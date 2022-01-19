--Autores: Sebastián y Pedro

--CONSULTA LEOCHAMPIONSLEAGUE
GO
USE LeoChampionsLeague
GO
SELECT * FROM Partidos
SELECT * FROM Equipos
SELECT * FROM Clasificacion
GO
--VISTA PARTIDOS JUGADOS

CREATE VIEW PartidosJugados AS
SELECT PartidosLocales.ELocal, ISNULL(PartidosLocales.[Partidos Locales], 0) + ISNULL(PartidosVisitantes.[Partidos Visitantes],0) AS [Partidos Jugados] FROM(
	SELECT ELocal, COUNT(ID) AS [Partidos Locales] FROM Partidos
	WHERE Finalizado=1
	GROUP BY ELocal)AS PartidosLocales
FULL JOIN ( --Por si se da la casualidad de que un equipo no ha jugado fuera (sobret odo las primeras jornadas)
	SELECT EVisitante, COUNT(ID) AS [Partidos Visitantes] FROM Partidos
	WHERE Finalizado=1
	GROUP BY EVisitante)AS PartidosVisitantes
ON PartidosLocales.ELocal=PartidosVisitantes.EVisitante
GO

--VISTA PARTIDOS GANADOS

CREATE VIEW PartidosGanados AS
SELECT GanadosLocal.[ELocal], ISNULL([Partidos Locales Ganados],0) + ISNULL([Partidos Visitantes Ganados],0) AS [Partidos Ganados] FROM(
	SELECT ELocal, COUNT(ID) AS [Partidos Locales Ganados] FROM Partidos
	WHERE GolesLocal>GolesVisitante and Finalizado=1 
	GROUP BY ELocal) AS GanadosLocal
FULL JOIN(
	SELECT EVisitante, COUNT(ID) AS [Partidos Visitantes Ganados] FROM Partidos
	WHERE GolesVisitante>GolesLocal and Finalizado=1
	GROUP BY EVisitante) AS GanadosVisitantes
ON GanadosLocal.ELocal=GanadosVisitantes.EVisitante
GO

--VISTA PARTIDOS EMPATADOS

CREATE VIEW PartidosEmpatados AS
SELECT EmpatadosLocal.[ELocal], ISNULL([Partidos Locales Empatados],0) + ISNULL([Partidos Visitantes Empatados],0) AS [Partidos Empatados] FROM(
	SELECT ELocal, COUNT(ID) AS [Partidos Locales Empatados] FROM Partidos
	WHERE GolesLocal=GolesVisitante and Finalizado=1 
	GROUP BY ELocal) AS EmpatadosLocal
FULL JOIN(
	SELECT EVisitante, COUNT(ID) AS [Partidos Visitantes Empatados] FROM Partidos
	WHERE GolesVisitante=GolesLocal and Finalizado=1
	GROUP BY EVisitante) AS EmpatadosVisitante
ON EmpatadosLocal.ELocal=EmpatadosVisitante.EVisitante
GO

--VISTA GOLES A FAVOR

CREATE VIEW GolesAFavor AS
SELECT GolesAFavorLocal.ELocal,[Goles A Favor Local]+[Goles A Favor Visitante] AS [GolesAFavor] FROM (
	SELECT ELocal,SUM(GolesLocal) AS [Goles A Favor Local] FROM Partidos
	WHERE Finalizado=1 
	GROUP BY ELocal) AS GolesAFavorLocal
FULL JOIN(
	SELECT EVisitante,SUM(GolesVisitante) AS [Goles A Favor Visitante] FROM Partidos
	WHERE Finalizado=1 
	GROUP BY EVisitante) AS GolesAFavorVisitante
ON GolesAFavorLocal.ELocal=GolesAFavorVisitante.EVisitante
GO

--VISTA GOLES EN CONTRA

CREATE VIEW GolesEnContra AS
SELECT GolesEnContraLocal.ELocal,[Goles En Contra Local]+[Goles En Contra Visitante] AS [GolesEnContra] FROM (
	SELECT ELocal,SUM(GolesVisitante) AS [Goles En Contra Local] FROM Partidos
	WHERE Finalizado=1 
	GROUP BY ELocal) AS GolesEnContraLocal
