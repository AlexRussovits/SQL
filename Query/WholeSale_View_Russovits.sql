USE Sample_AR;

GO
CREATE VIEW v_clerk
AS SELECT emp_no, project_no, enter_data
FROM Works_On
WHERE job = 'Clerk';
GO

SELECT * FROM v_clerk
-------------------------------------------
GO
CREATE VIEW v_count (project_no,count_project)
AS SELECT project_no, COUNT(*)
FROM Works_On
GROUP BY project_no; 
GO
----------------------------------------------
GO
CREATE VIEW v_job_clerk_p3
AS SELECT * FROM v_clerk
WHERE project_no = 'p3'
GO
-----------------------------------------------
GO
CREATE VIEW v_dept
AS SELECT dept_no, dept_name, location
FROM Department;
GO

GO
INSERT INTO v_dept
VALUES('d7', 'Economy', 'Kansas City');
GO

SELECT * FROM v_dept

DROP VIEW v_dept
SELECT * FROM Department
------------------------------------------------------------------

GO
CREATE VIEW v_2006_check
AS SELECT * FROM Works_On
WHERE YEAR(enter_data) = 2006
WITH CHECK OPTION;
GO

SELECT * FROM Employee

INSERT INTO v_2006_check VALUES ('11111', 'p2', 'IT', '02-06-2020')

SELECT * FROM v_2006_check
DROP VIEW v_2006_check

-----------------------------------------------------------------------
USE WholeSale;

SELECT * FROM Categories
SELECT * FROM Customers
SELECT * FROM Employees
SELECT * FROM OrderDetails
SELECT * FROM Orders
SELECT * FROM Products
SELECT * FROM Shippers
SELECT * FROM Suppliers

GO
CREATE VIEW report AS
SELECT Customers.CustomerID, SUM(OrderDetails.Quantity) AS quantity, SUM(OrderDetails.UnitPrice * OrderDetails.Quantity) AS summa, Shippers.CompanyName AS ship, YEAR(Orders.ShippedDate) AS shipYear FROM Orders 
	INNER JOIN Customers ON Customers.CustomerID = Orders.CustomerID
	INNER JOIN Shippers ON Orders.ShipVia = Shippers.ShipperID
	INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
	GROUP BY Customers.CustomerID, YEAR(Orders.ShippedDate), Shippers.CompanyName
GO

SELECT * FROM report ORDER BY CustomerID,shipYear
