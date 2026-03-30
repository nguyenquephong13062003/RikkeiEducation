-- 1. Create schema exe4
CREATE SCHEMA exe4;

-- 2. Create company tables
CREATE TABLE exe4.OrderInfo (
    id SERIAL PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total NUMERIC(10, 2),
    status VARCHAR(20)
);

-- 3. Thêm 5 đơn hàng mẫu với tổng tiền khác nhau
INSERT INTO exe4.OrderInfo (customer_id, order_date, total, status) VALUES
    (1, '2024-10-05', 600000, 'Completed'),
    (2, '2024-10-12', 450000, 'Pending'),
    (3, '2024-09-20', 800000, 'Completed'),
    (4, '2024-10-22', 1200000, 'Shipped'),
    (5, '2024-11-01', 300000, 'Cancelled');

SELECT * FROM exe4.OrderInfo;

-- 4. Truy vấn các đơn hàng có tổng tiền lớn hơn 500,000
SELECT *
FROM exe4.OrderInfo
WHERE total > 500000;

-- 5. Truy vấn các đơn hàng có ngày đặt trong tháng 10 năm 2024
SELECT *
FROM exe4.OrderInfo
WHERE order_date BETWEEN '2024-10-01' AND '2024-10-31';

-- 6. Liệt kê các đơn hàng có trạng thái khác “Completed”
SELECT *
FROM exe4.OrderInfo
WHERE status <> 'Completed';

-- 7. Lấy 2 đơn hàng mới nhất
SELECT *
FROM exe4.OrderInfo
ORDER BY order_date DESC
LIMIT 2;
