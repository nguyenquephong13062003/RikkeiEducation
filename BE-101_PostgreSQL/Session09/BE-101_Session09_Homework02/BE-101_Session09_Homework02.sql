CREATE SCHEMA homework02;
SET search_path TO homework02;

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    email VARCHAR(100),
    username VARCHAR(100)
);

INSERT INTO users (email, username) VALUES
    ('a@gmail.com', 'user_a'),
    ('b@gmail.com', 'user_b'),
    ('c@gmail.com', 'user_c'),
    ('example@example.com', 'target_user'),
    ('d@gmail.com', 'user_d');

EXPLAIN ANALYZE
SELECT *
FROM users
WHERE email = 'example@example.com';

CREATE INDEX idx_users_email_hash
ON users USING HASH (email);

EXPLAIN ANALYZE
SELECT *
FROM users
WHERE email = 'example@example.com';

SELECT *
FROM users
WHERE email = 'example@example.com';
