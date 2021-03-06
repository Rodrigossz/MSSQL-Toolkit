
USE [DbaDb]
GO
create FUNCTION fn_dba_nomeProc (@lastQuery varchar(max))
RETURNS varchar(50)
WITH EXECUTE AS CALLER
AS
BEGIN
     DECLARE @nomeProc varchar(50) 

select @lastQuery = (replace(@lastQuery,'create proc [dbo].',''))
select @lastQuery = (replace(@lastQuery,'create procedure [sys].',''))
select @lastQuery = (replace(@lastQuery,'create procedure sys.',''))
select @lastQuery = (replace(@lastQuery,' [',''))
select @lastQuery = (replace(@lastQuery,'--',''))
select @lastQuery = (replace(@lastQuery,char(10),''))
select @lastQuery = (replace(@lastQuery,char(13),''))
select @nomeProc = SUBSTRING (@lastQuery,1,CHArindex(']',@lastQuery,1))

     RETURN(@nomeProc)
END
GO


 ALTER PROC [dbo].[sp_dba_compare_ProcSnapshot] 
      (@start_snap_ID INT = NULL,
       @end_snap_ID INT = NULL)
AS
DECLARE @end_snp INT
DECLARE @start_snp INT
BEGIN

   SET NOCOUNT ON
   
   IF (@end_snap_ID IS NULL) 
      SELECT @end_snp = MAX(id) FROM [snapshot] s where tipo = 'PROC' and exists (select 1 from procSnapshot rc where rc.snapshotId = s.id)
      ELSE SET @end_snp = @end_snap_ID

   IF (@start_snap_ID IS NULL) 
      SELECT @start_snp = Min(id) FROM [snapshot] s where tipo = 'PROC' and id < @end_snp and dataHora >= DATEADD(hh,-12,getdate())
      and exists (select 1 from procSnapshot rc where rc.snapshotId = s.id)
      ELSE SET @start_snp = @start_snap_ID
      
      
   SELECT 'START = ',spid,command,login_name,blk,percent_complete,cpu_time,duration_secs,status,logical_reads,reads,writes,
db,wait_time,dbo.fn_dba_nomeProc (last_query) as last_Query,host_name
FROM procsnapshot A (nolock) WHERE a.snapshotId = @start_snp and last_Query like '%create %'
   union
   SELECT 'END = ',spid,command,login_name,blk,percent_complete,cpu_time,duration_secs,status,logical_reads,reads,writes,
db,wait_time, dbo.fn_dba_nomeProc (last_query) as last_Query,host_name
FROM procsnapshot A (nolock) WHERE a.snapshotId = @end_snp and last_Query like '%create %' 
union
   SELECT 'START = ',spid,command,login_name,blk,percent_complete,cpu_time,duration_secs,status,logical_reads,reads,writes,
db,wait_time, substring(last_query,CHArindex('begin',last_Query,1)  ,50) as last_Query,host_name
FROM procsnapshot A (nolock) WHERE a.snapshotId = @start_snp and last_Query not like '%create %'
   union
   SELECT 'END = ',spid,command,login_name,blk,percent_complete,cpu_time,duration_secs,status,logical_reads,reads,writes,
db,wait_time, substring(last_query,CHArindex('begin',last_Query,1)  ,50) as last_Query,host_name
FROM procsnapshot A (nolock) WHERE a.snapshotId = @end_snp and last_Query not like '%create %' 



order by 1 desc,2

  SET NOCOUNT OFF
END
go
exec [sp_dba_compare_ProcSnapshot]





  