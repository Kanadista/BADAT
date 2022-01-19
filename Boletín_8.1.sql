USE Northwind

SELECT * FROM Customers
SELECT * FROM Products
SELECT * FROM Orders
SELECT * FROM [Order Details]
SELECT * FROM Shippers
SELECT * FROM Suppliers

--Nombre del pa�s y n�mero de clientes de cada pa�s, ordenados alfab�ticamente por el nombre del pa�s.

SELECT Country, COUNT(*) AS [Numero Clientes] FROM Customers
GROUP BY Country
ORDER BY Country


--ID de producto y n�mero de unidades vendidas de cada producto. A�ade el nombre del producto

SELECT OD.ProductID, P.ProductName, SUM(Quantity) AS [Unidades Vendidas] FROM [Order Details] AS OD
INNER JOIN Products AS P 
ON OD.ProductID = P.ProductID
GROUP BY OD.ProductID, P.ProductName

--ID del cliente y n�mero de pedidos que nos ha hecho. A�ade nombre (CompanyName) y ciudad del cliente

SELECT O.CustomerID, C.CompanyName, C.City, COUNT(*) AS [Numero Pedidos] FROM Orders AS O
INNER JOIN Customers AS C
ON O.CustomerID = C.CustomerID
GROUP BY O.CustomerID, C.CompanyName, C.City

--ID del cliente, a�o y n�mero de pedidos que nos ha hecho cada a�o. A�ade nombre (CompanyName) y ciudad del cliente, as� como la fecha del primer pedido que nos hizo.

SELECT O.CustomerID, C.CompanyName, C.City, MIN(O.OrderDate) AS [Primer pedido], YEAR(OrderDate) AS A�o, COUNT(*) AS [Numero Pedidos] FROM Orders AS O
INNER JOIN Customers AS C 
ON O.CustomerID = C.CustomerID
GROUP BY O.CustomerID, C.CompanyName, C.City, YEAR(OrderDate)

-- ID del producto, precio unitario y total facturado de ese producto, ordenado por cantidad facturada de mayor a menor.
--Si hay varios precios unitarios para el mismo producto tomaremos el mayor. A�ade el nombre del producto

SELECT OD.ProductID, P.ProductName, MAX(OD.UnitPrice) AS Precio, SUM(OD.UnitPrice * Quantity) AS [Cantidad Facturada] FROM [Order Details] AS OD
INNER JOIN Products AS P 
ON OD.ProductID = P.ProductID
GROUP BY OD.ProductId, P.ProductName
ORDER BY [Cantidad Facturada] DESC

--ID del proveedor e importe total del stock acumulado de productos correspondientes a ese proveedor. A�ade el nombre del proveedor

SELECT P.SupplierID, S.CompanyName, SUM(UnitPrice * UnitsInStock) AS StockAcumulado FROM Products AS P 
INNER JOIN Suppliers AS S
ON P.SupplierID = S.SupplierID
GROUP BY P.SupplierID, S.CompanyName

-- N�mero de pedidos registrados mes a mes de cada a�o.
SELECT YEAR(OrderDate) AS A�o, MONTH(OrderDate) AS Mes, COUNT(OrderDate) AS Pedidos FROM Orders
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY YEAR(OrderDate) ASC

--A�o y tiempo medio transcurrido entre la fecha de cada pedido (OrderDate) y la fecha en la que lo hemos enviado (ShipDate), en d�as para cada a�o.

SELECT YEAR(OrderDate) AS A�o, AVG(DATEDIFF(day, OrderDate, ShippedDate)) AS [Tiempo Medio] FROM Orders
GROUP BY YEAR(OrderDate)

--ID del distribuidor y n�mero de pedidos enviados a trav�s de ese distribuidor. A�ade el nombre del distribuidor

SELECT ShipVia, S.CompanyName, COUNT(*) AS [Pedidos Enviados] FROM Orders AS O
INNER JOIN Shippers AS S 
ON O.ShipVia = S.ShipperID
GROUP BY ShipVia, S.CompanyName


--ID de cada proveedor y n�mero de productos distintos que nos suministra. A�ade el nombre del proveedor.

SELECT P.SupplierID, S.CompanyName, COUNT(*) AS [Numero Productos] FROM Products AS P
INNER JOIN Suppliers AS S
ON P.SupplierID = S.SupplierID
GROUP BY P.SupplierID, S.CompanyName