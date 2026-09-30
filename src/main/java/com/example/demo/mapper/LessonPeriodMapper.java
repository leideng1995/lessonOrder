package com.example.demo.mapper;

import com.example.demo.model.LessonPeriod;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface LessonPeriodMapper {

    int insert(LessonPeriod period);

    int deleteByLesson(@Param("lessonId") long lessonId);

    /** lessonId 为 null 时查询全部,按课程、节次排序 */
    List<LessonPeriod> findAll(@Param("lessonId") Long lessonId);
}
