-- Bài tập [Giỏi 2]
-- 1. Tạo Cơ Sở dữ liệu EcommerceDB
CREATE DATABASE ElearningDB;
-- 2. Tạo Schema elearning
CREATE SCHEMA elearning;
SET search_path TO elearning;
-- 3. Tạo bảng Students
CREATE TABLE Students (
    student_id serial primary key ,
    first_name varchar(50) not null ,
    last_name varchar(50) not null ,
    email text not null unique
);
-- 4. Tạo bảng Instructors
CREATE TABLE Instructors (
    instructor_id serial primary key ,
    first_name varchar(50) not null ,
    last_name varchar(50) not null ,
    email text not null unique
);
-- 5. Tạo bảng Courses
CREATE TABLE Courses (
    course_id serial primary key ,
    course_name varchar(100) not null ,
    instructor_id int,
    foreign key (instructor_id) references Instructors(instructor_id)
);
-- 6. Tạo bảng Enrollments
CREATE TABLE Enrollments (
    enrollment_id serial primary key ,
    student_id int,
    foreign key (student_id) references Students (student_id),
    course_id int,
    foreign key (course_id) references Courses (course_id),
    enroll_date date not null
);
-- 7. Tạo bảng Assignments
CREATE TABLE Assignments (
    assignment_id serial primary key ,
    course_id int,
    foreign key (course_id) references Courses (course_id),
    title varchar(100) not null ,
    due_date date not null
);
-- 8. Tạo bảng Submissions
CREATE TABLE Submissions (
    submission_id serial primary key ,
    assignment_id int,
    foreign key (assignment_id) references Assignments (assignment_id),
    student_id int,
    foreign key (student_id) references Students (student_id),
    due_date date not null,
    grade numeric(5, 2) check ( grade between 0 and 100)
);