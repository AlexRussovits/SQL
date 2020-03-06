USE master;
-- Create Database
CREATE DATABASE ApartmentAssociation_AR
ON (NAME=ApartmentAssociation_AR_dat,
FILENAME = 'D:\SQL\ApartmentAssociation_AR.mdf',
SIZE = 5,
MAXSIZE = 100,
FILEGROWTH = 5)

LOG ON (NAME= ApartmentAssociation_AR_log,
FILENAME = 'D:\SQL\ApartmentAssociation_AR.ldf',
SIZE = 10,
MAXSIZE = 100,
FILEGROWTH = 10);

USE ApartmentAssociation_AR;

-- Create Tables

CREATE TABLE Flats (f_no INT PRIMARY KEY, apsquare FLOAT NOT NULL, typeofheating VARCHAR(30) DEFAULT 'Central' NOT NULL, 
CHECK (typeofheating IN ('Central', 'Gas', 'Electricty')), percentage FLOAT NOT NULL, OwnerID VARCHAR(11) NOT NULL)


CREATE TABLE Owners (OwnerID VARCHAR(11) PRIMARY KEY, OwnerFirstName VARCHAR(30) NOT NULL, OwnerLastName VARCHAR(30)
NOT NULL, OwnerPhone VARCHAR(12) NULL, OwnerEmail VARCHAR(50) NULL, f_no INT NOT NULL)

CREATE TABLE TariffArea
(TariffID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
TariffPriceArea MONEY NOT NULL,
TariffDate DATE DEFAULT GETDATE() NOT NULL);

CREATE TABLE TariffMWh
(TariffID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
TariffPriceMWh MONEY NOT NULL,
TariffDate DATE DEFAULT GETDATE() NOT NULL);

CREATE TABLE Counter
()


-- Add foreign keys
ALTER TABLE Flats ADD CONSTRAINT FK_OwnerID FOREIGN KEY (OwnerID) REFERENCES Owners(OwnerID);
ALTER TABLE Owners ADD CONSTRAINT FK_FlatsNo FOREIGN KEY (f_no) REFERENCES Flats (f_no);

-- Drop foreign keys
ALTER TABLE Flats DROP CONSTRAINT FK_OwnerID
ALTER TABLE Owners DROP CONSTRAINT FK_FlatsNo

INSERT INTO Flats VALUES 
(1, 62, 'Electricty', 0.15, '50206213737'),
(2, 54, 'Central', 0.1, '50103153737'),
(3, 50, 'Gas', 0.08, '50011163737'),
(4, 55, 'Central', 0.1,'49908283737'),
(5, 47, 'Electricty', 0.13, '49706123737'),
(6, 49, 'Gas', 0.11, '39607143737'),
(7, 51, 'Central', 0.1 ,'49701183737'),
(8, 60, 'Electricty', 0.19, '39805143737'),
(9, 64, 'Gas', 0.07,'49503143737'),
(10, 70, 'Central', 0.1, '39202273737');

INSERT INTO Owners VALUES 
('50206213737', 'Aleksander', 'Russovits', '+37253002573', 'sasikrus2002@gmail.com', 1),
('50103153737', 'Renat', 'Barabanov', '+37258787854', 'renat.barabanov@gmail.com', 2),
('50011163737', 'Denis', 'Gospadarov', '+37251874521', 'denis.gospadarov@mail.ru', 3),
('49908283737', 'Nina', 'Sergeyeva', '+37256547962', 'nina.sergeyeva@gmail.com', 4),
('49706123737', 'Ekaterina', 'Varlamova', '+37253254712', 'ekaterina.varlamova@mail.ru', 5),
('39607143737', 'Yegor', 'Sidorov', '+37258984120', 'yegor.sidorov@hotmail.com', 6),
('49701183737', 'Maria', 'Tamm', '+37251256978', 'maria.tamm@gmail.com', 7),
('39805143737', 'Vsevolod', 'Orlov', '+37253114477', 'vsevolod.orlov@bk.ru', 8),
('49503143737', 'Andzhelika', 'Mirzova', '+37258147465', 'andzhelika.mirzova@hotmail.com', 9),
('39202273737', 'Nikita', 'Milanov', '+37253698741', 'nikita.milanov@gmail.com', 10);

INSERT INTO TariffArea (TariffPriceArea,TariffDate) VALUES (66.26, DEFAULT);

/*INSERT INTO TariffMWh (TariffPriceMWh,TariffDate) VALUES ();*/

SELECT * FROM Owners
SELECT * FROM Flats
SELECT * FROM TariffArea

-- Drop tables
DROP TABLE Owners
DROP TABLE Flats
DROP TABLE TariffArea
DROP TABLE TariffMWh
