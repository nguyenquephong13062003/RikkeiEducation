CREATE DATABASE Session_08_HW;

CREATE SCHEMA excellent;
SET search_path TO excellent;

CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(50),
    salary NUMERIC(10,2),
    bonus NUMERIC(10,2) DEFAULT 0
);

INSERT INTO employees (name, department, salary) VALUES
    ('Nguyen Van A', 'HR', 4000),
    ('Tran Thi B', 'IT', 6000),
    ('Le Van C', 'Finance', 10500),
    ('Pham Thi D', 'IT', 8000),
    ('Do Van E', 'HR', 12000);

ALTER TABLE employees
ADD COLUMN status TEXT;

CREATE OR REPLACE PROCEDURE update_employee_status(
    IN p_emp_id INT,
    OUT p_status TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_salary NUMERIC;
BEGIN
    -- 1. Kiểm tra nhân viên tồn tại + lấy salary
    SELECT salary
    INTO v_salary
    FROM employees
    WHERE id = p_emp_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Employee not found';
    END IF;

    -- 2. Xác định status theo salary
    IF v_salary < 5000 THEN
        p_status := 'Junior';
    ELSIF v_salary <= 10000 THEN
        p_status := 'Mid-level';
    ELSE
        p_status := 'Senior';
    END IF;

    -- 3. Update vào bảng
    UPDATE employees
    SET status = p_status
    WHERE id = p_emp_id;

END;
$$;

CALL update_employee_status(1, NULL);

SELECT * FROM employees;

CALL update_employee_status(999, NULL);
