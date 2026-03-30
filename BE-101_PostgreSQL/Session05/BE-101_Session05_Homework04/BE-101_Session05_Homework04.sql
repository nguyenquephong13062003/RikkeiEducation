-- 1. Create schema good2
CREATE SCHEMA good2;
-- 2. Create company tables
CREATE TABLE good2.customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE good2.orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES good2.customers(customer_id),
    order_date DATE,
    total_amount NUMERIC(10, 2)
);

CREATE TABLE good2.order_item (
    item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES good2.orders(order_id),
    product_name VARCHAR(100),
    quantity INT,
    price NUMERIC(10, 2)
);

-- 3. Insert data into database
INSERT INTO good2.customers (customer_name, city) VALUES
    ('Nguyen Van A', 'Ho Chi Minh'),
    ('Tran Thi B', 'Ha Noi'),
    ('Le Van C', 'Da Nang'),
    ('Pham Thi D', 'Ho Chi Minh'),
    ('Hoang Van E', 'Can Tho');

INSERT INTO good2.orders (customer_id, order_date, total_amount) VALUES
    (1, '2024-01-10', 5000),
    (1, '2024-02-15', 7000),
    (2, '2024-01-12', 3000),
    (2, '2024-03-20', 12000),
    (3, '2024-02-05', 8000),
    (4, '2024-01-25', 2000),
    (4, '2024-03-01', 15000),
    (5, '2024-02-18', 4000),
    (5, '2024-03-22', 6000);

INSERT INTO good2.order_item (order_id, product_name, quantity, price) VALUES
    (1, 'Laptop', 1, 5000),
    (2, 'Phone', 1, 7000),
    (3, 'Headphones', 2, 1500),
    (4, 'Tablet', 1, 12000),
    (5, 'Monitor', 2, 4000),
    (6, 'Mouse', 2, 1000),
    (7, 'Keyboard', 3, 5000),
    (8, 'USB', 4, 1000),
    (9, 'Charger', 2, 3000);

SELECT * FROM good2.customers;
SELECT * FROM good2.orders;
SELECT * FROM good2.order_item;

-- 4. ALIAS
/*
    Hiển thị danh sách tất cả các đơn hàng với các cột:
    - Tên khách (customer_name)
    - Ngày đặt hàng (order_date)
    - Tổng tiền (total_amount)
*/
SELECT
    c.customer_name AS "Tên khách",
    o.order_date AS "Ngày đặt hàng",
    o.total_amount AS "Tổng tiền"
FROM good2.orders o
    JOIN good2.customers c ON o.customer_id = c.customer_id;

-- 5. Aggregate Functions
/*
    Tính các thông tin tổng hợp:
        Tổng doanh thu (SUM(total_amount))
        Trung bình giá trị đơn hàng (AVG(total_amount))
        Đơn hàng lớn nhất (MAX(total_amount))
        Đơn hàng nhỏ nhất (MIN(total_amount))
        Số lượng đơn hàng (COUNT(order_id))
*/
SELECT
    SUM(total_amount) AS "Tổng doanh thu",
    AVG(total_amount) AS "Trung bình đơn hàng",
    MAX(total_amount) AS "Đơn hàng lớn nhất",
    MIN(total_amount) AS "Đơn hàng nhỏ nhất",
    COUNT(order_id) AS "Số lượng đơn hàng"
FROM good2.orders;

-- 6. GROUP BY / HAVING
/*
    Tính tổng doanh thu theo từng thành phố
    chỉ hiển thị những thành phố có tổng doanh thu lớn hơn 10.000
*/
SELECT
    c.city AS "Thành phố",
    SUM(o.total_amount) AS "Tổng doanh thu"
FROM good2.customers c
    JOIN good2.orders o ON c.customer_id = o.customer_id
GROUP BY c.city
HAVING SUM(o.total_amount) > 10000;

-- 7. JOIN
/*
    Liệt kê tất cả các sản phẩm đã bán, kèm:
        Tên khách hàng
        Ngày đặt hàng
        Số lượng và giá
        (JOIN 3 bảng customers, orders, order_items)
*/
SELECT
    c.customer_name AS "Tên khách",
    o.order_date AS "Ngày đặt",
    oi.product_name AS "Sản phẩm",
    oi.quantity AS "Số lượng",
    oi.price AS "Giá"
FROM good2.customers c
    JOIN good2.orders o ON c.customer_id = o.customer_id
    JOIN good2.order_item oi ON o.order_id = oi.order_id;

-- 8. Subquery
/*
    Tìm tên khách hàng có tổng doanh thu cao nhất.
    Gợi ý: Dùng SUM(total_amount) trong subquery để tìm MAX
*/
SELECT
    c.customer_name AS "Tên khách",
    SUM(o.total_amount) AS "Tổng chi tiêu"
FROM good2.customers c
    JOIN good2.orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(o.total_amount) = (
    SELECT MAX(total_spent)
    FROM (
        SELECT SUM(total_amount) AS total_spent
        FROM good2.orders
        GROUP BY customer_id
    ) AS sub
);