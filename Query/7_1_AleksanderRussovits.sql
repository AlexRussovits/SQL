USE Sample_AR;

SELECT emp_fname, emp_lname FROM Employee WHERE dept_no = (SELECT dept_no FROM Department WHERE dept_name = 'Research'); -- ѕодзапросы и операторы сравнени€

SELECT * FROM Employee WHERE dept_no IN (SELECT dept_no FROM Department WHERE location = 'Dallas'); -- ќператор IN работает со списком

SELECT emp_lname FROM Employee WHERE emp_no IN (SELECT emp_no FROM Works_On WHERE project_no IN (SELECT project_no FROM Project WHERE project_name = 'Apollo')); -- ¬ыборка фамилий всех сотрудников, работающих над проектом Apollo


SELECT emp_no, project_no, job FROM Works_On WHERE enter_data > ANY (SELECT enter_data FROM Works_On); -- ¬ыборка табельного номера сотрудника, номера проекта и названи€ должности дл€ сотрудников, которые приступили к работе над проектами позже мин. даты любого из проектов


SELECT emp_lname FROM Employee WHERE 'p3' IN (SELECT project_no FROM Works_On WHERE Works_On.emp_no = Employee.emp_no); -- ¬ыборка фамилий всех сотрудников, работающих над проектом p3

SELECT emp_lname FROM Employee WHERE EXISTS (SELECT * FROM Works_On WHERE Employee.emp_no = Works_On.emp_no AND project_no = 'p1'); -- ¬ыборка фамилий всех сотрудников, работающих над проектом p1

SELECT emp_lname FROM Employee WHERE NOT EXISTS (SELECT * FROM Department WHERE Employee.dept_no = Department.dept_no AND location = 'Seattle'); -- ¬ыборка фамилий сотрудников, чей отдел не расположен в —иэтле


-- 6.18 - 6.23 SUBQUERY

--Aleksander Russovits

SELECT * FROM Department WHERE dept_no = (SELECT TOP(1) dept_no FROM Employee GROUP BY(dept_no) ORDER BY COUNT(dept_no) DESC); --6.18 (a)

SELECT * FROM Department WHERE dept_no = (SELECT TOP(1) dept_no FROM Employee GROUP BY(dept_no) ORDER BY COUNT(dept_no)); --6.18 (b)

SELECT location FROM Department WHERE dept_no = (SELECT TOP(1) dept_no FROM Employee GROUP BY(dept_no) ORDER BY COUNT(dept_no)); --6.19

SELECT * FROM Employee WHERE dept_no IN (SELECT dept_no FROM Department WHERE location = 'Seattle' OR location = 'Dallas'); -- 6.20

SELECT emp_fname,emp_lname FROM Employee WHERE emp_no = (SELECT emp_no FROM Works_On WHERE enter_data = '2007-01-04'); --6.21(a)

SELECT emp_fname,emp_lname FROM Employee WHERE emp_no IN (SELECT emp_no FROM Works_On WHERE enter_data LIKE '2008-01%' OR enter_data LIKE '2008-02%'); --6.21(b)

SELECT * FROM Employee WHERE emp_no IN (SELECT emp_no FROM Works_On WHERE job = 'Clerk' OR dept_no = 'd3'); --6.22

SELECT project_name FROM Project WHERE project_no IN (SELECT project_no FROM Works_On WHERE job = 'Clerk') -- 6.23 ¬место = нужно IN

-- ѕотому что IN может возвращать больше 1 значени€


SELECT * FROM Employee


-- сколько сотрудников в каждом отделе

SELECT TOP(1) dept_no, COUNT(dept_no) AS Kolichestvo_Sotrudnikov FROM Employee GROUP BY dept_no ORDER BY COUNT(dept_no) DESC

SELECT * FROM Department WHERE dept_no IN
(SELECT dept_no FROM Employee GROUP BY dept_no HAVING COUNT(dept_no) = 
(SELECT TOP(1) COUNT(dept_no) AS Kolichestvo_Sotrudnikov FROM Employee GROUP BY dept_no ORDER BY COUNT(dept_no) DESC))  -- 6.18(a) remake
 
SELECT * FROM Department WHERE dept_no IN
(SELECT dept_no FROM Employee GROUP BY dept_no HAVING COUNT(dept_no) = 
(SELECT TOP(1) COUNT(dept_no) AS Kolichestvo_Sotrudnikov FROM Employee GROUP BY dept_no ORDER BY COUNT(dept_no))) -- 6.18(b) remake



---------------------------------------------------------------------------------==========================================================

SELECT Employee.*, Department.* FROM Employee INNER JOIN Department ON Department.dept_no = Employee.dept_no

SELECT Employee.*, Department.* FROM Employee, Department WHERE Department.dept_no = Employee.dept_no

SELECT *  FROM Employee LEFT JOIN Works_On ON Employee.emp_no = Works_On.emp_no

SELECT *  FROM Works_On RIGHT JOIN Project ON Works_On.project_no = Project.project_no
                                  