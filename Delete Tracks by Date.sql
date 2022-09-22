
use marcus8

DECLARE @DT DATETIME = '2019-01-01'
if object_id('tempdb..#t') IS NOT NULL drop table #t

select TRACKSRID into #t from RNH01VSQL02.Marcus_2019.dbo.tracks
where utcsatdate >= @DT and utcsatdate < DATEADD(DD,1, @DT)

INSERT INTO DBA..TracksDelete_Log (TracksRID_Start, TracksRID_End, Deleted_Rows, Deleted_Time)
SELECT MIN(TracksRID), MAX(TracksRID), COUNT(*), GetDate() 
FROM TRACKS T with (nolock)
where T.utcsatdate >= @DT and T.utcsatdate < DATEADD(DD, 1, @DT)
AND TracksRID IN (SELECT Tracksrid FROM #t)

DELETE T FROM TRACKS T
where T.utcsatdate >= @DT and T.utcsatdate < DATEADD(DD, 1, @DT)
AND TracksRID IN (SELECT Tracksrid FROM #t)
GO
 --Until June 6th 


