USE Test4_AR;

SELECT * FROM Employees
SELECT * FROM #Temp
SELECT * FROM Departments
SELECT * FROM Positions

DROP TABLE Employees
DROP TABLE #Temp
DROP TABLE Departments
DROP TABLE Positions

/*
CREATE TABLE Employees (
	ID_emp int NOT NULL CONSTRAINT PK_Employees PRIMARY KEY,
	nameEmp NVARCHAR(30) NULL,
	Birthday DATE,
	Email NVARCHAR(50),
	Position NVARCHAR(30),
	Department NVARCHAR(30))*/

ALTER TABLE Employees ALTER COLUMN nameEmp NVARCHAR(30) NOT NULL -- Изменение у колонки значения
ALTER TABLE Employees DROP CONSTRAINT PK_Employees -- сброс primary key
ALTER TABLE Employees ADD CONSTRAINT PK_Employees PRIMARY KEY

INSERT INTO Employees(ID_emp, Position,Department,nameEmp)  VALUES 
(1000,N'Директор',N'Администрация',N'Иванов И.И.'),
(1001,N'Программист',N'ИТ',N'Петров П.П.'),
(1002,N'Бухгалтер',N'Бухгалтерия',N'Сидоров С.С.'),
(1003,N'Старший программист',N'ИТ',N'Андреев А.А.')

/*
CREATE TABLE #Temp(
  ID_emp int,
  nameEmp NVARCHAR(30) -- Временная таблица
)
*/

SELECT ID_emp,nameEmp INTO #Temp FROM Employees

CREATE TABLE Positions(
  posID int IDENTITY(1000,10) NOT NULL CONSTRAINT PK_Positions PRIMARY KEY,
  posName NVARCHAR(30) NOT NULL
)

CREATE TABLE Departments(
  deptID int IDENTITY(10000,100) NOT NULL CONSTRAINT PK_Departments PRIMARY KEY,
  deptName NVARCHAR(30) NOT NULL
)

-- заполняем поле posName таблицы Positions, уникальными значениями из поля Position таблицы Employees
INSERT Positions(posName)
SELECT DISTINCT Position
FROM Employees
WHERE Position IS NOT NULL -- отбрасываем записи у которых позиция не указана

INSERT Departments(deptName)
SELECT DISTINCT Department
FROM Employees
WHERE Department IS NOT NULL

-- добавляем поле для ID должности
ALTER TABLE Employees ADD PositionID int
-- добавляем поле для ID отдела
ALTER TABLE Employees ADD DepartmentID int

ALTER TABLE Employees ADD CONSTRAINT FK_Employees_PositionID
FOREIGN KEY(PositionID) REFERENCES Positions(posID)

ALTER TABLE Employees ADD CONSTRAINT FK_Employees_DepartmentID
FOREIGN KEY(DepartmentID) REFERENCES Departments(deptID)

UPDATE e
SET
  PositionID=(SELECT posID FROM Positions WHERE posName=e.Position),
  DepartmentID=(SELECT deptID FROM Departments WHERE deptName=e.Department)
FROM Employees e

ALTER TABLE Employees DROP COLUMN Position,Department

SELECT e.ID_emp,e.nameEmp,p.posName PositionName,d.deptName DepartmentName
FROM Employees e
LEFT JOIN Departments d ON d.deptID=e.DepartmentID
LEFT JOIN Positions p ON p.posID=e.PositionID

ALTER TABLE Employees ADD ManagerID int

ALTER TABLE Employees ADD CONSTRAINT FK_Employees_ManagerID
FOREIGN KEY (ManagerID) REFERENCES Employees(ID_emp)
/*
CREATE TABLE Employees(
  ID_emp int NOT NULL,
  nameEmp nvarchar(30),
  Birthday date,
  Email nvarchar(50),
  PositionID int,
  DepartmentID int,
  ManagerID int,
CONSTRAINT PK_Employees PRIMARY KEY (ID_emp),
CONSTRAINT FK_Employees_DepartmentID FOREIGN KEY(DepartmentID) REFERENCES Departments(deptID)
ON DELETE CASCADE,
CONSTRAINT FK_Employees_PositionID FOREIGN KEY(PositionID) REFERENCES Positions(posID),
CONSTRAINT FK_Employees_ManagerID FOREIGN KEY (ManagerID) REFERENCES Employees(ID_emp)
)
*/

/*
INSERT INTO Employees(ID_emp,nameEmp,Birthday,PositionID,DepartmentID,ManagerID) VALUES
(1000,N'Иванов И.И.','19550219',1000,10000,NULL),
(1001,N'Петров П.П.','19831203',1010,10000,1001),
(1002,N'Сидоров С.С.','19760607',1020,10100,1002),
(1003,N'Андреев А.А.','19820417',1030,10200,1003)
*/


DELETE Departments WHERE deptID=10200
/*
UPDATE Departments
SET
  ID=30  --Опция ON UPDATE CASCADE ведет себя аналогично, но действует она при обновлении значения ID в справочнике.
WHERE ID=3 -- Но в данном случае это продемонстрировать просто не получится, т.к. у колонки ID в таблице Departments стоит опция IDENTITY, 
			-- которая не позволит нам выполнить следующий запрос (сменить идентификатор отдела 3 на 30):
*/

-- даем разрешение на добавление/изменение IDENTITY значения
SET IDENTITY_INSERT Departments ON

INSERT Departments(deptID,deptName) VALUES(10200,N'ИТ')

-- запрещаем добавление/изменение IDENTITY значения
SET IDENTITY_INSERT Departments OFF
-- Полное очищение таблицы
TRUNCATE TABLE Employees

