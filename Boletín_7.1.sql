USE Northwind

SELECT * FROM Customers
SELECT * FROM Employees
SELECT * FROM Products
SELECT * FROM Suppliers

--Nombre de la compa��a y direcci�n completa (direcci�n, cuidad, pa�s) de todos los
--clientes que no sean de los Estados Unidos. 

SELECT CompanyName, Address, City, Country FROM Customers
WHERE Country <> 'USA'

--La consulta anterior ordenada por pa�s y ciudad.
SELECT CompanyName, Address, City, Country FROM Customers
WHERE Country <> 'USA'
Order By City, Country

--Nombre, Apellidos, Ciudad y Edad de todos los empleados, ordenados por antig�edad en
--la empresa. 
SELECT LastName, FirstName, City, CAST(DATEDIFF(DD, BirthDate, GETDATE()) as int) / 365 AS Age FROM Employees
ORDER BY HireDate

--Nombre y precio de cada producto, ordenado de mayor a menor precio. 

SELECT ProductName, UnitPrice FROM Products
ORDER BY UnitPrice DESC

--Nombre de la compa��a y direcci�n completa de cada proveedor de alg�n pa�s de
--Am�rica del Norte. 

SELECT CompanyName, Address, City, Country FROM Suppliers
WHERE Country IN ('USA', 'Mexico', 'Canada')