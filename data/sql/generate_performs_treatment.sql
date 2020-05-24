# Generate 50 new performs_treatment records
INSERT INTO performs_treatment
(SELECT
       (SELECT doc_ID FROM intern ORDER BY RAND() LIMIT 1) AS doc_ID,
        pat_ID,
       (SELECT treat_ID FROM treatments ORDER BY RAND() LIMIT 1) AS treat_ID,
        CURRENT_DATE() AS dates
FROM patients
ORDER BY RAND()
LIMIT 50);