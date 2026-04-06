CREATE SCHEMA mid2;
SET search_path TO mid2;

CREATE TABLE inventory (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    quantity INT
);

INSERT INTO inventory (product_name, quantity) VALUES
    ('Laptop Dell XPS 13', 10),
    ('iPhone 14 Pro', 5),
    ('Samsung Galaxy S23', 0),
    ('Tai nghe Sony WH-1000XM5', 15),
    ('Chuột Logitech MX Master 3', 50),
    ('Bàn phím cơ Keychron K8', 20),
    ('Màn hình LG UltraWide', 7),
    ('Ổ cứng SSD Samsung 1TB', 0),
    ('Loa Bluetooth JBL', 30),
    ('Camera Xiaomi', 3);

SELECT * FROM inventory;

CREATE OR REPLACE PROCEDURE check_stock (
    IN p_id INT,
    IN p_qty INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_quantity INT;
BEGIN
    -- 1. Kiểm tra hàng tồn tại + lấy quantity
    SELECT quantity
    INTO v_quantity
    FROM inventory
    WHERE product_id = p_id;

    -- 2. Kiểm tra tồn tại
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Inventory not found';
    END IF;

    -- 3. Kiểm tra đủ hàng hay không
    IF v_quantity < p_qty THEN
        RAISE EXCEPTION 'Không đủ hàng trong kho';
    END IF;

    -- 4. Nếu đủ hàng
    RAISE NOTICE 'Đủ hàng trong kho (còn % sản phẩm)', v_quantity;

END;
$$;

CALL check_stock(1, 5);

CALL check_stock(3, 2);
