CREATE SCHEMA hw01;
SET search_path TO hw01;

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    price NUMERIC(10,2),
    last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO products (name, price) VALUES
    ('Laptop Dell', 1500),
    ('iPhone 14', 1200);

SELECT * FROM products;

CREATE OR REPLACE FUNCTION update_last_modified()
RETURNS TRIGGER AS $$
BEGIN

    IF NEW IS DISTINCT FROM OLD THEN
        NEW.last_modified := CURRENT_TIMESTAMP;
    END IF;
    RETURN NEW;

END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_last_modified
BEFORE UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION update_last_modified();

UPDATE products
SET price = 1800
WHERE id = 1;

SELECT * FROM products WHERE id = 1;
