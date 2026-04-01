-- 1. Create Database Hospital_DB
CREATE DATABASE Hospital_DB;


-- 2. Create Schema hospital
CREATE SCHEMA hospital;
SET search_path TO hospital;


-- 3. Create Tables: patients, doctors, appointments
CREATE TABLE patients (
    patient_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    phone VARCHAR(20),
    city VARCHAR(50),
    symptoms TEXT
);

CREATE TABLE doctors (
    doctor_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    department VARCHAR(50)
);

CREATE TABLE appointments (
    appointment_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES patients(patient_id),
    doctor_id INT REFERENCES doctors(doctor_id),
    appointment_date DATE,
    diagnosis VARCHAR(200),
    fee NUMERIC(10,2)
);


-- 4. Insert at least 5 patients, 5 doctors, and 10 appointments.
INSERT INTO patients (full_name, phone, city, symptoms) VALUES
    ('Nguyen Van A', '0901111111', 'HCM', 'fever cough headache'),
    ('Tran Thi B', '0902222222', 'Hanoi', 'stomach pain nausea'),
    ('Le Van C', '0903333333', 'Danang', 'fever sore throat'),
    ('Pham Thi D', '0904444444', 'HCM', 'back pain fatigue'),
    ('Hoang Van E', '0905555555', 'Can Tho', 'cough headache');

INSERT INTO doctors (full_name, department) VALUES
    ('Dr. An', 'Cardiology'),
    ('Dr. Binh', 'Neurology'),
    ('Dr. Cuong', 'General'),
    ('Dr. Dung', 'Orthopedic'),
    ('Dr. Hanh', 'Pediatrics');

INSERT INTO appointments (patient_id, doctor_id, appointment_date, diagnosis, fee) VALUES
    (1, 1, '2025-01-01', 'Flu', 200),
    (2, 2, '2025-01-02', 'Migraine', 300),
    (3, 3, '2025-01-03', 'Cold', 150),
    (4, 4, '2025-01-04', 'Back pain', 400),
    (5, 5, '2025-01-05', 'Cough', 180),
    (1, 2, '2025-01-06', 'Headache', 250),
    (2, 3, '2025-01-07', 'Stomach issue', 350),
    (3, 4, '2025-01-08', 'Throat infection', 220),
    (4, 5, '2025-01-09', 'Fatigue', 270),
    (5, 1, '2025-01-10', 'Flu', 210);


-- 5. Create indexes to speed up queries.
/*
    B-tree: find patients by phone number.
    Hash: find patients by city.
    GIN: find patients by keyword in symptoms list.
    GIST: find appointments by fee range.
*/
CREATE INDEX idx_patients_phone
ON patients(phone);
EXPLAIN ANALYZE
SELECT * FROM patients WHERE phone = '0904444444';

CREATE INDEX idx_patients_city_hash
ON patients USING HASH(city);
EXPLAIN ANALYZE
SELECT * FROM patients WHERE city = 'HCM';


CREATE INDEX idx_patients_symptoms_gin
ON patients USING GIN (to_tsvector('english', symptoms));
EXPLAIN ANALYZE
SELECT * FROM patients
WHERE to_tsvector('english', symptoms) @@ to_tsquery('fever');

CREATE INDEX idx_appointments_fee_gist
ON appointments USING GIST (numrange(fee, fee, '[]'));
EXPLAIN ANALYZE
SELECT * FROM appointments
WHERE numrange(fee, fee, '[]') && numrange(200, 300, '[]');


-- 6. Create a Clustered Index on the appointments table based on the appointment date.
CREATE INDEX idx_appointments_date
ON appointments(appointment_date);
CLUSTER appointments USING idx_appointments_date;

SELECT *
FROM appointments
WHERE appointment_date = '2025-01-05';


-- 7. Execute queries on the View.
/*
    Find the top 3 patients with the highest total consultation fees.
    Calculate the total number of visits by doctor.
*/
CREATE VIEW v_top_patients AS
SELECT p.patient_id, p.full_name, SUM(a.fee) AS total_fee
FROM patients p
    JOIN appointments a ON p.patient_id = a.patient_id
GROUP BY p.patient_id, p.full_name
ORDER BY total_fee DESC
LIMIT 3;
SELECT * FROM v_top_patients;

CREATE VIEW v_doctor_appointments AS
SELECT d.doctor_id, d.full_name, COUNT(a.appointment_id) AS total_visits
FROM doctors d
    LEFT JOIN appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.full_name;
SELECT * FROM v_doctor_appointments;


-- 8. Create an updateable View to change the patient's city.
CREATE VIEW v_patient_city AS
SELECT patient_id, full_name, city FROM patients
WITH CHECK OPTION;

/*
    Try updating a patient's city via the View and check the patients table again.
*/
UPDATE v_patient_city
SET city = 'Hue'
WHERE patient_id = 1;
SELECT * FROM patients WHERE patient_id = 1;
