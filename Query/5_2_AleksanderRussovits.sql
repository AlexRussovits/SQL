USE WholeSale;
SELECT *
FROM Customers
WHERE Country = 'Canada'; -- 1

SELECT *
FROM Customers
WHERE PostalCode = '1010' OR PostalCode = '8010'; -- 2

SELECT *
FROM Customers
WHERE Fax IS NULL; --3

SELECT *
FROM Customers
WHERE Region IS NOT NULL; -- 4

SELECT *
FROM Customers
WHERE Region IS NULL AND Fax IS NULL; -- 5

SELECT *
FROM Customers
WHERE Phone LIKE '%555%'; --6

SELECT * 
FROM Customers
WHERE ContactTitle = 'Owner' AND Country = 'USA' OR Country = 'Mexico'; --7


SELECT *
FROM Customers
WHERE ContactName LIKE '%Sven%'; --8

SELECT DISTINCT Country
FROM Customers; --9

SELECT *
FROM Customers
WHERE CustomerID LIKE 'B%' OR CustomerID LIKE 'C%' OR CustomerID LIKE 'D%' OR CustomerID LIKE 'E%'; --10


SELECT *
FROM Customers 
WHERE CustomerID NOT LIKE '%A'  AND CustomerID NOT LIKE '%O'; -- 11


SELECT *
FROM Customers
WHERE ContactTitle LIKE '%sales%'; -- 12


SELECT *
FROM Customers
WHERE ContactTitle LIKE '%Manager%' AND ContactTitle NOT LIKE '%sales%'; --13

SELECT *
FROM Customers
WHERE City LIKE '% % %'; --14

SELECT *, YEAR(OrderDate)
FROM Orders
WHERE YEAR(OrderDate) = 1996; --15
--ПРАКТИКА
-- Александер Русович JPTVR18 5.2

SELECT *
FROM Orders
WHERE OrderDate BETWEEN '1997-08-01' AND '1997-08-31'; --16

SELECT *
FROM Orders 
WHERE OrderDate BETWEEN '1997-07-01' AND '1997-07-31' AND CustomerID = 'GREAL'; --17


SELECT *
FROM Products
WHERE UnitPrice >= 50 AND UnitsInStock <= 5; --18


SELECT *,
UnitPrice * UnitsInStock AS Summa FROM Products; --19

SELECT TOP 4 *
FROM Orders
--WHERE OrderDate BETWEEN '1996-07-04' AND '1996-07-08'; --20











