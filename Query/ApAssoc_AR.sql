USE master;
-- Create Database
CREATE DATABASE ApartmentAssociation2_AR

USE ApartmentAssociation2_AR;

-- Create Table Flats

CREATE TABLE Flats (f_no INT PRIMARY KEY, apsquare FLOAT NOT NULL, typeofheating VARCHAR(30) DEFAULT 'Central' NOT NULL, 
CHECK (typeofheating IN ('Central', 'Gas', 'Electricty')), percentage FLOAT NOT NULL, OwnerID VARCHAR(11) NOT NULL)

-- Add foreign keys
ALTER TABLE Flats ADD CONSTRAINT FK_OwnerID FOREIGN KEY (OwnerID) REFERENCES Owners(OwnerID);

-- Drop foreign keys
ALTER TABLE Flats DROP CONSTRAINT FK_OwnerID

-- �������� ������� 
CREATE TABLE Owners (OwnerID VARCHAR(11) PRIMARY KEY, OwnerFirstName VARCHAR(30) NOT NULL, OwnerLastName VARCHAR(30)
NOT NULL, OwnerPhone VARCHAR(12) NULL, OwnerEmail VARCHAR(50) NULL)

-- �������� ������� TariffArea
CREATE TABLE TariffArea
(TariffID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
TariffPriceArea MONEY NOT NULL,
TariffDate DATE NOT NULL);

--�������� ������� CounterElect
CREATE TABLE CounterElect (CounterDate DATE PRIMARY KEY NOT NULL,
CounterMWH FLOAT NOT NULL, userEnter VARCHAR(20) DEFAULT 'admin' NOT NULL, userDate DATE NOT NULL)

--�������� ������� ��� ����������
CREATE TABLE OwnerHistory (
    HistoryID INT IDENTITY PRIMARY KEY,
    Operation NVARCHAR(200) NOT NULL,
    CreateAt DATETIME NOT NULL DEFAULT GETDATE()
)


-- ���������� �������� ��� ������ ��������� 
GO 
	CREATE PROC AddCounterElect (@CounterMWH FLOAT, @Date DATE) AS 
		BEGIN
			IF DAY(@Date) <= 28
				BEGIN
					INSERT INTO CounterElect VALUES (EOMONTH (@Date,-1),@CounterMWH, DEFAULT, @Date)
				END
			ELSE
				BEGIN
					INSERT INTO CounterElect VALUES (EOMONTH (@Date,-2), @CounterMWH, DEFAULT, @Date)
				END
		END
GO

-- � ���� ������� ����� ����������� ����������, ������� ����� ����������, ������� ����� ����� ��������� ��������� ��������
CREATE TABLE PayoffFlats(f_no INT NOT NULL, 
apsquare FLOAT NOT NULL, percentage FLOAT NOT NULL,
heatingFlatsSquare FLOAT NOT NULL,
FlatSquarePrice MONEY NOT NULL,
Tariff FLOAT NOT NULL,
FlatPrice MONEY NOT NULL,
ToDate DATE NOT NULL,
CONSTRAINT FK_f_no FOREIGN KEY(f_no) REFERENCES Flats (f_no) ON DELETE CASCADE,
CONSTRAINT FK_ToDate FOREIGN KEY(ToDate) REFERENCES CounterElect (CounterDate) ON DELETE CASCADE)

-- ���������, ������� ����� ����������� ���������� ������� �� ��������
GO
	CREATE PROC CalculationOfElectricity AS 
	-- ����������� ����������
		BEGIN
			DECLARE @counter1 AS FLOAT
			DECLARE @counter2 AS FLOAT
			DECLARE @result AS FLOAT
			DECLARE @perApSquare AS FLOAT
			DECLARE @MonthPrice AS FLOAT
			DECLARE @tariff AS FLOAT
			DECLARE @date AS DATE

			-- ���� ����� � ���� �� ������ 
			BEGIN
				SELECT TOP 1 @date = CounterDate FROM CounterElect ORDER BY CounterDate DESC
				SELECT TOP 1 @tariff = TariffPriceArea FROM TariffArea ORDER BY TariffPriceArea DESC

				-- ��������, ������� �������� � ������� ��������� � ������������� ����������
				IF(SELECT COUNT(*) FROM CounterElect) > 1
					BEGIN
						SELECT TOP 1 @counter1 = CounterMWH FROM CounterElect ORDER BY CounterDate DESC
						SELECT TOP 1 @counter2 = CounterMWH FROM CounterElect WHERE CounterMWH IN (SELECT TOP 2 CounterMWH FROM CounterElect ORDER BY CounterDate DESC)
						SET @result = @tariff * (@counter1 - @counter2)
					END
				ELSE
				-- ���� ������ 1 �������
					BEGIN
						SELECT TOP 1 @counter1 = CounterMWH FROM CounterElect ORDER BY CounterDate DESC
						SET @result = @tariff * @counter1
					END
				-- ������� ����� ��������� �� ��������
				SELECT @perApSquare = SUM(apsquare * percentage) FROM Flats
				SET @MonthPrice = @result/@perApSquare

				--������� ���� ����������, ��� �� �������� 
				INSERT INTO PayoffFlats
					SELECT f_no,
					apsquare AS apsquare,
					percentage AS percentage,
					apsquare * percentage AS heatingFlatsSquare,
					@MonthPrice AS FlatSquarePrice,
					@tariff AS Tariff,
					@MonthPrice * (apsquare * percentage) AS FlatPrice,
					@date AS ToDate
					FROM Flats

					SELECT * FROM PayoffFlats
			END
		END
GO

-- ����� ���������
DROP PROC CalculationOfElectricity

--������ ���������
EXEC CalculationOfElectricity


-- �������, ���������� ��� ���������� � �������
GO
CREATE TRIGGER InsertOwner ON Owners
AFTER INSERT
AS
	BEGIN
		INSERT INTO OwnerHistory (Operation,CreateAt) VALUES ('INSERT', DEFAULT)
		SELECT * FROM OwnerHistory
	END
GO

-- �������, ���������� ��� ���������� � �������
GO
CREATE TRIGGER UpdateOwner ON Owners
AFTER UPDATE
AS
	BEGIN
		INSERT INTO OwnerHistory (Operation,CreateAt) VALUES ('UPDATE', DEFAULT)
		SELECT * FROM OwnerHistory
	END
GO

-- �������, ���������� ��� ��������� �� �������
GO
CREATE TRIGGER DeleteOwner ON Owners
AFTER DELETE
AS
	BEGIN
		INSERT OwnerHistory (Operation,CreateAt) VALUES ('DELETE', DEFAULT)
		SELECT * FROM OwnerHistory
	END
GO

-- Select tables
SELECT * FROM Owners
SELECT * FROM Flats
SELECT * FROM TariffArea
SELECT * FROM CounterElect
SELECT * FROM PayoffFlats 

-- Drop tables
DROP TABLE Owners
DROP TABLE Flats
DROP TABLE TariffArea
DROP TABLE CounterElect
DROP TABLE PayoffFlats
