USE ApartmentAssociation3_AR;

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

INSERT INTO Flats VALUES 
(1, 62, 'Electricty', 0.15, '50206213737'),
(2, 54, 'Central', 1, '50103153737'),
(3, 50, 'Gas', 0.08, '50011163737'),
(4, 55, 'Central', 1,'49908283737'),
(5, 47, 'Electricty', 0.13, '49706123737'),
(6, 49, 'Gas', 0.11, '39607143737'),
(7, 51, 'Central', 1 ,'49701183737'),
(8, 60, 'Electricty', 0.19, '39805143737'),
(9, 64, 'Gas', 0.07,'49503143737'),
(10, 70, 'Central', 1, '39202273737');




--Вставка информации TariffArea
INSERT INTO TariffArea (TariffPriceArea,TariffDate) VALUES (0.56, '2018-09-1');  -- тариф 1м2 площади

insert into tarif_heating values
	('11.01.2018', 50.5, 'koosolek 1','09/15/2018') -- тариф отопления  1MWh

INSERT INTO  CounterElect VALUES ('12/31/2018',750.5,default, '12/31/2018') -- начальные показания счетчика



-- ТЕСТИРУЕМ 2019 год

-- ========== январь
-- Запуск процедуры
EXEC AddCounterElect 760, '2019-02-3'

EXEC CalculationOfElectricity
-- новый тариф площади
INSERT INTO TariffArea (TariffPriceArea,TariffDate) VALUES (0.6, '2019-03-1');  -- тариф 1м2 площади

-- ========== февраль
EXEC AddCounterElect 772, '2019-03-5'

EXEC CalculationOfElectricity

--  ================ март
EXEC AddCounterElect 781, '2019-03-30'

EXEC CalculationOfElectricity
-- -- новый тариф отопления
insert into tarif_heating values
	('05.01.2019', 55.5, 'koosolek 2','03/15/2019') -- тариф отопления  1MWh

--  ================ апрель
EXEC AddCounterElect 790, '2019-05-2'

EXEC CalculationOfElectricity


--  ================ mai
EXEC AddCounterElect 799, '2019-05-30'

EXEC CalculationOfElectricity

--  ================ juuni
EXEC AddCounterElect 801, '2019-06-30'

EXEC CalculationOfElectricity


/*
EXEC AddCounterElect '10', '2020-02-28'

-- Удалить все данные из процедуры
DROP PROC AddCounterElect

-- Сброс процедуры
DROP PROC CalculationOfElectricity

--Запуск процедуры
EXEC CalculationOfElectricity
*/


-- Select tables
SELECT * FROM Owners
SELECT * FROM Flats
SELECT * FROM TariffArea
SELECT * FROM tarif_heating 
SELECT * FROM CounterElect
SELECT * FROM PayoffFlats ORDER BY ToDate
SELECT * from OwnerHistory 

DELETE FROM Owners
DELETE FROM Flats
DELETE FROM TariffArea
DELETE FROM tarif_heating 
DELETE FROM CounterElect
DELETE FROM PayoffFlats
DELETE from OwnerHistory 

