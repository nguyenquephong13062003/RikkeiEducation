CREATE SCHEMA homework04;
SET search_path TO homework04;

CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    customer_id INT,
    product_id INT,
    sale_date DATE,
    amount NUMERIC(10,2)
);

INSERT INTO sales (customer_id, product_id, sale_date, amount) VALUES
    (1, 101, '2025-01-01', 500),
    (1, 102, '2025-01-02', 700),
    (2, 103, '2025-01-03', 300),
    (2, 104, '2025-01-04', 900),
    (3, 105, '2025-01-05', 2000),
    (4, 106, '2025-01-06', 700);

SELECT * FROM sales;

CREATE VIEW CustomerSales AS
SELECT customer_id,
    SUM(amount) AS total_amount
FROM sales
GROUP BY customer_id;

SELECT * FROM CustomerSales;

SELECT *
FROM CustomerSales
WHERE total_amount > 1000;

UPDATE CustomerSales
SET total_amount = 5000
WHERE customer_id = 1;
/*
    ERROR: cannot update view "customersales"
      Detail: Views containing GROUP BY are not automatically updatable.
      Hint: To enable updating the view, provide an INSTEAD OF UPDATE trigger or an unconditional ON UPDATE DO INSTEAD rule.
*/