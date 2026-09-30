package com.example.demo.mapper;

import com.example.demo.model.RechargeRecord;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/** 充值记录表 recharge_record,只增不改 */
@Mapper
public interface RechargeRecordMapper {

    int insert(RechargeRecord record);

    /** studentId 为 null 时查询全部,按时间倒序 */
    List<RechargeRecord> findAll(@Param("studentId") Long studentId);
}
