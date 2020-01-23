USE Student2_AR;

-- Очистить таблицы

DROP TABLE Student
DROP TABLE Specialities
DROP TABLE Groups
DROP TABLE Training
DROP TABLE Department
 
SELECT * FROM Specialities
SELECT * FROM Student
SELECT * FROM Groups
SELECT * FROM Training
SELECT * FROM Department

-- Студенты

INSERT INTO Student VALUES ('50206213737','Aleksander','Russovits', 'Vahtra 16' ,'+37253002573', 'aleksander.russovits@ivkhk.ee'), 
('60105125476', 'Elena', 'Kuznetsova', 'Puru tee 64' ,'+37253879887', 'elena.kuznetsova@ivhk.ee'),
('50003148987', 'Sergey', 'Belyakov', 'Aleksander Puškini 12', '+37258986547', 'sergey.belyakov@ivkhk.ee'); 

-- Специальности

CREATE TABLE Specialities (Speciality_ID INT NOT NULL CONSTRAINT PK_Speciality_ID PRIMARY KEY, specialityName CHAR(50), shortName CHAR(2), 
dateSpeciality DATE DEFAULT GETDATE());


ALTER TABLE Specialities ADD Dept_ID INT NULL, CONSTRAINT FK_Dept_ID FOREIGN KEY (Dept_ID) REFERENCES Department (Dept_ID);



INSERT INTO Specialities VALUES (128197,'Noorem Tarkvaraarendaja', 'TV', DEFAULT), (147845,'Mehhatroonik','MH', DEFAULT), 
(178954,'Kook', 'KK', DEFAULT);

-- Группы

CREATE TABLE Groups (Group_ID NCHAR(10) NOT NULL,
Education NVARCHAR (50) DEFAULT 'Põhiharidus' NOT NULL, CHECK(Education IN ('Põhiharidus', 'Keskharidus')),
Lang CHAR(30) DEFAULT 'Russian' NOT NULL , CHECK(Lang IN ('Russian', 'Estonian')),
PlaceOfTraining NVARCHAR(30) DEFAULT 'Jõhvi' NOT NULL, CHECK (PlaceofTraining IN('Jõhvi', 'Narva','Sillamäe')),
date_reg DATETIME DEFAULT GETDATE(), Speciality_ID INT NOT NULL,
CONSTRAINT PK_GroupID PRIMARY KEY (Group_ID),
CONSTRAINT FK_SpecialityID FOREIGN KEY (Speciality_ID) REFERENCES Specialities (Speciality_ID));

ALTER TABLE Groups DROP CONSTRAINT FK_SpecialityID -- удаление ключа 

INSERT INTO Groups VALUES ('JPTVR18', 'Põhiharidus', 'Russian', 'Jõhvi', DEFAULT, 128197), 
('SPKO18', 'Põhiharidus', 'Russian', 'Sillamäe', DEFAULT,147845),

('NPMH19', 'Keskharidus', 'Estonian', 'Narva', DEFAULT, 178954);

UPDATE Groups SET Education = 'Põhiharidus' WHERE Education = 'Keskharidus'  


-- Обучение

CREATE TABLE Training (Student NCHAR(11) NOT NULL, Group_ID NCHAR (10) NOT NULL, 
beginningTraining DATETIME DEFAULT GETDATE(), 
EndingTraining DATETIME DEFAULT GETDATE(), 
StatusTraining CHAR(30) DEFAULT 'Studying',CHECK (StatusTraining IN ('Finished', 'Expelled','Studying')),
CONSTRAINT FK_Student FOREIGN KEY(Student) REFERENCES Student (Isikukood),
CONSTRAINT FK_GroupID FOREIGN KEY (Group_ID) REFERENCES Groups (Group_ID));

ALTER TABLE Training DROP CONSTRAINT FK_GroupID
ALTER TABLE Training DROP CONSTRAINT FK_Student

INSERT INTO Training VALUES ('50003148987', 'NPMH19', '2019-09-01', '2019-12-10', 'Expelled'), 
('60105125476', 'SPKO18', '2018-09-01', DEFAULT, 'Finished'),
('50206213737', 'JPTVR18', '2018-09-01', NULL, 'Studying');

CREATE TABLE Department (Dept_ID INT IDENTITY (10000,10) NOT NULL CONSTRAINT PK_Dep_ID PRIMARY KEY, Dept_Name NVARCHAR(40) NOT NULL,
 Principal NVARCHAR(60) NOT NULL, TelNumber NVARCHAR(25), Reg_Date DATE DEFAULT GETDATE());
 
INSERT INTO Department (Dept_Name,Principal,TelNumber,Reg_Date) VALUES ('IT and Multimedia', 'Kirill Varlamov', '+37253875474', DEFAULT),
('Construction and Wood', 'Timofei Egorov', '+37256897414', DEFAULT), ('Catering', 'Maria Haritonova', '+37251478965', DEFAULT);
--=========================================================================================================================================================


SELECT firstName, lastName FROM Student INNER JOIN Training ON Student.Isikukood = Training.Student;

SELECT Group_ID, COUNT(Group_ID) AS Students FROM Training GROUP BY Group_ID; -- 2

SELECT Group_ID, COUNT(Group_ID) AS Finish_Studying FROM Training WHERE StatusTraining = 'Finished' GROUP BY Group_ID; --3

SELECT Group_ID, COUNT(Group_ID) FROM Training WHERE Group_ID IN (SELECT Group_ID FROM Groups WHERE Speciality_ID IN 
(SELECT Speciality_ID FROM Specialities)) GROUP BY Group_ID; --4

SELECT EndingTraining, COUNT(Student) FROM Training WHERE Group_ID IN (SELECT Group_ID FROM Groups WHERE Speciality_ID IN 
(SELECT Speciality_ID FROM Specialities)) GROUP BY EndingTraining; --5




