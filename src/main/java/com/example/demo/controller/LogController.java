package com.example.demo.controller;

import com.example.demo.model.OperationLog;
import com.example.demo.security.OpLogService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/** 操作日志只读,仅管理员(AuthInterceptor 按 log:read 权限拦截) */
@RestController
@RequestMapping("/api/logs")
@RequiredArgsConstructor
public class LogController {

    private final OpLogService opLog;

    /** GET /api/logs?category=LOGIN&limit=2000,都可选;默认最近 2000 条 */
    @GetMapping
    public List<OperationLog> list(@RequestParam(required = false) OperationLog.Category category,
                                   @RequestParam(defaultValue = "2000") int limit) {
        return opLog.recent(category, limit);
    }
}
