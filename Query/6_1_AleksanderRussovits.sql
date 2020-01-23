USE Sample_AR;

SELECT * FROM Works_On

SELECT job
FROM Works_On
GROUP BY job

SELECT project_no,job
FROM Works_On
GROUP BY project_no,job

SELECT MAX(emp_no) AS Max_empno
FROM Employee


SELECT *
FROM Employee
WHERE emp_no = 
	(SELECT MAX(emp_no)
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


SELECT COUNT(*) all_row, COUNT(job), COUNT(*)- COUNT(job) AS null_count
 FROM Works_On

 SELECT project_no, COUNT(*)
	FROM Works_On
	GROUP BY project_no
	HAVING COUNT(*) < 4;

SELECT emp_fname, emp_lname, dept_no
 FROM Employee
 WHERE emp_no < 20000
 ORDER BY emp_lname, emp_fname;
 --================================================================================================
 -- ALEKSANDER RUSSOVITS 
 -- JPTVR18  Zadanie 6.1

 SELECT location, COUNT(location) AS Quantity_Filials
 FROM Department
 GROUP BY location -- 6.11

 -- ������� ����� ����������� DISTINCT � GROUP BY, � ��� ��� GROUP BY ���������� ��������� ����� ��� ��������� ������ ������� ����� �� ��������� ��������, 
 --� DISTINCT ��������� ������, ������� �������� ������������� �������� � ��������� ����� 6.12

 -- ��� GROUP BY ��� �������� NULL ���������� ��� ������, �� ���� ��� ����������� �� ����, ����������� NULL-��������, ��� ����� ������ ������� � ���� ������. 6.13

 -- ������� ����� ����������� ��������� COUNT(*) � COUNT(column) � ���, ��� COUNT(column) ����� ������������ ���������� �������� � ������� col_name, � COUNT(*) ������������ ��. 6.14


 SELECT *
 FROM Employee
 WHERE emp_no = 
 (SELECT MAX(emp_no)
	 FROM Employee); -- 6.15

SELECT dept_no, COUNT(dept_no) as dept_count 
FROM Employee
GROUP BY dept_no -- 6.16(a)

SELECT project_no, COUNT(project_no) as project_count
FROM Works_On
GROUP BY project_no -- 6.16(b)

SELECT emp_no, COUNT(*) AS Project_Working
FROM Works_On
GROUP BY emp_no -- 6.16(c)


 SELECT job, COUNT(*) AS Count_job
	FROM Works_On
	GROUP BY job
	HAVING COUNT(*) >= 2; --6.17






