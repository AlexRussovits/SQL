USE Sample_AR;

SELECT * FROM Project

GO
CREATE TABLE audit_budget(project_no CHAR(4) NULL,
user_name CHAR(16) NULL,
date DATETIME NULL,
budget_old FLOAT NULL,
budget_new FLOAT NULL);
GO

GO
CREATE TRIGGER modify_budget
ON project AFTER UPDATE
AS IF UPDATE(budget)
	BEGIN
		DECLARE @budget_old FLOAT
		DECLARE @budget_new FLOAT
		DECLARE @project_number CHAR(4)
		SELECT @budget_old = (SELECT budget FROM deleted)
		SELECT @budget_new = (SELECT budget FROM inserted)
		SELECT @project_number = (SELECT project_no FROM deleted)

		INSERT INTO  audit_budget VALUES
		(@project_number, USER_NAME(), GETDATE(), @budget_old, @budget_new)
	END 
GO


UPDATE Project
SET budget = 210000 
WHERE project_no = 'p2'

UPDATE Project
SET budget = 180000 
WHERE project_no = 'p1'

UPDATE Project
SET project_name = 'Gemini' 
WHERE project_no = 'p2'
------------------------------------------------------------========================================================

-- Триггер total_budget является примером использования
-- триггер для реализации бизнес-правила

GO
CREATE TRIGGER total_budget
ON Project AFTER UPDATE
AS IF UPDATE (budget)
	BEGIN
		DECLARE @sum_old1 FLOAT
		DECLARE @sum_old2 FLOAT
		DECLARE @sum_new FLOAT
		SELECT @sum_new = (SELECT SUM(budget) FROM inserted)
		SELECT @sum_old1 =
			(SELECT SUM(p.budget)
			FROM project p
			WHERE p.project_no NOT IN
				(SELECT d.project_no FROM deleted d))
		SELECT @sum_old2 = (SELECT SUM(budget) FROM deleted)
		IF @sum_new > (@sum_old1 + @sum_old2)*1.5
		BEGIN
			PRINT 'No modification of budgets'
			ROLLBACK TRANSACTION
		END
	ELSE
		PRINT 'The modification of budgets executed'
	END
GO

UPDATE Project 
SET budget = 400000 WHERE project_no = 'p3'

UPDATE Project
SET budget = 900000 WHERE project_no = 'p1'

UPDATE Project
SET  budget = 1300000 WHERE project_no = 'p1'

UPDATE Project
SET  budget = 13000000 WHERE project_no = 'p1'

SELECT * FROM Project
---------------------------------------------------------------------------------------------------=====================================

CREATE TABLE TestTable(
[ProductId] [INT] IDENTITY(1,1) NOT NULL,
[CategoryId] [INT] NOT NULL,
[ProductName] [VARCHAR](100) NOT NULL,
[Price] [Money] NULL
)


GO
CREATE TABLE AutiTestTable (
Id INT IDENTITY (1,1) NOT NULL,
DtChange DATETIME NOT NULL,
UserName VARCHAR(100) NOT NULL,
SQL_Command VARCHAR(100) NOT NULL,
ProductId_Old INT NULL,
ProductId_New INT NULL,
CategoryId_Old INT NULL,
CategoryId_New INT NULL,
ProductName_Old VARCHAR(100) NULL,
ProductName_New VARCHAR(100) NULL,
Price_Old MONEY NULL,
Price_New MONEY NULL,
CONSTRAINT PK_AutitTestTable PRIMARY KEY (Id))
GO

GO
CREATE TRIGGER TRG_Audit_TestTable ON TestTable
	AFTER INSERT,UPDATE,DElETE
AS
	BEGIN
		DECLARE @SQL_Command VARCHAR(100);
		/*
		Определяем, что это за операция
		на основе наличия записей в таблицах inserted и deleted.
		На практике, конечно же, лучше делать отдельный триггер для каждой операции
		*/
		IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted)
			SET @SQL_Command = 'INSERT'
		IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted)
			SET @SQL_Command = 'UPDATE'
		IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted)
			SET @SQL_Command = 'DELETE'
		-- Инструкция если происходит добавление или обновление записи
		IF @SQL_Command = 'UPDATE' OR @SQL_Command = 'INSERT'
		BEGIN
			INSERT INTO AutiTestTable(DtChange, UserName, SQL_Command, ProductId_Old,
			ProductId_New, CategoryId_Old, CategoryId_New,
			ProductName_Old, ProductName_New, Price_Old, Price_New)
			SELECT GETDATE(), SUSER_SNAME(), @SQL_Command, D.ProductId, I.ProductId,
			D.CategoryId, I.CategoryId, D.ProductName, I.ProductName, D.Price, I.Price
			FROM inserted I
			LEFT JOIN deleted D ON I.ProductId = D.ProductId
		END
		-- Инструкция если происходит удаление записи
		IF @SQL_Command = 'DELETE'
		BEGIN
			INSERT INTO AutiTestTable(DtChange, UserName, SQL_Command, ProductId_Old,
			ProductId_New, CategoryId_Old, CategoryId_New,
			ProductName_Old, ProductName_New, Price_Old, Price_New)
			SELECT GETDATE(), SUSER_SNAME(), @SQL_Command,
			 D.ProductId, NULL,
			 D.CategoryId, NULL,
			 D.ProductName, NULL,
			 D.Price, NULL
			FROM deleted D
		END
	END 
GO
DROP TRIGGER TRG_Audit_TestTable

--Добавляем запись
INSERT INTO TestTable
VALUES (1, 'Chair', 0)

--Изменяем запись
UPDATE TestTable SET ProductName = 'Wardrobe',
Price = 200
WHERE ProductName = 'Chair'

--Удаляем запись
DELETE TestTable WHERE ProductName = 'Наименование товара'SELECT * FROM AutiTestTableSELECT * FROM TestTableDISABLE TRIGGER TRG_Audit_TestTable ON TestTable; -- выключение триггераENABLE TRIGGER TRG_Audit_TestTable ON TestTable; -- включение триггера






