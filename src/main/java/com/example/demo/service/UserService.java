package com.example.demo.service;

import com.example.demo.mapper.SysUserMapper;
import com.example.demo.model.SysUser;
import com.example.demo.security.AuthService;
import com.example.demo.security.PasswordHasher;
import com.example.demo.security.Role;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.regex.Pattern;

/** 系统用户管理(仅管理员) */
@Service
public class UserService {

    private static final Pattern USERNAME = Pattern.compile("[a-z0-9_.-]{3,32}");

    @Autowired
    public SysUserMapper userMapper;

    public List<SysUser> list() {
        List<SysUser> list = userMapper.findAll();
        list.forEach(u -> u.setPasswordHash(null));
        return list;
    }

    public SysUser get(long id) {
        SysUser u = userMapper.findById(id);
        if (u == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "用户不存在: " + id);
        }
        u.setPasswordHash(null);
        return u;
    }

    /** 新建用户:管理员设置初始密码,用户首次登录必须修改 */
    public SysUser create(String username, String displayName, Role role, String password) {
        String name = username == null ? "" : username.trim().toLowerCase();
        if (!USERNAME.matcher(name).matches()) {
            throw bad("用户名为 3~32 位小写字母、数字或 _ . -");
        }
        checkDisplayName(displayName);
        if (role == null) {
            throw bad("请选择角色");
        }
        AuthService.checkPolicy(password);
        SysUser u = new SysUser();
        u.setUsername(name);
        u.setDisplayName(displayName.trim());
        u.setRole(role);
        u.setEnabled(true);
        u.setMustChangePassword(true);
        u.setPasswordHash(PasswordHasher.hash(password));
        try {
            userMapper.insert(u);
        } catch (DuplicateKeyException e) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "用户名已存在: " + name);
        }
        return get(u.getUserId());
    }

    /**
     * 修改姓名、角色、启用状态。不能停用自己或改自己的角色(防止把自己锁在外面),
     * 并且系统里至少要保留一个启用的管理员。
     */
    @Transactional
    public SysUser update(SysUser current, long id, String displayName, Role role, boolean enabled) {
        SysUser u = userMapper.findById(id);
        if (u == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "用户不存在: " + id);
        }
        checkDisplayName(displayName);
        if (role == null) {
            throw bad("请选择角色");
        }
        if (u.getUserId() == current.getUserId() && (role != u.getRole() || !enabled)) {
            throw bad("不能修改自己的角色或停用自己");
        }
        boolean wasActiveAdmin = u.getRole() == Role.ADMIN && u.isEnabled();
        boolean staysActiveAdmin = role == Role.ADMIN && enabled;
        if (wasActiveAdmin && !staysActiveAdmin && userMapper.countEnabledByRole(Role.ADMIN) <= 1) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "至少要保留一个启用的管理员");
        }
        u.setDisplayName(displayName.trim());
        u.setRole(role);
        u.setEnabled(enabled);
        userMapper.update(u);
        return get(id);
    }

    /** 管理员重置密码:设置新的临时密码,用户下次登录必须修改 */
    public SysUser resetPassword(long id, String password) {
        get(id);
        AuthService.checkPolicy(password);
        userMapper.updatePassword(id, PasswordHasher.hash(password), true);
        return get(id);
    }

    private static void checkDisplayName(String displayName) {
        if (displayName == null || displayName.isBlank() || displayName.trim().length() > 50) {
            throw bad("请填写姓名(不超过 50 字)");
        }
    }

    private static ResponseStatusException bad(String msg) {
        return new ResponseStatusException(HttpStatus.BAD_REQUEST, msg);
    }
}
