--Delete EventsAttrs of 2019
use Marcus8

SET NOCOUNT ON 
/*
--Count check
SELECT COUNT(*) FROM Marcus8..EventsAttrs S WITH (NOLOCK)
INNER JOIN RNH01VSQL02.MARCUS_2019.dbo.EventsAttrs A
	ON S.EventsAttrsRID = A.EventsAttrsRID
INNER JOIN RNH01VSQL02.MARCUS_2019.dbo.vwEvents E
	ON S.EventsRid = E.EventsRID
WHERE (E.UTCActionDate >= '2019-01-01' AND E.UTCActionDate < '2020-01-01')
*/


DECLARE @StartRID bigint, @EndRID bigint, @Cnt int, @StartDate DateTime, @EndDate DateTime, @i int = 1

SELECT @StartDate = MAX(UTCActionDate_End) FROM DBA..EventsAttrsDelete_Log
SET @StartDate = ISNULL(@StartDate, '01/01/2019')
SET @EndDate = '07/01/2019'

WHILE @StartDate < @EndDate --and @i <= 100
BEGIN	
	IF OBJECT_ID('tempdb..#t') IS NOT NULL DROP TABLE #t 

	SELECT A.EventsAttrsRID INTO #t
	FROM RNH01VSQL02.MARCUS_2019.dbo.EventsAttrs A WITH (NOLOCK)	
	INNER JOIN RNH01VSQL02.MARCUS_2019.dbo.vwEvents E WITH (NOLOCK)
		ON A.EventsRid = E.EventsRID
	WHERE E.UTCActionDate >= @StartDate AND E.UTCActionDate < DATEADD(HOUR, 1, @StartDate)

	SELECT 
		@StartRID = MIN(EventsAttrsRID), 
		@EndRID = MAX(EventsAttrsRID) 
	FROM #t 

	DELETE S 
	FROM Marcus8..EventsAttrs S
	INNER JOIN #t t ON S.EventsAttrsRid = t.EventsAttrsRid

	SET @Cnt = @@ROWCOUNT 

	INSERT DBA..EventsAttrsDelete_Log  (TableName, RowsDeleted, EventsAttrsRID_Start, EventsAttrsRID_End, UTCActionDate_Start, UTCActionDate_End)
	SELECT 'EventsAttrs', @Cnt, @StartRID, @EndRID, @StartDate, DATEADD(HOUR, 1, @StartDate)

	PRINT @i 

	SET @StartDate = DATEADD(HOUR, 1, @StartDate)
	SET @i += 1

	IF @Cnt > 0 WAITFOR DELAY '00:00:03'
END
GO

select top 10 * from DBA..EventsAttrsDelete_Log 
order by 1 desc 
