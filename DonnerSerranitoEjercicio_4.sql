

/*Ejercicio 4 (3 points)
Crea una funci�n a la que se pase como par�metro el nombre de un establecimiento y nos devuelva una tabla con dos columnas, 
hora y tipo de pan. La tabla tendr� 24 filas, correspondientes a las 24 horas del d�a y nos dir� qu� pan se vende m�s a cada hora. 
La fila de hora 0 abarcar� desde las 0:00 a las 0:59, la hora 1 de las 1:00 a las 1:59 y as� sucesivamente.
*/
select*from dsPedidos

SELECT DATEPART(HOUR,(Recibido)),* FROM DSPedidos



--FUNCI�N INLINE QUE DEVUELVE EL PAN M�S VENDIDO A CADA HORA EN EL ESTABLECIMIENTO PASADO POR PAR�METROS
GO
CREATE OR ALTER FUNCTION FPMVHE(@NombreEstablecimiento varchar(30)) 
RETURNS TABLE AS RETURN

	SELECT FFNPH.NPanes,MNPVH.Horas,MNPVH.MaxNumeroPanesHora, FFNPH.Denominacion FROM
	(SELECT FNPH.Horas,MAX(FNPH.NPanes) MaxNumeroPanesHora FROM--SACAMOS EL M�XIMO DE PANES QUE SE HAN VENDIDO A CADA HORA
	FNPH(@NombreEstablecimiento) GROUP BY FNPH.Horas,FNPH.Denominacion) AS MNPVH INNER JOIN--UNIMO DE NUEVO CON LA FUNCI�N INLINE PARA OBTENER EL NOMBRE DEL PAN Y LA DENOMINACI�N DEL ESTABLECIMIENTO
	FNPH(@NombreEstablecimiento) AS FFNPH  ON MNPVH.Horas=FFNPH.Horas AND MNPVH.MaxNumeroPanesHora=FFNPH.NPanes

GO



--FUNCI�N INLINE QUE DEVUELVE LA CANTIDAD DE PANES VENDIDAS A CADA HORA SEG�N EL NOMBRE DEL RESTAURANTE PASADO POR PAR�METROS
GO
CREATE OR ALTER FUNCTION FNPH(@NombreEstablecimiento varchar(30)) RETURNS TABLE AS RETURN
	(SELECT E.Denominacion,TP.Pan,DATEPART(HOUR,P.Recibido) AS Horas,COUNT(*) AS NPanes  FROM DSPedidos AS P INNER JOIN DSPlatos AS PT
	ON P.ID=PT.IDPedido INNER JOIN DSTiposPan TP ON PT.TipoPan=TP.Pan INNER JOIN DSEstablecimientos AS E ON E.ID=P.IDEstablecimiento
	WHERE E.Denominacion=@NombreEstablecimiento
	GROUP BY TP.Pan,DATEPART(HOUR,P.Recibido),E.Denominacion)
GO

--COMPROBACI�N DE FUNCIONAMIENTO
SELECT*FROM FPMVHE('Atracon')





