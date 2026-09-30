package com.example.demo.mapper;

import com.example.demo.model.OperationLog;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/** 操作日志表 operation_log,只增不改 */
@Mapper
public interface OperationLogMapper {

    int insert(OperationLog log);

    /** 最近的日志,category 为空时查询全部,按时间倒序,最多 limit 条 */
    List<OperationLog> findRecent(@Param("category") OperationLog.Category category, @Param("limit") int limit);
}
