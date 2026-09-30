package com.example.demo.security;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.TypeMismatchException;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.web.ErrorResponse;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.HandlerExceptionResolver;
import org.springframework.web.servlet.ModelAndView;

/**
 * 排在最前面的异常解析器:只把失败原因记到 request 属性里给操作日志和访问日志用,然后返回 null,
 * 交给 Spring 原来的解析器照常处理(返回给前端的错误格式不变)。
 * <p>
 * 业务校验失败(ResponseStatusException,如"余额不足")和 Spring 能识别的请求错误(如 JSON 格式不对)
 * 属于预期内的失败,由 RequestLogFilter 打一行原因即可;其他异常是程序或环境问题,在这里打出完整堆栈。
 */
public class ErrorCaptureResolver implements HandlerExceptionResolver {

    private static final Logger log = LoggerFactory.getLogger(ErrorCaptureResolver.class);

    public static final String ERROR_ATTR = "opLogError";

    @Override
    public ModelAndView resolveException(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) {
        String msg = ex instanceof ResponseStatusException rse && rse.getReason() != null ? rse.getReason() : ex.getMessage();
        request.setAttribute(ERROR_ATTR, msg == null ? ex.getClass().getSimpleName() : msg);
        if (!expected(ex)) {
            log.error("处理请求 {} {} 时发生未预期的异常", request.getMethod(), request.getRequestURI(), ex);
        }
        return null;
    }

    /** 预期内的失败:都会返回 4xx,不需要堆栈。ErrorResponse 包括 ResponseStatusException 和 Spring 的大部分请求错误 */
    private static boolean expected(Exception ex) {
        return ex instanceof ErrorResponse
                || ex instanceof HttpMessageNotReadableException   // 请求体不是合法 JSON 或字段类型不对
                || ex instanceof TypeMismatchException;            // 路径或参数类型不对,如 /api/orders/abc
    }
}
