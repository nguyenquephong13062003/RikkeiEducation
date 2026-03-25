-- 1. Tạo bảng student
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    full_name VARCHAR(50),
    gender VARCHAR(5),
    birth_year INT,
    major VARCHAR(50),
    gpa DECIMAL(3,2)
);
-- 2. Thêm dữ liệu vào bảng student
INSERT INTO students (full_name, gender, birth_year, major, gpa)
VALUES ('Nguyễn Văn A', 'Nam', 2002, 'CNTT', 3.6),
       ('Trần Thị Bích Ngọc', 'Nữ', 2001, 'Kinh tế', 3.2),
       ('Lê Quốc Cường', 'Nam', 2003, 'CNTT', 2.7),
       ('Phạm Minh Anh', 'Nữ', 2000, 'Luật', 3.9),
       ('Nguyễn Văn A', 'Nam', 2002, 'CNTT', 3.6),
       ('Lưu Đức Tài', 2004, 2004, 'Cơ khí', Null),
       ('Võ Thị Thu Hằng', 'Nữ', 2001, 'CNTT', 3.0);
-- 3. Xem dữ liệu trong bảng student
SELECT * FROM students;
-- 4. Thêm sinh viên “Phan Hoàng Nam”, giới tính Nam, sinh năm 2003, ngành CNTT, GPA 3.8
INSERT INTO students (full_name, gender, birth_year, major, gpa)
VALUES ('Phan Hoàng Nam', 'Nam', 2003, 'CNTT', 3.8);
SELECT * FROM students;
-- 5. Sinh viên “Lê Quốc Cường” vừa cải thiện học lực, cập nhật gpa = 3.4
UPDATE students SET gpa = 3.4 WHERE full_name = 'Lê Quốc Cường';
SELECT * FROM students;
-- 6. Xóa tất cả sinh viên có gpa IS NULL
DELETE FROM students WHERE gpa IS NULL;
SELECT * FROM students;
-- 7. Hiển thị sinh viên ngành CNTT có gpa >= 3.0, chỉ lấy 3 kết quả đầu tiên
SELECT *
FROM students
WHERE major = 'CNTT' AND gpa >= 3.0
LIMIT 3;
-- 8. Liệt kê danh sách ngành học duy nhất
SELECT DISTINCT major FROM students;
-- 9. Hiển thị sinh viên ngành CNTT, sắp xếp giảm dần theo GPA, sau đó tăng dần theo tên
SELECT *
FROM students
WHERE major = 'CNTT'
ORDER BY gpa DESC, full_name ASC;
-- 10. Tìm sinh viên có tên bắt đầu bằng “Nguyễn”
SELECT * FROM students WHERE full_name ILIKE 'nguyễn%';
-- 11. Hiển thị sinh viên có năm sinh từ 2001 đến 2003
SELECT *
FROM students
WHERE birth_year BETWEEN 2001 AND 2003;