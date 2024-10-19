IF EXISTS (SELECT name 
   FROM   sysobjects 
   WHERE  name = 'SaveMeasurementData' 
   AND   type = 'P')
DROP PROCEDURE SaveMeasurementData
GO

CREATE PROCEDURE SaveMeasurementData
@MeasurementName varchar(50),
@MeasurementValue float
AS

DECLARE
@MeasurementId int

if not exists (select * from MEASUREMENT where MeasurementName = @MeasurementName)
	insert into MEASUREMENT (MeasurementName) values (@MeasurementName)
else
	select @MeasurementId = MeasurementId from MEASUREMENT where MeasurementName = @MeasurementName


insert into MEASUREMENTDATA (MeasurementId, MeasurementValue, MeasurementTimeStamp) values (@MeasurementId, @MeasurementValue, getdate())

GO
