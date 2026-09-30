package com.example.demo.security;

import com.example.demo.mapper.StudentMapper;
import com.example.demo.mapper.SysUserMapper;
import com.example.demo.model.Student;
import com.example.demo.model.SysUser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.stereotype.Component;

import java.security.SecureRandom;

/**
 * 启动时:
 * 1. 没有任何系统用户时创建管理员 admin,随机初始密码只打印一次到日志,首次登录必须修改;
 * 2. 把学生表里历史遗留的明文密码转成哈希(已是哈希的跳过,可重复执行);
 * 3. 登录页公开的「重置管理员密码」开着时打警告,提醒上线前关闭。
 */
@Component
public class SecurityBootstrap implements ApplicationRunner {

    private static final Logger log = LoggerFactory.getLogger(SecurityBootstrap.class);
    private static final String CHARS = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnpqrstuvwxyz23456789";

    @Autowired
    public SysUserMapper userMapper;

    @Autowired
    public StudentMapper studentMapper;

    @Autowired
    public AuthService authService;

    @Override
    public void run(ApplicationArguments args) {
        if (userMapper.count() == 0) {
            String pw = randomPassword();
            SysUser admin = new SysUser();
            admin.setUsername("admin");
            admin.setDisplayName("系统管理员");
            admin.setRole(Role.ADMIN);
            admin.setEnabled(true);
            admin.setMustChangePassword(true);
            admin.setPasswordHash(PasswordHasher.hash(pw));
            userMapper.insert(admin);
            log.warn("""

                    ==================================================
                      已创建初始管理员账号(仅显示这一次)
                        用户名: admin
                        密  码: {}
                      首次登录后必须修改密码。
                    ==================================================""", pw);
        }

        int n = 0;
        for (Student s : studentMapper.findAll()) {
            if (!PasswordHasher.isHashed(s.getPassword())) {
                studentMapper.updatePasswordHash(s.getStudentId(), PasswordHasher.hash(s.getPassword() == null ? "" : s.getPassword()));
                n++;
            }
        }
        if (n > 0) {
            log.info("已将 {} 个学生的明文密码转换为哈希", n);
        }

        if (authService.adminResetEnabled()) {
            log.warn("登录页「重置管理员密码」已开启:任何人都能把 admin 密码重置为初始密码。"
                    + "仅限本地开发,上线前请设置 app.security.admin-reset-enabled=false");
        }
    }

    /** 16 位随机初始密码:前 14 位从 CHARS 里取(去掉了容易看错的 0/O/o、1/l/I),末尾补一位数字和一位小写字母 */
    private static String randomPassword() {
        SecureRandom r = new SecureRandom();
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < 14; i++) {
            sb.append(CHARS.charAt(r.nextInt(CHARS.length())));
        }
        // 保证同时有字母和数字,满足密码规则
        return sb.append(r.nextInt(10)).append((char) ('a' + r.nextInt(26))).toString();
    }
}
