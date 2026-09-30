-- 课程排课:课程有起止日期,每天若干节(节次模板),展开成具体课次;订单一单可选多节课(订单明细)

-- 1. 课程:加起止日期;price 改为"单节价格",capacity 改为"每节名额"
ALTER TABLE lesson
    ADD COLUMN start_date DATE NULL COMMENT '开课日期' AFTER category,
    ADD COLUMN end_date   DATE NULL COMMENT '结课日期' AFTER start_date,
    ADD CONSTRAINT chk_lesson_dates CHECK (end_date >= start_date);

-- 2. 每日节次模板
CREATE TABLE lesson_period (
    period_id  BIGINT  NOT NULL AUTO_INCREMENT COMMENT '节次ID',
    lesson_id  BIGINT  NOT NULL COMMENT '课程ID',
    seq        TINYINT NOT NULL COMMENT '第几节',
    start_time TIME    NOT NULL COMMENT '开始时间',
    end_time   TIME    NOT NULL COMMENT '结束时间',
    PRIMARY KEY (period_id),
    UNIQUE KEY uk_period (lesson_id, seq),
    CONSTRAINT fk_period_lesson FOREIGN KEY (lesson_id) REFERENCES lesson (lesson_id) ON DELETE CASCADE,
    CONSTRAINT chk_period_time CHECK (end_time > start_time)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '课程每日节次';

-- 3. 课次:日期 × 节次 展开后的每一节课,名额在这一层
CREATE TABLE lesson_session (
    session_id      BIGINT   NOT NULL AUTO_INCREMENT COMMENT '课次ID',
    lesson_id       BIGINT   NOT NULL COMMENT '课程ID',
    period_id       BIGINT   NULL COMMENT '来自哪个节次模板',
    start_at        DATETIME NOT NULL COMMENT '开始时间',
    end_at          DATETIME NOT NULL COMMENT '结束时间',
    capacity        INT      NOT NULL COMMENT '名额',
    available_seats INT      NOT NULL COMMENT '剩余名额',
    status          ENUM ('SCHEDULED', 'CANCELLED') NOT NULL DEFAULT 'SCHEDULED' COMMENT '课次状态',
    PRIMARY KEY (session_id),
    UNIQUE KEY uk_session (lesson_id, start_at),
    KEY idx_session_time (start_at, end_at),
    CONSTRAINT fk_session_lesson FOREIGN KEY (lesson_id) REFERENCES lesson (lesson_id) ON DELETE CASCADE,
    CONSTRAINT fk_session_period FOREIGN KEY (period_id) REFERENCES lesson_period (period_id) ON DELETE SET NULL,
    CONSTRAINT chk_session_time CHECK (end_at > start_at),
    CONSTRAINT chk_session_seats CHECK (available_seats BETWEEN 0 AND capacity)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '课次';

-- 4. 订单头:price 改为订单金额;新增已退款金额(部分退课时累加)
--    price 上的 CHECK 约束会阻止改名,先删掉,改名后按新列重建
ALTER TABLE orders DROP CHECK chk_orders_price;
ALTER TABLE orders
    RENAME COLUMN price TO total_amount,
    ADD COLUMN refunded_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00 COMMENT '已退款金额' AFTER total_amount,
    ADD CONSTRAINT chk_orders_amount CHECK (total_amount >= 0 AND refunded_amount BETWEEN 0 AND total_amount);

-- 5. 订单明细:一单多节课,每节一行
CREATE TABLE order_item (
    item_id     BIGINT         NOT NULL AUTO_INCREMENT COMMENT '明细ID',
    order_id    BIGINT         NOT NULL COMMENT '订单ID',
    session_id  BIGINT         NOT NULL COMMENT '课次ID',
    student_id  BIGINT         NOT NULL COMMENT '学生ID(冗余自订单,用于唯一约束和时间冲突查询)',
    price       DECIMAL(10, 2) NOT NULL COMMENT '下单时的单节价格',
    status      ENUM ('ACTIVE', 'CANCELLED') NOT NULL DEFAULT 'ACTIVE' COMMENT '明细状态',
    -- 只有 ACTIVE 时为 1,取消后为 NULL;唯一索引里 NULL 互不冲突 => 同一学生同一课次只能有一条有效报名
    active_flag TINYINT GENERATED ALWAYS AS (IF(status = 'ACTIVE', 1, NULL)) STORED,
    PRIMARY KEY (item_id),
    UNIQUE KEY uk_student_session (student_id, session_id, active_flag),
    KEY idx_item_order (order_id),
    KEY idx_item_session (session_id),
    CONSTRAINT fk_item_order FOREIGN KEY (order_id) REFERENCES orders (order_id) ON DELETE CASCADE,
    CONSTRAINT fk_item_session FOREIGN KEY (session_id) REFERENCES lesson_session (session_id),
    CONSTRAINT fk_item_student FOREIGN KEY (student_id) REFERENCES student (student_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '订单明细';

-- ---------- 迁移已有数据 ----------
-- 旧订单每单对应"一节课"。同一学生对同一课程的第 k 个有效订单放到第 k 天,避免违反唯一约束。
CREATE TEMPORARY TABLE tmp_order_day AS
SELECT o.order_id,
       o.lesson_id,
       IF(o.status = 'CANCELLED', 1,
          ROW_NUMBER() OVER (PARTITION BY o.student_id, o.lesson_id, o.status = 'CANCELLED' ORDER BY o.order_id)) AS day_no
FROM orders o;

-- 旧课程:从 7 天后开始,天数 = 需要的最大 day_no;每天一节 09:00 起,时长沿用旧 duration
UPDATE lesson l
SET l.start_date = CURDATE() + INTERVAL 7 DAY,
    l.end_date   = CURDATE() + INTERVAL 7 DAY
        + INTERVAL (COALESCE((SELECT MAX(t.day_no) FROM tmp_order_day t WHERE t.lesson_id = l.lesson_id), 1) - 1) DAY;

INSERT INTO lesson_period (lesson_id, seq, start_time, end_time)
SELECT lesson_id, 1, '09:00:00', ADDTIME('09:00:00', SEC_TO_TIME(GREATEST(duration, 1) * 60))
FROM lesson;

INSERT INTO lesson_session (lesson_id, period_id, start_at, end_at, capacity, available_seats)
WITH RECURSIVE d AS (
    SELECT lesson_id, start_date AS day FROM lesson
    UNION ALL
    SELECT d.lesson_id, d.day + INTERVAL 1 DAY
    FROM d JOIN lesson l ON l.lesson_id = d.lesson_id
    WHERE d.day < l.end_date
)
SELECT d.lesson_id, p.period_id, TIMESTAMP(d.day, p.start_time), TIMESTAMP(d.day, p.end_time), l.capacity, l.capacity
FROM d
JOIN lesson l ON l.lesson_id = d.lesson_id
JOIN lesson_period p ON p.lesson_id = d.lesson_id;

INSERT INTO order_item (order_id, session_id, student_id, price, status)
SELECT o.order_id, s.session_id, o.student_id, o.total_amount, IF(o.status = 'CANCELLED', 'CANCELLED', 'ACTIVE')
FROM orders o
JOIN tmp_order_day t ON t.order_id = o.order_id
JOIN lesson l ON l.lesson_id = o.lesson_id
JOIN lesson_session s ON s.lesson_id = o.lesson_id AND DATE(s.start_at) = l.start_date + INTERVAL (t.day_no - 1) DAY;

UPDATE lesson_session s
SET s.available_seats = GREATEST(0, s.capacity - (SELECT COUNT(*) FROM order_item i
                                                   WHERE i.session_id = s.session_id AND i.status = 'ACTIVE'));

UPDATE orders SET refunded_amount = total_amount WHERE payment_status = 'REFUNDED';

DROP TEMPORARY TABLE tmp_order_day;

-- 名额和时长都下沉到课次 / 节次,旧列不再使用(先删掉引用它们的 CHECK 约束)
ALTER TABLE lesson
    DROP CHECK chk_lesson_seats,
    DROP CHECK chk_lesson_duration;
ALTER TABLE lesson
    ADD CONSTRAINT chk_lesson_capacity CHECK (capacity > 0),
    DROP COLUMN available_seats,
    DROP COLUMN duration;
