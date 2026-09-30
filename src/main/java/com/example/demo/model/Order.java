package com.example.demo.model;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

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

    private BigDecimal refundedBalance;

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

    public enum OrderStatus {
        PENDING, CONFIRMED, CANCELLED
    }

    public enum PaymentStatus {
        UNPAID, PAID, REFUNDED
    }
}
