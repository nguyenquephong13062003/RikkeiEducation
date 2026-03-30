-- 1. Create schema exe2
CREATE SCHEMA exe2;

-- 2. Create company tables
CREATE TABLE exe2.Employee (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    department VARCHAR(50),
    salary NUMERIC(10, 2),
    hire_date DATE
);

-- 3. Thêm 6 nhân viên mới
INSERT INTO exe2.Employee (full_name, department, salary, hire_date) VALUES
    ('Nguyen Van An', 'IT', 10000000, '2023-02-15'),
    ('Tran Thi Binh', 'HR', 7000000, '2022-06-10'),
    ('Le Van An', 'IT', 12000000, '2023-08-20'),
    ('Pham Thi Hoa', 'Finance', 5000000, '2021-03-05'),
    ('Hoang Van Nam', 'IT', 9000000, '2023-11-01'),
    ('Do Thi Lan', 'Marketing', 8000000, '2022-12-12');

SELECT * FROM exe2.Employee;

-- 4. Cập nhật mức lương tăng 10% cho nhân viên thuộc phòng IT
UPDATE exe2.Employee
SET salary = salary * 1.10
WHERE department = 'IT';

-- 5. Xóa nhân viên có mức lương dưới 6,000,000
DELETE FROM exe2.Employee
WHERE salary < 6000000;

-- 6. Liệt kê các nhân viên có tên chứa chữ “An” (không phân biệt hoa thường)
SELECT *
FROM exe2.Employee
WHERE full_name ILIKE '%an%';

-- 7. Hiển thị các nhân viên có ngày vào làm việc trong khoảng từ '2023-01-01' đến '2023-12-31'
SELECT *
FROM exe2.Employee
WHERE hire_date BETWEEN '2023-01-01' AND '2023-12-31';
