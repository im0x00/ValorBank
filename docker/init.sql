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
    (1, 'Necessity', 'Basic living and maintenance expenses'),
    (2, 'Health', 'Expenses directly invested in physical and mental health'),
    (3, 'Stability', 'Expenses to secure financial and life stability'),
    (4, 'Work / Income', 'Expenses for generating income or performing job duties'),
    (5, 'Growth / Skill', 'Expenses for personal growth and knowledge/skill expansion'),
    (6, 'Aesthetic / Self-Expression', 'Expenses for appearance, style, or self-expression'),
    (7, 'Experience / Leisure', 'Expenses for experiences, satisfaction, and leisure'),
    (8, 'Connection / Social', 'Expenses to maintain or strengthen social relationships'),
    (9, 'Contribution / Charity', 'Expenses contributing to others or society'),
    (10, 'Status / Signaling', 'Expenses to indicate social status or position'),
    (11, 'Convenience / Time-Saving', 'Expenses to save time or improve convenience'),
    (12, 'Future / Investment', 'Monetary investments for future value accumulation');