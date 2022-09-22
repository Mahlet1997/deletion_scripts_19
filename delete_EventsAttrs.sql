--Run in PRD cluster
--Delete eventsAttrs of 2019

use Marcus8 
go
set nocount on 

declare @MinID bigint, @MaxID bigint, @Inc int = 10, @i int = 1, @rc int

select @MinID = MIN(EventsAttrsRid) from Marcus8.dbo.EventsAttrs WITH (NOLOCK) where EventsAttrsRid > = 159976968 and  EventsAttrsRid < = 1575324426
select @MaxID = MAX(EventsAttrsRid) from RNH01VSQL02.Marcus_2019.dbo.EventsAttrs Where EventsAttrsRid > = 159976968 and  EventsAttrsRid < = 1575324426
while (@MinID <= @MaxID) AND (@i <= 10)
BEGIN
	DELETE E
	FROM Marcus8..EventsAttrs E
	INNER JOIN RNH01VSQL02.Marcus_2019.dbo.eventsAttrs F
	ON E.EventsAttrsRid = F.EventsAttrsRid 
	WHERE E.EventsAttrsRid >= @MinID AND E.EventsAttrsRid < @MinID + @Inc
	
	SET @rc = @@ROWCOUNT 
	IF @rc <> 0 	
	BEGIN 
		PRINT '@i = ' + CONVERT(varchar(10), @i)  + '; Deleted = ' + CONVERT(varchar(10), @rc)

		INSERT INTO DBA..EventsAttrsDelete_Log (EventsAttrsRid_Start, EventsAttrsRid_End, Deleted_Rows, Deleted_Time)
		SELECT @MinID, @MinID + @Inc -1, @rc, GetDate()
	END
	SET @MinID += @Inc
	SET @i+= 1
	WAITFOR DELAY '00:00:03'
END
GO
 
