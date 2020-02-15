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
GO
ALTER VIEW Department1
AS SELECT * FROM Employee WHERE dept_no =  'd1' OR dept_no = 'd2'
GO

SELECT * FROM Department1
SELECT * FROM Employee
-- 8
GO
DROP VIEW Employees2
GO
-- В 4 задании также удалится представление, потому что это представление было основано на Employees2

--9

SELECT * FROM Project
SELECT * FROM Project_View

GO
INSERT INTO Project_View VALUES ('p2', 'Raketa')
GO

GO
INSERT INTO Project_View VALUES ('p7', 'Raketa')
GO

--10

GO
CREATE VIEW Employees4
AS SELECT * FROM Employee WHERE emp_no <= 10000
WITH CHECK OPTION;
GO

SELECT * FROM Employees4
INSERT INTO Employees4 VALUES (22123,'Arvo', 'Kont', 'd3', 2500);

--11
GO
CREATE VIEW Employees5
AS SELECT * FROM Employee WHERE emp_no <= 10000
GO

INSERT INTO Employees5 VALUES (22123,'Arvo', 'Kont', 'd3', 2500);

-- В 10 идёт проверка чтобы табельный номер был меньше или равно 10000, WITH CHECK OPTION проверяет значение 22123 и выводит ошибку, а в 11 нет.

--12
GO
CREATE VIEW DataEmpCheck
AS SELECT * FROM Works_On WHERE YEAR(enter_data) BETWEEN 2007 AND 2008
WITH CHECK OPTION;
GO

UPDATE DataEmpCheck
SET enter_data = '06.01.2006' WHERE emp_no = 29346

SELECT * FROM DataEmpCheck
SELECT * FROM Works_On
DROP VIEW DataEmpCheck

--13
GO
CREATE VIEW DataEmpCheck2
AS SELECT * FROM Works_On WHERE YEAR(enter_data) BETWEEN 2007 AND 2008
GO

UPDATE DataEmpCheck2
SET enter_data = '06.01.2006' WHERE emp_no = 29346

SELECT * FROM DataEmpCheck2

-- В 12 произошла ошибка, а в 13 в представление при изменении даты сотрудник с 29346 пропадает, так как по условию должно быть между 2007 и 2008 годом