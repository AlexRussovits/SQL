USE master;
CREATE DATABASE Cars_AR
ON (NAME=Cars_AR_dat,
FILENAME = 'D:\PTVR18_SQL\Cars_AR.mdf',
SIZE = 5,
MAXSIZE = 100,
FILEGROWTH = 5)

LOG ON (NAME= Cars_AR_log,
FILENAME = 'D:\PTVR18_SQL\Cars_AR.ldf',
SIZE = 10,
MAXSIZE = 100,
FILEGROWTH = 10);

USE Cars_AR;

SELECT * FROM Cars
DROP TABLE Cars

CREATE TABLE Cars(
Brands VARCHAR(30) NOT NULL,
Models VARCHAR(30) NOT NULL,
yeafOfIssue DATE NOT NULL,
Price MONEY NOT NULL,
statusOfCar VARCHAR(30) DEFAULT 'Yes', CHECK (statusofCar IN ('Yes', 'No'))
)

INSERT INTO Cars VALUES ('Lamborghini', 'Gallardo', '2019-04-17', '1500000', 'No'),
('Lamborghini', 'Murcielago', '2018-06-30', '1000000', DEFAULT), ('Lamborghini', 'Aventador', '2017-01-18', '800000', DEFAULT)

ALTER TABLE Cars ADD conditionOfCar VARCHAR(50) DEFAULT 'Normal' NULL;

INSERT INTO Cars VALUES ('Aston Martin', 'DB9' , '2018-08-12', '1200000' ,'No', 'Normal'),
('Aston Martin', 'Vulcan' , '2017-01-05', '500000' ,DEFAULT, 'Normal'), ('Aston Martin', 'DBX' , '2018-03-05', '750000' ,DEFAULT, 'Normal')


ALTER TABLE Cars DROP CONSTRAINT DF__Cars__conditionO__1DE57479
ALTER TABLE Cars ADD CONSTRAINT Df_ConditionOfCar DEFAULT 'Normal' FOR conditionOfCar

INSERT INTO Cars VALUES ('Nissan', '370Z', '2018-09-01', 950000, DEFAULT, DEFAULT), 
('Subaru', 'Impreza', '2016-04-04', 250000, 'No', DEFAULT)

SELECT * FROM Cars