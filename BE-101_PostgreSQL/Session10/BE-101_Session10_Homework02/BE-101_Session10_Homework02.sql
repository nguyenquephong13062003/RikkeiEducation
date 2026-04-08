CREATE SCHEMA hw02;
SET search_path TO hw02;

CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    credit_limit NUMERIC(12,2)
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(id),
    order_amount NUMERIC(12,2)
);

CREATE OR REPLACE FUNCTION check_credit_limit()
    RETURNS TRIGGER AS $$
DECLARE
    v_total_amount NUMERIC(12,2);
    v_credit_limit NUMERIC(12,2);
BEGIN
    -- Lấy tổng đơn hiện tại
    SELECT COALESCE(SUM(order_amount), 0)
    INTO v_total_amount
    FROM orders
    WHERE customer_id = NEW.customer_id;

    -- Lấy hạn mức
    SELECT credit_limit
    INTO v_credit_limit
    FROM customers
    WHERE id = NEW.customer_id;

    -- Kiểm tra vượt hạn mức
    IF  v_credit_limit < v_total_amount + NEW.order_amount THEN
        RAISE EXCEPTION
            'Vượt hạn mức tín dụng! Tổng: %, Đơn mới: %, Hạn mức: %',
            v_total_amount, NEW.order_amount, v_credit_limit;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_credit
BEFORE INSERT ON orders
FOR EACH ROW
EXECUTE FUNCTION check_credit_limit();

INSERT INTO customers (name, credit_limit) VALUES
    ('Nguyen Van A', 1000),
    ('Tran Thi B', 2000);

INSERT INTO orders (customer_id, order_amount) VALUES
    (1, 300),
    (1, 400);

INSERT INTO orders (customer_id, order_amount)
VALUES (1, 400);
/*
    ERROR: Vượt hạn mức tín dụng! Tổng: 700.00, Đơn mới: 400.00, Hạn mức: 1000.00
*/

SELECT * FROM orders;
