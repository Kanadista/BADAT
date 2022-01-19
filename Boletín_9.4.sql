USE Northwind

SELECT * FROM Customers
SELECT * FROM Employees
SELECT * FROM Orders
SELECT * FROM [Order Details]
SELECT * FROM Products


--1.- N�mero de clientes de cada pa�s.

SELECT Country, COUNT(*) AS [Numero clientes] FROM Customers
GROUP BY Country

--2.- N�mero de clientes diferentes que compran cada producto. Incluye el nombre del producto

SELECT P.ProductID, ProductName, COUNT(*) AS [Numero de ventas] FROM Products AS P
INNER JOIN [Order Details] AS OD
ON P.ProductID = OD.ProductID
INNER JOIN Orders AS O
ON OD.OrderID = O.OrderID
INNER JOIN Customers AS C
ON O.CustomerID = C.CustomerID
GROUP BY P.ProductID, ProductName
ORDER BY P.ProductID

--3.- N�mero de pa�ses diferentes en los que se vende cada producto. Incluye el nombre del producto
 
SELECT P.ProductID, ProductName, COUNT(DISTINCT C.Country) AS [Paises] FROM Products AS P
INNER JOIN [Order Details] AS OD
ON P.ProductID = OD.ProductID
INNER JOIN Orders AS O
ON OD.OrderID = O.OrderID
INNER JOIN Customers AS C
ON O.CustomerID = C.CustomerID
GROUP BY P.ProductID, ProductName
ORDER BY P.ProductID

--4.- Empleados (nombre y apellido) que han vendido alguna vez �Gudbrandsdalsost�, �Lakkalik��ri�, �Tourti�re� o �Boston Crab Meat�.

SELECT DISTINCT E.EmployeeID, FirstName, LastName FROM Employees AS E
INNER JOIN Orders AS O
ON E.EmployeeID = O.EmployeeID
INNER JOIN [Order Details] AS OD
ON O.OrderID = OD.OrderID
INNER JOIN Products AS P
ON OD.ProductID = P.ProductID
WHERE P.ProductName in ('Gudbrandsdalsost', 'Lakkalik��ri', 'Tourti�re', 'Boston Crab Meat')

--5.- Empleados que no han vendido nunca �Northwoods Cranberry Sauce� o �Carnarvon Tigers�.

--USANDO CONSULTA EN EL WHERE

SELECT DISTINCT E.EmployeeID, FirstName, LastName FROM Employees AS E
WHERE E.EmployeeID not IN (SELECT DISTINCT E.EmployeeID FROM Employees AS E
INNER JOIN Orders AS O
ON E.EmployeeID = O.EmployeeID
INNER JOIN [Order Details] AS OD
ON O.OrderID = OD.OrderID
INNER JOIN Products AS P
ON OD.ProductID = P.ProductID
WHERE P.ProductName IN ('Northwoods Cranberry Sauce', 'Carnarvon Tigers'))


--USANDO EXCEPT
 
SELECT DISTINCT E.EmployeeID, E.FirstName, E.LastName FROM Employees AS E
EXCEPT
SELECT DISTINCT E.EmployeeID, E.FirstName, E.LastName FROM Employees AS E
INNER JOIN Orders AS O
ON E.EmployeeID=O.EmployeeID
INNER JOIN [Order Details] AS OD
ON O.OrderID = OD.OrderID
INNER JOIN Products AS P
ON OD.ProductID = P.ProductID
WHERE P.ProductName IN ('Northwoods Cranberry Sauce','Carnarvon Tigers')



/*
SELECT distinct E.EmployeeID, FirstName, LastName, P.ProductName FROM Employees AS E
INNER JOIN Orders AS O
ON E.EmployeeID = O.EmployeeID
INNER JOIN [Order Details] AS OD
ON O.OrderID = OD.OrderID
INNER JOIN Products AS P
ON OD.ProductID = P.ProductID
WHERE P.ProductName IN ('Northwoods Cranberry Sauce', 'Carnarvon Tigers')
*/

