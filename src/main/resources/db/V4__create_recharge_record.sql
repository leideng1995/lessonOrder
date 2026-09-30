-- 充值记录:每次充值写一条,记下金额和充值后的余额
CREATE TABLE recharge_record (
    record_id     BIGINT         NOT NULL AUTO_INCREMENT COMMENT '记录ID',
    student_id    BIGINT         NOT NULL COMMENT '学生ID',
    amount        DECIMAL(10, 2) NOT NULL COMMENT '充值金额(元)',
    balance_after DECIMAL(10, 2) NOT NULL COMMENT '充值后余额(元)',
    created_at    DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '充值时间',
    PRIMARY KEY (record_id),
    KEY idx_recharge_student (student_id),
    -- 学生被删除时,其充值记录一并删除
    CONSTRAINT fk_recharge_student FOREIGN KEY (student_id) REFERENCES student (student_id) ON DELETE CASCADE,
    CONSTRAINT chk_recharge_amount CHECK (amount > 0)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '充值记录表';
