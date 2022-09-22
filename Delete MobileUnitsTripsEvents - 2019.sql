--Archive Delete MobileUnitsTripsEvents - 2019
USE Marcus8

/*
select MIN(UTCEndDate), MAX(UTCEndDate) from Marcus8..MobileUnitsTripsEvents with (nolock) WHERE UTCEndDate < '07/01/2019'
select MIN(UTCEndDate), MAX(UTCEndDate) from RNH01VSQL02.Marcus_2019.dbo.MobileUnitsTripsEvents
*/

SET NOCOUNT ON 

DECLARE @StartDate DateTime2, @EndDate DateTime, @RowCnt int

--Read from the log table
SELECT @StartDate = MAX(UTCEndDate_End) 
FROM DBA..MobileUnitsTripsEvents_Delete_Log
WHERE UTCEndDate_End < '07/01/2019'

IF @StartDate IS NULL
BEGIN
	SELECT @StartDate = MIN(UTCEndDate) 
	FROM RNH01VSQL02.Marcus_2019.dbo.MobileUnitsTripsEvents 
	WHERE UTCEndDate < '07/01/2019'
END

SET @EndDate = '07/01/2019'

SELECT @StartDate AS DeleteStartDate, @EndDate AS DeleteEndDate

WHILE @StartDate < @EndDate
BEGIN	
	IF OBJECT_ID('tempdb..#t') IS NOT NULL
	DROP TABLE #t

	SELECT MobileUnitsTripsEventsRID
	INTO #t
	FROM RNH01VSQL02.Marcus_2019.dbo.MobileUnitsTripsEvents
	WHERE UTCEndDate >= @StartDate AND UTCEndDate < DATEADD(DD, 1, @StartDate)

	IF EXISTS (SELECT * FROM #t)
	BEGIN
		DELETE MC
		FROM MobileUnitsTripsEvents MC
		INNER JOIN #t ETL
			ON MC.MobileUnitsTripsEventsRID = ETL.MobileUnitsTripsEventsRID
		WHERE MC.UTCEndDate >= @StartDate AND MC.UTCEndDate < DATEADD(DD, 1, @StartDate)

		SET @RowCnt = @@ROWCOUNT 

		INSERT DBA..MobileUnitsTripsEvents_Delete_Log(TableName, RowsDeleted, UTCEndDate_Start, UTCEndDate_End)		
		SELECT 'MobileUnitsTripsEvents', @RowCnt, @StartDate, DATEADD(DD, 1, @StartDate)
		
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



