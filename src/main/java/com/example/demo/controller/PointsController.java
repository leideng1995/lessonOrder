package com.example.demo.controller;

import com.example.demo.model.PointsRecord;
import com.example.demo.service.PointsService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/** 积分流水只读;积分由支付、退课、充值产生变动 */
@RestController
@RequestMapping("/api/points")
@RequiredArgsConstructor
public class PointsController {

    private final PointsService pointsService;

    /** GET /api/points?studentId=1,studentId 可选 */
    @GetMapping
    public List<PointsRecord> list(@RequestParam(required = false) Long studentId) {
        return pointsService.records(studentId);
    }

    /** 积分规则,供前端计算抵扣和预计获得的积分 */
    @GetMapping("/rule")
    public Map<String, Integer> rule() {
        return Map.of("pointsPerYuan", PointsService.POINTS_PER_YUAN,
                "earnPerYuan", PointsService.EARN_PER_YUAN,
                "rechargePerYuan", PointsService.RECHARGE_PER_YUAN);
    }
}
