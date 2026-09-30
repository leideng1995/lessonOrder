/*
 Navicat Premium Dump SQL

 Source Server         : local
 Source Server Type    : MySQL
 Source Server Version : 80046 (8.0.46)
 Source Host           : localhost:3306
 Source Schema         : test

 Target Server Type    : MySQL
 Target Server Version : 80046 (8.0.46)
 File Encoding         : 65001

 Date: 30/09/2026 14:24:57
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for balance_record
-- ----------------------------
DROP TABLE IF EXISTS `balance_record`;
CREATE TABLE `balance_record`  (
  `record_id` bigint NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `student_id` bigint NOT NULL COMMENT '学生ID',
  `order_id` bigint NULL DEFAULT NULL COMMENT '关联订单(订单删除后保留流水)',
  `change_amount` decimal(10, 2) NOT NULL COMMENT '变动金额,正数增加、负数减少',
  `balance_after` decimal(10, 2) NOT NULL COMMENT '变动后余额',
  `type` enum('OPENING','INITIAL','RECHARGE','PAY','REFUND') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '期初/开户/充值/支付/退款',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '说明',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '时间',
  PRIMARY KEY (`record_id`) USING BTREE,
  INDEX `idx_balance_student`(`student_id` ASC) USING BTREE,
  CONSTRAINT `fk_balance_student` FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 64 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '余额流水' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of balance_record
-- ----------------------------
INSERT INTO `balance_record` VALUES (1, 1, NULL, 1000.00, 1000.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (2, 3, NULL, 3790.00, 3790.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (3, 4, NULL, 1000.00, 1000.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (4, 5, NULL, 1200.00, 1200.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (5, 6, NULL, 200.00, 200.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (6, 7, NULL, 200.00, 200.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (7, 8, NULL, 800.00, 800.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (8, 9, NULL, 500.00, 500.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (9, 10, NULL, 3000.00, 3000.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (10, 11, NULL, 500.00, 500.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (11, 12, NULL, 2000.00, 2000.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (12, 13, NULL, 500.00, 500.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (13, 14, NULL, 3000.00, 3000.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (14, 15, NULL, 800.00, 800.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (15, 16, NULL, 3000.00, 3000.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (16, 18, NULL, 500.00, 500.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (17, 19, NULL, 3000.00, 3000.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (18, 20, NULL, 1000.00, 1000.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (19, 21, NULL, 2000.00, 2000.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (20, 22, NULL, 1500.00, 1500.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (21, 24, NULL, 3000.00, 3000.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (22, 25, NULL, 500.00, 500.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (23, 26, NULL, 500.00, 500.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (24, 27, NULL, 300.00, 300.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (25, 28, NULL, 300.00, 300.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (26, 29, NULL, 500.00, 500.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (27, 30, NULL, 1500.00, 1500.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (28, 31, NULL, 1000.00, 1000.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (29, 33, NULL, 800.00, 800.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (30, 34, NULL, 800.00, 800.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (31, 35, NULL, 1000.00, 1000.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (32, 36, NULL, 1000.00, 1000.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (33, 37, NULL, 200.00, 200.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (34, 38, NULL, 1500.00, 1500.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (35, 39, NULL, 500.00, 500.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (36, 41, NULL, 3000.00, 3000.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (37, 42, NULL, 3000.00, 3000.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (38, 43, NULL, 3000.00, 3000.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (39, 44, NULL, 2000.00, 2000.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (40, 45, NULL, 500.00, 500.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (41, 46, NULL, 1000.00, 1000.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (42, 48, NULL, 200.00, 200.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (43, 49, NULL, 300.00, 300.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (44, 50, NULL, 500.00, 500.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (45, 51, NULL, 1500.00, 1500.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (46, 52, NULL, 3000.00, 3000.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (47, 53, NULL, 800.00, 800.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (48, 54, NULL, 2000.00, 2000.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');
INSERT INTO `balance_record` VALUES (49, 55, NULL, 3890.00, 3890.00, 'OPENING', '启用余额流水时的余额', '2026-09-30 11:08:55');

-- ----------------------------
-- Table structure for lesson
-- ----------------------------
DROP TABLE IF EXISTS `lesson`;
CREATE TABLE `lesson`  (
  `lesson_id` bigint NOT NULL AUTO_INCREMENT COMMENT '课程ID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '课程标题',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '课程描述',
  `price` decimal(10, 2) NOT NULL COMMENT '课程价格',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '课程分类',
  `start_date` date NULL DEFAULT NULL COMMENT '开课日期',
  `end_date` date NULL DEFAULT NULL COMMENT '结课日期',
  `capacity` int NOT NULL COMMENT '总名额',
  `points_enabled` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否支持积分抵扣',
  PRIMARY KEY (`lesson_id`) USING BTREE,
  INDEX `idx_lesson_category`(`category` ASC) USING BTREE,
  CONSTRAINT `chk_lesson_capacity` CHECK (`capacity` > 0),
  CONSTRAINT `chk_lesson_dates` CHECK (`end_date` >= `start_date`),
  CONSTRAINT `chk_lesson_price` CHECK (`price` >= 0)
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '课程表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of lesson
-- ----------------------------
INSERT INTO `lesson` VALUES (1, 'Java入门', '基础课', 99.50, '编程', '2026-10-06', '2026-10-08', 2, 1);
INSERT INTO `lesson` VALUES (2, '英语（小学）', '基础课', 100.00, '英语', '2026-10-06', '2026-10-09', 10, 1);
INSERT INTO `lesson` VALUES (3, '数学（小学）', '基础课', 50.00, '数学', '2026-10-06', '2026-10-08', 25, 1);
INSERT INTO `lesson` VALUES (11, '数学（突击）', '突击课程', 50.00, '数学', '2026-10-06', '2026-10-08', 25, 1);
INSERT INTO `lesson` VALUES (13, '小学数学思维训练', '通过趣味题型培养数感与逻辑推理,适合 2-4 年级。', 60.00, '数学', '2026-10-12', '2026-10-23', 20, 1);
INSERT INTO `lesson` VALUES (14, '少儿英语口语', '小班情景对话,外教与中教搭配授课。', 80.00, '英语', '2026-10-12', '2026-10-30', 12, 1);
INSERT INTO `lesson` VALUES (15, 'Python 编程入门', '从变量、循环到小游戏开发,适合 10 岁以上零基础学生。', 120.00, '编程', '2026-10-19', '2026-10-30', 15, 1);
INSERT INTO `lesson` VALUES (16, 'Scratch 创意编程', '积木式编程,完成动画与互动故事作品。', 90.00, '编程', '2026-10-12', '2026-10-18', 15, 1);
INSERT INTO `lesson` VALUES (17, '语文阅读与写作', '精读绘本与短篇,练习看图写话和记叙文。', 70.00, '语文', '2026-10-13', '2026-10-24', 25, 1);
INSERT INTO `lesson` VALUES (18, '少儿素描', '线条、明暗与静物写生基础。', 75.00, '美术', '2026-10-17', '2026-10-25', 10, 1);
INSERT INTO `lesson` VALUES (19, '钢琴基础', '识谱、指法与简单曲目演奏,小班教学。', 150.00, '音乐', '2026-10-20', '2026-10-31', 6, 1);
INSERT INTO `lesson` VALUES (20, '围棋启蒙', '围棋规则、吃子与死活入门。', 65.00, '棋类', '2026-10-12', '2026-10-21', 16, 1);
INSERT INTO `lesson` VALUES (21, '小学科学实验', '动手做实验,认识力、光、电与植物生长。', 85.00, '科学', '2026-10-24', '2026-11-06', 18, 1);
INSERT INTO `lesson` VALUES (22, '奥数竞赛冲刺', '面向竞赛的专题训练与真题讲解,适合 4-6 年级。', 110.00, '数学', '2026-11-02', '2026-11-13', 20, 0);

-- ----------------------------
-- Table structure for lesson_period
-- ----------------------------
DROP TABLE IF EXISTS `lesson_period`;
CREATE TABLE `lesson_period`  (
  `period_id` bigint NOT NULL AUTO_INCREMENT COMMENT '节次ID',
  `lesson_id` bigint NOT NULL COMMENT '课程ID',
  `seq` tinyint NOT NULL COMMENT '第几节',
  `start_time` time NOT NULL COMMENT '开始时间',
  `end_time` time NOT NULL COMMENT '结束时间',
  PRIMARY KEY (`period_id`) USING BTREE,
  UNIQUE INDEX `uk_period`(`lesson_id` ASC, `seq` ASC) USING BTREE,
  CONSTRAINT `fk_period_lesson` FOREIGN KEY (`lesson_id`) REFERENCES `lesson` (`lesson_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `chk_period_time` CHECK (`end_time` > `start_time`)
) ENGINE = InnoDB AUTO_INCREMENT = 51 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '课程每日节次' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of lesson_period
-- ----------------------------
INSERT INTO `lesson_period` VALUES (1, 1, 1, '09:00:00', '10:00:00');
INSERT INTO `lesson_period` VALUES (2, 2, 1, '09:00:00', '09:45:00');
INSERT INTO `lesson_period` VALUES (3, 3, 1, '09:00:00', '09:40:00');
INSERT INTO `lesson_period` VALUES (28, 11, 1, '09:00:00', '09:40:00');
INSERT INTO `lesson_period` VALUES (29, 11, 2, '10:50:00', '11:30:00');
INSERT INTO `lesson_period` VALUES (30, 11, 3, '11:40:00', '12:20:00');
INSERT INTO `lesson_period` VALUES (31, 11, 4, '12:30:00', '13:10:00');
INSERT INTO `lesson_period` VALUES (32, 11, 5, '13:20:00', '14:00:00');
INSERT INTO `lesson_period` VALUES (35, 13, 1, '09:00:00', '10:00:00');
INSERT INTO `lesson_period` VALUES (36, 13, 2, '10:15:00', '11:15:00');
INSERT INTO `lesson_period` VALUES (37, 14, 1, '14:00:00', '14:45:00');
INSERT INTO `lesson_period` VALUES (38, 14, 2, '15:00:00', '15:45:00');
INSERT INTO `lesson_period` VALUES (39, 15, 1, '19:00:00', '20:30:00');
INSERT INTO `lesson_period` VALUES (40, 16, 1, '16:00:00', '17:00:00');
INSERT INTO `lesson_period` VALUES (41, 17, 1, '08:30:00', '09:30:00');
INSERT INTO `lesson_period` VALUES (42, 18, 1, '13:30:00', '15:00:00');
INSERT INTO `lesson_period` VALUES (43, 19, 1, '17:00:00', '17:45:00');
INSERT INTO `lesson_period` VALUES (44, 19, 2, '18:00:00', '18:45:00');
INSERT INTO `lesson_period` VALUES (45, 20, 1, '10:00:00', '11:30:00');
INSERT INTO `lesson_period` VALUES (46, 21, 1, '09:30:00', '11:00:00');
INSERT INTO `lesson_period` VALUES (49, 22, 1, '19:00:00', '20:00:00');
INSERT INTO `lesson_period` VALUES (50, 22, 2, '20:10:00', '21:10:00');

-- ----------------------------
-- Table structure for lesson_session
-- ----------------------------
DROP TABLE IF EXISTS `lesson_session`;
CREATE TABLE `lesson_session`  (
  `session_id` bigint NOT NULL AUTO_INCREMENT COMMENT '课次ID',
  `lesson_id` bigint NOT NULL COMMENT '课程ID',
  `period_id` bigint NULL DEFAULT NULL COMMENT '来自哪个节次模板',
  `start_at` datetime NOT NULL COMMENT '开始时间',
  `end_at` datetime NOT NULL COMMENT '结束时间',
  `capacity` int NOT NULL COMMENT '名额',
  `available_seats` int NOT NULL COMMENT '剩余名额',
  `status` enum('SCHEDULED','CANCELLED') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'SCHEDULED' COMMENT '课次状态',
  PRIMARY KEY (`session_id`) USING BTREE,
  UNIQUE INDEX `uk_session`(`lesson_id` ASC, `start_at` ASC) USING BTREE,
  INDEX `idx_session_time`(`start_at` ASC, `end_at` ASC) USING BTREE,
  INDEX `fk_session_period`(`period_id` ASC) USING BTREE,
  CONSTRAINT `fk_session_lesson` FOREIGN KEY (`lesson_id`) REFERENCES `lesson` (`lesson_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_session_period` FOREIGN KEY (`period_id`) REFERENCES `lesson_period` (`period_id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `chk_session_seats` CHECK (`available_seats` between 0 and `capacity`),
  CONSTRAINT `chk_session_time` CHECK (`end_at` > `start_at`)
) ENGINE = InnoDB AUTO_INCREMENT = 234 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '课次' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of lesson_session
-- ----------------------------
INSERT INTO `lesson_session` VALUES (1, 1, 1, '2026-10-06 09:00:00', '2026-10-06 10:00:00', 2, 1, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (2, 2, 2, '2026-10-06 09:00:00', '2026-10-06 09:45:00', 10, 9, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (3, 2, 2, '2026-10-07 09:00:00', '2026-10-07 09:45:00', 10, 9, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (4, 3, 3, '2026-10-06 09:00:00', '2026-10-06 09:40:00', 25, 25, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (39, 11, 28, '2026-10-06 09:00:00', '2026-10-06 09:40:00', 25, 25, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (40, 11, 29, '2026-10-06 10:50:00', '2026-10-06 11:30:00', 25, 24, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (41, 11, 30, '2026-10-06 11:40:00', '2026-10-06 12:20:00', 25, 24, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (42, 11, 31, '2026-10-06 12:30:00', '2026-10-06 13:10:00', 25, 24, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (43, 11, 32, '2026-10-06 13:20:00', '2026-10-06 14:00:00', 25, 24, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (44, 11, 28, '2026-10-07 09:00:00', '2026-10-07 09:40:00', 25, 25, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (45, 11, 29, '2026-10-07 10:50:00', '2026-10-07 11:30:00', 25, 24, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (46, 11, 30, '2026-10-07 11:40:00', '2026-10-07 12:20:00', 25, 24, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (47, 11, 31, '2026-10-07 12:30:00', '2026-10-07 13:10:00', 25, 24, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (48, 11, 32, '2026-10-07 13:20:00', '2026-10-07 14:00:00', 25, 24, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (49, 11, 28, '2026-10-08 09:00:00', '2026-10-08 09:40:00', 25, 24, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (50, 11, 29, '2026-10-08 10:50:00', '2026-10-08 11:30:00', 25, 24, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (51, 11, 30, '2026-10-08 11:40:00', '2026-10-08 12:20:00', 25, 24, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (52, 11, 31, '2026-10-08 12:30:00', '2026-10-08 13:10:00', 25, 24, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (53, 11, 32, '2026-10-08 13:20:00', '2026-10-08 14:00:00', 25, 24, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (60, 13, 35, '2026-10-12 09:00:00', '2026-10-12 10:00:00', 20, 20, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (61, 13, 36, '2026-10-12 10:15:00', '2026-10-12 11:15:00', 20, 20, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (62, 13, 35, '2026-10-13 09:00:00', '2026-10-13 10:00:00', 20, 20, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (63, 13, 36, '2026-10-13 10:15:00', '2026-10-13 11:15:00', 20, 20, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (64, 13, 35, '2026-10-14 09:00:00', '2026-10-14 10:00:00', 20, 20, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (65, 13, 36, '2026-10-14 10:15:00', '2026-10-14 11:15:00', 20, 20, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (66, 13, 35, '2026-10-15 09:00:00', '2026-10-15 10:00:00', 20, 20, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (67, 13, 36, '2026-10-15 10:15:00', '2026-10-15 11:15:00', 20, 20, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (68, 13, 35, '2026-10-16 09:00:00', '2026-10-16 10:00:00', 20, 20, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (69, 13, 36, '2026-10-16 10:15:00', '2026-10-16 11:15:00', 20, 20, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (70, 13, 35, '2026-10-17 09:00:00', '2026-10-17 10:00:00', 20, 20, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (71, 13, 36, '2026-10-17 10:15:00', '2026-10-17 11:15:00', 20, 20, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (72, 13, 35, '2026-10-18 09:00:00', '2026-10-18 10:00:00', 20, 20, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (73, 13, 36, '2026-10-18 10:15:00', '2026-10-18 11:15:00', 20, 20, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (74, 13, 35, '2026-10-19 09:00:00', '2026-10-19 10:00:00', 20, 20, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (75, 13, 36, '2026-10-19 10:15:00', '2026-10-19 11:15:00', 20, 20, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (76, 13, 35, '2026-10-20 09:00:00', '2026-10-20 10:00:00', 20, 20, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (77, 13, 36, '2026-10-20 10:15:00', '2026-10-20 11:15:00', 20, 20, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (78, 13, 35, '2026-10-21 09:00:00', '2026-10-21 10:00:00', 20, 20, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (79, 13, 36, '2026-10-21 10:15:00', '2026-10-21 11:15:00', 20, 20, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (80, 13, 35, '2026-10-22 09:00:00', '2026-10-22 10:00:00', 20, 20, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (81, 13, 36, '2026-10-22 10:15:00', '2026-10-22 11:15:00', 20, 20, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (82, 13, 35, '2026-10-23 09:00:00', '2026-10-23 10:00:00', 20, 20, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (83, 13, 36, '2026-10-23 10:15:00', '2026-10-23 11:15:00', 20, 20, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (84, 14, 37, '2026-10-12 14:00:00', '2026-10-12 14:45:00', 12, 12, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (85, 14, 38, '2026-10-12 15:00:00', '2026-10-12 15:45:00', 12, 12, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (86, 14, 37, '2026-10-13 14:00:00', '2026-10-13 14:45:00', 12, 12, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (87, 14, 38, '2026-10-13 15:00:00', '2026-10-13 15:45:00', 12, 12, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (88, 14, 37, '2026-10-14 14:00:00', '2026-10-14 14:45:00', 12, 12, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (89, 14, 38, '2026-10-14 15:00:00', '2026-10-14 15:45:00', 12, 12, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (90, 14, 37, '2026-10-15 14:00:00', '2026-10-15 14:45:00', 12, 12, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (91, 14, 38, '2026-10-15 15:00:00', '2026-10-15 15:45:00', 12, 12, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (92, 14, 37, '2026-10-16 14:00:00', '2026-10-16 14:45:00', 12, 12, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (93, 14, 38, '2026-10-16 15:00:00', '2026-10-16 15:45:00', 12, 12, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (94, 14, 37, '2026-10-17 14:00:00', '2026-10-17 14:45:00', 12, 12, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (95, 14, 38, '2026-10-17 15:00:00', '2026-10-17 15:45:00', 12, 12, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (96, 14, 37, '2026-10-18 14:00:00', '2026-10-18 14:45:00', 12, 12, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (97, 14, 38, '2026-10-18 15:00:00', '2026-10-18 15:45:00', 12, 12, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (98, 14, 37, '2026-10-19 14:00:00', '2026-10-19 14:45:00', 12, 12, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (99, 14, 38, '2026-10-19 15:00:00', '2026-10-19 15:45:00', 12, 12, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (100, 14, 37, '2026-10-20 14:00:00', '2026-10-20 14:45:00', 12, 12, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (101, 14, 38, '2026-10-20 15:00:00', '2026-10-20 15:45:00', 12, 12, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (102, 14, 37, '2026-10-21 14:00:00', '2026-10-21 14:45:00', 12, 12, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (103, 14, 38, '2026-10-21 15:00:00', '2026-10-21 15:45:00', 12, 12, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (104, 14, 37, '2026-10-22 14:00:00', '2026-10-22 14:45:00', 12, 12, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (105, 14, 38, '2026-10-22 15:00:00', '2026-10-22 15:45:00', 12, 12, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (106, 14, 37, '2026-10-23 14:00:00', '2026-10-23 14:45:00', 12, 12, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (107, 14, 38, '2026-10-23 15:00:00', '2026-10-23 15:45:00', 12, 12, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (108, 14, 37, '2026-10-24 14:00:00', '2026-10-24 14:45:00', 12, 12, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (109, 14, 38, '2026-10-24 15:00:00', '2026-10-24 15:45:00', 12, 12, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (110, 14, 37, '2026-10-25 14:00:00', '2026-10-25 14:45:00', 12, 12, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (111, 14, 38, '2026-10-25 15:00:00', '2026-10-25 15:45:00', 12, 12, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (112, 14, 37, '2026-10-26 14:00:00', '2026-10-26 14:45:00', 12, 12, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (113, 14, 38, '2026-10-26 15:00:00', '2026-10-26 15:45:00', 12, 12, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (114, 14, 37, '2026-10-27 14:00:00', '2026-10-27 14:45:00', 12, 12, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (115, 14, 38, '2026-10-27 15:00:00', '2026-10-27 15:45:00', 12, 12, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (116, 14, 37, '2026-10-28 14:00:00', '2026-10-28 14:45:00', 12, 12, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (117, 14, 38, '2026-10-28 15:00:00', '2026-10-28 15:45:00', 12, 12, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (118, 14, 37, '2026-10-29 14:00:00', '2026-10-29 14:45:00', 12, 12, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (119, 14, 38, '2026-10-29 15:00:00', '2026-10-29 15:45:00', 12, 12, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (120, 14, 37, '2026-10-30 14:00:00', '2026-10-30 14:45:00', 12, 12, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (121, 14, 38, '2026-10-30 15:00:00', '2026-10-30 15:45:00', 12, 12, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (122, 15, 39, '2026-10-19 19:00:00', '2026-10-19 20:30:00', 15, 14, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (123, 15, 39, '2026-10-20 19:00:00', '2026-10-20 20:30:00', 15, 15, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (124, 15, 39, '2026-10-21 19:00:00', '2026-10-21 20:30:00', 15, 15, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (125, 15, 39, '2026-10-22 19:00:00', '2026-10-22 20:30:00', 15, 15, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (126, 15, 39, '2026-10-23 19:00:00', '2026-10-23 20:30:00', 15, 15, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (127, 15, 39, '2026-10-24 19:00:00', '2026-10-24 20:30:00', 15, 15, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (128, 15, 39, '2026-10-25 19:00:00', '2026-10-25 20:30:00', 15, 15, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (129, 15, 39, '2026-10-26 19:00:00', '2026-10-26 20:30:00', 15, 15, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (130, 15, 39, '2026-10-27 19:00:00', '2026-10-27 20:30:00', 15, 15, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (131, 15, 39, '2026-10-28 19:00:00', '2026-10-28 20:30:00', 15, 15, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (132, 15, 39, '2026-10-29 19:00:00', '2026-10-29 20:30:00', 15, 15, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (133, 15, 39, '2026-10-30 19:00:00', '2026-10-30 20:30:00', 15, 15, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (134, 16, 40, '2026-10-12 16:00:00', '2026-10-12 17:00:00', 15, 15, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (135, 16, 40, '2026-10-13 16:00:00', '2026-10-13 17:00:00', 15, 15, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (136, 16, 40, '2026-10-14 16:00:00', '2026-10-14 17:00:00', 15, 15, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (137, 16, 40, '2026-10-15 16:00:00', '2026-10-15 17:00:00', 15, 15, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (138, 16, 40, '2026-10-16 16:00:00', '2026-10-16 17:00:00', 15, 15, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (139, 16, 40, '2026-10-17 16:00:00', '2026-10-17 17:00:00', 15, 15, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (140, 16, 40, '2026-10-18 16:00:00', '2026-10-18 17:00:00', 15, 15, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (141, 17, 41, '2026-10-13 08:30:00', '2026-10-13 09:30:00', 25, 25, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (142, 17, 41, '2026-10-14 08:30:00', '2026-10-14 09:30:00', 25, 25, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (143, 17, 41, '2026-10-15 08:30:00', '2026-10-15 09:30:00', 25, 25, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (144, 17, 41, '2026-10-16 08:30:00', '2026-10-16 09:30:00', 25, 25, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (145, 17, 41, '2026-10-17 08:30:00', '2026-10-17 09:30:00', 25, 25, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (146, 17, 41, '2026-10-18 08:30:00', '2026-10-18 09:30:00', 25, 25, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (147, 17, 41, '2026-10-19 08:30:00', '2026-10-19 09:30:00', 25, 25, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (148, 17, 41, '2026-10-20 08:30:00', '2026-10-20 09:30:00', 25, 25, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (149, 17, 41, '2026-10-21 08:30:00', '2026-10-21 09:30:00', 25, 25, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (150, 17, 41, '2026-10-22 08:30:00', '2026-10-22 09:30:00', 25, 25, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (151, 17, 41, '2026-10-23 08:30:00', '2026-10-23 09:30:00', 25, 25, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (152, 17, 41, '2026-10-24 08:30:00', '2026-10-24 09:30:00', 25, 25, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (153, 18, 42, '2026-10-17 13:30:00', '2026-10-17 15:00:00', 10, 10, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (154, 18, 42, '2026-10-18 13:30:00', '2026-10-18 15:00:00', 10, 10, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (155, 18, 42, '2026-10-19 13:30:00', '2026-10-19 15:00:00', 10, 10, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (156, 18, 42, '2026-10-20 13:30:00', '2026-10-20 15:00:00', 10, 10, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (157, 18, 42, '2026-10-21 13:30:00', '2026-10-21 15:00:00', 10, 10, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (158, 18, 42, '2026-10-22 13:30:00', '2026-10-22 15:00:00', 10, 10, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (159, 18, 42, '2026-10-23 13:30:00', '2026-10-23 15:00:00', 10, 10, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (160, 18, 42, '2026-10-24 13:30:00', '2026-10-24 15:00:00', 10, 10, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (161, 18, 42, '2026-10-25 13:30:00', '2026-10-25 15:00:00', 10, 10, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (162, 19, 43, '2026-10-20 17:00:00', '2026-10-20 17:45:00', 6, 5, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (163, 19, 44, '2026-10-20 18:00:00', '2026-10-20 18:45:00', 6, 5, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (164, 19, 43, '2026-10-21 17:00:00', '2026-10-21 17:45:00', 6, 5, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (165, 19, 44, '2026-10-21 18:00:00', '2026-10-21 18:45:00', 6, 5, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (166, 19, 43, '2026-10-22 17:00:00', '2026-10-22 17:45:00', 6, 5, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (167, 19, 44, '2026-10-22 18:00:00', '2026-10-22 18:45:00', 6, 5, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (168, 19, 43, '2026-10-23 17:00:00', '2026-10-23 17:45:00', 6, 5, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (169, 19, 44, '2026-10-23 18:00:00', '2026-10-23 18:45:00', 6, 5, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (170, 19, 43, '2026-10-24 17:00:00', '2026-10-24 17:45:00', 6, 5, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (171, 19, 44, '2026-10-24 18:00:00', '2026-10-24 18:45:00', 6, 5, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (172, 19, 43, '2026-10-25 17:00:00', '2026-10-25 17:45:00', 6, 5, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (173, 19, 44, '2026-10-25 18:00:00', '2026-10-25 18:45:00', 6, 5, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (174, 19, 43, '2026-10-26 17:00:00', '2026-10-26 17:45:00', 6, 5, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (175, 19, 44, '2026-10-26 18:00:00', '2026-10-26 18:45:00', 6, 5, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (176, 19, 43, '2026-10-27 17:00:00', '2026-10-27 17:45:00', 6, 5, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (177, 19, 44, '2026-10-27 18:00:00', '2026-10-27 18:45:00', 6, 5, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (178, 19, 43, '2026-10-28 17:00:00', '2026-10-28 17:45:00', 6, 5, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (179, 19, 44, '2026-10-28 18:00:00', '2026-10-28 18:45:00', 6, 5, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (180, 19, 43, '2026-10-29 17:00:00', '2026-10-29 17:45:00', 6, 5, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (181, 19, 44, '2026-10-29 18:00:00', '2026-10-29 18:45:00', 6, 5, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (182, 19, 43, '2026-10-30 17:00:00', '2026-10-30 17:45:00', 6, 5, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (183, 19, 44, '2026-10-30 18:00:00', '2026-10-30 18:45:00', 6, 5, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (184, 19, 43, '2026-10-31 17:00:00', '2026-10-31 17:45:00', 6, 5, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (185, 19, 44, '2026-10-31 18:00:00', '2026-10-31 18:45:00', 6, 5, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (186, 20, 45, '2026-10-12 10:00:00', '2026-10-12 11:30:00', 16, 16, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (187, 20, 45, '2026-10-13 10:00:00', '2026-10-13 11:30:00', 16, 16, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (188, 20, 45, '2026-10-14 10:00:00', '2026-10-14 11:30:00', 16, 16, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (189, 20, 45, '2026-10-15 10:00:00', '2026-10-15 11:30:00', 16, 16, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (190, 20, 45, '2026-10-16 10:00:00', '2026-10-16 11:30:00', 16, 16, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (191, 20, 45, '2026-10-17 10:00:00', '2026-10-17 11:30:00', 16, 16, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (192, 20, 45, '2026-10-18 10:00:00', '2026-10-18 11:30:00', 16, 16, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (193, 20, 45, '2026-10-19 10:00:00', '2026-10-19 11:30:00', 16, 16, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (194, 20, 45, '2026-10-20 10:00:00', '2026-10-20 11:30:00', 16, 16, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (195, 20, 45, '2026-10-21 10:00:00', '2026-10-21 11:30:00', 16, 16, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (196, 21, 46, '2026-10-24 09:30:00', '2026-10-24 11:00:00', 18, 18, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (197, 21, 46, '2026-10-25 09:30:00', '2026-10-25 11:00:00', 18, 18, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (198, 21, 46, '2026-10-26 09:30:00', '2026-10-26 11:00:00', 18, 18, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (199, 21, 46, '2026-10-27 09:30:00', '2026-10-27 11:00:00', 18, 18, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (200, 21, 46, '2026-10-28 09:30:00', '2026-10-28 11:00:00', 18, 18, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (201, 21, 46, '2026-10-29 09:30:00', '2026-10-29 11:00:00', 18, 18, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (202, 21, 46, '2026-10-30 09:30:00', '2026-10-30 11:00:00', 18, 18, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (203, 21, 46, '2026-10-31 09:30:00', '2026-10-31 11:00:00', 18, 18, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (204, 21, 46, '2026-11-01 09:30:00', '2026-11-01 11:00:00', 18, 18, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (205, 21, 46, '2026-11-02 09:30:00', '2026-11-02 11:00:00', 18, 18, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (206, 21, 46, '2026-11-03 09:30:00', '2026-11-03 11:00:00', 18, 18, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (207, 21, 46, '2026-11-04 09:30:00', '2026-11-04 11:00:00', 18, 18, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (208, 21, 46, '2026-11-05 09:30:00', '2026-11-05 11:00:00', 18, 18, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (209, 21, 46, '2026-11-06 09:30:00', '2026-11-06 11:00:00', 18, 18, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (210, 22, 49, '2026-11-02 19:00:00', '2026-11-02 20:00:00', 20, 18, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (211, 22, 50, '2026-11-02 20:10:00', '2026-11-02 21:10:00', 20, 19, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (212, 22, 49, '2026-11-03 19:00:00', '2026-11-03 20:00:00', 20, 19, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (213, 22, 50, '2026-11-03 20:10:00', '2026-11-03 21:10:00', 20, 19, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (214, 22, 49, '2026-11-04 19:00:00', '2026-11-04 20:00:00', 20, 19, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (215, 22, 50, '2026-11-04 20:10:00', '2026-11-04 21:10:00', 20, 19, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (216, 22, 49, '2026-11-05 19:00:00', '2026-11-05 20:00:00', 20, 19, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (217, 22, 50, '2026-11-05 20:10:00', '2026-11-05 21:10:00', 20, 19, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (218, 22, 49, '2026-11-06 19:00:00', '2026-11-06 20:00:00', 20, 19, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (219, 22, 50, '2026-11-06 20:10:00', '2026-11-06 21:10:00', 20, 19, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (220, 22, 49, '2026-11-07 19:00:00', '2026-11-07 20:00:00', 20, 19, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (221, 22, 50, '2026-11-07 20:10:00', '2026-11-07 21:10:00', 20, 19, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (222, 22, 49, '2026-11-08 19:00:00', '2026-11-08 20:00:00', 20, 19, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (223, 22, 50, '2026-11-08 20:10:00', '2026-11-08 21:10:00', 20, 19, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (224, 22, 49, '2026-11-09 19:00:00', '2026-11-09 20:00:00', 20, 19, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (225, 22, 50, '2026-11-09 20:10:00', '2026-11-09 21:10:00', 20, 19, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (226, 22, 49, '2026-11-10 19:00:00', '2026-11-10 20:00:00', 20, 19, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (227, 22, 50, '2026-11-10 20:10:00', '2026-11-10 21:10:00', 20, 19, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (228, 22, 49, '2026-11-11 19:00:00', '2026-11-11 20:00:00', 20, 19, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (229, 22, 50, '2026-11-11 20:10:00', '2026-11-11 21:10:00', 20, 19, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (230, 22, 49, '2026-11-12 19:00:00', '2026-11-12 20:00:00', 20, 19, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (231, 22, 50, '2026-11-12 20:10:00', '2026-11-12 21:10:00', 20, 19, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (232, 22, 49, '2026-11-13 19:00:00', '2026-11-13 20:00:00', 20, 19, 'SCHEDULED');
INSERT INTO `lesson_session` VALUES (233, 22, 50, '2026-11-13 20:10:00', '2026-11-13 21:10:00', 20, 19, 'SCHEDULED');

-- ----------------------------
-- Table structure for operation_log
-- ----------------------------
DROP TABLE IF EXISTS `operation_log`;
CREATE TABLE `operation_log`  (
  `log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `category` enum('LOGIN','OPERATION','DENIED','SYSTEM') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '登录/操作/越权被拒/系统',
  `action` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '操作名称,如 学生充值、登录失败',
  `user_id` bigint NULL DEFAULT NULL COMMENT '操作人(登录失败时可能为空)',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '操作人用户名(登录失败时是尝试的用户名)',
  `display_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '操作人姓名',
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '操作人角色',
  `method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'HTTP 方法',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '请求路径',
  `detail` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '请求内容摘要(密码已打码)',
  `success` tinyint(1) NOT NULL COMMENT '是否成功',
  `status` int NULL DEFAULT NULL COMMENT 'HTTP 状态码',
  `error` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '失败原因',
  `ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '客户端 IP',
  `user_agent` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '浏览器',
  `duration_ms` int NULL DEFAULT NULL COMMENT '耗时(毫秒)',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '时间',
  PRIMARY KEY (`log_id`) USING BTREE,
  INDEX `idx_log_time`(`created_at` ASC) USING BTREE,
  INDEX `idx_log_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_log_category`(`category` ASC, `created_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '操作日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of operation_log
-- ----------------------------
INSERT INTO `operation_log` VALUES (1, 'LOGIN', '登录', 1, 'admin', '系统管理员', '管理员', 'POST', '/api/auth/login', NULL, 1, 200, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', NULL, '2026-09-30 11:27:47');
INSERT INTO `operation_log` VALUES (2, 'LOGIN', '退出登录', 1, 'admin', '系统管理员', '管理员', 'POST', '/api/auth/logout', NULL, 1, 204, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', 7, '2026-09-30 11:28:20');
INSERT INTO `operation_log` VALUES (3, 'LOGIN', '登录失败', 1, 'admin', '系统管理员', '管理员', 'POST', '/api/auth/login', NULL, 0, NULL, '密码错误', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', NULL, '2026-09-30 11:28:26');
INSERT INTO `operation_log` VALUES (4, 'LOGIN', '登录失败', NULL, 'dltest', NULL, NULL, 'POST', '/api/auth/login', NULL, 0, NULL, '用户名不存在', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', NULL, '2026-09-30 11:28:33');
INSERT INTO `operation_log` VALUES (5, 'LOGIN', '登录', 1, 'admin', '系统管理员', '管理员', 'POST', '/api/auth/login', NULL, 1, 200, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', NULL, '2026-09-30 11:28:42');
INSERT INTO `operation_log` VALUES (6, 'OPERATION', '下单', 1, 'admin', '系统管理员', '管理员', 'POST', '/api/orders', '{\"studentId\":3,\"lessonId\":14,\"sessionIds\":[84]}', 1, 201, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', 493, '2026-09-30 11:56:18');
INSERT INTO `operation_log` VALUES (7, 'SYSTEM', '超时自动取消订单', NULL, 'system', '系统', NULL, NULL, NULL, '订单 #17 下单后 30 分钟未支付,已取消并归还名额', 1, NULL, NULL, NULL, NULL, NULL, '2026-09-30 12:26:35');

-- ----------------------------
-- Table structure for order_item
-- ----------------------------
DROP TABLE IF EXISTS `order_item`;
CREATE TABLE `order_item`  (
  `item_id` bigint NOT NULL AUTO_INCREMENT COMMENT '明细ID',
  `order_id` bigint NOT NULL COMMENT '订单ID',
  `session_id` bigint NOT NULL COMMENT '课次ID',
  `student_id` bigint NOT NULL COMMENT '学生ID(冗余自订单,用于唯一约束和时间冲突查询)',
  `price` decimal(10, 2) NOT NULL COMMENT '下单时的单节价格',
  `status` enum('ACTIVE','CANCELLED') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'ACTIVE' COMMENT '明细状态',
  `active_flag` tinyint GENERATED ALWAYS AS (if((`status` = _utf8mb4'ACTIVE'),1,NULL)) STORED NULL,
  PRIMARY KEY (`item_id`) USING BTREE,
  UNIQUE INDEX `uk_student_session`(`student_id` ASC, `session_id` ASC, `active_flag` ASC) USING BTREE,
  INDEX `idx_item_order`(`order_id` ASC) USING BTREE,
  INDEX `idx_item_session`(`session_id` ASC) USING BTREE,
  CONSTRAINT `fk_item_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_item_session` FOREIGN KEY (`session_id`) REFERENCES `lesson_session` (`session_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_item_student` FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 87 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '订单明细' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order_item
-- ----------------------------
INSERT INTO `order_item` VALUES (1, 1, 1, 1, 99.50, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (2, 3, 2, 3, 100.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (3, 5, 3, 3, 100.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (4, 4, 4, 3, 50.00, 'CANCELLED', DEFAULT);
INSERT INTO `order_item` VALUES (19, 11, 40, 3, 50.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (20, 11, 41, 3, 50.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (21, 11, 42, 3, 50.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (22, 11, 43, 3, 50.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (23, 11, 45, 3, 50.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (24, 11, 46, 3, 50.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (25, 11, 47, 3, 50.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (26, 11, 48, 3, 50.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (27, 11, 49, 3, 50.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (28, 11, 50, 3, 50.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (29, 11, 51, 3, 50.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (30, 11, 52, 3, 50.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (31, 11, 53, 3, 50.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (36, 13, 162, 3, 150.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (37, 13, 163, 3, 150.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (38, 13, 164, 3, 150.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (39, 13, 165, 3, 150.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (40, 13, 166, 3, 150.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (41, 13, 167, 3, 150.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (42, 13, 168, 3, 150.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (43, 13, 169, 3, 150.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (44, 13, 170, 3, 150.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (45, 13, 171, 3, 150.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (46, 13, 172, 3, 150.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (47, 13, 173, 3, 150.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (48, 13, 174, 3, 150.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (49, 13, 175, 3, 150.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (50, 13, 176, 3, 150.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (51, 13, 177, 3, 150.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (52, 13, 178, 3, 150.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (53, 13, 179, 3, 150.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (54, 13, 180, 3, 150.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (55, 13, 181, 3, 150.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (56, 13, 182, 3, 150.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (57, 13, 183, 3, 150.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (58, 13, 184, 3, 150.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (59, 13, 185, 3, 150.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (60, 14, 210, 3, 110.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (61, 14, 211, 3, 110.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (62, 14, 212, 3, 110.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (63, 14, 213, 3, 110.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (64, 14, 214, 3, 110.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (65, 14, 215, 3, 110.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (66, 14, 216, 3, 110.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (67, 14, 217, 3, 110.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (68, 14, 218, 3, 110.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (69, 14, 219, 3, 110.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (70, 14, 220, 3, 110.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (71, 14, 221, 3, 110.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (72, 14, 222, 3, 110.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (73, 14, 223, 3, 110.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (74, 14, 224, 3, 110.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (75, 14, 225, 3, 110.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (76, 14, 226, 3, 110.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (77, 14, 227, 3, 110.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (78, 14, 228, 3, 110.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (79, 14, 229, 3, 110.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (80, 14, 230, 3, 110.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (81, 14, 231, 3, 110.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (82, 14, 232, 3, 110.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (83, 14, 233, 3, 110.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (84, 15, 122, 3, 120.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (85, 16, 210, 55, 110.00, 'ACTIVE', DEFAULT);
INSERT INTO `order_item` VALUES (86, 17, 84, 3, 80.00, 'CANCELLED', DEFAULT);

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders`  (
  `order_id` bigint NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `student_id` bigint NOT NULL COMMENT '学生ID',
  `lesson_id` bigint NOT NULL COMMENT '课程ID',
  `total_amount` decimal(10, 2) NOT NULL COMMENT '下单时成交价(快照,不随课程调价变化)',
  `refunded_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '已退款金额',
  `paid_balance` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '余额支付金额',
  `paid_points` int NOT NULL DEFAULT 0 COMMENT '积分支付数量',
  `earned_points` int NOT NULL DEFAULT 0 COMMENT '本单获得的积分',
  `refunded_balance` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '已退回余额',
  `refunded_points` int NOT NULL DEFAULT 0 COMMENT '已退回积分',
  `clawed_points` int NOT NULL DEFAULT 0 COMMENT '因退课应扣回的已得积分',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '下单时间',
  `cancel_reason` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '取消原因,如超时未支付',
  `status` enum('PENDING','CONFIRMED','CANCELLED') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'PENDING' COMMENT '订单状态',
  `payment_status` enum('UNPAID','PAID','REFUNDED') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'UNPAID' COMMENT '支付状态',
  PRIMARY KEY (`order_id`) USING BTREE,
  INDEX `idx_orders_student`(`student_id` ASC) USING BTREE,
  INDEX `idx_orders_lesson`(`lesson_id` ASC) USING BTREE,
  INDEX `idx_orders_pending`(`status` ASC, `payment_status` ASC, `created_at` ASC) USING BTREE,
  CONSTRAINT `fk_orders_lesson` FOREIGN KEY (`lesson_id`) REFERENCES `lesson` (`lesson_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_orders_student` FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_orders_amount` CHECK ((`total_amount` >= 0) and (`refunded_amount` between 0 and `total_amount`))
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '订单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of orders
-- ----------------------------
INSERT INTO `orders` VALUES (1, 1, 1, 99.50, 0.00, 99.50, 0, 0, 0.00, 0, 0, '2026-09-30 11:08:55', NULL, 'CONFIRMED', 'PAID');
INSERT INTO `orders` VALUES (3, 3, 2, 100.00, 0.00, 100.00, 0, 0, 0.00, 0, 0, '2026-09-30 11:08:55', NULL, 'CONFIRMED', 'PAID');
INSERT INTO `orders` VALUES (4, 3, 3, 50.00, 50.00, 50.00, 0, 0, 50.00, 0, 0, '2026-09-30 11:08:55', NULL, 'CANCELLED', 'REFUNDED');
INSERT INTO `orders` VALUES (5, 3, 2, 100.00, 0.00, 100.00, 0, 0, 0.00, 0, 0, '2026-09-30 11:08:55', NULL, 'CONFIRMED', 'PAID');
INSERT INTO `orders` VALUES (11, 3, 11, 650.00, 0.00, 650.00, 0, 0, 0.00, 0, 0, '2026-09-30 11:08:55', NULL, 'CONFIRMED', 'PAID');
INSERT INTO `orders` VALUES (13, 3, 19, 3600.00, 0.00, 3600.00, 0, 0, 0.00, 0, 0, '2026-09-30 11:08:55', NULL, 'CONFIRMED', 'PAID');
INSERT INTO `orders` VALUES (14, 3, 22, 2640.00, 0.00, 2640.00, 0, 5280, 0.00, 0, 0, '2026-09-30 11:08:55', NULL, 'CONFIRMED', 'PAID');
INSERT INTO `orders` VALUES (15, 3, 15, 120.00, 0.00, 120.00, 0, 240, 0.00, 0, 0, '2026-09-30 11:08:55', NULL, 'CONFIRMED', 'PAID');
INSERT INTO `orders` VALUES (16, 55, 22, 110.00, 0.00, 110.00, 0, 220, 0.00, 0, 0, '2026-09-30 11:08:55', NULL, 'CONFIRMED', 'PAID');
INSERT INTO `orders` VALUES (17, 3, 14, 0.00, 0.00, 0.00, 0, 0, 0.00, 0, 0, '2026-09-30 11:56:18', '超时未支付(下单后 30 分钟),系统自动取消', 'CANCELLED', 'UNPAID');

-- ----------------------------
-- Table structure for points_record
-- ----------------------------
DROP TABLE IF EXISTS `points_record`;
CREATE TABLE `points_record`  (
  `record_id` bigint NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `student_id` bigint NOT NULL COMMENT '学生ID',
  `order_id` bigint NULL DEFAULT NULL COMMENT '关联订单(订单删除后保留流水)',
  `change_points` int NOT NULL COMMENT '变动数量,正数增加、负数减少',
  `balance_after` int NOT NULL COMMENT '变动后的积分余额',
  `type` enum('EARN','REDEEM','REFUND','CLAWBACK','RECHARGE') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '获得/抵扣/退回/扣回/充值赠送',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '说明',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '时间',
  PRIMARY KEY (`record_id`) USING BTREE,
  INDEX `idx_points_student`(`student_id` ASC) USING BTREE,
  CONSTRAINT `fk_points_student` FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '积分流水' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of points_record
-- ----------------------------
INSERT INTO `points_record` VALUES (1, 3, 14, 5280, 5280, 'EARN', '订单 #14 余额实付 ¥2640.00', '2026-09-30 10:39:24');
INSERT INTO `points_record` VALUES (2, 55, NULL, 1000, 1000, 'RECHARGE', '充值 ¥1000 赠送', '2026-09-30 10:50:09');
INSERT INTO `points_record` VALUES (3, 3, 15, 240, 5520, 'EARN', '订单 #15 余额实付 ¥120.00', '2026-09-30 10:50:54');
INSERT INTO `points_record` VALUES (4, 55, 16, 220, 1220, 'EARN', '订单 #16 余额实付 ¥110.00', '2026-09-30 10:51:30');

-- ----------------------------
-- Table structure for recharge_record
-- ----------------------------
DROP TABLE IF EXISTS `recharge_record`;
CREATE TABLE `recharge_record`  (
  `record_id` bigint NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `student_id` bigint NOT NULL COMMENT '学生ID',
  `amount` decimal(10, 2) NOT NULL COMMENT '充值金额(元)',
  `balance_after` decimal(10, 2) NOT NULL COMMENT '充值后余额(元)',
  `bonus_points` int NOT NULL DEFAULT 0 COMMENT '本次充值赠送的积分',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '充值时间',
  PRIMARY KEY (`record_id`) USING BTREE,
  INDEX `idx_recharge_student`(`student_id` ASC) USING BTREE,
  CONSTRAINT `fk_recharge_student` FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `chk_recharge_amount` CHECK (`amount` > 0)
) ENGINE = InnoDB AUTO_INCREMENT = 48 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '充值记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of recharge_record
-- ----------------------------
INSERT INTO `recharge_record` VALUES (1, 5, 200.00, 1200.00, 0, '2026-09-29 17:05:13');
INSERT INTO `recharge_record` VALUES (2, 6, 200.00, 200.00, 0, '2026-09-29 17:56:29');
INSERT INTO `recharge_record` VALUES (3, 7, 200.00, 200.00, 0, '2026-09-29 17:56:29');
INSERT INTO `recharge_record` VALUES (4, 8, 800.00, 800.00, 0, '2026-09-29 17:56:29');
INSERT INTO `recharge_record` VALUES (5, 9, 500.00, 500.00, 0, '2026-09-29 17:56:29');
INSERT INTO `recharge_record` VALUES (6, 10, 3000.00, 3000.00, 0, '2026-09-29 17:56:29');
INSERT INTO `recharge_record` VALUES (7, 11, 500.00, 500.00, 0, '2026-09-29 17:56:29');
INSERT INTO `recharge_record` VALUES (8, 12, 2000.00, 2000.00, 0, '2026-09-29 17:56:30');
INSERT INTO `recharge_record` VALUES (9, 13, 500.00, 500.00, 0, '2026-09-29 17:56:30');
INSERT INTO `recharge_record` VALUES (10, 14, 3000.00, 3000.00, 0, '2026-09-29 17:56:30');
INSERT INTO `recharge_record` VALUES (11, 15, 800.00, 800.00, 0, '2026-09-29 17:56:30');
INSERT INTO `recharge_record` VALUES (12, 16, 3000.00, 3000.00, 0, '2026-09-29 17:56:30');
INSERT INTO `recharge_record` VALUES (13, 18, 500.00, 500.00, 0, '2026-09-29 17:56:30');
INSERT INTO `recharge_record` VALUES (14, 19, 3000.00, 3000.00, 0, '2026-09-29 17:56:30');
INSERT INTO `recharge_record` VALUES (15, 20, 1000.00, 1000.00, 0, '2026-09-29 17:56:30');
INSERT INTO `recharge_record` VALUES (16, 21, 2000.00, 2000.00, 0, '2026-09-29 17:56:30');
INSERT INTO `recharge_record` VALUES (17, 22, 1500.00, 1500.00, 0, '2026-09-29 17:56:30');
INSERT INTO `recharge_record` VALUES (18, 24, 3000.00, 3000.00, 0, '2026-09-29 17:56:30');
INSERT INTO `recharge_record` VALUES (19, 25, 500.00, 500.00, 0, '2026-09-29 17:56:30');
INSERT INTO `recharge_record` VALUES (20, 26, 500.00, 500.00, 0, '2026-09-29 17:56:30');
INSERT INTO `recharge_record` VALUES (21, 27, 300.00, 300.00, 0, '2026-09-29 17:56:30');
INSERT INTO `recharge_record` VALUES (22, 28, 300.00, 300.00, 0, '2026-09-29 17:56:30');
INSERT INTO `recharge_record` VALUES (23, 29, 500.00, 500.00, 0, '2026-09-29 17:56:30');
INSERT INTO `recharge_record` VALUES (24, 30, 1500.00, 1500.00, 0, '2026-09-29 17:56:30');
INSERT INTO `recharge_record` VALUES (25, 31, 1000.00, 1000.00, 0, '2026-09-29 17:56:30');
INSERT INTO `recharge_record` VALUES (26, 33, 800.00, 800.00, 0, '2026-09-29 17:56:30');
INSERT INTO `recharge_record` VALUES (27, 34, 800.00, 800.00, 0, '2026-09-29 17:56:30');
INSERT INTO `recharge_record` VALUES (28, 35, 1000.00, 1000.00, 0, '2026-09-29 17:56:30');
INSERT INTO `recharge_record` VALUES (29, 36, 1000.00, 1000.00, 0, '2026-09-29 17:56:30');
INSERT INTO `recharge_record` VALUES (30, 37, 200.00, 200.00, 0, '2026-09-29 17:56:30');
INSERT INTO `recharge_record` VALUES (31, 38, 1500.00, 1500.00, 0, '2026-09-29 17:56:30');
INSERT INTO `recharge_record` VALUES (32, 39, 500.00, 500.00, 0, '2026-09-29 17:56:30');
INSERT INTO `recharge_record` VALUES (33, 41, 3000.00, 3000.00, 0, '2026-09-29 17:56:30');
INSERT INTO `recharge_record` VALUES (34, 42, 3000.00, 3000.00, 0, '2026-09-29 17:56:30');
INSERT INTO `recharge_record` VALUES (35, 43, 3000.00, 3000.00, 0, '2026-09-29 17:56:30');
INSERT INTO `recharge_record` VALUES (36, 44, 2000.00, 2000.00, 0, '2026-09-29 17:56:31');
INSERT INTO `recharge_record` VALUES (37, 45, 500.00, 500.00, 0, '2026-09-29 17:56:31');
INSERT INTO `recharge_record` VALUES (38, 46, 1000.00, 1000.00, 0, '2026-09-29 17:56:31');
INSERT INTO `recharge_record` VALUES (39, 48, 200.00, 200.00, 0, '2026-09-29 17:56:31');
INSERT INTO `recharge_record` VALUES (40, 49, 300.00, 300.00, 0, '2026-09-29 17:56:31');
INSERT INTO `recharge_record` VALUES (41, 50, 500.00, 500.00, 0, '2026-09-29 17:56:31');
INSERT INTO `recharge_record` VALUES (42, 51, 1500.00, 1500.00, 0, '2026-09-29 17:56:31');
INSERT INTO `recharge_record` VALUES (43, 52, 3000.00, 3000.00, 0, '2026-09-29 17:56:31');
INSERT INTO `recharge_record` VALUES (44, 53, 800.00, 800.00, 0, '2026-09-29 17:56:31');
INSERT INTO `recharge_record` VALUES (45, 54, 2000.00, 2000.00, 0, '2026-09-29 17:56:31');
INSERT INTO `recharge_record` VALUES (46, 55, 3000.00, 3000.00, 0, '2026-09-29 17:56:31');
INSERT INTO `recharge_record` VALUES (47, 55, 1000.00, 4000.00, 1000, '2026-09-30 10:50:09');

-- ----------------------------
-- Table structure for student
-- ----------------------------
DROP TABLE IF EXISTS `student`;
CREATE TABLE `student`  (
  `student_id` bigint NOT NULL AUTO_INCREMENT COMMENT '学生ID',
  `first_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '名',
  `last_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '姓',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '邮箱(登录账号)',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码哈希(PBKDF2)',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '手机号',
  `date_of_birth` date NULL DEFAULT NULL COMMENT '出生日期',
  `balance` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '账户余额(元)',
  `points` int NOT NULL DEFAULT 0 COMMENT '积分余额',
  `registration_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
  PRIMARY KEY (`student_id`) USING BTREE,
  UNIQUE INDEX `uk_student_email`(`email` ASC) USING BTREE,
  CONSTRAINT `chk_student_balance` CHECK (`balance` >= 0),
  CONSTRAINT `chk_student_points` CHECK (`points` >= 0)
) ENGINE = InnoDB AUTO_INCREMENT = 56 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '学生表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of student
-- ----------------------------
INSERT INTO `student` VALUES (1, 'San', 'Zhang', 'a@test.com', 'pbkdf2_sha512$210000$HpVMzSapbhm/9VLdKuVKZg==$v9McmO0CxqnmRlVykIQzaP749xIXui8eKvZREeZQ9/vR+QvSPAMiDoAlXiZzJDEbfv9HWVaYmR4iGCmEPVj4+g==', '13211112222', '2026-09-08', 1000.00, 0, '2026-09-29 15:49:59');
INSERT INTO `student` VALUES (3, 'ying', 'you', '111@gmail.com', 'pbkdf2_sha512$210000$5wVlBiRIbanmU91i9Gs53w==$pgXjT7l3/oojZuSvS01+glgR23ILNMLDjwWyO5glRErGbflogOg888/Nce1jGbtfOaUQLHmPNsMirlDydK2axA==', '13222223333', '2026-09-30', 3790.00, 5520, '2026-09-29 16:15:37');
INSERT INTO `student` VALUES (4, '周', '周', 'leidengl11@gmail.com', 'pbkdf2_sha512$210000$QLsQf9qevcFbq+snZ6abmQ==$hN+JMUI3557rW1hTbTnmRBk3HgLRCoVWHYOciniZB5JZ+hNoZOn5m6jFDtd2tFSybH1DRD+b0jJo/Vcn4KLB+w==', '13222224444', '2026-06-17', 1000.00, 0, '2026-09-29 16:30:17');
INSERT INTO `student` VALUES (5, '二', '刘', 'ceshi@gmail.com', 'pbkdf2_sha512$210000$HyCyEIthz1gU0S7dynLqvQ==$jem1DAeJTsetOcpCWni1pWwmQxLOO+XXnfuitj8yRfef4hd5nvTfz6welynJciXSsSNORrplU1Qz8ZkeOatmtA==', '13222223334', '2026-09-17', 1200.00, 0, '2026-09-29 17:02:48');
INSERT INTO `student` VALUES (6, '子涵', '梁', 'student01@demo.example.com', 'pbkdf2_sha512$210000$voghRxK7SrSpM3nI3e6PYg==$wmf5WQbWb6sp7RgKJ7w7WNcyyteOD9zzTqEZ1ORvEp08nCX7QBHSVh0i6a2gLwugBoCzoTlUdfmegy14EDgyiw==', '15288437294', '2014-10-21', 200.00, 0, '2026-09-29 17:56:29');
INSERT INTO `student` VALUES (7, '欣怡', '周', 'student02@demo.example.com', 'pbkdf2_sha512$210000$Ez2I5Cz5IGbeJFXFXu1cLQ==$pbkvWCPHeDsXUHXD89EshiSjc08qhLaJjYVQtHGa8u7tzUa2aQoSAKU6eeSOdqmZNihTFTGMVjI5GxRJrWQrNg==', '15049705564', '2017-08-08', 200.00, 0, '2026-09-29 17:56:29');
INSERT INTO `student` VALUES (8, '梓萱', '杨', 'student03@demo.example.com', 'pbkdf2_sha512$210000$beo+BfivbNTbqp/8aLe7Dw==$WhYm4ZBqoQs0xZ37VepYvGMlcm8HlawnyKRK9gFJ5qRCroYbPnudBRGIKcT4B2ekYMGtfDxu07hR/A3GZrFWhw==', '18872198665', '2017-05-25', 800.00, 0, '2026-09-29 17:56:29');
INSERT INTO `student` VALUES (9, '浩然', '胡', 'student04@demo.example.com', 'pbkdf2_sha512$210000$frY7pYVgrD1fQbvvO3ZFjw==$+t1FB5XIH7Qqsdl1eDCCmMjR4OqfT7anUz8qdI4/+kO/8/rwlrxGzFYrQGon95RK7lVBVVQDjpJ1KNDZh50VjQ==', '13563155689', '2017-06-20', 500.00, 0, '2026-09-29 17:56:29');
INSERT INTO `student` VALUES (10, '宇轩', '徐', 'student05@demo.example.com', 'pbkdf2_sha512$210000$heoU/LahGt6fYaUBAtoxeQ==$yjn7/7G+b/xdoeh0h1vSjXeFbQ8m9ZKRsAcvBEi4qpyveduXevpjuQruNBxH7+aSk4EHOoA2IdRDy5AN1uaghA==', '18890829491', '2017-01-13', 3000.00, 0, '2026-09-29 17:56:29');
INSERT INTO `student` VALUES (11, '雨桐', '马', 'student06@demo.example.com', 'pbkdf2_sha512$210000$S39ioq0I/mUkiqpA+PCGdw==$o/z3i0OKlS5vatJD0RYBRW27po5iTwD08f6pSiTlgyCzNZIHwFWnpEQSO6QY5ND7P446aecFj9r2A9XThPfaPw==', '18878629064', '2018-02-15', 500.00, 0, '2026-09-29 17:56:29');
INSERT INTO `student` VALUES (12, '一诺', '王', 'student07@demo.example.com', 'pbkdf2_sha512$210000$pi+yX6D9gl9QJWWPKymeDA==$PnzltoxlzSE7fB/TiFsIX/JP32KvnSJ0NgF2mNTZuohxMUAayFLGyMJc1soj07AvdOnEFCny0YM4Mx+BKFyU3A==', '15010747075', '2014-03-23', 2000.00, 0, '2026-09-29 17:56:29');
INSERT INTO `student` VALUES (13, '思远', '许', 'student08@demo.example.com', 'pbkdf2_sha512$210000$t9Sn86KY157K8kM1l2p+Dg==$54zbTC/JRMW23tAb7Wm88h0BYcIbr6uiU11AmMWVvWkGUysbqvQAZAIzIPGyZ1w5fcFKUMFiFNKBQLY/2A04kA==', '13799516308', '2014-12-16', 500.00, 0, '2026-09-29 17:56:30');
INSERT INTO `student` VALUES (14, '若曦', '梁', 'student09@demo.example.com', 'pbkdf2_sha512$210000$GDQ6UqKB3YQpjj8hF9JBKQ==$1UNuM/PoqJX1TzhuHikd1gpc3FSbEKg4bI/htZtTVwRAe57U0bXYFTDIXVac4ZPhDePbaXMgnuxf7xlamCOSAg==', '18636221635', '2018-05-07', 3000.00, 0, '2026-09-29 17:56:30');
INSERT INTO `student` VALUES (15, '俊杰', '徐', 'student10@demo.example.com', 'pbkdf2_sha512$210000$QGFXK110Dh4ectVB5tq+3g==$gjMf+EOiiapQy0FN62vetEPrQ2ov4g5lgD2qEZ/w/Wt+xKI5mrA3YxjyjG3LEpKnPISFa23Cr6DF7vvxgjhhkw==', '13866218042', '2016-07-16', 800.00, 0, '2026-09-29 17:56:30');
INSERT INTO `student` VALUES (16, '诗涵', '曹', 'student11@demo.example.com', 'pbkdf2_sha512$210000$5xmfdo3+2BuZ/x8VWXhhGg==$qGSd7OLJek80Xx3ZBk+TzSaJgWZ9dkcATxUrL9xtwfsKJ80fPNoNbL0GhdYleergpQNmTHbMHyLptUUBjTBhmg==', '15842970228', '2012-08-08', 3000.00, 0, '2026-09-29 17:56:30');
INSERT INTO `student` VALUES (17, '明轩', '张', 'student12@demo.example.com', 'pbkdf2_sha512$210000$kRygqSikSRxFLB66ivuLyQ==$HHKsxffVtiX1CjLICzpyZuvXn/NNB9Hq2OoFRwaQQ07DuOBok1Dkcb0QftoiPKlDFNH5W6Ob1djbtyMic2lQMg==', '18602157199', '2012-12-25', 0.00, 0, '2026-09-29 17:56:30');
INSERT INTO `student` VALUES (18, '可馨', '郭', 'student13@demo.example.com', 'pbkdf2_sha512$210000$pui72EPGpTY9U1RHMeFDeg==$+7uw6TcDd1HntnIHU4nB/leOex3YUtPyfwVY+BPYJnnBs/0+8u1C57Ep3k4cCZ9rGSqL7A5OgvfEVOcIltef7w==', '13898489522', '2012-05-07', 500.00, 0, '2026-09-29 17:56:30');
INSERT INTO `student` VALUES (19, '嘉怡', '梁', 'student14@demo.example.com', 'pbkdf2_sha512$210000$cJmuxdWPyXR0KmELRHZCDg==$NTds6SFPq3BBehHRFT8ZyBJHiQ3bjbD0svSAIH4bk1ZIyJ8FlHyRyEG7gKrKmS1uUy1yr0Wm7YHv8S80ZKDjKw==', '18698537588', '2015-05-20', 3000.00, 0, '2026-09-29 17:56:30');
INSERT INTO `student` VALUES (20, '皓轩', '邓', 'student15@demo.example.com', 'pbkdf2_sha512$210000$6WH2O8XA1FAx+m3UmpYUxA==$HYTjmO60cttVTnBacBPnPevR7cGR+V6Q5bKQXe7BFeZ5ySwxX6Y9cQChhZAStGsaLwfK+Snajkg8GCsatS4qog==', '13662866583', '2015-01-10', 1000.00, 0, '2026-09-29 17:56:30');
INSERT INTO `student` VALUES (21, '语桐', '高', 'student16@demo.example.com', 'pbkdf2_sha512$210000$/in7AvN+S8e7FdlWVXffMQ==$W3A9S4EWpxcBAALi8sbxQ0B5Ah/D+pE8mITTqVWR/a5CcktXhl8TVhslJY9a9QJ706OynXhbZi/q/F8zLJE0zg==', '18858239531', '2015-10-17', 2000.00, 0, '2026-09-29 17:56:30');
INSERT INTO `student` VALUES (22, '天佑', '邓', 'student17@demo.example.com', 'pbkdf2_sha512$210000$VE9VahxIr7D8qbbbP740/A==$EXu+kfX++scRL5fHvagxA6DdkS48+6W3ZxlvGM6kqZk8b3UqNHrEsEQ1d/fim8wRz4jx6rZKJGHUxiOE+gwqhA==', '15099993288', '2012-09-08', 1500.00, 0, '2026-09-29 17:56:30');
INSERT INTO `student` VALUES (23, '梓睿', '赵', 'student18@demo.example.com', 'pbkdf2_sha512$210000$9kCYz3XghCLO+YzJgZHKew==$xdcTLBvF755w6s8xDslC9HaRi3O+P/fD/ALZMabhqSR5MFD3R7lOoFcS/USNpmonZz28b3p8UUVWnNlpvkYwnQ==', '15281167602', '2016-01-27', 0.00, 0, '2026-09-29 17:56:30');
INSERT INTO `student` VALUES (24, '欣妍', '郭', 'student19@demo.example.com', 'pbkdf2_sha512$210000$JVRcvRzw/AG/8iJMmVzPvQ==$azxyNRPmIvPvQA/o/3IElGqKE5W1MaNii/4kOxVbqmjPLlBjrvjf3campvo2LIsDG6r+BUAzwjgux6j/kn8jXQ==', '15207866573', '2012-05-19', 3000.00, 0, '2026-09-29 17:56:30');
INSERT INTO `student` VALUES (25, '博文', '韩', 'student20@demo.example.com', 'pbkdf2_sha512$210000$qeShlM42vAPZ2b6dVgPjhA==$/cA/3em5AMXsrVwKYLpukNeFfJ2Mq2Lr2xuB3fgsB9PY0hIkUSU+7+xtsxRINcp6XRklFvFvG8g7kLTEWvQ9/w==', '13591428604', '2016-04-07', 500.00, 0, '2026-09-29 17:56:30');
INSERT INTO `student` VALUES (26, '晨曦', '王', 'student21@demo.example.com', 'pbkdf2_sha512$210000$pDdDsNXYDkiKOwEXltoKEA==$7+WBXUbgEtucdOs6GrPGlvdkrybH234sr4h2FkqF3UuFXNTnB6ZYm4EQTTMeezB+Ur/YR623X/t2nJ46Vr2gRQ==', '18617642521', '2016-07-27', 500.00, 0, '2026-09-29 17:56:30');
INSERT INTO `student` VALUES (27, '子墨', '赵', 'student22@demo.example.com', 'pbkdf2_sha512$210000$2b6y5dYwHLmSNMXviYs/KA==$Mz9DTD75Gdqh+hnDitLtTaE2aAJlPyTO2F+eHi8DAQepAktEWdxpIQ24MqlMrBnvib6JdbMbUg91f62y2vLPpg==', '15863005232', '2012-02-13', 300.00, 0, '2026-09-29 17:56:30');
INSERT INTO `student` VALUES (28, '安琪', '冯', 'student23@demo.example.com', 'pbkdf2_sha512$210000$OsWdMR1hArvgLdhJ6bvCcw==$OKGaHrXTxsCvQAbNTdhA2xL2ibe+p6HVz2y3uGY4jcF838sdqhjbHwTbDHrBsWQn4nd9zVO2LEdl5OCSDIbfDA==', '13506763318', '2014-02-16', 300.00, 0, '2026-09-29 17:56:30');
INSERT INTO `student` VALUES (29, '泽宇', '朱', 'student24@demo.example.com', 'pbkdf2_sha512$210000$x9wv76uFne+4MbJ5tMcbNA==$zm3mSMyAG1iAPof0dQNqGExrlhopinDkPXyDSP2qnfbk14K1Vs/VTeogQY6XNrQ9R52K9LRkPytLCXq2aWJ+Qw==', '18833914649', '2017-11-13', 500.00, 0, '2026-09-29 17:56:30');
INSERT INTO `student` VALUES (30, '雅琪', '唐', 'student25@demo.example.com', 'pbkdf2_sha512$210000$z4KKAP8VaIxJQ9GG/9fPPQ==$kGKuJJAoNKCKVP91t6W9ykIBrv/RH3JOBxbTUOKwiLj4Ctxk0XqJQnscfu9Y1GtbIRDC/cUceF6BxTIj4qlLeg==', '13806720960', '2017-04-12', 1500.00, 0, '2026-09-29 17:56:30');
INSERT INTO `student` VALUES (31, '奕辰', '郑', 'student26@demo.example.com', 'pbkdf2_sha512$210000$6id7hyFEstfIX7Ua0c9tyQ==$SlWwL6/LsA9G+T/aYrTg9Q7W0cZICljR7+dchOOmzaDF6h+HbXda+oxPR71bBfDKQlcGfm/nkMmkzYEDUG+lxg==', '15021610713', '2012-08-10', 1000.00, 0, '2026-09-29 17:56:30');
INSERT INTO `student` VALUES (32, '佳怡', '朱', 'student27@demo.example.com', 'pbkdf2_sha512$210000$Zyoie8oRAX1tgQO1Ow5Irw==$vx2L7mLos50AfWatQqp+mLYPriU7TKf9Ab9IdxPcR+bogMrV7TSjacPL4rGmaNCV90Aa6rIEkF/iWgzCG1fBzA==', '13931288111', '2017-04-27', 0.00, 0, '2026-09-29 17:56:30');
INSERT INTO `student` VALUES (33, '宇航', '杨', 'student28@demo.example.com', 'pbkdf2_sha512$210000$/JOG/am3l4txaGZlOZmTGw==$9W/55vH28WlGcNzOm6G3XK7jqPqPcroYujjTMNaKX3OUl+tkBX5quqgz0QO9TVjmIWzuC10Wb+qt+85LItOeeQ==', '13914803779', '2015-04-14', 800.00, 0, '2026-09-29 17:56:30');
INSERT INTO `student` VALUES (34, '梦瑶', '冯', 'student29@demo.example.com', 'pbkdf2_sha512$210000$Gs+VwGqeVfJSqQn3F/fWiA==$fxdghXrnBh/UcfXL9twDyT0QTMuaWwr3f+wsN0EpKFZ2g1YZ7r/X5xRVmOcqFb5EIOhca46YcI1op5meRGAlig==', '13704928615', '2014-11-22', 800.00, 0, '2026-09-29 17:56:30');
INSERT INTO `student` VALUES (35, '俊熙', '黄', 'student30@demo.example.com', 'pbkdf2_sha512$210000$KPHyCS4jPqelNau17lfExQ==$PH8EqYEZkrJ0rwoSnG4ykjNcex/IGdPctEQDwfipOhcGf470W0EoRgU1A0yLLyjezSQ16ACN211/KBEluTyPnw==', '15039633405', '2014-08-20', 1000.00, 0, '2026-09-29 17:56:30');
INSERT INTO `student` VALUES (36, '思琪', '高', 'student31@demo.example.com', 'pbkdf2_sha512$210000$Aomw5YF9pbvv0GD9oD+SGg==$upx0KU/H4rHe3WAPZ2OnSdM+8exvIGv2P6Lb+Z4uMigKRVGuLBq31t8AvzW3uPuzWI0zONIR/y+lyLGk5Jh0rw==', '18696022105', '2012-05-18', 1000.00, 0, '2026-09-29 17:56:30');
INSERT INTO `student` VALUES (37, '沐阳', '许', 'student32@demo.example.com', 'pbkdf2_sha512$210000$HJzmmqedwPodt6aJuchgXw==$hevAFNd+a4qBv5awjKm50UD6ML8JiY032Jbjtrb8TQ+ggSrkb8I2bOVZcQ1rmq/h2bjSBnHaVUu1yS5hciMxvg==', '18610071349', '2015-07-23', 200.00, 0, '2026-09-29 17:56:30');
INSERT INTO `student` VALUES (38, '雨萱', '杨', 'student33@demo.example.com', 'pbkdf2_sha512$210000$tVos9o69PoRZe6UqXWFAFg==$vKP2JN02s/bnFWWYaQf4xdFd1BCWjquvXiD6ZHFpcQ8qEntJU5sLxrt104JR5+Nlfvg1uzj4HC6ubl0UNIriRQ==', '18652466607', '2016-11-03', 1500.00, 0, '2026-09-29 17:56:30');
INSERT INTO `student` VALUES (39, '承泽', '林', 'student34@demo.example.com', 'pbkdf2_sha512$210000$mmWmJP6G/3mjIttYoQRW8A==$qa8uzBrCZJfDnittwwF8y9MO9EVeDKWg/99o3rRaKh5YSybdBmCfNToIQhzsemnvPjoTa/UdScKS28nyM3aE4g==', '18609444737', '2014-11-13', 500.00, 0, '2026-09-29 17:56:30');
INSERT INTO `student` VALUES (40, '芷若', '郭', 'student35@demo.example.com', 'pbkdf2_sha512$210000$2Lj5QslCzWztJILDBePbxQ==$1bi+gFhyFAopxfwJE17P4Nm4OCYq7KTRWyR4oenN7sT0e6Hc+Bn2KQ11zQeks0gW3mpWX2D2t3n93Wd4NKMAwQ==', '18870934307', '2015-04-26', 0.00, 0, '2026-09-29 17:56:30');
INSERT INTO `student` VALUES (41, '铭哲', '罗', 'student36@demo.example.com', 'pbkdf2_sha512$210000$VN81p1S+E5fHGwM2qMfPCQ==$rCSW54wVaw/j6hVvGwVE0cWN4gjurkpmV4xksrgBRB3nL2X/R4VuHzU3iY4++GaZMAjY7+mH49h6SggvUBB+IQ==', '15009182703', '2013-03-14', 3000.00, 0, '2026-09-29 17:56:30');
INSERT INTO `student` VALUES (42, '依依', '张', 'student37@demo.example.com', 'pbkdf2_sha512$210000$xdg4gtByfSQBexcunOhhWw==$BvAltm5MsVqvQ/GJpzSjDE4MJYDBaPzKoqrkbYzCM1PhjJuiW8Pky1gEQOK9/1K/nalAjX39KcoGyF8LkEhybQ==', '13539877456', '2014-11-10', 3000.00, 0, '2026-09-29 17:56:30');
INSERT INTO `student` VALUES (43, '景行', '许', 'student38@demo.example.com', 'pbkdf2_sha512$210000$lAMrPzNSt0/MBvrOWPhL9w==$+5hJAWlheHbAEzUa2IeKoYBfxgFvCCZ0dvDHr7KZYdoW7ig3sSsTBmHZGK4xdYdt/ffzetV/3rwaFnhioJtmCg==', '18835296618', '2012-09-09', 3000.00, 0, '2026-09-29 17:56:30');
INSERT INTO `student` VALUES (44, '书瑶', '张', 'student39@demo.example.com', 'pbkdf2_sha512$210000$yR5SBDaytNujdX+PELWRbg==$rtxJDl7xd3cvI2tIecCeQTWdWqUcwX/SWHEI1wZT87AEMXZovPULmAvYStbHgV9bwAY4XPKPvkDcyEAiAY9mOw==', '15841957855', '2015-10-03', 2000.00, 0, '2026-09-29 17:56:30');
INSERT INTO `student` VALUES (45, '亦凡', '梁', 'student40@demo.example.com', 'pbkdf2_sha512$210000$3CSooFQrOW52wv+ZB0ZsfA==$3Zxc+Im62BKQT2+MiAuy8sHN2564jPkrDKp/9ygjlpuNp4H31WnvYpTPtGb0htRQ9NXXhaRRP8E9vpcOSh7nuw==', '15884128761', '2018-04-27', 500.00, 0, '2026-09-29 17:56:31');
INSERT INTO `student` VALUES (46, '乐怡', '孙', 'student41@demo.example.com', 'pbkdf2_sha512$210000$EumhBF+Sq4QhfUNPn5YbfA==$5Gi/iWf9sZVbHylQFBsf/sFNGJqs4jVzE+Ph2gC5BO7OxFnveglvmTrhulaatDajbFNlGWepm4KvVOH8BFdlMA==', '18897695016', '2018-03-14', 1000.00, 0, '2026-09-29 17:56:31');
INSERT INTO `student` VALUES (47, '修远', '郭', 'student42@demo.example.com', 'pbkdf2_sha512$210000$pZ2P/P55EeVoobv8XV+iug==$fDCBAK14yUcPiWYzR8P0NhrI8rWyXGJfYnmyvxG0db+f4vkK1GAsLGni60DmDRTgRUy/1JHQku6x+MVYCe8kSQ==', '13816606748', '2012-08-01', 0.00, 0, '2026-09-29 17:56:31');
INSERT INTO `student` VALUES (48, '心悦', '韩', 'student43@demo.example.com', 'pbkdf2_sha512$210000$/GwY6qEf+hAfW1ajjSW3Ow==$Ol+p/TFLt5UNipQUWnjtMIHV65rTVgTIIfRACvbGKY30JvX6RO5WNhJlpaD4Mj+fBD0gGY0CrbA1+vuGL4pLHg==', '18897640812', '2013-10-27', 200.00, 0, '2026-09-29 17:56:31');
INSERT INTO `student` VALUES (49, '瑞霖', '高', 'student44@demo.example.com', 'pbkdf2_sha512$210000$J0zwj022+FukdKdpY5fPRA==$rz9QArh+0Al1OkR5eZN/YbNKKygSBpgDIkqCuK4hSMW3hcqbgyR8a+nXW8ThR+KeZ1hsLjEw6Rh5P7YyQclIqQ==', '18651011931', '2013-08-23', 300.00, 0, '2026-09-29 17:56:31');
INSERT INTO `student` VALUES (50, '婉清', '高', 'student45@demo.example.com', 'pbkdf2_sha512$210000$7VAdDb+52Jc3AjLqXtXgqw==$XER2PH4Sn8tz5U+5iV2zeQCbgDx6LzkDYZYfYV19bkLZz0FLBgesI5OdcVIlaWGntywELFQlArjUWt/x16U43Q==', '15810638892', '2018-02-23', 500.00, 0, '2026-09-29 17:56:31');
INSERT INTO `student` VALUES (51, '昊天', '罗', 'student46@demo.example.com', 'pbkdf2_sha512$210000$+wHrXqeB8YAY9faiwNYUAA==$lH++qdL10T5OFLjkvbteo2tMrceEXj2CPFWkZ8sS0oEIU+RWazb8VRz9q23uVU9E8tWVsO/vtfqh/vvBsH2Fzg==', '13615307155', '2012-05-25', 1500.00, 0, '2026-09-29 17:56:31');
INSERT INTO `student` VALUES (52, '语嫣', '邓', 'student47@demo.example.com', 'pbkdf2_sha512$210000$gF7XZW6fR7l3MXgD1oDTog==$HQ2Yc0oA/0m9OjmgfDoqNUsQE3zBF89mztOR+YYww4Rtusa5QbGo3kTULrCMkmCihfn1xi8Ts6PEQ1vuwcP4sg==', '13902345061', '2018-10-16', 3000.00, 0, '2026-09-29 17:56:31');
INSERT INTO `student` VALUES (53, '锦程', '赵', 'student48@demo.example.com', 'pbkdf2_sha512$210000$v7owdotqE4AGL31NiKxzxg==$+WI4sIocItrRHagjHGMNKoYYzdSJf/gYlS7bPmTgnLkjNAq2fC/IWGcd72rm7+WeX9Mzy6U4DVeIC9CYaFd3xw==', '13530451181', '2014-05-15', 800.00, 0, '2026-09-29 17:56:31');
INSERT INTO `student` VALUES (54, '星辰', '李', 'student49@demo.example.com', 'pbkdf2_sha512$210000$wVEPvrSxY66HLR0OQCtj9Q==$SUEyb29nO9PodamW5IuIqKgiA/PpKsL2uuBsZMIg8ij7qjYeZGGUzeJDTUs1wmHrqQi9xZ3o8DqIIJbfKUQzKg==', '18806027650', '2014-06-18', 2000.00, 0, '2026-09-29 17:56:31');
INSERT INTO `student` VALUES (55, '知夏', '梁', 'student50@demo.example.com', 'pbkdf2_sha512$210000$nkU0XOPragQuJ9bPOa/QqQ==$KizBbSB7eaNoFfvZZgxD4xFcRbL4ZAtDK76gBgD6JvDAqC/5mR2uhC0zgingq4HubYgDDeNulQfrDyNYKLdNVw==', '15011655271', '2015-10-24', 3890.00, 1220, '2026-09-29 17:56:31');

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '登录名',
  `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码哈希',
  `display_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '姓名',
  `role` enum('ADMIN','RECEPTION','ACADEMIC') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色:管理员/前台/教务',
  `enabled` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否启用',
  `must_change_password` tinyint(1) NOT NULL DEFAULT 0 COMMENT '下次登录必须修改密码',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `last_login_at` datetime NULL DEFAULT NULL COMMENT '最近登录时间',
  PRIMARY KEY (`user_id`) USING BTREE,
  UNIQUE INDEX `uk_user_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'admin', 'pbkdf2_sha512$210000$vM/DZSY+TvJvkBQwxpt2gA==$1QYgpx15a46SqoDZW4lorXQPz1lhVyrEW8MdxbQWH5SPIBsa2rff9toxtNOdKbHhXpRGw59yCaOa54bV8FlTxg==', '系统管理员', 'ADMIN', 1, 0, '2026-09-30 10:02:51', '2026-09-30 11:28:42');
INSERT INTO `sys_user` VALUES (2, 'jiaowu01', 'pbkdf2_sha512$210000$2QtEIDWlTQAD97S666X5hA==$1/pXSiKzhcNsLP2xM7ebHzd+PtZ1fIDaL8uFoLxK4x07Du31nc/p3GUlOXrNf82+Zuyc5mODcUvn7+DGFSr9dA==', '张敏', 'ACADEMIC', 1, 0, '2026-09-30 10:22:09', '2026-09-30 10:23:31');
INSERT INTO `sys_user` VALUES (3, 'jiaowu02', 'pbkdf2_sha512$210000$ihDyP3D+4mkttDRrcsCBbA==$UfEJWFQR/PXx8a8n125v3hmiyK+G/d82Ndhh6C/2Fxd3A3KZyVlMOAnkJWUcnliixytsu15s4vfvdXuAKM5buQ==', '李强', 'ACADEMIC', 1, 1, '2026-09-30 10:22:09', '2026-09-30 10:22:26');
INSERT INTO `sys_user` VALUES (4, 'qiantai01', 'pbkdf2_sha512$210000$vKeEDycuHwx1LruFDQhDZw==$lckVS/r4lxgjAKOt4AvPYn6HZ3MGuueG8B6HWiiOB3W4gLXwMM/02ULqQ3W3kz26WsMriNB6eA7TjkhicneZ/Q==', '王芳', 'RECEPTION', 1, 0, '2026-09-30 10:22:09', '2026-09-30 10:37:52');
INSERT INTO `sys_user` VALUES (5, 'qiantai02', 'pbkdf2_sha512$210000$gQywblJSVm6EjhrKYPcXrQ==$6yqAfJHpgOh8ES2aPxd6Nx4UZNPCpJwDv9FMudzuC0OeZy0CttR/Nyz9vBRi1qnK++PZiS+JnpNswzZIQQUqXg==', '刘洋', 'RECEPTION', 1, 1, '2026-09-30 10:22:09', '2026-09-30 10:22:29');
INSERT INTO `sys_user` VALUES (6, 'qiantai03', 'pbkdf2_sha512$210000$D6FltpKgw3SX+h1DA0xXlw==$3AQetN71YrI/pwAZGHaVqfrHcj7Fn9fWIFUihXKs4zhG4f/7VFGgeFdVMjFixlyb77dlSNaLrDQmrFlUh9smDw==', '陈静', 'RECEPTION', 1, 1, '2026-09-30 10:22:09', '2026-09-30 10:22:31');
INSERT INTO `sys_user` VALUES (7, 'qiantai04', 'pbkdf2_sha512$210000$PAcezCnJhiUQGOwo+BViYQ==$k0fvOUokBebd8NUXZVKsI2996gqI9+ArWbLFvE+c3TaAkAMG9uyAhAUxS1j3zCtq8nxK4OzLMvlh5DDT8A+Fgw==', '赵磊', 'RECEPTION', 1, 1, '2026-09-30 10:22:09', '2026-09-30 10:22:32');
INSERT INTO `sys_user` VALUES (8, 'qiantai05', 'pbkdf2_sha512$210000$NX9IwcstLcwUdxUXc2vWXw==$XMHXhpxtX+tCDHbt/kIsnrOucT+pVgXRdvU0+LTJCdhFab/Xo0WpAZg1iLvGfJUh8bY7DKFcNwvNPfEXRe9OvQ==', '孙悦', 'RECEPTION', 1, 1, '2026-09-30 10:22:09', '2026-09-30 10:22:34');

SET FOREIGN_KEY_CHECKS = 1;
