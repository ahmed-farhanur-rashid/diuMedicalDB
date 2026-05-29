# DIU Medical Center Database

A relational database design project for a university medical center, built as part of a **Database Management** course. The project covers the full database design lifecycle — entity identification, ER modeling, schema definition, and normalization — with no backend or frontend implementation.

---

## ER Diagram

![ER Diagram](https://raw.githubusercontent.com/ahmed-farhanur-rashid/diuMedicalDB/main/Medical_Center.png)

> The diagram illustrates entity relationships across students, patients, consultations, prescriptions, transactions, and supporting tables.

---

## Schema

### `accounts`
Holds financial account information linked to students.
```
accounts (
    account_id, 
    balance
);
```

---

### `students`
Stores student identity and membership details, including card issuance and expiry dates.
```
students (
    student_id, 
    name, 
    issued_on, 
    expires_on, 
    account_id, 
    phone
);
```
- `account_id` → references `accounts`

---

### `patients`
Extends student records with medical profile information.
```
patients (
    patient_id, 
    student_id, 
    date_of_birth, 
    bloodgroup, 
    sex
);
```
- `student_id` → references `students`

---

### `histories`
Tracks a patient's medical history, including conditions and their current status.
```
histories (
    history_id, 
    patient_id, 
    conditionDetails, 
    condition_status, 
    year_diagnosed
);
```
- `patient_id` → references `patients`

---

### `medical_staff_roles`
Defines roles within the medical center and whether each role has prescribing authority.
```
medical_staff_roles (
    role_id, 
    role_name, 
    can_prescribe
);
```

---

### `medical_staffs`
Stores information about medical personnel and their assigned roles.
```
medical_staffs (
    medical_staff_id, 
    role_id, 
    name, 
    phone, 
    password
);
```
- `role_id` → references `medical_staff_roles`

---

### `consultations`
Records each consultation session between a patient and a staff member.
```
consultations (
    consult_id, 
    patient_id, 
    medical_staff_id, 
    consult_time
);
```
- `patient_id` → references `patients`
- `medical_staff_id` → references `medical_staffs`

---

### `vital_signs`
Captures clinical measurements taken during a consultation.
```
vital_signs (
    consult_id, 
    bp, 
    pulse, 
    temp, 
    respiratory_rate, 
    oxygen_saturation, 
    blood_glucose, 
    weight
);
```
- `consult_id` → references `consultations` (1-to-1)

---

### `prescriptions`
Links a prescription to a consultation, recording the date and chief complaint.
```
prescriptions (
    prescription_id, 
    consult_id, 
    prescription_date, 
    chief_complaint
);
```
- `consult_id` → references `consultations`

---

### `prescription_medicines`
Lists individual medicines prescribed within a prescription.
```
prescription_medicines (
    medicine_id, 
    medicine_name, 
    frequency, 
    dosage, 
    days, 
    instructions, 
    prescription_id
);
```
- `prescription_id` → references `prescriptions`

---

### `prescription_lab_tests`
Lists lab tests ordered as part of a prescription.
```
prescription_lab_tests (
    lab_test_id, 
    lab_test_name, 
    prescription_id
);
```
- `prescription_id` → references `prescriptions`

---

### `transactions`
Records financial transactions associated with a student's account.
```
transactions (
    transaction_id, 
    account_id, 
    trans_type, 
    amount, 
    transaction_date
);
```
- `account_id` → references `accounts`

---

### `invoices`
Ties a consultation's billing to a student and a transaction record.
```
invoices (
    invoice_id, 
    invoice_date, 
    amount, 
    transaction_status, 
    consult_id, 
    student_id, 
    transaction_id
);
```
- `consult_id` → references `consultations`
- `student_id` → references `students`
- `transaction_id` → references `transactions`

---

## Project Scope

| Area            | Included |
|-----------------|----------|
| Database Design | ✅       |
| ER Modeling     | ✅       |
| Schema          | ✅       |
| Backend         | ❌       |
| Frontend        | ❌       |

---

## Course

**Database Management** — University course project
