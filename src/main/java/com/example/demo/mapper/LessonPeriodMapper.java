package com.example.demo.mapper;

import com.example.demo.model.LessonPeriod;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/** 课程每日节次表 lesson_period */
@Mapper
public interface LessonPeriodMapper {

    int insert(LessonPeriod period);

    /** 删除课程的全部节次(修改课程时先删后插);课次上的 period_id 被置空 */
    int deleteByLesson(@Param("lessonId") long lessonId);

    /** lessonId 为 null 时查询全部,按课程、节次排序 */
    List<LessonPeriod> findAll(@Param("lessonId") Long lessonId);
}
