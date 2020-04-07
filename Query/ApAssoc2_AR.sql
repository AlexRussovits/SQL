USE master;
-- Create Database
CREATE DATABASE ApartmentAssociation2_AR

USE ApartmentAssociation2_AR;
use ApartmentAssociation3_AR;
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

-- �������� ������� TariffArea -- ����� �������   ���� ���� ������� ���� (������ ����� �-�� � �������� �������� � ���� �����)
CREATE TABLE TariffArea
(TariffID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
TariffPriceArea MONEY NOT NULL,
TariffDate DATE NOT NULL);

-- ����� ���������

	create table tarif_heating   
	(first_date_heating date PRIMARY KEY,
	price_heating money,
	comment varchar(50),
	date_comment datetime default GETDATE())



--�������� ������� CounterElect
CREATE TABLE CounterElect (CounterDate DATE PRIMARY KEY NOT NULL,
CounterMWH FLOAT NOT NULL, userEnter VARCHAR(20) DEFAULT 'admin' NOT NULL, userDate DATE NOT NULL)

--�������� ������� ��� ����������
CREATE TABLE OwnerHistory 
(
    HistoryID INT IDENTITY PRIMARY KEY,
    Operation NVARCHAR(200) NOT NULL,
    CreateAt DATETIME NOT NULL DEFAULT GETDATE()
)

select * FROM OwnerHistory

-- ���������� ������ �������� ��� ������ ��������� - ��������� ���� �-��, --- ����� ������� �������� �� �������� > ��� ����
GO 
	CREATE PROC AddCounterElect (@CounterMWH FLOAT, @Date DATE) AS 
		BEGIN
			IF DAY(@Date) <= 25
				BEGIN
					INSERT INTO CounterElect VALUES (EOMONTH (@Date,-1),@CounterMWH, DEFAULT, @Date) -- ����������
				END
			ELSE
				BEGIN
					INSERT INTO CounterElect VALUES (EOMONTH (@Date), @CounterMWH, DEFAULT, @Date)  -- �������� �������
				END
		END
GO

DROP Proc AddCounterElect

-- � ���� ������� ����� ����������� ����������, ������� ����� ����������, ������� ����� ����� ��������� ��������� ��������

CREATE TABLE PayoffFlats(f_no INT NOT NULL, 
apsquare FLOAT NOT NULL, 
percentage FLOAT NOT NULL,
heatingFlatsSquare FLOAT NOT NULL, --������������ ������� ��������
m1heating MONEY NOT NULL,  -- ��������� 1�2 ������������ �������
heatingSquarePrice MONEY NOT NULL, -- ��������� ��������� ��������
tariffArea MONEY  NOT NULL, -- ����� 1�2 �������
FlatSquarePrice MONEY NOT NULL,  -- ��������� ������� ��������
TotalPrice MONEY NOT NULL, -- ����� � ������
ToDate DATE NOT NULL,
CONSTRAINT PR_Payoff PRIMARY KEY (f_no, ToDate),
CONSTRAINT FK_f_no FOREIGN KEY(f_no) REFERENCES Flats (f_no) ON DELETE CASCADE,
CONSTRAINT FK_ToDate FOREIGN KEY(ToDate) REFERENCES CounterElect (CounterDate) ON DELETE CASCADE)

-- ���������, ������� ����� ����������� ���������� ������� �� ��������
GO
	CREATE PROC CalculationOfElectricity AS 
	-- ����������� ����������
		BEGIN
			DECLARE @counter1 AS FLOAT  -- last
			DECLARE @counter2 AS FLOAT  -- prev
			
			DECLARE @perApSquare AS FLOAT  -- ������������ ������� ����

			DECLARE @tariff_area AS MONEY,
					@tarif_heating AS MONEY,
					@m1heating AS MONEY    -- ��������� 1�2 ������������ �������
			DECLARE @date AS DATE -- ��������� ���� �-�� �� ������� ��������


			-- ���� ����� � ���� �� ������ 
			BEGIN
				SELECT @perApSquare = SUM(apsquare * percentage) FROM Flats -- ������������ ������� ����

				SELECT TOP 1 @date = CounterDate FROM CounterElect ORDER BY CounterDate DESC -- ��������� ����

				-- WHERE first_date_heating < @date  - ��� ������� �.�. - ��������� ������� �������� �������, ������ �������� � ���� �������� ����

				SELECT TOP 1 @tarif_heating =  price_heating FROM  tarif_heating WHERE first_date_heating < @date ORDER BY first_date_heating DESC --tariff 1MWh
				
			
				SELECT TOP 1 @counter1 = CounterMWH FROM CounterElect ORDER BY CounterDate DESC  -- ��������� ��������� ��������
				SELECT TOP 2 @counter2 = CounterMWH FROM CounterElect ORDER BY CounterDate DESC -- ������������� ��������� ��������

				SET @m1heating = @tarif_heating * (@counter1 - @counter2)/@perApSquare          -- ��������� 1�2 ������������ �������

				-- -- ����� 1�2 �������
				SELECT TOP 1 @tariff_area = TariffPriceArea FROM TariffArea WHERE TariffDate <  @date ORDER BY TariffDate  DESC  --     ���������� ������ �� ���� ������ ����

				-- ��������, ������� ������� �������� � ������� ��������� � ������������� ����������


				--������� ���� ����������, ��� �� �������� 
				INSERT INTO PayoffFlats (f_no, apsquare, percentage , heatingFlatsSquare, m1heating ,  heatingSquarePrice,
				 tariffArea , FlatSquarePrice ,TotalPrice, ToDate)
					SELECT f_no,
					apsquare,
					percentage,
					apsquare * percentage ,
					@m1heating ,
					@m1heating *apsquare * percentage, 
					@tariff_area ,
					@tariff_area * apsquare,
					@m1heating *apsquare * percentage + @tariff_area * apsquare,
					@date
					FROM Flats

					SELECT * FROM PayoffFlats WHERE  ToDate = @date
			END
		END
GO

-- ����� ��������� - �������� 
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
SELECT * FROM tarif_heating
SELECT * FROM CounterElect
SELECT * FROM PayoffFlats 

-- Drop tables
DROP TABLE Owners
DROP TABLE Flats
DROP TABLE TariffArea
DROP table tarif_heating
DROP TABLE CounterElect
DROP TABLE PayoffFlats

DROP Proc AddCounterElect
DROP PROC CalculationOfElectricity

create database ApartmentAssociation3_AR


