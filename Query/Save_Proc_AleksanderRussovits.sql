USE WholeSale;

--1
SELECT OrderID, CustomerID, OrderDate
FROM Orders
WHERE CustomerID = 'HANAR' AND OrderDate >= '1998-04-01' AND OrderDate < '1998-07-01'



--2
GO
DECLARE @cust_id AS VARCHAR(5),
@orderdate_from AS DATE,
@orderdate_to AS DATE
	SET @cust_id = 'HANAR';
	SET @orderdate_from = '1998-04-01';
	SET @orderdate_to = '1998-07-01';
		SELECT OrderID, CustomerID, OrderDate
			FROM Orders
			WHERE CustomerID = @cust_id AND OrderDate >= @orderdate_from AND OrderDate < @orderdate_to
GO

--3
GO
CREATE PROC GetCustomersOrders
@cust_id AS VARCHAR(5),
@orderdate_from AS DATE = '19960101',
@orderdate_to AS DATE = '20001231'
AS 
	BEGIN
		SELECT OrderID, CustomerID, OrderDate
			FROM Orders
				WHERE CustomerID = @cust_id AND OrderDate >= @orderdate_from AND OrderDate < @orderdate_to
	END
GO	

GO
--3.1
EXEC GetCustomersOrders 'HANAR'
GO
--3.2
GO
EXEC GetCustomersOrders @cust_id = 'HANAR'
GO
--3.3
GO
EXEC GetCustomersOrders 'HANAR', '19980401', '19980701'
GO
--3.40
GO
EXEC GetCustomersOrders
@cust_id = 'HANAR', @orderdate_from = '19980401', @orderdate_to = '19980701'
GO
DROP PROC GetCustomersOrders

GO
IF OBJECT_ID('GetCustomersOrders', 'P') IS NOT NULL
	PRINT 'Процедура такая существует'
GO

GO
CREATE PROC GetCustomersOrders
@cust_id AS VARCHAR(5),
@orderdate_from AS DATE = '19960101',
@orderdate_to AS DATE = '20001231',
@numrows INT = 0 OUTPUT
AS 
BEGIN
	SET NOCOUNT ON;
		SELECT OrderID, CustomerID, OrderDate
			FROM Orders
				WHERE CustomerID = @cust_id AND OrderDate >= @orderdate_from AND OrderDate < @orderdate_to
				SET @numrows = @@ROWCOUNT
END
GO
----------------------------------------------
GO
DECLARE @rowsreturned AS INT;
EXEC GetCustomersOrders
 @cust_id = 'HANAR',
 @orderdate_from = '19980401',
 @orderdate_to = '19980701',
 @numrows = @rowsreturned OUTPUT;
 SELECT @rowsreturned AS [Rows Returned];
 GO
 ---------------------------------------------
GO
DECLARE @rowsreturned AS INT;
EXEC GetCustomersOrders
 'HANAR',
 '19980401',
 '19980701',
 @rowsreturned OUTPUT;
 SELECT @rowsreturned --AS [Rows Returned];
 GO

 USE Sample_AR;
 GO
 CREATE PROC modify_empno
 (@old_no INT, @new_no INT)
 AS UPDATE Employee
	SET emp_no = @new_no
	WHERE emp_no = @old_no
	UPDATE Works_On
		SET emp_no = @new_no
		WHERE emp_no = @old_no
GO

SELECT * FROM Employee

GO
EXEC modify_empno
@old_no = 2581 ,@new_no = 55452
GO

DROP CONSTRAINT  