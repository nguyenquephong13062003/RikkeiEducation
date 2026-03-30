-- 1. Create schema exe3
CREATE SCHEMA exe3;

-- 2. Create company tables
CREATE TABLE exe3.Customer (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    points INT
);

-- 3. Thêm 7 khách hàng (trong đó có 1 người không có email)
INSERT INTO exe3.Customer (name, email, phone, points) VALUES
    ('Nguyen Van A', 'a@gmail.com', '0901111111', 100),
    ('Tran Thi B', 'b@gmail.com', '0902222222', 200),
    ('Le Van C', NULL, '0903333333', 150), -- không có email
    ('Pham Thi D', 'd@gmail.com', '0904444444', 300),
    ('Hoang Van E', 'e@gmail.com', '0905555555', 250),
    ('Do Thi F', 'f@gmail.com', '0906666666', 180),
    ('Nguyen Van A', 'a2@gmail.com', '0907777777', 120);

SELECT * FROM exe3.Customer;

-- 4. Truy vấn danh sách tên khách hàng duy nhất (DISTINCT)
SELECT DISTINCT name
FROM exe3.Customer;

-- 5. Tìm các khách hàng chưa có email (IS NULL)
SELECT *
FROM exe3.Customer
WHERE email IS NULL;

-- 6. Hiển thị 3 khách hàng có điểm thưởng cao nhất, bỏ qua khách hàng cao điểm nhất (gợi ý: dùng OFFSET)
SELECT *
FROM exe3.Customer
ORDER BY points DESC
LIMIT 3 OFFSET 1;

-- 7. Sắp xếp danh sách khách hàng theo tên giảm dần
SELECT *
FROM exe3.Customer
ORDER BY name DESC;
