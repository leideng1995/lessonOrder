package com.example.demo.security;

import com.example.demo.mapper.OperationLogMapper;
import com.example.demo.model.OperationLog;
import com.example.demo.model.OperationLog.Category;
import com.example.demo.model.SysUser;
import jakarta.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.regex.Pattern;

/**
 * 写操作日志。日志独立于业务事务写入(自动提交):业务失败回滚了,日志照样留下。
 * 写日志本身出错只打印警告,不影响业务请求。
 */
@Service
public class OpLogService {

    private static final Logger log = LoggerFactory.getLogger(OpLogService.class);

    /** 请求内容里的密码字段打码 */
    private static final Pattern PASSWORD = Pattern.compile("(\"[A-Za-z]*[Pp]assword\"\\s*:\\s*)\"(?:[^\"\\\\]|\\\\.)*\"");

    /** 路径 → 操作名称;{n} 表示数字 ID。按顺序匹配,先写更具体的 */
    private static final List<Object[]> ACTIONS = List.of(
            new Object[]{"POST", "/api/students/{n}/recharge", "学生充值"},
            new Object[]{"POST", "/api/students", "新增学生"},
            new Object[]{"PUT", "/api/students/{n}", "修改学生"},
            new Object[]{"DELETE", "/api/students/{n}", "删除学生"},
            new Object[]{"PUT", "/api/lessons/{n}/sessions/{n}/cancel", "停课"},
            new Object[]{"POST", "/api/lessons", "新增课程"},
            new Object[]{"PUT", "/api/lessons/{n}", "修改课程"},
            new Object[]{"DELETE", "/api/lessons/{n}", "删除课程"},
            new Object[]{"PUT", "/api/orders/{n}/items/{n}/cancel", "退课"},
            new Object[]{"PUT", "/api/orders/{n}/pay", "支付订单"},
            new Object[]{"PUT", "/api/orders/{n}/cancel", "取消订单"},
            new Object[]{"POST", "/api/orders", "下单"},
            new Object[]{"DELETE", "/api/orders/{n}", "删除订单"},
            new Object[]{"PUT", "/api/users/{n}/password", "重置用户密码"},
            new Object[]{"POST", "/api/users", "新增系统用户"},
            new Object[]{"PUT", "/api/users/{n}", "修改系统用户"},
            new Object[]{"PUT", "/api/auth/password", "修改密码"},
            new Object[]{"POST", "/api/auth/logout", "退出登录"});

    @Autowired
    public OperationLogMapper mapper;

    public static String actionOf(String method, String path) {
        for (Object[] a : ACTIONS) {
            if (a[0].equals(method) && path.matches(((String) a[1]).replace("{n}", "\\d+"))) {
                return (String) a[2];
            }
        }
        return method + " " + path;
    }

    /** 退出登录、改密码归到"登录"类,其余写操作归到"操作"类 */
    public static Category categoryOf(String path) {
        return path.startsWith("/api/auth/") ? Category.LOGIN : Category.OPERATION;
    }

    public static String mask(String body) {
        if (body == null || body.isBlank()) {
            return null;
        }
        String s = PASSWORD.matcher(body).replaceAll("$1\"***\"");
        return s.length() > 1000 ? s.substring(0, 997) + "..." : s;
    }

    /** 客户端 IP。没有经过反向代理时就是连接的来源地址;部署在代理后面时需要改为读取可信代理传来的头 */
    public static String ipOf(HttpServletRequest req) {
        String ip = req.getRemoteAddr();
        return "0:0:0:0:0:0:0:1".equals(ip) ? "::1" : ip; // IPv6 本机地址写成短格式
    }

    /** 按请求和用户组装一条日志(调用方再补充 action、结果等) */
    public OperationLog from(HttpServletRequest req, SysUser user, Category category, String action) {
        OperationLog l = new OperationLog();
        l.setCategory(category);
        l.setAction(action);
        if (user != null) {
            l.setUserId(user.getUserId());
            l.setUsername(user.getUsername());
            l.setDisplayName(user.getDisplayName());
            l.setRole(user.getRole().label());
        }
        if (req != null) {
            l.setMethod(req.getMethod());
            l.setPath(req.getRequestURI());
            l.setIp(ipOf(req));
            String ua = req.getHeader("User-Agent");
            l.setUserAgent(ua == null ? null : ua.length() > 255 ? ua.substring(0, 255) : ua);
        }
        return l;
    }

    public void save(OperationLog l) {
        try {
            if (l.getError() != null && l.getError().length() > 500) {
                l.setError(l.getError().substring(0, 497) + "...");
            }
            mapper.insert(l);
        } catch (RuntimeException e) {
            log.warn("写操作日志失败: {} {}", l.getAction(), e.getMessage());
        }
    }

    /** 系统自动操作(定时任务) */
    public void system(String action, String detail) {
        OperationLog l = new OperationLog();
        l.setCategory(Category.SYSTEM);
        l.setAction(action);
        l.setUsername("system");
        l.setDisplayName("系统");
        l.setDetail(detail);
        l.setSuccess(true);
        save(l);
    }

    public List<OperationLog> recent(Category category, int limit) {
        return mapper.findRecent(category, Math.max(1, Math.min(limit, 5000)));
    }
}
