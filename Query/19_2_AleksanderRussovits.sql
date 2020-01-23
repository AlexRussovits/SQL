USE Sample_AR;

SELECT * FROM Project
SELECT AVG(budget) FROM Project

GO
DECLARE @avg_budget MONEY, @extra_budget MONEY, @project CHAR(3)
	SET @extra_budget = 15000
	SET @project = 'p1'
	SELECT @avg_budget = AVG(budget) FROM Project
	IF (SELECT budget
		FROM Project
		WHERE project_no = @project) < @avg_budget
	 BEGIN
		UPDATE Project
			SET budget = budget + @extra_budget
			WHERE project_no = @project
		PRINT 'Budget for '+@project +'increased by @extra_budget'
	END
	ELSE
		PRINT 'Budget for '+@project +'unchanged'
GO

-- Рассчитаем баланс счёта через несколько лет с учётом процентной ставки:
CREATE TABLE #Accounts (CreateDate DATE, Balance MONEY)

SELECT * FROM #Accounts

GO
DECLARE @rate FLOAT = 0.065, @period INT = 5, @sum MONEY = 10000, @date DATE = GETDATE()
WHILE @period > 0
	BEGIN
		INSERT INTO #Accounts VALUES (@date,@sum)
		SET @period = @period - 1
		SET @date = DATEADD(YEAR,1,@date)
		SET @sum = @sum + @sum * @rate
	END	
GO

GO
DECLARE @number INT = 1
WHILE @number < 10
	BEGIN
		PRINT CONVERT(NVARCHAR, @number)
		SET @number = @number + 1
		IF @number = 7
			BREAK
		IF @number = 4
			CONTINUE
		PRINT N'Конец итерации'
	END
GO

SELECT @@SERVERNAME
SELECT @@VERSION
SELECT @@ROWCOUNT
SELECT @@SPID
SELECT @@OPTIONS 
SELECT @@ERROR
SELECT @@IDENTITY

GO
UPDATE Employee
	SET dept_no = 'd100'
	WHERE emp_no = 2581
IF @@ERROR <> 0
	PRINT 'Error = ' + CAST(@@ERROR AS NVARCHAR(8));
	PRINT N'Нарушение целостности данных.'
GO
-----------------------------------------------------

GO
DECLARE @ErrorVar INT
UPDATE Employee
	SET dept_no = 'd4'
	WHERE emp_no = 2581
SET @ErrorVar = @@ERROR
		IF @ErrorVar <> 0
			BEGIN
				PRINT 'Error = ' + CAST(@ErrorVar AS NVARCHAR(8))
				PRINT N'Нарушение целостности данных'
			END
GO

INSERT INTO Employee VALUES (13, 'Anu', 'Ressi', 'd2', 1000)

GO
	DELETE FROM Employee WHERE emp_no = 2581
	PRINT  N'Error = ' + CAST (@@ERROR AS NVARCHAR(8))
	PRINT  N'Rows Deleted = ' + CAST(@@ROWCOUNT AS NVARCHAR(8))
GO

GO
BEGIN TRY
	SELECT 1/0
END TRY
BEGIN CATCH
	SELECT 
		ERROR_NUMBER() AS ErrorNumber,
		ERROR_SEVERITY() AS ErrorSeverity,
		ERROR_STATE() AS ErrorState,
		ERROR_LINE() AS ErrorLine,
		ERROR_MESSAGE() AS ErrorMessage
END CATCH
GO
GO
	SELECT RAND()
	SELECT RAND(125)
	SELECT 20*RAND()
	SELECT CONVERT(INT, 20*RAND())
	SELECT CONVERT(INT, RAND()*(100-50)+5)

	SELECT RAND((DATEPART(mm,GETDATE()) * 100000) + (DATEPART(ss,GETDATE()) * 1000) + DATEPART(ms,GETDATE()))
	DECLARE @counter smallint
	SET @counter = 1
	WHILE @counter < 5
		BEGIN
			SELECT RAND() Random_Number
			SET @counter = @counter + 1
		END
GO


-- 19.2
-- Aleksander Russovits

GO
DECLARE @emp_no INT,
@dept_no NCHAR(10),@emp_lname NCHAR(15),
@emp_fname NCHAR(15), @salary MONEY; 

SET @emp_no = 10;
SET @dept_no = '25721'; 
SET @emp_fname = 'Aleksei'; 
SET @emp_lname = 'Barabanov';
SET @salary = 9000;

WHILE(@emp_no < 60)
	BEGIN
		SELECT CONVERT(INT, 10+RAND()*10000) Random_Number
		IF Random_Number < @emp_no > Random_Number
		INSERT INTO Employee_30 VALUES (@emp_no, @dept_no,@emp_fname,@emp_lname,@salary)
		SET @emp_no = @emp_no + 1
	END
GO