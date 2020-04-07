USE ApartmentAssociation2_AR;

-- Вставка информации в Owners
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

-- Вставка информации в Owners
INSERT INTO Owners VALUES 
('50206213737', 'Aleksander', 'Russovits', '+37253002573', 'sasikrus2002@gmail.com'),
('50103153737', 'Renat', 'Barabanov', '+37258787854', 'renat.barabanov@gmail.com'),
('50011163737', 'Denis', 'Gospadarov', '+37251874521', 'denis.gospadarov@mail.ru'),
('49908283737', 'Nina', 'Sergeyeva', '+37256547962', 'nina.sergeyeva@gmail.com'),
('49706123737', 'Ekaterina', 'Varlamova', '+37253254712', 'ekaterina.varlamova@mail.ru'),
('39607143737', 'Yegor', 'Sidorov', '+37258984120', 'yegor.sidorov@hotmail.com'),
('49701183737', 'Maria', 'Tamm', '+37251256978', 'maria.tamm@gmail.com'),
('39805143737', 'Vsevolod', 'Orlov', '+37253114477', 'vsevolod.orlov@bk.ru'),
('49503143737', 'Andzhelika', 'Mirzova', '+37258147465', 'andzhelika.mirzova@hotmail.com'),
('39202273737', 'Nikita', 'Milanov', '+37253698741', 'nikita.milanov@gmail.com');

--Вставка информации TariffArea
INSERT INTO TariffArea (TariffPriceArea,TariffDate) VALUES (66.26, '2019-01-31');

-- Запуск процедуры
EXEC AddCounterElect '5', '2020-01-31'
EXEC AddCounterElect '10', '2020-02-28'

-- Удалить все данные из процедуры
DROP PROC AddCounterElect

-- Сброс процедуры
DROP PROC CalculationOfElectricity

--Запуск процедуры
EXEC CalculationOfElectricity


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