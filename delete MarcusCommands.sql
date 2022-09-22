use prd cluster
use marcus_2019
go
set nocount on 

declare @rc int, @StartDate DateTime, @EndDate DateTime, @i int = 1

select @StartDate = '01/01/2019' 

SET @EndDate = DATEADD(DD, 1, @StartDate)

WHILE @StartDate < '07/01/2019' AND @i <= 1
BEGIN
	DELETE A
	FROM Marcus8..MarcusCommands A
	INNER JOIN RNH01VSQL02.Marcus_2019.dbo.MarcusCommands B
	ON A.MarcusCommandsRid = B.MarcusCommandsRid
	WHERE A.UTCReceivedDate >=  @StartDate AND A.UTCReceivedDate < DATEADD(DD, 1, @StartDate)
	
	SET @rc = @@ROWCOUNT 
	IF @rc <> 0 	
	BEGIN 
		PRINT '@i = ' + CONVERT(varchar(10), @i)  + '; Deleted = ' + CONVERT(varchar(10), @rc)

		INSERT INTO DBA..MarcusCommandsDelete_Log(TableName,RowsDeleted, UTCReceivedDate_Start, UTCReceivedDate_End, DeleteDateTime)
		SELECT 'MarcusCommands', @rc,@StartDate,@EndDate , GetDate()
	END
	SET @StartDate = DATEADD(DD, 1, @StartDate)
	SET @EndDate = DATEADD(DD, 1, @EndDate)
	SET @i += 1

	WAITFOR DELAY '00:00:02'
END
GO