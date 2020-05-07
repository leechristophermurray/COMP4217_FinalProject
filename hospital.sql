/* ENTITIES */
CREATE TABLE Doctors (
    doc_ID INT NOT NULL AUTO_INCREMENT,
    fname VARCHAR(100) NOT NULL,
    lname VARCHAR (100) NOT NULL,
    dob DATE NOT NULL,
    address VARCHAR (500) NOT NULL,
    phone INT(11) NOT NULL,

    PRIMARY KEY(doc_ID)
);

CREATE TABLE Nurses (
    nurse_ID INT NOT NULL AUTO_INCREMENT,
    fname VARCHAR (100) NOT NULL,
    lname VARCHAR (100) NOT NULL,
    dob DATE NOT NULL,
    address VARCHAR (500) NOT NULL,
    phone INT(11) NOT NULL,
    category VARCHAR (100) NOT NULL,

    PRIMARY KEY(nurse_ID)
);

CREATE TABLE Patients (
    pat_ID INT NOT NULL AUTO_INCREMENT,
    fname VARCHAR (100) NOT NULL,
    lname VARCHAR (100) NOT NULL,
    dob DATE NOT NULL,
    address VARCHAR (500) NOT NULL,
    phone INT(11) NOT NULL,

    PRIMARY KEY(pat_ID)
);

CREATE TABLE Diagnosis (
    diag_ID INT NOT NULL AUTO_INCREMENT,
    name VARCHAR (100) NOT NULL,
    specific_details VARCHAR (500) NOT NULL,

    PRIMARY KEY(diag_ID)
);

CREATE TABLE FamilyHistory (
    fam_hist_ID INT NOT NULL AUTO_INCREMENT,
    fam_ID INT NOT NULL,
    diagnosis VARCHAR(500) NOT NULL,

    PRIMARY KEY(fam_hist_ID)
);

CREATE TABLE Medication (
    med_ID INT NOT NULL AUTO_INCREMENT,
    gen_name VARCHAR (200) NOT NULL,
    other_name VARCHAR (100) NOT NULL,

    PRIMARY KEY(med_ID)
);

CREATE TABLE Procedure (
    proc_ID INT NOT NULL AUTO_INCREMENT,
    name VARCHAR (100) NOT NULL,
    category VARCHAR (50) NOT NULL,

    PRIMARY KEY(proc_ID)
);

CREATE TABLE Result (
    result_ID INT NOT NULL AUTO_INCREMENT,
    result VARCHAR (200) NOT NULL,
    result_date DATE NOT NULL,

    PRIMARY KEY(result_ID)
);

CREATE TABLE Treatment (
    treat_ID INT NOT NULL AUTO_INCREMENT,
    name VARCHAR (100) NOT NULL,

    PRIMARY KEY(treat_ID)
);

CREATE TABLE Test (
    test_ID INT NOT NULL AUTO_INCREMENT,
    name VARCHAR (100) NOT NULL,
    type VARCHAR (100) NOT NULL,

    PRIMARY KEY(test_ID)
);

CREATE TABLE VitalSigns (
    vitals_ID INT NOT NULL AUTO_INCREMENT,
    temperature INT NOT NULL,
    pulse INT NOT NULL,
    blood_pressure INT NOT NULL,
    respiratory VARCHAR (100) NOT NULL,

    PRIMARY KEY(vitals_ID)
);


