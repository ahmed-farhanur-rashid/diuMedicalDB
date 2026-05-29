#########################################
#		             Schema			            #
#########################################

accounts (
    account_id, 
    balance
);

students (
    student_id, 
    name, 
    issued_on, 
    expires_on, 
    account_id, 
    phone
);

patients (
    patient_id, 
    student_id, 
    date_of_birth, 
    bloodgroup, 
    sex
);

histories (
    history_id, 
    patient_id, 
    conditionDetails, 
    condition_status, 
    year_diagnosed
);

medical_staff_roles (
    role_id, 
    role_name, 
    can_prescribe
);

medical_staffs (
    medical_staff_id, 
    role_id, 
    name, 
    phone, 
    password
);

consultations (
    consult_id, 
    patient_id, 
    medical_staff_id, 
    consult_time
);

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

prescriptions (
    prescription_id, 
    consult_id, 
    prescription_date, 
    chief_complaint
);

prescription_medicines (
    medicine_id, 
    medicine_name, 
    frequency, 
    dosage, 
    days, 
    instructions, 
    prescription_id
);

prescription_lab_tests (
    lab_test_id, 
    lab_test_name, 
    prescription_id
);

transactions (
    transaction_id, 
    account_id, 
    trans_type, 
    amount, 
    transaction_date
);

invoices (
    invoice_id, 
    invoice_date, 
    amount, 
    transaction_status, 
    consult_id, 
    student_id, 
    transaction_id
);
