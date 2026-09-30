package com.example.demo.mapper;

import com.example.demo.model.LessonSession;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.Collection;
import java.util.List;

/** 课次表 lesson_session:名额和停课状态在这一层 */
@Mapper
public interface LessonSessionMapper {

    int insert(LessonSession session);

    /** 物理删除课次,只用于从没人报过名的课次 */
    int deleteById(@Param("id") long id);

    /** 更新时间、节次、名额、剩余名额、状态 */
    int update(LessonSession session);

    /** 带 bookedCount / itemCount */
    LessonSession findById(@Param("id") long id);

    /** 某课程的全部课次,按开始时间排序,带 bookedCount / itemCount */
    List<LessonSession> findByLesson(@Param("lessonId") long lessonId);

    /** 按 ID 查询并加行锁(FOR UPDATE),按 ID 升序加锁避免死锁 */
    List<LessonSession> lockByIds(@Param("ids") Collection<Long> ids);

    /** 扣一个名额,返回 0 表示已满或已停课(条件更新,防止超卖) */
    int decreaseSeat(@Param("id") long id);

    /** 归还一个名额,不会超过总名额 */
    int increaseSeat(@Param("id") long id);

    /** 改课次状态(停课) */
    int updateStatus(@Param("id") long id, @Param("status") LessonSession.SessionStatus status);
}
