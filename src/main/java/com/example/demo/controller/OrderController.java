package com.example.demo.controller;

import com.example.demo.model.Order;
import com.example.demo.service.OrderService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/** 订单接口:查看需要 order:read,下单、支付、取消、退课、删除需要 order:write */
@RestController
@RequestMapping("/api/orders")
@RequiredArgsConstructor
public class OrderController {

    private final OrderService orderService;

    /** 下单请求:一个学生、一门课、若干课次;价格和状态由服务端决定 */
    public record CreateOrderRequest(long studentId, long lessonId, List<Long> sessionIds) {
    }

    /** POST /api/orders  {"studentId":1,"lessonId":2,"sessionIds":[5,6,7]} */
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Order create(@RequestBody CreateOrderRequest req) {
        return orderService.create(req.studentId(), req.lessonId(), req.sessionIds());
    }

    /** 单个订单,带明细 items */
    @GetMapping("/{id}")
    public Order get(@PathVariable long id) {
        return orderService.get(id);
    }

    /** GET /api/orders?studentId=1,studentId 可选;列表不含明细 */
    @GetMapping
    public List<Order> list(@RequestParam(required = false) Long studentId) {
        return orderService.list(studentId);
    }

    /** 支付请求:points 为本次用来抵扣的积分(100 积分 = 1 元),不传或为 0 表示全部用余额 */
    public record PayRequest(Integer points) {
    }

    /** PUT /api/orders/1/pay  {"points": 500}  → 积分抵扣 ¥5,其余从余额扣 */
    @PutMapping("/{id}/pay")
    public Order pay(@PathVariable long id, @RequestBody(required = false) PayRequest req) {
        return orderService.pay(id, req == null || req.points() == null ? 0 : req.points());
    }

    /** 取消订单:取消所有未开始的课次 */
    @PutMapping("/{id}/cancel")
    public Order cancel(@PathVariable long id) {
        return orderService.cancel(id);
    }

    /** 退掉订单里的一节课 */
    @PutMapping("/{id}/items/{itemId}/cancel")
    public Order cancelItem(@PathVariable long id, @PathVariable long itemId) {
        return orderService.cancelItem(id, itemId);
    }

    /** 删除订单,只能删已取消的 */
    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(@PathVariable long id) {
        orderService.delete(id);
    }
}
