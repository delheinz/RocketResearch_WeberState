
CREATE TABLE [MEASUREMENT]
( 
	[MeasurementId]      int  NOT NULL  IDENTITY ( 1,1 ) Primary Key,
	[MeasurementName]    varchar(50)  NOT NULL UNIQUE 

)
go

CREATE TABLE [MEASUREMENTDATA]
( 
	[MeasurementDataId]  int  NOT NULL  IDENTITY ( 1,1 ) Primary Key,
	[MeasurementId]      int  NOT NULL Foreign Key REFERENCES MEASUREMENT(MeasurementId),
	[MeasurementTimeStamp] datetime  NOT NULL ,
	[MeasurementValue]   float  NOT NULL 
)
go
