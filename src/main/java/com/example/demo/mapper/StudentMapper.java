package com.example.demo.mapper;

import com.example.demo.model.Student;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;
import java.util.List;

/**
 * 学生表 student。余额、积分只能通过 add / deduct 系列方法改,且都是条件更新:
 * 扣减时带上"够扣"的条件,返回 0 表示不够,不会扣成负数。
 */
@Mapper
public interface StudentMapper {

    int insert(Student student);

    int deleteById(@Param("id") long id);

    /** password 为空时不修改密码 */
    int update(Student student);

    Student findById(@Param("id") long id);

    /** 按 ID 查询并加行锁(FOR UPDATE):同一学生的下单串行执行,保证时间冲突检查可靠 */
    Student lockById(@Param("id") long id);

    List<Student> findAll();

    /** 增加积分 */
    int addPoints(@Param("id") long id, @Param("n") int n);

    /** 扣积分,返回 0 表示积分不足(条件更新,不会扣成负数) */
    int deductPoints(@Param("id") long id, @Param("n") int n);

    /** 只改密码哈希(启动时把历史明文密码转成哈希) */
    int updatePasswordHash(@Param("id") long id, @Param("hash") String hash);

    /** 充值 */
    int addBalance(@Param("id") long id, @Param("amount") BigDecimal amount);

    /** 扣款,返回 0 表示学生不存在或余额不足(条件更新,防止扣成负数) */
    int deductBalance(@Param("id") long id, @Param("amount") BigDecimal amount);
}
