
--CONSULTAS RANDOMS 

--CALCULANDO EL IMPORTE EXTRA

--FORMA 1
SELECT S.ID,SUM(CASE S.Tipo WHEN 'E' THEN PP.precioE 
WHEN 'S' THEN PP.precioS ELSE 0 END)
FROM HSuscripciones AS S
INNER JOIN HPerfiles AS P ON S.ID=P.IDSuscripcion INNER JOIN HVisionados AS V 
ON P.ID=V.IDPerfil INNER JOIN HContenidos AS C ON V.IDContenido=C.ID
INNER JOIN HPeliculas AS PP ON C.ID=PP.ID
WHERE C.tipo='P'
GROUP BY S.ID


--FORMA 2
DECLARE @Importe money
SET @Importe= (SELECT S.ID, CASE S.tipo WHEN 'E' THEN SUM(PP.precioE)
WHEN 'S' THEN SUM(PP.precioS) END 
FROM HSuscripciones AS S
INNER JOIN HPerfiles AS P ON S.ID=P.IDSuscripcion INNER JOIN HVisionados AS V 
ON P.ID=V.IDPerfil INNER JOIN HContenidos AS C ON V.IDContenido=C.ID
INNER JOIN HPeliculas AS PP ON C.ID=PP.ID
WHERE C.tipo='P'
GROUP BY S.ID)


--CANTIDAD DE PELICULAS COMPRADAS POR USUARIOS
SELECT NPU.ID,COUNT(*) AS CantidadPeliculas FROM 
(SELECT S.ID,P.ID AS IDPeliculas, COUNT(DISTINCT P.ID) AS NPeliculas FROM HContenidos AS CN INNER JOIN HPeliculas AS P ON CN.ID=P.ID
INNER JOIN HVisionados AS V ON CN.ID=V.IDContenido INNER JOIN HPerfiles AS PP ON V.IDPerfil=PP.ID
INNER JOIN HSuscripciones AS S ON PP.IDSuscripcion=S.ID
WHERE CN.tipo='P'
GROUP BY S.ID,P.ID) AS NPU GROUP BY NPU.ID


GO
/*
* CABECERA: PROCEDURE PC_CrearRecibo @IdSuscripcion Int, @InicioPeriodo datetime, @FinPeriodo datetime
* ENTRADA: @IdSuscripcion Int, @InicioPeriodo datetime, @FinPeriodo datetime
* SALIDA: Ninguna
* Postcondiciones: Procedimiento para crear un recibo e insertar en la tabla
*/
CREATE OR ALTER PROCEDURE PC_CrearRecibo @IdSuscripcion Int, @InicioPeriodo datetime, @FinPeriodo datetime  AS
BEGIN 

    INSERT INTO HRecibos
    SELECT @IdSuscripcion, @InicioPeriodo, @FinPeriodo, CURRENT_TIMESTAMP, TS.importeMensual * DATEDIFF(MONTH, @InicioPeriodo, @FinPeriodo), CASE WHEN TS.tipo = 'P' THEN 0
                                                                                                                                                  WHEN TS.tipo = 'S' THEN SUM(PEL.precioS)
                                                                                                                                                  WHEN TS.tipo = 'E' THEN SUM(PEL.precioE)
                                                                                                                                                  END 
        FROM HSuscripciones AS S

        INNER JOIN HTiposSuscripcion AS TS ON S.tipo = TS.tipo
        INNER JOIN HPerfiles AS P ON S.ID = P.IDSuscripcion
        INNER JOIN HVisionados AS V ON P.ID = V.IDPerfil
        INNER JOIN HPeliculas AS PEL ON V.IDContenido = PEL.ID

END
GO

