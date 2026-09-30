package com.example.demo.service;

import com.example.demo.mapper.LessonMapper;
import com.example.demo.mapper.LessonPeriodMapper;
import com.example.demo.mapper.LessonSessionMapper;
import com.example.demo.mapper.OrderMapper;
import com.example.demo.model.Lesson;
import com.example.demo.model.LessonPeriod;
import com.example.demo.model.LessonSession;
import com.example.demo.model.LessonSession.SessionStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class LessonService {

    /** 一门课最长排多少天、每天最多几节,防止误操作生成海量课次 */
    private static final int MAX_DAYS = 366;
    private static final int MAX_PERIODS = 12;
    private static final DateTimeFormatter FMT = DateTimeFormatter.ofPattern("MM-dd HH:mm");

    @Autowired
    public LessonMapper lessonMapper;

    @Autowired
    public LessonPeriodMapper periodMapper;

    @Autowired
    public LessonSessionMapper sessionMapper;

    @Autowired
    public OrderMapper orderMapper;

    /** 新建课程:保存课程和节次,按 [开课日期, 结课日期] × 节次 生成课次 */
    @Transactional
    public Lesson create(Lesson lesson) {
        List<LessonPeriod> periods = validate(lesson);
        lessonMapper.insert(lesson);
        savePeriods(lesson.getLessonId(), periods);
        syncSessions(lesson, periods);
        return get(lesson.getLessonId());
    }

    public Lesson get(long id) {
        Lesson l = lessonMapper.findById(id);
        if (l == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "课程不存在: " + id);
        }
        l.setPeriods(periodMapper.findAll(id));
        return l;
    }

    public List<Lesson> list(String category) {
        List<Lesson> list = lessonMapper.findAll(category);
        Map<Long, List<LessonPeriod>> byLesson = periodMapper.findAll(null).stream()
                .collect(Collectors.groupingBy(LessonPeriod::getLessonId));
        list.forEach(l -> l.setPeriods(byLesson.getOrDefault(l.getLessonId(), List.of())));
        return list;
    }

    public List<LessonSession> sessions(long lessonId) {
        get(lessonId);
        return sessionMapper.findByLesson(lessonId);
    }

    /**
     * 修改课程:日期范围或节次变化时同步课次。
     * 已有学生报名的课次不能被移除或改时间(否则学生的课表会被悄悄改掉),遇到时整体拒绝并说明是哪几节。
     */
    @Transactional
    public Lesson update(long id, Lesson lesson) {
        get(id);
        lesson.setLessonId(id);
        List<LessonPeriod> periods = validate(lesson);
        lessonMapper.update(lesson);
        periodMapper.deleteByLesson(id);   // 课次上的 period_id 会被置空,下面同步时重新关联
        savePeriods(id, periods);
        syncSessions(lesson, periods);
        return get(id);
    }

    /** 删除:已有订单的课程不能删除;没有订单时课次和节次随课程一起删除 */
    public void delete(long id) {
        get(id);
        if (orderMapper.countByLesson(id) > 0) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "该课程已有订单,不能删除");
        }
        lessonMapper.deleteById(id);
    }

    /* ---------- 内部 ---------- */

    /** 校验课程字段,返回按开始时间排好序、seq 从 1 编号的节次 */
    private List<LessonPeriod> validate(Lesson l) {
        if (l.getTitle() == null || l.getTitle().isBlank()) {
            throw bad("课程标题不能为空");
        }
        if (l.getPrice() < 0) {
            throw bad("单节价格不能为负数");
        }
        if (l.getPointsEnabled() == null) {
            l.setPointsEnabled(true); // 默认支持积分抵扣
        }
        if (l.getCapacity() <= 0) {
            throw bad("每节名额至少为 1");
        }
        if (l.getStartDate() == null || l.getEndDate() == null) {
            throw bad("请填写开课日期和结课日期");
        }
        if (l.getEndDate().isBefore(l.getStartDate())) {
            throw bad("结课日期不能早于开课日期");
        }
        if (ChronoUnit.DAYS.between(l.getStartDate(), l.getEndDate()) + 1 > MAX_DAYS) {
            throw bad("课程时间跨度不能超过 " + MAX_DAYS + " 天");
        }
        List<LessonPeriod> periods = new ArrayList<>(l.getPeriods() == null ? List.of() : l.getPeriods());
        if (periods.isEmpty()) {
            throw bad("请至少设置一节课的上课时间");
        }
        if (periods.size() > MAX_PERIODS) {
            throw bad("每天最多 " + MAX_PERIODS + " 节课");
        }
        for (LessonPeriod p : periods) {
            if (p.getStartTime() == null || p.getEndTime() == null) {
                throw bad("每节课都要填写开始和结束时间");
            }
            if (!p.getEndTime().isAfter(p.getStartTime())) {
                throw bad("节次 " + p.getStartTime() + " 的结束时间必须晚于开始时间");
            }
        }
        periods.sort(Comparator.comparing(LessonPeriod::getStartTime));
        for (int i = 1; i < periods.size(); i++) {
            LessonPeriod prev = periods.get(i - 1), cur = periods.get(i);
            if (cur.getStartTime().isBefore(prev.getEndTime())) {
                throw bad("节次时间重叠: " + prev.getStartTime() + "-" + prev.getEndTime()
                        + " 与 " + cur.getStartTime() + "-" + cur.getEndTime());
            }
        }
        for (int i = 0; i < periods.size(); i++) {
            periods.get(i).setSeq(i + 1);
        }
        return periods;
    }

    private void savePeriods(long lessonId, List<LessonPeriod> periods) {
        for (LessonPeriod p : periods) {
            p.setLessonId(lessonId);
            periodMapper.insert(p);
        }
    }

    /** 期望的课次:每天 × 每节 */
    private record Slot(LocalDateTime startAt, LocalDateTime endAt, long periodId) {
    }

    /**
     * 让课次与"日期范围 × 节次"一致,按开始时间匹配已有课次:
     * - 仍需要的:更新结束时间 / 节次 / 名额,剩余名额 = 名额 - 已报名;停过课的保持停课
     * - 不再需要的:没人报过名则删除;只有已取消的报名则标记停课(保留历史);有有效报名则拒绝
     * - 新增的:插入
     */
    private void syncSessions(Lesson lesson, List<LessonPeriod> periods) {
        Map<LocalDateTime, Slot> wanted = new LinkedHashMap<>();
        for (LocalDate d = lesson.getStartDate(); !d.isAfter(lesson.getEndDate()); d = d.plusDays(1)) {
            for (LessonPeriod p : periods) {
                LocalDateTime start = d.atTime(p.getStartTime());
                wanted.put(start, new Slot(start, d.atTime(p.getEndTime()), p.getPeriodId()));
            }
        }

        List<String> conflicts = new ArrayList<>();
        for (LessonSession s : sessionMapper.findByLesson(lesson.getLessonId())) {
            Slot slot = wanted.remove(s.getStartAt());
            int booked = s.getBookedCount();
            if (slot == null) {
                if (booked > 0) {
                    conflicts.add(s.getStartAt().format(FMT) + " 已有 " + booked + " 人报名,不能移除");
                } else if (s.getItemCount() > 0) {
                    sessionMapper.updateStatus(s.getSessionId(), SessionStatus.CANCELLED);
                } else {
                    sessionMapper.deleteById(s.getSessionId());
                }
                continue;
            }
            if (booked > 0 && !s.getEndAt().equals(slot.endAt())) {
                conflicts.add(s.getStartAt().format(FMT) + " 已有 " + booked + " 人报名,不能修改下课时间");
                continue;
            }
            if (booked > lesson.getCapacity()) {
                conflicts.add(s.getStartAt().format(FMT) + " 已有 " + booked + " 人报名,名额不能少于报名人数");
                continue;
            }
            s.setEndAt(slot.endAt());
            s.setPeriodId(slot.periodId());
            s.setCapacity(lesson.getCapacity());
            s.setAvailableSeats(lesson.getCapacity() - booked);
            sessionMapper.update(s);
        }
        if (!conflicts.isEmpty()) {
            String more = conflicts.size() > 3 ? " 等 " + conflicts.size() + " 节" : "";
            throw new ResponseStatusException(HttpStatus.CONFLICT,
                    "以下课次已有学生报名:" + String.join(";", conflicts.subList(0, Math.min(3, conflicts.size()))) + more);
        }

        for (Slot slot : wanted.values()) {
            LessonSession s = new LessonSession();
            s.setLessonId(lesson.getLessonId());
            s.setPeriodId(slot.periodId());
            s.setStartAt(slot.startAt());
            s.setEndAt(slot.endAt());
            s.setCapacity(lesson.getCapacity());
            s.setAvailableSeats(lesson.getCapacity());
            s.setStatus(SessionStatus.SCHEDULED);
            sessionMapper.insert(s);
        }
    }

    private static ResponseStatusException bad(String msg) {
        return new ResponseStatusException(HttpStatus.BAD_REQUEST, msg);
    }
}