INSERT INTO Employees(ID_emp,nameEmp,Birthday,PositionID,DepartmentID,ManagerID) VALUES
(1000,N'Иванов И.И.','19550219',1000,10000,NULL),
(1001,N'Петров П.П.','19831203',1010,10000,1001),
(1002,N'Сидоров С.С.','19760607',1020,10100,1002),
(1003,N'Андреев А.А.','19820417',1030,10200,1003)

UPDATE Employees SET Email='i.ivanov@test.tt' WHERE ID_emp=1000
UPDATE Employees SET Email='p.petrov@test.tt' WHERE ID_emp=1001
UPDATE Employees SET Email='s.sidorov@test.tt' WHERE ID_emp=1002
UPDATE Employees SET Email='a.andreev@test.tt' WHERE ID_emp=1003

-- Наложение на это поле ограничение-уникальности
ALTER TABLE Employees ADD CONSTRAINT UQ_Employees_Email UNIQUE(Email)

ALTER TABLE Employees ADD CONSTRAINT DF_Employees_HireDate DEFAULT SYSDATETIME() FOR HireDate

INSERT Employees(ID_emp,nameEmp,Email)VALUES(1004,N'Сергеев С.С.','s.sergeev@test.tt')

ALTER TABLE Employees ADD CONSTRAINT CK_Employees_ID CHECK(ID_emp BETWEEN 1000 AND 1999)

INSERT Employees(ID_emp,Email) VALUES(2000,'test@test.tt') -- Должна выйти ошибка

INSERT Employees(ID_emp,Email) VALUES(1500,'test@test.tt') 

/*
ALTER TABLE Employees ADD UNIQUE(Email)
ALTER TABLE Employees ADD CHECK(ID BETWEEN 1000 AND 1999) -- Можно так же создать ограничения UNIQUE и CHECK без указания имени
*/

/*
CREATE TABLE Employees(
  ID_emp int NOT NULL,
  empName nvarchar(30),
  Birthday date,
  Email nvarchar(50),
  PositionID int,
  DepartmentID int,
  HireDate date NOT NULL DEFAULT SYSDATETIME(), -- для DEFAULT я сделаю исключение
CONSTRAINT PK_Employees PRIMARY KEY (ID_emp),
CONSTRAINT FK_Employees_DepartmentID FOREIGN KEY(DepartmentID) REFERENCES Departments(deptID),
CONSTRAINT FK_Employees_PositionID FOREIGN KEY(PositionID) REFERENCES Positions(posID),
CONSTRAINT UQ_Employees_Email UNIQUE (Email),
CONSTRAINT CK_Employees_ID CHECK (ID_emp BETWEEN 1000 AND 1999)
)
*/

INSERT INTO Employees(ID_emp,empName,Birthday,Email,PositionID,DepartmentID) VALUES
(1000,N'Иванов И.И.','19550219','i.ivanov@test.tt',1000,10000),
(1001,N'Петров П.П.','19831203','p.petrov@test.tt',1010,10000),
(1002,N'Сидоров С.С.','19760607','s.sidorov@test.tt',1020,10100),
(1003,N'Андреев А.А.','19820417','a.andreev@test.tt',1030,10200)

ALTER TABLE Employees DROP CONSTRAINT PK_Employees -- Для примера сделаем индекс ограничения PK_Employees некластерным, 
ALTER TABLE Employees DROP CONSTRAINT UQ_Employees_Email --а индекс ограничения UQ_Employees_Email кластерным. 
														--Первым делом удалим данные ограничения:


ALTER TABLE Employees ADD CONSTRAINT PK_Employees PRIMARY KEY NONCLUSTERED (ID_emp)
ALTER TABLE Employees ADD CONSTRAINT UQ_Employees_Email UNIQUE CLUSTERED (Email)

SELECT * FROM Employees

--Под самостоятельностью здесь имеются в виду индексы, которые создаются не для ограничения PRIMARY KEY или UNIQUE.
--Индексы по полю или полям можно создавать следующей командой:

CREATE INDEX IDX_Employees_Name ON Employees(empName)

CREATE UNIQUE NONCLUSTERED INDEX UQ_Employees_EmailDesc ON Employees(Email DESC)

DROP INDEX IDX_Employees_Name ON Employees

DROP TABLE Employees

CREATE TABLE Employees(
  ID_emp int NOT NULL,
  empName nvarchar(30),
  Birthday date,
  Email nvarchar(50),
  PositionID int,
  DepartmentID int,
  HireDate date NOT NULL CONSTRAINT DF_Employees_HireDate DEFAULT SYSDATETIME(),
  ManagerID int,
CONSTRAINT PK_Employees PRIMARY KEY (ID_Emp),
CONSTRAINT FK_Employees_DepartmentID FOREIGN KEY(DepartmentID) REFERENCES Departments(deptID),
CONSTRAINT FK_Employees_PositionID FOREIGN KEY(PositionID) REFERENCES Positions(posID),
CONSTRAINT FK_Employees_ManagerID FOREIGN KEY (ManagerID) REFERENCES Employees(ID_emp),
CONSTRAINT UQ_Employees_Email UNIQUE(Email),
CONSTRAINT CK_Employees_ID CHECK(ID_Emp BETWEEN 1000 AND 1999),
INDEX IDX_Employees_Name(empName)
)

INSERT Employees (ID_emp,empName,Birthday,Email,PositionID,DepartmentID,ManagerID) VALUES
(1000,N'Иванов И.И.','19550219','i.ivanov@test.tt',1000,10000,NULL),
(1001,N'Петров П.П.','19831203','p.petrov@test.tt',1010,10000,1001),
(1002,N'Сидоров С.С.','19760607','s.sidorov@test.tt',1020,10100,1002),
(1003,N'Андреев А.А.','19820417','a.andreev@test.tt',1030,10200,1003)

SELECT * FROM Employees