FULL JOIN(
	SELECT EVisitante,SUM(GolesLocal) AS [Goles En Contra Visitante] FROM Partidos
	WHERE Finalizado=1 
	GROUP BY EVisitante) AS GolesEnContraVisitante
ON GolesEnContraLocal.ELocal=GolesEnContraVisitante.EVisitante
GO
---
--INSERTAMOS LOS DATOS EN LA TABLA CLASIFICACION
INSERT INTO Clasificacion(IDEquipo,NombreEquipo,PartidosJugados,PartidosGanados,PartidosEmpatados,GolesFavor,GolesContra)
	SELECT ID,Nombre,[Partidos Jugados],[Partidos Ganados],[Partidos Empatados],GolesAFavor.GolesAFavor,GolesEnContra.GolesEnContra FROM Equipos
	INNER JOIN PartidosJugados ON Equipos.ID=PartidosJugados.ELocal
	INNER JOIN PartidosGanados ON PartidosJugados.ELocal=PartidosGanados.ELocal
	INNER JOIN PartidosEmpatados ON PartidosGanados.ELocal=PartidosEmpatados.ELocal
	INNER JOIN GolesAFavor ON PartidosEmpatados.ELocal=GolesAFavor.ELocal
	INNER JOIN GolesEnContra ON GolesAFavor.ELocal=GolesEnContra.ELocal
---

SELECT * FROM Clasificacion
ORDER BY Puntos DESC,GolesFavor-GolesContra DESC,GolesFavor DESC

UPDATE Clasificacion
SET GolesContra+=4
WHERE IDEquipo='BARC'



--INTENTO DE TABLAS TEMPORALES (NO LO USAMOS AL FINAL PORQUE NO PODÍAMOS MANTENER EL ORDEN A LA HORA DE INSERTARLO)
DECLARE @ClasificacionTemporal AS TABLE(
	IDEquipo Char(4) Not NULL,
	NombreEquipo VarChar(20) Not NULL,
	PartidosJugados TinyInt Not NULL Default 0,
	PartidosGanados TinyInt Not NULL Default 0,
	PartidosEmpatados TinyInt Not NULL Default 0,
	PartidosPerdidos AS PartidosJugados - (PartidosGanados + PartidosEmpatados),
	Puntos AS PartidosGanados * 3 + PartidosEmpatados,
	GolesFavor SmallInt Not NULL Default 0,
	GolesContra SmallInt Not NULL Default 0
	)

	INSERT INTO @ClasificacionTemporal (IDEquipo,NombreEquipo,PartidosJugados,PartidosGanados,PartidosEmpatados,GolesFavor,GolesContra)
	SELECT ID,Nombre,[Partidos Jugados],[Partidos Ganados],[Partidos Empatados],GolesAFavor.GolesAFavor,GolesEnContra.GolesEnContra FROM Equipos
	INNER JOIN PartidosJugados ON Equipos.ID=PartidosJugados.ELocal
	INNER JOIN PartidosGanados ON PartidosJugados.ELocal=PartidosGanados.ELocal
	INNER JOIN PartidosEmpatados ON PartidosGanados.ELocal=PartidosEmpatados.ELocal
	INNER JOIN GolesAFavor ON PartidosEmpatados.ELocal=GolesAFavor.ELocal
	INNER JOIN GolesEnContra ON GolesAFavor.ELocal=GolesEnContra.ELocal

	INSERT INTO Clasificacion (IDEquipo,NombreEquipo,PartidosJugados,PartidosGanados,PartidosEmpatados,GolesFavor,GolesContra)
	SELECT IDEquipo,NombreEquipo,PartidosJugados,PartidosGanados,PartidosEmpatados,GolesFavor,GolesContra FROM @ClasificacionTemporal
	
	SELECT * FROM Clasificacion
	ORDER BY Puntos DESC

	

--BEGIN TRANSACTION 
--COMMIT
--ROLLBACK

