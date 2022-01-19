USE Northwind

SELECT * FROM Customers
SELECT * FROM Products
SELECT * FROM Orders
SELECT * FROM [Order Details]
SELECT * FROM Shippers
SELECT * FROM Suppliers
SELECT * FROM Employees
SELECT * FROM EmployeeTerritories
SELECT * FROM Territories
SELECT * FROM Categories

--1.- Nombre de los proveedores y número de productos que nos vende cada uno

SELECT S.CompanyName, COUNT(*) AS [Numero de productos] FROM Suppliers AS S
INNER JOIN Products AS P
ON S.SupplierID = P.SupplierID
GROUP BY P.SupplierID, S.CompanyName

--2.- Nombre completo y telefono de los vendedores que trabajen en New York, Seattle, Vermont, Columbia, Los Angeles, Redmond o Atlanta.
SELECT E.FirstName, E.LastName, E.HomePhone, T.TerritoryDescription FROM Employees AS E
INNER JOIN EmployeeTerritories AS ET
ON E.EmployeeID = ET.EmployeeID
INNER JOIN Territories AS T
ON ET.TerritoryID = T.TerritoryID
WHERE T.TerritoryDescription IN ('New York', 'Seattle', 'Vermont', 'Columbia', 'Los Angeles', 'Redmond', 'Atlanta')

--3.- Número de productos de cada categoría y nombre de la categoría.
SELECT C.CategoryName, COUNT(*) AS [Numero de productos] FROM Categories AS C
INNER JOIN Products AS P 
ON C.CategoryID = P.CategoryID
GROUP BY C.CategoryID, C.CategoryName

--4.- Nombre de la compañía de todos los clientes que hayan comprado queso de cabrales o tofu.
SELECT C.CompanyName FROM Customers AS C
INNER JOIN Orders AS O 
ON C.CustomerID = O.CustomerID
INNER JOIN [Order Details] AS OD
ON O.OrderID = OD.OrderID
WHERE OD.ProductID = 11 OR OD.ProductID = 14  --Puedo hacer otro join a productos y hacer el where usando el nombre

--5.- Empleados (ID, nombre, apellidos y teléfono) que han vendido algo a Bon app' o Meter Franken.

SELECT E.EmployeeID, E.FirstName, E.LastName, E.HomePhone FROM Employees AS E
INNER JOIN Orders AS O
ON E.EmployeeID = O.EmployeeID
INNER JOIN Customers AS C
ON O.CustomerID = C.CustomerID
WHERE C.CompanyName IN ('Bon app''', 'Meter Franken')

--6.- Empleados (ID, nombre, apellidos, mes y día de su cumpleaños) que no han vendido nunca nada a ningún cliente de Francia. *

--7.- Total de ventas en US$ de productos de cada categoría (nombre de la categoría).

SELECT C.CategoryName, SUM(OD.UnitPrice * OD.Quantity) AS [Total Ventas USA] FROM Categories AS C
INNER JOIN Products AS P 
ON C.CategoryID = P.CategoryID
INNER JOIN [Order Details] AS OD
ON P.ProductID = OD.ProductID
INNER JOIN Orders AS O
ON OD.OrderID = O.OrderID
WHERE O.ShipCountry = 'USA'
GROUP BY C.CategoryName

--8.- Total de ventas en US$ de cada empleado cada año (nombre, apellidos, dirección).
SELECT E.FirstName, E.LastName, E.Address, SUM(OD.UnitPrice * OD.Quantity) FROM Employees AS E
INNER JOIN Orders AS O
ON E.EmployeeID = O.EmployeeID
INNER JOIN [Order Details] AS OD
ON O.OrderID = OD.OrderID
WHERE O.ShipCountry = 'USA'
GROUP BY E.EmployeeID, E.FirstName, E.LastName, E.Address

--9.- Ventas de cada producto en el año 97. Nombre del producto y unidades.
SELECT P.ProductName, SUM(OD.Quantity) AS Ventas FROM Products AS P
INNER JOIN [Order Details] AS OD
ON P.ProductID = OD.ProductID
INNER JOIN Orders AS O
ON OD.OrderID = O.OrderID
WHERE YEAR(O.OrderDate) = 1997
GROUP BY P.ProductName

--10.- Cuál es el producto del que hemos vendido más unidades en cada país. *
--11.- Empleados (nombre y apellidos) que trabajan a las órdenes de Andrew Fuller.


--12.- Número de subordinados que tiene cada empleado, incluyendo los que no tienen ninguno. Nombre, apellidos, ID.

