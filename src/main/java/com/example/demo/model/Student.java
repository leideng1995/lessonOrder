package com.example.demo.model;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/** 学生:基本资料、余额和积分 */
@Data
public class Student {
    private long studentId;

    private String firstName;

    private String lastName;

    private String email;

    /** 密码:入库前转成哈希,查询返回前清空;修改时留空表示不改 */
    private String password;

    private String phone;

    private LocalDate dateOfBirth;

    /** 账户余额(元),只能通过充值和支付变动,编辑学生时不会修改 */
    private BigDecimal balance;

    /** 积分余额,100 积分 = 1 元;只能通过支付获得、抵扣、退课变动 */
    private int points;

    /** 注册时间,数据库自动填 */
    private LocalDateTime registrationDate;
}
