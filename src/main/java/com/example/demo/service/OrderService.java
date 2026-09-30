package com.example.demo.service;

import com.example.demo.mapper.*;
import com.example.demo.model.*;
import com.example.demo.model.LessonSession.SessionStatus;
import com.example.demo.model.Order.OrderStatus;
import com.example.demo.model.Order.PaymentStatus;
import com.example.demo.model.OrderItem.ItemStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Service
public class OrderService {

    /** 一单最多选多少节课 */
    private static final int MAX_ITEMS = 200;
    private static final DateTimeFormatter FMT = DateTimeFormatter.ofPattern("MM-dd HH:mm");

    @Autowired
    public OrderMapper orderMapper;

    @Autowired
    public OrderItemMapper itemMapper;

    @Autowired
    public LessonMapper lessonMapper;

    @Autowired
    public LessonSessionMapper sessionMapper;

    @Autowired
    public StudentMapper studentMapper;

    @Autowired
    public PointsService pointsService;

    @Autowired
    public BalanceService balanceService;

    /**
     * 下单:一个学生、一门课、多节课次。
     * 先锁学生行,同一学生的下单串行执行,时间冲突检查才可靠;
     * 再按课次 ID 升序锁课次、逐个扣名额,任一节已满则整单回滚。
     */
    @Transactional
    public Order create(long studentId, long lessonId, List<Long> sessionIds) {
        if (studentMapper.lockById(studentId) == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "学生不存在: " + studentId);
        }
        Lesson lesson = lessonMapper.findById(lessonId);
        if (lesson == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "课程不存在: " + lessonId);
        }
        Set<Long> ids = new TreeSet<>();
        if (sessionIds != null) {
            sessionIds.stream().filter(Objects::nonNull).forEach(ids::add);
        }
        if (ids.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "请至少选择一节课");
        }
        if (ids.size() > MAX_ITEMS) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "一次最多选 " + MAX_ITEMS + " 节课");
        }

        List<LessonSession> sessions = sessionMapper.lockByIds(ids);
        if (sessions.size() != ids.size()) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "部分课次不存在,请刷新后重试");
        }
        LocalDateTime now = LocalDateTime.now();
        for (LessonSession s : sessions) {
            String when = s.getStartAt().format(FMT);
            if (s.getLessonId() != lessonId) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "课次 " + when + " 不属于该课程");
            }
            if (s.getStatus() != SessionStatus.SCHEDULED) {
                throw new ResponseStatusException(HttpStatus.CONFLICT, "课次 " + when + " 已停课");
            }
            if (!s.getStartAt().isAfter(now)) {
                throw new ResponseStatusException(HttpStatus.CONFLICT, "课次 " + when + " 已开始,不能报名");
            }
        }
        checkClash(studentId, sessions);

        for (LessonSession s : sessions) {
            if (sessionMapper.decreaseSeat(s.getSessionId()) == 0) {
                throw new ResponseStatusException(HttpStatus.CONFLICT, "课次 " + s.getStartAt().format(FMT) + " 名额已满");
            }
        }

        BigDecimal price = BigDecimal.valueOf(lesson.getPrice()); // 单节价格快照
        Order order = new Order();
        order.setStudentId(studentId);
        order.setLessonId(lessonId);
        order.setTotalAmount(price.multiply(BigDecimal.valueOf(sessions.size())));
        order.setStatus(OrderStatus.PENDING);
        order.setPaymentStatus(PaymentStatus.UNPAID);
        orderMapper.insert(order);
        try {
            for (LessonSession s : sessions) {
                OrderItem item = new OrderItem();
                item.setOrderId(order.getOrderId());
                item.setSessionId(s.getSessionId());
                item.setStudentId(studentId);
                item.setPrice(price);
                item.setStatus(ItemStatus.ACTIVE);
                itemMapper.insert(item);
            }
        } catch (DuplicateKeyException e) {
            // 唯一约束兜底:同一学生同一课次只能有一条有效报名
            throw new ResponseStatusException(HttpStatus.CONFLICT, "已报名过其中的课次,请刷新后重试");
        }
        return get(order.getOrderId());
    }

    /** 时间冲突:所选课次之间、以及与该学生已报的课次(任何课程)之间不能重叠 */
    private void checkClash(long studentId, List<LessonSession> picked) {
        List<LessonSession> sorted = new ArrayList<>(picked);
        sorted.sort(Comparator.comparing(LessonSession::getStartAt));
        for (int i = 1; i < sorted.size(); i++) {
            LessonSession a = sorted.get(i - 1), b = sorted.get(i);
            if (b.getStartAt().isBefore(a.getEndAt())) {
                throw new ResponseStatusException(HttpStatus.CONFLICT,
                        "所选课次时间重叠: " + a.getStartAt().format(FMT) + " 与 " + b.getStartAt().format(FMT));
            }
        }
        for (OrderItem booked : itemMapper.findActiveByStudent(studentId)) {
            for (LessonSession s : picked) {
                if (s.getStartAt().isBefore(booked.getEndAt()) && s.getEndAt().isAfter(booked.getStartAt())) {
                    String msg = booked.getSessionId() == s.getSessionId()
                            ? "已报名过课次 " + s.getStartAt().format(FMT) + "(订单 #" + booked.getOrderId() + ")"
                            : "课次 " + s.getStartAt().format(FMT) + " 与已报的课(订单 #" + booked.getOrderId() + ","
                              + booked.getStartAt().format(FMT) + ")时间冲突";
                    throw new ResponseStatusException(HttpStatus.CONFLICT, msg);
                }
            }
        }
    }

    /** 查询单个订单,带明细 */
    public Order get(long id) {
        Order o = orderMapper.findById(id);
        if (o == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "订单不存在: " + id);
        }
        o.setItems(itemMapper.findByOrder(id));
        return withDeadline(o);
    }

    /** 学生课表:该学生报过的所有课次(含已退课) */
    public List<OrderItem> schedule(long studentId) {
        if (studentMapper.findById(studentId) == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "学生不存在: " + studentId);
        }
        return itemMapper.findScheduleByStudent(studentId);
    }

    public List<Order> list(Long studentId) {
        List<Order> list = orderMapper.findAll(studentId);
        list.forEach(this::withDeadline);
        return list;
    }

    /* ---------- 未支付订单超时 ---------- */

    /** 下单后多少分钟内必须支付,超时由 OrderTimeoutJob 自动取消 */
    @Value("${app.orders.pay-timeout-minutes:30}")
    public int payTimeoutMinutes;

    /** 支付时限(分钟)。其他 Bean 要通过方法读:本类有 @Transactional,被注入的是代理对象,直接读字段拿不到值 */
    public int payTimeoutMinutes() {
        return payTimeoutMinutes;
    }

    /** 待支付订单填上支付截止时间,供前端显示倒计时 */
    private Order withDeadline(Order o) {
        if (o.getStatus() == OrderStatus.PENDING && o.getPaymentStatus() == PaymentStatus.UNPAID && o.getCreatedAt() != null) {
            o.setPayDeadline(o.getCreatedAt().plusMinutes(payTimeoutMinutes));
        }
        return o;
    }

    private boolean expired(Order o) {
        return o.getCreatedAt() != null && !LocalDateTime.now().isBefore(o.getCreatedAt().plusMinutes(payTimeoutMinutes));
    }

    /** 已超过支付时限、还没取消的订单 ID(定时任务用) */
    public List<Long> expiredPendingIds() {
        return orderMapper.findPendingCreatedBefore(LocalDateTime.now().minusMinutes(payTimeoutMinutes));
    }

    /**
     * 超时自动取消:锁住订单后再确认一次仍是待支付且已超时,然后取消所有课次、归还名额。
     * 未支付订单不涉及余额和积分。返回是否真的取消了(期间可能已被支付或手动取消)。
     */
    @Transactional
    public boolean cancelExpired(long id) {
        Order o = lock(id);
        if (o.getStatus() != OrderStatus.PENDING || o.getPaymentStatus() != PaymentStatus.UNPAID || !expired(o)) {
            return false;
        }
        List<OrderItem> active = itemMapper.findByOrder(id).stream()
                .filter(i -> i.getStatus() == ItemStatus.ACTIVE)
                .toList();
        if (active.isEmpty()) {
            orderMapper.transition(id, OrderStatus.PENDING, PaymentStatus.UNPAID, OrderStatus.CANCELLED, PaymentStatus.UNPAID);
        } else {
            cancelItems(o, active);
        }
        orderMapper.updateCancelReason(id, "超时未支付(下单后 " + payTimeoutMinutes + " 分钟),系统自动取消");
        return true;
    }

    /**
     * 支付:可以用积分抵扣一部分(最多抵扣全部),剩下的从余额扣;课程设置为不支持积分时只能用余额。
     * 支付成功后按余额实付金额 × 2 获得积分(向下取整)。任一步不足则整体回滚。
     */
    @Transactional
    public Order pay(long id, int usePoints) {
        Order o = lock(id);
        long sid = o.getStudentId();
        if (usePoints < 0) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "使用的积分不能为负数");
        }
        if (usePoints > 0) {
            Lesson lesson = lessonMapper.findById(o.getLessonId());
            if (lesson != null && !Boolean.TRUE.equals(lesson.getPointsEnabled())) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "课程「" + lesson.getTitle() + "」不支持积分抵扣,请只用余额支付");
            }
        }
        if (o.getStatus() == OrderStatus.PENDING && expired(o)) {
            // 定时任务每分钟跑一次,可能还没来得及取消;超时后一律不能再支付
            throw new ResponseStatusException(HttpStatus.CONFLICT,
                    "订单已超过支付时限(下单后 " + payTimeoutMinutes + " 分钟),将自动取消,请重新下单");
        }
        long maxPoints = cents(o.getTotalAmount());
        if (usePoints > maxPoints) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "本单最多使用 " + maxPoints + " 积分(抵扣全部 ¥" + o.getTotalAmount() + ")");
        }
        if (orderMapper.transition(id, OrderStatus.PENDING, PaymentStatus.UNPAID,
                OrderStatus.CONFIRMED, PaymentStatus.PAID) == 0) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "只有待确认订单可以支付");
        }
        BigDecimal pointsValue = yuan(usePoints);
        BigDecimal balancePart = o.getTotalAmount().subtract(pointsValue);

        if (usePoints > 0) {
            if (studentMapper.deductPoints(sid, usePoints) == 0) {
                Student s = studentMapper.findById(sid);
                throw new ResponseStatusException(HttpStatus.CONFLICT, s == null
                        ? "学生不存在: " + sid
                        : "积分不足:本次使用 " + usePoints + " 积分,当前只有 " + s.getPoints() + " 积分");
            }
            pointsRecord(sid, id, -usePoints, PointsRecord.Type.REDEEM, "订单 #" + id + " 抵扣 ¥" + pointsValue);
        }
        if (balancePart.signum() > 0 && studentMapper.deductBalance(sid, balancePart) == 0) {
            Student s = studentMapper.findById(sid);
            throw new ResponseStatusException(HttpStatus.CONFLICT, s == null
                    ? "学生不存在: " + sid
                    : "余额不足:" + (usePoints > 0 ? "积分抵扣 ¥" + pointsValue + " 后" : "")
                      + "需余额支付 ¥" + balancePart + ",当前余额 ¥" + s.getBalance());
        }
        if (balancePart.signum() > 0) {
            balanceService.record(sid, id, balancePart.negate(), BalanceRecord.Type.PAY,
                    "支付订单 #" + id + (usePoints > 0 ? "(另用 " + usePoints + " 积分抵 ¥" + pointsValue + ")" : ""));
        }
        int earned = PointsService.pointsFor(balancePart, PointsService.EARN_PER_YUAN);
        if (earned > 0) {
            studentMapper.addPoints(sid, earned);
            pointsRecord(sid, id, earned, PointsRecord.Type.EARN, "订单 #" + id + " 余额实付 ¥" + balancePart);
        }
        orderMapper.updatePayment(id, balancePart, usePoints, earned);
        return get(id);
    }

    /** 取消订单:取消所有尚未开始的课次;已开始的课次保留,不退款 */
    @Transactional
    public Order cancel(long id) {
        Order o = lock(id);
        if (o.getStatus() == OrderStatus.CANCELLED) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "订单已取消");
        }
        LocalDateTime now = LocalDateTime.now();
        List<OrderItem> targets = itemMapper.findByOrder(id).stream()
                .filter(i -> i.getStatus() == ItemStatus.ACTIVE && i.getStartAt().isAfter(now))
                .toList();
        if (targets.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "订单里的课次都已开始,不能取消");
        }
        cancelItems(o, targets);
        return get(id);
    }

    /** 退掉订单里的一节课(课次尚未开始) */
    @Transactional
    public Order cancelItem(long orderId, long itemId) {
        Order o = lock(orderId);
        OrderItem item = itemMapper.findByOrder(orderId).stream()
                .filter(i -> i.getItemId() == itemId)
                .findFirst()
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "订单里没有这节课: " + itemId));
        if (item.getStatus() != ItemStatus.ACTIVE) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "这节课已取消");
        }
        if (!item.getStartAt().isAfter(LocalDateTime.now())) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "这节课已开始,不能取消");
        }
        cancelItems(o, List.of(item));
        return get(orderId);
    }

    /**
     * 停课:把课次标记为停课,该课次的所有有效报名都取消;已支付的全额退回余额。
     * 先改状态再处理报名:状态一改,新的下单扣名额就会失败,不会有人在停课过程中报进来。
     * (停课是先锁课次再锁学生,与同时报这节课的下单可能交叉等待,InnoDB 会回滚其中一个,重试即可)
     */
    @Transactional
    public LessonSession cancelSession(long lessonId, long sessionId) {
        LessonSession s = sessionMapper.findById(sessionId);
        if (s == null || s.getLessonId() != lessonId) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "课次不存在: " + sessionId);
        }
        if (s.getStatus() == SessionStatus.CANCELLED) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "该课次已停课");
        }
        sessionMapper.updateStatus(sessionId, SessionStatus.CANCELLED);
        Map<Long, List<OrderItem>> byOrder = new TreeMap<>();
        for (OrderItem i : itemMapper.findActiveBySession(sessionId)) {
            byOrder.computeIfAbsent(i.getOrderId(), k -> new ArrayList<>()).add(i);
        }
        for (Map.Entry<Long, List<OrderItem>> e : byOrder.entrySet()) {
            cancelItems(lock(e.getKey()), e.getValue());
        }
        return sessionMapper.findById(sessionId);
    }

    /**
     * 取消若干条明细(调用方已锁住订单):归还名额;
     * 未支付的订单同步减少订单金额,已支付的按原支付方式退款(见 refund);
     * 全部明细都取消后,订单变为已取消(已支付的支付状态变为已退款)。
     */
    private void cancelItems(Order o, List<OrderItem> items) {
        BigDecimal amount = BigDecimal.ZERO;
        for (OrderItem i : items) {
            if (itemMapper.cancel(i.getItemId()) == 0) {
                continue; // 已被其他请求取消,不重复退款
            }
            sessionMapper.increaseSeat(i.getSessionId());
            amount = amount.add(i.getPrice());
        }
        boolean paid = o.getPaymentStatus() == PaymentStatus.PAID;
        boolean anyActive = itemMapper.findByOrder(o.getOrderId()).stream()
                .anyMatch(i -> i.getStatus() == ItemStatus.ACTIVE);
        if (amount.signum() > 0) {
            if (paid) {
                refund(o, amount, !anyActive);
            } else {
                o.setTotalAmount(o.getTotalAmount().subtract(amount));
            }
            orderMapper.updateAmounts(o);
        }
        if (!anyActive && o.getStatus() != OrderStatus.CANCELLED) {
            orderMapper.transition(o.getOrderId(), o.getStatus(), o.getPaymentStatus(),
                    OrderStatus.CANCELLED, paid ? PaymentStatus.REFUNDED : o.getPaymentStatus());
            o.setStatus(OrderStatus.CANCELLED);
        }
    }

    /**
     * 已支付订单退款 amount 元:按原支付方式退回——余额部分退余额、积分部分退积分,按剩余未退的比例拆分;
     * 最后一次退款(订单里没有有效课次了)把剩余的余额和积分全部退回,避免舍入误差累积。
     * 同时按退回的余额比例扣回当初获得的积分;学生积分不够时只扣到 0(流水里注明)。
     */
    private void refund(Order o, BigDecimal amount, boolean last) {
        long sid = o.getStudentId();
        int remainPoints = o.getPaidPoints() - o.getRefundedPoints();
        BigDecimal remainBalance = o.getPaidBalance().subtract(o.getRefundedBalance());
        int pointsBack;
        BigDecimal balanceBack;
        if (last) {
            pointsBack = remainPoints;
            balanceBack = remainBalance;
        } else {
            long remainCents = remainPoints + cents(remainBalance);
            pointsBack = remainCents == 0 ? 0 : (int) (remainPoints * cents(amount) / remainCents);
            balanceBack = amount.subtract(yuan(pointsBack));
        }

        if (balanceBack.signum() > 0) {
            if (studentMapper.addBalance(sid, balanceBack) == 0) {
                throw new ResponseStatusException(HttpStatus.NOT_FOUND, "学生不存在,无法退款: " + sid);
            }
            balanceService.record(sid, o.getOrderId(), balanceBack, BalanceRecord.Type.REFUND, "订单 #" + o.getOrderId() + " 退课退款");
        }
        if (pointsBack > 0) {
            studentMapper.addPoints(sid, pointsBack);
            pointsRecord(sid, o.getOrderId(), pointsBack, PointsRecord.Type.REFUND, "订单 #" + o.getOrderId() + " 退课退回抵扣的积分");
        }

        int remainEarned = o.getEarnedPoints() - o.getClawedPoints();
        int clawDue = last ? remainEarned
                : remainBalance.signum() == 0 ? 0
                : balanceBack.multiply(BigDecimal.valueOf(remainEarned)).divide(remainBalance, 0, RoundingMode.FLOOR).intValue();
        if (clawDue > 0) {
            int actual = Math.min(clawDue, studentMapper.findById(sid).getPoints());
            if (actual > 0) {
                studentMapper.deductPoints(sid, actual);
                pointsRecord(sid, o.getOrderId(), -actual, PointsRecord.Type.CLAWBACK, "订单 #" + o.getOrderId() + " 退课扣回已得积分"
                        + (actual < clawDue ? "(应扣 " + clawDue + ",积分不足只扣 " + actual + ")" : ""));
            }
            o.setClawedPoints(o.getClawedPoints() + clawDue);
        }

        o.setRefundedPoints(o.getRefundedPoints() + pointsBack);
        o.setRefundedBalance(o.getRefundedBalance().add(balanceBack));
        o.setRefundedAmount(o.getRefundedAmount().add(amount));
    }

    private void pointsRecord(long studentId, Long orderId, int change, PointsRecord.Type type, String remark) {
        pointsService.record(studentId, orderId, change, type, remark);
    }

    /** 元 → 分(= 积分数) */
    private static long cents(BigDecimal yuan) {
        return yuan.movePointRight(2).setScale(0, RoundingMode.UNNECESSARY).longValueExact();
    }

    /** 积分 → 元 */
    private static BigDecimal yuan(long points) {
        return BigDecimal.valueOf(points).movePointLeft(2).setScale(2, RoundingMode.UNNECESSARY);
    }

    /**
     * 锁订单。所有改订单的操作统一按"学生 → 订单 → 课次"的顺序加锁(下单是"学生 → 课次"),
     * 同一学生的下单、支付、退课互相串行,不会交叉等待而死锁。
     */
    private Order lock(long id) {
        Order o = orderMapper.findById(id);
        if (o == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "订单不存在: " + id);
        }
        studentMapper.lockById(o.getStudentId());
        return orderMapper.lockById(id);
    }

    /** 删除:仅允许删除已取消的订单,明细随订单一起删除 */
    @Transactional
    public void delete(long id) {
        Order o = lock(id);
        if (o.getStatus() != OrderStatus.CANCELLED) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "只能删除已取消的订单");
        }
        orderMapper.deleteById(id);
    }
}
