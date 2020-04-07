USE Sample_AR;

-- Выборка идентификатора таблицы, идентификатора
--пользователя и типа таблицы для таблицы employee

SELECT OBJECT_ID, principal_id, type FROM sys.objects WHERE name = 'employee'

--Выборка имен всех таблиц базы данных
--Sample_AR, которые содержат столбец project_no

SELECT sys.objects.name FROM  sys.objects INNER JOIN sys.columns
ON  sys.objects.object_id = sys.columns.object_id
WHERE sys.objects.type = 'U' AND sys.columns.name = 'project_no'

-- Определение владельца таблицы employee

SELECT sys.database_principals.name FROM sys.database_principals INNER JOIN sys.objects
ON sys.database_principals.principal_id = sys.objects.schema_id
WHERE sys.objects.name = 'employee' AND sys.objects.type = 'U'

-- Системные хранимые процедуры

EXEC sp_rename @objname = Department, @newname = subdivision

--Использование системной процедуры sp_configure

EXEC sp_configure 'show advanced options',1 ;

RECONFIGURE WITH OVERRIDE;
-- устанавливаем разрешение 
-- Теперь можно изменять значения дополнительных параметров

EXEC sp_configure 'fill factor', 100

-- Параметру fill factor присваивается значение 100
-- Параметр fill factor указывает объём хранилища в процентах для страниц индексов

RECONFIGURE WITH OVERRIDE;

-- устанавливаем разрешение 

sp_help 'Employee'  -- параметр процедуры - имя таблицы
sp_help 'CHAR' -- тип данных 

-- Системные функции

SELECT OBJECT_ID FROM sys.objects -- представление каталог
WHERE name = 'Employee'; 

-- альтернативно
SELECT OBJECT_ID('Employee') -- системная функция

-- Список некоторых системных функций для доступа к системным базовым таблицам

SELECT DB_ID ('Sample_AR')
SELECT DB_NAME(7)

SELECT OBJECT_ID('bonus')
SELECT OBJECT_NAME(597577167)

sp_helpuser
SELECT USER_NAME(1)
SELECT USER_ID('dbo')

GO
	IF	OBJECTPROPERTY (OBJECT_ID('dbo.Employee'), 'IsTable') = 1
		PRINT 'This is a table.'
	ELSE IF OBJECTPROPERTY (OBJECT_ID('dbo.Employee'), 'IsTable') = 0
		PRINT 'This is not a table.'
	ELSE IF OBJECTPROPERTY (OBJECT_ID('dbo.Employee'), 'IsTable') IS NULL
		PRINT 'ERROR: this is not a valid object';
GO


