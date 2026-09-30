package com.example.demo.mapper;

import com.example.demo.model.OrderItem;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface OrderItemMapper {

    int insert(OrderItem item);

    /** 订单的全部明细,带课次时间,按上课时间排序 */
    List<OrderItem> findByOrder(@Param("orderId") long orderId);

    /** 某课次的有效明细 */
    List<OrderItem> findActiveBySession(@Param("sessionId") long sessionId);

    /** 学生的全部有效明细(带课次时间),用于检查上课时间冲突 */
    List<OrderItem> findActiveByStudent(@Param("studentId") long studentId);

    /** 学生课表:该学生的全部明细(含已退课),带课程标题、订单状态和支付状态,按上课时间排序 */
    List<OrderItem> findScheduleByStudent(@Param("studentId") long studentId);

    /** 取消一条有效明细,返回 0 表示已被取消(条件更新,防止重复退款) */
    int cancel(@Param("id") long id);
}
