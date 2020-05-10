/* ENTITIES */

CREATE DATABASE IF NOT EXISTS HOSPITAL DEFAULT CHARACTER SET UTF8 DEFAULT COLLATE UTF8_BIN;
USE HOSPITAL;

CREATE TABLE IF NOT EXISTS Doctors(
    doc_ID INT NOT NULL AUTO_INCREMENT,
    fname VARCHAR(100) NOT NULL,
    lname VARCHAR (100) NOT NULL,
    dob DATE NOT NULL,
    address VARCHAR (500) NOT NULL,
    phone INT(11) NOT NULL,

    PRIMARY KEY(doc_ID)
);

CREATE TABLE IF NOT EXISTS Nurses (
    nurse_ID INT NOT NULL AUTO_INCREMENT,
    name VARCHAR (100) NOT NULL,
    lname VARCHAR (100) NOT NULL,
    dob DATE NOT NULL,
    address VARCHAR (500) NOT NULL,
    phone INT(11) NOT NULL,
    category VARCHAR (100) NOT NULL,

    PRIMARY KEY(nurse_ID)
);

CREATE TABLE IF NOT EXISTS Patients (
    pat_ID INT NOT NULL AUTO_INCREMENT,
    name VARCHAR (100) NOT NULL,
    lname VARCHAR (100) NOT NULL,
    dob DATE NOT NULL,
    address VARCHAR (500) NOT NULL,
    phone INT(11) NOT NULL,

    PRIMARY KEY(pat_ID)
);

CREATE TABLE IF NOT EXISTS Diagnosis (
    diag_ID INT NOT NULL AUTO_INCREMENT,
    icd_ID INT,
    icd_description VARCHAR (1000),
    name VARCHAR (100) NOT NULL,
    specifics_details VARCHAR (500) NOT NULL,

    PRIMARY KEY(diag_ID)
);

CREATE TABLE IF NOT EXISTS FamilyHistory (
    fam_hist_ID INT NOT NULL AUTO_INCREMENT,
    fam_ID INT NOT NULL,
    diagnosis VARCHAR(500) NOT NULL,

    PRIMARY KEY(fam_hist_ID)
);

CREATE TABLE IF NOT EXISTS Medication (
    med_ID INT NOT NULL AUTO_INCREMENT,
    gen_name VARCHAR (200) NOT NULL,
    other_name VARCHAR (100) NOT NULL,

    PRIMARY KEY(med_ID)
);

CREATE TABLE IF NOT EXISTS Procedures (
    proc_ID INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,

    PRIMARY KEY(proc_ID)
);

CREATE TABLE IF NOT EXISTS  Results (
    result_ID INT NOT NULL AUTO_INCREMENT,
    result VARCHAR (200) NOT NULL,
    result_date DATE NOT NULL,

    PRIMARY KEY(result_ID)
);

CREATE TABLE IF NOT EXISTS Treatments (
    treat_ID INT NOT NULL AUTO_INCREMENT,
    name VARCHAR (100) NOT NULL,

    PRIMARY KEY(treat_ID)
);

CREATE TABLE IF NOT EXISTS Tests (
    test_ID INT NOT NULL AUTO_INCREMENT,
    name VARCHAR (100) NOT NULL,
    type VARCHAR (100) NOT NULL,

    PRIMARY KEY(test_ID)
);

CREATE TABLE IF NOT EXISTS VitalSigns (
    vitals_ID INT NOT NULL AUTO_INCREMENT,
    temperature INT NOT NULL,
    pulse INT NOT NULL,
    blood_pressure INT NOT NULL,
    respiratory VARCHAR (100) NOT NULL,

    PRIMARY KEY(vitals_ID)
);


