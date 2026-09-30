package com.example.demo.controller;

import com.example.demo.model.SysUser;
import com.example.demo.security.AuthService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 登录相关接口。login、options、reset-admin 不需要登录,其余只要登录即可(AuthInterceptor 放行 /api/auth/**)。
 */
@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    public record LoginRequest(String username, String password) {
    }

    public record ChangePasswordRequest(String oldPassword, String newPassword) {
    }

    /** 登录成功后服务端建立会话(Cookie),返回当前用户、权限和可见菜单 */
    @PostMapping("/login")
    public AuthService.Me login(@RequestBody LoginRequest req, HttpServletRequest request) {
        return authService.login(req.username(), req.password(), request);
    }

    /** 登录页用:是否显示「重置管理员密码」(不需要登录) */
    @GetMapping("/options")
    public Map<String, Object> options() {
        return Map.of("adminResetEnabled", authService.adminResetEnabled());
    }

    /** 把 admin 的密码重置为 123456,下次登录必须修改(不需要登录,仅用于本地开发) */
    @PostMapping("/reset-admin")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void resetAdmin(HttpServletRequest request) {
        authService.resetAdmin(request);
    }

    /** 退出登录,作废会话 */
    @PostMapping("/logout")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void logout(HttpServletRequest request) {
        authService.logout(request);
    }

    /** 当前登录用户、权限和菜单;前端每个页面加载时调用,401 时跳到登录页 */
    @GetMapping("/me")
    public AuthService.Me me(@RequestAttribute(AuthService.CURRENT_USER) SysUser current) {
        return authService.me(current);
    }

    /** 修改自己的密码,需要原密码;首次登录修改初始密码也走这里 */
    @PutMapping("/password")
    public AuthService.Me changePassword(@RequestAttribute(AuthService.CURRENT_USER) SysUser current,
                                         @RequestBody ChangePasswordRequest req) {
        return authService.changePassword(current, req.oldPassword(), req.newPassword());
    }
}
