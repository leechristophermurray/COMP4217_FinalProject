# Generate 250,000 new afflicted_with records
INSERT INTO allergic_to
(SELECT
       pat_ID,
       (SELECT med_ID FROM medication
ORDER BY RAND()
LIMIT 1) AS med_ID
FROM patients
ORDER BY RAND()
LIMIT 250000);