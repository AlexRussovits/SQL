-- Эта функция вычисляет возникающие дополнительные 
--общие затраты, при увеличении бюджетов проектов
USE Sample_AR;
GO
CREATE FUNCTION compute_costs(@percent INT = 10)
RETURNS DECIMAL(16,2)
 BEGIN
	DECLARE @additional_costs DEC(14,2),
			@sum_budget DEC(16,2)
	SELECT @sum_budget = SUM(budget)
		FROM Project
	SET @additional_costs = @sum_budget*@percent/100
	RETURN @additional_costs
	END
GO
SELECT project_no, project_name
 FROM Project
 WHERE budget < dbo.compute_costs(25)
 ------------------------------------
 -- Создание возвращающей табличное значение функции
 GO
 CREATE FUNCTION employees_in_project (@pr_number CHAR(4))
	RETURNS TABLE
	AS RETURN (SELECT emp_fname, emp_lname
	FROM Works_On, Employee
	WHERE Employee.emp_no = Works_On.emp_no
	AND project_no = @pr_number)
GO

SELECT  * FROM employees_in_project('p3')
--------------------------------------------------------

--Multistatement

GO
CREATE FUNCTION get_flname()
RETURNS @ret TABLE (id_peoples INT PRIMARY KEY,
flname VARCHAR(50))
AS
	BEGIN
		INSERT INTO @ret
		SELECT emp_no, emp_fname+' '+emp_lname
		FROM Employee
		RETURN
	END
GO
-----------------------------------------------------

-- SCHEMABINDING
GO
CREATE FUNCTION get_flname2(@Fam VARCHAR(20))
RETURNS TABLE
WITH SCHEMABINDING
AS
	RETURN
		(
		SELECT emp_no, emp_fname+' '+emp_lname AS flname
		FROM dbo.Employee
		WHERE emp_fname = @Fam
		)
GO

SELECT * FROM get_flname2 ('Julia')
SELECT * FROM get_flname2 ('Alexander')
-------------------------------
-- Применение APPLY
GO
CREATE FUNCTION dbo.fn_getjob (@empid AS INT)
RETURNS TABLE AS
RETURN
	SELECT job
	FROM Works_On
	WHERE emp_no = @empid
	AND job IS NOT NULL AND project_no = 'p1'
GO

--"Соединение" двух таблиц
--посредством предложения APPLY

-- используется CROSS APPLY
SELECT E.emp_no, emp_fname, emp_lname, job
FROM Employee AS E
CROSS APPLY dbo.fn_getjob(E.emp_no) AS A

-- используется OUTER APPLY
SELECT E.emp_no, emp_fname,  emp_lname, job
FROM Employee AS E
OUTER APPLY dbo.fn_getjob(E.emp_no) AS A
----------------------------------------------

--Возвращающие табличное значение
--параметры (1)

-- Использование возвращающего табличное значение параметра
-- в примере
GO
CREATE TYPE departmentType AS TABLE (dept_no CHAR(4),
dept_name CHAR(25), location CHAR(30));
GO


CREATE TABLE #dallasTable -- временная таблица
(dept_no CHAR(4), dept_name CHAR(25), location CHAR(30));

GO
CREATE PROC insertProc
@Dallas departmentType READONLY 
AS SET NOCOUNT ON
INSERT INTO #dallasTable (dept_no, dept_name, location)
SELECT * FROM @Dallas

GO
DECLARE @Dallas AS departmentType;
	INSERT INTO @Dallas (dept_no, dept_name, location)
	SELECT * FROM Department
	WHERE location = 'Dallas'
EXEC insertProc @Dallas;
GO

SELECT * FROM #dallasTable
