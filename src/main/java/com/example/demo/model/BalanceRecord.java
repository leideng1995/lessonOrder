package com.example.demo.model;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/** 余额流水:每次余额变动一条 */
@Data
public class BalanceRecord {
    private long recordId;

    private long studentId;

    private Long orderId;

    /** 变动金额,正数增加、负数减少 */
    private BigDecimal changeAmount;

    /** 变动后余额 */
    private BigDecimal balanceAfter;

    private Type type;

    private String remark;

    private LocalDateTime createdAt;

    public enum Type {
        /** 启用余额流水时的期初余额(历史数据迁移) */
        OPENING,
        /** 新建学生时的初始余额 */
        INITIAL,
        /** 充值 */
        RECHARGE,
        /** 支付订单扣款 */
        PAY,
        /** 退课退款 */
        REFUND
    }
}
