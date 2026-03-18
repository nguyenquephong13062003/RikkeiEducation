-- Bài tập [Xuất sắc 1]
-- 1. Tạo Cơ Sở dữ liệu HotelDB
CREATE DATABASE HotelDB;
-- 2. Tạo Schema hotel
CREATE SCHEMA hotel;
-- 3. Tạo bảng RoomTypes
CREATE TABLE hotel.RoomTypes (
    room_type_id serial primary key ,
    type_name varchar(50) not null unique ,
    price_per_night numeric(10, 2) check ( price_per_night > 0 ),
    max_capacity int check ( max_capacity > 0 )
);
-- 4. Tạo bảng Rooms
-- Tạo room_status type
CREATE TYPE hotel.room_status as enum('Available','Occupied','Maintenance');
CREATE TABLE hotel.Rooms (
    room_id  serial primary key ,
    room_number varchar(10) not null unique ,
    room_type_id int,
    foreign key (room_type_id) references hotel.RoomTypes (room_type_id),
    status hotel.room_status
);
-- 5. Tạo bảng Customers
CREATE TABLE hotel.Customers (
    customer_id serial primary key ,
    full_name varchar(100) not null ,
    email varchar(100) not null  unique ,
    phone varchar(15) not null
);
-- 6. Tạo bảng Bookings
CREATE TABLE  hotel.Bookings (
    booking_id serial primary key ,
    customer_id int ,
    foreign key (customer_id) references hotel.Customers (customer_id),
    room_id int,
    foreign key (room_id) references hotel.Rooms (room_id),
    check_in date not null ,
    check_out date not null ,
    status varchar(20) check ( status in ('Pending','Confirmed','Cancelled'))
);
-- 7. Tạo bảng Payments
-- Tạo payment_method type
CREATE TYPE hotel.payment_method as enum('Credit Card','Cash','Bank Transfer');
CREATE TABLE hotel.Payments (
    payment_id serial primary key ,
    booking_id int,
    foreign key (booking_id) references hotel.Bookings (booking_id),
    amount numeric(10,2) check ( amount >= 0 ),
    payment_date date not null ,
    method hotel.payment_method
);