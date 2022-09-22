--Run in PRD cluster
--Delete events of 2019
use Marcus8 
go
set nocount on 

declare @rc int, @StartDateTime DateTime, @EndDateTime DateTime, @i int = 1

select @StartDateTime = '01/01/2019'

SET @EndDateTime = DATEADD(DD, 1, @StartDateTime)

WHILE @StartDateTime < '07/01/2019' AND @i <= 10
BEGIN
	
	if object_id('tempdb..#t') IS NOT NULL drop table #t

	SELECT EventsRID INTO #t 
	FROM RNH01VSQL02.Marcus_2019.dbo.vwEvents
	WHERE UtcActionDate >= @StartDateTime and UtcActionDate < @EndDateTime
	AND EventsRID NOT IN (SELECT EventsRID FROM Marcus8..UserAttendanceActions where eventsrid is not null)
		
	SET @rc = @@ROWCOUNT
	--IF @rc <> 0 PRINT '@i = ' + CONVERT(varchar(10), @i)  + '; Archived Records = ' + CONVERT(varchar(10), @rc)		

	IF @rc > 0
	BEGIN
		DELETE FROM Marcus8..Events
		WHERE EventsRID IN (SELECT EventsRID FROM #t)
		AND UtcActionDate >= @StartDateTime and UtcActionDate < @EndDateTime
	
		SET @rc = @@ROWCOUNT
		IF @rc <> 0 
		BEGIN
			PRINT '@i = ' + CONVERT(varchar(10), @i)  + '; Deleted now = ' + CONVERT(varchar(10), @rc)		
			INSERT INTO DBA..EventsDelete_Log (TableName, UTCActionDate_Start, UTCActionDate_End, RowsDeleted, DeleteDateTime)
			SELECT 'Events', @StartDateTime, DATEADD(DD, 1, @StartDateTime), @rc, GetDate()
		END
	END
	SET @StartDateTime = DATEADD(DD, 1, @StartDateTime)
	SET @EndDateTime = DATEADD(DD, 1, @EndDateTime)
	SET @i += 1
	
	WAITFOR DELAY '00:00:10'
END
GO

select top 10 * from DBA.dbo.EventsDelete_Log order by 1 desc
