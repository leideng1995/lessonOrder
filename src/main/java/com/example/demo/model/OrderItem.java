package com.example.demo.model;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/** 订单明细:订单里的一节课 */
@Data
public class OrderItem {
    private long itemId;

    private long orderId;

    private long sessionId;

    private long studentId;

    /** 下单时的单节价格 */
    private BigDecimal price;

    private ItemStatus status;

    /* 查询时关联课次带出 */
    private long lessonId;

    private LocalDateTime startAt;

    private LocalDateTime endAt;

    private LessonSession.SessionStatus sessionStatus;

    /* 只在学生课表查询时带出 */
    private String lessonTitle;

    private Order.OrderStatus orderStatus;

    private Order.PaymentStatus paymentStatus;

    public enum ItemStatus {
        ACTIVE, CANCELLED
    }
}
