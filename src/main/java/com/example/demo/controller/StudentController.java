package com.example.demo.controller;

import com.example.demo.model.OrderItem;
import com.example.demo.model.Student;
import com.example.demo.service.OrderService;
import com.example.demo.service.StudentService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;

/** 学生接口:查看需要 student:read,新增、修改、删除、充值需要 student:write */
@RestController
@RequestMapping("/api/students")
@RequiredArgsConstructor
public class StudentController {

    private final StudentService studentService;

    private final OrderService orderService;

    /** 新增学生,可带初始余额 */
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Student create(@RequestBody Student student) {
        return studentService.create(student);
    }

    /** 单个学生(不含密码) */
    @GetMapping("/{id}")
    public Student get(@PathVariable long id) {
        return studentService.get(id);
    }

    /** 全部学生(不含密码) */
    @GetMapping
    public List<Student> list() {
        return studentService.list();
    }

    /** 修改学生资料,密码留空表示不改;余额和积分不能在这里改 */
    @PutMapping("/{id}")
    public Student update(@PathVariable long id, @RequestBody Student student) {
        return studentService.update(id, student);
    }

    /** POST /api/students/1/recharge  {"amount": 100.00} */
    @PostMapping("/{id}/recharge")
    public Student recharge(@PathVariable long id, @RequestBody RechargeRequest req) {
        return studentService.recharge(id, req.amount());
    }

    /** 充值请求:金额(元),0.01 ~ 100000,最多两位小数 */
    public record RechargeRequest(BigDecimal amount) {
    }

    /** 学生课表:报过的所有课次(含已退课),带课程标题、订单和支付状态 */
    @GetMapping("/{id}/schedule")
    public List<OrderItem> schedule(@PathVariable long id) {
        return orderService.schedule(id);
    }

    /** 删除学生;已有订单时拒绝 */
    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(@PathVariable long id) {
        studentService.delete(id);
    }
}