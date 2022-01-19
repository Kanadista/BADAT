

/*Ejercicio 4 (3 points)
Crea una función a la que se pase como parámetro el nombre de un establecimiento y nos devuelva una tabla con dos columnas, 
hora y tipo de pan. La tabla tendrá 24 filas, correspondientes a las 24 horas del día y nos dirá qué pan se vende más a cada hora. 
La fila de hora 0 abarcará desde las 0:00 a las 0:59, la hora 1 de las 1:00 a las 1:59 y así sucesivamente.
*/
select*from dsPedidos

SELECT DATEPART(HOUR,(Recibido)),* FROM DSPedidos



--FUNCIÓN INLINE QUE DEVUELVE EL PAN MÁS VENDIDO A CADA HORA EN EL ESTABLECIMIENTO PASADO POR PARÁMETROS
GO
CREATE OR ALTER FUNCTION FPMVHE(@NombreEstablecimiento varchar(30)) 
RETURNS TABLE AS RETURN

	SELECT FFNPH.NPanes,MNPVH.Horas,MNPVH.MaxNumeroPanesHora, FFNPH.Denominacion FROM
	(SELECT FNPH.Horas,MAX(FNPH.NPanes) MaxNumeroPanesHora FROM--SACAMOS EL MÁXIMO DE PANES QUE SE HAN VENDIDO A CADA HORA
	FNPH(@NombreEstablecimiento) GROUP BY FNPH.Horas,FNPH.Denominacion) AS MNPVH INNER JOIN--UNIMO DE NUEVO CON LA FUNCIÓN INLINE PARA OBTENER EL NOMBRE DEL PAN Y LA DENOMINACIÓN DEL ESTABLECIMIENTO
	FNPH(@NombreEstablecimiento) AS FFNPH  ON MNPVH.Horas=FFNPH.Horas AND MNPVH.MaxNumeroPanesHora=FFNPH.NPanes

GO



--FUNCIÓN INLINE QUE DEVUELVE LA CANTIDAD DE PANES VENDIDAS A CADA HORA SEGÚN EL NOMBRE DEL RESTAURANTE PASADO POR PARÁMETROS
GO
CREATE OR ALTER FUNCTION FNPH(@NombreEstablecimiento varchar(30)) RETURNS TABLE AS RETURN
	(SELECT E.Denominacion,TP.Pan,DATEPART(HOUR,P.Recibido) AS Horas,COUNT(*) AS NPanes  FROM DSPedidos AS P INNER JOIN DSPlatos AS PT
	ON P.ID=PT.IDPedido INNER JOIN DSTiposPan TP ON PT.TipoPan=TP.Pan INNER JOIN DSEstablecimientos AS E ON E.ID=P.IDEstablecimiento
	WHERE E.Denominacion=@NombreEstablecimiento
	GROUP BY TP.Pan,DATEPART(HOUR,P.Recibido),E.Denominacion)
GO

--COMPROBACIÓN DE FUNCIONAMIENTO
SELECT*FROM FPMVHE('Atracon')





