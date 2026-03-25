-- 1. Tạo bảng products
CREATE TABLE products (
    products_id SERIAL PRIMARY KEY,
    products_name VARCHAR(50),
    products_category VARCHAR(50),
    products_price DECIMAL(10,2),
    products_stock INT,
    products_manufacturer VARCHAR(15)
);
-- 2. Thêm dữ liệu vào bảng products
INSERT INTO products (products_name, products_category, products_price, products_stock, products_manufacturer)
VALUES ('Laptop Dell XPS 13', 'Laptop', 25000000, 12, 'Dell'),
       ('Chuột Logitech M90', 'Phụ kiện', 150000, 50, 'Logitech'),
       ('Bàn phím cơ Razer', 'Phụ kiện', 2200000, 0, 'Razer'),
       ('Macbook Air M2', 'Laptop', 32000000, 7, 'Apple'),
       ('iPhone 14 Pro Max', 'Điện thoại', 35000000, 15, 'Apple'),
       ('Laptop Dell XPS 13', 'Laptop', 25000000, 12, 'Dell'),
       ('Tai nghe AirPods 3', 'Phụ kiện', 4500000, Null, 'Apple');
-- 3. Xem dữ liệu trong bảng products
SELECT * FROM products;
-- 4. Thêm sản phẩm “Chuột không dây Logitech M170”, loại Phụ kiện, giá 300000, tồn kho 20, hãng Logitech
INSERT INTO products (products_name, products_category, products_price, products_stock, products_manufacturer)
VALUES ('Chuột không dây Logitech M170', 'Phụ kiện', 300000, 20, 'Logitech');
SELECT * FROM products;
-- 5. Tăng giá tất cả sản phẩm của Apple thêm 10%
UPDATE products
SET products_price = products_price * 1.10
WHERE products_manufacturer = 'Apple';
SELECT * FROM products;
-- 6. Xóa các sản phẩm có stock bằng 0 (nếu có)
DELETE FROM products WHERE products_stock = 0;
SELECT * FROM products;
-- 7. Hiển thị sản phẩm có price BETWEEN 1000000 AND 30000000
SELECT *
FROM products
WHERE products_price BETWEEN 1000000 AND 30000000;
-- 8. Hiển thị sản phẩm có stock IS NULL
SELECT *
FROM products
WHERE products_stock IS NULL;
-- 9. Liệt kê danh sách hãng sản xuất duy nhất
SELECT DISTINCT products_manufacturer
FROM products;
-- 10. Hiển thị toàn bộ sản phẩm, sắp xếp giảm dần theo giá, sau đó tăng dần theo tên
SELECT *
FROM products
ORDER BY products_price DESC, products_name ASC;
-- 11. Tìm sản phẩm có tên chứa từ “laptop” (không phân biệt hoa thường)
SELECT *
FROM products
WHERE products_name ILIKE '%laptop%';
-- 12. Lấy về 2 sản phẩm đầu tiên sau khi sắp xếp theo giá giảm dần .
SELECT *
FROM products
ORDER BY products_price DESC
LIMIT 2;
