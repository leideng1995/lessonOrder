package com.example.demo.model;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class RechargeRecord {
    private long recordId;

    private long studentId;

    /** 充值金额(元) */
    private BigDecimal amount;

    /** 充值后余额(元) */
    private BigDecimal balanceAfter;

    /** 本次充值赠送的积分 */
    private int bonusPoints;

    private LocalDateTime createdAt;
}
