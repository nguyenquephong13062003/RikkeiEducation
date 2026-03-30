-- 1. Create schema exe8
CREATE SCHEMA exe8;

-- 2. Create company tables
CREATE TABLE exe8.Customer(
    id SERIAL PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE exe8.Orders (
    id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES exe8.Customer(id),
    order_date DATE,
    total_amount NUMERIC(10, 2)
);

-- 3. Thêm dữ liệu
INSERT INTO exe8.Customer (name) VALUES
    ('Lê Thị A'),
    ('Trần Văn B'),
    ('Nguyễn Thị C'),
    ('Phạm Văn D');

INSERT INTO exe8.Orders (customer_id, order_date, total_amount) VALUES
    (1, '2023-10-01', 500000),
    (1, '2023-10-05', 700000),
    (2, '2023-10-02', 800000),
    (3, '2023-10-03', 200000),
    (3, '2023-10-04', 100000);

SELECT * FROM exe8.Customer;
SELECT * FROM exe8.Orders;

-- 4. Hiển thị tên khách hàng và tổng tiền đã mua, sắp xếp theo tổng tiền giảm dần
SELECT
    c.name,
    SUM(o.total_amount) AS total_spent
FROM exe8.Customer c
    INNER JOIN exe8.Orders o ON c.id = o.customer_id
GROUP BY c.id, c.name
ORDER BY total_spent DESC;

-- 5. Tìm khách hàng có tổng chi tiêu cao nhất (dùng Subquery với MAX)
SELECT
    c.name,
    SUM(o.total_amount) AS total_spent
FROM exe8.Customer c
    INNER JOIN exe8.Orders o ON c.id = o.customer_id
GROUP BY c.id, c.name
HAVING SUM(o.total_amount) = (
    SELECT MAX(total_sum)
    FROM (
        SELECT SUM(total_amount) AS total_sum
        FROM exe8.Orders
        GROUP BY customer_id
    ) AS sub_totals
);

-- 6. Liệt kê khách hàng chưa từng mua hàng (LEFT JOIN + IS NULL)
SELECT
    c.name
FROM exe8.Customer c
    LEFT JOIN exe8.Orders o ON c.id = o.customer_id
WHERE o.id IS NULL;

-- 7. Hiển thị khách hàng có tổng chi tiêu > trung bình của toàn bộ khách hàng (dùng Subquery trong HAVING)
SELECT
    c.name,
    SUM(o.total_amount) AS total_spent
FROM exe8.Customer c
    INNER JOIN exe8.Orders o ON c.id = o.customer_id
GROUP BY c.id, c.name
HAVING SUM(o.total_amount) > (
    SELECT AVG(total_sum)
    FROM (
        SELECT SUM(total_amount) AS total_sum
        FROM exe8.Orders
        GROUP BY customer_id
    ) AS sub_avg
);