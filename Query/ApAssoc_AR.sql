USE master;
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

CREATE TABLE Flats (f_no INT PRIMARY KEY, apsquare FLOAT NOT NULL, typeofheating VARCHAR(30) DEFAULT 'Central' NOT NULL, 
CHECK (typeofheating IN ('Central', 'Gas', 'Electricty')), percentage FLOAT NOT NULL, OwnerID VARCHAR(11) NOT NULL,
CONSTRAINT FK_OwnerID FOREIGN KEY (OwnerID) REFERENCES Owners (OwnerID))

CREATE TABLE Owners (OwnerID VARCHAR(11) PRIMARY KEY, OwnerFirstName VARCHAR(30) NOT NULL, OwnerLastName VARCHAR(30)
NOT NULL, OwnerPhone VARCHAR(11) NULL, OwnerEmail VARCHAR(40) NULL, f_no INT NOT NULL,
CONSTRAINT FK_FlatsNo FOREIGN KEY (f_no) REFERENCES Flats (f_no));

ALTER TABLE Flats DROP CONSTRAINT FK_OwnerID
DROP TABLE Owners
DROP TABLE Flats