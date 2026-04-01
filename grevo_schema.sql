-- GREVO System Database Schema DDL
-- Generated from JPA Entities

CREATE TABLE citizens (
    citizen_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT
);

CREATE TABLE collector_assignments (
    assignment_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    allocated_weight DOUBLE,
    status VARCHAR(255),
    assigned_at DATETIME,
    completed_at DATETIME,
    estimated_arrival DATETIME,
    accepted_latitude DOUBLE,
    accepted_longitude DOUBLE,
    completed_latitude DOUBLE,
    completed_longitude DOUBLE,
    completed_address VARCHAR(255),
    report_id BIGINT,
    collector_id BIGINT
);

CREATE TABLE collector_requests (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    status VARCHAR(255),
    reason VARCHAR(255),
    created_at DATETIME,
    user_id BIGINT,
    enterprise_id BIGINT
);

CREATE TABLE collectors (
    collector_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    vehicle_type VARCHAR(255),
    vehicle_plate VARCHAR(255),
    max_capacity INT,
    current_status VARCHAR(255),
    leave_reason VARCHAR(255),
    last_active_at DATETIME,
    user_id BIGINT,
    enterprise_id BIGINT
);

CREATE TABLE enterprise (
    enterprise_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    company_name VARCHAR(255),
    company_phone VARCHAR(255),
    company_email VARCHAR(255),
    company_adr VARCHAR(255),
    tax_code VARCHAR(255),
    capacity INT,
    logo_url VARCHAR(255),
    user_id BIGINT
);

CREATE TABLE enterprise_area (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    enterprise_id BIGINT,
    area_id BIGINT
);

CREATE TABLE feedback (
    feedback_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    rater_type VARCHAR(255),
    star_rating INT,
    description VARCHAR(255),
    created_at DATETIME,
    citizen_id BIGINT,
    collector_id BIGINT,
    report_id BIGINT
);

CREATE TABLE feedback_image (
    image_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    image_url VARCHAR(255),
    created_at DATETIME,
    feedback_id BIGINT
);

CREATE TABLE location_sessions (
    session_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    latitude DOUBLE,
    longitude DOUBLE,
    address VARCHAR(255),
    created_at DATETIME,
    expires_at DATETIME,
    user_id BIGINT
);

CREATE TABLE notification (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255),
    message VARCHAR(255),
    type VARCHAR(255),
    user_id BIGINT
);

CREATE TABLE point_rules (
    rule_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    rule_name VARCHAR(255),
    description VARCHAR(255),
    min_quantity_for_bonus DOUBLE,
    created_at DATETIME,
    updated_at DATETIME,
    waste_type_id BIGINT,
    enterprise_id BIGINT
);

CREATE TABLE point_transactions (
    transaction_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    points_awarded INT,
    reason VARCHAR(255),
    created_at DATETIME,
    citizen_id BIGINT,
    report_id BIGINT
);

CREATE TABLE report_lifecycle (
    lifecycle_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    accepted_at DATETIME,
    assigned_at DATETIME,
    collected_at DATETIME,
    collector_id BIGINT,
    report_id BIGINT,
    enterprise_id BIGINT
);

CREATE TABLE rewards (
    reward_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    points INT,
    created_at DATETIME,
    citizen_id BIGINT,
    report_id BIGINT
);

CREATE TABLE saved_locations (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    label VARCHAR(255),
    address VARCHAR(255),
    latitude VARCHAR(255),
    longitude VARCHAR(255),
    created_at DATETIME,
    user_id BIGINT
);

CREATE TABLE service_areas (
    area_id BIGINT,
    area_name VARCHAR(255),
    area_code VARCHAR(255),
    type VARCHAR(255),
    lat DOUBLE,
    lng DOUBLE
);

CREATE TABLE status_history (
    history_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    old_status VARCHAR(255),
    new_status VARCHAR(255),
    changed_at DATETIME,
    report_id BIGINT
);

CREATE TABLE system_feedbacks (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    sender_id BIGINT,
    sender_role VARCHAR(255),
    category VARCHAR(255),
    rating INT,
    subject VARCHAR(255),
    description VARCHAR(255),
    created_at DATETIME,
    admin_response VARCHAR(255),
    responded_at DATETIME
);

CREATE TABLE system_logs (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    level VARCHAR(255),
    action VARCHAR(255),
    message VARCHAR(255),
    timestamp DATETIME
);

CREATE TABLE users (
    user_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    google_id BIGINT,
    username VARCHAR(255),
    password VARCHAR(255),
    create_at DATETIME,
    update_at DATETIME,
    full_name VARCHAR(255),
    email VARCHAR(255),
    temp_email VARCHAR(255),
    phone VARCHAR(255),
    address VARCHAR(255),
    rs_password_token VARCHAR(255),
    rs_password_t_expiry DATETIME,
    verification_code VARCHAR(255),
    verification_code_expiry DATETIME,
    avatar VARCHAR(255)
);

CREATE TABLE vouchers (
    voucher_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255),
    description VARCHAR(255),
    points_cost INT,
    quantity INT,
    valid_from DATETIME,
    valid_until DATETIME,
    image_url VARCHAR(255),
    created_at DATETIME,
    updated_at DATETIME,
    enterprise_id BIGINT
);

CREATE TABLE voucher_redemptions (
    redemption_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    points_spent INT,
    redemption_code VARCHAR(255),
    redeemed_at DATETIME,
    used_at DATETIME,
    voucher_id BIGINT,
    citizen_id BIGINT
);

CREATE TABLE waste_report_image (
    image_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    image_type VARCHAR(255),
    source_type VARCHAR(255),
    image_url VARCHAR(255),
    created_at DATETIME,
    report_id BIGINT
);

CREATE TABLE waste_reports (
    report_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255),
    description VARCHAR(255),
    latitude VARCHAR(255),
    longitude VARCHAR(255),
    status VARCHAR(255),
    quality_score INT,
    created_at DATETIME,
    waste_type VARCHAR(255),
    waste_quantity DOUBLE,
    item_weights VARCHAR(255),
    note VARCHAR(255),
    waste_size VARCHAR(255),
    assigned_at DATETIME,
    citizen_id BIGINT,
    area_id BIGINT,
    assigned_collector_id BIGINT
);

CREATE TABLE waste_types (
    type_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255),
    base_points INT
);

