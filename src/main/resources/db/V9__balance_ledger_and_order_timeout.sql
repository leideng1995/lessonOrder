-- 1. 余额流水:每次余额变动一条(充值、开户初始余额、支付扣款、退课退款)
CREATE TABLE balance_record (
    record_id     BIGINT         NOT NULL AUTO_INCREMENT COMMENT '记录ID',
    student_id    BIGINT         NOT NULL COMMENT '学生ID',
    order_id      BIGINT         NULL COMMENT '关联订单(订单删除后保留流水)',
    change_amount DECIMAL(10, 2) NOT NULL COMMENT '变动金额,正数增加、负数减少',
    balance_after DECIMAL(10, 2) NOT NULL COMMENT '变动后余额',
    type          ENUM ('OPENING', 'INITIAL', 'RECHARGE', 'PAY', 'REFUND') NOT NULL COMMENT '期初/开户/充值/支付/退款',
    remark        VARCHAR(200)   NULL COMMENT '说明',
    created_at    DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '时间',
    PRIMARY KEY (record_id),
    KEY idx_balance_student (student_id),
    CONSTRAINT fk_balance_student FOREIGN KEY (student_id) REFERENCES student (student_id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '余额流水';

-- 历史的支付、退款没有时间,无法准确还原顺序:给每个余额不为 0 的学生记一条"期初余额",
-- 让每个学生的流水合计从一开始就等于实际余额
INSERT INTO balance_record (student_id, change_amount, balance_after, type, remark)
SELECT student_id, balance, balance, 'OPENING', '启用余额流水时的余额'
FROM student
WHERE balance <> 0;

-- 2. 订单下单时间与取消原因(未支付订单超时自动取消)
--    已有订单的下单时间记为迁移时刻,待支付的订单从现在起重新计算支付时限
ALTER TABLE orders
    ADD COLUMN created_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '下单时间' AFTER clawed_points,
    ADD COLUMN cancel_reason VARCHAR(100) NULL COMMENT '取消原因,如超时未支付' AFTER created_at,
    ADD KEY idx_orders_pending (status, payment_status, created_at);
