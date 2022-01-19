USE Antisistemas

SELECT * FROM Activistas
SELECT * FROM ActivistasProtestas
SELECT * FROM ActosProtesta
SELECT * FROM Categorias
SELECT * FROM Detenciones
SELECT * FROM Grupos
SELECT * FROM GruposProtestas
SELECT * FROM Incidentes
SELECT * FROM Materiales
SELECT * FROM MaterialesIncidentes


--Queremos saber cuantos actos ha convocado cada organizacion o grupo y cuantas personas en total han sido detenidas en los mismos

SELECT GrupoConvocado.ID, GrupoConvocado.Nombre, COUNT(D.IDActo) AS NumeroActos, SUM(D.NumeroDetenidos) AS NumeroDetenidos FROM

(SELECT G.ID, Nombre, AP.ID AS IDActo FROM Grupos AS G
INNER JOIN GruposProtestas AS GP
ON G.ID = GP.IDGrupo
INNER JOIN ActosProtesta AS AP
ON GP.IDActo = AP.ID
GROUP BY G.ID, G.Nombre, AP.ID) AS GrupoConvocado

INNER JOIN 

(SELECT Detenciones.IDActo, COUNT(*) AS NumeroDetenidos FROM Detenciones
GROUP BY Detenciones.IDActo

) AS D 

ON GrupoConvocado.IDActo = D.IDActo
GROUP BY GrupoConvocado.ID, GrupoConvocado.Nombre

--Queremos saber en que actos se han producido incidentes en los que no han intervenido materiales de la categoria 'Arrojadiza' ni 'Armas blancas'.

--USANDO EXCEPT

SELECT ID, Titulo, Fecha FROM ActosProtesta

EXCEPT

SELECT AP.ID, AP.Titulo, AP.Fecha FROM ActosProtesta AS AP
INNER JOIN Incidentes AS I
ON AP.ID = I.IDActo
INNER JOIN MaterialesIncidentes AS MI
ON I.IDActo = MI.IDActo
INNER JOIN Materiales AS M
ON MI.IDMaterial = M.ID
INNER JOIN Categorias AS C
ON M.Categoria = C.ID
WHERE C.Nombre IN ('Arrojadizas', 'Armas blancas')


--SIN USAR EXCEPT. (Solo la he hecho porque me sobraba tiempo). 
SELECT ID, Titulo, Fecha FROM ActosProtesta
WHERE ID NOT IN (SELECT AP.ID FROM ActosProtesta AS AP
INNER JOIN Incidentes AS I
ON AP.ID = I.IDActo
INNER JOIN MaterialesIncidentes AS MI
ON I.IDActo = MI.IDActo
INNER JOIN Materiales AS M
ON MI.IDMaterial = M.ID
INNER JOIN Categorias AS C
ON M.Categoria = C.ID
WHERE C.Nombre IN ('Arrojadizas', 'Armas blancas'))

--Queremos saber cual fue el acto en el que mas detenciones se han producido en cada ciudad y cuantos de los detenidos en ese acto eran menores de edad en el momento de producirse la detencion

--Vista para la consulta base.
GO
CREATE VIEW DetenidosCiudad AS 
(SELECT AP.ID, AP.Ciudad, COUNT(*) AS NumeroDetenidos FROM Detenciones AS D
INNER JOIN ActosProtesta AS AP
ON D.IDActo = AP.ID
GROUP BY AP.ID, AP.Ciudad)
GO

--Vista para el máximo
GO
CREATE VIEW MaximoDetenidosCiudad AS
(SELECT DC.Ciudad, MAX(NumeroDetenidos) AS MaximoDetenidos FROM DetenidosCiudad AS DC
 GROUP BY DC.Ciudad
)
GO

--Consulta relacionando las dos vistas.
SELECT DetenidosMaximo.ID, DetenidosMaximo.Titulo, DetenidosMaximo.Ciudad, DetenidosMaximo.Fecha, DetenidosMaximo.MaximoDetenidos, DetenidosMenores.NumeroDetenidos AS MenoresDetenidos FROM 
(SELECT DT.ID, AP.Titulo, AP.Fecha, DT.Ciudad, MDC.MaximoDetenidos FROM DetenidosCiudad AS DT
INNER JOIN MaximoDetenidosCiudad AS MDC
ON DT.Ciudad = MDC.Ciudad AND DT.NumeroDetenidos = MDC.MaximoDetenidos
INNER JOIN ActosProtesta AS AP
ON DT.ID = AP.ID) AS DetenidosMaximo

INNER JOIN

(SELECT AP.ID, AP.Ciudad, COUNT(*) AS NumeroDetenidos FROM Detenciones AS D
INNER JOIN ActosProtesta AS AP
ON D.IDActo = AP.ID
INNER JOIN Activistas AS A
ON D.IDActivista = A.ID
WHERE Year(CAST(AP.Fecha AS SmallDateTime) - CAST (A.FechaNac AS SmallDateTime))-1900 < 18
GROUP BY AP.ID, AP.Ciudad) AS DetenidosMenores

ON DetenidosMaximo.ID = DetenidosMenores.ID

--Queremos saber cual es la hora mas peligrosa de cada ciudad. Consideramos que la más peligrosa es cuando se producen un mayor numero de detenciones. 
--Se consideraran tramos horarios de una hora.

--Vista para la consulta base.
GO
CREATE VIEW DetenidosCiudadHora AS
(SELECT AP.Ciudad, DATEPART(Hour, Hora) AS Hora, COUNT(*) AS Detenidos FROM Detenciones AS D
INNER JOIN ActosProtesta AS AP
ON D.IDActo = AP.ID
GROUP BY DATEPART(Hour, Hora), AP.Ciudad)
GO

--Vista para el máximo.
GO
CREATE VIEW MaximosDetenidosCiudadHora AS
(SELECT DetenidosCiudadHora.Ciudad, MAX(Detenidos) AS MaximoDetenidos FROM DetenidosCiudadHora
GROUP BY DetenidosCiudadHora.Ciudad
) 

GO

--Consulta relacionando las dos vistas.
SELECT DCH.Ciudad, DCH.Hora, DCH.Detenidos FROM DetenidosCiudadHora AS DCH
INNER JOIN MaximosDetenidosCiudadHora as MDCH
ON DCH.Ciudad = MDCH.Ciudad AND DCH.Detenidos = MDCH.MaximoDetenidos

--El grupo "Club de fans de El Fari" ha decidido nombrar socios a todos los activistas que hayan sido detenidos en algún acto en el que dicho grupo figure entre los convocantes. Actualiza la tabla activistas para que quede recogido.

begin tran

UPDATE Activistas SET Organizacion = 11

WHERE ID IN (
SELECT D.IDActivista FROM Detenciones AS D
INNER JOIN GruposProtestas AS GP
ON D.IDActo = GP.IDActo
WHERE GP.IDGrupo = 11)

rollback