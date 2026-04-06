CREATE SCHEMA homework01;
SET search_path TO homework01;

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount NUMERIC(10,2)
);

INSERT INTO orders (customer_id, order_date, total_amount)
SELECT
    (RANDOM() * 100)::INT,
    CURRENT_DATE - (RANDOM() * 30)::INT,
    (RANDOM() * 1000)::NUMERIC
FROM generate_series(1, 10000);

EXPLAIN ANALYZE
SELECT *
FROM orders
WHERE customer_id = 10;

CREATE INDEX idx_orders_customer
ON orders(customer_id);

EXPLAIN ANALYZE
SELECT *
FROM orders
WHERE customer_id = 10;

SELECT *
FROM orders
WHERE customer_id = 10;
