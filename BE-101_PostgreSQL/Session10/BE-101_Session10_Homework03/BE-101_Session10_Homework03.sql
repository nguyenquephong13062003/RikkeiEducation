CREATE SCHEMA hw03;
SET search_path TO hw03;

CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    position VARCHAR(50),
    salary NUMERIC(10,2)
);

CREATE TABLE employees_log (
    log_id SERIAL PRIMARY KEY,
    employee_id INT,
    operation VARCHAR(10),
    old_data JSONB,
    new_data JSONB,
    change_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION trg_func_employees_insert()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO employees_log (
        employee_id,
        operation,
        old_data,
        new_data
    )
    VALUES (
        NEW.id,
        'INSERT',
        NULL,
        to_jsonb(NEW)
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION trg_func_employees_update()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO employees_log (
        employee_id,
        operation,
        old_data,
        new_data
    )
    VALUES (
        NEW.id,
        'UPDATE',
        to_jsonb(OLD),
        to_jsonb(NEW)
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION trg_func_employees_delete()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO employees_log (
        employee_id,
        operation,
        old_data,
        new_data
    )
    VALUES (
        OLD.id,
        'DELETE',
        to_jsonb(OLD),
        NULL
    );

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- INSERT
CREATE TRIGGER trg_emp_insert
    AFTER INSERT ON employees
    FOR EACH ROW
EXECUTE FUNCTION trg_func_employees_insert();

-- UPDATE
CREATE TRIGGER trg_emp_update
    AFTER UPDATE ON employees
    FOR EACH ROW
EXECUTE FUNCTION trg_func_employees_update();

-- DELETE
CREATE TRIGGER trg_emp_delete
    AFTER DELETE ON employees
    FOR EACH ROW
EXECUTE FUNCTION trg_func_employees_delete();

INSERT INTO employees (name, position, salary)
VALUES ('Nguyen Van A', 'Developer', 1000);

UPDATE employees
SET salary = 1500
WHERE id = 1;

DELETE FROM employees
WHERE id = 1;

SELECT * FROM employees_log;