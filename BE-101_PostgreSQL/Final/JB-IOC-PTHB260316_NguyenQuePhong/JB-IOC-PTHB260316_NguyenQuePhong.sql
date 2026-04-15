-- Create DATABASE
CREATE DATABASE Final;

-- Create SCHEMA
CREATE SCHEMA workstate;
SET SEARCH_PATH TO workstate;

-- PHẦN 1: Thao tác với dữ liệu các bảng
--Create Table
CREATE TABLE Customer (
    customer_id VARCHAR(5) PRIMARY KEY,
    customer_full_name VARCHAR(100) NOT NULL,
    customer_email VARCHAR(100) UNIQUE NOT NULL,
    customer_phone VARCHAR(15) NOT NULL,
    customer_address VARCHAR(255) NOT NULL
);

CREATE TYPE rstatus as ENUM('Available', 'Booked');
CREATE TABLE Room (
    room_id VARCHAR(5) PRIMARY KEY,
    room_type VARCHAR(50) NOT NULL,
    room_price DECIMAL(10,2) NOT NULL,
    room_status rstatus NOT NULL, -- ENUM
    room_area INT NOT NULL
);

CREATE TABLE Booking (
    booking_id SERIAL PRIMARY KEY,
    customer_id VARCHAR(5) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    room_id VARCHAR(5) NOT NULL,
    FOREIGN KEY (room_id) REFERENCES Room(room_id),
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    total_amount DECIMAL(10,2)
);

CREATE TABLE Payment (
    payment_id SERIAL PRIMARY KEY,
    booking_id INT NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id),
    payment_method VARCHAR(50) NOT NULL,
    payment_date DATE NOT NULL,
    payment_amount DECIMAL(10,2) NOT NULL
);

-- Insert Value
INSERT INTO Customer(customer_id, customer_full_name, customer_email, customer_phone, customer_address)
VALUES ('C001', 'Nguyen Anh Tu','tu.nguyen@example.com', '0912345678', 'Hanoi, Vietnam'),
       ('C002', 'Tran Thi Mai','mai.tran@example.com', '0923456789', 'Ho Chi Minh, Vietnam'),
       ('C003', 'Le Minh Hoang','hoang.le@example.com', '0934567890', 'Danang, Vietnam'),
       ('C004', 'Pham Hoang Nam','nam.pham@example.com', '0945678901', 'Hue, Vietnam'),
       ('C005', 'Vu Minh Thu','thu.vu@example.com', '0956789012', 'Hai Phong, Vietnam'),
       ('C006', 'Nguyen Thi Lan','lan.nguyen@example.com', '0967890123', 'Quang Ninh, Vietnam'),
       ('C007', 'Bui Minh Tuan','tuan.bui@example.com', '0978901234', 'Bac Giang, Vietnam'),
       ('C008', 'Pham Quang Hieu','hieu.pham@example.com', '0989012345', 'Quang Nam, Vietnam'),
       ('C009', 'Le Thi Lan','lan.le@example.com', '0990123456', 'Da Lat, Vietnam'),
       ('C010', 'Nguyen Thi Mai','mai.nguyen@example.com', '0901234567', 'Can Tho, Vietnam');

SELECT * FROM Customer;

INSERT INTO Room(room_id, room_type, room_price, room_status, room_area)
VALUES ('R001', 'Single', 100.0, 'Available', 25),
       ('R002', 'Double', 150.0, 'Booked', 40),
       ('R003', 'Suite', 250.0, 'Available', 60),
       ('R004', 'Single', 120.0, 'Booked', 30),
       ('R005', 'Double', 160.0, 'Available', 35);

SELECT * FROM Room;

