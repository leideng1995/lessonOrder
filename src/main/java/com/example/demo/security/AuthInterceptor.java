package com.example.demo.security;

import com.example.demo.mapper.SysUserMapper;
import com.example.demo.model.OperationLog;
import com.example.demo.model.SysUser;
import com.example.demo.security.Role.Perm;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.util.ContentCachingRequestWrapper;
import org.springframework.web.util.WebUtils;

import java.nio.charset.StandardCharsets;

/**
 * 所有 /api 请求的登录和权限检查。页面本身是静态文件,不含数据;数据都经过这里。
 * 每次请求都从数据库重新读用户,停用账号或修改角色后立即生效。
 * 规则按"路径前缀 + 读/写"对应到权限,没有列出的 /api 路径一律拒绝。
 */
@Component
public class AuthInterceptor implements HandlerInterceptor {

    private static final Logger log = LoggerFactory.getLogger(AuthInterceptor.class);

    @Autowired
    public SysUserMapper userMapper;

    @Autowired
    public OpLogService opLog;

    private static final String START_ATTR = "opLogStart";

    @Override
    public boolean preHandle(HttpServletRequest req, HttpServletResponse res, Object handler) {
        String path = req.getRequestURI().substring(req.getContextPath().length());
        String method = req.getMethod();
        req.setAttribute(START_ATTR, System.currentTimeMillis());
        // 不需要登录的接口:登录、登录页选项、重置管理员密码(后者可用配置关闭)
        if ("OPTIONS".equals(method)
                || ("POST".equals(method) && (path.equals("/api/auth/login") || path.equals("/api/auth/reset-admin")))
                || ("GET".equals(method) && path.equals("/api/auth/options"))) {
            return true;
        }

        HttpSession session = req.getSession(false);
        Object uid = session == null ? null : session.getAttribute(AuthService.SESSION_UID);
        SysUser user = uid instanceof Long id ? userMapper.findById(id) : null;
        if (user == null || !user.isEnabled()) {
            if (session != null) {
                session.invalidate();
            }
            if (user != null) {
                // 账号在登录期间被管理员停用:会话作废,强制下线
                log.info("账号 {} 已停用,会话作废", user.getUsername());
            }
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, user == null ? "请先登录" : "该账号已停用");
        }
        req.setAttribute(AuthService.CURRENT_USER, user);
        MDC.put(RequestLogFilter.MDC_USER, user.getUsername()); // 本请求之后的日志都带上用户名

        if (path.startsWith("/api/auth/")) {
            return true; // 查看自己、改密码、退出:登录即可
        }
        if (user.isMustChangePassword()) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "请先修改初始密码");
        }
        Perm need = required(method, path);
        if (need == null || !user.getRole().has(need)) {
            // 已登录用户越权访问:记一条(拒绝时不会走到 afterCompletion)
            OperationLog l = opLog.from(req, user, OperationLog.Category.DENIED,
                    "GET".equals(method) ? "越权查看" : "越权" + OpLogService.actionOf(method, path));
            l.setDetail(OpLogService.mask(bodyOf(req)));
            l.setSuccess(false);
            l.setStatus(403);
            l.setError(need == null ? "未开放的接口" : "角色「" + user.getRole().label() + "」没有「" + need.code() + "」权限");
            opLog.save(l);
            log.warn("越权访问 {} {}:{}", method, path, l.getError());
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "没有权限执行此操作");
        }
        return true;
    }

    /**
     * 写操作(非 GET)结束后记操作日志:谁、什么操作、请求内容(密码打码)、成功与否、失败原因、耗时。
     * 登录和登录页重置管理员密码由 AuthService 自己记(那时还没有登录用户)。
     */
    @Override
    public void afterCompletion(HttpServletRequest req, HttpServletResponse res, Object handler, Exception ex) {
        String method = req.getMethod();
        String path = req.getRequestURI().substring(req.getContextPath().length());
        if ("GET".equals(method) || "OPTIONS".equals(method)
                || path.equals("/api/auth/login") || path.equals("/api/auth/reset-admin")) {
            return;
        }
        SysUser user = (SysUser) req.getAttribute(AuthService.CURRENT_USER);
        OperationLog l = opLog.from(req, user, OpLogService.categoryOf(path), OpLogService.actionOf(method, path));
        l.setDetail(OpLogService.mask(bodyOf(req)));
        int status = res.getStatus();
        Object err = req.getAttribute(ErrorCaptureResolver.ERROR_ATTR);
        l.setStatus(status);
        l.setSuccess(status < 400 && err == null && ex == null);
        if (!l.isSuccess()) {
            l.setError(err != null ? err.toString() : ex != null ? ex.getMessage() : "HTTP " + status);
        }
        Object start = req.getAttribute(START_ATTR);
        if (start instanceof Long t) {
            l.setDurationMs((int) (System.currentTimeMillis() - t));
        }
        opLog.save(l);
    }

    /** 读缓存下来的请求体(RequestBodyCachingFilter),没有则为 null */
    static String bodyOf(HttpServletRequest req) {
        ContentCachingRequestWrapper w = WebUtils.getNativeRequest(req, ContentCachingRequestWrapper.class);
        if (w == null) {
            return null;
        }
        byte[] b = w.getContentAsByteArray();
        return b.length == 0 ? null : new String(b, StandardCharsets.UTF_8);
    }

    /** 路径 → 需要的权限;GET 为读,其他方法为写 */
    static Perm required(String method, String path) {
        boolean read = "GET".equals(method);
        if (under(path, "/api/logs")) {
            return read ? Perm.LOG_READ : null;
        }
        if (under(path, "/api/users")) {
            return Perm.USER_ADMIN;
        }
        if (under(path, "/api/students")) {
            return read ? Perm.STUDENT_READ : Perm.STUDENT_WRITE;
        }
        if (under(path, "/api/lessons")) {
            return read ? Perm.LESSON_READ : Perm.LESSON_WRITE;
        }
        if (under(path, "/api/orders")) {
            return read ? Perm.ORDER_READ : Perm.ORDER_WRITE;
        }
        if (under(path, "/api/points")) {
            // 积分规则(换算比例)支付时要用,有订单权限即可查看;积分流水需要积分权限
            return !read ? null : path.equals("/api/points/rule") ? Perm.ORDER_READ : Perm.POINTS_READ;
        }
        if (under(path, "/api/balance")) {
            return read ? Perm.BALANCE_READ : null;
        }
        if (under(path, "/api/recharges")) {
            return read ? Perm.RECHARGE_READ : null;
        }
        return null;
    }

    private static boolean under(String path, String prefix) {
        return path.equals(prefix) || path.startsWith(prefix + "/");
    }
}
