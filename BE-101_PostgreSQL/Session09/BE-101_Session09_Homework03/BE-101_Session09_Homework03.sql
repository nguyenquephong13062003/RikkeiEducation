CREATE SCHEMA homework03;
SET search_path TO homework03;

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    category_id INT,
    price NUMERIC(10,2),
    stock_quantity INT
);

INSERT INTO products (category_id, price, stock_quantity) VALUES
    (1, 1000, 50),
    (1, 1500, 30),
    (1, 1200, 20),
    (1, 1800, 10),

    (2, 2000, 25),
    (2, 2200, 15),
    (2, 2100, 40),
    (2, 2500, 5),

    (3, 3000, 12),
    (3, 3200, 8),
    (3, 3100, 18),
    (3, 3500, 6);

EXPLAIN ANALYZE
SELECT *
FROM products
WHERE category_id = 1
ORDER BY price;

CREATE INDEX idx_products_category
ON products(category_id);
CLUSTER products USING idx_products_category;

CREATE INDEX idx_products_price
ON products(price);

EXPLAIN ANALYZE
SELECT *
FROM products
WHERE category_id = 1
ORDER BY price;

SELECT *
FROM products
WHERE category_id = 1
ORDER BY price;