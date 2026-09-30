package com.example.demo.service;

import com.example.demo.mapper.RechargeRecordMapper;
import com.example.demo.mapper.StudentMapper;
import com.example.demo.model.BalanceRecord;
import com.example.demo.model.PointsRecord;
import com.example.demo.model.RechargeRecord;
import com.example.demo.model.Student;
import com.example.demo.security.PasswordHasher;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.math.BigDecimal;
import java.util.List;

@Service
@RequiredArgsConstructor
public class StudentService {

    @Autowired
    public StudentMapper studentMapper;

    @Autowired
    public RechargeRecordMapper rechargeRecordMapper;

    @Autowired
    public PointsService pointsService;

    @Autowired
    public BalanceService balanceService;

    /** 单次充值上限,防止误输入 */
    private static final BigDecimal MAX_RECHARGE = new BigDecimal("100000");

    @Transactional
    public Student create(Student student) {
        if (student.getPassword() == null || student.getPassword().length() < 6) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "学生密码至少 6 位");
        }
        student.setPassword(PasswordHasher.hash(student.getPassword())); // 只存哈希
        BigDecimal balance = student.getBalance();
        if (balance != null && (balance.signum() < 0 || balance.scale() > 2 || balance.compareTo(MAX_RECHARGE) > 0)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "初始余额需在 0 ~ " + MAX_RECHARGE + " 元之间,最多两位小数");
        }
        studentMapper.insert(student);
        if (balance != null && balance.signum() > 0) {
            balanceService.record(student.getStudentId(), null, balance, BalanceRecord.Type.INITIAL, "新建学生时的初始余额");
        }
        return get(student.getStudentId());
    }

    public Student get(long id) {
        Student s = studentMapper.findById(id);
        if (s == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "学生不存在: " + id);
        }
        s.setPassword(null); // 不向外返回密码
        return s;
    }

    public List<Student> list() {
        List<Student> list = studentMapper.findAll();
        list.forEach(s -> s.setPassword(null));
        return list;
    }

    public Student update(long id, Student student) {
        student.setStudentId(id);
        // 密码留空表示不修改(mapper 里跳过);填了则校验并存哈希
        if (student.getPassword() != null && !student.getPassword().isEmpty()) {
            if (student.getPassword().length() < 6) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "学生密码至少 6 位");
            }
            student.setPassword(PasswordHasher.hash(student.getPassword()));
        }
        if (studentMapper.update(student) == 0) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "学生不存在: " + id);
        }
        return get(id);
    }

    /**
     * 充值:金额需大于 0、最多两位小数。加余额和写充值记录在同一事务里;
     * 加余额的 UPDATE 会锁住该学生行直到提交,所以紧接着读到的余额就是本次充值后的余额。
     */
    @Transactional
    public Student recharge(long id, BigDecimal amount) {
        if (amount == null || amount.signum() <= 0 || amount.scale() > 2 || amount.compareTo(MAX_RECHARGE) > 0) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "充值金额需在 0.01 ~ " + MAX_RECHARGE + " 元之间,最多两位小数");
        }
        if (studentMapper.addBalance(id, amount) == 0) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "学生不存在: " + id);
        }
        // 充值赠送积分:每 1 元送 1 积分(向下取整),和充值在同一事务里
        int bonus = PointsService.pointsFor(amount, PointsService.RECHARGE_PER_YUAN);
        balanceService.record(id, null, amount, BalanceRecord.Type.RECHARGE,
                "充值 ¥" + amount + (bonus > 0 ? ",赠送 " + bonus + " 积分" : ""));
        if (bonus > 0) {
            studentMapper.addPoints(id, bonus);
            pointsService.record(id, null, bonus, PointsRecord.Type.RECHARGE, "充值 ¥" + amount + " 赠送");
        }
        Student s = get(id);
        RechargeRecord record = new RechargeRecord();
        record.setStudentId(id);
        record.setAmount(amount);
        record.setBalanceAfter(s.getBalance());
        record.setBonusPoints(bonus);
        rechargeRecordMapper.insert(record);
        return s;
    }

    /** 充值记录,studentId 为 null 时查询全部 */
    public List<RechargeRecord> recharges(Long studentId) {
        return rechargeRecordMapper.findAll(studentId);
    }

    public void delete(long id) {
        if (studentMapper.deleteById(id) == 0) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "学生不存在: " + id);
        }
    }
}
