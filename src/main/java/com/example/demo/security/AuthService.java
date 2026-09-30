package com.example.demo.security;

import com.example.demo.mapper.SysUserMapper;
import com.example.demo.model.OperationLog;
import com.example.demo.model.SysUser;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.regex.Pattern;

@Service
public class AuthService {

    /** session 里存登录用户 ID 的键 */
    public static final String SESSION_UID = "uid";
    /** 拦截器把当前用户放在 request 的这个属性里 */
    public static final String CURRENT_USER = "currentUser";

    /** 连续失败 5 次锁定 5 分钟(按用户名),防止暴力猜密码 */
    private static final int MAX_FAILS = 5;
    private static final long LOCK_MILLIS = 5 * 60 * 1000L;

    private static final Pattern HAS_LETTER = Pattern.compile("[A-Za-z]");
    private static final Pattern HAS_DIGIT = Pattern.compile("\\d");

    @Autowired
    public SysUserMapper userMapper;

    @Autowired
    public OpLogService opLog;

    private final Map<String, int[]> fails = new ConcurrentHashMap<>();
    private final Map<String, Long> lockedUntil = new ConcurrentHashMap<>();

    /** 返回给前端的当前用户信息:不含密码哈希 */
    public record Me(long userId, String username, String displayName, String role, String roleName,
                     boolean mustChangePassword, List<String> permissions, List<String> menus) {
        static Me of(SysUser u) {
            return new Me(u.getUserId(), u.getUsername(), u.getDisplayName(), u.getRole().name(), u.getRole().label(),
                    u.isMustChangePassword(), u.getRole().permissionCodes(), u.getRole().menus());
        }
    }

    public Me login(String username, String password, HttpServletRequest request) {
        String key = username == null ? "" : username.trim().toLowerCase();
        if (key.isEmpty() || password == null || password.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "请输入用户名和密码");
        }
        Long until = lockedUntil.get(key);
        if (until != null && until > System.currentTimeMillis()) {
            long min = Math.max(1, (until - System.currentTimeMillis() + 59_999) / 60_000);
            loginLog(request, userMapper.findByUsername(key), key, "登录失败", "账号已锁定(密码错误次数过多)");
            throw new ResponseStatusException(HttpStatus.TOO_MANY_REQUESTS, "密码错误次数过多,请 " + min + " 分钟后再试");
        }

        SysUser u = userMapper.findByUsername(key);
        // 用户不存在时 matches 也会算一次哈希,响应时间一致,不暴露用户名是否存在
        if (!PasswordHasher.matches(password, u == null ? null : u.getPasswordHash())) {
            int n = fails.computeIfAbsent(key, k -> new int[1])[0] += 1;
            if (n >= MAX_FAILS) {
                fails.remove(key);
                lockedUntil.put(key, System.currentTimeMillis() + LOCK_MILLIS);
                loginLog(request, u, key, "登录失败", "密码错误次数过多,账号锁定 5 分钟");
                throw new ResponseStatusException(HttpStatus.TOO_MANY_REQUESTS, "密码错误次数过多,账号已锁定 5 分钟");
            }
            loginLog(request, u, key, "登录失败", u == null ? "用户名不存在" : "密码错误");
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "用户名或密码错误");
        }
        if (!u.isEnabled()) {
            loginLog(request, u, key, "登录失败", "账号已停用");
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "该账号已停用,请联系管理员");
        }
        fails.remove(key);
        lockedUntil.remove(key);

        // 登录成功换一个新会话,防止会话固定攻击
        HttpSession old = request.getSession(false);
        if (old != null) {
            old.invalidate();
        }
        request.getSession(true).setAttribute(SESSION_UID, u.getUserId());
        userMapper.touchLogin(u.getUserId());
        loginLog(request, u, key, "登录", null);
        return Me.of(u);
    }

    /**
     * 登录页的「重置管理员密码」:把 admin 的密码重置为 123456(存哈希)并启用账号、解除锁定,
     * 下次登录必须先改密码。没有 admin 账号时新建一个。
     * 这是不需要登录就能调用的接口,等于公开后门,只适合本地开发;上线前把 app.security.admin-reset-enabled 设为 false。
     */
    public static final String ADMIN_RESET_PASSWORD = "123456";

    @Value("${app.security.admin-reset-enabled:true}")
    public boolean adminResetEnabled;

    /** 其他 Bean 通过方法读(若本类以后被代理,直接读字段会拿不到值) */
    public boolean adminResetEnabled() {
        return adminResetEnabled;
    }

    public void resetAdmin(HttpServletRequest request) {
        if (!adminResetEnabled) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "该功能未开启");
        }
        loginLog(request, null, "admin", "重置管理员密码", null); // 登录页公开入口,记下来源 IP
        SysUser u = userMapper.findByUsername("admin");
        if (u == null) {
            u = new SysUser();
            u.setUsername("admin");
            u.setDisplayName("系统管理员");
            u.setRole(Role.ADMIN);
            u.setEnabled(true);
            u.setMustChangePassword(true);
            u.setPasswordHash(PasswordHasher.hash(ADMIN_RESET_PASSWORD));
            userMapper.insert(u);
        } else {
            userMapper.updatePassword(u.getUserId(), PasswordHasher.hash(ADMIN_RESET_PASSWORD), true);
            if (!u.isEnabled()) {
                u.setEnabled(true);
                userMapper.update(u);
            }
        }
        fails.remove("admin");
        lockedUntil.remove("admin");
    }

    /** 登录类日志;失败时 username 记尝试的用户名(用户可能不存在),error 记内部原因(只有管理员能看日志) */
    private void loginLog(HttpServletRequest request, SysUser u, String username, String action, String error) {
        OperationLog l = opLog.from(request, u, OperationLog.Category.LOGIN, action);
        if (u == null) {
            l.setUsername(username);
        }
        l.setSuccess(error == null);
        l.setStatus(error == null ? 200 : null);
        l.setError(error);
        opLog.save(l);
    }

    public void logout(HttpServletRequest request) {
        HttpSession s = request.getSession(false);
        if (s != null) {
            s.invalidate();
        }
    }

    public Me me(SysUser current) {
        return Me.of(current);
    }

    /** 修改自己的密码:要验证旧密码 */
    public Me changePassword(SysUser current, String oldPassword, String newPassword) {
        if (!PasswordHasher.matches(oldPassword, current.getPasswordHash())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "原密码不正确");
        }
        checkPolicy(newPassword);
        if (PasswordHasher.matches(newPassword, current.getPasswordHash())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "新密码不能与原密码相同");
        }
        userMapper.updatePassword(current.getUserId(), PasswordHasher.hash(newPassword), false);
        return Me.of(userMapper.findById(current.getUserId()));
    }

    /** 密码规则:8~64 位,至少包含字母和数字 */
    public static void checkPolicy(String pw) {
        if (pw == null || pw.length() < 8 || pw.length() > 64
                || !HAS_LETTER.matcher(pw).find() || !HAS_DIGIT.matcher(pw).find()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "密码需为 8~64 位,且同时包含字母和数字");
        }
    }
}
