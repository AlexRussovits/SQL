USE Projects_AR;

-- 1
INSERT INTO Product(product_name,price) VALUES ('chair',25), ('table',50),('wardrobe', 100);

SELECT * FROM Product

INSERT INTO Product(product_name,price) VALUES ('lamp', 10), ('armchair', 75), ('sofa', 250); 
--=================================================================================================
DROP TABLE Product

-- 2

CREATE TABLE Product
(product_ID INT IDENTITY(1000,1) NOT NULL, product_name VARCHAR(50) NOT NULL, price MONEY, date_reg DATETIME DEFAULT GETDATE());

SELECT * FROM Product

INSERT INTO Product(product_name,price) VALUES ('chair',25), ('table',50),('wardrobe', 100);

INSERT INTO Product(product_name,price) VALUES ('lamp', 10), ('armchair', 75), ('sofa', 250); 

INSERT INTO Product(product_name,price,date_reg) VALUES ('Panel', 350, DEFAULT);
---================================================================================================================

CREATE TABLE Product
(product_ID INT IDENTITY(1000,1) NOT NULL CONSTRAINT PK_product PRIMARY KEY, product_name VARCHAR(50) NOT NULL, price MONEY, date_reg DATETIME DEFAULT GETDATE());

INSERT INTO Product(product_name,price) VALUES ('chair',25), ('table',50),('wardrobe', 100);

INSERT INTO Product(product_name,price) VALUES ('lamp', 10), ('armchair', 75), ('sofa', 250);

INSERT INTO Product(product_name,price) VALUES ('dress',90),('bubble gum',5),('boots',45),('stool',30);

INSERT INTO Product(product_name,price) VALUES ('OnePlus',700);

/*UPDATE Product SET product_ID = 1760 FROM Product
WHERE product_name = 'OnePlus'*/

DELETE FROM Product WHERE product_name = 'chair'

CREATE TABLE Customer (cust_no INTEGER NOT NULL, cust_group CHAR(3) NULL, CHECK (cust_group IN('c1','c2','c3')));

INSERT INTO Customer (cust_no,cust_group) VALUES (1750, 'c1'),(2150, 'c2'),(1235, 'c3') ;

SELECT * FROM Customer

DROP TABLE Customer

CREATE TABLE Sales (sale_ID INT IDENTITY(10000,1) NOT NULL CONSTRAINT PK_sales PRIMARY KEY,
 product_ID INT NOT NULL,
 Quantity INT DEFAULT 1 NULL, date_sale DATETIME DEFAULT GETDATE(),
 date_received DATETIME DEFAULT GETDATE()+3,CHECK (date_received >= date_sale),
 CONSTRAINT FK_product FOREIGN KEY(product_ID) REFERENCES Product (product_ID) ON DELETE CASCADE);

 INSERT INTO Sales (product_ID,Quantity) VALUES (1000,15)
 INSERT INTO Sales (product_ID,Quantity) VALUES (1001,8)
 INSERT INTO Sales (product_ID,Quantity) VALUES (1002,10)
 INSERT INTO Sales (product_ID,Quantity) VALUES (1003,12)
 INSERT INTO Sales (product_ID,Quantity) VALUES (1004,25)
 INSERT INTO Sales (product_ID,Quantity) VALUES (1005,17)
 INSERT INTO Sales (product_ID,Quantity) VALUES (1006,30)
 INSERT INTO Sales (product_ID,Quantity) VALUES (1007,20)
 INSERT INTO Sales (product_ID,Quantity) VALUES (1008,26)
 INSERT INTO Sales (product_ID,Quantity) VALUES (1009,11)

SELECT * FROM Sales
DROP TABLE Sales

SELECT Sales.sale_ID,Sales.product_ID,Sales.Quantity,Product.product_name,Product.price, Sales.Quantity * Product.price AS Earned_Money FROM Sales JOIN Product ON Sales.product_ID = Product.product_ID;

SELECT SUM(Sales.Quantity * Product.price) AS Earned_Money, COUNT(Sales.Quantity) AS QuantitySales FROM Sales JOIN Product ON Sales.product_ID = Product.product_ID;


--===============================================================================================================================================================



