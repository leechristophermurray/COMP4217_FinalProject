/* ENTITIES */

CREATE DATABASE IF NOT EXISTS HOSPITAL DEFAULT CHARACTER SET UTF8 DEFAULT COLLATE UTF8_BIN;

USE HOSPITAL;

CREATE TABLE IF NOT EXISTS Doctors (
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
    fname VARCHAR (100) NOT NULL,
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

CREATE TABLE IF NOT EXISTS Secretaries (
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
    pat_ID INT NOT NULL,
    dates DATE NOT NULL,
    dosage VARCHAR (20) NOT NULL,
    dosage_intervals VARCHAR (20) NOT NULL,

    CONSTRAINT pk_administers
        PRIMARY KEY(nurse_ID,med_ID),
    CONSTRAINT fk_administers_nurse_ID
        FOREIGN KEY (nurse_ID)
            REFERENCES Nurses(nurse_ID),
    CONSTRAINT fk_administers_pat_ID
 	FOREIGN KEY (pat_ID)
            REFERENCES Patients(pat_ID)
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

    CONSTRAINT fk_attached_to_result_ID
        FOREIGN KEY (result_ID)
            REFERENCES Results(result_ID),
    CONSTRAINT fk_attached_to_scn_img_ID 
        FOREIGN KEY (scn_img_ID)
            REFERENCES ScnImg(scn_img_ID)
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
    pat_ID INT NOT NULL,
    treat_ID INT NOT NULL,
    dates DATE NOT NULL,

    CONSTRAINT fk_prescribe_medication_doc_ID
        FOREIGN KEY (doc_ID)
            REFERENCES Doctors(doc_ID),
    CONSTRAINT fk_medication_pat_ID
        FOREIGN KEY (pat_ID)
            REFERENCES Patients(pat_ID),
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


# STORE PROCEDURES


CREATE OR REPLACE PROCEDURE make_diagnosis(
	IN docID INT,
	IN patID INT,
	IN icdID INT,
	IN icdDesc VARCHAR(1000),
	IN icdname VARCHAR(100),
	IN specifics VARCHAR(500)
)
	BEGIN
	    IF (
	        (SELECT NOT EXISTS(
                            SELECT 1
                            FROM hospital.makes_diagnosis AS md
                                     JOIN diagnosis AS d
                                         ON md.diag_ID = d.diag_ID
                            WHERE md.doc_ID = docID
                              AND md.pat_ID = patId
                              AND d.icd_ID = icdID
                        )
           )
	        OR
           (SELECT EXISTS(
                           SELECT 1
                           FROM hospital.makes_diagnosis AS md
                                    JOIN diagnosis AS d
                                         ON md.diag_ID = d.diag_ID
                           WHERE md.doc_ID = docID
                             AND md.pat_ID = patId
                             AND d.icd_ID = icdID
                             AND md.dates < CURRENT_DATE() - INTERVAL 1 WEEK
                       )
           )
	    )
	    THEN

            INSERT INTO  diagnosis VALUES (NULL, icdID, icdDesc, icdname, specifics);
            SET @diagID = (SELECT LAST_INSERT_ID());
            INSERT INTO makes_diagnosis VALUES (docID, @diagID, patID, CURRENT_DATE());

        END IF;

    END;

# CALL make_diagnosis(3,2,534877374,
#     'Inhalation anthrax begins abruptly, usually 1-3 days (range, 1-60 d) after inhaling anthrax spores that are 1-5 µm in diameter. The number of spores needed to cause inhalation anthrax varies. This form presents initially with nonspecific symptoms, including a low-grade fever and a nonproductive cough. Patients may report substernal discomfort early in the illness. Patients may improve temporarily before rapidly deteriorating clinically with hemorrhagic mediastinitis. After the initial improvement, inhalation anthrax progresses rapidly, causing high fever, severe shortness of breath, tachypnea, cyanosis, profuse diaphoresis, hematemesis, and chest pain, which may be severe enough to mimic acute myocardial infarction.',
#     'Pulmonary anthrax','N/A');


# 5a
CREATE OR REPLACE PROCEDURE GetPatientByDiagnosisAndDate(
	IN start_date DATE, 
	IN end_date DATE, 
	IN diag_ID VARCHAR(100)
)
	BEGIN
        SELECT fname,lname FROM Patients 
            WHERE pat_ID IN(
                    SELECT pat_ID FROM makes_diagnosis
                        WHERE dates BETWEEN start_date AND end_date AND diag_ID IN(
                    SELECT diag_ID FROM Diagnosis
                ));
    END;


# 5b
CREATE OR REPLACE PROCEDURE
    get_allergens_of_patient(
    patID INT
)
    BEGIN
        SELECT a.name       AS Allergen,
               p.fname      AS FirstName,
               p.lname      AS LastName
        FROM patients AS p
             JOIN afflicted_with aw ON p.pat_ID = aw.pat_ID
             JOIN otherallergies AS a ON a.allergy_ID = aw.allergy_ID
        WHERE p.pat_ID = patID

        UNION

        SELECT m.gen_name   AS Allergen,
               p.fname      AS FirstName,
               p.lname      AS LastName
        FROM patients AS p
             JOIN allergic_to at ON p.pat_ID = at.pat_ID
             JOIN medication AS m ON m.med_ID = at.med_ID
        WHERE p.pat_ID = patID;
    END;

# CALL get_patients_by_allergens();

CREATE OR REPLACE PROCEDURE
    get_patients_by_allergens(
)
    BEGIN
        SELECT
               pat_ID,
               FirstName,
               LastName,
               Allergen
        FROM
        (SELECT p.pat_ID,
                p.fname      AS FirstName,
                p.lname      AS LastName,
                a.name       AS Allergen
        FROM patients AS p
             JOIN afflicted_with aw ON p.pat_ID = aw.pat_ID
             JOIN otherallergies AS a ON a.allergy_ID = aw.allergy_ID

        UNION

        SELECT p.pat_ID,
               p.fname      AS FirstName,
               p.lname      AS LastName,
               m.gen_name   AS Allergen
        FROM patients AS p
             JOIN allergic_to at ON p.pat_ID = at.pat_ID
             JOIN medication AS m ON m.med_ID = at.med_ID) AS pat_allergens
        ORDER BY pat_ID;
    END;

# CALL get_patients_by_allergens();

						
# 5c
CREATE OR REPLACE PROCEDURE GetMedicineAllergyByMostPatients()
	BEGIN
        SELECT
               m.med_ID,
               gen_name,
               risky_medz.pat_count
        FROM Medication AS m
        JOIN (
                SELECT
                       med_ID,
                       COUNT(pat_ID) AS pat_count
                FROM allergic_to
                GROUP BY med_ID
                    HAVING COUNT(pat_ID) > (
                        SELECT
                               AVG(at_avg.Amount)
                        FROM (
                            SELECT
                               COUNT(pat_ID) AS Amount
                            FROM allergic_to
                            GROUP BY med_ID
                            ) AS at_avg
                        )
                ) AS risky_medz
            ON m.med_ID = risky_medz.med_ID
        ORDER BY risky_medz.pat_count DESC;
    END;

						
# 5d
CREATE OR REPLACE PROCEDURE GetResultsByPatient(
    IN patID INT
)
	BEGIN
        SELECT
           test_result,
           scn_img_ID
        FROM
             performs_test AS pt
             JOIN tests AS t
                ON pt.test_ID = t.test_ID
                    AND pat_ID = patID
            JOIN  generate_results AS gr
                 ON t.test_ID = gr.test_ID
            JOIN results AS r
                ON gr.result_ID = r.result_ID
            LEFT JOIN attached_to AS at
                ON r.result_ID = at.result_ID;
	    # WHERE pat_ID = patID;
    END;

						
# 5e
CREATE OR REPLACE PROCEDURE GetNursesByPatientAndDate(
	IN start_date DATE, 
	IN end_date DATE,
	IN patID INT
)
	BEGIN
        SELECT
               nurse_ID,
               fname,
               lname
        FROM Nurses
            WHERE nurse_id IN(
                    SELECT
                           nurse_id
                    FROM administers
                    WHERE (dates BETWEEN
                                start_date AND end_date)
                        AND pat_ID = patID);
    END;

						
# 5f
CREATE OR REPLACE PROCEDURE GetInternsByMostPatient()
	BEGIN
        SELECT
               fname,
               lname
        FROM Doctors
            WHERE doc_ID IN(
                    SELECT
                           Newb.doc_ID
                    FROM Intern AS Newb,
                         performs_treatment AS Help
                    WHERE Newb.doc_ID = Help.doc_ID
                        AND Help.doc_ID IN(
                                SELECT
                                       doc_ID
                                FROM performs_treatment
                                GROUP BY doc_ID
                                    HAVING COUNT(pat_ID) > (
                                            SELECT AVG(pt_avg.Amount)
                                            FROM (
                                                SELECT COUNT(pat_ID) AS Amount
                                                FROM performs_treatment
                                                GROUP BY doc_ID
                                                ) AS pt_avg
                                        )
                            )
                );
    END;

#  OTHER Store Procedures


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
            fname                                               # tuple[0]
            ,lname                                              # tuple[1]
        FROM Nurses;
    END;
# CALL sp_get_nurses();

CREATE OR REPLACE PROCEDURE sp_get_currentuser(
    username VARCHAR(100)
)
    BEGIN
        SELECT * FROM
            (SELECT
               CONCAT(fname,lname) AS usr,
               fname,
               lname,
               'Doctor' AS role
            FROM doctors
            UNION
            SELECT
               CONCAT(fname,lname) AS usr,
                   fname,
                   lname,
                   'Nurse' AS role
            FROM nurses
            UNION
            SELECT
               CONCAT(fname,lname) AS usr,
                   fname,
                   lname,
                   'Secretary' AS role
            FROM secretaries) AS usrs
        WHERE LOCATE(usrs.usr,username) != 0;
    END;


# CALL sp_get_currentuser('CarlaDavis');

CREATE OR REPLACE PROCEDURE
    get_patients(
    q VARCHAR(100)
)
    BEGIN
        SELECT
               pat_ID,
               fname,
               lname,
               dob,
               address,
               phone
        FROM Patients
        WHERE LOCATE(q, fname)
            OR LOCATE(q, lname)
            OR LOCATE(q, CONCAT(fname, ' ', lname))
        ORDER BY RAND()
        LIMIT 30;

    END;

# CALL get_patients('Paul Shelton');


# Adder Store Procedures

CREATE OR REPLACE PROCEDURE
    sp_add_patient(
    fname VARCHAR(100),
    lname VARCHAR (100),
    dob VARCHAR (100),
    address VARCHAR (500),
    phone INT(11)
)
    BEGIN

        IF (SELECT NOT EXISTS(SELECT 1
                                FROM hospital.patients AS p
                                WHERE p.fname = fname
                                AND p.lname = lname
                                AND p.dob = CAST(dob AS DATE )
                                AND p.address = address
                                AND p.phone = phone)) THEN

            INSERT INTO Patients VALUES (NULL, fname, lname, CAST(dob AS DATE), address, phone);

        END IF;
    END;

# CALL sp_add_patient('Andy', 'Noobs', '2020-05-16', '228 HAMMOCK RIDGE DR', 5275469);


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

            SET @sql = CONCAT('GRANT EXECUTE ON PROCEDURE sp_get_currentuser TO \'',@username,'\'');
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

            SET @sql = CONCAT('GRANT EXECUTE ON PROCEDURE sp_get_currentuser TO \'',@username,'\'');
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

            SET @sql = CONCAT('GRANT EXECUTE ON PROCEDURE get_patients TO \'',@username,'\'');
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

            SET @sql = CONCAT('GRANT EXECUTE ON PROCEDURE sp_get_currentuser TO \'',@username,'\'');
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

            SET @sql = CONCAT('GRANT EXECUTE ON PROCEDURE make_diagnosis TO \'',@username,'\'');
            PREPARE stmt from @sql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @sql = CONCAT('GRANT EXECUTE ON PROCEDURE get_patients TO \'',@username,'\'');
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




# Roles

CREATE OR REPLACE ROLE Secretary;
GRANT SELECT,INSERT,UPDATE ON hospital.patients TO Secretary;
GRANT USAGE, SELECT ON hospital.doctors TO Secretary;
GRANT USAGE, SELECT ON hospital.nurses TO Secretary;
GRANT EXECUTE ON hospital.* TO Secretary;
GRANT SELECT, USAGE ON mysql.proc TO Secretary;

CREATE OR REPLACE ROLE Nurse;
GRANT SELECT,INSERT,UPDATE ON hospital.accesses TO Nurse;
GRANT SELECT,INSERT,UPDATE ON hospital.administers TO Nurse;
GRANT SELECT,INSERT,UPDATE ON hospital.checks TO Nurse;
GRANT SELECT,INSERT,UPDATE ON hospital.treats TO Nurse;
GRANT SELECT,INSERT,UPDATE ON hospital.patients TO Nurse;

CREATE OR REPLACE ROLE Doctor;
GRANT SELECT,INSERT,UPDATE ON hospital.examine TO Doctor;
GRANT SELECT,INSERT,UPDATE ON hospital.makes_diagnosis TO Doctor;
GRANT SELECT,INSERT,UPDATE ON hospital.performs_procedure TO Doctor;
GRANT SELECT,INSERT,UPDATE ON hospital.performs_test TO Doctor;
GRANT SELECT,INSERT,UPDATE ON hospital.prescribe_medication TO Doctor;
GRANT SELECT,INSERT,UPDATE ON hospital.recommends TO Doctor;
GRANT SELECT,INSERT,UPDATE ON hospital.patients TO Doctor;

CREATE OR REPLACE ROLE AppUser;
GRANT USAGE, SELECT ON HOSPITAL.* TO AppUser;
GRANT SELECT ON mysql.global_priv TO AppUser;

# Add Users
#
## CALL sp_add_patient('Bill', 'Willy', '1990-04-01', '2 Will Way', 8349602);
#  CALL sp_add_secretary('Carla', 'Davis', '1990-12-11', '123 Main Street', 4759309);
#  CALL sp_add_nurse('Susan', 'Wilby', '1990-02-01', '183 5th Street', 3759245, 'registered');
#  CALL sp_add_doctor('Jeff', 'Rights', '1990-12-11', '345 Wilbo Avenue', 3472893);
#  CALL sp_add_doctor('Timmy', 'Tuner', '1999-01-01', '345 Burner Way', 3472893);
