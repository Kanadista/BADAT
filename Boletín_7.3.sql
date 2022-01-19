USE pubs

SELECT * FROM titles
SELECT * FROM jobs
SELECT * FROM publishers
SELECT * FROM authors
SELECT * FROM employee

--Título, precio y notas de los libros (titles) que tratan de cocina, ordenados de mayor a menor precio.

SELECT title, price, notes FROM titles
WHERE type IN ('mod_cook', 'trad_cook')
ORDER BY price DESC

--ID, descripción y nivel máximo y mínimo de los puestos de trabajo (jobs) que pueden tener un nivel 110.

SELECT * FROM jobs
WHERE max_lvl >= 110


--Título, ID y tema de los libros que contengan la palabra "and” en las notas

SELECT title_id, title, type FROM titles
WHERE notes like '%and%'

--Nombre y ciudad de las editoriales (publishers) de los Estados Unidos que no estén en California ni en Texas

SELECT pub_name, city FROM publishers
WHERE state NOT IN ('CA', 'TX')


--Título, precio, ID de los libros que traten sobre psicología o negocios y cuesten entre diez y 20 dólares.

SELECT title_id, title, price FROM titles
WHERE type IN ('psychology', 'business') AND price BETWEEN 10 AND 20

--Nombre completo (nombre y apellido) y dirección completa de todos los autores que no viven en California ni en Oregón.

SELECT au_fname, au_lname, address, city FROM authors
WHERE state NOT IN ('CA','OR') 

--Nombre completo y dirección completa de todos los autores cuyo apellido empieza por D, G o S.

SELECT au_fname, au_lname, address, city FROM authors
WHERE au_fname LIKE ('[DGS]%')

--ID, nivel y nombre completo de todos los empleados con un nivel inferior a 100, ordenado alfabéticamente

SELECT emp_id, job_lvl, fname, lname FROM employee
WHERE job_lvl < 100
ORDER BY fname, lname


--Inserta un nuevo autor.

INSERT INTO authors VALUES
('420-69-1312', 'Marx', 'Karl', '405 987-4567', '546 Bollwerkstraße','Treveris', 'GE', '54290', 1)

--Inserta dos libros, escritos por el autor que has insertado antes y publicados por la editorial "Ramona publishers”.

INSERT INTO titles VALUES 
('EC1050', 'Communist Manifesto', 'economy', '1756',  15.99, 5000.0, 195400, 2, 'The Communist Manifesto reflects an attempt to explain the goals of Communism.', CONVERT(datetime, '21-02-1848')),
('EC9876', 'Das Kapital', 'economy', '1756',  19.99, 1500.0, 7540, 2, 'In Das Kapital, Marx proposes that the motivating force of capitalism is in the exploitation of labor' , CONVERT(datetime, '14-09-1848'))


--Modifica la tabla jobs para que el nivel mínimo sea 90.

UPDATE jobs SET
min_lvl = 90


--Crea una nueva editorial (publihers) con ID 9908, nombre Mostachon Books y sede en Utrera.

INSERT INTO publishers VALUES
('9908', 'Mostachon Books', 'Utrera', 'UT', 'Spain') 

--Cambia el nombre de la editorial con sede en Alemania para que se llame "Machen Wücher" y traslasde su sede a Stuttgart

UPDATE publishers SET
pub_name = 'Machen Wücher', 
city = 'Stuttgart'
WHERE pub_id = 9901