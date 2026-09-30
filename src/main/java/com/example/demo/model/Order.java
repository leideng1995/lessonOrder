package com.example.demo.model;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

/** 订单:一个学生报一门课的若干节;金额、支付构成和退款构成都记在订单上,便于对账 */
@Data
public class Order {
    private long orderId;
    private long studentId;
    private long lessonId;

    /** 订单金额 = 有效课次单价之和;未支付时退课会同步减少,已支付后保持不变 */
    private BigDecimal totalAmount;

    /** 已退款金额(余额 + 积分折算),已支付订单退课时累加 */
    private BigDecimal refundedAmount;

    /* ---------- 支付构成:totalAmount = paidBalance + paidPoints / 100 ---------- */

    /** 余额支付的金额 */
    private BigDecimal paidBalance;

    /** 积分支付的数量(100 积分 = 1 元) */
    private int paidPoints;

    /** 本单获得的积分(余额实付 × 2) */
    private int earnedPoints;

    /* ---------- 退款构成:refundedAmount = refundedBalance + refundedPoints / 100 ---------- */

    /** 已退回的余额 */
    private BigDecimal refundedBalance;

    /** 已退回的积分 */
    private int refundedPoints;

    /** 因退课应扣回的已得积分(学生积分不够时实际扣的会少一些,见积分流水) */
    private int clawedPoints;

    /** 下单时间 */
    private LocalDateTime createdAt;

    /** 取消原因(如超时未支付),手动取消或退课时为空 */
    private String cancelReason;

    /** 支付截止时间:只有待支付订单有,= 下单时间 + 支付时限,超时自动取消 */
    private LocalDateTime payDeadline;

    private OrderStatus status;

    private PaymentStatus paymentStatus;

    /** 查询时统计:课次总数、有效课次数 */
    private int itemCount;

    private int activeItemCount;

    /** 订单明细,只在查询单个订单时返回 */
    private List<OrderItem> items;

    /** 订单状态:待支付(PENDING)→ 已确认(CONFIRMED,已支付);任何时候全部课次取消后 → 已取消(CANCELLED) */
    public enum OrderStatus {
        PENDING, CONFIRMED, CANCELLED
    }

    /** 支付状态:未支付 → 已支付 → 已退款(已支付订单的课次全部退掉后) */
    public enum PaymentStatus {
        UNPAID, PAID, REFUNDED
    }
}
