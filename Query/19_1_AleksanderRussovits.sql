USE Sample_AR;

SELECT * FROM Department
SELECT * FROM Works_On
SELECT * FROM Employee
SELECT * FROM Project

SELECT project_no, COUNT(*) FROM Works_On
GROUP BY project_no

SELECT Employee.emp_no,emp_fname,emp_lname FROM Employee
INNER JOIN Works_On ON Employee.emp_no = Works_On.emp_no

-- IF и декларирование переменных

GO
DECLARE @var1 CHAR(3), @count_emp INT
SET @var1 = 'p1'

IF (SELECT COUNT(project_no)
FROM Works_On
WHERE project_no = @var1
GROUP BY project_no) > 3
BEGIN
PRINT 'The number of employees in the project ' + @var1+'is 4 or more'
SELECT @count_emp = COUNT(project_no)
FROM Works_On WHERE project_no = @var1
PRINT 'Count Employees = ' + CAST(@count_emp AS CHAR(4))
END
ELSE
	BEGIN
		PRINT 'The following employees work for the project ' + @var1
		SELECT Employee.emp_no,emp_fname,emp_lname FROM Employee
		INNER JOIN Works_On ON Employee.emp_no = Works_On.emp_no
		WHERE project_no = @var1
	END
GO


-- WHILE 

GO
DECLARE @bdg1 MONEY, @bdg2 MONEY
SET @bdg1 = 500000
SET @bdg1 = 240000

WHILE (SELECT SUM(budget)
	FROM Project) < @bdg1
	BEGIN
		UPDATE Project SET budget = budget*1.1
		IF (SELECT MAX(budget)
			FROM Project) > @bdg2
			BREAK
		ELSE CONTINUE
	END
GO


GO
DECLARE @ErrorVar INT
UPDATE Employee
	SET dept_no = 'd6'
	WHERE emp_no = 2581
SET @ErrorVar = @@ERROR
IF @@ERROR <> 0
	BEGIN
		PRINT 'Error = ' + CAST(@@ERROR AS NVARCHAR(8));
		PRINT 'Нарушение целостности данных.'
	END
GO
---------=========================================================================

--Задание 19.1
--Aleksander Russovits

CREATE TABLE Employee_30(
emp_no INT PRIMARY KEY NOT NULL, emp_fname NCHAR(15) NOT NULL,
emp_lname NCHAR(15) NOT NULL, dept_no NCHAR(10) NULL,
salary MONEY NULL);

DROP TABLE Employee_30

GO
DECLARE @emp_no INT,
@dept_no NCHAR(10),@emp_lname NCHAR(15),
@emp_fname NCHAR(15), @salary MONEY; 

SET @emp_no = 1;
SET @dept_no = '25721'; 
SET @emp_fname = 'Aleksei'; 
SET @emp_lname = 'Barabanov';
SET @salary = 9000;

WHILE(@emp_no < 30)
	BEGIN
		INSERT INTO Employee_30 VALUES (@emp_no, @dept_no,@emp_fname,@emp_lname,@salary)
		SET @emp_no = @emp_no + 1
	END
GO
