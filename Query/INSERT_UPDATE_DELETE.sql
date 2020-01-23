USE Sample_AR;
SELECT * FROM Employee

SELECT * FROM Department

SELECT * FROM Works_On

INSERT INTO Employee VALUES (12345, 'Kyle', 'Walker', 'd1')

INSERT INTO Department VALUES ('d4','IT', 'Chicago'), ('d5', 'Managment', 'Tallahassee'), ('d6', 'Sales', 'Phoenix')

UPDATE Works_On SET job = 'Sales' WHERE emp_no = 18316 AND project_no = 'p2'

UPDATE Works_On SET job = 'IT' WHERE emp_no = 28559 AND project_no = 'p1'

UPDATE Works_On SET job = 'Managment' WHERE emp_no = 29346 AND project_no = 'p2'