/* RELATIONSHIPS */
CREATE TABLE administers (
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

CREATE TABLE accesses (
    nurse_ID INT NOT NULL,
    treat_ID INT NOT NULL,
    date DATE NOT NULL,
    dosage VARCHAR (20) NOT NULL,
    dosage_intervals VARCHAR (20) NOT NULL,

    CONSTRAINT pk_administers
        PRIMARY KEY(nurse_ID,treat_ID),
    CONSTRAINT fk_administers
        FOREIGN KEY (nurse_ID)
            REFERENCES Nurses(nurse_ID)
);

CREATE TABLE associated_with (
    pat_ID INT NOT NULL,
    fam_hist_ID INT NOT NULL,

    CONSTRAINT fk_associated_with_pat_ID
        FOREIGN KEY (pat_ID)
            REFERENCES Patients(pat_ID),
    CONSTRAINT fk_associated_with_fam_hist_ID
        FOREIGN KEY (fam_hist_ID)
            REFERENCES FamilyHistory(fam_hist_ID)
);

CREATE TABLE belongs_to (
    pat_ID INT NOT NULL,
    vitals_ID INT NOT NULL,
    
    CONSTRAINT fk_belongs_to_pat_ID
        FOREIGN KEY (pat_ID)
            REFERENCES Patients(pat_ID),
    CONSTRAINT fk_checks_vitals_ID
        FOREIGN KEY (vitals_ID)
            REFERENCES VitalSigns(vitals_ID)
);

CREATE TABLE checks (
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

CREATE TABLE examine (
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

CREATE TABLE generate_results (
    test_ID INT NOT NULL,
    result_ID INT NOT NULL,

    CONSTRAINT pk_generate_results
        PRIMARY KEY(test_ID,result_ID),
    CONSTRAINT fk_generate_results_test_ID
        FOREIGN KEY (test_ID)
            REFERENCES Tests(test_ID)
);

CREATE TABLE makes_diagnosis (
    doc_ID INT NOT NULL,
    diag_ID INT NOT NULL,
    pat_ID INT NOT NULL,    
    date DATE NOT NULL,

    CONSTRAINT fk_makes_diagnosis_doc_ID
        FOREIGN KEY (doc_ID)
            REFERENCES Doctors(doc_ID),
    CONSTRAINT fk_makes_diagnosis_diag_ID
        FOREIGN KEY (diag_ID)
            REFERENCES Diagnosis(diag_ID),
    CONSTRAINT fk_makes_diagnosis_pat_ID
        FOREIGN KEY (pat_ID)
            REFERENCES Patients(pat_ID)
);

CREATE TABLE performs_procedure (
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
            REFERENCES Procedure(proc_ID)
);

CREATE TABLE performs_test (
    doc_ID INT NOT NULL,
    pat_ID INT NOT NULL,
    test_ID INT NOT NULL,
    date DATE NOT NULL,

    CONSTRAINT fk_performs_procedure_doc_ID
        FOREIGN KEY (doc_ID)
            REFERENCES Doctors(doc_ID),
    CONSTRAINT fk_performs_procedure_pat_ID
        FOREIGN KEY (pat_ID)
            REFERENCES Patients(pat_ID),
    CONSTRAINT fk_performs_procedure_test_ID
        FOREIGN KEY (test_ID)
            REFERENCES Tests(test_ID)
);

CREATE TABLE prescribe_medication (
    doc_ID INT NOT NULL,
    med_ID INT NOT NULL,
    treat_ID INT NOT NULL,    
    date DATE NOT NULL,

    CONSTRAINT fk_prescribe_medication_doc_ID
        FOREIGN KEY (doc_ID)
            REFERENCES Doctors(doc_ID),
    CONSTRAINT fk_prescribe_medication_med_ID
        FOREIGN KEY (med_ID)
            REFERENCES Medication(med_ID),
    CONSTRAINT fk_prescribe_medication_treat_ID
        FOREIGN KEY (treat_ID)
            REFERENCES Treatment(treat_ID)            
);

CREATE TABLE recommends (
    doc_ID INT NOT NULL,
    treat_ID INT NOT NULL,
    diag_ID INT NOT NULL,
    date DATE NOT NULL,

    CONSTRAINT fk_recommends_doc_ID
        FOREIGN KEY (doc_ID)
            REFERENCES Doctors(doc_ID),
    CONSTRAINT fk_recommends_treat_ID
        FOREIGN KEY (treat_ID)
            REFERENCES Treatment(treat_ID),
    CONSTRAINT fk_recommends_diag_ID
        FOREIGN KEY (diag_ID)
            REFERENCES Diagnosis(diag_ID)            
);

CREATE TABLE treats (
    nurse_ID INT NOT NULL,
    pat_ID INT NOT NULL,
    treat_ID INT NOT NULL,    
    date DATE NOT NULL,

    CONSTRAINT fk_treats_nurse_ID
        FOREIGN KEY (nurse_ID)
            REFERENCES Doctors(nurse_ID),
    CONSTRAINT fk_treats_pat_ID
        FOREIGN KEY (pat_ID)
            REFERENCES Patients(pat_ID),
    CONSTRAINT fk_treats_treat_ID
        FOREIGN KEY (treat_ID)
            REFERENCES Treatment(treat_ID)            
);


/* IS A */
CREATE TABLE Consultant (
    doc_ID INT NOT NULL,
    specialization VARCHAR (100) NOT NULL,

    CONSTRAINT fk_Consultant_doc_ID
        FOREIGN KEY (doc_ID)
            REFERENCES Doctors(doc_ID)
);

CREATE TABLE Intern (
    doc_ID INT NOT NULL

    CONSTRAINT fk_intern_doc_ID
        FOREIGN KEY (doc_ID)
            REFERENCES Doctors(doc_ID)
);

CREATE TABLE Resident (
    doc_ID INT NOT NULL

    CONSTRAINT fk_resident_doc_ID
        FOREIGN KEY (doc_ID)
            REFERENCES Doctors(doc_ID)
);
