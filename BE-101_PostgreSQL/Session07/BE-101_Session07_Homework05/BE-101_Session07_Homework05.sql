CREATE DATABASE Shop_DB;

CREATE SCHEMA shop;
SET search_path TO shop;


CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    city VARCHAR(50)
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    category TEXT,
    price NUMERIC(10, 2)
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    product_id INT REFERENCES products(product_id),
    order_date DATE,
    quantity INT
);


---

-- 1
INSERT INTO customers (full_name, email, city) VALUES
    ('Nguyen Van A', 'a@gmail.com', 'HCM'),
    ('Tran Thi B', 'b@gmail.com', 'Hanoi'),
    ('Le Van C', 'c@gmail.com', 'Danang'),
    ('Pham Thi D', 'd@gmail.com', 'HCM'),
    ('Hoang Van E', 'e@gmail.com', 'Can Tho');

INSERT INTO products (product_name, category, price) VALUES
    ('Laptop Dell', 'Electronics Computer', 1000),
    ('iPhone 13', 'Electronics Phone', 900),
    ('Office Chair', 'Furniture Office', 300),
    ('Gaming Mouse', 'Electronics Accessories', 50),
    ('Air Conditioner', 'Electronics Home', 700);

INSERT INTO orders (customer_id, product_id, order_date, quantity) VALUES
    (1, 1, '2025-01-01', 1),
    (2, 2, '2025-01-02', 2),
    (3, 3, '2025-01-03', 1),
    (4, 4, '2025-01-04', 3),
    (5, 5, '2025-01-05', 1),
    (1, 2, '2025-01-06', 1),
    (2, 3, '2025-01-07', 2),
    (3, 4, '2025-01-08', 1),
    (4, 5, '2025-01-09', 1),
    (5, 1, '2025-01-10', 2);

-- 2
-- 2.a
CREATE INDEX idx_customers_email
ON customers(email);
--2.b
CREATE INDEX idx_customers_city_hash
ON customers USING HASH(city);
-- 2.c
CREATE INDEX idx_products_category_gin
ON products USING GIN (to_tsvector('english', category));
-- 2.d
CREATE INDEX idx_products_price_gist
ON products USING GIST (numrange(price, price, '[]'));


-- 3
-- 3.a
EXPLAIN ANALYZE
SELECT * FROM customers
WHERE email = 'a@gmail.com';
-- 3.b
EXPLAIN ANALYZE
SELECT *
FROM products
WHERE to_tsvector('english', category) @@ to_tsquery('Electronics');
-- 3.c
EXPLAIN ANALYZE
SELECT *
FROM products
WHERE numrange(price, price, '[]') && numrange(500, 1000, '[]');


-- 4
CREATE INDEX idx_orders_date
    ON orders(order_date);

CLUSTER orders USING idx_orders_date;


-- 5
-- 5.a
CREATE VIEW v_top_customers AS
SELECT c.customer_id, c.full_name, SUM(o.quantity) AS total_quantity
FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY total_quantity DESC
LIMIT 3;

SELECT * FROM v_top_customers;
-- 5.b
CREATE VIEW v_product_revenue AS
SELECT
    p.product_id,
    p.product_name,
    SUM(o.quantity * p.price) AS total_revenue
FROM products p
    JOIN orders o ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name;

SELECT * FROM v_product_revenue;


-- 6
-- 6.a
CREATE VIEW v_customer_city AS
SELECT customer_id, full_name, city
FROM customers
WITH CHECK OPTION;
-- 6.b
UPDATE v_customer_city
SET city = 'Hue'
WHERE customer_id = 1;

SELECT * FROM customers WHERE customer_id = 1;

