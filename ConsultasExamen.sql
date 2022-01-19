USE Antisistemas

SELECT * FROM Activistas
SELECT * FROM ActivistasProtestas
SELECT * FROM ActosProtesta
SELECT * FROM Cargos
SELECT * FROM Categorias
SELECT * FROM Detenciones
SELECT * FROM Grupos
SELECT * FROM GruposProtestas
SELECT * FROM Incidentes
SELECT * FROM Materiales
SELECT * FROM MaterialesIncidentes


--Numero de asistentes por protestas (teniendo en cuenta de que todas las manifestaciones con el mismo motivo son una sola)
SELECT AP.Titulo, COUNT(*) AS [Numero Asistentes] FROM ActosProtesta AS AP
INNER JOIN ActivistasProtestas AS ActivistasP
ON AP.ID = ActivistasP.IDActo
GROUP BY AP.Titulo

--Numero de asistentes por protestas 
SELECT AP.Titulo, AP.Fecha, AP.Ciudad, COUNT(*) AS [Numero Asistentes] FROM ActosProtesta AS AP
INNER JOIN ActivistasProtestas AS ActivistasP
ON AP.ID = ActivistasP.IDActo
GROUP BY AP.ID, AP.Titulo, AP.Ciudad, AP.Fecha
ORDER BY AP.Titulo

--Vista base para superventas de asistentes por protesta
GO
CREATE VIEW AsistentesProtestas AS
(SELECT AP.Titulo, AP.Fecha, AP.Ciudad, COUNT(*) AS [Numero Asistentes] FROM ActosProtesta AS AP
INNER JOIN ActivistasProtestas AS ActivistasP
ON AP.ID = ActivistasP.IDActo
GROUP BY AP.ID, AP.Titulo, AP.Fecha, AP.Ciudad)
GO

--Vista para el máximo
CREATE VIEW AsistentesCiudad AS
(SELECT Ciudad, MAX([Numero Asistentes]) AS [Maximo asistentes] FROM AsistentesProtestas
GROUP BY Ciudad 
)

--Superventas. Máximo de asistentes a una protesta en cada ciudad.
SELECT AP.Titulo, AP.Ciudad, AP.Fecha, AC.[Maximo asistentes] FROM AsistentesProtestas AS AP
INNER JOIN AsistentesCiudad AS AC
ON AP.Ciudad = AC.Ciudad AND AP.[Numero Asistentes] = AC.[Maximo asistentes]



INSERT INTO Detenciones (IDActivista, IDActo, OrdIncidente) 
SELECT
go


SELECT A.ID, AP.IDActo, I.Ord  FROM Activistas AS A
	INNER JOIN ActivistasProtestas AS AP
	ON A.ID = AP.IDActivista
	INNER JOIN ActosProtesta AS ACP
	ON AP.IDActo = ACP.ID
	INNER JOIN Incidentes AS I
	ON ACP.ID = I.IDActo
WHERE ACP.Ciudad = 'Trebujena'
