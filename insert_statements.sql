-- Insert 10 accounts with random balances
INSERT INTO accounts (balance) VALUES (1500.00);
INSERT INTO accounts (balance) VALUES (2500.00);
INSERT INTO accounts (balance) VALUES (3200.00);
INSERT INTO accounts (balance) VALUES (4200.00);
INSERT INTO accounts (balance) VALUES (1800.00);
INSERT INTO accounts (balance) VALUES (5000.00);
INSERT INTO accounts (balance) VALUES (2700.00);
INSERT INTO accounts (balance) VALUES (1000.00);
INSERT INTO accounts (balance) VALUES (3800.00);
INSERT INTO accounts (balance) VALUES (4500.00);



-- Insert 10 students
INSERT INTO students (student_id, name, issued_on, account_id, phone) 
VALUES
(101, 'John Doe', '2023-05-01', 1, '123-456-7890'),
(102, 'Jane Smith', '2024-02-15', 2, '987-654-3210'),
(103, 'Alice Johnson', '2022-09-25', 3, '555-123-4567'),
(104, 'Bob Brown', '2023-08-10', 4, '444-567-8901'),
(105, 'Charlie White', '2022-01-19', 5, '666-234-5678'),
(106, 'David Green', '2023-06-30', 6, '777-345-6789'),
(107, 'Eva Black', '2024-11-02', 7, '888-456-7890'),
(108, 'Frank Blue', '2022-07-14', 8, '999-567-8901'),
(109, 'Grace Red', '2023-03-03', 9, '123-987-6543'),
(110, 'Helen Pink', '2023-12-15', 10, '555-234-9876');



-- Insert 10 patients
INSERT INTO patients (student_id, date_of_birth, bloodgroup, sex) 
VALUES
(101, '2000-05-15', 'O+', 'M'),
(102, '2001-12-30', 'A-', 'F'),
(103, '1999-08-25', 'B+', 'F'),
(104, '2002-11-12', 'AB-', 'M'),
(105, '2000-06-18', 'O-', 'M'),
(106, '2001-09-09', 'A+', 'M'),
(107, '1999-12-25', 'B-', 'F'),
(108, '2003-04-14', 'AB+', 'M'),
(109, '2001-10-10', 'O+', 'F'),
(110, '1998-07-01', 'A-', 'F');



-- Insert medical staff roles (refactored with new roles)
INSERT INTO medical_staff_roles (role_id, role_name, can_prescribe) 
VALUES (1000, 'Physiotherapist', FALSE);

INSERT INTO medical_staff_roles (role_id, role_name, can_prescribe) 
VALUES (2000, 'Medical Officer', TRUE);

INSERT INTO medical_staff_roles (role_id, role_name, can_prescribe) 
VALUES (3000, 'Medical Assistant', FALSE);

INSERT INTO medical_staff_roles (role_id, role_name, can_prescribe) 
VALUES (4000, 'Nurse', FALSE);

INSERT INTO medical_staff_roles (role_id, role_name, can_prescribe) 
VALUES (5000, 'Pharmacist', TRUE);

INSERT INTO medical_staff_roles (role_id, role_name, can_prescribe) 
VALUES (6000, 'Office Assistant', FALSE);



-- Inserting Employees/Staffs
-- 1 Physiotherapist
INSERT INTO medical_staffs (medical_staff_id, role_id, name, phone, password) 
VALUES
(1001, 1000, 'Physiotherapist John Doe', '222-333-4444', 'physio123'),

-- 2 Medical Officers
(2001, 2000, 'Dr. Mark Smith', '222-444-5555', 'medoff123'),
(2002, 2000, 'Dr. Sarah Johnson', '333-555-6666', 'medoff456'),

-- 2 Medical Assistants (IDs start with 104)
(3001, 3000, 'Assistant George Williams', '444-666-7777', 'medass123'),
(3002, 3000, 'Assistant Emily Clark', '555-777-8888', 'medass456'),

-- 2 Nurses (IDs start with 106)
(4001, 4000, 'Nurse Rachel Lee', '555-987-6543', 'nursepass1'),
(4002, 4000, 'Nurse Emma Adams', '666-123-4567', 'nursepass2'),

-- 1 Pharmacist
(5001, 5000, 'Pharmacist Olivia Harris', '888-654-3210', 'pharma123'),

-- 2 Office Assistant
(6001, 6000, 'Office Assistant Tina James', '777-987-6543', 'office123'),
(6002, 6000, 'Office Assistant Michael Brown', '999-123-4567', 'office456');



-- Inserting Consultations
-- Physio - 2
INSERT INTO consultations (patient_id, medical_staff_id, consult_time) 
VALUES
(1, 1001, '2025-04-26 09:00:00'),
(2, 1001, '2025-04-26 10:30:00'),

-- Medical Officer - 3
(3, 2001, '2025-04-26 14:00:00'),
(4, 2001, '2025-04-26 11:15:00'),
(5, 2002, '2025-04-26 12:00:00'),

-- Medical Assistant
(6, 3001, '2025-04-26 13:30:00'),
(7, 3002, '2025-04-26 15:00:00'),

-- Nurses
(8, 4001, '2025-04-26 16:15:00'),
(9, 4002, '2025-04-26 17:00:00'), -- Office Assistant Michael Brown

