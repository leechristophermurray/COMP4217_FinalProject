# Generate 250,000 new afflicted_with records
INSERT INTO afflicted_with
(SELECT
       pat_ID,
       (SELECT allergy_ID FROM otherallergies
ORDER BY RAND()
LIMIT 1) AS allergy_ID
FROM patients
ORDER BY RAND()
LIMIT 250000);