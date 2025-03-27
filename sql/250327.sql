use ys;
CREATE TABLE employee_profile(
                                 id int,
                                 device_id int,
                                 gender varchar(255),
                                 age int,
                                 department varchar(255),
                                 score int,
                                 active_days_within int
);

CREATE TABLE question_practice_detail(
                                         id int,
                                         device_id int,
                                         question_id int,
                                         result varchar(255),
                                         stat_date VARCHAR(255)
)

    INSERT INTO employee_profile (id, device_id, gender, age, department, score, active_days_within)
VALUES
(1, 2138,'male', 21, '销售部', 87, 7),
(2, 3214,'male', 20, '采购部', 90, 15),
(3, 6543, 'female', 23, '销售部', 91, 12),
(4, 2315, 'female', 20, '产品部', 76, 5),
(5, 5432,'male', 25, '运营部', 88, 20),
(6, 2131,'male', 28, '运营部', 95, 15),
(7, 4321, 'female', 26, '采购部', 92, 9),
(8, 3456,'male', 22, '销售部', 85, 8),
(9, 6789, 'female', 24, '产品部', 80, 10),
(10, 5678,'male', 27, '运营部', 93, 18),
(11, 4567, 'female', 23, '采购部', 89, 13),
(12, 7890,'male', 29, '销售部', 94, 16),
(13, 2345, 'female', 21, '产品部', 78, 6),
(14, 8901,'male', 26, '运营部', 86, 14),
(15, 3457, 'female', 25, '采购部', 90, 11),
(16, 6781,'male', 24, '销售部', 83, 9),
(17, 4561, 'female', 22, '产品部', 82, 10),
(18, 7892,'male', 28, '运营部', 91, 17),
(19, 5671, 'female', 27, '采购部', 88, 12),
(20, 9012,'male', 23, '销售部', 84, 8);

INSERT INTO question_practice_detail (id, device_id, question_id, result, stat_date)
VALUES
    (1, 2138, 111, 'wrong', '2023-5-3'),
    (2, 3214, 112, 'wrong', '2023-5-9'),
    (3, 3214, 113, 'wrong', '2023-6-15'),
    (4, 6543, 111, 'right', '2023-8-13'),
    (5, 2315, 115, 'right', '2023-8-13'),
    (6, 2315, 116, 'right', '2023-8-14'),
    (7, 2315, 117, 'wrong', '2023-8-15'),
    (8, 4321, 117, 'right', '2023-8-16'),
    (9, 2138, 118, 'right', '2023-9-2'),
    (10, 3214, 119, 'wrong', '2023-9-10'),
    (11, 6543, 120, 'right', '2023-10-5'),
    (12, 2315, 121, 'right', '2023-10-12'),
    (13, 4321, 122, 'wrong', '2023-10-18'),
    (14, 2138, 123, 'right', '2023-11-3'),
    (15, 3214, 124, 'wrong', '2023-11-11'),
    (16, 6543, 125, 'right', '2023-12-7'),
    (17, 2315, 126, 'right', '2023-12-14'),
    (18, 4321, 127, 'wrong', '2023-12-20'),
    (19, 2138, 128, 'right', '2024-1-5'),
    (20, 3214, 129, 'wrong', '2024-1-12');

SELECT a.device_id,
       sum(if(MONTH(stat_date)=8,1,0)),
       sum(if(result='right',1,0))
FROM employee_profile a LEFT JOIN question_practice_detail b on b.device_id=a.device_id
WHERE department='采购部' GROUP BY a.device_id



















