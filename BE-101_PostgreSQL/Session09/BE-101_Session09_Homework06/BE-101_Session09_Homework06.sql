CREATE SCHEMA homework06;
SET search_path TO homework06;

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    price NUMERIC(10,2),
    category_id INT
);

INSERT INTO products (name, price, category_id) VALUES
    ('Laptop Dell', 20000, 1),
    ('iPhone 14', 25000, 1),
    ('Bàn phím cơ', 3000, 2),
    ('Chuột Logitech', 1500, 2),
    ('Màn hình LG', 8000, 1);

SELECT * FROM products;

CREATE OR REPLACE PROCEDURE update_product_price(
    IN p_category_id INT,
    IN p_increase_percent NUMERIC(5,2)
)
LANGUAGE plpgsql
AS $$
DECLARE
    rec RECORD;
    v_new_price NUMERIC(10,2);
BEGIN
    -- 1. Duyệt từng sản phẩm trong category
    FOR rec IN
        SELECT product_id, price
        FROM products
        WHERE category_id = p_category_id
        LOOP
            -- 2. Tính giá mới
            v_new_price := rec.price + (rec.price * p_increase_percent / 100);

            -- 3. Cập nhật
            UPDATE products
            SET price = v_new_price
            WHERE product_id = rec.product_id;
        END LOOP;

END;
$$;

CALL update_product_price(1, 10);

SELECT * FROM products;
