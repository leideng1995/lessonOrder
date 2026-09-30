package com.example.demo;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

/**
 * 课程管理系统启动类。
 * 分层:controller(接口)→ service(业务规则和事务)→ mapper(MyBatis,SQL 在 resources/mapper/*.xml);
 * security 包负责登录、权限、操作日志和访问日志。
 */
@SpringBootApplication
@MapperScan("com.example.demo.mapper")
@EnableScheduling // 定时任务:未支付订单超时自动取消(OrderTimeoutJob)
public class DemoApplication {

    public static void main(String[] args) {
        SpringApplication.run(DemoApplication.class, args);
    }

}
