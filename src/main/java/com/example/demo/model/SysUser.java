package com.example.demo.model;

import com.example.demo.security.Role;
import lombok.Data;

import java.time.LocalDateTime;

/** 系统用户(后台登录账号) */
@Data
public class SysUser {
    private long userId;

    private String username;

    /** 密码哈希,返回给前端前会清空 */
    private String passwordHash;

    private String displayName;

    private Role role;

    private boolean enabled;

    /** 为 true 时登录后必须先修改密码才能使用其他功能(新建账号、管理员重置密码后) */
    private boolean mustChangePassword;

    private LocalDateTime createdAt;

    private LocalDateTime lastLoginAt;
}
