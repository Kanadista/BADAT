USE Northwind

SELECT * FROM Orders
SELECT * FROM [Order Details]
SELECT * FROM Products

BEGIN TRANSACTION
COMMIT
ROLLBACK

--Ejercicio 1:
--Deseamos incluir un producto en la tabla Products llamado "Cruzcampo lata” pero no estamos seguros si se ha insertado o no.
--El precio son 4,40, el proveedor es el 16, la categoría 1 y la cantidad por unidad es "Pack 6 latas” "Discontinued” toma el valor 0
--y el resto de columnas se dejarán a NULL.

IF EXISTS(SELECT ProductName FROM Products WHERE ProductName= 'Cruzcampo lata')
	UPDATE Products SET UnitPrice = '4.40'

ELSE 
	INSERT INTO Products VALUES('Cruzcampo lata', 16, 1, 'Pack 6 latas', 4.40, NULL, NULL, NULL, 0)
	
--Ejercicio 2:
--Comprueba si existe una tabla llamada ProductSales. Esta tabla ha de tener de cada producto el ID, el Nombre, el Precio unitario,
--el número total de unidades vendidas y el total de dinero facturado con ese producto. Si no existe, créala

IF OBJECT_ID('ProductSales') IS NULL
	CREATE TABLE ProductSales (
	ProductID int,
	ProductName nvarchar(40),
	UnitPrice money,
	TotalSales int,
	TotalInvoiced money
	)


































--Ejercicio 5:
--Entre los años 96 y 97 hay productos que han aumentado sus ventas y otros que las han disminuido. 
--Queremos cambiar el precio unitario según la siguiente tabla

GO
CREATE FUNCTION FNIncrementoVentas(@IDProducto as int) RETURNS float AS 
BEGIN

DECLARE @Resultado float;

SELECT @Resultado = ((CAST(Ventas97.[Numero de ventas] as float) - CAST(Ventas96.[Numero de ventas] as float)) * 100) / CAST(Ventas96.[Numero de ventas] as float) FROM
(SELECT ProductID, SUM(Quantity) AS [Numero de ventas] FROM [Order Details] AS OD
	INNER JOIN Orders AS O
	ON OD.OrderID = O.OrderID
	WHERE ProductID = @IDProducto AND YEAR(O.OrderDate) = 1996
	GROUP BY ProductID) AS Ventas96

	INNER JOIN

	(SELECT ProductID, SUM(Quantity) AS [Numero de ventas] FROM [Order Details] AS OD
		INNER JOIN Orders AS O
		ON OD.OrderID = O.OrderID
		WHERE ProductID = @IDProducto AND YEAR(O.OrderDate) = 1997
		GROUP BY ProductID) AS Ventas97

	ON Ventas96.ProductID = Ventas97.ProductID

	RETURN @Resultado
END
GO

UPDATE Products SET UnitPrice =
(CASE
	WHEN dbo.FNIncrementoVentas(ProductID) < 0 THEN UnitPrice * 0.9
	WHEN dbo.FNIncrementoVentas(ProductID) >= 0 AND dbo.FNIncrementoVentas(ProductID) <= 10  THEN UnitPrice 
	WHEN dbo.FNIncrementoVentas(ProductID) >= 10 AND dbo.FNIncrementoVentas(ProductID) <=50 THEN UnitPrice * 1.05
	WHEN dbo.FNIncrementoVentas(ProductID) > 50 THEN
	CASE 
		WHEN UnitPrice * 1.10 < 2.25 THEN UnitPrice * 1.10
		WHEN UnitPrice * 1.10 > 2.25 THEN UnitPrice + 2.25
		END
END)