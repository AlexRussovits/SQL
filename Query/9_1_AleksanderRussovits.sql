-- PTVR18
-- Aleksander RUssovits 27.11.2019

USE Sample_AR;

SELECT * FROM Employee

INSERT INTO Employee(emp_no,emp_fname,emp_lname,dept_no) VALUES(11111,'Julia','Long', NULL); -- 9.1


CREATE TABLE emp_d1_d2 (emp_no INT NOT NULL, emp_fname NCHAR(50) NOT NULL, emp_lname NCHAR(50) NOT NULL,dept_no NCHAR(10) NULL, salary MONEY NULL);

INSERT INTO emp_d1_d2 (emp_no,emp_fname,emp_lname,dept_no,salary) SELECT * FROM Employee WHERE dept_no = 'd1' OR dept_no = 'd2'; -- 9.2 (1)

/*SELECT * FROM emp_d1_d2*/

SELECT  emp_no, emp_fname, emp_lname, dept_no, salary INTO Emp_d2_d1 FROM Employee WHERE dept_no = 'd1' OR dept_no = 'd2'; -- 9.2(2)

CREATE TABLE Works_On2 (emp_no INT NOT NULL, project_no NCHAR(10) NULL, job NCHAR(40) NULL, enter_data DATE NULL);

INSERT INTO Works_On2 (emp_no,project_no,job,enter_data) SELECT * FROM Works_On WHERE enter_data LIKE '2008%' --9.3

/*SELECT * FROM Works_On

SELECT * FROM Works_On2*/
 
UPDATE Works_On SET job = 'Clerk' WHERE job = 'Manager' AND project_no = 'p1'; -- 9.4

/*SELECT * FROM Project*/

UPDATE Project SET budget = NULL WHERE project_no = 'p1' OR project_no = 'p3'; -- 9.5

SELECT * FROM Works_On

UPDATE Works_On SET job = 'Manager' WHERE emp_no = 28559; -- 9.6

UPDATE Project SET budget = budget+(budget/10) WHERE project_no IN (SELECT project_no FROM Works_On WHERE emp_no = 10102 AND job = 'Manager'); -- 9.7
/*
SELECT * FROM Department

SELECT * FROM Employee
*/

UPDATE Department SET dept_name = 'Sales' WHERE dept_no IN (SELECT dept_no FROM Employee WHERE emp_lname = 'Bardolph'); -- 9.8

--9.9
UPDATE enter_data



--9.10

DELETE FROM Department WHERE location = 'Seattle';

--9.11

DELETE FROM Project WHERE project_no = 'p3';

-- 9.12

DELETE Works_On FROM Works_On, Employee,Department WHERE Works_On.emp_no = Employee.emp_no




 