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

-- Создание таблицы 
CREATE TABLE Owners (OwnerID VARCHAR(11) PRIMARY KEY, OwnerFirstName VARCHAR(30) NOT NULL, OwnerLastName VARCHAR(30)
NOT NULL, OwnerPhone VARCHAR(12) NULL, OwnerEmail VARCHAR(50) NULL)

-- Создание таблицы TariffArea -- тариф площади   КЛЮЧ надо ставить дату (первое число м-ца с которого вступает в силу тариф)
CREATE TABLE TariffArea
(TariffID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
TariffPriceArea MONEY NOT NULL,
TariffDate DATE NOT NULL);

-- ТАРИФ ОТОПЛЕНИЯ

	create table tarif_heating   
	(first_date_heating date PRIMARY KEY,
	price_heating money,
	comment varchar(50),
	date_comment datetime default GETDATE())



--Создание таблицы CounterElect
CREATE TABLE CounterElect (CounterDate DATE PRIMARY KEY NOT NULL,
CounterMWH FLOAT NOT NULL, userEnter VARCHAR(20) DEFAULT 'admin' NOT NULL, userDate DATE NOT NULL)

--Создание Истории для Владельцев
CREATE TABLE OwnerHistory 
(
    HistoryID INT IDENTITY PRIMARY KEY,
    Operation NVARCHAR(200) NOT NULL,
    CreateAt DATETIME NOT NULL DEFAULT GETDATE()
)

select * FROM OwnerHistory

-- Добавление ДАННЫХ счётчика при помощи процедуры - последний день м-ца, --- можно сделать проверку по счетчику > чем было
GO 
	CREATE PROC AddCounterElect (@CounterMWH FLOAT, @Date DATE) AS 
		BEGIN
			IF DAY(@Date) <= 25
				BEGIN
					INSERT INTO CounterElect VALUES (EOMONTH (@Date,-1),@CounterMWH, DEFAULT, @Date) -- предыдущий
				END
			ELSE
				BEGIN
					INSERT INTO CounterElect VALUES (EOMONTH (@Date), @CounterMWH, DEFAULT, @Date)  -- ИЗМЕНИЛА текущий
				END
		END
GO

DROP Proc AddCounterElect

-- В этой таблице будет содержаться информация, которая будет показывать, сколько нужно будет выплатить владельцу квартиры

CREATE TABLE PayoffFlats(f_no INT NOT NULL, 
apsquare FLOAT NOT NULL, 
percentage FLOAT NOT NULL,
heatingFlatsSquare FLOAT NOT NULL, --ОТАПЛИВАЕМАЯ ПЛОЩАДЬ квартиры
m1heating MONEY NOT NULL,  -- стоимость 1м2 отапливаемой площади
heatingSquarePrice MONEY NOT NULL, -- стоимость отопления квартиры
tariffArea MONEY  NOT NULL, -- тариф 1м2 площади
FlatSquarePrice MONEY NOT NULL,  -- стоимость площади квартиры
TotalPrice MONEY NOT NULL, -- всего к оплате
ToDate DATE NOT NULL,
CONSTRAINT PR_Payoff PRIMARY KEY (f_no, ToDate),
CONSTRAINT FK_f_no FOREIGN KEY(f_no) REFERENCES Flats (f_no) ON DELETE CASCADE,
CONSTRAINT FK_ToDate FOREIGN KEY(ToDate) REFERENCES CounterElect (CounterDate) ON DELETE CASCADE)

-- Процедура, которая будет производить вычисления выплаты за квартиру
GO
	CREATE PROC CalculationOfElectricity AS 
	-- Декларируем переменные
		BEGIN
			DECLARE @counter1 AS FLOAT  -- last
			DECLARE @counter2 AS FLOAT  -- prev
			
			DECLARE @perApSquare AS FLOAT  -- отапливаемая площадь дома

			DECLARE @tariff_area AS MONEY,
					@tarif_heating AS MONEY,
					@m1heating AS MONEY    -- стоимость 1м2 отапливаемой площади
			DECLARE @date AS DATE -- последний день м-ца из таблицы счеткмка


			-- Берём тариф и дату из таблиц 
			BEGIN
				SELECT @perApSquare = SUM(apsquare * percentage) FROM Flats -- отапливаемая площадь дома

				SELECT TOP 1 @date = CounterDate FROM CounterElect ORDER BY CounterDate DESC -- последняя дата

				-- WHERE first_date_heating < @date  - это условие д.б. - изменение тарифов вносится заранее, тарифы вступают в силу согласно дате

				SELECT TOP 1 @tarif_heating =  price_heating FROM  tarif_heating WHERE first_date_heating < @date ORDER BY first_date_heating DESC --tariff 1MWh
				
			
				SELECT TOP 1 @counter1 = CounterMWH FROM CounterElect ORDER BY CounterDate DESC  -- последние показания счетчика
				SELECT TOP 2 @counter2 = CounterMWH FROM CounterElect ORDER BY CounterDate DESC -- предпоследние показания счетчика

				SET @m1heating = @tarif_heating * (@counter1 - @counter2)/@perApSquare          -- стоимость 1м2 отапливаемой площади

				-- -- тариф 1м2 площади
				SELECT TOP 1 @tariff_area = TariffPriceArea FROM TariffArea WHERE TariffDate <  @date ORDER BY TariffDate  DESC  --     сортировка только по дате должна быть

				-- Проверка, сколько записей хранится в таблице счётчиков и воспроизводим вычисления


				--Вставка всей информации, что мы получили 
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

-- Сброс процедуры - УДАЛЕНИЕ 
DROP PROC CalculationOfElectricity

--Запуск процедуры
EXEC CalculationOfElectricity


-- Триггер, показывает что вставилось в таблицу
GO
CREATE TRIGGER InsertOwner ON Owners
AFTER INSERT
AS
	BEGIN
		INSERT INTO OwnerHistory (Operation,CreateAt) VALUES ('INSERT', DEFAULT)
		SELECT * FROM OwnerHistory
	END
GO

-- Триггер, показывает что обновилось в таблице
GO
CREATE TRIGGER UpdateOwner ON Owners
AFTER UPDATE
AS
	BEGIN
		INSERT INTO OwnerHistory (Operation,CreateAt) VALUES ('UPDATE', DEFAULT)
		SELECT * FROM OwnerHistory
	END
GO

-- Триггер, показывает что удалилось из таблицы
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


