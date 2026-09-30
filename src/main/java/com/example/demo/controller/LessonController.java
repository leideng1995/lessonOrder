package com.example.demo.controller;

import com.example.demo.model.Lesson;
import com.example.demo.model.LessonSession;
import com.example.demo.service.LessonService;
import com.example.demo.service.OrderService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/lessons")
@RequiredArgsConstructor
public class LessonController {

    private final LessonService lessonService;

    private final OrderService orderService;

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Lesson create(@RequestBody Lesson lesson) {
        return lessonService.create(lesson);
    }

    @GetMapping("/{id}")
    public Lesson get(@PathVariable long id) {
        return lessonService.get(id);
    }

    /** GET /api/lessons?category=xxx,category 可选 */
    @GetMapping
    public List<Lesson> list(@RequestParam(required = false) String category) {
        return lessonService.list(category);
    }

    /** 课程的全部课次(按时间排序,带已报名人数) */
    @GetMapping("/{id}/sessions")
    public List<LessonSession> sessions(@PathVariable long id) {
        return lessonService.sessions(id);
    }

    /** 停课:取消该课次的所有报名,已支付的退回余额 */
    @PutMapping("/{id}/sessions/{sessionId}/cancel")
    public LessonSession cancelSession(@PathVariable long id, @PathVariable long sessionId) {
        return orderService.cancelSession(id, sessionId);
    }

    @PutMapping("/{id}")
    public Lesson update(@PathVariable long id, @RequestBody Lesson lesson) {
        return lessonService.update(id, lesson);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(@PathVariable long id) {
        lessonService.delete(id);
    }
}