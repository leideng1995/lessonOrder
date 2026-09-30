package com.example.demo.security;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.HandlerExceptionResolver;
import org.springframework.web.servlet.ModelAndView;

/**
 * 排在最前面的异常解析器:只把失败原因记到 request 属性里给操作日志用,然后返回 null,
 * 交给 Spring 原来的解析器照常处理(返回给前端的错误格式不变)。
 */
public class ErrorCaptureResolver implements HandlerExceptionResolver {

    public static final String ERROR_ATTR = "opLogError";

    @Override
    public ModelAndView resolveException(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) {
        String msg = ex instanceof ResponseStatusException rse && rse.getReason() != null ? rse.getReason() : ex.getMessage();
        request.setAttribute(ERROR_ATTR, msg == null ? ex.getClass().getSimpleName() : msg);
        return null;
    }
}
