# Generate 100000 performs_test records
INSERT INTO performs_test
(SELECT
       (SELECT doctors.doc_ID FROM doctors ORDER BY RAND() LIMIT 1) AS doc_ID,
        pat_ID,
        (SELECT tests.test_ID FROM tests ORDER BY RAND() LIMIT 1) AS test_ID,
        (SELECT * FROM (VALUES ('2020-05-16'),('2020-05-17'),('2020-05-18'),('2020-05-19'),('2020-05-20'),('2020-05-21'),('2020-05-22'),('2020-05-23'),('2020-05-24'),('2020-05-25'),('2020-05-26')) AS x ORDER BY RAND() LIMIT 1) AS dates
FROM patients
ORDER BY RAND()
LIMIT 100000);