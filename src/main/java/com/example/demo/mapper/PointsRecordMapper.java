package com.example.demo.mapper;

import com.example.demo.model.PointsRecord;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/** 积分流水表 points_record,只增不改 */
@Mapper
public interface PointsRecordMapper {

    int insert(PointsRecord record);

    /** studentId 为 null 时查询全部,按时间倒序 */
    List<PointsRecord> findAll(@Param("studentId") Long studentId);
}
