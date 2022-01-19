USE LeoMetro

SELECT * FROM LM_Estaciones
SELECT * FROM LM_Itinerarios
SELECT * FROM LM_Lineas
SELECT * FROM LM_Recorridos
SELECT * FROM LM_Tarjetas
SELECT * FROM LM_Pasajeros
SELECT * FROM LM_Viajes
SELECT * FROM LM_Trenes

--Crea una función inline que nos devuelva el número de estaciones que ha recorrido cada tren en un determinado periodo de tiempo. 
--El principio y el fin de ese periodo se pasarán como parámetros

GO
CREATE OR ALTER Function FNContarEstacionesTrenes (@FechaInicio as date, @FechaFinal as date) RETURNS TABLE AS
RETURN(
SELECT Tren, COUNT(*) AS [Numero estaciones] FROM LM_Recorridos AS R
WHERE CAST(Momento as date) BETWEEN @FechaInicio AND @FechaFinal
GROUP BY Tren 
)

GO

SELECT * FROM FNContarEstacionesTrenes('2017-02-24', '2017-02-28')

--Crea una función inline que nos devuelva el número de veces que cada usuario ha entrado en el metro en un periodo de tiempo.
--El principio y el fin de ese periodo se pasarán como parámetros

GO
CREATE OR ALTER Function FNContarEntradasPasajeros(@FechaInicio as date, @FechaFinal as date) RETURNS TABLE AS
RETURN(
SELECT IDTarjeta, COUNT(*) AS [Numero de entradas] FROM LM_Viajes AS V
WHERE CAST(MomentoEntrada AS date) BETWEEN @FechaInicio AND @FechaFinal 
GROUP BY IDTarjeta
)
GO

SELECT * FROM FNContarEntradasPasajeros('2017-02-24', '2017-02-28')
order by idtarjeta


--Crea una función inline a la que pasemos la matrícula de un tren y una fecha de inicio y fin y nos devuelva una tabla con el 
--número de veces que ese tren ha estado en cada estación, además del ID, nombre y dirección de la estación

GO

CREATE OR ALTER Function FNContarTrenesEstaciones(@Matricula as char(7), @FechaInicio as date, @FechaFinal as date) RETURNS TABLE AS 
RETURN(
SELECT Estacion, Denominacion, Direccion, COUNT(R.estacion) AS [Numero de veces] FROM LM_Recorridos AS R
INNER JOIN LM_Estaciones AS E
ON R.Estacion = E.ID
INNER JOIN LM_Trenes AS T
ON R.Tren = T.ID
WHERE (CAST(Momento as date) BETWEEN @FechaInicio AND @FechaFinal AND T.Matricula = @Matricula)
GROUP BY Estacion, Denominacion, Direccion
)

GO


SELECT * FROM FNContarTrenesEstaciones('5610GLZ', '2017-02-26', '2017-02-28') 



--Crea una función inline que nos diga el número de personas que han pasado por una estacion en un periodo de tiempo.
--Se considera que alguien ha pasado por una estación si ha entrado o salido del metro por ella. 
--El principio y el fin de ese periodo se pasarán como parámetros

GO

CREATE FUNCTION FNNumeroPasajerosEstacion(@FechaInicio as date, @FechaFinal as date) RETURNS TABLE AS 
RETURN(

SELECT PersonasEntradas.ID, PersonasEntradas.[Numero pasajeros] + PersonasSalidas.[Numero salidas] AS [Personas estacion] FROM 
	(SELECT E.ID, COUNT(IDEstacionEntrada) AS [Numero pasajeros] FROM LM_Estaciones AS E 
	INNER JOIN LM_Viajes AS V
	ON E.ID = V.IDEstacionEntrada
	WHERE CAST(MomentoEntrada as date) BETWEEN @FechaInicio AND @FechaFinal 
	GROUP BY E.ID) AS PersonasEntradas

INNER JOIN

	(SELECT E.ID, COUNT(IDEstacionSalida) AS [Numero salidas] FROM LM_Estaciones AS E
	INNER JOIN LM_Viajes AS V
	ON E.ID = V.IDEstacionSalida
	WHERE CAST(MomentoSalida as date) BETWEEN @FechaInicio AND @FechaFinal 
	GROUP BY E.ID) AS PersonasSalidas

ON PersonasEntradas.ID = PersonasSalidas.ID
)

GO

SELECT * FROM FNNumeroPasajerosEstacion('2017-02-24', '2017-02-28')




--Crea una función inline que nos devuelva los kilómetros que ha recorrido cada tren en un periodo de tiempo. 
--El principio y el fin de ese periodo se pasarán como parámetros.

SELECT Tren, estacion,  Distancia, Momento FROM LM_Itinerarios AS I
INNER JOIN LM_Recorridos AS R
ON I.estacionIni = R.estacion 
--Consulta.Tren, Consulta.Linea, Base.estacion AS PrimeraEstacion, Consulta.estacion AS SegundaEstacion,  Base.Momento as PrimerMomento, Consulta.SegundoMomento

SELECT *FROM

(SELECT Estaciones.Tren, Estaciones.Linea, Estaciones.estacion, Estaciones.SegundoMomento, MAX(Estaciones.Momento) AS PrimerMomento FROM (

	SELECT Estacion.Tren, Estacion.Linea, Estacion.estacion, Estacion.Momento AS SegundoMomento, EstacionAnterior.Momento FROM(

	SELECT Tren, Linea, estacion, Momento FROM LM_Recorridos AS R
	)AS Estacion

	INNER JOIN

	(SELECT Tren, Linea, estacion, Momento FROM LM_Recorridos AS R
	)AS EstacionAnterior

	ON	Estacion.Tren = EstacionAnterior.Tren AND Estacion.Momento > EstacionAnterior.Momento 

	
) AS Estaciones
GROUP BY Tren, Linea, estacion, SegundoMomento) AS Consulta 

INNER JOIN 

(SELECT Tren, Linea, estacion, Momento FROM LM_Recorridos AS R) AS Base

ON Consulta.PrimerMomento = Base.Momento

INNER JOIN LM_Itinerarios AS I
ON Base.estacion = I.estacionIni AND Consulta.estacion = I.estacionFin AND Base.Tren = Consulta.Tren AND Base.Linea = Consulta.Linea


