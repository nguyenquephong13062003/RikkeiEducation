-- 1. Create schema exe6
CREATE SCHEMA exe6;

-- 2. Create company tables
CREATE TABLE exe6.Orders (
    id SERIAL PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount NUMERIC(10, 2)
);

-- 3. Add data
INSERT INTO exe6.Orders (customer_id, order_date, total_amount) VALUES
    (1, '2023-01-10', 12000000),
    (2, '2023-03-15', 8000000),
    (3, '2023-05-20', 15000000),
    (1, '2023-07-05', 5000000),
    (2, '2024-02-10', 20000000),
    (3, '2024-04-12', 18000000),
    (1, '2024-06-18', 22000000),
    (2, '2024-09-25', 10000000),
    (3, '2024-11-30', 12000000),
    (4, '2024-12-05', 25000000);

SELECT * FROM exe6.Orders;

-- 4. Hiển thị tổng doanh thu, số đơn hàng, giá trị trung bình mỗi đơn (dùng SUM, COUNT, AVG) - Đặt bí danh cột lần lượt là total_revenue, total_orders, average_order_value
SELECT
    SUM(total_amount) AS total_revenue,
    COUNT(id) AS total_orders,
    AVG(total_amount) AS average_order_value
FROM exe6.Orders;

-- 5. Nhóm dữ liệu theo năm đặt hàng, hiển thị doanh thu từng năm (GROUP BY EXTRACT(YEAR FROM order_date))
SELECT
    EXTRACT(YEAR FROM order_date) AS year,
    SUM(total_amount) AS total_revenue
FROM exe6.Orders
GROUP BY year;

-- 6. Chỉ hiển thị các năm có doanh thu trên 50 triệu (HAVING)
SELECT
    EXTRACT(YEAR FROM order_date) AS year,
    SUM(total_amount) AS total_revenue
FROM exe6.Orders
GROUP BY year
HAVING SUM(total_amount) > 50000000;

-- 7. Hiển thị 5 đơn hàng có giá trị cao nhất (dùng ORDER BY + LIMIT)
SELECT *
FROM exe6.Orders
ORDER BY total_amount DESC
LIMIT 5;
