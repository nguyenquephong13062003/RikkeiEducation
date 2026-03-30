-- 1. Create schema ex2
CREATE SCHEMA ex2;
-- 2. Create company tables
CREATE TABLE ex2.departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(100)
);

CREATE TABLE ex2.employees (
    emp_id SERIAL PRIMARY KEY,
    emp_name VARCHAR(100),
    dept_id INT REFERENCES ex2.departments(dept_id),
    salary NUMERIC(10, 2),
    hire_date DATE
);

CREATE TABLE ex2.projects (
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(100),
    dept_id INT REFERENCES ex2.departments(dept_id)
);

-- 3. Insert data into database
INSERT INTO ex2.departments (dept_name) VALUES
    ('IT'),
    ('Human Resources'),
    ('Finance'),
    ('Marketing'),
    ('Sales');

INSERT INTO ex2.employees (emp_name, dept_id, salary, hire_date) VALUES
    ('Nguyen Van A', 1, 20000000, '2022-01-15'),
    ('Tran Thi B', 1, 25000000, '2021-03-10'),
    ('Le Van C', 1, 15000000, '2023-06-01'),
    ('Pham Thi D', 2, 12000000, '2020-09-20'),
    ('Hoang Van E', 2, 18000000, '2021-11-11'),
    ('Vo Thi F', 3, 30000000, '2019-07-07'),
    ('Dang Van G', 3, 22000000, '2022-05-05'),
    ('Bui Thi H', 4, 14000000, '2023-02-14'),
    ('Do Van I', 4, 16000000, '2022-12-01'),
    ('Nguyen Thi K', 5, 10000000, '2021-08-08'),
    ('Tran Van L', 5, 5000000, '2023-09-09');

INSERT INTO ex2.projects (project_name, dept_id) VALUES
    ('Website Development', 1),
    ('Mobile App', 1),
    ('Recruitment System', 2),
    ('Financial Report 2025', 3),
    ('Marketing Campaign A', 4),
    ('Brand Awareness', 4),
    ('Sales Expansion', 5);

SELECT * FROM ex2.departments;
SELECT * FROM ex2.employees;
SELECT * FROM ex2.projects;

-- 4. ALIAS
/*
    Hiển thị danh sách nhân viên gồm: Tên nhân viên, Phòng ban, Lương
    dùng bí danh bảng ngắn (employees as e,departments as d).
*/
SELECT
    e.emp_name AS "Tên nhân viên",
    d.dept_name AS "Phòng ban",
    e.salary AS "Lương"
FROM ex2.employees e
    JOIN ex2.departments d ON e.dept_id = d.dept_id;


-- 5. Aggregate Functions
/*
    Tổng quỹ lương toàn công ty
    Mức lương trung bình
    Lương cao nhất, thấp nhất
    Số nhân viên
*/
SELECT
    SUM(salary) AS "Tổng quỹ lương",
    AVG(salary) AS "Lương trung bình",
    MAX(salary) AS "Lương cao nhất",
    MIN(salary) AS "Lương thấp nhất",
    COUNT(*) AS "Số nhân viên"
FROM ex2.employees;

-- 6. GROUP BY / HAVING
/*
    Tính mức lương trung bình của từng phòng ban
    chỉ hiển thị những phòng ban có lương trung bình > 15.000.000
*/
SELECT
    d.dept_name AS "Phòng ban",
    AVG(e.salary) AS "Lương trung bình"
FROM ex2.employees e
    JOIN ex2.departments d ON e.dept_id = d.dept_id
GROUP BY d.dept_name
HAVING AVG(e.salary) > 15000000;

-- 7. JOIN
/*
    Liệt kê danh sách dự án (project) cùng với phòng ban phụ trách và nhân viên thuộc phòng ban đó
*/
SELECT
    p.project_name AS "Dự án",
    d.dept_name AS "Phòng ban",
    e.emp_name AS "Nhân viên"
FROM ex2.projects p
    JOIN ex2.departments d ON p.dept_id = d.dept_id
    JOIN ex2.employees e ON d.dept_id = e.dept_id;

-- 8. Subquery
/*
    Tìm nhân viên có lương cao nhất trong mỗi phòng ban
    Gợi ý: Subquery lồng trong WHERE salary IN (SELECT MAX(...))
*/
SELECT
    e.emp_name AS "Tên nhân viên",
    d.dept_name AS "Phòng ban",
    e.salary AS "Lương"
FROM ex2.employees e
    JOIN ex2.departments d ON e.dept_id = d.dept_id
WHERE e.salary IN (
    SELECT MAX(salary)
    FROM ex2.employees
    GROUP BY dept_id
);
