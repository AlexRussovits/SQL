USE Test2_AR;
SELECT * FROM Employees
SELECT * FROM #Temp
SELECT * FROM Departments
SELECT * FROM Positions

DROP TABLE Employees
DROP TABLE #Temp
DROP TABLE Departments
DROP TABLE Positions

/*CREATE TABLE Employees (
	ID_emp int NOT NULL CONSTRAINT PK_Employees PRIMARY KEY,
	nameEmp NVARCHAR(30) NULL,
	Birthday DATE,
	Email NVARCHAR(50),
	Position NVARCHAR(30),
	Department NVARCHAR(30) 
)
*/

ALTER TABLE Employees ALTER COLUMN nameEmp NVARCHAR(30) NOT NULL -- ��������� � ������� ��������
ALTER TABLE Employees DROP CONSTRAINT PK_Employees -- ����� primary key

INSERT INTO Employees(ID_emp, Position,Department,nameEmp)  VALUES 
(1000,N'��������',N'�������������',N'������ �.�.'),
(1001,N'�����������',N'��',N'������ �.�.'),
(1002,N'���������',N'�����������',N'������� �.�.'),
(1003,N'������� �����������',N'��',N'������� �.�.')

CREATE TABLE #Temp(
  ID_emp int,
  nameEmp NVARCHAR(30) -- ��������� �������
)

SELECT ID_emp,nameEmp INTO #Temp FROM Employees

CREATE TABLE Positions(
  posID int IDENTITY(1000,10) NOT NULL CONSTRAINT PK_Positions PRIMARY KEY,
  posName NVARCHAR(30) NOT NULL
)

CREATE TABLE Departments(
  deptID int IDENTITY(10000,100) NOT NULL CONSTRAINT PK_Departments PRIMARY KEY,
  deptName NVARCHAR(30) NOT NULL
)

-- ��������� ���� posName ������� Positions, ����������� ���������� �� ���� Position ������� Employees
INSERT Positions(posName)
SELECT DISTINCT Position
FROM Employees
WHERE Position IS NOT NULL -- ����������� ������ � ������� ������� �� �������

INSERT Departments(deptName)
SELECT DISTINCT Department
FROM Employees
WHERE Department IS NOT NULL

-- ��������� ���� ��� ID ���������
ALTER TABLE Employees ADD PositionID int
-- ��������� ���� ��� ID ������
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

ALTER TABLE Employees DROP CONSTRAINT FK_Employees_DepartmentID
ALTER TABLE Employees DROP CONSTRAINT FK_Employees_PositionID
ALTER TABLE Employees DROP CONSTRAINT PK_Employees
ALTER TABLE Employees DROP CONSTRAINT FK_Employees_ManagerID

INSERT INTO Employees(ID_emp,nameEmp,Birthday,PositionID,DepartmentID,ManagerID) VALUES
(1000,N'������ �.�.','19550219',1000,10000,NULL),
(1001,N'������ �.�.','19831203',1010,10000,1001),
(1002,N'������� �.�.','19760607',1020,10100,1002),
(1003,N'������� �.�.','19820417',1030,10200,1003)