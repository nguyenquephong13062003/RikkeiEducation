CREATE SCHEMA homework05;
SET search_path TO homework05;

CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    customer_id INT,
    amount NUMERIC(10,2),
    sale_date DATE
);

INSERT INTO sales (customer_id, amount, sale_date) VALUES
    (1, 500, '2025-01-01'),
    (2, 700, '2025-01-02'),
    (1, 300, '2025-01-03'),
    (3, 1000, '2025-01-04'),
    (2, 400, '2025-01-05');

SELECT * FROM sales;

CREATE OR REPLACE PROCEDURE calculate_total_sales(
    IN start_date DATE,
    IN end_date DATE,
    OUT total NUMERIC(10,2)
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- 1. Tính tổng doanh thu trong khoảng thời gian
    SELECT COALESCE(SUM(amount), 0)
    INTO total
    FROM sales
    WHERE sale_date BETWEEN start_date AND end_date;

END;
$$;

CALL calculate_total_sales('2025-01-01', '2025-01-03', NULL);

CALL calculate_total_sales('2025-01-06', '2025-01-08', NULL);
