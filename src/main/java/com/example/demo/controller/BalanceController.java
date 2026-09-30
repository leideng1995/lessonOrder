package com.example.demo.controller;

import com.example.demo.model.BalanceRecord;
import com.example.demo.service.BalanceService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/** 余额流水只读;余额由充值、开户、支付、退课产生变动 */
@RestController
@RequestMapping("/api/balance")
@RequiredArgsConstructor
public class BalanceController {

    private final BalanceService balanceService;

    /** GET /api/balance?studentId=1,studentId 可选 */
    @GetMapping
    public List<BalanceRecord> list(@RequestParam(required = false) Long studentId) {
        return balanceService.records(studentId);
    }
}
