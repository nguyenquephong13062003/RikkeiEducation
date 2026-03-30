-- 1. Create schema exe5
CREATE SCHEMA exe5;

-- 2. Create company tables
CREATE TABLE exe5.Course (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100),
    instructor VARCHAR(50),
    price NUMERIC(10, 2),
    duration INT -- số giờ học
);

-- 3. Thêm ít nhất 6 khóa học vào bảng
INSERT INTO exe5.Course (title, instructor, price, duration) VALUES
    ('SQL Cơ bản', 'Nguyen Van A', 1000000, 25),
    ('SQL Nâng cao', 'Tran Thi B', 1500000, 40),
    ('Python cho người mới', 'Le Van C', 800000, 35),
    ('Demo Java cơ bản', 'Pham Thi D', 500000, 20),
    ('Web Development', 'Hoang Van E', 1200000, 50),
    ('Machine Learning', 'Do Thi F', 2000000, 45);

SELECT * FROM exe5.Course;

-- 4. Cập nhật giá tăng 15% cho các khóa học có thời lượng trên 30 giờ
UPDATE exe5.Course
SET price = price * 1.15
WHERE duration > 30;

-- 5. Xóa khóa học có tên chứa từ khóa “Demo”
DELETE FROM exe5.Course
WHERE title ILIKE '%Demo%';

-- 6. Hiển thị các khóa học có tên chứa từ “SQL” (không phân biệt hoa thường)
SELECT *
FROM exe5.Course
WHERE title ILIKE '%SQL%';

-- 7. Lấy 3 khóa học có giá nằm giữa 500,000 và 2,000,000, sắp xếp theo giá giảm dần
SELECT *
FROM exe5.Course
WHERE price BETWEEN 500000 AND 2000000
ORDER BY price DESC
LIMIT 3;
