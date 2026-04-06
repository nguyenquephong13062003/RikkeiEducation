CREATE SCHEMA good1;
SET search_path TO good1;

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    emp_name VARCHAR(100),
    job_level INT,
    salary NUMERIC(10,2)
);

INSERT INTO employees (emp_name, job_level, salary) VALUES
    ('Nguyen Van A', 1, 4000.00),
    ('Tran Thi B', 2, 6000.00),
    ('Le Van C', 3, 9000.00),
    ('Pham Thi D', 2, 7500.00),
    ('Hoang Van E', 1, 12000.00),
    ('Do Thi F', 1, 3500.00),
    ('Vo Van G', 3, 10000.00),
    ('Bui Thi H', 2, 15000.00),
    ('Dang Van I', 2, 6500.00),
    ('Ngo Thi K', 3, 11000.00);

SELECT * FROM employees;

CREATE OR REPLACE PROCEDURE adjust_salary (
    IN p_emp_id INT,
    OUT p_new_salary NUMERIC(10, 2)
)
    LANGUAGE plpgsql
AS $$
DECLARE
    v_salary NUMERIC(10,2);
    v_job_level INT;
BEGIN
    -- 1. Kiểm tra nhân viên tồn tại + lấy salary
    SELECT salary, job_level
    INTO v_salary, v_job_level
    FROM employees
    WHERE emp_id = p_emp_id;

    -- 2. Kiểm tra tồn tại
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Employee not found';
    END IF;

    -- 3. Tính lương mới theo job_level
    IF v_job_level = 1 THEN
        p_new_salary := v_salary * 1.05;
    ELSIF v_job_level = 2 THEN
        p_new_salary := v_salary * 1.10;
    ELSIF v_job_level = 3 THEN
        p_new_salary := v_salary * 1.15;
    ELSE
        -- Nếu level khác thì không tăng
        p_new_salary := v_salary;
    END IF;

    -- 4. Update vào bảng
    UPDATE employees
    SET salary = p_new_salary
    WHERE emp_id = p_emp_id;

END;
$$;

CALL adjust_salary(3, NULL);

SELECT * FROM employees WHERE emp_id = 3;

SELECT * FROM employees;
