USE WholeSale;

SELECT * FROM OrderDetails
SELECT * FROM Products
SELECT * FROM Categories

GO
CREATE FUNCTION txt_Name(@ProductID INT)
	RETURNS NVARCHAR (40)
	AS
		BEGIN
			DECLARE @txt_Name NVARCHAR(40)
			SELECT @txt_Name = ProductName FROM Products
			WHERE ProductID = @ProductID
			RETURN @txt_Name
		END 
GO

SELECT dbo.txt_Name(1)

SELECT *, dbo.txt_Name(ProductID) txt_Name FROM OrderDetails
----------------------------------------------------------------------------------

SELECT ProductID, ProductName, Products.CategoryID, CategoryName, UnitPrice FROM Products INNER JOIN Categories ON Categories.CategoryID = Products.CategoryID

GO
CREATE FUNCTION Table_Product(@CategoryID INT)
RETURNS TABLE
AS
	RETURN
		SELECT ProductID, ProductName, Products.CategoryID, CategoryName, UnitPrice FROM Products INNER JOIN Categories ON Categories.CategoryID = Products.CategoryID 
		WHERE Products.CategoryID = @CategoryID 
GO

SELECT * FROM Table_Product(8)
--------------------------------------




