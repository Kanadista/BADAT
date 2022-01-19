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

-- N�mero de autores diferentes en cada ciudad y estado

SELECT state, city, COUNT(*) AS [Numero Autores] FROM authors
GROUP BY state, city
ORDER BY state

-- Nombre, apellidos, nivel y antig�edad en la empresa de los empleados con un nivel entre 100 y 150.

SELECT fname, lname, job_lvl, DATEDIFF(year, hire_date, getdate()) AS Antiguedad FROM employee
WHERE job_lvl BETWEEN 100 AND 150

-- N�mero de editoriales en cada pa�s. Incluye el pa�s.

SELECT Country, COUNT(*) AS [Numero Editoriales] FROM publishers
GROUP BY Country

-- N�mero de unidades vendidas de cada libro en cada a�o (title_id, unidades y a�o).

SELECT title_id, COUNT(*) AS Unidades, YEAR(ord_date) AS A�o  FROM sales
GROUP BY title_id, YEAR(ord_date)


-- N�mero de autores que han escrito cada libro (title_id y numero de autores).

SELECT title_id, COUNT(*) AS [Numero autores] FROM titleauthor
GROUP BY title_id


-- ID, Titulo, tipo y precio de los libros cuyo adelanto inicial (advance) tenga un valor superior a $7.000, ordenado por tipo y t�tulo

SELECT title_id, title, type, price FROM titles
WHERE advance > 7000 
ORDER BY type, title