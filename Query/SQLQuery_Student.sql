--18--10-2019
USE Student_AR;
SELECT * 
FROM Student

SELECT *, LEFT(Isikukood,1) AS Gender, SUBSTRING(Isikukood,4,2) AS Kuu, SUBSTRING(Isikukood,6,2) AS Päev, SUBSTRING (Isikukood,2,2) AS Aasta
FROM Student

----------------------------------------------------------=======================================================================

USE Sample_AR;

SELECT project_no,job
FROM Works_On
GROUP BY project_no,job;


SELECT MAX(emp_no) AS max_employee_no 
FROM Employee


SELECT emp_no, emp_lname
	FROM Employee
	WHERE emp_no = 
	(SELECT MIN(emp_no)
		 FROM Employee);

SELECT *
FROM Employee
WHERE emp_no =
	(SELECT emp_no
	FROM Works_On
	WHERE enter_data =
	 (SELECT MAX(enter_data)
		FROM Works_On
		WHERE job = 'Manager'));

SELECT project_no, COUNT(DISTINCT job) job_count
	FROM Works_On
	GROUP BY project_no;

SELECT project_no, COUNT(job) job_count
	FROM Works_On
	GROUP BY project_no;

SELECT job, COUNT(*) job_count
	FROM Works_On
	GROUP BY job;

SELECT COUNT(*), COUNT(job) AS job_ON, -- Количество заполненных и незаполненных колонок
		COUNT(*)- COUNT(job) AS job_Null
FROM Works_On


SELECT project_no, COUNT(project_no)
	FROM Works_On
	GROUP BY project_no
	HAVING COUNT(*) < 4;