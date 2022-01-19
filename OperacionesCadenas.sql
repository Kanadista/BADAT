CREATE DATABASE PruebaCadenas

--Operaciones con cadenas


--CONCAT. Devuelve el resultado de concatenar varias cadenas. Esta instrucción convierte los tipos a cadena antes de hacer la concatenación. Si recibe un argumento NULL lo interpretará como una cadena vacía.

SELECT CONCAT ('Hola', 'Mundo', 2020) AS Cadena

SELECT CONCAT ('Hola') AS Cadena

CREATE TABLE PruebaConcat (  
    Nombre NVARCHAR(200) NOT NULL,  
    Apellido NVARCHAR(200) NULL,  
);  

INSERT INTO PruebaConcat VALUES('Nombre', NULL);  
SELECT CONCAT(Nombre, Apellido) AS Cadena
FROM PruebaConcat;  



SELECT (Nombre + Apellido) AS Cadena
FROM PruebaConcat

--CONCATWS. Devuelve el resultado de concatenar varias cadenas con el añadido de poder elegir un separador entre estas.

SELECT CONCAT_WS(' ', 'Hola', 'Mundo')


--LOWER. Devuelve una cadena con todos los caracteres en minúsculas.

SELECT LOWER('HOLA MUNDO') AS Cadena

--UPPER. Devuelve una cadena con todos los caracteres en mayúsculas.

SELECT UPPER('hola mundo') AS Cadena

--RTRIM. Devuelve una cadena después de eliminar todo el espacio vacío a la derecha. 

SELECT RTRIM('Hola mundo    ') AS Cadena

SELECT ('Hola mundo    ') AS Cadena

SELECT CONCAT ('Hola       ', 'mundo') AS Cadena

SELECT CONCAT (RTRIM(' Hola          '),' ', 'mundo') AS Cadena

--LTRIM.  Devuelve una cadena después de eliminar todo el espacio vacío a la izquierda. 

SELECT LTRIM('             Hola mundo') AS Cadena


SELECT CONCAT ('          Hola', 'mundo') AS Cadena

SELECT CONCAT (LTRIM('        Hola'),' ', 'mundo') AS Cadena

--TRIM. Devuelve una cadena después de eliminar todo el espacio vacío a la izquierda y la derecha.

SELECT TRIM('            Hola mundo           ') AS Cadena

SELECT CONCAT ('          Hola          ', 'mundo') AS Cadena

SELECT CONCAT (TRIM('        Hola         '),' ', 'mundo') AS Cadena


--STRING_SPLIT. Divide una cadena en subcadenas basandose en un caracter determinado. (Requiere una version de SQL superior a la 2014).

SELECT value FROM STRING_SPLIT('Lorem ipsum dolor sit amet.', ' ');

SELECT value FROM STRING_SPLIT('Lorem, ipsum, dolor, sit, amet.', ',');

--CHAR. Convierte un código ASCII (entero) a un caracter.

SELECT CHAR(65) AS Caracter

SELECT 'Hola' + CHAR(13) + 'mundo' AS Cadena --Solo se puede ver cambiando el modo de resultados a texto.

--LEFT. Devuelve la parte izquierda de una cadena a partir de un entero.

SELECT LEFT('Hola mundo', 5) AS Cadena

--RIGHT. Devuelve la parte derecha de una cadena a partir de un entero.

SELECT RIGHT('Hola mundo', 5) AS Cadena

--REVERSE. Devuelve una cadena al revés.

SELECT REVERSE('Hola mundo') AS Cadena

--TRANSLATE. Devuelve una cadena en la cual, se sustituyen los caracteres específicados en el segundo argumento por los que se encuentran en el tercer elemento.

SELECT TRANSLATE('ABCDEFG', 'ABC', 'ZYX') AS Cadena
	
--REPLACE. Reemplaza todas las ocurrencias de una cadena por otra

SELECT REPLACE('ABCDEFG', 'CBA', 'ZYX') AS Cadena

--STRING_AGG. Toma varios valores de cadena y los concatena añadiendo separadores.

INSERT INTO PruebaConcat VALUES('John', 'Doe'),
('Emma', 'Ford'),
('Richard', 'Smith')

SELECT STRING_AGG(Nombre, ', ') AS Nombres FROM PruebaConcat 

--STUFF. Introduce una cadena dentro de otra cadena.

SELECT STUFF('ABCDEFG' , 3, 0, '012345')

SELECT STUFF('ABCDEFG' , 3, 3, '012345')

--CHARINDEX. Devuelve la posicion de inicio de una cadena dentro de otra cadena.

SELECT CHARINDEX('la', 'Hola mundo') AS Cadena

SELECT CHARINDEX('la', 'Hola mundo', 4) AS Cadena

--LEN. Devuelve el numero de caracteres de una cadena. No cuenta los espacios a la derecha.

SELECT LEN('Hola Mundo') AS Cadena
SELECT LEN('Hola Mundo      ') AS Cadena

--NCHAR. Recibe un entero y devuelve el caracter unicode que le corresponde.
SELECT NCHAR(63) AS Cadena

--UNICODE. Devuelve el entero que corresponde a un caracter unicode

SELECT UNICODE('?') AS Cadena

--SPACE. Devuelve una cadena con un numero de espacios.

SELECT 'Hola' + SPACE(4) + 'Mundo'

--SUBSTRING. Divide la parte de una cadena, determinado por dos enteros, siendo el primero el caracter de inicio y el segundo la longitud.

SELECT SUBSTRING('Hola mundo', 5,6)