




use Marcus8 
go
set nocount on 

declare @rc int, @StartDate DateTime, @EndDate DateTime, @i int = 1

select @StartDate = '01/01/2019' 

SET @EndDate = DATEADD(DD, 1, @StartDate)

WHILE @StartDate < '07/01/2019' AND @i <= 10
BEGIN
	DELETE A
	FROM Marcus8..AlertEvents A
	INNER JOIN RNH01VSQL02.Marcus_2019.dbo.AlertEvents B
	ON A.AlertEventsRid = B.AlertEventsRid
	WHERE A.UtcAlertDate >=  @StartDate AND A.UtcAlertDate < DATEADD(DD, 1, @StartDate)
	
	SET @rc = @@ROWCOUNT 
	IF @rc <> 0 	
	BEGIN 
		PRINT '@i = ' + CONVERT(varchar(10), @i)  + '; Deleted = ' + CONVERT(varchar(10), @rc)

		INSERT INTO DBA..AlertEventsDelete_Log(TableName,RowsDeleted, UTCAlertDate_Start, UTCAlertDate_End, DeleteDateTime)
		SELECT 'AlertEvents', @rc,@StartDate,@EndDate , GetDate()
	END
	SET @StartDate = DATEADD(DD, 1, @StartDate)
	SET @EndDate = DATEADD(DD, 1, @EndDate)
	SET @i += 1

	WAITFOR DELAY '00:00:02'
END
GO























































































