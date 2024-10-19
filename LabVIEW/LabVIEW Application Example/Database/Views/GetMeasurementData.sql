IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = 'GetMeasurementData' 
	   AND 	  type = 'V')
	DROP VIEW GetMeasurementData
GO

CREATE VIEW GetMeasurementData
AS

SELECT
MEASUREMENTDATA.MeasurementDataId, 
MEASUREMENT.MeasurementId, 
MEASUREMENT.MeasurementName, 
MEASUREMENTDATA.MeasurementTimeStamp, 
MEASUREMENTDATA.MeasurementValue


FROM MEASUREMENTDATA 
INNER JOIN MEASUREMENT ON MEASUREMENTDATA.MeasurementId = MEASUREMENT.MeasurementId

GO
