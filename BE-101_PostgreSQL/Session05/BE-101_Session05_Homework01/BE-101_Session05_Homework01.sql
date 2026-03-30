-- 1. Create schema average
CREATE SCHEMA average;
-- 2. Create company tables
CREATE TABLE average.products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50)
);

CREATE TABLE average.orders (
    order_id INT PRIMARY KEY,
    product_id INT REFERENCES average.products(product_id),
    quantity INT,
    total_price NUMERIC(10, 2)
);

-- 3. Insert data into database
INSERT INTO average.products (product_id, product_name, category) VALUES
    (1, 'Laptop Dell', 'Electronics'),
    (2, 'IPhone 15', 'Electronics'),
    (3, 'Bàn học gỗ', 'Furniture'),
    (4, 'Ghế xoay', 'Furniture');

INSERT INTO average.orders (order_id, product_id, quantity, total_price) VALUES
    (101, 1, 2, 2200),
    (102, 2, 3, 3300),
    (103, 3, 5, 2500),
    (104, 4, 4, 1600),
    (105, 1, 1, 1100);

-- 4. Viết truy vấn hiển thị tổng doanh thu (SUM(total_price)) và số lượng sản phẩm bán được (SUM(quantity)) cho từng nhóm danh mục (category)
/*
    Đặt bí danh cột như sau:
        total_sales cho tổng doanh thu
        total_quantity cho tổng số lượng
    Chỉ hiển thị những nhóm có tổng doanh thu lớn hơn 2000
    Sắp xếp kết quả theo tổng doanh thu giảm dần
*/
SELECT
    p.category,
    SUM(o.total_price) AS total_sales,
    SUM(o.quantity) AS total_quantity
FROM average.products p
    JOIN average.orders o ON p.product_id = o.product_id
GROUP BY p.category
HAVING SUM(o.total_price) > 2000
ORDER BY total_sales DESC;
