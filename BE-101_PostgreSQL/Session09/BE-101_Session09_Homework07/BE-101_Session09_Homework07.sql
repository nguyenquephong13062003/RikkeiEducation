CREATE SCHEMA homework07;
SET search_path TO homework07;

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT,
    amount NUMERIC(10,2),
    order_date DATE DEFAULT CURRENT_DATE
);

INSERT INTO customers (name, email) VALUES
    ('Nguyen Van A', 'a@gmail.com'),
    ('Tran Thi B', 'b@gmail.com');

SELECT * FROM customers;

CREATE OR REPLACE PROCEDURE add_order(
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
        RAISE EXCEPTION 'Customer does not exist';
    END IF;

    -- 2. Thêm đơn hàng
    INSERT INTO orders(customer_id, amount)
    VALUES (p_customer_id, p_amount);

END;
$$;

CALL add_order(1, 500);

CALL add_order(999, 100);

SELECT * FROM orders;
