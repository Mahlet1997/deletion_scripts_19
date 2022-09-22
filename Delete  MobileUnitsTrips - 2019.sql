--Archive Delete MobileUnitsTrips - 2019
USE Marcus8

/*
select MIN(UTCEndDate), MAX(UTCEndDate) from Marcus8..MobileUnitsTrips with (nolock) WHERE UTCEndDate < '07/01/2019'
select MIN(UTCEndDate), MAX(UTCEndDate) from RNH01VSQL02.Marcus_2019.dbo.MobileUnitsTrips
*/

SET NOCOUNT ON 

DECLARE @StartDate DateTime2, @EndDate DateTime, @RowCnt int

--Read from the log table
SELECT @StartDate = MAX(UTCEndDate_End) 
FROM DBA..MobileUnitsTrips_Delete_Log
WHERE UTCEndDate_End < '07/01/2019'

IF @StartDate IS NULL
BEGIN
	SELECT @StartDate = MIN(UTCEndDate) 
	FROM RNH01VSQL02.Marcus_2019.dbo.MobileUnitsTrips 
	WHERE UTCEndDate < '07/01/2019'
END

SELECT top 10 *
FROM RNH01VSQL02.Marcus_2019.dbo.MobileUnitsTrips 
WHERE UTCEndDate < '07/01/2019'

select * FROM RNH01VSQL02.Marcus_2019.dbo.MobileUnitsTrips 

SET @EndDate = '07/01/2019'

SELECT @StartDate AS DeleteStartDate, @EndDate AS DeleteEndDate

WHILE @StartDate < @EndDate
BEGIN	
	IF OBJECT_ID('tempdb..#t') IS NOT NULL
	DROP TABLE #t

	SELECT MobileUnitsTripsRID
	INTO #t
	FROM RNH01VSQL02.Marcus_2019.dbo.MobileUnitsTrips
	WHERE UTCEndDate >= @StartDate AND UTCEndDate < DATEADD(DD, 1, @StartDate)

	IF EXISTS (SELECT * FROM #t)
	BEGIN
		DELETE MC
		FROM MobileUnitsTrips MC
		INNER JOIN #t ETL
			ON MC.MobileUnitsTripsRID = ETL.MobileUnitsTripsRID
		WHERE MC.UTCEndDate >= @StartDate AND MC.UTCEndDate < DATEADD(DD, 1, @StartDate)

		SET @RowCnt = @@ROWCOUNT 

		INSERT DBA..MobileUnitsTripsDelete_Log(TableName, RowsDeleted, UTCEndDate_Start, UTCEndDate_End)		
		SELECT 'MobileUnitsTrips', @RowCnt, @StartDate, DATEADD(DD, 1, @StartDate)
		
		IF @RowCnt < 30000
			WAITFOR DELAY '00:00:03'	
		ELSE IF @RowCnt >= 30000 AND @RowCnt <= 50000
			WAITFOR DELAY '00:00:05'
		ELSE IF @RowCnt > 50000 AND @RowCnt <= 100000
			WAITFOR DELAY '00:00:10'
		ELSE IF @RowCnt > 100000 AND @RowCnt <= 150000
			WAITFOR DELAY '00:00:15'
		ELSE IF @RowCnt > 150000 
			WAITFOR DELAY '00:00:20'
	
	END
	SET @StartDate = DATEADD(DD, 1, @StartDate)
	
END
GO

