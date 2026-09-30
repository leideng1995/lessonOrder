-- 积分:支付时按余额实付金额 × 2 获得积分;100 积分 = 1 元,可与余额组合支付;退课按原支付方式退回并扣回对应的已得积分

-- 1. 学生积分余额
ALTER TABLE student
    ADD COLUMN points INT NOT NULL DEFAULT 0 COMMENT '积分余额' AFTER balance,
    ADD CONSTRAINT chk_student_points CHECK (points >= 0);

-- 2. 订单的支付构成与退款构成
--    total_amount = paid_balance + paid_points / 100(已支付订单)
--    refunded_amount = refunded_balance + refunded_points / 100
ALTER TABLE orders
    ADD COLUMN paid_balance     DECIMAL(10, 2) NOT NULL DEFAULT 0.00 COMMENT '余额支付金额' AFTER refunded_amount,
    ADD COLUMN paid_points      INT            NOT NULL DEFAULT 0    COMMENT '积分支付数量' AFTER paid_balance,
    ADD COLUMN earned_points    INT            NOT NULL DEFAULT 0    COMMENT '本单获得的积分' AFTER paid_points,
    ADD COLUMN refunded_balance DECIMAL(10, 2) NOT NULL DEFAULT 0.00 COMMENT '已退回余额' AFTER earned_points,
    ADD COLUMN refunded_points  INT            NOT NULL DEFAULT 0    COMMENT '已退回积分' AFTER refunded_balance,
    ADD COLUMN clawed_points    INT            NOT NULL DEFAULT 0    COMMENT '因退课应扣回的已得积分' AFTER refunded_points;

-- 已有的已支付订单都是余额支付,不补发积分
UPDATE orders
SET paid_balance = total_amount,
    refunded_balance = refunded_amount
WHERE payment_status IN ('PAID', 'REFUNDED');

-- 3. 积分流水:每次积分变动一条
CREATE TABLE points_record (
    record_id     BIGINT       NOT NULL AUTO_INCREMENT COMMENT '记录ID',
    student_id    BIGINT       NOT NULL COMMENT '学生ID',
    order_id      BIGINT       NULL COMMENT '关联订单(订单删除后保留流水)',
    change_points INT          NOT NULL COMMENT '变动数量,正数增加、负数减少',
    balance_after INT          NOT NULL COMMENT '变动后的积分余额',
    type          ENUM ('EARN', 'REDEEM', 'REFUND', 'CLAWBACK') NOT NULL COMMENT '获得/抵扣/退回/扣回',
    remark        VARCHAR(200) NULL COMMENT '说明',
    created_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '时间',
    PRIMARY KEY (record_id),
    KEY idx_points_student (student_id),
    CONSTRAINT fk_points_student FOREIGN KEY (student_id) REFERENCES student (student_id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '积分流水';
