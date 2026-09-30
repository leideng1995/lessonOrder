-- 操作日志:登录/退出、所有写操作(新增、修改、删除、充值、下单、支付、退课……)、越权被拒、系统自动操作
-- 查询类请求(GET)不记录。请求内容里的密码字段一律打码为 ***
CREATE TABLE operation_log (
    log_id       BIGINT        NOT NULL AUTO_INCREMENT COMMENT '日志ID',
    category     ENUM ('LOGIN', 'OPERATION', 'DENIED', 'SYSTEM') NOT NULL COMMENT '登录/操作/越权被拒/系统',
    action       VARCHAR(50)   NOT NULL COMMENT '操作名称,如 学生充值、登录失败',
    user_id      BIGINT        NULL COMMENT '操作人(登录失败时可能为空)',
    username     VARCHAR(50)   NULL COMMENT '操作人用户名(登录失败时是尝试的用户名)',
    display_name VARCHAR(50)   NULL COMMENT '操作人姓名',
    role         VARCHAR(20)   NULL COMMENT '操作人角色',
    method       VARCHAR(10)   NULL COMMENT 'HTTP 方法',
    path         VARCHAR(200)  NULL COMMENT '请求路径',
    detail       VARCHAR(1000) NULL COMMENT '请求内容摘要(密码已打码)',
    success      TINYINT(1)    NOT NULL COMMENT '是否成功',
    status       INT           NULL COMMENT 'HTTP 状态码',
    error        VARCHAR(500)  NULL COMMENT '失败原因',
    ip           VARCHAR(45)   NULL COMMENT '客户端 IP',
    user_agent   VARCHAR(255)  NULL COMMENT '浏览器',
    duration_ms  INT           NULL COMMENT '耗时(毫秒)',
    created_at   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '时间',
    PRIMARY KEY (log_id),
    KEY idx_log_time (created_at),
    KEY idx_log_user (user_id),
    KEY idx_log_category (category, created_at)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '操作日志';
