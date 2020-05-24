# Generate 4656 generate_results records
INSERT INTO generate_results
(SELECT
        doc_ID,
        pat_ID,
        test_ID,
        dates AS testDate,
        results.result_ID AS result_ID
        FROM results
        LEFT JOIN (SELECT
                    ROW_NUMBER() OVER (ORDER BY doc_ID,
                                            pat_ID,
                                            test_ID,
                                            dates) AS row_num,
                    doc_ID,
                    pat_ID,
                    test_ID,
                    dates
                FROM performs_test ORDER BY doc_ID,
                                            pat_ID,
                                            test_ID,
                                            dates
                ) AS t  ON t.row_num = results.result_ID
LIMIT 4656);