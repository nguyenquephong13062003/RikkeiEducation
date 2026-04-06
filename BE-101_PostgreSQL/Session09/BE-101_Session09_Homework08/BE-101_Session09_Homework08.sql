CREATE DATABASE Session09;

CREATE SCHEMA homework08;
SET search_path TO homework08;

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    total_spent NUMERIC(10,2) DEFAULT 0.00
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    total_amount NUMERIC(10,2)
);

INSERT INTO customers (name, total_spent) VALUES
    ('Nguyen Van A', 0.00),
    ('Tran Thi B', 1000.00),
    ('Le Van C', 500.00);

SELECT * FROM customers;

CREATE OR REPLACE PROCEDURE add_order_and_update_customer(
    IN p_customer_id INT,
    IN p_amount NUMERIC(10,2)
)
    LANGUAGE plpgsql
AS $$
DECLARE
    v_exists INT;
BEGIN
    -- 1. Kiểm tra khách hàng tồn tại
    SELECT 1 INTO v_exists
    FROM customers
    WHERE customer_id = p_customer_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Customer not found';
    END IF;

    -- 2. Thêm đơn hàng
    INSERT INTO orders(customer_id, total_amount)
    VALUES (p_customer_id, p_amount);

    -- 3. Cập nhật tổng chi tiêu
    UPDATE customers
    SET total_spent = total_spent + p_amount
    WHERE customer_id = p_customer_id;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Insert order failed: %', SQLERRM;

END;
$$;

CALL add_order_and_update_customer(1, 500);

SELECT * FROM orders;

SELECT * FROM customers;

