USE Northwind

SELECT * FROM Customers
SELECT * FROM Products
SELECT * FROM Orders
SELECT * FROM [Order Details]
SELECT * FROM Shippers
SELECT * FROM Suppliers

--Nombre del país y número de clientes de cada país, ordenados alfabéticamente por el nombre del país.

SELECT Country, COUNT(*) AS [Numero Clientes] FROM Customers
GROUP BY Country
ORDER BY Country


--ID de producto y número de unidades vendidas de cada producto. Añade el nombre del producto

SELECT OD.ProductID, P.ProductName, SUM(Quantity) AS [Unidades Vendidas] FROM [Order Details] AS OD
INNER JOIN Products AS P 
ON OD.ProductID = P.ProductID
GROUP BY OD.ProductID, P.ProductName

--ID del cliente y número de pedidos que nos ha hecho. Añade nombre (CompanyName) y ciudad del cliente

SELECT O.CustomerID, C.CompanyName, C.City, COUNT(*) AS [Numero Pedidos] FROM Orders AS O
INNER JOIN Customers AS C
ON O.CustomerID = C.CustomerID
GROUP BY O.CustomerID, C.CompanyName, C.City

--ID del cliente, año y número de pedidos que nos ha hecho cada año. Añade nombre (CompanyName) y ciudad del cliente, así como la fecha del primer pedido que nos hizo.

SELECT O.CustomerID, C.CompanyName, C.City, MIN(O.OrderDate) AS [Primer pedido], YEAR(OrderDate) AS Año, COUNT(*) AS [Numero Pedidos] FROM Orders AS O
INNER JOIN Customers AS C 
ON O.CustomerID = C.CustomerID
GROUP BY O.CustomerID, C.CompanyName, C.City, YEAR(OrderDate)

-- ID del producto, precio unitario y total facturado de ese producto, ordenado por cantidad facturada de mayor a menor.
--Si hay varios precios unitarios para el mismo producto tomaremos el mayor. Añade el nombre del producto

SELECT OD.ProductID, P.ProductName, MAX(OD.UnitPrice) AS Precio, SUM(OD.UnitPrice * Quantity) AS [Cantidad Facturada] FROM [Order Details] AS OD
INNER JOIN Products AS P 
ON OD.ProductID = P.ProductID
GROUP BY OD.ProductId, P.ProductName
ORDER BY [Cantidad Facturada] DESC

--ID del proveedor e importe total del stock acumulado de productos correspondientes a ese proveedor. Añade el nombre del proveedor

SELECT P.SupplierID, S.CompanyName, SUM(UnitPrice * UnitsInStock) AS StockAcumulado FROM Products AS P 
INNER JOIN Suppliers AS S
ON P.SupplierID = S.SupplierID
GROUP BY P.SupplierID, S.CompanyName

-- Número de pedidos registrados mes a mes de cada año.
SELECT YEAR(OrderDate) AS Año, MONTH(OrderDate) AS Mes, COUNT(OrderDate) AS Pedidos FROM Orders
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY YEAR(OrderDate) ASC

--Año y tiempo medio transcurrido entre la fecha de cada pedido (OrderDate) y la fecha en la que lo hemos enviado (ShipDate), en días para cada año.

SELECT YEAR(OrderDate) AS Año, AVG(DATEDIFF(day, OrderDate, ShippedDate)) AS [Tiempo Medio] FROM Orders
GROUP BY YEAR(OrderDate)

--ID del distribuidor y número de pedidos enviados a través de ese distribuidor. Añade el nombre del distribuidor

SELECT ShipVia, S.CompanyName, COUNT(*) AS [Pedidos Enviados] FROM Orders AS O
INNER JOIN Shippers AS S 
ON O.ShipVia = S.ShipperID
GROUP BY ShipVia, S.CompanyName


--ID de cada proveedor y número de productos distintos que nos suministra. Añade el nombre del proveedor.

SELECT P.SupplierID, S.CompanyName, COUNT(*) AS [Numero Productos] FROM Products AS P
INNER JOIN Suppliers AS S
ON P.SupplierID = S.SupplierID
GROUP BY P.SupplierID, S.CompanyName