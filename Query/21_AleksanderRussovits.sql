USE Sample_AR;

--Aleksander Russovitš
-- 20.1

--1
GO
CREATE VIEW Department1
AS SELECT * FROM Employee WHERE dept_no = 'd1'
GO

SELECT * FROM Department1
DROP VIEW Department1

--2

SELECT * FROM Project

GO
CREATE VIEW Project_View
AS SELECT project_no, project_name  FROM Project
GO

SELECT * FROM Project_View


--3

SELECT * FROM Works_On
SELECT * FROM Employee

GO
CREATE VIEW Employees2
AS SELECT emp_fname, emp_lname FROM Employee INNER JOIN Works_On ON Employee.emp_no = Works_On.emp_no WHERE YEAR(Works_On.enter_data) >= '2007' AND MONTH(Works_On.enter_data) >= 6  
GO

SELECT * FROM Employees2
DROP VIEW Employees2

--4

GO
CREATE VIEW Employees3(first,last)
AS SELECT emp_fname,emp_lname FROM Employees2
GROUP BY emp_fname,emp_lname
GO

SELECT * FROM Employees3
DROP VIEW Employees3

--5
GO
CREATE VIEW EmployeeM
AS SELECT * FROM Department1 WHERE emp_lname LIKE 'M%' 
GO

SELECT * FROM EmployeeM

--6
GO
CREATE VIEW DataSmith
AS SELECT * FROM Project WHERE project_no IN (SELECT project_no FROM Works_On WHERE emp_no IN(SELECT emp_no FROM Employee WHERE emp_lname = 'Smith'))
GO

SELECT * FROM DataSmith

--7