/* RELATIONSHIPS */
CREATE TABLE IF NOT EXISTS administers (
    nurse_ID INT NOT NULL,
    med_ID INT NOT NULL,
    date DATE NOT NULL,
    dosage VARCHAR (20) NOT NULL,
    dosage_intervals VARCHAR (20) NOT NULL,

    CONSTRAINT pk_administers
        PRIMARY KEY(nurse_ID,med_ID),
    CONSTRAINT fk_administers
        FOREIGN KEY (nurse_ID)
            REFERENCES Nurses(nurse_ID)
);

CREATE TABLE IF NOT EXISTS accesses (
    nurse_ID INT NOT NULL,
    treat_ID INT NOT NULL,
    date DATE NOT NULL,
    dosage VARCHAR(20) NOT NULL,
    dosage_intervals VARCHAR(20) NOT NULL,

    CONSTRAINT pk_accesses
        PRIMARY KEY(nurse_ID,treat_ID),
    CONSTRAINT fk_accesses
        FOREIGN KEY (nurse_ID)
            REFERENCES Nurses(nurse_ID)
);

CREATE TABLE IF NOT EXISTS associated_with (
    pat_ID INT NOT NULL,
    fam_hist_ID INT NOT NULL,

    CONSTRAINT fk_associated_with_pat_ID
        FOREIGN KEY (pat_ID)
            REFERENCES Patients(pat_ID),
    CONSTRAINT fk_associated_with_fam_hist_ID
        FOREIGN KEY (fam_hist_ID)
            REFERENCES FamilyHistory(fam_hist_ID)
);

CREATE TABLE IF NOT EXISTS belongs_to (
    pat_ID INT NOT NULL,
    vitals_ID INT NOT NULL,
    CONSTRAINT fk_belongs_to
        FOREIGN KEY (pat_ID)
            REFERENCES Patients(pat_ID),
    CONSTRAINT fk_belongs_to_vitals_ID
        FOREIGN KEY (vitals_ID)
            REFERENCES VitalSigns(vitals_ID)
);

CREATE TABLE IF NOT EXISTS checks (
    nurse_ID INT NOT NULL,
    vitals_ID INT NOT NULL,
    date DATE NOT NULL,

    CONSTRAINT fk_checks_nurse_ID
        FOREIGN KEY (nurse_ID)
            REFERENCES Nurses(nurse_ID),
    CONSTRAINT fk_checks_vitals_ID
        FOREIGN KEY (vitals_ID)
            REFERENCES VitalSigns(vitals_ID)
);

CREATE TABLE IF NOT EXISTS examine (
    doc_ID INT NOT NULL,
    pat_ID INT NOT NULL,
    date DATE NOT NULL,

    CONSTRAINT fk_examine_doc_ID
        FOREIGN KEY (doc_ID)
            REFERENCES Doctors(doc_ID),
    CONSTRAINT fk_examine_pat_ID
        FOREIGN KEY (pat_ID)
            REFERENCES Patients(pat_ID)
);

CREATE TABLE IF NOT EXISTS generate_results (
    test_ID INT NOT NULL,
    result_ID INT NOT NULL,

    CONSTRAINT pk_generate_results
        PRIMARY KEY(test_ID,result_ID),
    CONSTRAINT fk_generate_results_test_ID
        FOREIGN KEY (test_ID)
            REFERENCES Tests(test_ID),
    CONSTRAINT fk_generate_results_result_ID
        FOREIGN KEY (result_ID)
            REFERENCES Results(result_ID)
);

CREATE TABLE IF NOT EXISTS makes_diagnosis (
    doc_ID INT NOT NULL,
    result_ID INT NOT NULL ,
    diag_ID INT NOT NULL,
    date DATE NOT NULL,

    CONSTRAINT fk_makes_diagnosis_doc_ID
        FOREIGN KEY (doc_ID)
            REFERENCES Doctors(doc_ID),
    CONSTRAINT fk_makes_diagnosis_result_ID
        FOREIGN KEY (result_ID)
            REFERENCES Results(result_ID),
    CONSTRAINT fk_makes_diagnosis_diag_ID
        FOREIGN KEY (diag_ID)
            REFERENCES Diagnosis(diag_ID)
);

