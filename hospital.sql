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
    fname VARCHAR (100) NOT NULL,
    lname VARCHAR (100) NOT NULL,
    dob DATE NOT NULL,
    address VARCHAR (500) NOT NULL,
    phone INT(11) NOT NULL,

    PRIMARY KEY(pat_ID)
);

CREATE TABLE IF NOT EXISTS Secretaries(
    sec_ID INT NOT NULL AUTO_INCREMENT,
    fname VARCHAR(100) NOT NULL,
    lname VARCHAR (100) NOT NULL,
    dob DATE NOT NULL,
    address VARCHAR (500) NOT NULL,
    phone INT(11) NOT NULL,

    PRIMARY KEY(sec_ID)
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

CREATE TABLE IF NOT EXISTS OtherAllergies (
    allergy_ID INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,

    PRIMARY KEY(allergy_ID)
);

CREATE TABLE IF NOT EXISTS Procedures (
    proc_ID INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,

    PRIMARY KEY(proc_ID)
);

CREATE TABLE IF NOT EXISTS  Results (
    result_ID INT NOT NULL AUTO_INCREMENT,
    test_result VARCHAR (200) NOT NULL,
    result_date DATE NOT NULL,

    PRIMARY KEY(result_ID)
);

CREATE TABLE IF NOT EXISTS ScnImg (
    scn_img_ID INT NOT NULL AUTO_INCREMENT,
    scn_img MEDIUMBLOB NOT NULL,

    PRIMARY KEY(scn_img_ID)
);

CREATE TABLE IF NOT EXISTS Tests (
    test_ID INT NOT NULL AUTO_INCREMENT,
    name VARCHAR (100) NOT NULL,
    types VARCHAR (100) NOT NULL,

    PRIMARY KEY(test_ID)
);

CREATE TABLE IF NOT EXISTS Treatments (
    treat_ID INT NOT NULL AUTO_INCREMENT,
    name VARCHAR (100) NOT NULL,

    PRIMARY KEY(treat_ID)
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
CREATE TABLE IF NOT EXISTS accesses (
    nurse_ID INT NOT NULL,
    treat_ID INT NOT NULL,
    dates DATE NOT NULL,
    dosage VARCHAR(20) NOT NULL,
    dosage_intervals VARCHAR(20) NOT NULL,

    CONSTRAINT pk_accesses
        PRIMARY KEY(nurse_ID,treat_ID),
    CONSTRAINT fk_accesses
        FOREIGN KEY (nurse_ID)
            REFERENCES Nurses(nurse_ID)
);

CREATE TABLE IF NOT EXISTS administers (
    nurse_ID INT NOT NULL,
    med_ID INT NOT NULL,
    dates DATE NOT NULL,
    dosage VARCHAR (20) NOT NULL,
    dosage_intervals VARCHAR (20) NOT NULL,

    CONSTRAINT pk_administers
        PRIMARY KEY(nurse_ID,med_ID),
    CONSTRAINT fk_administers
        FOREIGN KEY (nurse_ID)
            REFERENCES Nurses(nurse_ID)
);

CREATE TABLE IF NOT EXISTS afflicted_with (
    pat_ID INT NOT NULL,
    allergy_ID INT NOT NULL,

    CONSTRAINT fk_afflicted_with_pat_ID
        FOREIGN KEY (pat_ID)
            REFERENCES Patients(pat_ID),
    CONSTRAINT fk_afflicted_with_allergy_ID
        FOREIGN KEY (allergy_ID)
            REFERENCES OtherAllergies(allergy_ID)
);

CREATE TABLE IF NOT EXISTS allergic_to (
    pat_ID INT NOT NULL,
    med_ID INT NOT NULL,

    CONSTRAINT fk_allergic_to_pat_ID
        FOREIGN KEY (pat_ID)
            REFERENCES Patients(pat_ID),
    CONSTRAINT fk_allergic_to_med_ID
        FOREIGN KEY (med_ID)
            REFERENCES Medication(med_ID)
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

CREATE TABLE IF NOT EXISTS attached_to (
    result_ID INT NOT NULL,
    scn_img_ID INT NOT NULL,

    CONSTRAINT fk_attached_to_pat_ID
        FOREIGN KEY (result_ID)
            REFERENCES Results(result_ID),
    CONSTRAINT fk_attached_to_scn_img_ID 
        FOREIGN KEY (scn_img_ID )
            REFERENCES ScnImg (scn_img_ID )
);

CREATE TABLE IF NOT EXISTS belongs_to (
    pat_ID INT NOT NULL,
    vitals_ID INT NOT NULL,
	
    CONSTRAINT fk_belongs_to_pat_ID
        FOREIGN KEY (pat_ID)
            REFERENCES Patients(pat_ID),
    CONSTRAINT fk_belongs_to_vitals_ID
        FOREIGN KEY (vitals_ID)
            REFERENCES VitalSigns(vitals_ID)
);

CREATE TABLE IF NOT EXISTS checks (
    nurse_ID INT NOT NULL,
    vitals_ID INT NOT NULL,
    dates DATE NOT NULL,

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
    dates DATE NOT NULL,

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
    diag_ID INT NOT NULL,
    pat_ID INT NOT NULL,
    dates DATE NOT NULL,

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

CREATE TABLE IF NOT EXISTS performs_procedure (
    doc_ID INT NOT NULL,
    pat_ID INT NOT NULL,
    proc_ID INT NOT NULL,
    dates DATE NOT NULL,

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
    dates DATE NOT NULL,

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

CREATE TABLE IF NOT EXISTS performs_treatment (
    doc_ID INT NOT NULL,
    pat_ID INT NOT NULL,
    treat_ID INT NOT NULL,
    dates DATE NOT NULL,

    CONSTRAINT fk_performs_treatment_doc_ID
        FOREIGN KEY (doc_ID)
            REFERENCES Doctors(doc_ID),
    CONSTRAINT fk_performs_treatment_pat_ID
        FOREIGN KEY (pat_ID)
            REFERENCES Patients(pat_ID),
    CONSTRAINT fk_performs_treatment_treat_ID
        FOREIGN KEY (treat_ID)
            REFERENCES Treatments(treat_ID)
);

CREATE TABLE IF NOT EXISTS prescribe_medication (
    doc_ID INT NOT NULL,
    med_ID INT NOT NULL,
    treat_ID INT NOT NULL,
    dates DATE NOT NULL,

    CONSTRAINT fk_prescribe_medication_doc_ID
        FOREIGN KEY (doc_ID)
            REFERENCES Doctors(doc_ID),
    CONSTRAINT fk_prescribe_medication_med_ID
        FOREIGN KEY (med_ID)
            REFERENCES Medication(med_ID),
	CONSTRAINT fk_prescribe_medication_treat_ID
		FOREIGN KEY (treat_ID)
			REFERENCES Treatments(treat_ID)
);

CREATE TABLE IF NOT EXISTS recommends (
    doc_ID INT NOT NULL,
    treat_ID INT NOT NULL,
    diag_ID INT NOT NULL,
    dates DATE NOT NULL,

    CONSTRAINT fk_recommends_doc_ID
        FOREIGN KEY (doc_ID)
            REFERENCES Doctors(doc_ID),
    CONSTRAINT fk_recommends_treat_ID
        FOREIGN KEY (treat_ID)
            REFERENCES Treatments(treat_ID),
	CONSTRAINT fk_recommends_diag_ID
		FOREIGN KEY (diag_ID)
			REFERENCES Diagnosis(diag_ID)
);

CREATE TABLE IF NOT EXISTS registers (
    sec_ID INT NOT NULL,
    pat_ID INT NOT NULL,
    fam_hist_ID INT NOT NULL,
    dates DATE NOT NULL,

    CONSTRAINT fk_registers_sec_ID
        FOREIGN KEY (sec_ID)
            REFERENCES Secretaries(sec_ID),
	CONSTRAINT fk_registers_pat_ID
        FOREIGN KEY (pat_ID)
            REFERENCES Patients(pat_ID),
    CONSTRAINT fk_registers_fam_hist_ID
        FOREIGN KEY (fam_hist_ID)
            REFERENCES FamilyHistory(fam_hist_ID)
);

CREATE TABLE IF NOT EXISTS treats (
    nurse_ID INT NOT NULL,
    pat_ID INT NOT NULL,
    treat_ID INT NOT NULL,
    dates DATE NOT NULL,

    CONSTRAINT fk_treats_nurse_ID
        FOREIGN KEY (nurse_ID)
            REFERENCES Nurses(nurse_ID),
    CONSTRAINT fk_treats_pat_ID
        FOREIGN KEY (pat_ID)
            REFERENCES Patients(pat_ID),
	CONSTRAINT fk_treats_treat_ID
		FOREIGN KEY (treat_ID)
			REFERENCES Treatments(treat_ID)
);


/* IS A */
CREATE TABLE IF NOT EXISTS Consultant (
    doc_ID INT NOT NULL,
    specialization VARCHAR (100) NOT NULL,

    CONSTRAINT fk_consultant_doc_ID
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

# Store Procedures


# GRANT ALL PRIVILEGES ON HOSPITAL.* to 'sysAdmin'@'%' IDENTIFIED BY 'sysAdmin123';

CREATE OR REPLACE PROCEDURE sp_get_doctors()
    BEGIN
        SELECT
            fname                                               # tuple[0]
            ,lname                                              # tuple[1]
        FROM Doctors;
    END;

# CALL sp_get_doctors();

CREATE OR REPLACE PROCEDURE sp_get_nurses()
    BEGIN
        SELECT
            name                                               # tuple[0]
            ,lname                                              # tuple[1]
        FROM Nurses;
    END;
# CALL sp_get_nurses();

CREATE OR REPLACE PROCEDURE sp_get_currentuser()
    BEGIN
        SELECT SESSION_USER();
    END;


 # CALL sp_get_currentuser();

CREATE OR REPLACE PROCEDURE
    get_patients_by_allergens(
)
    BEGIN
        SELECT a.name  AS Allergen,
               p.fname  AS FirstName,
               p.lname AS LastName
        FROM patients AS p
                 JOIN afflicted_with aw on p.pat_ID = aw.pat_ID
                 JOIN otherallergies as a on a.allergy_ID = aw.allergy_ID

        UNION

        SELECT m.gen_name AS Allergen,
               p.fname     AS FirstName,
               p.lname    AS LastName
        FROM patients AS p
                 JOIN allergic_to at on p.pat_ID = at.pat_ID
                 JOIN medication as m on m.med_ID = at.med_ID;
    END;

# CALL get_patients_by_allergens();



#

CREATE OR REPLACE PROCEDURE
    sp_add_patient(
    fname VARCHAR(100),
    lname VARCHAR (100),
    dob DATE,
    address VARCHAR (500),
    phone INT(11)
)
    BEGIN

        IF (SELECT NOT EXISTS(SELECT 1
                                FROM hospital.patients AS p
                                WHERE p.fname = fname
                                AND p.lname = lname
                                AND p.dob = dob
                                AND p.address = address
                                AND p.phone = phone)) THEN

            INSERT INTO Secretaries VALUES (NULL, fname, lname, dob, address, phone);

        END IF;
    END;

CALL sp_add_patient('Bill', 'Willy', '1990-04-01', '2 Will Way', 8349602);

#

CREATE OR REPLACE PROCEDURE
    sp_add_secretary(
    fname VARCHAR(100),
    lname VARCHAR (100),
    dob DATE,
    address VARCHAR (500),
    phone INT(11)
)
    BEGIN
        SET @username = CONCAT(fname,lname);
        SET @password = CONCAT(fname,lname);

        IF (SELECT NOT EXISTS(SELECT 1 FROM mysql.user WHERE user = @username)) THEN

            SET @sql = CONCAT('GRANT USAGE,SELECT ON HOSPITAL.* to \'',@username,'\'@\'%\' IDENTIFIED BY \'',@password,'\'');
            PREPARE stmt from @sql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @sql = CONCAT('GRANT EXECUTE ON PROCEDURE sp_get_doctors TO \'',@username,'\'');
            PREPARE stmt from @sql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @sql = CONCAT('GRANT EXECUTE ON PROCEDURE sp_get_nurses TO \'',@username,'\'');
            PREPARE stmt from @sql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @sql = CONCAT('GRANT EXECUTE ON PROCEDURE sp_add_patient TO \'',@username,'\'');
            PREPARE stmt from @sql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @sql = CONCAT('GRANT Secretary TO \'',@username,'\'@\'%\'');
            PREPARE stmt from @sql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @sql = CONCAT('GRANT AppUser TO \'',@username,'\'@\'%\'');
            PREPARE stmt from @sql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            INSERT INTO Secretaries VALUES (NULL, fname, lname, dob, address, phone);
        END IF;
    END;

 CALL sp_add_secretary('Carla', 'Davis', '1990-12-11', '123 Main Street', 4759309);

CREATE OR REPLACE PROCEDURE
    sp_add_nurse(
    fname VARCHAR(100),
    lname VARCHAR (100),
    dob DATE,
    address VARCHAR (500),
    phone INT(11),
    category VARCHAR (100)
)
    BEGIN
        SET @username = CONCAT(fname,lname);
        SET @password = CONCAT(fname,lname);

        IF (SELECT NOT EXISTS(SELECT 1 FROM mysql.user WHERE user = @username)) THEN
            SET @sql = CONCAT('GRANT USAGE,SELECT ON HOSPITAL.* to \'',@username,'\'@\'%\' IDENTIFIED BY \'',@password,'\'');
            PREPARE stmt from @sql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @sql = CONCAT('GRANT EXECUTE ON PROCEDURE sp_get_doctors TO \'',@username,'\'');
            PREPARE stmt from @sql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @sql = CONCAT('GRANT EXECUTE ON PROCEDURE get_patients_by_allergens TO \'',@username,'\'');
            PREPARE stmt from @sql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @sql = CONCAT('GRANT EXECUTE ON PROCEDURE sp_add_patient TO \'',@username,'\'');
            PREPARE stmt from @sql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @sql = CONCAT('GRANT Nurse TO \'',@username,'\'@\'%\'');
            PREPARE stmt from @sql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @sql = CONCAT('GRANT AppUser TO \'',@username,'\'@\'%\'');
            PREPARE stmt from @sql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            INSERT INTO Nurses VALUES (NULL, fname, lname, dob, address, phone, category);
        END IF;
    END;

 CALL sp_add_nurse('Susan', 'Wilby', '1990-02-01', '183 5th Street', 3759245, 'registered');



#

CREATE OR REPLACE PROCEDURE
    sp_add_doctor(
    fname VARCHAR(100),
    lname VARCHAR (100),
    dob DATE,
    address VARCHAR (500),
    phone INT(11)
)
    BEGIN
        SET @username = CONCAT(fname,lname);
        SET @password = CONCAT(fname,lname);

        IF (SELECT NOT EXISTS(SELECT 1 FROM mysql.user WHERE user = @username)) THEN

            SET @sql = CONCAT('GRANT USAGE,SELECT ON HOSPITAL.* to \'',@username,'\'@\'%\' IDENTIFIED BY \'',@password,'\'');
            PREPARE stmt from @sql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @sql = CONCAT('GRANT EXECUTE ON PROCEDURE sp_get_doctors TO \'',@username,'\'');
            PREPARE stmt from @sql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @sql = CONCAT('GRANT EXECUTE ON PROCEDURE sp_get_nurses TO \'',@username,'\'');
            PREPARE stmt from @sql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @sql = CONCAT('GRANT EXECUTE ON PROCEDURE get_patients_by_allergens TO \'',@username,'\'');
            PREPARE stmt from @sql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @sql = CONCAT('GRANT Doctor TO \'',@username,'\'@\'%\'');
            PREPARE stmt from @sql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @sql = CONCAT('GRANT AppUser TO \'',@username,'\'@\'%\'');
            PREPARE stmt from @sql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            INSERT INTO Doctors VALUES (NULL, fname, lname, dob, address, phone);
        END IF;
    END;

 CALL sp_add_doctor('Jeff', 'Rights', '1990-12-11', '345 Wilbo Avenue', 3472893);
 CALL sp_add_doctor('Timmy', 'Tuner', '1999-01-01', '345 Burner Way', 3472893);



# Roles

CREATE OR REPLACE ROLE Secretary;
GRANT SELECT,INSERT,UPDATE ON patients.* TO Secretary;
GRANT USAGE, SELECT ON doctors.* TO Secretary;
GRANT EXECUTE ON hospital.* TO Secretary;
GRANT SELECT, USAGE ON mysql.proc TO Secretary;
GRANT EXECUTE ON PROCEDURE sp_get_doctors TO Secretary;

CREATE OR REPLACE ROLE Nurse;
GRANT SELECT,INSERT,UPDATE ON accesses.* TO Nurse;
GRANT SELECT,INSERT,UPDATE ON administers.* TO Nurse;
GRANT SELECT,INSERT,UPDATE ON checks.* TO Nurse;
GRANT SELECT,INSERT,UPDATE ON treats.* TO Nurse;
GRANT SELECT,INSERT,UPDATE ON patients.* TO Nurse;

CREATE OR REPLACE ROLE Doctor;
GRANT SELECT,INSERT,UPDATE ON examine.* TO Doctor;
GRANT SELECT,INSERT,UPDATE ON makes_diagnosis.* TO Doctor;
GRANT SELECT,INSERT,UPDATE ON performs_procedure.* TO Doctor;
GRANT SELECT,INSERT,UPDATE ON performs_test.* TO Doctor;
GRANT SELECT,INSERT,UPDATE ON prescribe_medication.* TO Doctor;
GRANT SELECT,INSERT,UPDATE ON recommends.* TO Doctor;
GRANT SELECT,INSERT,UPDATE ON patients.* TO Doctor;

CREATE OR REPLACE ROLE AppUser;
GRANT USAGE, SELECT ON HOSPITAL.* TO AppUser;
GRANT SELECT ON mysql.global_priv TO AppUser;


