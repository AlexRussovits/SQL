USE Sample_AR;

SELECT t1.dept_no, t1.dept_name, t1.location FROM Department t1 JOIN Department t2 ON t1.location = t2.location WHERE t1.dept_no <> t2.dept_no;

-- 8.1 Aleksander Russovitš

SELECT  Works_On.* , Project.* FROM Works_On INNER JOIN Project ON Works_On.project_no = Project.project_no -- 8.1 (a)

SELECT  Works_On.* , Project.* FROM Works_On, Project WHERE Works_On.project_no = Project.project_no  -- 8.1 (b)


-- Теоретически количество таблиц, которые можно соединить в инструкции SELECT, неограниченно. (Но одно условие соединения совмещает только две таблицы!) -- 8.2


SELECT emp_no, job FROM Works_On JOIN Project ON Works_On.project_no = Project.project_no WHERE project_name = 'Gemini'; -- 8.3

SELECT emp_fname, emp_lname FROM Department JOIN Employee ON Department.dept_no = Employee.dept_no WHERE dept_name = 'Research' OR dept_name = 'Accounting' -- 8.4


SELECT enter_data FROM Works_On JOIN Employee ON Works_On.emp_no = Employee.emp_no WHERE job = 'Clerk'; -- 8.5

SELECT * FROM Project WHERE project_no IN (SELECT project_no FROM Works_On WHERE job = 'Clerk' GROUP BY project_no HAVING COUNT(job) >= 2); -- 8.6

SELECT emp_fname, emp_lname FROM Employee JOIN Works_On ON Employee.emp_no = Works_On.emp_no JOIN Project ON Works_On.project_no = Project.project_no WHERE job = 'Manager' AND project_name = 'Mercury'; --8.7

SELECT emp_fname, emp_lname FROM Employee JOIN Works_On ON Employee.emp_no = Works_On.emp_no JOIN Project ON Works_On.project_no = Project.project_no WHERE enter_data = ();
