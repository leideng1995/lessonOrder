package com.example.demo.model;

import lombok.Data;

import java.time.LocalDateTime;

/** 操作日志 */
@Data
public class OperationLog {
    private long logId;

    private Category category;

    /** 操作名称,如 学生充值、登录失败 */
    private String action;

    private Long userId;

    private String username;

    private String displayName;

    private String role;

    private String method;

    private String path;

    /** 请求内容摘要(密码已打码) */
    private String detail;

    private boolean success;

    private Integer status;

    private String error;

    private String ip;

    private String userAgent;

    private Integer durationMs;

    private LocalDateTime createdAt;

    public enum Category {
        /** 登录、退出、改密码 */
        LOGIN,
        /** 写操作 */
        OPERATION,
        /** 越权被拒 */
        DENIED,
        /** 系统自动操作(定时任务) */
        SYSTEM
    }
}
