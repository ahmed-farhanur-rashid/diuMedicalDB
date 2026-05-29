#################################################################
#                       Table Creation                         #
#################################################################


CREATE DATABASE diumedical;
USE diumedical;

-- ACCOUNTS TABLE
CREATE TABLE accounts (
    account_id INT PRIMARY KEY AUTO_INCREMENT,
    balance DECIMAL(10, 2) NOT NULL DEFAULT 0.00
);

-- STUDENTS TABLE
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    issued_on DATE NOT NULL,
    expires_on DATE GENERATED ALWAYS AS (issued_on + INTERVAL 4 YEAR) STORED,
    account_id INT NOT NULL,
    phone VARCHAR(15),
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

-- PATIENTS TABLE
CREATE TABLE patients (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    date_of_birth DATE NOT NULL,
    bloodgroup VARCHAR(5),
    sex CHAR(1) CHECK (sex IN ('M', 'F', 'O')),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

-- HISTORIES TABLE
CREATE TABLE histories (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    conditionDetails VARCHAR(255),
    condition_status VARCHAR(50),
    year_diagnosed YEAR,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

-- MEDICAL STAFF ROLES TABLE
CREATE TABLE medical_staff_roles (
    role_id INT PRIMARY KEY,
    role_name VARCHAR(100),
    can_prescribe BOOLEAN NOT NULL
);

-- MEDICAL STAFFS TABLE
CREATE TABLE medical_staffs (
    medical_staff_id INT PRIMARY KEY,
    role_id INT NOT NULL,
    name VARCHAR(100),
    phone VARCHAR(15),
    password VARCHAR(255),
    FOREIGN KEY (role_id) REFERENCES medical_staff_roles(role_id)
);

-- CONSULTATIONS TABLE
CREATE TABLE consultations (
    consult_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    medical_staff_id INT NOT NULL,
    consult_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (medical_staff_id) REFERENCES medical_staffs(medical_staff_id)
);

-- VITAL SIGNS TABLE
CREATE TABLE vital_signs (
    consult_id INT PRIMARY KEY,
    bp VARCHAR(20),
    pulse INT,
    temp DECIMAL(4,1),
    respiratory_rate INT,
    oxygen_saturation DECIMAL(5,2),
    blood_glucose DECIMAL(6,2),
    weight DECIMAL(5,2),
    FOREIGN KEY (consult_id) REFERENCES consultations(consult_id)
);

-- PRESCRIPTIONS TABLE
CREATE TABLE prescriptions (
    prescription_id INT PRIMARY KEY AUTO_INCREMENT,
    consult_id INT NOT NULL,
    prescription_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    chief_complaint TEXT,
    FOREIGN KEY (consult_id) REFERENCES consultations(consult_id)
);

-- PRESCRIPTION MEDICINES TABLE (weak entity)
CREATE TABLE prescription_medicines (
    medicine_id INT PRIMARY KEY AUTO_INCREMENT,
    medicine_name VARCHAR(100) NOT NULL,
    frequency VARCHAR(50),
    dosage VARCHAR(50),
    days INT,
    instructions VARCHAR(255),
    prescription_id INT NOT NULL,
    FOREIGN KEY (prescription_id) REFERENCES prescriptions(prescription_id) ON DELETE CASCADE
);

-- PRESCRIPTION LAB TESTS TABLE (weak entity)
CREATE TABLE prescription_lab_tests (
    lab_test_id INT PRIMARY KEY AUTO_INCREMENT,
    lab_test_name VARCHAR(100),
    prescription_id INT NOT NULL,
    FOREIGN KEY (prescription_id) REFERENCES prescriptions(prescription_id) ON DELETE CASCADE
);

-- TRANSACTIONS TABLE
CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT NOT NULL,
    trans_type VARCHAR(32),
    amount DECIMAL(10,2) NOT NULL,
    transaction_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

-- INVOICES TABLE
CREATE TABLE invoices (
    invoice_id INT PRIMARY KEY AUTO_INCREMENT,
    invoice_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10,2) NOT NULL,
    transaction_status VARCHAR(20) DEFAULT 'pending',
    consult_id INT NOT NULL,
    student_id INT NOT NULL,
    transaction_id INT,
    FOREIGN KEY (consult_id) REFERENCES consultations(consult_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id) ON DELETE SET NULL
);



#################################################################
#                        Procedures                             #
#################################################################


-- Procedure to transfer funds (pay invoices)
DELIMITER $$

CREATE PROCEDURE transfer_funds (
    IN sender_student_id INT,
    IN medical_center_account_id INT,
    IN amount DECIMAL(10,2)
)
BEGIN
    DECLARE student_account_id INT;
    DECLARE student_balance DECIMAL(10,2);
    DECLARE v_transaction_id INT;

    -- Find student's account
    SELECT account_id INTO student_account_id
    FROM students
    WHERE student_id = sender_student_id;

    START TRANSACTION;

    -- Lock sender's account row
    SELECT balance INTO student_balance
    FROM accounts
    WHERE account_id = student_account_id
    FOR UPDATE;

    IF student_balance < amount THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient funds';
    ELSE
        -- Update balances
        UPDATE accounts SET balance = balance - amount WHERE account_id = student_account_id;
        UPDATE accounts SET balance = balance + amount WHERE account_id = medical_center_account_id;

        -- Log transactions
        INSERT INTO transactions(account_id, trans_type, amount, transaction_date)
        VALUES (student_account_id, 'Made Payment', amount, NOW());

        INSERT INTO transactions(account_id, trans_type, amount, transaction_date)
        VALUES (medical_center_account_id, 'Received Payment', amount, NOW());

        -- Capture transaction id
        SET v_transaction_id = LAST_INSERT_ID();

        -- Update pending invoices
        UPDATE invoices
        SET transaction_status = 'paid',
            transaction_id = v_transaction_id
        WHERE student_id = sender_student_id
          AND transaction_status = 'pending'
        ORDER BY invoice_date ASC
        LIMIT 1;

        COMMIT;
    END IF;
END $$

DELIMITER ;

-- Procedure to count non-null vital signs
DELIMITER $$

CREATE PROCEDURE count_non_null_values_vital_signs (
    IN p_consult_id INT,
    OUT p_non_null_count INT
)
BEGIN
    DECLARE non_null_count INT DEFAULT 0;

    SELECT 
        (CASE WHEN bp IS NOT NULL THEN 1 ELSE 0 END) +
        (CASE WHEN pulse IS NOT NULL THEN 1 ELSE 0 END) +
        (CASE WHEN temp IS NOT NULL THEN 1 ELSE 0 END) +
        (CASE WHEN respiratory_rate IS NOT NULL THEN 1 ELSE 0 END) +
        (CASE WHEN oxygen_saturation IS NOT NULL THEN 1 ELSE 0 END) +
        (CASE WHEN blood_glucose IS NOT NULL THEN 1 ELSE 0 END) +
        (CASE WHEN weight IS NOT NULL THEN 1 ELSE 0 END)
    INTO non_null_count
    FROM vital_signs
    WHERE consult_id = p_consult_id;

    SET p_non_null_count = non_null_count;
END $$

DELIMITER ;


#################################################################
#                        Triggers                               #
#################################################################




-- First, drop the old trigger if it exists
DROP TRIGGER IF EXISTS generate_invoice;

-- Now, new correct trigger AFTER vital_signs insertion
DELIMITER $$

CREATE TRIGGER generate_invoice_after_vitals
AFTER INSERT ON vital_signs
FOR EACH ROW
BEGIN
    DECLARE num_non_null INT;
    DECLARE student INT;
    DECLARE amount DECIMAL(10,2);

    -- Find the student id from the consultation -> patient -> student
    SELECT st.student_id INTO student
    FROM consultations c
    JOIN patients p ON c.patient_id = p.patient_id
    JOIN students st ON p.student_id = st.student_id
    WHERE c.consult_id = NEW.consult_id;

    -- Count non-null vital signs
    CALL count_non_null_values_vital_signs(NEW.consult_id, num_non_null);

    -- Calculate invoice amount
    SET amount = num_non_null * 50;

    -- Create invoice
    INSERT INTO invoices (invoice_date, amount, transaction_status, consult_id, student_id)
    VALUES (NOW(), amount, 'pending', NEW.consult_id, student);
END $$

DELIMITER ;



