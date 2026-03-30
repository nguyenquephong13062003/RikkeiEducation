-- 1. Create schema exe9
CREATE SCHEMA exe9;

-- 2. Create company tables
CREATE TABLE exe9.Product (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    price NUMERIC(10, 2)
);

CREATE TABLE exe9.OrderDetail (
    id SERIAL PRIMARY KEY,
    order_id INT,
    product_id INT REFERENCES exe9.Product(id),
    quantity INT
);

-- 3. Thêm dữ liệu
INSERT INTO exe9.Product (name, category, price) VALUES
    ('Laptop Dell XPS 15', 'Electronics', 35000000),
    ('Chuột không dây Logitech', 'Electronics', 500000),
    ('Bàn phím cơ Keychron', 'Electronics', 1500000),
    ('Áo thun cotton nam', 'Clothing', 250000),
    ('Quần jean ống rộng', 'Clothing', 450000),
    ('Sách "Clean Code"', 'Books', 300000);

INSERT INTO exe9.OrderDetail (order_id, product_id, quantity) VALUES
    (1, 1, 1),
    (1, 2, 2),
    (2, 4, 3),
    (2, 5, 1),
    (2, 6, 2),
    (3, 1, 2),
    (3, 3, 1),
    (3, 4, 5);

SELECT *  FROM exe9.Product;
SELECT * FROM exe9.OrderDetail;

-- 4. Tính tổng doanh thu từng sản phẩm, hiển thị product_name, total_sales (SUM(price * quantity))
SELECT
    p.name AS product_name,
    SUM(p.price * o.quantity) AS total_sales
FROM exe9.Product p
    INNER JOIN exe9.OrderDetail o on p.id = o.product_id
GROUP BY p.id, p.name;

-- 5. Tính doanh thu trung bình theo từng loại sản phẩm (GROUP BY category)
SELECT
    p.category,
    AVG(p.price * o.quantity) AS avg_category_sales
FROM exe9.Product p
    INNER JOIN exe9.OrderDetail o ON p.id = o.product_id
GROUP BY p.category;

-- 6. Chỉ hiển thị các loại sản phẩm có doanh thu trung bình > 20 triệu (HAVING)
SELECT
    p.category,
    AVG(p.price * o.quantity) AS avg_category_sales
FROM exe9.Product p
    INNER JOIN exe9.OrderDetail o ON p.id = o.product_id
GROUP BY p.category
HAVING AVG(p.price * o.quantity) > 20000000;

-- 7. Hiển thị tên sản phẩm có doanh thu cao hơn doanh thu trung bình toàn bộ sản phẩm (dùng Subquery)
SELECT
    p.name,
    SUM(p.price * o.quantity) AS total_product_sales
FROM exe9.Product p
    INNER JOIN exe9.OrderDetail o ON p.id = o.product_id
GROUP BY p.id, p.name
HAVING SUM(p.price * o.quantity) > (
    SELECT AVG(p2.price * o2.quantity)
    FROM exe9.Product p2
        INNER JOIN exe9.OrderDetail o2 ON p2.id = o2.product_id
);

-- 8. Liệt kê toàn bộ sản phẩm và số lượng bán được (nếu có) – kể cả sản phẩm chưa có đơn hàng (LEFT JOIN)
SELECT
    p.name AS product_name,
    COALESCE(SUM(o.quantity), 0) AS total_quantity_sold
FROM exe9.Product p
    LEFT JOIN exe9.OrderDetail o ON p.id = o.product_id
GROUP BY p.id, p.name
ORDER BY total_quantity_sold DESC;