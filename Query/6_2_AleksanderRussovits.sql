USE WholeSale;

-- Определите количество заказов оформленных в 1996 году 


SELECT COUNT(OrderDate) AS Kolichestvo_Zakazov, YEAR(OrderDate) AS God
FROM Orders
WHERE YEAR(OrderDate) = 1996
GROUP BY YEAR(OrderDate); -- 1