--6.- N�mero de unidades de cada categor�a de producto que ha vendido cada empleado. Incluye el nombre y apellidos del empleado y el nombre de la
--categor�a.

SELECT E.EmployeeID, E.FirstName, E.LastName, C.CategoryName, COUNT(C.CategoryName) AS [Productos vendidos] FROM Employees AS E
INNER JOIN Orders AS O
ON E.EmployeeID = O.EmployeeID
INNER JOIN [Order Details] AS OD
ON O.OrderID = OD.OrderID
INNER JOIN Products AS P
ON OD.ProductID = P.ProductID
INNER JOIN Categories AS C
ON P.CategoryID = C.CategoryID
GROUP BY E.EmployeeID, E.FirstName, E.LastName, P.CategoryID, C.CategoryName
ORDER BY E.EmployeeID

--7.- Total de ventas (US$) de cada categor�a en el a�o 97. Incluye el nombre de la categor�a.

SELECT C.CategoryID, C.CategoryName, SUM(OD.UnitPrice * Quantity*(1-OD.Discount)) AS [Total Ventas] FROM Categories AS C
INNER JOIN Products AS P
ON C.CategoryID = P.CategoryID
INNER JOIN [Order Details] AS OD
ON P.ProductID = OD.ProductID
INNER JOIN Orders AS O
ON OD.OrderID = O.OrderID
WHERE DATEPART(YEAR, O.OrderDate) = 1997 
GROUP BY C.CategoryID, C.CategoryName
ORDER BY C.CategoryID

--8.- Productos que han comprado m�s de un cliente del mismo pa�s, indicando el nombre del producto, el pa�s y el n�mero de clientes distintos de ese pa�s que
--lo han comprado

SELECT P.ProductID, P.ProductName, C.Country, COUNT(DISTINCT C.CustomerID) AS [Numero clientes] FROM Products AS P
INNER JOIN [Order Details] AS OD
ON P.ProductID = OD.ProductID
INNER JOIN Orders AS O
ON OD.OrderID = O.OrderID
INNER JOIN Customers AS C
ON O.CustomerID = C.CustomerID
GROUP BY P.ProductID, P.ProductName, C.Country
HAVING COUNT(DISTINCT C.CustomerID) >= 2
ORDER BY ProductID

--9.- Total de ventas (US$) en cada pa�s cada a�o. SELECT O.ShipCountry, YEAR(O.ShippedDate) as A�o, SUM(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) as [Ventas Totales] FROM Orders AS O
INNER JOIN [Order Details] AS OD
ON O.OrderID = OD.OrderID
GROUP BY O.ShipCountry, YEAR(O.ShippedDate)ORDER BY O.ShipCountry--10.- Producto superventas de cada a�o, indicando a�o, nombre del producto, categor�a y cifra total de ventas. SELECT MayorCantidad.ProductID, P.ProductName, C.CategoryName, MayorCantidad.A�o, PPP.MayorVenta FROM(SELECT OD.ProductID, YEAR(O.OrderDate) AS A�o, SUM(OD.Quantity) AS TotalUnidades FROM [Order Details] AS OD
INNER JOIN Orders AS O
ON O.OrderID = OD.OrderID
GROUP BY OD.ProductID, YEAR(O.OrderDate)) AS MayorCantidadINNER JOIN(SELECT ProductoPorA�o.A�o, MAX(TotalUnidades) AS MayorVenta FROM 
	(SELECT OD.ProductID, YEAR(O.OrderDate) AS A�o, SUM(OD.Quantity) AS TotalUnidades
		FROM [Order Details] AS OD
			INNER JOIN Orders AS O
			on O.OrderID = OD.OrderID
		GROUP BY OD.ProductID, YEAR(O.OrderDate)) AS ProductoPorA�o
	GROUP BY A�o) AS PPPON MayorCantidad.A�o = PPP.A�o AND MayorCantidad.TotalUnidades = PPP.MayorVentaINNER JOIN Products AS PON MayorCantidad.ProductID = P.ProductIDINNER JOIN Categories AS CON P.CategoryID = C.CategoryID--UPDATES Y INSERT CON CONSULTAS.