USE WholeSale;

-- ���������� ���������� ������� ����������� � 1996 ���� 


SELECT COUNT(OrderDate) AS Kolichestvo_Zakazov, YEAR(OrderDate) AS God
FROM Orders
WHERE YEAR(OrderDate) = 1996
GROUP BY YEAR(OrderDate); -- 1



