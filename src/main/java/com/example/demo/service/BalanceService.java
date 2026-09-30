package com.example.demo.service;

import com.example.demo.mapper.BalanceRecordMapper;
import com.example.demo.mapper.StudentMapper;
import com.example.demo.model.BalanceRecord;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;

/**
 * 余额流水。余额的增减由调用方在各自的事务里完成(充值、开户、支付、退款),这里负责记流水;
 * 所有改余额的地方都要调用 record,保证每个学生的流水合计 = 当前余额。
 */
@Service
public class BalanceService {

    private static final Logger log = LoggerFactory.getLogger(BalanceService.class);

    @Autowired
    public StudentMapper studentMapper;

    @Autowired
    public BalanceRecordMapper recordMapper;

    /** 记一条余额流水,变动后余额取当前值(调用方已在本事务里改过该学生的余额,行已锁住,读到的就是最新值) */
    public void record(long studentId, Long orderId, BigDecimal change, BalanceRecord.Type type, String remark) {
        BalanceRecord r = new BalanceRecord();
        r.setStudentId(studentId);
        r.setOrderId(orderId);
        r.setChangeAmount(change);
        r.setBalanceAfter(studentMapper.findById(studentId).getBalance());
        r.setType(type);
        r.setRemark(remark);
        recordMapper.insert(r);
        log.debug("余额流水:学生 #{},{} {},变动后 ¥{},{}", studentId, type, change, r.getBalanceAfter(), remark);
    }

    /** 余额流水,studentId 为 null 时查询全部 */
    public List<BalanceRecord> records(Long studentId) {
        return recordMapper.findAll(studentId);
    }
}
