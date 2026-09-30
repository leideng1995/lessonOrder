package com.example.demo.model;

import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

/** 课程:标题、单价、名额、日期范围和每日节次,保存时展开成课次 */
@Data
public class Lesson {
    private long lessonId;

    private String title;

    private String description;

    /** 单节课价格(元) */
    private double price;

    /** 分类,如 数学、英语,用于筛选 */
    private String category;

    /** 开课、结课日期(含) */
    private LocalDate startDate;

    private LocalDate endDate;

    /** 每节课的名额,生成课次时带过去 */
    private int capacity;

    /** 是否支持积分抵扣;不传时按支持处理 */
    private Boolean pointsEnabled;

    /** 每天的节次;保存时按 [startDate, endDate] × periods 展开成课次 */
    private List<LessonPeriod> periods;

    /* ---------- 以下为查询时统计的只读字段 ---------- */

    /** 正常排课(未停课)的课次数 */
    private int sessionCount;

    /** 所有正常课次的名额合计 */
    private int seatTotal;

    /** 有效报名人次 */
    private int bookedCount;

    /** 下一节未开始的课的开始时间,没有则为 null */
    private LocalDateTime nextSessionAt;
}
