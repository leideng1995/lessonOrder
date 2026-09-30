package com.example.demo.security;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.concurrent.ThreadLocalRandom;

/**
 * /api 请求的访问日志和日志上下文。
 * <ul>
 *   <li>每个请求生成一个 8 位请求号,放进 MDC(reqId),这个请求里打出的所有日志都带上它;
 *       同时写到响应头 X-Request-Id,用户反馈问题时按请求号就能在日志里找到整个过程。</li>
 *   <li>当前用户名由 AuthInterceptor 识别出用户后放进 MDC(user)。</li>
 *   <li>请求结束打一行汇总:方法、路径、状态码、耗时,失败时带上失败原因。</li>
 * </ul>
 * 日志级别:写操作 INFO;查询 DEBUG(默认不输出);4xx 为 WARN(未登录的 401 除外);5xx 为 ERROR;超过 2 秒为 WARN。
 * 排在所有过滤器最前面,保证后面的过滤器、拦截器、业务代码打的日志都有请求号。
 */
@Component
@Order(Ordered.HIGHEST_PRECEDENCE)
public class RequestLogFilter extends OncePerRequestFilter {

    private static final Logger log = LoggerFactory.getLogger(RequestLogFilter.class);

    /** MDC 键:请求号、当前用户名(logback-spring.xml 的输出格式里引用) */
    public static final String MDC_REQ_ID = "reqId";
    public static final String MDC_USER = "user";

    /** 超过这个耗时(毫秒)的请求记为慢请求 */
    private static final long SLOW_MS = 2000;

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        return !request.getRequestURI().startsWith("/api/"); // 静态页面、图片等不记
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws ServletException, IOException {
        String reqId = String.format("%08x", ThreadLocalRandom.current().nextInt());
        MDC.put(MDC_REQ_ID, reqId);
        response.setHeader("X-Request-Id", reqId);
        long start = System.currentTimeMillis();
        Throwable failure = null;
        try {
            chain.doFilter(request, response);
        } catch (IOException | ServletException | RuntimeException e) {
            failure = e; // 没被 Spring 处理的异常,交给容器返回 500,这里只记录
            throw e;
        } finally {
            logRequest(request, response, System.currentTimeMillis() - start, failure);
            MDC.clear(); // 线程会被复用,必须清掉
        }
    }

    private void logRequest(HttpServletRequest req, HttpServletResponse res, long ms, Throwable failure) {
        String method = req.getMethod();
        String query = req.getQueryString();
        String target = method + " " + req.getRequestURI() + (query == null ? "" : "?" + query);
        int status = failure != null ? 500 : res.getStatus();
        Object reason = failure != null ? failure.toString() : req.getAttribute(ErrorCaptureResolver.ERROR_ATTR);
        String msg = "{} -> {} ({} ms){}";
        Object[] args = {target, status, ms, reason == null ? "" : " 原因: " + reason};

        boolean read = "GET".equals(method) || "OPTIONS".equals(method);
        if (status >= 500) {
            log.error(msg, args);
        } else if (status >= 400 && status != 401) {
            log.warn(msg, args);
        } else if (ms >= SLOW_MS && !hashesPassword(req)) {
            log.warn("慢请求 " + msg, args);
        } else if (!read) {
            log.info(msg, args);
        } else {
            log.debug(msg, args); // 查询请求量大,默认不输出;排查问题时把本类日志级别调到 debug
        }
    }

    /**
     * 要计算密码哈希的接口:PBKDF2 故意算得慢(约 1 秒),不算慢请求。
     * 登录、改密码、重置管理员密码;新增系统用户、重置用户密码;新增学生、修改学生(可能改密码)。
     */
    private static boolean hashesPassword(HttpServletRequest req) {
        String m = req.getMethod(), path = req.getRequestURI();
        return path.startsWith("/api/auth/")
                || ("POST".equals(m) && (path.equals("/api/users") || path.equals("/api/students")))
                || ("PUT".equals(m) && (path.matches("/api/users/\\d+/password") || path.matches("/api/students/\\d+")));
    }
}
