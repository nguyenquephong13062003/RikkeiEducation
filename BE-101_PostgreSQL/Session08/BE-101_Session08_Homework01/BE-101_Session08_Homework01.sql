CREATE SCHEMA mid1;
SET search_path TO mid1;

CREATE TABLE order_detail (
    id SERIAL PRIMARY KEY,
    order_id INT,
    product_name VARCHAR(100),
    quantity INT,
    unit_price NUMERIC(10,2)
);

INSERT INTO order_detail (order_id, product_name, quantity, unit_price) VALUES
    (1, 'Laptop Dell XPS 13', 1, 25000),
    (1, 'Chuột Logitech MX Master 3', 2, 2500),

    (2, 'iPhone 14 Pro', 1, 30000),
    (2, 'Tai nghe Sony WH-1000XM5', 1, 8000),

    (3, 'Samsung Galaxy S23', 2, 22000),

    (4, 'Màn hình LG UltraWide', 1, 12000),
    (4, 'Bàn phím cơ Keychron K8', 1, 3500),

    (5, 'Ổ cứng SSD Samsung 1TB', 3, 4000),

    (6, 'Loa Bluetooth JBL', 2, 1500),
    (6, 'Camera Xiaomi', 1, 2000);

SELECT * FROM order_detail;

CREATE OR REPLACE PROCEDURE calculate_order_total (
    IN order_id_input INT,
    OUT total NUMERIC(10,2)
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- 1. Tính tổng giá trị đơn hàng
    SELECT SUM(unit_price * quantity)
    INTO total
    FROM order_detail
    WHERE order_id = order_id_input;

    -- 2. Nếu không có đơn hàng → total = 0
    IF total IS NULL THEN
        total := 0;
    END IF;

END;
$$;

CALL calculate_order_total(1, NULL);
