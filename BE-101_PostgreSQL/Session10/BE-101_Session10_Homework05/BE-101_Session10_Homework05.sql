CREATE SCHEMA hw05;
SET search_path TO hw05;

CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    address TEXT
);

CREATE TABLE customers_log (
    log_id SERIAL PRIMARY KEY,
    customer_id INT,
    operation VARCHAR(10),
    old_data JSONB,
    new_data JSONB,
    changed_by VARCHAR(100),
    change_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION trg_func_insert_customer ()
RETURNS TRIGGER AS $$
BEGIN

    INSERT INTO customers_log (
        customer_id,
        operation,
        old_data,
        new_data,
        changed_by
    )
    VALUES (
       NEW.id,
       'INSERT',
       NULL,
       to_jsonb(NEW),
       current_user
   );

    RETURN NEW;

END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_insert_customer
BEFORE INSERT ON customers
FOR EACH ROW
EXECUTE FUNCTION trg_func_insert_customer();

INSERT INTO customers (name, email, phone, address) VALUES
    ('Nguyen Van A', 'a@gmail.com', '0901234567', 'Ho Chi Minh'),
    ('Tran Thi B', 'b@gmail.com', '0912345678', 'Ha Noi'),
    ('Le Van C', 'c@gmail.com', '0923456789', 'Da Nang');

SELECT * FROM customers;
SELECT * FROM customers_log;

CREATE OR REPLACE FUNCTION trg_func_update_customer ()
RETURNS TRIGGER AS $$
BEGIN

    INSERT INTO customers_log (
        customer_id,
        operation,
        old_data,
        new_data,
        changed_by
    )
    VALUES (
        NEW.id,
        'UPDATE',
        to_jsonb(OLD),
        to_jsonb(NEW),
        current_user
    );

    RETURN NEW;

END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_customer
BEFORE UPDATE ON customers
FOR EACH ROW
EXECUTE FUNCTION trg_func_update_customer();

UPDATE customers
SET phone = '0999999999',
    address = 'Can Tho'
WHERE id = 1;

UPDATE customers
SET address = 'Ho Chi Minh'
WHERE address = 'Ha Noi';

SELECT * FROM customers;
SELECT * FROM customers_log;

CREATE OR REPLACE FUNCTION trg_func_delete_customer ()
RETURNS TRIGGER AS $$
BEGIN

    INSERT INTO customers_log (
        customer_id,
        operation,
        old_data,
        new_data,
        changed_by
    )
    VALUES (
        OLD.id,
        'DELETE',
        to_jsonb(OLD),
        NULL,
        current_user
    );

    RETURN OLD;

END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_delete_customer
BEFORE DELETE ON customers
FOR EACH ROW
EXECUTE FUNCTION trg_func_delete_customer();

DELETE FROM customers
WHERE id = 3;

SELECT * FROM customers;
SELECT * FROM customers_log;
