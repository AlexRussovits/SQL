-- 25/09/2019
USE Sample_AR;
SELECT * FROM Department -- отбирается информация из таблицы Department
SELECT * FROM Employee -- отбирается информация из таблицы Employee
SELECT * FROM Works_On -- отбирается информация из таблицы Works_On
SELECT * FROM Project -- отбирается информация из таблицы Project


SELECT dept_no, dept_name
FROM Department -- отбирается информация из колонки dept_no и dept_name из таблицы

-- SELECT DISTINCT location

SELECT location FROM Department -- отбирается локация

SELECT dept_name, dept_no
FROM Department
WHERE location = 'Dallas';

SELECT emp_lname, emp_fname
FROM Employee
WHERE emp_no >=15000;

SELECT *
	FROM WORKS_On
	WHERE enter_data > '2008-07-15'
	--WHERE enter_data > '2006/11/10'
	--WHERE enter_data > '2007.06.12'
	--WHERE enter_data > '17/10/2007'

SELECT * , LEFT(project_no,1) AS symbol
FROM Project

SELECT emp_no, emp_fname, emp_lname
FROM Employee
WHERE emp_no = 25348 AND emp_lname = 'Smith'
OR emp_fname = 'Matthew' AND dept_no = 'd1';


SELECT emp_no, emp_fname, emp_lname
FROM Employee
WHERE ((emp_no = 25348 AND emp_lname = 'Smith')
OR emp_fname = 'Matthew') AND dept_no = 'd1';


SELECT emp_no, emp_lname
FROM Employee
WHERE NOT dept_no = 'd2';

SELECT *
FROM Employee
WHERE emp_no IN (29346, 28559, 25348);

SELECT emp_no, emp_fname, emp_lname, dept_no
FROM Employee
WHERE emp_no NOT IN (10102, 9031);

SELECT project_name, budget
FROM Project
WHERE budget BETWEEN 95000 AND 12000;

SELECT project_name, budget
FROM Project
WHERE budget >= 95000 AND budget <= 120000;

SELECT emp_no, project_no

FROM Works_On

WHERE project_no = 'p2'
AND job IS NULL;

SELECT project_no, job
FROM Works_On
WHERE job <> NULL; -- не работает

SELECT project_no, job
FROM Works_On
WHERE job IS NOT NULL;


SELECT emp_no, ISNULL(job,'Job unknown') AS task
FROM Works_On
WHERE project_no = 'p1';

SELECT emp_no, project_no, job,
ISNULL(job,'Job unknown') AS task
FROM Works_On;



SELECT emp_fname, emp_lname, emp_no
FROM Employee
WHERE emp_lname LIKE 'j%';

SELECT emp_fname, emp_lname, emp_no
FROM Employee
WHERE emp_fname LIKE '_a%';

SELECT *
FROM Department
WHERE location LIKE '[C-F%]';

SELECT emp_no, emp_fname, emp_lname
FROM Employee
WHERE emp_lname LIKE '[^J-O]%'
AND emp_fname LIKE '[^EZ]%';

SELECT GETDATE() -- текущая дата

SELECT *, YEAR(enter_data) AS God
FROM Works_On
WHERE YEAR(enter_data) = 2006;

--===============================================================================

--ПРАКТИКА
-- Александер Русович JPTVR18

SELECT * FROM Works_On -- 5.1

SELECT *
FROM Works_On
WHERE job = 'Clerk'; -- 5.2

SELECT *
FROM Works_On
WHERE emp_no < 10000 AND project_no = 'p2'; -- 5.3

SELECT emp_no, YEAR(enter_data) AS Aastat FROM Works_On WHERE YEAR(enter_data) = 2007

SELECT emp_no, YEAR(enter_data) AS Aastat FROM Works_On WHERE YEAR(enter_data) BETWEEN 2007 AND 2019 -- 5.4

SELECT * 
FROM Works_On
WHERE project_no = 'p1' AND job = 'Analyst' OR job = 'Manager'; --5.5

SELECT *
FROM Works_On

WHERE  project_no = 'p2' AND job IS NULL; -- 5.6

SELECT emp_fname, emp_lname, emp_no
FROM Employee
WHERE emp_fname LIKE '%tt%'; -- 5.7

SELECT emp_fname, emp_lname, emp_no
FROM Employee
WHERE emp_lname LIKE '_o%' OR emp_lname LIKE '%a%' AND emp_lname LIKE '%es'; -- 5.8

SELECT *
FROM Project
WHERE budget > 100000 AND budget < 300000;


SELECT *
FROM Project
WHERE budget BETWEEN 100000 AND 300000;

SELECT *
FROM Employee
WHERE emp_fname NOT LIKE '%[y]%' AND emp_fname NOT LIKE '[x]' AND emp_lname NOT LIKE '%[y]%' AND emp_lname NOT LIKE '%[x]%';








