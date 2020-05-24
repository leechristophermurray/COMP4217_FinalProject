# Generate 100000 new administers records
INSERT INTO administers
(SELECT
       (SELECT nurses.nurse_ID FROM nurses ORDER BY RAND() LIMIT 1) AS nurse_ID,
        (SELECT medication.med_ID FROM medication ORDER BY RAND() LIMIT 1) AS med_ID,
        pat_ID,
        (SELECT * FROM (VALUES ('2020-05-18 20:38:59'),('2020-05-19'),('2020-05-20 20:38:59'),('2020-05-21 09:34:23'),('2020-05-22 20:38:59'),('2020-05-23 20:38:59'),('2020-05-24 20:38:59'),('2020-05-25 12:14:36'),('2020-05-26 09:34:23')) AS x ORDER BY RAND() LIMIT 1) AS date_time,
        (SELECT * FROM (VALUES ('1 cup'),('2 oz'),('3 tbl spn'),('5 cc'),('76 cup'),('8 oz'),('9 cup'),('34 oz'),('53 oz')) AS x ORDER BY RAND() LIMIT 1) AS dosage,
        (SELECT * FROM (VALUES ('1 hr'),('2 hrs'),('3 hrs'),('5 hr'),('76 mins'),('8 hr'),('9 hr'),('34 mins'),('53 mins')) AS y ORDER BY RAND() LIMIT 1) AS dosage_intervals
FROM patients
ORDER BY RAND()
LIMIT 100000);