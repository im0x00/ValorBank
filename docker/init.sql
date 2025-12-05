CREATE DATABASE IF NOT EXISTS valorbankdb
    DEFAULT CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

DROP USER IF EXISTS 'valorbank_admin'@'%';

CREATE USER 'valorbank_admin'@'%' IDENTIFIED BY 'moneyitselfhasnomeaning';

GRANT ALL PRIVILEGES ON valorbankdb.* TO 'valorbank_admin'@'%';

FLUSH PRIVILEGES;

USE valorbankdb;

CREATE TABLE user (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    login_id VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(10) NOT NULL DEFAULT 'USER', -- 'USER', 'ADMIN'
    name VARCHAR(30) NOT NULL
);

CREATE TABLE main_account (
    main_account_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE ,
    balance DECIMAL(15, 2) DEFAULT 0.00,
    account_number BIGINT UNIQUE,
    FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE
);

CREATE TABLE value (
    value_id INT PRIMARY KEY,
    value_name VARCHAR(50) NOT NULL,
    description TEXT
);

CREATE TABLE personal_value_weight (
    user_id INT NOT NULL,
    value_id INT NOT NULL,
    weight DECIMAL(5,2) NOT NULL,
    PRIMARY KEY (user_id, value_id),
    FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE,
    FOREIGN KEY (value_id) REFERENCES value(value_id)
);

CREATE TABLE value_account (
    user_id INT NOT NULL,
    value_id INT NOT NULL,
    balance DECIMAL(15,2) DEFAULT 0.00,
    PRIMARY KEY (user_id, value_id),
    FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE,
    FOREIGN KEY (value_id) REFERENCES value(value_id)
);

CREATE TABLE transaction (
    transaction_id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    user_id INT NOT NULL,
    amount DECIMAL(15,2) NOT NULL,

    type VARCHAR(10) NOT NULL, -- 'DEPOSIT', 'EXPENSE'
    status VARCHAR(10) DEFAULT 'UNSCORED', -- 'UNSCORED', 'SCORED'
    description VARCHAR(100), -- 사용처 기록 (예: StarBucks)

    transaction_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE
);

CREATE TABLE transaction_value (
    transaction_id INT NOT NULL,
    value_id INT NOT NULL,
    score TINYINT NOT NULL CHECK (score BETWEEN 0 AND 5),
    allocated_amount DECIMAL(15,2) NOT NULL,
    PRIMARY KEY (transaction_id, value_id),
    FOREIGN KEY (transaction_id) REFERENCES transaction(transaction_id) ON DELETE CASCADE,
    FOREIGN KEY (value_id) REFERENCES value(value_id)
);

INSERT INTO value (value_id, value_name, description) VALUES
    (1, 'Necessity', '기본 생계 및 생활유지 비용'),
    (2, 'Health', '신체·정신 건강에 직접 투자되는 비용'),
    (3, 'Stability', '재무적·생활 안정성 확보 비용'),
    (4, 'Work / Income', '수입 창출 혹은 직무 수행을 위해 직접 지출되는 비용'),
    (5, 'Growth / Skill', '개인 역량·지식 확장 목적의 비용'),
    (6, 'Aesthetic / Self-Expression', '외적 표현·스타일·이미지 구축을 위한 비용'),
    (7, 'Experience / Leisure', '경험 기반의 만족·휴식'),
    (8, 'Connection / Social', '인간관계 유지·강화 목적의 지출'),
    (9, 'Contribution / Charity', '타인·사회에 기여하는 지출'),
    (10, 'Status / Signaling', '사회적 지위·신분 표시를 위해 소비되는 비용'),
    (11, 'Convenience / Time-Saving', '시간 절약·편의성 확보를 위한 비용'),
    (12, 'Future / Investment', '미래 가치 축적을 위한 금전적 투자');