INSERT INTO Booking(customer_id, room_id, check_in_date, check_out_date, total_amount)
VALUES ('C001', 'R001', '2025-03-01', '2025-03-05', 400.0),
       ('C002', 'R002', '2025-03-02', '2025-03-06', 600.0),
       ('C003', 'R003', '2025-03-03', '2025-03-07', 1000.0),
       ('C004', 'R004', '2025-03-04', '2025-03-08', 480.0),
       ('C005', 'R005', '2025-03-05', '2025-03-09', 800.0),
       ('C006', 'R001', '2025-03-06', '2025-03-10', 400.0),
       ('C007', 'R002', '2025-03-07', '2025-03-11', 600.0),
       ('C008', 'R003', '2025-03-08', '2025-03-12', 1000.0),
       ('C009', 'R004', '2025-03-09', '2025-03-13', 480.0),
       ('C010', 'R005', '2025-03-10', '2025-03-14', 800.0);

SELECT * FROM Booking;

INSERT INTO Payment(booking_id, payment_method, payment_date, payment_amount)
VALUES (1, 'Cash', '2025-03-05', 400.0),
       (2, 'Credit Card', '2025-03-06', 600.0),
       (3, 'Bank Transfer', '2025-03-07', 1000.0),
       (4, 'Cash', '2025-03-08', 480.0),
       (5, 'Credit Card', '2025-03-09', 800.0),
       (6, 'Bank Transfer', '2025-03-10', 400.0),
       (7, 'Cash', '2025-03-11', 600.0),
       (8, 'Credit Card', '2025-03-12', 1000.0),
       (9, 'Bank Transfer', '2025-03-13', 480.0),
       (10, 'Cash', '2025-03-14', 800.0);

SELECT * FROM Payment;

-- Cập nhật dữ liệu
SELECT
    b.booking_id,
    r.room_id,
    r.room_price,
    b.check_in_date,
    b.check_out_date,
    b.total_amount,
    (b.check_out_date-b.check_in_date) * r.room_price as calculated_total_amount
FROM Booking b JOIN Room r ON b.room_id=r.room_id
WHERE r.room_status='Booked';

UPDATE Booking b
SET total_amount = (b.check_out_date - b.check_in_date) * r.room_price
FROM Room r
WHERE b.room_id = r.room_id
    AND r.room_status = 'Booked'
    AND b.check_in_date < CURRENT_DATE;

SELECT * FROM Booking;

-- Xóa dữ liệu
DELETE FROM Payment
WHERE payment_method = 'Cash' AND payment_amount < 500.0;

SELECT * FROM Payment;

-- PHẦN 2: Truy vấn dữ liệu
-- Lấy thông tin khách hàng gồm mã khách hàng, họ tên, email, số điện thoại và địa chỉ được sắp xếp theo họ tên khách hàng tăng dần.
SELECT
    c.customer_id,
    c.customer_full_name,
    c.customer_email,
    c.customer_phone,
    c.customer_address
FROM Customer c
ORDER BY c.customer_full_name ASC;

-- Lấy thông tin các phòng khách sạn gồm mã phòng, loại phòng, giá phòng và diện tích phòng, sắp xếp theo giá phòng giảm dần.
SELECT
    room_id,
    room_status,
    room_price,
    room_area
FROM Room
ORDER BY room_price DESC;

-- Lấy thông tin khách hàng và phòng khách sạn đã đặt, gồm mã khách hàng, họ tên khách hàng, mã phòng, ngày nhận phòng và ngày trả phòng.
SELECT
    c.customer_id,
    c.customer_full_name,
    b.room_id,
    b.check_in_date,
    b.check_out_date
FROM Booking b
    JOIN Customer c
        ON b.customer_id = c.customer_id;

-- Lấy danh sách khách hàng và tổng tiền đã thanh toán khi đặt phòng, gồm mã khách hàng, họ tên khách hàng, phương thức thanh toán và số tiền thanh toán, sắp xếp theo số tiền thanh toán giảm dần.
SELECT
    c.customer_id,
    c.customer_full_name,
    p.payment_method,
    p.payment_amount
FROM Payment p JOIN Booking b ON p.booking_id = b.booking_id
    JOIN Customer c ON b.customer_id = c.customer_id
ORDER BY p.payment_amount DESC;

-- Lấy thông tin khách hàng từ vị trí thứ 2 đến thứ 4 trong bảng Customer được sắp xếp theo tên khách hàng.
SELECT *
FROM Customer
ORDER BY customer_full_name
LIMIT 3 OFFSET 1;

