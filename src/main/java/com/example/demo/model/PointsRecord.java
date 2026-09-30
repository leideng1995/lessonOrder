package com.example.demo.model;

import lombok.Data;

import java.time.LocalDateTime;

/** 积分流水:每次积分变动一条 */
@Data
public class PointsRecord {
    private long recordId;

    private long studentId;

    private Long orderId;

    /** 变动数量,正数增加、负数减少 */
    private int changePoints;

    /** 变动后的积分余额 */
    private int balanceAfter;

    private Type type;

    private String remark;

    private LocalDateTime createdAt;

    public enum Type {
        /** 支付获得 */
        EARN,
        /** 支付时抵扣 */
        REDEEM,
        /** 退课退回抵扣的积分 */
        REFUND,
        /** 退课扣回当初获得的积分 */
        CLAWBACK,
        /** 充值赠送 */
        RECHARGE
    }
}
