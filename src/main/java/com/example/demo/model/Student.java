package com.example.demo.model;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class Student {
    private long studentId;

    private String firstName;

    private String lastName;

    private String email;

    private String password;

    private String phone;

    private LocalDate dateOfBirth;

    /** 账户余额(元),只能通过充值和支付变动,编辑学生时不会修改 */
    private BigDecimal balance;

    /** 积分余额,100 积分 = 1 元;只能通过支付获得、抵扣、退课变动 */
    private int points;

    private LocalDateTime registrationDate;
}
