package com.example.demo.controller;

import com.example.demo.model.SysUser;
import com.example.demo.security.AuthService;
import com.example.demo.security.Role;
import com.example.demo.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

/** 系统用户管理,只有管理员能访问(AuthInterceptor 按 user:admin 权限拦截) */
@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    public record CreateUserRequest(String username, String displayName, Role role, String password) {
    }

    public record UpdateUserRequest(String displayName, Role role, boolean enabled) {
    }

    public record ResetPasswordRequest(String password) {
    }

    @GetMapping
    public List<SysUser> list() {
        return userService.list();
    }

    /** 角色列表:[{ code, name, menus }],供前端下拉框和说明使用 */
    @GetMapping("/roles")
    public List<Map<String, Object>> roles() {
        return Arrays.stream(Role.values())
                .map(r -> Map.<String, Object>of("code", r.name(), "name", r.label(), "menus", r.menus()))
                .toList();
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public SysUser create(@RequestBody CreateUserRequest req) {
        return userService.create(req.username(), req.displayName(), req.role(), req.password());
    }

    @PutMapping("/{id}")
    public SysUser update(@RequestAttribute(AuthService.CURRENT_USER) SysUser current,
                          @PathVariable long id, @RequestBody UpdateUserRequest req) {
        return userService.update(current, id, req.displayName(), req.role(), req.enabled());
    }

    @PutMapping("/{id}/password")
    public SysUser resetPassword(@PathVariable long id, @RequestBody ResetPasswordRequest req) {
        return userService.resetPassword(id, req.password());
    }
}
