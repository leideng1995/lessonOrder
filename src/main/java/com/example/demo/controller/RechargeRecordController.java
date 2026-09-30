package com.example.demo.controller;

import com.example.demo.model.RechargeRecord;
import com.example.demo.service.StudentService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/** 充值记录只读;记录由 POST /api/students/{id}/recharge 产生 */
@RestController
@RequestMapping("/api/recharges")
@RequiredArgsConstructor
public class RechargeRecordController {

    private final StudentService studentService;

    /** GET /api/recharges?studentId=1,studentId 可选 */
    @GetMapping
    public List<RechargeRecord> list(@RequestParam(required = false) Long studentId) {
        return studentService.recharges(studentId);
    }
}
