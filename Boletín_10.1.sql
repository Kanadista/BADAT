	USE NorthWind

SELECT * FROM Customers
SELECT * FROM Employees
SELECT * FROM Orders
SELECT * FROM [Order Details]
SELECT * FROM Products
SELECT * FROM Categories
SELECT * FROM EmployeeTerritories
SELECT * FROM Territories

--1.- Inserta un nuevo cliente.

INSERT INTO Customers VALUES(
'VAHPR','Vahagn Provisions', 'Vahagn Hayrapetyan', 'Owner', 'Calle Emprendedor nº2', 'Sevilla', NULL, 41927, 'Spain', '90-245-8858', NULL)

--2.- Véndele (hoy) tres unidades de "Pavlova”, diez de "Inlagd Sill” y 25 de "Filo Mix”. El distribuidor será Speedy Express y el vendedor Laura Callahan.

--3.- Ante la bajada de ventas producida por la crisis, hemos de adaptar nuestros precios según las siguientes reglas:
--Los productos de la categoría de bebidas (Beverages) que cuesten más de $10 reducen su precio en un dólar.

UPDATE Products SET UnitPrice = UnitPrice - 1
WHERE ProductID IN ( SELECT ProductID FROM Products AS P
INNER JOIN Categories AS C
ON P.CategoryID = C.CategoryID
WHERE UnitPrice > 10 AND C.CategoryName = 'Beverages')

--Los productos de la categoría Lácteos que cuesten más de $5 reducen su precio en un 10%.

UPDATE Products SET UnitPrice = UnitPrice * 0.9
WHERE ProductID IN ( SELECT ProductID FROM Products AS P
INNER JOIN Categories AS C
ON P.CategoryID = C.CategoryID
WHERE UnitPrice > 5 AND C.CategoryName = 'Dairy Products')

--Los productos de los que se hayan vendido menos de 200 unidades en el último año, reducen su precio en un 5%

UPDATE Products SET UnitPrice = UnitPrice * 0.95
WHERE ProductID IN (
SELECT P.ProductID FROM Products AS P
INNER JOIN [Order Details] AS OD
ON P.ProductID = OD.ProductID
INNER JOIN ORDERS AS O 
ON OD.OrderID = O.OrderID
WHERE YEAR(O.OrderDate) = 1998
GROUP BY P.ProductID
HAVING SUM(Quantity) < 200)


SELECT P.ProductID FROM Products AS P
INNER JOIN [Order Details] AS OD
ON P.ProductID = OD.ProductID
INNER JOIN Orders AS O
ON OD.OrderID = O.OrderID
WHERE YEAR(O.OrderDate) = 1997
GROUP BY P.ProductID

--4.- Inserta un nuevo vendedor llamado Michael Trump. Asígnale los territorios de Louisville, Phoenix, Santa Cruz y Atlanta.

INSERT INTO Employees VALUES(
'Trump', 'Michael', 'Sales Representative', 'Mr.', '1948-12-09', '2020-03-11', '904 Republican Scum', 'Seattle', 'WA', 98122, 'USA', '(206) 555-8765', '5467', NULL, 'None', 2, NULL) 

INSERT INTO EmployeeTerritories VALUES
(10, 40222),
(10, 85014),
(10, 95060),
(10, 30346)

--5.- Haz que las ventas del año 97 de Robert King que haya hecho a clientes de los estados de California y Texas se le asignen al nuevo empleado.

UPDATE Orders SET EmployeeID = 10
WHERE EmployeeID IN (
SELECT O.EmployeeID FROM Orders AS O 
INNER JOIN Employees AS E
ON O.EmployeeID = E.EmployeeID
WHERE YEAR(O.OrderDate) = 1997 AND E.FirstName = 'Robert' AND E.LastName = 'King'
)



--6.- Inserta un nuevo producto con los siguientes datos:
--ProductID: 90
--ProductName: Nesquick Power Max
--SupplierID: 12
--CategoryID: 3
--QuantityPerUnit: 10 x 300g
--UnitPrice: 2,40
--UnitsInStock: 38
--UnitsOnOrder: 0
--ReorderLevel: 0
--Discontinued: 0


INSERT INTO Products VALUES
('Nesquik Power Max', 12, 3, '10 X 300g', 2.40, 38, 0, 0, 0)



--7.- Inserta un nuevo producto con los siguientes datos:
--ProductID: 91
--ProductName: Mecca Cola
--SupplierID: 1
--CategoryID: 1
--QuantityPerUnit: 6 x 75 cl
--UnitPrice: 7,35
--UnitsInStock: 14
--UnitsOnOrder: 0
--ReorderLevel: 0
--Discontinued: 0


INSERT INTO Products VALUES
('Mecca Cola', 1, 1, '6 X 75cl', 7.35, 14, 0, 0, 0)

--8.- Todos los que han comprado "Outback Lager" han comprado cinco años después la misma cantidad de Mecca Cola al mismo vendedor

INSERT INTO Orders (CustomerID, EmployeeID, OrderDate)
SELECT CustomerID, EmployeeID, DATEADD(YEAR, 5, OrderDate) FROM [Order Details] AS OD
INNER JOIN Products AS P
ON OD.ProductID = P.ProductID
INNER JOIN Orders AS O
ON OD.OrderID = O.OrderID
WHERE P.ProductName = 'Outback Lager'

INSERT INTO [Order Details] (OrderID, ProductID, Quantity)
SELECT Mecca.OrderID, OD.ProductID, OD.Quantity FROM Orders AS Outback 
INNER JOIN Orders AS Mecca
ON Outback.CustomerID = Mecca.CustomerID AND Outback.EmployeeID = Mecca.EmployeeID AND DATEADD(YEAR, 5, Outback.OrderDate) = Mecca.OrderDate
INNER JOIN [Order Details] as OD ON Outback.OrderID = OD.OrderID
WHERE OD.ProductID = 70


UPDATE [Order Details] SET ProductID = 1079, UnitPrice = 7.35
WHERE OrderID IN (
SELECT Mecca.OrderID FROM Orders AS Outback 
INNER JOIN Orders AS Mecca
ON Outback.CustomerID = Mecca.CustomerID AND Outback.EmployeeID = Mecca.EmployeeID AND DATEADD(YEAR, 5, Outback.OrderDate) = Mecca.OrderDate
INNER JOIN [Order Details] as OD ON Outback.OrderID = OD.OrderID
WHERE OD.ProductID = 70)



BEGIN TRAN

ROLLBACK





--9.- El pasado 20 de enero, Margaret Peacock consiguió vender una caja de Nesquick Power Max a todos los clientes que le habían comprado algo anteriormente. Los datos de envío (dirección, transportista, etc) son los mismos de alguna de sus ventas anteriores a ese cliente).

begin tran

INSERT INTO Customers (CustomerID,CompanyName, City, Country)
SELECT SupplierID, CompanyName, City, Country FROM Suppliers
WHERE Country='Germany';

SELECT * FROM Customers
WHERE Country='GERMANY';

rollback

select * from suppliers