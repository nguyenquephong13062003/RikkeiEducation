-- 1. Create schema exe7
CREATE SCHEMA exe7;

-- 2. Create company tables
CREATE TABLE exe7.Department (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE exe7.Employee (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    department_id INT REFERENCES exe7.Department(id),
    salary NUMERIC(10, 2)
);

-- 3. Thêm dữ liệu
INSERT INTO exe7.Department (name) VALUES
    ('Nhân sự'),
    ('IT'),
    ('Kinh doanh'),
    ('Marketing');

INSERT INTO exe7.Employee (full_name, department_id, salary) VALUES
    ('Nguyễn Văn A', 1, 8000000),
    ('Trần Thị B', 1, 9000000),
    ('Lê Văn C', 2, 15000000),
    ('Phạm Thị D', 2, 20000000),
    ('Hoàng Văn E', 3, 11000000),
    ('Đỗ Thị F', 3, 9500000);

SELECT * FROM exe7.Department;
SELECT * FROM exe7.Employee;

-- 4. Liệt kê danh sách nhân viên cùng tên phòng ban của họ (INNER JOIN)
SELECT
    e.full_name,
    d.name AS department_name
FROM exe7.Employee e
    INNER JOIN exe7.Department d ON e.department_id = d.id;

-- 5. Tính lương trung bình của từng phòng ban, hiển thị: department_name, avg_salary. Gợi ý: dùng GROUP BY và bí danh cột
SELECT
    d.name AS department_name,
    ROUND(AVG(e.salary), 2) AS avg_salary
FROM exe7.Department d
    INNER JOIN exe7.Employee e ON d.id = e.department_id
GROUP BY d.name;

-- 6. Hiển thị các phòng ban có lương trung bình > 10 triệu (HAVING)
SELECT
    d.name AS department_name,
    ROUND(AVG(e.salary), 2) AS avg_salary
FROM exe7.Department d
    INNER JOIN exe7.Employee e ON d.id = e.department_id
GROUP BY d.name
HAVING AVG(e.salary) > 10000000;

-- 7. Liệt kê phòng ban không có nhân viên nào (LEFT JOIN + WHERE employee.id IS NULL)
SELECT
    d.name AS department_name
FROM exe7.Department d
    LEFT JOIN exe7.Employee e ON d.id = e.department_id
WHERE e.id IS NULL;