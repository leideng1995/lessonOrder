package com.example.demo.model;

import lombok.Data;

import java.time.LocalDateTime;

/** 课次:某一天的某一节具体的课,名额在这一层 */
@Data
public class LessonSession {
    private long sessionId;

    private long lessonId;

    /** 来自哪个节次;修改课程重建节次期间可能为空 */
    private Long periodId;

    private LocalDateTime startAt;

    private LocalDateTime endAt;

    private int capacity;

    /** 剩余名额 = 名额 - 有效报名数,下单扣、退课还 */
    private int availableSeats;

    private SessionStatus status;

    /** 查询时统计:有效报名人数 */
    private int bookedCount;

    /** 查询时统计:所有报名记录数(含已取消),> 0 时课次不能物理删除 */
    private int itemCount;

    /** 正常排课 / 已停课 */
    public enum SessionStatus {
        SCHEDULED, CANCELLED
    }
}
