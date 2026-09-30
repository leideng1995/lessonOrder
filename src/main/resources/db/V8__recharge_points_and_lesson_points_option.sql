-- 1. 充值赠送积分:每充值 1 元赠送 1 积分
ALTER TABLE recharge_record
    ADD COLUMN bonus_points INT NOT NULL DEFAULT 0 COMMENT '本次充值赠送的积分' AFTER balance_after;

ALTER TABLE points_record
    MODIFY COLUMN type ENUM ('EARN', 'REDEEM', 'REFUND', 'CLAWBACK', 'RECHARGE') NOT NULL COMMENT '获得/抵扣/退回/扣回/充值赠送';

-- 2. 课程是否支持积分抵扣(默认支持,已有课程不变)
ALTER TABLE lesson
    ADD COLUMN points_enabled TINYINT(1) NOT NULL DEFAULT 1 COMMENT '是否支持积分抵扣' AFTER capacity;
