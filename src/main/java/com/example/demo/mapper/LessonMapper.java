package com.example.demo.mapper;

import com.example.demo.model.Lesson;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface LessonMapper {

    int insert(Lesson lesson);

    int deleteById(@Param("id") long id);

    int update(Lesson lesson);

    /** 带课次统计(sessionCount / seatTotal / bookedCount / nextSessionAt),不含 periods */
    Lesson findById(@Param("id") long id);

    /** category 为空时查询全部;带课次统计,不含 periods */
    List<Lesson> findAll(@Param("category") String category);
}
