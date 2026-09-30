package com.example.demo.service;

import com.example.demo.mapper.PointsRecordMapper;
import com.example.demo.mapper.StudentMapper;
import com.example.demo.model.PointsRecord;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;

/** 积分规则和积分流水。积分余额的增减由调用方在各自的事务里完成,这里负责记流水 */
@Service
public class PointsService {

    private static final Logger log = LoggerFactory.getLogger(PointsService.class);

    /** 100 积分 = 1 元,即 1 积分 = 1 分钱,积分和金额之间换算没有舍入 */
    public static final int POINTS_PER_YUAN = 100;

    /** 余额每实付 1 元获得的积分(积分抵扣的部分不产生积分) */
    public static final int EARN_PER_YUAN = 2;

    /** 每充值 1 元赠送的积分 */
    public static final int RECHARGE_PER_YUAN = 1;

    @Autowired
    public StudentMapper studentMapper;

    @Autowired
    public PointsRecordMapper recordMapper;

    /** 金额 × 每元积分,向下取整 */
    public static int pointsFor(BigDecimal yuan, int perYuan) {
        return yuan.multiply(BigDecimal.valueOf(perYuan)).setScale(0, RoundingMode.FLOOR).intValueExact();
    }

    /** 记一条积分流水,变动后余额取当前值(调用方已在本事务里改过该学生的积分,行已锁住,读到的就是最新值) */
    public void record(long studentId, Long orderId, int change, PointsRecord.Type type, String remark) {
        PointsRecord r = new PointsRecord();
        r.setStudentId(studentId);
        r.setOrderId(orderId);
        r.setChangePoints(change);
        r.setBalanceAfter(studentMapper.findById(studentId).getPoints());
        r.setType(type);
        r.setRemark(remark);
        recordMapper.insert(r);
        log.debug("积分流水:学生 #{},{} {},变动后 {},{}", studentId, type, change, r.getBalanceAfter(), remark);
    }

    /** 积分流水,studentId 为 null 时查询全部 */
    public List<PointsRecord> records(Long studentId) {
        return recordMapper.findAll(studentId);
    }
}
