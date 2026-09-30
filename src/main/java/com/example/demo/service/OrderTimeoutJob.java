package com.example.demo.service;

import com.example.demo.security.OpLogService;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

/**
 * 未支付订单超时自动取消:每分钟检查一次,下单超过支付时限(app.orders.pay-timeout-minutes)仍未支付的订单
 * 逐个取消、归还名额。每个订单单独一个事务,一个失败不影响其他订单,下一轮会再试。
 */
@Component
@RequiredArgsConstructor
public class OrderTimeoutJob {

    private static final Logger log = LoggerFactory.getLogger(OrderTimeoutJob.class);

    private final OrderService orderService;

    private final OpLogService opLog;

    @Scheduled(fixedDelayString = "${app.orders.timeout-check-ms:60000}", initialDelayString = "${app.orders.timeout-check-ms:60000}")
    public void cancelExpiredOrders() {
        int n = 0;
        for (long id : orderService.expiredPendingIds()) {
            try {
                if (orderService.cancelExpired(id)) {
                    n++;
                    opLog.system("超时自动取消订单", "订单 #" + id + " 下单后 " + orderService.payTimeoutMinutes() + " 分钟未支付,已取消并归还名额");
                }
            } catch (RuntimeException e) {
                log.warn("超时订单 #{} 自动取消失败,下一轮重试: {}", id, e.getMessage());
            }
        }
        if (n > 0) {
            log.info("已自动取消 {} 个超时未支付的订单", n);
        }
    }
}