CREATE TABLE IF NOT EXISTS performs_procedure (
    doc_ID INT NOT NULL,
    pat_ID INT NOT NULL,
    proc_ID INT NOT NULL,
    date DATE NOT NULL,

    CONSTRAINT fk_performs_procedure_doc_ID
        FOREIGN KEY (doc_ID)
            REFERENCES Doctors(doc_ID),
    CONSTRAINT fk_performs_procedure_pat_ID
        FOREIGN KEY (pat_ID)
            REFERENCES Patients(pat_ID),
    CONSTRAINT fk_performs_procedure_proc_ID
        FOREIGN KEY (proc_ID)
            REFERENCES Procedures(proc_ID)
);

CREATE TABLE IF NOT EXISTS performs_test (
    doc_ID INT NOT NULL,
    pat_ID INT NOT NULL,
    test_ID INT NOT NULL,
    date DATE NOT NULL,

    CONSTRAINT fk_performs_test_doc_ID
        FOREIGN KEY (doc_ID)
            REFERENCES Doctors(doc_ID),
    CONSTRAINT fk_performs_test_pat_ID
        FOREIGN KEY (pat_ID)
            REFERENCES Patients(pat_ID),
    CONSTRAINT fk_performs_test_test_ID
        FOREIGN KEY (test_ID)
            REFERENCES Tests(test_ID)
);

CREATE TABLE IF NOT EXISTS prescribe_medication (
    doc_ID INT NOT NULL,
    med_ID INT NOT NULL,
    date DATE NOT NULL,

    CONSTRAINT fk_prescribe_medication_doc_ID
        FOREIGN KEY (doc_ID)
            REFERENCES Doctors(doc_ID),
    CONSTRAINT fk_prescribe_medication_med_ID
        FOREIGN KEY (med_ID)
            REFERENCES Medication(med_ID)
);

CREATE TABLE IF NOT EXISTS recommends (
    doc_ID INT NOT NULL,
    treat_ID INT NOT NULL,
    date DATE NOT NULL,

    CONSTRAINT fk_recommends_doc_ID
        FOREIGN KEY (doc_ID)
            REFERENCES Doctors(doc_ID),
    CONSTRAINT fk_recommends_treat_ID
        FOREIGN KEY (treat_ID)
            REFERENCES Treatments(treat_ID)
);

CREATE TABLE IF NOT EXISTS treats (
    nurse_ID INT NOT NULL,
    pat_ID INT NOT NULL,
    date DATE NOT NULL,

    CONSTRAINT fk_treats_nurse_ID
        FOREIGN KEY (nurse_ID)
            REFERENCES Nurses(nurse_ID),
    CONSTRAINT fk_treats_pat_ID
        FOREIGN KEY (pat_ID)
            REFERENCES Patients(pat_ID)
);


/* IS A */
CREATE TABLE IF NOT EXISTS Consultant (
    doc_ID INT NOT NULL,
    specialization VARCHAR (100) NOT NULL,

    CONSTRAINT fk_Consultant_doc_ID
        FOREIGN KEY (doc_ID)
            REFERENCES Doctors(doc_ID)
);

CREATE TABLE IF NOT EXISTS Intern (
    doc_ID INT NOT NULL,

    CONSTRAINT fk_intern_doc_ID
        FOREIGN KEY (doc_ID)
            REFERENCES Doctors(doc_ID)
);

CREATE TABLE IF NOT EXISTS Resident (
    doc_ID INT NOT NULL,

    CONSTRAINT fk_resident_doc_ID
        FOREIGN KEY (doc_ID)
            REFERENCES Doctors(doc_ID)
);


# GRANT ALL PRIVILEGES ON HOSPITAL.* to 'sysAdmin'@'%' IDENTIFIED BY 'sysAdmin123';

CREATE OR REPLACE PROCEDURE sp_get_doctors()
    BEGIN
        SELECT
            fname
            ,lname
        FROM Doctors;
    END;


CALL sp_get_doctors();