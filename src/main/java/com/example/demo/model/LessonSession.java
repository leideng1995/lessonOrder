package com.example.demo.model;

import lombok.Data;

import java.time.LocalDateTime;

/** 课次:某一天的某一节具体的课,名额在这一层 */
@Data
public class LessonSession {
    private long sessionId;

    private long lessonId;

    private Long periodId;

    private LocalDateTime startAt;

    private LocalDateTime endAt;

    private int capacity;

    private int availableSeats;

    private SessionStatus status;

    /** 查询时统计:有效报名人数 */
    private int bookedCount;

    /** 查询时统计:所有报名记录数(含已取消),> 0 时课次不能物理删除 */
    private int itemCount;

    public enum SessionStatus {
        SCHEDULED, CANCELLED
    }
}
