package com.example.demo.mapper;

import com.example.demo.model.Order;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Mapper
public interface OrderMapper {

    int insert(Order order);

    int deleteById(@Param("id") long id);

    /**
     * 状态流转:仅当订单当前是 (fromStatus, fromPaymentStatus) 时才改为 (status, paymentStatus)。
     * 返回 0 表示订单状态已被其他请求改变,用来防止重复支付 / 重复退款。
     */
    int transition(@Param("id") long id,
                   @Param("fromStatus") Order.OrderStatus fromStatus,
                   @Param("fromPaymentStatus") Order.PaymentStatus fromPaymentStatus,
                   @Param("status") Order.OrderStatus status,
                   @Param("paymentStatus") Order.PaymentStatus paymentStatus);

    /** 修改订单金额和退款构成(total_amount、refunded_amount/balance/points、clawed_points) */
    int updateAmounts(Order order);

    /** 记录支付构成 */
    int updatePayment(@Param("id") long id,
                      @Param("paidBalance") BigDecimal paidBalance,
                      @Param("paidPoints") int paidPoints,
                      @Param("earnedPoints") int earnedPoints);

    /** 带 itemCount / activeItemCount,不含 items */
    Order findById(@Param("id") long id);

    /** 按 ID 查询并加行锁(FOR UPDATE):支付、退课前先锁订单,保证读到的金额和状态是最新的 */
    Order lockById(@Param("id") long id);

    /** studentId 为 null 时查询全部 */
    List<Order> findAll(@Param("studentId") Long studentId);

    int countByLesson(@Param("lessonId") long lessonId);

    /** 下单时间不晚于 before、仍待支付的订单 ID */
    List<Long> findPendingCreatedBefore(@Param("before") LocalDateTime before);

    int updateCancelReason(@Param("id") long id, @Param("reason") String reason);
}
