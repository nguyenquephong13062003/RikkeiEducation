-- Bài tập [Giỏi 1]
-- 1. Tạo Cơ Sở dữ liệu SalesDB
CREATE DATABASE SalesDB;
-- 2. Tạo Schema sales
CREATE SCHEMA sales;
SET search_path TO sales;
-- 3. Tạo bảng Customers
CREATE TABLE Customers (
    customer_id serial PRIMARY KEY,
    first_name varchar(50) NOT NULL,
    last_name varchar(50) NOT NULL,
    email varchar(100) NOT NULL UNIQUE,
    phone varchar(15)
);
-- 4. Tạo bảng Products
CREATE TABLE Products (
    product_id serial PRIMARY KEY,
    product_name varchar(100) NOT NULL,
    price numeric(10,2) NOT NULL CHECK (price > 0),
    stock_quantity int NOT NULL CHECK (stock_quantity >= 0)
);
-- 5. Tạo bảng Orders
CREATE TABLE Orders (
    order_id serial PRIMARY KEY,
    customer_id int,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    order_date date NOT NULL
);

-- 6. Tạo bảng OrderItems
CREATE TABLE OrderItems (
    order_item_id serial PRIMARY KEY,
    order_id int,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    product_id int,
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    quantity int NOT NULL CHECK (quantity >= 1)
);