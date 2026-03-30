-- 1. Create schema exe1
CREATE SCHEMA exe1;

-- 2. Create company tables
CREATE TABLE exe1.Product (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    price NUMERIC(10, 2),
    stock INT
);

-- 3. Thêm 5 sản phẩm vào bảng bằng lệnh INSERT
INSERT INTO exe1.Product (name, category, price, stock) VALUES
    ('Laptop Dell', 'Điện tử', 15000000, 10),
    ('iPhone 15', 'Điện tử', 20000000, 5),
    ('Tai nghe Sony', 'Điện tử', 3000000, 20),
    ('Bàn học', 'Nội thất', 2500000, 15),
    ('Ghế gaming', 'Nội thất', 5000000, 8);


-- 4. Hiển thị danh sách toàn bộ sản phẩm
SELECT * FROM exe1.Product;

-- 5. Hiển thị 3 sản phẩm có giá cao nhất
SELECT *
FROM exe1.Product
ORDER BY price DESC
LIMIT 3;

-- 6. Hiển thị các sản phẩm thuộc danh mục “Điện tử” có giá nhỏ hơn 10,000,000
SELECT *
FROM exe1.Product
WHERE category = 'Điện tử'
    AND price < 10000000;

-- 7. Sắp xếp sản phẩm theo số lượng tồn kho tăng dần
SELECT *
FROM exe1.Product
ORDER BY stock ASC;
