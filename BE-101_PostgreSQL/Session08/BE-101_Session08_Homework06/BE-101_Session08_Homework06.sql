SET search_path TO excellent;

ALTER TABLE employees
ADD COLUMN bonus NUMERIC(10,2);

SELECT * FROM employees;

CREATE OR REPLACE PROCEDURE calculate_bonus (
    IN p_emp_id INT,
    IN p_percent NUMERIC(5,2),
    OUT p_bonus NUMERIC(10,2)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_salary NUMERIC(10,2);
BEGIN
    -- 1. Kiểm tra nhân viên tồn tại + lấy salary
    SELECT salary
    INTO v_salary
    FROM employees
    WHERE id = p_emp_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Employee not found';
    END IF;

    -- 2. Kiểm tra percent hợp lệ
    IF p_percent <= 0 THEN
        p_bonus := 0;
    ELSE
        -- 3. Tính bonus
        p_bonus := v_salary * p_percent / 100;
    END IF;

    -- 4. Cập nhật vào bảng
    UPDATE employees
    SET bonus = p_bonus
    WHERE id = p_emp_id;

END;
$$;

CALL calculate_bonus(1, 0, NULL);

CALL calculate_bonus(2, 10, NULL);

CALL calculate_bonus(999, 10, NULL);

SELECT * FROM employees;
