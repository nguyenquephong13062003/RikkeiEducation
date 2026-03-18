-- Bài tập [Xuất sắc 2]
-- 1. Tạo Cơ Sở dữ liệu EcommerceDB
CREATE DATABASE EcommerceDB;
-- 2. Tạo Schema shop
CREATE SCHEMA SHOP;
-- 3. Tạo các bảng Users
CREATE TABLE SHOP.USERS(
    user_id serial primary key ,
    username varchar(50) not null unique,
    email varchar(100) not null unique ,
    password varchar(100) not null,
    role varchar(20) check ( role IN ('Customer', 'Admin') )
);
-- 4. Tạo các bảng Categories
CREATE TABLE SHOP.CATEGORIES(
    catalog_id serial primary key ,
    catalog_name varchar(100) not null unique
);
-- 5. Tạo các bảng Products
CREATE TABLE SHOP.PRODUCTS
(
    product_id      serial primary key,
    product_name    varchar(100) not null,
    price   numeric(10,2) check ( price > 0 ),
    stock   int check ( stock >= 0 ),
    catalog_id      int,
    foreign key (catalog_id) references SHOP.CATEGORIES (catalog_id)
);
-- 6. Tạo các bảng Orders
CREATE TABLE SHOP.ORDERS(
    order_id serial primary key ,
    user_id int ,
    foreign key (user_id) references SHOP.USERS (user_id),
    oder_date date not null ,
    status varchar(20) check ( status IN ('Pending','Shipped','Delivered','Cancelled') )
);
-- 7. Tạo các bảng OrderDetails
CREATE TABLE SHOP.ORDERDETAILS (
    order_detail_id serial primary key ,
    order_id int,
    foreign key (order_id) references SHOP.ORDERS (order_id),
    product_id int,
    foreign key (product_id) references SHOP.PRODUCTS (product_id),
    quantity int check ( quantity > 0 ),
    price_each numeric(10, 2) check ( price_each > 0 )
);
-- 8. Tạo các bảng Payments
CREATE TABLE SHOP.PAYMENTS (
    payment_id serial primary key ,
    order_id int,
    foreign key (order_id) references SHOP.ORDERS (order_id),
    amount numeric(10, 2) check ( amount >= 0 ),
    payment_date date not null ,
    method varchar(30) CHECK ( method in ('Credit Card','Momo','Bank Transfer','Cash') )
);