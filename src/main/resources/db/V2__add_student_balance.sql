-- 学生余额:支付订单时从这里扣款
ALTER TABLE student
    ADD COLUMN balance DECIMAL(10, 2) NOT NULL DEFAULT 0.00 COMMENT '账户余额(元)' AFTER date_of_birth,
    ADD CONSTRAINT chk_student_balance CHECK (balance >= 0);
