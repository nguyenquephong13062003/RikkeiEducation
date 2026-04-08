CREATE SCHEMA hw04;
SET search_path TO hw04;

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    stock INT
);

INSERT INTO products (name, stock) VALUES
    ('Laptop Dell', 10),
    ('iPhone 14', 20),
    ('Chuột Logitech', 50),
    ('Bàn phím cơ', 30),
    ('Tai nghe Sony', 15);

SELECT * FROM products;

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    product_id INT REFERENCES products(id),
    quantity INT
);

CREATE OR REPLACE FUNCTION trg_func_insert_order ()
    RETURNS TRIGGER AS $$
DECLARE
    v_stock INT;
BEGIN
    SELECT stock
    INTO v_stock
    FROM products
    WHERE id = NEW.product_id;

    IF v_stock < NEW.quantity THEN
        RAISE EXCEPTION 'Không đủ hàng trong kho';
    END IF;

    UPDATE products
    SET stock = stock - NEW.quantity
    WHERE id = NEW.product_id;

    RETURN NEW;

END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_insert_order
BEFORE INSERT ON orders
FOR EACH ROW
EXECUTE FUNCTION trg_func_insert_order();

INSERT INTO orders (product_id, quantity) VALUES
    -- Laptop Dell (stock: 10)
    (1, 2),
    (1, 1),

    -- iPhone 14 (stock: 20)
    (2, 3),
    (2, 5),

    -- Chuột Logitech (stock: 50)
    (3, 10),
    (3, 5),

    -- Bàn phím cơ (stock: 30)
    (4, 4),
    (4, 2),

    -- Tai nghe Sony (stock: 15)
    (5, 3),
    (5, 2);

SELECT * FROM orders;
SELECT * FROM products;

INSERT INTO orders (product_id, quantity) VALUES
    -- Laptop Dell (stock: 7)
    (1, 9);
/*
    ERROR: Không đủ hàng trong kho
*/

CREATE OR REPLACE FUNCTION trg_func_update_order ()
RETURNS TRIGGER AS $$
DECLARE
    v_stock INT;
BEGIN
    SELECT stock
    INTO v_stock
    FROM products
    WHERE id = NEW.product_id;

    IF v_stock < NEW.quantity - OLD.quantity THEN
        RAISE EXCEPTION 'Không đủ hàng trong kho';
    END IF;

    UPDATE products
    SET stock = stock - NEW.quantity + OLD.quantity
    WHERE id = NEW.product_id;

    RETURN NEW;

END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_order
BEFORE UPDATE ON orders
FOR EACH ROW
EXECUTE FUNCTION trg_func_update_order();

UPDATE orders
SET quantity = 7 -- OLD: 5, stock: 12
WHERE id = 4;

SELECT * FROM orders WHERE id = 4;
SELECT * FROM products WHERE id = 2;

UPDATE orders
SET quantity = 6 -- OLD: 10, stock: 35
WHERE id = 5;

SELECT * FROM orders WHERE id = 5;
SELECT * FROM products WHERE id = 3;

UPDATE orders
SET quantity = 60 -- OLD: 4, stock: 24
WHERE id = 7;
/*
    ERROR: Không đủ hàng trong kho
*/

SELECT * FROM orders WHERE id = 7;
SELECT * FROM products WHERE id = 4;

CREATE OR REPLACE FUNCTION trg_func_delete_order ()
RETURNS TRIGGER AS $$
BEGIN

    UPDATE products
    SET stock = stock + OLD.quantity
    WHERE id = OLD.product_id;

    RETURN OLD;

END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_delete_order
BEFORE DELETE ON orders
FOR EACH ROW
EXECUTE FUNCTION trg_func_delete_order();

DELETE FROM orders WHERE id = 10;  -- OLD: 2, stock: 10

SELECT * FROM products WHERE id = 5;