-- Pharmacist assigned for consultations
(10, 5001, '2025-04-26 18:00:00');



-- Insert 10 vital signs, matching the 10 consultations
INSERT INTO vital_signs (consult_id, bp, pulse, temp, respiratory_rate, oxygen_saturation, blood_glucose, weight)
VALUES 
(1, '120/80', 75, 36.7, 18, 98.5, 95.2, 68.5),
(2, '118/76', 72, 36.5, 17, 97.8, 90.4, 70.2),
(3, '130/85', 80, 37.0, 20, 99.0, 100.1, 75.0),
(4, '110/70', 65, 36.3, 16, 96.5, 85.7, 60.3),
(5, '125/82', 78, 36.8, 19, 98.2, 92.5, 72.4),
(6, '115/75', 70, 36.4, 18, 97.3, 89.8, 65.5),
(7, '140/90', 85, 37.5, 22, 95.0, 110.6, 80.0),
(8, '135/88', 82, 37.2, 21, 96.8, 102.3, 77.8),
(9, '122/78', 74, 36.6, 18, 98.7, 93.1, 69.7),
(10, '128/84', 76, 36.9, 19, 97.9, 97.5, 73.2);



-- medical center account id  = 11;



-- Insert prescriptions based on consultations (consult_id = 1 to 9)
INSERT INTO prescriptions (consult_id, chief_complaint) VALUES
(1, 'Knee pain after sports injury.'),
(2, 'Lower back strain after lifting heavy object.'),
(3, 'Routine medical check-up.'),
(4, 'Sneezing and congestion, possible allergies.'),
(5, 'Elevated blood pressure found during screening.'),
(6, 'Minor cuts from accident.'),
(7, 'Routine health examination.'),
(8, 'Wound care after minor surgery.'),
(9, 'Follow-up for wound dressing.');



-- Insert prescription medicines
INSERT INTO prescription_medicines (medicine_name, frequency, dosage, days, instructions, prescription_id) VALUES
('Ibuprofen 400mg', 'twice daily', '1 tablet', 5, 'Take after meals.', 1),
('Paracetamol 500mg', 'thrice daily', '1 tablet', 3, 'Use for pain relief.', 2),
('Multivitamin', 'once daily', '1 tablet', 30, 'Take in the morning.', 3),
('Cetirizine 10mg', 'once nightly', '1 tablet', 7, 'For allergy symptoms.', 4),
('Amlodipine 5mg', 'once daily', '1 tablet', 60, 'Monitor blood pressure regularly.', 5),
('Antibiotic Cream', 'twice daily', 'Apply thin layer', 7, 'Apply on cleaned wound.', 6),
('Vitamin D supplement', 'once weekly', '1 tablet', 8, 'Take with food.', 7),
('Povidone-iodine solution', 'twice daily', 'Apply', 5, 'Use for wound cleaning.', 8),
('Sterile dressing pack', 'daily', 'Apply', 7, 'Change dressing daily.', 9);



-- Insert lab tests prescribed
INSERT INTO prescription_lab_tests (lab_test_name, prescription_id) VALUES
('Complete Blood Count (CBC)', 3),
('Lipid Profile', 5),
('Blood Pressure Monitoring', 5),
('Blood Sugar (Fasting)', 7),
('Wound Culture and Sensitivity', 9);



-- Student 101
CALL transfer_funds(101, 11, (
    SELECT amount FROM invoices WHERE student_id = 101 AND transaction_status = 'pending' ORDER BY invoice_date ASC LIMIT 1
));

-- Student 102
CALL transfer_funds(102, 11, (
    SELECT amount FROM invoices WHERE student_id = 102 AND transaction_status = 'pending' ORDER BY invoice_date ASC LIMIT 1
));

-- Student 103
CALL transfer_funds(103, 11, (
    SELECT amount FROM invoices WHERE student_id = 103 AND transaction_status = 'pending' ORDER BY invoice_date ASC LIMIT 1
));

-- Student 104
CALL transfer_funds(104, 11, (
    SELECT amount FROM invoices WHERE student_id = 104 AND transaction_status = 'pending' ORDER BY invoice_date ASC LIMIT 1
));

-- Student 105
CALL transfer_funds(105, 11, (
    SELECT amount FROM invoices WHERE student_id = 105 AND transaction_status = 'pending' ORDER BY invoice_date ASC LIMIT 1
));

-- Student 106
CALL transfer_funds(106, 11, (
    SELECT amount FROM invoices WHERE student_id = 106 AND transaction_status = 'pending' ORDER BY invoice_date ASC LIMIT 1
));

-- Student 107
CALL transfer_funds(107, 11, (
    SELECT amount FROM invoices WHERE student_id = 107 AND transaction_status = 'pending' ORDER BY invoice_date ASC LIMIT 1
));

-- Student 108
CALL transfer_funds(108, 11, (
    SELECT amount FROM invoices WHERE student_id = 108 AND transaction_status = 'pending' ORDER BY invoice_date ASC LIMIT 1
));

-- Student 109
CALL transfer_funds(109, 11, (
    SELECT amount FROM invoices WHERE student_id = 109 AND transaction_status = 'pending' ORDER BY invoice_date ASC LIMIT 1
));
