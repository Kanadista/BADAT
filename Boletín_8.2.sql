USE pubs

 
SELECT * FROM authors
SELECT * FROM employee
SELECT * FROM publishers
SELECT * FROM sales
SELECT * FROM titles
SELECT * FROM titleauthor


-- Numero de libros que tratan de cada tema

SELECT type, COUNT(*) AS Cantidad FROM titles
GROUP BY type

-- Número de autores diferentes en cada ciudad y estado

SELECT state, city, COUNT(*) AS [Numero Autores] FROM authors
GROUP BY state, city
ORDER BY state

-- Nombre, apellidos, nivel y antigüedad en la empresa de los empleados con un nivel entre 100 y 150.

SELECT fname, lname, job_lvl, DATEDIFF(year, hire_date, getdate()) AS Antiguedad FROM employee
WHERE job_lvl BETWEEN 100 AND 150

-- Número de editoriales en cada país. Incluye el país.

SELECT Country, COUNT(*) AS [Numero Editoriales] FROM publishers
GROUP BY Country

-- Número de unidades vendidas de cada libro en cada año (title_id, unidades y año).

SELECT title_id, COUNT(*) AS Unidades, YEAR(ord_date) AS Año  FROM sales
GROUP BY title_id, YEAR(ord_date)


-- Número de autores que han escrito cada libro (title_id y numero de autores).

SELECT title_id, COUNT(*) AS [Numero autores] FROM titleauthor
GROUP BY title_id


-- ID, Titulo, tipo y precio de los libros cuyo adelanto inicial (advance) tenga un valor superior a $7.000, ordenado por tipo y título

SELECT title_id, title, type, price FROM titles
WHERE advance > 7000 
ORDER BY type, title