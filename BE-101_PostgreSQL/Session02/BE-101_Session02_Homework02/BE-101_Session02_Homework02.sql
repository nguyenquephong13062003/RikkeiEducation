-- Bài tập [Khá 2]
-- 1. Tạo Cơ Sở dữ liệu UniversityDB
CREATE DATABASE UniversityDB;
-- 2. Tạo Schema university
CREATE SCHEMA university;
SET search_path TO university;
-- 3. Tạo bảng Students
CREATE TABLE Students (
    student_id serial PRIMARY KEY,
    first_name varchar(50) NOT NULL,
    last_name varchar(50) NOT NULL,
    birth_date date,
    email varchar(100) NOT NULL UNIQUE
);
-- 4. Tạo bảng Courses
CREATE TABLE Courses (
    course_id serial PRIMARY KEY,
    course_name varchar(100) NOT NULL,
    credits int
);
-- 5. Tạo bảng Enrollments
CREATE TABLE Enrollments (
    enrollment_id serial PRIMARY KEY,
    student_id int,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    course_id int,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    enroll_date date
);
