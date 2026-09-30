-- 系统用户(后台登录账号)与角色
-- 密码只存 PBKDF2 哈希(格式 pbkdf2_sha512$迭代次数$盐$哈希),不存明文。
-- 首次启动时如果没有任何用户,程序会自动创建管理员 admin,随机初始密码只打印一次到启动日志,首次登录必须修改。
CREATE TABLE sys_user (
    user_id              BIGINT       NOT NULL AUTO_INCREMENT COMMENT '用户ID',
    username             VARCHAR(50)  NOT NULL COMMENT '登录名',
    password_hash        VARCHAR(255) NOT NULL COMMENT '密码哈希',
    display_name         VARCHAR(50)  NOT NULL COMMENT '姓名',
    role                 ENUM ('ADMIN', 'RECEPTION', 'ACADEMIC') NOT NULL COMMENT '角色:管理员/前台/教务',
    enabled              TINYINT(1)   NOT NULL DEFAULT 1 COMMENT '是否启用',
    must_change_password TINYINT(1)   NOT NULL DEFAULT 0 COMMENT '下次登录必须修改密码',
    created_at           DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    last_login_at        DATETIME     NULL COMMENT '最近登录时间',
    PRIMARY KEY (user_id),
    UNIQUE KEY uk_user_username (username)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '系统用户表';

-- 学生表 password 字段改为存哈希(已有的明文密码会在程序启动时自动转成哈希)
ALTER TABLE student MODIFY COLUMN password VARCHAR(255) NOT NULL COMMENT '密码哈希(PBKDF2)';
