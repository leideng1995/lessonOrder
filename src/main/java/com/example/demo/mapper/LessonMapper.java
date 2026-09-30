package com.example.demo.mapper;

import com.example.demo.model.Lesson;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/** 课程表 lesson;删除课程时节次、课次由外键级联删除 */
@Mapper
public interface LessonMapper {

    int insert(Lesson lesson);

    /** 删除课程,节次和课次级联删除;调用前需确认没有订单 */
    int deleteById(@Param("id") long id);

    /** 修改课程基本信息(不含节次,节次由 LessonPeriodMapper 维护) */
    int update(Lesson lesson);

    /** 带课次统计(sessionCount / seatTotal / bookedCount / nextSessionAt),不含 periods */
    Lesson findById(@Param("id") long id);

    /** category 为空时查询全部;带课次统计,不含 periods */
    List<Lesson> findAll(@Param("category") String category);
}
