-- 1. Create schema ex1
CREATE SCHEMA ex1;
-- 2. Create company tables
CREATE TABLE ex1.students (
    student_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    major VARCHAR(50)
);

CREATE TABLE ex1.courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(100),
    credit INT
);

CREATE TABLE ex1.enrollments (
    student_id INT REFERENCES ex1.students(student_id),
    course_id INT REFERENCES ex1.courses(course_id),
    score NUMERIC(5, 2)
);

-- 3. Insert data into database
INSERT INTO ex1.students (full_name, major)
VALUES ('Nguyễn Văn A', 'CNTT'),
       ('Trần Thị B', 'Kinh tế'),
       ('Lê Văn C', 'CNTT'),
       ('Phạm Thị D', 'Marketing'),
       ('Hoàng Văn E', 'CNTT');

INSERT INTO ex1.courses (course_name, credit)
VALUES ('Cơ sở dữ liệu', 3),
       ('Lập trình Python', 4),
       ('Kinh tế vi mô', 3),
       ('Marketing căn bản', 2);

INSERT INTO ex1.enrollments (student_id, course_id, score)
VALUES
    (1, 1, 8.5),
    (1, 2, 9.0),
    (2, 3, 7.5),
    (3, 1, 6.8),
    (3, 2, 7.2),
    (4, 4, 8.0),
    (5, 1, 9.5),
    (5, 2, 8.7);

-- 4. ALIAS
/*
    - Liệt kê danh sách sinh viên cùng tên môn học và điểm
    - dùng bí danh bảng ngắn (vd. s, c, e)
    - và bí danh cột như Tên sinh viên, Môn học, Điểm
*/
SELECT s.full_name as "Tên sinh viên", c.course_name as "Môn học", e.score as "Điểm"
FROM ex1.students s join ex1.enrollments e on s.student_id = e.student_id
                    join ex1.courses c on e.course_id = c.course_id;

-- 5. Aggregate Functions
/*
    a. Tính cho từng sinh viên:
        - Điểm trung bình
        - Điểm cao nhất
        - Điểm thấp nhất
*/
SELECT e.student_id, avg(e.score) as "avg_score", max(e.score) as "max_score", min(e.score) as "min_score"
FROM ex1.enrollments e
GROUP BY e.student_id;

-- 6. GROUP BY / HAVING
/*
    Tìm ngành học (major) có điểm trung bình cao hơn 7.5
*/
SELECT s.major as "Ngành học",AVG(e.score) as "Điểm trung bình"
FROM ex1.students s join ex1.enrollments e on e.student_id = s.student_id
GROUP BY s.major
HAVING avg(e.score) > 7.5;

-- 7. JOIN
/*
    Liệt kê tất cả sinh viên, môn học, số tín chỉ và điểm (JOIN 3 bảng)
*/
SELECT
    s.full_name AS "Tên sinh viên",
    c.course_name AS "Môn học",
    c.credit AS "Số tín chỉ",
    e.score AS "Điểm"
FROM ex1.students s
    JOIN ex1.enrollments e ON s.student_id = e.student_id
    JOIN ex1.courses c ON e.course_id = c.course_id;

-- 8. Subquery
/*
    Tìm sinh viên có điểm trung bình cao hơn điểm trung bình toàn trường
    Gợi ý: dùng AVG(score) trong subquery
*/
SELECT
    s.full_name AS "Tên sinh viên",
    AVG(e.score) AS "Điểm trung bình"
FROM ex1.students s
    JOIN ex1.enrollments e ON s.student_id = e.student_id
GROUP BY s.full_name
HAVING AVG(e.score) > (
    SELECT AVG(score) FROM ex1.enrollments
);
