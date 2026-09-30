package com.example.demo.mapper;

import com.example.demo.model.BalanceRecord;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/** 余额流水表 balance_record,只增不改 */
@Mapper
public interface BalanceRecordMapper {

    int insert(BalanceRecord record);

    /** studentId 为 null 时查询全部,按时间倒序 */
    List<BalanceRecord> findAll(@Param("studentId") Long studentId);
}