-- Lấy danh sách khách hàng đã đặt ít nhất 2 phòng và có tổng số tiền thanh toán trên 1000, gồm mã khách hàng, họ tên khách hàng và số lượng phòng đã đặt.
SELECT c.customer_id, c.customer_full_name, count(b.room_id) as booking_number
FROM Payment p JOIN Booking b ON p.booking_id = b.booking_id
               JOIN Customer c ON b.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_full_name
HAVING count(b.room_id) > 1 AND sum(p.payment_amount) > 1000.0;

--  Lấy danh sách các phòng có tổng số tiền thanh toán dưới 1000 và có ít nhất 3 khách hàng đặt, gồm mã phòng, loại phòng, giá phòng và tổng số tiền thanh toán.
SELECT
    r.room_id, r.room_status, r.room_price,
    sum(p.payment_amount) as total_payment_amount
FROM Payment p JOIN Booking b ON p.booking_id = b.booking_id
               JOIN Room r ON b.room_id = r.room_id
GROUP BY r.room_id, r.room_status, r.room_price
HAVING sum(p.payment_amount) < 1000.0
    AND count(b.customer_id) > 2;

-- Lấy danh sách các khách hàng có tổng số tiền thanh toán lớn hơn 1000, gồm mã khách hàng, họ tên khách hàng, mã phòng, tổng số tiền thanh toán.
SELECT
    c.customer_id, c.customer_full_name,
    array_agg(b.room_id) as room_id_array,
    sum(p.payment_amount) as total_payment_amount
FROM Payment p JOIN Booking b ON p.booking_id = b.booking_id
               JOIN Customer c ON b.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_full_name
HAVING sum(p.payment_amount) > 1000.0;

--  Lấy danh sách các khách hàng Mmã KH, Họ tên, Email, SĐT) có họ tên chứa chữ "Minh" hoặc địa chỉ (address) ở "Hanoi". Sắp xếp kết quả theo họ tên tăng dần.
SELECT customer_id, customer_full_name, customer_email, customer_phone
FROM Customer
WHERE customer_full_name LIKE '%Minh%'
    OR customer_address LIKE 'Hanoi%'
ORDER BY customer_full_name ASC;

--  Lấy danh sách tất cả các phòng (Mã phòng, Loại phòng, Giá), sắp xếp theo giá phòng giảm dần. Hiển thị 5 phòng tiếp theo sau 5 phòng đầu tiên (tức là lấy kết quả của trang thứ 2, biết mỗi trang có 5 phòng).
SELECT room_id, room_status, room_price
FROM Room
ORDER BY room_price DESC
LIMIT 5 OFFSET 5;

-- PHẦN 3: Tạo View
-- Hãy tạo một view để lấy thông tin các phòng và khách hàng đã đặt, với điều kiện ngày nhận phòng nhỏ hơn ngày 2025-03-10. Cần hiển thị các thông tin sau: Mã phòng, Loại phòng, Mã khách hàng, họ tên khách hàng
CREATE OR REPLACE VIEW view_booking_summary_date AS
SELECT
    b.room_id,
    r.room_type,
    b.customer_id,
    c.customer_full_name
FROM Booking b JOIN Customer c ON b.customer_id = c.customer_id
    JOIN Room r on b.room_id = r.room_id
WHERE b.check_in_date < '2025-03-10';

SELECT * FROM view_booking_summary_date;

-- Hãy tạo một view để lấy thông tin khách hàng và phòng đã đặt, với điều kiện diện tích phòng lớn hơn 30 m². Cần hiển thị các thông tin sau: Mã khách hàng, Họ tên khách hàng, Mã phòng, Diện tích phòng
CREATE OR REPLACE VIEW view_booking_summary_area AS
SELECT
    b.customer_id,
    c.customer_full_name,
    b.room_id,
    r.room_area
FROM Booking b JOIN Customer c ON b.customer_id = c.customer_id
               JOIN Room r on b.room_id = r.room_id
