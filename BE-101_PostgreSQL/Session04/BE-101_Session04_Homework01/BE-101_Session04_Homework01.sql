-- 1. Tạo bảng student
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    student_name VARCHAR(50),
    student_age INT,
    student_major VARCHAR(50),
    student_gpa DECIMAL(3,2)
);
-- 2. Thêm dữ liệu vào bảng student
INSERT INTO students (student_name, student_age, student_major, student_gpa)
VALUES ('An', 20, 'CNTT', 3.5),
       ('Bình', 21, 'Toán', 3.2),
       ('Cường', 22, 'CNTT', 3.8),
       ('Dương', 20, 'Vật lý', 3.0),
       ('Em', 21, 'CNTT', 2.9);
-- 3. Xem dữ liệu trong bảng student
SELECT * FROM students;
-- 4. Thêm sinh viên mới: "Hùng", 23 tuổi, chuyên ngành "Hóa học", GPA 3.4
INSERT INTO students (student_name, student_age, student_major, student_gpa)
VALUES ('Hùng', 23, 'Hóa học', 3.4);
SELECT * FROM students;
-- 5. Cập nhật GPA của sinh viên "Bình" thành 3.6
UPDATE students SET student_gpa = 3.6 WHERE student_name = 'Bình';
SELECT * FROM students;
-- 6. Xóa sinh viên có GPA thấp hơn 3.0
DELETE FROM students WHERE student_gpa < 3.0;
SELECT * FROM students;
-- 7. Liệt kê tất cả sinh viên, chỉ hiển thị tên và chuyên ngành, sắp xếp theo GPA giảm dần
SELECT student_name, student_major FROM students ORDER BY student_gpa DESC;
-- 8. Liệt kê tên sinh viên duy nhất có chuyên ngành "CNTT"
SELECT DISTINCT student_name FROM students WHERE student_major = 'CNTT';
-- 9. Liệt kê sinh viên có GPA từ 3.0 đến 3.6
SELECT * FROM students WHERE student_gpa BETWEEN 3.0 AND 3.6;
-- 10. Liệt kê sinh viên có tên bắt đầu bằng chữ 'C' (sử dụng LIKE: phân biệt hoa thường)
SELECT * FROM students WHERE student_name LIKE 'C%';
-- 11. Liệt kê sinh viên có tên bắt đầu bằng chữ 'C' (sử dụng ILIKE: không phân biệt hoa thường)
SELECT * FROM students WHERE student_name ILIKE 'c%';
-- 12. Hiển thị 3 sinh viên đầu tiên theo thứ tự tên tăng dần
SELECT * FROM students ORDER BY student_name ASC LIMIT 3;
-- 13. Lấy từ sinh viên thứ 2 đến thứ 4 bằng LIMIT và OFFSET
SELECT * FROM students ORDER BY student_name ASC LIMIT 3 OFFSET 1;