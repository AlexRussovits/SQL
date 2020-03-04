USE Sample_AR;

CREATE TABLE bonus (pr_no CHAR(4), bonus MONEY DEFAULT 100);

INSERT INTO bonus (pr_no) VALUES ('p1');

SELECT * FROM bonus
SELECT * FROM Project



MERGE INTO bonus B
	USING (SELECT * FROM Project) E
		ON (B.pr_no = E.project_no)
	WHEN MATCHED THEN
		UPDATE SET B.bonus = E.budget * 0.1
	WHEN NOT MATCHED THEN
		INSERT (pr_no, bonus)
			VALUES (E.project_no, E.budget * 0.05);
			
SELECT * FROM bonus
SELECT * FROM Project			 

DROP TABLE bonus

GO
	DECLARE @del_table TABLE (emp_no INT, emp_lname CHAR(20))
	DELETE Employee
	OUTPUT deleted.emp_no, deleted.emp_lname INTO @del_table
	WHERE emp_no > 15000
	SELECT * FROM @del_table
GO

GO
	DECLARE @update_table TABLE
	(emp_no INT, project_no CHAR(20), old_job CHAR(20), new_job CHAR(20));
	UPDATE Works_On
	SET job = NULL
	OUTPUT deleted.emp_no, deleted.project_no, deleted.job, inserted.job INTO @update_table
	WHERE job = 'Clerk'
	SELECT * FROM @update_table
GO

CREATE TABLE WareHouse (item_no INT PRIMARY KEY, item_name NVARCHAR(30), Q_items INT, price MONEY)

CREATE TABLE Goods (itemNo INT PRIMARY KEY, itemName NVARCHAR(30), Quantity INT, Cost MONEY)

INSERT INTO WareHouse VALUES (1, 'CPU', 5, 500), (2, 'GPU', 10, 1000), (3, 'Cooler', 15, 120)

INSERT INTO Goods VALUES (1, 'CPU', 3, 500), (2, 'GPU', 5, 1000), (4, 'Tablet', 8, 150)


--1
MERGE INTO WareHouse
USING Goods
	ON (WareHouse.item_no = Goods.itemNo)
	WHEN MATCHED
		THEN UPDATE
			SET Q_items = Quantity + Q_items
	WHEN NOT MATCHED
		THEN INSERT
			VALUES (itemNo, itemName, Quantity, Cost)
	OUTPUT deleted.*, $action, inserted.*;

--2
UPDATE Goods SET Cost = 200 WHERE itemName = 'Tablet'

MERGE INTO WareHouse
USING Goods
	ON (WareHouse.item_no = Goods.itemNo) 
	WHEN MATCHED AND ((WareHouse.price = Goods.Cost) OR Q_items = 0)
		THEN UPDATE
			SET Q_items = Quantity, item_name = itemName, price = Cost
	WHEN NOT MATCHED
		THEN INSERT
			VALUES (itemNo, itemName, Quantity, Cost)
	OUTPUT deleted.*, $action, inserted.*;

SELECT * FROM WareHouse
SELECT * FROM Goods











DROP TABLE WareHouse
DROP TABLE Goods
