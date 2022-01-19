USE Northwind

SELECT * FROM Customers
SELECT * FROM Employees
SELECT * FROM Products
SELECT * FROM Suppliers

--Nombre de la compañía y dirección completa (dirección, cuidad, país) de todos los
--clientes que no sean de los Estados Unidos. 

SELECT CompanyName, Address, City, Country FROM Customers
WHERE Country <> 'USA'

--La consulta anterior ordenada por país y ciudad.
SELECT CompanyName, Address, City, Country FROM Customers
WHERE Country <> 'USA'
Order By City, Country

--Nombre, Apellidos, Ciudad y Edad de todos los empleados, ordenados por antigüedad en
--la empresa. 
SELECT LastName, FirstName, City, CAST(DATEDIFF(DD, BirthDate, GETDATE()) as int) / 365 AS Age FROM Employees
ORDER BY HireDate

--Nombre y precio de cada producto, ordenado de mayor a menor precio. 

SELECT ProductName, UnitPrice FROM Products
ORDER BY UnitPrice DESC

--Nombre de la compañía y dirección completa de cada proveedor de algún país de
--América del Norte. 

SELECT CompanyName, Address, City, Country FROM Suppliers
WHERE Country IN ('USA', 'Mexico', 'Canada')