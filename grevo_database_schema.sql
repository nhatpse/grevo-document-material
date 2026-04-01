-- ============================================================
-- GREVO DATABASE SCHEMA
-- Generated from JPA Entity classes (grevo-be-material)
-- Database: MySQL
-- Date: 2026-04-01
-- ============================================================

-- Tạo database (nếu chưa có)
CREATE DATABASE IF NOT EXISTS grevo_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE grevo_db;

-- ============================================================
-- 1. TABLE: users
-- Entity: Users.java
-- ============================================================
CREATE TABLE IF NOT EXISTS `users` (
    `user_id`                   INT             NOT NULL AUTO_INCREMENT,
    `google_id`                 VARCHAR(255)    NULL        UNIQUE,
    `username`                  VARCHAR(255)    NOT NULL    UNIQUE,
    `password`                  VARCHAR(255)    NOT NULL,
    `role`                      VARCHAR(255)    NOT NULL    DEFAULT 'CITIZEN',
    `is_active`                 BIT(1)          NULL        DEFAULT 1,
    `is_verified`               BIT(1)          NULL        DEFAULT 0,
    `create_at`                 DATETIME(6)     NULL,
    `update_at`                 DATETIME(6)     NULL,
    `full_name`                 VARCHAR(255)    NULL,
    `email`                     VARCHAR(255)    NULL        UNIQUE,
    `temp_email`                VARCHAR(255)    NULL,
    `phone`                     VARCHAR(255)    NULL        UNIQUE,
    `address`                   VARCHAR(255)    NULL,
    `avatar`                    VARCHAR(255)    NULL,
    `rs_password_token`         VARCHAR(255)    NULL,
    `rs_password_t_expiry`      DATETIME(6)     NULL,
    `verification_code`         VARCHAR(255)    NULL,
    `verification_code_expiry`  DATETIME(6)     NULL,
    PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 2. TABLE: citizens
-- Entity: Citizens.java
-- ============================================================
CREATE TABLE IF NOT EXISTS `citizens` (
    `citizen_id`    INT         NOT NULL AUTO_INCREMENT,
    `user_id`       INT         NOT NULL,
    `total_points`  INT         NULL    DEFAULT 0,
    PRIMARY KEY (`citizen_id`),
    KEY `idx_citizens_user_id` (`user_id`),
    CONSTRAINT `fk_citizens_user`
        FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 3. TABLE: enterprise
-- Entity: Enterprise.java
-- ============================================================
CREATE TABLE IF NOT EXISTS `enterprise` (
    `enterprise_id`     INT             NOT NULL AUTO_INCREMENT,
    `user_id`           INT             NOT NULL,
    `company_name`      VARCHAR(255)    NULL,
    `company_phone`     VARCHAR(255)    NULL,
    `company_email`     VARCHAR(255)    NULL,
    `company_adr`       VARCHAR(255)    NULL,
    `tax_code`          VARCHAR(255)    NULL,
    `capacity`          INT             NULL,
    `logo_url`          VARCHAR(255)    NULL,
    `is_active`         BIT(1)          NULL    DEFAULT 1,
    PRIMARY KEY (`enterprise_id`),
    KEY `idx_enterprise_user_id` (`user_id`),
    CONSTRAINT `fk_enterprise_user`
        FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 4. TABLE: collectors
-- Entity: Collectors.java
-- ============================================================
CREATE TABLE IF NOT EXISTS `collectors` (
    `collector_id`      INT             NOT NULL AUTO_INCREMENT,
    `user_id`           INT             NOT NULL,
    `enterprise_id`     INT             NULL,
    `vehicle_type`      VARCHAR(255)    NULL,
    `vehicle_plate`     VARCHAR(255)    NULL,
    `max_capacity`      INT             NULL,
    `current_status`    VARCHAR(255)    NULL,
    `leave_reason`      VARCHAR(255)    NULL,
    `last_active_at`    DATETIME(6)     NULL,
    `is_online`         BOOLEAN         DEFAULT FALSE,
    PRIMARY KEY (`collector_id`),
    KEY `idx_collectors_user_id` (`user_id`),
    KEY `idx_collectors_enterprise_id` (`enterprise_id`),
    CONSTRAINT `fk_collectors_user`
        FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT `fk_collectors_enterprise`
        FOREIGN KEY (`enterprise_id`) REFERENCES `enterprise` (`enterprise_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 5. TABLE: waste_types
-- Entity: WasteTypes.java
-- ============================================================
CREATE TABLE IF NOT EXISTS `waste_types` (
    `type_id`       INT             NOT NULL AUTO_INCREMENT,
    `name`          VARCHAR(255)    NOT NULL,
    `base_points`   INT             NULL,
    PRIMARY KEY (`type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 6. TABLE: service_areas
-- Entity: ServiceAreas.java
-- ============================================================
CREATE TABLE IF NOT EXISTS `service_areas` (
    `area_id`       INT             NOT NULL AUTO_INCREMENT,
    `area_name`     VARCHAR(255)    NULL,
    `area_code`     VARCHAR(255)    NULL,
    `type`          VARCHAR(255)    NULL,
    `lat`           DOUBLE          NULL,
    `lng`           DOUBLE          NULL,
    `is_active`     BIT(1)          NULL    DEFAULT 1,
    PRIMARY KEY (`area_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 7. TABLE: waste_reports
-- Entity: WasteReports.java
-- ============================================================
CREATE TABLE IF NOT EXISTS `waste_reports` (
    `report_id`                 INT             NOT NULL AUTO_INCREMENT,
    `citizen_id`                INT             NOT NULL,
    `title`                     VARCHAR(255)    NULL,
    `description`               TEXT            NULL,
    `latitude`                  VARCHAR(255)    NULL,
    `longitude`                 VARCHAR(255)    NULL,
    `status`                    VARCHAR(255)    NULL,
    `quality_score`             INT             NULL,
    `created_at`                DATETIME(6)     NULL,
    `waste_type`                VARCHAR(255)    NULL,
    `area_id`                   INT             NULL,
    `waste_quantity`            DOUBLE          NULL,
    `item_weights`              TEXT            NULL,
    `note`                      TEXT            NULL,
    `waste_size`                VARCHAR(255)    NULL,
    `assigned_collector_id`     INT             NULL,
    `assigned_at`               DATETIME(6)     NULL,
    PRIMARY KEY (`report_id`),
    KEY `idx_waste_reports_citizen_id` (`citizen_id`),
    KEY `idx_waste_reports_area_id` (`area_id`),
    KEY `idx_waste_reports_assigned_collector_id` (`assigned_collector_id`),
    CONSTRAINT `fk_waste_reports_citizen`
        FOREIGN KEY (`citizen_id`) REFERENCES `citizens` (`citizen_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT `fk_waste_reports_area`
        FOREIGN KEY (`area_id`) REFERENCES `service_areas` (`area_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT `fk_waste_reports_assigned_collector`
        FOREIGN KEY (`assigned_collector_id`) REFERENCES `collectors` (`collector_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 8. TABLE: report_lifecycle
-- Entity: ReportLifecycle.java
-- ============================================================
CREATE TABLE IF NOT EXISTS `report_lifecycle` (
    `lifecycle_id`      INT         NOT NULL AUTO_INCREMENT,
    `collector_id`      INT         NULL,
    `report_id`         INT         NOT NULL,
    `enterprise_id`     INT         NULL,
    `accepted_at`       DATETIME(6) NULL,
    `assigned_at`       DATETIME(6) NULL,
    `collected_at`      DATETIME(6) NULL,
    PRIMARY KEY (`lifecycle_id`),
    KEY `idx_report_lifecycle_collector_id` (`collector_id`),
    KEY `idx_report_lifecycle_report_id` (`report_id`),
    KEY `idx_report_lifecycle_enterprise_id` (`enterprise_id`),
    CONSTRAINT `fk_report_lifecycle_collector`
        FOREIGN KEY (`collector_id`) REFERENCES `collectors` (`collector_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT `fk_report_lifecycle_report`
        FOREIGN KEY (`report_id`) REFERENCES `waste_reports` (`report_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT `fk_report_lifecycle_enterprise`
        FOREIGN KEY (`enterprise_id`) REFERENCES `enterprise` (`enterprise_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 9. TABLE: status_history
-- Entity: StatusHistory.java
-- ============================================================
CREATE TABLE IF NOT EXISTS `status_history` (
    `history_id`    INT             NOT NULL AUTO_INCREMENT,
    `report_id`     INT             NOT NULL,
    `old_status`    VARCHAR(255)    NULL,
    `new_status`    VARCHAR(255)    NULL,
    `changed_at`    DATETIME(6)     NULL,
    PRIMARY KEY (`history_id`),
    KEY `idx_status_history_report_id` (`report_id`),
    CONSTRAINT `fk_status_history_report`
        FOREIGN KEY (`report_id`) REFERENCES `waste_reports` (`report_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 10. TABLE: point_rules
-- Entity: PointRules.java
-- ============================================================
CREATE TABLE IF NOT EXISTS `point_rules` (
    `rule_id`                   INT             NOT NULL AUTO_INCREMENT,
    `waste_type_id`             INT             NULL,
    `enterprise_id`             INT             NULL,
    `rule_name`                 VARCHAR(255)    NOT NULL,
    `description`               VARCHAR(255)    NULL,
    `base_points_per_kg`        DOUBLE          NOT NULL    DEFAULT 10.0,
    `quality_bonus_multiplier`  DOUBLE          NOT NULL    DEFAULT 1.0,
    `min_quantity_for_bonus`    DOUBLE          NULL,
    `quantity_bonus`            INT             NULL        DEFAULT 0,
    `is_active`                 BIT(1)          NOT NULL    DEFAULT 1,
    `priority`                  INT             NULL        DEFAULT 0,
    `created_at`                DATETIME(6)     NULL,
    `updated_at`                DATETIME(6)     NULL,
    PRIMARY KEY (`rule_id`),
    KEY `idx_point_rules_waste_type_id` (`waste_type_id`),
    KEY `idx_point_rules_enterprise_id` (`enterprise_id`),
    CONSTRAINT `fk_point_rules_waste_type`
        FOREIGN KEY (`waste_type_id`) REFERENCES `waste_types` (`type_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT `fk_point_rules_enterprise`
        FOREIGN KEY (`enterprise_id`) REFERENCES `enterprise` (`enterprise_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 11. TABLE: point_transactions
-- Entity: PointTransaction.java
-- ============================================================
CREATE TABLE IF NOT EXISTS `point_transactions` (
    `transaction_id`    INT             NOT NULL AUTO_INCREMENT,
    `citizen_id`        INT             NOT NULL,
    `report_id`         INT             NULL,
    `points_awarded`    INT             NOT NULL,
    `reason`            VARCHAR(255)    NOT NULL,
    `created_at`        DATETIME(6)     NULL,
    PRIMARY KEY (`transaction_id`),
    KEY `idx_point_transactions_citizen_id` (`citizen_id`),
    KEY `idx_point_transactions_report_id` (`report_id`),
    CONSTRAINT `fk_point_transactions_citizen`
        FOREIGN KEY (`citizen_id`) REFERENCES `citizens` (`citizen_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT `fk_point_transactions_report`
        FOREIGN KEY (`report_id`) REFERENCES `waste_reports` (`report_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 12. TABLE: feedback
-- Entity: Feedback.java
-- ============================================================
CREATE TABLE IF NOT EXISTS `feedback` (
    `feedback_id`   INT             NOT NULL AUTO_INCREMENT,
    `citizen_id`    INT             NULL,
    `collector_id`  INT             NULL,
    `report_id`     INT             NOT NULL,
    `rater_type`    VARCHAR(255)    NOT NULL,
    `star_rating`   INT             NOT NULL,
    `description`   TEXT            NULL,
    `created_at`    DATETIME(6)     NULL,
    PRIMARY KEY (`feedback_id`),
    KEY `idx_feedback_citizen_id` (`citizen_id`),
    KEY `idx_feedback_collector_id` (`collector_id`),
    KEY `idx_feedback_report_id` (`report_id`),
    CONSTRAINT `fk_feedback_citizen`
        FOREIGN KEY (`citizen_id`) REFERENCES `citizens` (`citizen_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT `fk_feedback_collector`
        FOREIGN KEY (`collector_id`) REFERENCES `collectors` (`collector_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT `fk_feedback_report`
        FOREIGN KEY (`report_id`) REFERENCES `waste_reports` (`report_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 13. TABLE: waste_report_image
-- Entity: WasteReportImage.java
-- ============================================================
CREATE TABLE IF NOT EXISTS `waste_report_image` (
    `image_id`      INT             NOT NULL AUTO_INCREMENT,
    `report_id`     INT             NOT NULL,
    `image_type`    VARCHAR(255)    NULL,
    `source_type`   VARCHAR(255)    NULL,
    `image_url`     VARCHAR(255)    NULL,
    `created_at`    DATETIME(6)     NULL,
    PRIMARY KEY (`image_id`),
    KEY `idx_waste_report_image_report_id` (`report_id`),
    CONSTRAINT `fk_waste_report_image_report`
        FOREIGN KEY (`report_id`) REFERENCES `waste_reports` (`report_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 14. TABLE: feedback_image
-- Entity: FeedbackImage.java
-- ============================================================
CREATE TABLE IF NOT EXISTS `feedback_image` (
    `image_id`      INT             NOT NULL AUTO_INCREMENT,
    `feedback_id`   INT             NOT NULL,
    `image_url`     VARCHAR(255)    NULL,
    `created_at`    DATETIME(6)     NULL,
    PRIMARY KEY (`image_id`),
    KEY `idx_feedback_image_feedback_id` (`feedback_id`),
    CONSTRAINT `fk_feedback_image_feedback`
        FOREIGN KEY (`feedback_id`) REFERENCES `feedback` (`feedback_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 15. TABLE: enterprise_area
-- Entity: EnterpriseArea.java
-- ============================================================
CREATE TABLE IF NOT EXISTS `enterprise_area` (
    `id`                INT     NOT NULL AUTO_INCREMENT,
    `enterprise_id`     INT     NOT NULL,
    `area_id`           INT     NOT NULL,
    `is_active`         BIT(1)  NULL    DEFAULT 1,
    PRIMARY KEY (`id`),
    KEY `idx_enterprise_area_enterprise_id` (`enterprise_id`),
    KEY `idx_enterprise_area_area_id` (`area_id`),
    CONSTRAINT `fk_enterprise_area_enterprise`
        FOREIGN KEY (`enterprise_id`) REFERENCES `enterprise` (`enterprise_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT `fk_enterprise_area_area`
        FOREIGN KEY (`area_id`) REFERENCES `service_areas` (`area_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 16. TABLE: notification
-- Entity: Notification.java
-- ============================================================
CREATE TABLE IF NOT EXISTS `notification` (
    `id`        INT             NOT NULL AUTO_INCREMENT,
    `user_id`   INT             NOT NULL,
    `title`     VARCHAR(255)    NULL,
    `message`   TEXT            NULL,
    `is_read`   BIT(1)          NULL    DEFAULT 0,
    `type`      VARCHAR(255)    NULL,
    PRIMARY KEY (`id`),
    KEY `idx_notification_user_id` (`user_id`),
    CONSTRAINT `fk_notification_user`
        FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 17. TABLE: vouchers
-- Entity: Voucher.java
-- ============================================================
CREATE TABLE IF NOT EXISTS `vouchers` (
    `voucher_id`        INT             NOT NULL AUTO_INCREMENT,
    `enterprise_id`     INT             NOT NULL,
    `title`             VARCHAR(255)    NOT NULL,
    `description`       TEXT            NULL,
    `points_cost`       INT             NOT NULL,
    `quantity`          INT             NULL,
    `redeemed_count`    INT             NOT NULL    DEFAULT 0,
    `valid_from`        DATETIME(6)     NULL,
    `valid_until`       DATETIME(6)     NULL,
    `is_active`         BIT(1)          NOT NULL    DEFAULT 1,
    `image_url`         VARCHAR(255)    NULL,
    `created_at`        DATETIME(6)     NULL,
    `updated_at`        DATETIME(6)     NULL,
    PRIMARY KEY (`voucher_id`),
    KEY `idx_vouchers_enterprise_id` (`enterprise_id`),
    CONSTRAINT `fk_vouchers_enterprise`
        FOREIGN KEY (`enterprise_id`) REFERENCES `enterprise` (`enterprise_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 18. TABLE: voucher_redemptions
-- Entity: VoucherRedemption.java
-- ============================================================
CREATE TABLE IF NOT EXISTS `voucher_redemptions` (
    `redemption_id`     INT             NOT NULL AUTO_INCREMENT,
    `voucher_id`        INT             NOT NULL,
    `citizen_id`        INT             NOT NULL,
    `points_spent`      INT             NOT NULL,
    `redemption_code`   VARCHAR(255)    NOT NULL    UNIQUE,
    `status`            VARCHAR(255)    NOT NULL    DEFAULT 'ACTIVE',
    `redeemed_at`       DATETIME(6)     NOT NULL,
    `used_at`           DATETIME(6)     NULL,
    PRIMARY KEY (`redemption_id`),
    KEY `idx_voucher_redemptions_voucher_id` (`voucher_id`),
    KEY `idx_voucher_redemptions_citizen_id` (`citizen_id`),
    CONSTRAINT `fk_voucher_redemptions_voucher`
        FOREIGN KEY (`voucher_id`) REFERENCES `vouchers` (`voucher_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT `fk_voucher_redemptions_citizen`
        FOREIGN KEY (`citizen_id`) REFERENCES `citizens` (`citizen_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 19. TABLE: collector_requests
-- Entity: CollectorRequest.java
-- ============================================================
CREATE TABLE IF NOT EXISTS `collector_requests` (
    `id`                BIGINT          NOT NULL AUTO_INCREMENT,
    `user_id`           INT             NOT NULL,
    `enterprise_id`     INT             NOT NULL,
    `status`            VARCHAR(20)     NULL,
    `type`              VARCHAR(20)     NULL    DEFAULT 'JOIN',
    `reason`            TEXT            NULL,
    `created_at`        DATETIME(6)     NOT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_collector_requests_user_id` (`user_id`),
    KEY `idx_collector_requests_enterprise_id` (`enterprise_id`),
    CONSTRAINT `fk_collector_requests_user`
        FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT `fk_collector_requests_enterprise`
        FOREIGN KEY (`enterprise_id`) REFERENCES `enterprise` (`enterprise_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 20. TABLE: system_logs
-- Entity: SystemLog.java
-- ============================================================
CREATE TABLE IF NOT EXISTS `system_logs` (
    `id`            BIGINT          NOT NULL AUTO_INCREMENT,
    `level`         VARCHAR(255)    NOT NULL,
    `action`        VARCHAR(255)    NOT NULL,
    `message`       TEXT            NULL,
    `timestamp`     DATETIME(6)     NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 21. TABLE: collector_assignments
-- Entity: CollectorAssignment.java
-- ============================================================
CREATE TABLE IF NOT EXISTS `collector_assignments` (
    `assignment_id`         INT             NOT NULL AUTO_INCREMENT,
    `report_id`             INT             NOT NULL,
    `collector_id`          INT             NOT NULL,
    `allocated_weight`      DOUBLE          NOT NULL,
    `status`                VARCHAR(255)    NOT NULL,
    `assigned_at`           DATETIME(6)     NULL,
    `completed_at`          DATETIME(6)     NULL,
    `estimated_arrival`     DATETIME(6)     NULL,
    `accepted_latitude`     DOUBLE          NULL,
    `accepted_longitude`    DOUBLE          NULL,
    `completed_latitude`    DOUBLE          NULL,
    `completed_longitude`   DOUBLE          NULL,
    `completed_address`     VARCHAR(255)    NULL,
    PRIMARY KEY (`assignment_id`),
    KEY `idx_collector_assignments_report_id` (`report_id`),
    KEY `idx_collector_assignments_collector_id` (`collector_id`),
    CONSTRAINT `fk_collector_assignments_report`
        FOREIGN KEY (`report_id`) REFERENCES `waste_reports` (`report_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT `fk_collector_assignments_collector`
        FOREIGN KEY (`collector_id`) REFERENCES `collectors` (`collector_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 22. TABLE: location_sessions
-- Entity: LocationSession.java
-- Lưu ý: sessionId là String (UUID), không phải auto-increment
-- ============================================================
CREATE TABLE IF NOT EXISTS `location_sessions` (
    `session_id`    VARCHAR(36)     NOT NULL,
    `latitude`      DOUBLE          NULL,
    `longitude`     DOUBLE          NULL,
    `address`       VARCHAR(500)    NULL,
    `status`        VARCHAR(255)    NOT NULL    DEFAULT 'WAITING',
    `created_at`    DATETIME(6)     NOT NULL,
    `expires_at`    DATETIME(6)     NOT NULL,
    `user_id`       BIGINT          NULL,
    PRIMARY KEY (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 23. TABLE: rewards
-- Entity: Rewards.java
-- ============================================================
CREATE TABLE IF NOT EXISTS `rewards` (
    `reward_id`     INT         NOT NULL AUTO_INCREMENT,
    `citizen_id`    INT         NOT NULL,
    `report_id`     INT         NULL,
    `points`        INT         NULL,
    `created_at`    DATETIME(6) NULL,
    PRIMARY KEY (`reward_id`),
    KEY `idx_rewards_citizen_id` (`citizen_id`),
    KEY `idx_rewards_report_id` (`report_id`),
    CONSTRAINT `fk_rewards_citizen`
        FOREIGN KEY (`citizen_id`) REFERENCES `citizens` (`citizen_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT `fk_rewards_report`
        FOREIGN KEY (`report_id`) REFERENCES `waste_reports` (`report_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 24. TABLE: saved_locations
-- Entity: SavedLocation.java
-- ============================================================
CREATE TABLE IF NOT EXISTS `saved_locations` (
    `id`            INT             NOT NULL AUTO_INCREMENT,
    `user_id`       INT             NOT NULL,
    `label`         VARCHAR(255)    NOT NULL,
    `address`       VARCHAR(255)    NOT NULL,
    `latitude`      VARCHAR(255)    NULL,
    `longitude`     VARCHAR(255)    NULL,
    `created_at`    DATETIME(6)     NULL,
    PRIMARY KEY (`id`),
    KEY `idx_saved_locations_user_id` (`user_id`),
    CONSTRAINT `fk_saved_locations_user`
        FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 25. TABLE: system_feedbacks
-- Entity: SystemFeedback.java
-- ============================================================
CREATE TABLE IF NOT EXISTS `system_feedbacks` (
    `id`                INT             NOT NULL AUTO_INCREMENT,
    `sender_id`         INT             NOT NULL,
    `sender_role`       VARCHAR(255)    NOT NULL,
    `category`          VARCHAR(255)    NOT NULL,
    `rating`            INT             NOT NULL,
    `subject`           VARCHAR(255)    NOT NULL,
    `description`       TEXT            NOT NULL,
    `status`            VARCHAR(255)    NULL    DEFAULT 'NEW',
    `created_at`        DATETIME(6)     NULL,
    `admin_response`    TEXT            NULL,
    `responded_at`      DATETIME(6)     NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TỔNG KẾT: 25 TABLES
-- ============================================================
-- 1.  users                  - Bảng người dùng chính
-- 2.  citizens               - Thông tin công dân (FK → users)
-- 3.  enterprise             - Thông tin doanh nghiệp (FK → users)
-- 4.  collectors             - Thông tin người thu gom (FK → users, enterprise)
-- 5.  waste_types            - Loại rác thải
-- 6.  service_areas          - Khu vực dịch vụ
-- 7.  waste_reports          - Báo cáo rác thải (FK → citizens, service_areas, collectors)
-- 8.  report_lifecycle       - Vòng đời báo cáo (FK → collectors, waste_reports, enterprise)
-- 9.  status_history         - Lịch sử trạng thái (FK → waste_reports)
-- 10. point_rules            - Quy tắc tính điểm (FK → waste_types, enterprise)
-- 11. point_transactions     - Giao dịch điểm (FK → citizens, waste_reports)
-- 12. feedback               - Đánh giá/phản hồi (FK → citizens, collectors, waste_reports)
-- 13. waste_report_image     - Ảnh báo cáo rác (FK → waste_reports)
-- 14. feedback_image         - Ảnh phản hồi (FK → feedback)
-- 15. enterprise_area        - Khu vực doanh nghiệp (FK → enterprise, service_areas)
-- 16. notification           - Thông báo (FK → users)
-- 17. vouchers               - Phiếu giảm giá (FK → enterprise)
-- 18. voucher_redemptions    - Đổi phiếu giảm giá (FK → vouchers, citizens)
-- 19. collector_requests     - Yêu cầu thu gom (FK → users, enterprise)
-- 20. system_logs            - Nhật ký hệ thống
-- 21. collector_assignments  - Phân công thu gom (FK → waste_reports, collectors)
-- 22. location_sessions      - Phiên vị trí (PK: UUID string)
-- 23. rewards                - Phần thưởng (FK → citizens, waste_reports)
-- 24. saved_locations        - Vị trí đã lưu (FK → users)
-- 25. system_feedbacks       - Phản hồi hệ thống
-- ============================================================
