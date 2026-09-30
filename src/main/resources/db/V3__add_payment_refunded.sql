-- 支付状态新增"已退款":已支付订单取消时,金额退回学生余额
ALTER TABLE orders
    MODIFY COLUMN payment_status ENUM('UNPAID', 'PAID', 'REFUNDED') NOT NULL DEFAULT 'UNPAID' COMMENT '支付状态';
