# Generate 100000 results records
INSERT INTO results
(SELECT
       NULL as result_ID,
        (SELECT * FROM (VALUES
            ('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut consectetur cursus enim, nec tristique tellus interdum at. Ut ornare tellus tellus, quis ultricies felis convallis ac. '),
            (' Fusce dictum felis sit amet sollicitudin lobortis.'),
            ('Fusce sollicitudin dui purus, in viverra est euismod eget.'),
            ('In suscipit dapibus neque, et consequat quam scelerisque id.'),
            ('Curabitur vitae viverra tellus, eu volutpat lorem. Suspendisse congue in nibh sed posuere.'),
            ('Mauris egestas magna ante, sed pharetra magna vestibulum lobortis.'),
            ('Ut orci risus, semper feugiat tincidunt vel, ullamcorper et quam.'),
            ('Aliquam erat volutpat. Maecenas mollis molestie lacus, vel vulputate arcu dapibus et. Etiam felis purus, mollis a ante eu, eleifend condimentum urna. In in eros metus.'),
            ('Integer laoreet mauris rhoncus urna laoreet lacinia. Praesent et elementum augue.'),
            (' Morbi non urna at tortor pharetra accumsan. Praesent fermentum tristique tellus vitae suscipit.'),
            ('Praesent tempus tempor tristique. Nulla turpis elit, dictum blandit sapien elementum, tincidunt auctor mi.')) AS x ORDER BY RAND() LIMIT 1) AS test_result,
        (SELECT * FROM (VALUES ('2020-05-16'),('2020-05-17'),('2020-05-18'),('2020-05-19'),('2020-05-20'),('2020-05-21'),('2020-05-22'),('2020-05-23'),('2020-05-24'),('2020-05-25'),('2020-05-26')) AS x ORDER BY RAND() LIMIT 1) AS result_date
FROM tests
ORDER BY RAND()
LIMIT 1552);