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

@RestController
@RequestMapping("/api/students")
@RequiredArgsConstructor
public class StudentController {

    private final StudentService studentService;

    private final OrderService orderService;

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Student create(@RequestBody Student student) {
        return studentService.create(student);
    }

    @GetMapping("/{id}")
    public Student get(@PathVariable long id) {
        return studentService.get(id);
    }

    @GetMapping
    public List<Student> list() {
        return studentService.list();
    }

    @PutMapping("/{id}")
    public Student update(@PathVariable long id, @RequestBody Student student) {
        return studentService.update(id, student);
    }

    /** POST /api/students/1/recharge  {"amount": 100.00} */
    @PostMapping("/{id}/recharge")
    public Student recharge(@PathVariable long id, @RequestBody RechargeRequest req) {
        return studentService.recharge(id, req.amount());
    }

    public record RechargeRequest(BigDecimal amount) {
    }

    /** 学生课表:报过的所有课次(含已退课),带课程标题、订单和支付状态 */
    @GetMapping("/{id}/schedule")
    public List<OrderItem> schedule(@PathVariable long id) {
        return orderService.schedule(id);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(@PathVariable long id) {
        studentService.delete(id);
    }
}