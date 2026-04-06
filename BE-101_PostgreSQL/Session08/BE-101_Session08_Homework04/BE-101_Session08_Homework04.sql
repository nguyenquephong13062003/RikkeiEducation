CREATE SCHEMA good2;
SET search_path TO good2;

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    price NUMERIC(10,2),
    discount_percent INT
);

INSERT INTO products (name, price, discount_percent) VALUES
    ('Laptop Dell XPS 13', 25000.00, 10),
    ('iPhone 14 Pro', 30000.00, 55),
    ('Samsung Galaxy S23', 22000.00, 8),
    ('Tai nghe Sony WH-1000XM5', 8000.00, 15),
    ('Chuột Logitech MX Master 3', 2500.00, 20),
    ('Bàn phím cơ Keychron K8', 3500.00, 12),
    ('Màn hình LG UltraWide', 12000.00, 7),
    ('Ổ cứng SSD Samsung 1TB', 4000.00, 18),
    ('Loa Bluetooth JBL', 1500.00, 25),
    ('Camera Xiaomi', 2000.00, 30);

SELECT * FROM products;

CREATE OR REPLACE PROCEDURE calculate_discount (
    IN p_id INT,
    OUT p_final_price NUMERIC(10, 2)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_price NUMERIC(10,2);
    v_discount_percent INT;
BEGIN
    -- 1. Kiểm tra sản phẩm tồn tại + lấy price
    SELECT price, discount_percent
    INTO v_price, v_discount_percent
    FROM products
    WHERE id = p_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Product not found';
    END IF;

    -- 2. Kiểm tra discount_percent > 50
    IF v_discount_percent > 50 THEN
        p_final_price := v_price / 2;
    ELSE
        -- 3. Tính final_price
        p_final_price := v_price - (v_price * v_discount_percent / 100);
    END IF;

    -- 4. Cập nhật vào bảng
    UPDATE products
    SET price = p_final_price
    WHERE id = p_id;

END;
$$;

CALL calculate_discount(1, NULL);

CALL calculate_discount(2, NULL);
SELECT * FROM products WHERE id = 2;

CALL calculate_discount(999, NULL);

SELECT * FROM products;
