-- Bài tập [Khá 1]
-- 1. Tạo Cơ Sở dữ liệu LibraryDB
CREATE DATABASE LibraryDB;
-- 2. Tạo Schema library;
CREATE SCHEMA library;
SET search_path TO library;
-- 3. Tạo bảng Books
CREATE TABLE Books (
    book_id serial PRIMARY KEY,
    title varchar(100) NOT NULL,
    author varchar(50) NOT NULL,
    published_year int,
    price numeric(10,2)
);