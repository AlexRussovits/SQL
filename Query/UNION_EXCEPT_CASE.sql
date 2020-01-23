USE Sample_AR;

SELECT domicile FROM Emplyee_Enh UNION SELECT location FROM Department;

SELECT emp_no FROM Employee WHERE dept_no = 'd1' INTERSECT SELECT emp_no FROM Works_On WHERE enter_data < '01.01.2008';

SELECT emp_no FROM Employee WHERE dept_no = 'd1' EXCEPT SELECT emp_no FROM Works_On WHERE enter_data < '01.01.2008';

SELECT project_name,
CASE
	WHEN budget > 0 AND budget < 100000 THEN 1
	WHEN budget >= 100000 AND budget < 200000 THEN 2
	WHEN budget >= 200000 AND budget < 300000 THEN 3
	ELSE 4
	END budget_weight
	FROM project

SELECT emp_no, emp_lname, salary,
	CASE 
		WHEN salary >= 3000 THEN 'palk >= 3000'
		WHEN salary >= 2000 THEN '2000 <= palk < 3000'
		ELSE 'palk < 2000'
	END salaryTypeWithELSE,

	CASE 
		WHEN salary >= 3000 THEN 'palk >= 3000'
		WHEN salary >= 2000 THEN '2000 <= palk < 3000'
	END salaryTypeWithoutELSE
FROM Employee

SELECT project_name,
	CASE
		WHEN p1.budget < (SELECT AVG(p2.budget) FROM Project p2)
			THEN 'below.average'
		WHEN p1.budget = (SELECT AVG(p2.budget) FROM Project p2)
			THEN 'on average'
		WHEN p1.budget > (SELECT AVG(p2.budget) FROM Project p2)
			THEN 'above average'
	END budget_category
FROM Project p1;

SELECT emp_fname,emp_lname, salary, 
	CASE 
		WHEN e1.salary < (SELECT AVG(e2.salary) FROM Employee e2)
			THEN 'below average'
		WHEN e1.salary = (SELECT AVG(e2.salary) FROM Employee e2)
			THEN 'on average'
		WHEN e1.salary > (SELECT AVG(e2.salary) FROM Employee e2)
			THEN 'above average'
	END salary_category
FROM Employee e1;

SELECT emp_no, emp_lname, salary,dept_no,
	
	CASE dept_no
		WHEN 'd1' THEN '10%'
		WHEN 'd2' THEN '15%'
		WHEN 'd3' THEN '20%'
		WHEN 'd4' THEN '25%'
		ELSE '18%'
	END NewYearBonusPercent
FROM Employee

SELECT emp_no, emp_lname, salary,dept_no,
	CASE dept_no
		WHEN 'd1' THEN '10%'
		WHEN 'd2' THEN '15%'
		WHEN 'd3' THEN '20%'
		WHEN 'd4' THEN '25%'
		ELSE '18%'
	END NewYearBonusPercent,
	salary/100*
	CASE dept_no
		WHEN 'd1' THEN 10
		WHEN 'd2' THEN 15
		WHEN 'd3' THEN 20
		WHEN 'd4' THEN 25
		ELSE 18
	END BonusAmount
FROM Employee;



SELECT emp_no, emp_lname, salary,

	CASE
		WHEN salary>= 2500 THEN ' >= 2500' ELSE ' < 2500'
	END DemoCASE
FROM Employee
---================================================================================
USE Student_AR;

SELECT * FROM Student

SELECT Isikukood, 
SUBSTRING(Isikukood,2,2) AS Aasta, 
SUBSTRING(Isikukood,4,2) AS Kuu,
SUBSTRING(Isikukood,6,2) AS Päev,
	CASE
		WHEN LEFT(Isikukood,1) = '3' OR LEFT(Isikukood,1) = '5' THEN 'Male' 
		WHEN LEFT(Isikukood,1) = '4' OR LEFT(Isikukood,1) = '6' THEN 'Female'
	ELSE 'Error'
	END Gender,
	CASE
		WHEN LEFT(Isikukood,1) = '3' OR LEFT(Isikukood,1) = '4' THEN DATEFROMPARTS('19' + SUBSTRING(Isikukood,2,2),SUBSTRING(Isikukood,4,2),SUBSTRING(Isikukood,6,2))
		WHEN LEFT(Isikukood,1) = '5' OR LEFT(Isikukood,1) = '6' THEN DATEFROMPARTS('20' + SUBSTRING(Isikukood,2,2),SUBSTRING(Isikukood,4,2),SUBSTRING(Isikukood,6,2))		
	ELSE 'Error'
	END DateofBirth,
	CASE
		WHEN LEFT(Isikukood,1) = '3' OR LEFT(Isikukood,1) = '4' THEN YEAR(GETDATE()) - YEAR(DATEFROMPARTS('19' + SUBSTRING(Isikukood,2,2),SUBSTRING(Isikukood,4,2),SUBSTRING(Isikukood,6,2)))
		WHEN LEFT(Isikukood,1) = '5' OR LEFT(Isikukood,1) = '6' THEN YEAR(GETDATE()) - YEAR(DATEFROMPARTS('20' + SUBSTRING(Isikukood,2,2),SUBSTRING(Isikukood,4,2),SUBSTRING(Isikukood,6,2)))		
	ELSE 'Error'
	END Age
FROM Student;