WHERE r.room_area > 30;

SELECT * FROM view_booking_summary_area;

-- PHẦN 4: Tạo Trigger
-- Hãy tạo một trigger check_insert_booking để kiểm tra dữ liệu mối khi chèn vào bảng Booking. Kiểm tra nếu ngày đặt phòng mà sau ngày trả phòng thì thông báo lỗi với nội dung “Ngày đặt phòng không thể sau ngày trả phòng được !” và hủy thao tác chèn dữ liệu vào bảng.
CREATE OR REPLACE FUNCTION check_insert_booking ()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.check_in_date > NEW.check_out_date THEN
        RAISE EXCEPTION 'Ngày đặt phòng không thể sau ngày trả phòng được !';
    END IF;
    RETURN NEW;
END ;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_insert_booking
    BEFORE INSERT ON Booking
    FOR EACH ROW
EXECUTE FUNCTION check_insert_booking();


-- ERROR: Ngày đặt phòng không thể sau ngày trả phòng được !
INSERT INTO Booking(customer_id, room_id, check_in_date, check_out_date, total_amount)
VALUES ('C001', 'R001', '2025-03-13', '2025-03-12', 400.0);

-- Hãy tạo một trigger có tên là update_room_status_on_booking để tự động cập nhật trạng thái phòng thành "Booked" khi một phòng được đặt (khi có bản ghi được INSERT vào bảng Booking).
CREATE OR REPLACE FUNCTION update_room_status_on_booking ()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Room
    SET room_status = 'Booked'
    WHERE room_id = NEW.room_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_room_status_on_booking
    AFTER INSERT ON Booking
    FOR EACH ROW
EXECUTE FUNCTION update_room_status_on_booking();

SELECT * FROM Room;

INSERT INTO Booking(customer_id, room_id, check_in_date, check_out_date)
VALUES ('C002', 'R001', '2025-03-13', '2025-03-16');

-- PHẦN 5: Tạo Store Procedure
-- Viết store procedure có tên add_customer để thêm mới một khách hàng với đầy đủ các thông tin cần thiết.
CREATE OR REPLACE PROCEDURE add_customer (
    customer_id_in VARCHAR(5),
    customer_full_name_in VARCHAR(100),
    customer_email_in VARCHAR(100),
    customer_phone_in VARCHAR(15),
    customer_address_in VARCHAR(255)
)
LANGUAGE plpgsql
AS $$
BEGIN
    BEGIN
        INSERT INTO Customer(customer_id, customer_full_name, customer_email, customer_phone, customer_address)
        VALUES (
           customer_id_in,
           customer_full_name_in,
           customer_email_in,
           customer_phone_in,
           customer_address_in
        );
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    end;

END;
$$;

CALL add_customer('C011', 'Nguyen Que Phong', 'phong.nguyen@example.com', '0908070605', 'Ho Chi Minh, Vietnam');

SELECT * FROM Customer;

-- Hãy tạo một Stored Procedure  có tên là add_payment để thực hiện việc thêm một thanh toán mới cho một lần đặt phòng.
/*
    Procedure này nhận các tham số đầu vào:
    - p_booking_id: Mã đặt phòng (booking_id).
    - p_payment_method: Phương thức thanh toán (payment_method).
    - p_payment_amount: Số tiền thanh toán (payment_amount).
    - p_payment_date: Ngày thanh toán (payment_date).
*/
CREATE OR REPLACE PROCEDURE add_payment (
    p_booking_id INT,
    p_payment_method VARCHAR(50),
    p_payment_amount DECIMAL(10,2),
    p_payment_date DATE
)
    LANGUAGE plpgsql
AS $$
BEGIN
    BEGIN
        INSERT INTO Payment (booking_id, payment_method, payment_date, payment_amount)
        VALUES (
                p_booking_id,
                p_payment_method,
                p_payment_date,
                p_payment_amount
               );
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    end;

END;
$$;

SELECT * FROM Payment;

CALL add_payment(9, 'Cash', 400.0, '2025-03-15');