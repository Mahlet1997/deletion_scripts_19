use Marcus8 
go
set nocount on 

declare @MinID bigint, @MaxID bigint, @Inc int = 20000, @i int = 1, @rc int

select @MinID = MIN(TracksRID) from Marcus8.dbo.tracks WITH (NOLOCK) WHERE UtcSatDate >= '2018-12-28' AND UtcSatDate < '2018-12-29'
select @MaxID = MAX(TracksRID) from RNH01VSQL02.Marcus_2019.dbo.tracks

while (@MinID <= @MaxID) AND (@i <= 20000)
BEGIN
	DELETE T
	FROM Marcus8..Tracks T
	INNER JOIN RNH01VSQL02.Marcus_2019.dbo.tracks D
	ON T.TracksRID = D.TracksRID 
	WHERE T.TracksRID >= @MinID AND T.TracksRID < @MinID + @Inc
	
	SET @rc = @@ROWCOUNT 
	IF @rc <> 0 	
	BEGIN 
		PRINT '@i = ' + CONVERT(varchar(10), @i)  + '; Deleted = ' + CONVERT(varchar(10), @rc)

		INSERT INTO DBA..TracksDelete_Log (TracksRID_Start, TracksRID_End, Deleted_Rows, Deleted_Time)
		SELECT @MinID, @MinID + @Inc -1, @rc, GetDate()
	END
	SET @MinID += @Inc
	SET @i+= 1
	WAITFOR DELAY '00:00:05'
END
GO



















































































