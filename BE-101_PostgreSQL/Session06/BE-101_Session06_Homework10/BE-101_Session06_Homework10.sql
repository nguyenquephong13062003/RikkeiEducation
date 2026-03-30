-- 1. Create schema exe10
CREATE SCHEMA exe10;

-- 2. Create company tables
CREATE TABLE exe10.OldCustomers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE exe10.NewCustomers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50)
);

-- 3. Thêm dữ liệu
INSERT INTO exe10.OldCustomers (name, city) VALUES
    ('Nguyễn Văn An', 'Hà Nội'),
    ('Trần Thị Bình', 'TP.HCM'),
    ('Lê Văn Cường', 'Đà Nẵng'),
    ('Phạm Minh Đức', 'Cần Thơ'),
    ('Hoàng Thị Em', 'Hải Phòng');

INSERT INTO exe10.NewCustomers (name, city) VALUES
    ('Nguyễn Văn An', 'Hà Nội'),
    ('Trần Thị Bình', 'Hà Nội'),
    ('Đặng Văn Giang', 'Huế'),
    ('Vũ Thị Hoa', 'Vũng Tàu'),
    ('Lê Văn Cường', 'Đà Nẵng');

SELECT * FROM exe10.OldCustomers;
SELECT * FROM exe10.NewCustomers;

-- 4. Lấy danh sách tất cả khách hàng (cũ + mới) không trùng lặp (UNION)
SELECT name, city FROM exe10.OldCustomers
UNION
SELECT name, city FROM exe10.NewCustomers;

-- 5. Tìm khách hàng vừa thuộc bảng OldCustomers vừa thuộc bảng NewCustomers (INTERSECT)
SELECT name, city FROM exe10.OldCustomers
INTERSECT
SELECT name, city FROM exe10.NewCustomers;

-- 6. Tính số lượng khách hàng ở từng thành phố (dùng GROUP BY city)
SELECT city, COUNT(*) AS customer_count
FROM (
    SELECT name, city FROM exe10.OldCustomers
    UNION ALL
    SELECT name, city FROM exe10.NewCustomers
) AS all_customers
GROUP BY city;

-- 7. Tìm thành phố có nhiều khách hàng nhất (dùng Subquery và MAX)
SELECT city, COUNT(*) AS total
FROM (
    SELECT name, city FROM exe10.OldCustomers
    UNION ALL
    SELECT name, city FROM exe10.NewCustomers
) AS all_customers
GROUP BY city
HAVING COUNT(*) = (
    SELECT MAX(city_count)
    FROM (
        SELECT COUNT(*) AS city_count
        FROM (
            SELECT name, city FROM exe10.OldCustomers
            UNION ALL
            SELECT name, city FROM exe10.NewCustomers
        ) AS combined
        GROUP BY city
    ) AS count_list
);