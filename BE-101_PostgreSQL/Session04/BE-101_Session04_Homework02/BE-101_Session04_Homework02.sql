-- 1. Tạo bảng products
CREATE TABLE products (
    products_id SERIAL PRIMARY KEY,
    products_name VARCHAR(50),
    products_category VARCHAR(50),
    products_price DECIMAL(10,2),
    products_stock INT
);
-- 2. Thêm dữ liệu vào bảng products
INSERT INTO products (products_name, products_category, products_price, products_stock)
VALUES ('Laptop Dell', 'Electronics', 1500.00, 5),
       ('Chuột Logitech', 'Electronics', 25.50, 50),
       ('Bàn phím Razer', 'Electronics', 120.00, 20),
       ('Tủ lạnh LG', 'Home Appliances', 800.00, 3),
       ('Máy giặt Samsung', 'Home Appliances', 600.00, 2);
-- 3. Xem dữ liệu trong bảng products
SELECT * FROM products;
-- 4. Thêm sản phẩm mới: 'Điều hòa Panasonic', category 'Home Appliances', giá 400.00, stock 10
INSERT INTO products (products_name, products_category, products_price, products_stock)
VALUES ('Điều hòa Panasonic', 'Home Appliances', 400.00, 10);
SELECT * FROM products;
-- 5. Cập nhật stock của 'Laptop Dell' thành 7
UPDATE products SET products_stock = 7 WHERE products_name = 'Laptop Dell';
SELECT * FROM products;
-- 6. Xóa các sản phẩm có stock bằng 0 (nếu có)
DELETE FROM products WHERE products_stock = 0;
SELECT * FROM products;
-- 7. Liệt kê tất cả sản phẩm theo giá tăng dần
SELECT * FROM products ORDER BY products_price ASC;
-- 8. Liệt kê danh mục duy nhất của các sản phẩm (DISTINCT)
SELECT DISTINCT products_category FROM products;
-- 9. Liệt kê sản phẩm có giá từ 100 đến 1000
SELECT * FROM products WHERE products_price BETWEEN 100 AND 1000;
-- 10. Liệt kê các sản phẩm có tên chứa từ 'LG' hoặc 'Samsung' (sử dụng LIKE: phân biệt hoa thường)
SELECT *
FROM products
WHERE products_name LIKE '%LG%'
   OR products_name LIKE '%Samsung%';
-- 11. Liệt kê các sản phẩm có tên chứa từ 'LG' hoặc 'Samsung' (sử dụng ILIKE: không phân biệt hoa thường)
SELECT *
FROM products
WHERE products_name ILIKE '%lg%'
   OR products_name ILIKE '%samsung%';
-- 12. Hiển thị 2 sản phẩm đầu tiên theo giá giảm dần
SELECT * FROM products ORDER BY products_price DESC LIMIT 2;
-- 13. Lấy sản phẩm thứ 2 đến thứ 3 bằng LIMIT và OFFSET
SELECT * FROM products ORDER BY products_price DESC LIMIT 2 OFFSET 1;