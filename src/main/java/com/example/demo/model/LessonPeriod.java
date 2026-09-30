package com.example.demo.model;

import lombok.Data;

import java.time.LocalTime;

/** 课程每天的一个节次,如"第 1 节 08:00-09:30" */
@Data
public class LessonPeriod {
    private long periodId;

    private long lessonId;

    /** 第几节,从 1 开始,按开始时间排序 */
    private int seq;

    private LocalTime startTime;

    private LocalTime endTime;
}
