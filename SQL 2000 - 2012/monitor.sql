USE [DbaDb]
GO
drop procedure [dbo].[sp_dba_OrphanUser]
go
drop TABLE [dbo].[VersaoPc]
GO



CREATE TABLE [dbo].[Snapshot](
	[id] [int] IDENTITY(1,1) primary key,
	[dataHora] [smalldatetime] NOT NULL,
	tipo tdsmalldesc not null,
	origem tdsmalldesc not null)
GO
CREATE NONCLUSTERED INDEX [snapshot_id01] ON [dbo].[snapshot] (dataHora) include (id)
GO
create index [snapshot_id02] ON [dbo].[snapshot] (tipo) include (id,datahora)
go

CREATE TABLE [dbo].[RowCountSnapshot](
	[id] [int] IDENTITY(1,1) primary key,
	snapshotId int not null references [snapshot],
	[db] [sysname] NOT NULL,
	[tabela] [sysname] NOT NULL,
	[linhas] [int] NOT NULl)
GO
CREATE NONCLUSTERED INDEX [RowCountSnapshot_ID01] ON RowCountSnapshot
(	snapshotId)INCLUDE ( [id])
GO
CREATE NONCLUSTERED INDEX [RowCountSnapshot_ID02] ON RowCountSnapshot
(	[tabela] ASC,	[db] ASC) INCLUDE ( [id]) 
GO


drop TABLE [dbo].[prodver]
GO

CREATE TABLE [dbo].[ProcSnapshot](
		[id] [int] IDENTITY(1,1) primary key,
	snapshotId int not null references [snapshot],
	[spid] [int] NULL,
	[command] [dbo].[tdDesc] NULL,
	[login_name] [dbo].[tdDesc] NULL,
	[host_name] [dbo].[tdDesc] NULL,
	[blk] [int] NULL,
	[percent_complete] [numeric](5, 2) NULL,
	[cpu_time] [bigint] NULL,
	[duration_secs] [int] NULL,
	[status] [dbo].[tdDesc] NULL,
	[logical_reads] [bigint] NULL,
	[reads] [bigint] NULL,
	[writes] [bigint] NULL,
	[db] [dbo].[tdDesc] NULL,
	[wait_time] [int] NULL,
	[last_Query] [varchar](max) NULL) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProcSnapshot_ID01] ON [dbo].ProcSnapshot 
(snapshotId ASC) INCLUDE ( [id]) 
GO
CREATE NONCLUSTERED INDEX [ProcSnapshot_ID02] ON [dbo].ProcSnapshot 
([spid] ASC) INCLUDE ( [id]) 
GO

CREATE TABLE [dbo].[IoSnapshot](
	[id] [int] IDENTITY(1,1) primary key,
	snapshotId int not null references [snapshot],
	[db_id] [smallint] NOT NULL,
	[file_id] [smallint] NOT NULL,
	[database_name] [sysname] NOT NULL,
	[physical_file_name] [sysname] NOT NULL,
	[Diff_Number_of_reads] [bigint] NULL,
	[Diff_Bytes_Read] [bigint] NULL,
	[Diff_Read_stall_time_ms] [bigint] NULL,
	[Diff_Number_of_writes] [bigint] NULL,
	[Diff_Bytes_written] [bigint] NULL,
	[Diff_Write_stall_time_ms] [bigint] NULL,
	[Diff_Read_Write_stall_ms] [bigint] NULL,
	[size_on_disk_MB] [bigint] NULL) 
GO
CREATE NONCLUSTERED INDEX [IoSnapshot_ID01] ON [dbo].ioSnapshot 
(snapshotId ASC) INCLUDE ( [id]) 
GO
CREATE NONCLUSTERED INDEX [IoSnapshot_ID02] ON [dbo].ioSnapshot 
([db_id],[file_id] ASC) INCLUDE ( [id]) 
GO
CREATE TABLE [dbo].[SpaceSnapshot](
	[id] [int] IDENTITY(1,1) primary key,
	snapshotId int not null references [snapshot],
	[medida] [dbo].[tdDesc] NOT NULL,
	[tamanhoMB] [numeric](10, 2) NOT NULL) 
GO
CREATE NONCLUSTERED INDEX [SpaceSnapshot_ID01] ON [dbo].SpaceSnapshot 
(	snapshotId ASC) iNCLUDE ( [id])
GO


create proc [dbo].[sp_dba_lista_snapshots]
@dtIni smalldatetime = null, @dtFim smalldatetime = null
as
begin
if @dtIni is null
select @dtIni = DATEADD(hh,-12,getdate()), @dtFim = GETDATE()

select top 20 * from [snapshot] (nolock)
where dataHora between @dtIni and @dtFim
order by dataHora desc
end
GO

create PROC [dbo].[sp_dba_carga_IoSnapshot]
@origem tdsmalldesc = 'NORMAL'
AS
BEGIN
   SET NOCOUNT ON
   declare @snapshotid int
   
   INSERT INTO [snapshot] SELECT GETDATE(), 'IO',@origem
   select @snapshotid = @@IDENTITY
  
  
   INSERT INTO IoSnapshot 
       (snapshotId,
       [db_id],
       [file_id],
       database_name ,
       physical_file_name,
       Diff_Number_of_reads,
       Diff_Bytes_Read,
       Diff_Read_stall_time_ms,
       Diff_Number_of_writes,
       Diff_Bytes_written,
       Diff_Write_stall_time_ms,
       Diff_Read_Write_stall_ms,
       size_on_disk_MB)
   SELECT
       @snapshotid,
       db_files.database_id,
       db_files.FILE_ID,
       DB_NAME(db_files.database_id) AS Database_Name,
       db_files.physical_name        AS File_actual_name,
       num_of_reads                  AS Number_of_reads,
       num_of_bytes_read             AS Bytes_Read,
       io_stall_read_ms              AS Read_time_stall_ms,
       num_of_writes                 AS Number_of_writes,
       num_of_bytes_written          AS Bytes_written,
       io_stall_write_ms             AS Write_time_stall_ms,
       io_stall                      AS Read_Write_stall_ms,
       size_on_disk_bytes / POWER(1024,2) AS size_on_disk_MB
   FROM 
       sys.dm_io_virtual_file_stats(NULL,NULL) dm_io_vf_stats ,
       sys.master_files db_files
   WHERE 
       db_files.database_id = dm_io_vf_stats.database_id
       AND db_files.[file_id] = dm_io_vf_stats.[file_id];

  SET NOCOUNT OFF

END
GO


create proc [dbo].[sp_dba_carga_RowCountSnapshot]
@origem tdsmalldesc = 'NORMAL'
AS
BEGIN
   SET NOCOUNT ON
   declare @snapshotid int
   
   INSERT INTO [snapshot] SELECT GETDATE(), 'ROWCOUNT',@origem
   select @snapshotid = @@IDENTITY
   
declare @dataHora smalldatetime = getdate()

--OLD
--select object_name(object_id) as Name,sum(rows) as Rows
--from sys.partitions 
--where objectproperty(object_id, 'IsUserTable') = 1 and index_id < 2
--group by object_name(object_id)
--order by 1


DECLARE @query VARCHAR(4000) 
DECLARE @temp TABLE (DBName VARCHAR(200),TABLEName VARCHAR(300), COUNT INT) 
SET @query='SELECT  ''?'',sysobjects.Name, sysindexes.Rows FROM   ?..sysobjects INNER JOIN ?..sysindexes ON sysobjects.id = sysindexes.id WHERE  type = ''U''  AND sysindexes.IndId < 2 order by sysobjects.Name' 
INSERT @temp EXEC sp_msforeachdb @query 

insert RowCountSnapshot select @snapshotid,DBName,TABLEName,count FROM @temp WHERE DBName not in ('tempdb','msdb','master','msdb')
end --proc
GO

create proc [dbo].[sp_dba_carga_ProcSnapshot]
@origem tdsmalldesc = 'NORMAL'
AS
BEGIN
   SET NOCOUNT ON
   declare @snapshotid int
   
   INSERT INTO [snapshot] SELECT GETDATE(), 'PROC',@origem
   select @snapshotid = @@IDENTITY


declare @dataHora smalldatetime = getdate()

insert ProcSnapshot (snapshotid,spid,command,login_name,host_name,blk,percent_complete,cpu_time,duration_secs,status,
logical_reads,reads,writes,db,wait_time,last_Query)
SELECT  @snapshotid, r.session_id,command,login_name,host_name,blocking_session_id,percent_complete,
r.cpu_time,r.total_elapsed_time/1000,r.status,r.logical_reads,r.reads,r.writes,
DB_NAME(database_id) AS [Database], r.wait_time ,[text] AS [LAST_Query]  
FROM sys.dm_exec_requests r  
CROSS APPLY sys.dm_exec_sql_text(r.plan_handle) st  
join sys.dm_exec_sessions p on r.session_id = p.session_id 
WHERE r.session_Id > 50   

union 
SELECT  @snapshotid, p.session_id,program_name,login_name,host_name,
blk=0,0,cpu_time,total_elapsed_time/1000,status,logical_reads,reads,writes,
null AS [Database], cpu_time ,null AS [LAST_Query]  
FROM sys.dm_exec_sessions p
WHERE 
exists (select 1 from sys.dm_exec_requests r2 where r2.blocking_session_id = p.session_id) 

end
GO

create proc [dbo].[sp_dba_carga_SpaceSnapshot]
@origem tdsmalldesc = 'NORMAL'
AS
BEGIN
   SET NOCOUNT ON
   declare @snapshotid int
   
   INSERT INTO [snapshot] SELECT GETDATE(), 'SPACE',@origem
   select @snapshotid = @@IDENTITY
   
declare @dataHora smalldatetime = getdate()

CREATE TABLE #TEMPSPACE
(DRIVE VARCHAR(20),
SPACE INT)

CREATE TABLE #TEMPDB
(name sysname,
db_size tdsmalldesc,
owner tdsmalldesc,
dbid smallint,
created datetime,
status tddesc,
compatibility_level smallint)


INSERT INTO #TEMPSPACE
EXEC XP_FIXEDDRIVES

INSERT INTO #TEMPDB
exec sp_helpdb

update #TEMPDB set db_size = REPLACE(db_size,' MB','')
update #TEMPDB set db_size = REPLACE(db_size,' ','')

insert space_snapshot
select @dataHora, 'Database '+name,db_size from #TEMPDB

insert spacesnapshot
select @snapshotid, 'Drive - Espaco Livre '+DRIVE,space from #TEMPSPACE

drop table #TEMPDB
drop table #TEMPSPACE
end --proc
GO

create PROC [dbo].[sp_dba_compare_IoSnapshot] 
      (@start_snap_ID INT = NULL,
       @end_snap_ID INT = NULL)
AS
DECLARE @end_snp INT
DECLARE @start_snp INT
BEGIN

   SET NOCOUNT ON
   
   IF (@end_snap_ID IS NULL) 
      SELECT @end_snp = MAX(id) FROM [snapshot] where tipo = 'IO'
      ELSE SET @end_snp = @end_snap_ID

   IF (@start_snap_ID IS NULL) 
      SELECT @start_snp = Min(id) FROM [snapshot] where tipo = 'IO' and id < @end_snp and dataHora >= DATEADD(hh,-12,getdate())
      ELSE SET @start_snp = @start_snap_ID

   
   SELECT 
       CONVERT(VARCHAR(12),S.dataHora,101) AS snapshot_creation_date,
       A.database_name,
       A.physical_file_name,
       A.size_on_disk_MB as Last_Size_MB,
       A.size_on_disk_MB - B.size_on_disk_MB as Diff_Size_MB,
       A.Diff_Number_of_reads - B.Diff_Number_of_reads   AS Diff_Number_of_reads,
       A.Diff_Bytes_read - B.Diff_Bytes_read             AS Diff_Bytes_read,
       A.Diff_Read_stall_time_ms -  B.Diff_Read_stall_time_ms AS Diff_Read_stall_time_ms,
       A.Diff_Number_of_writes - B.Diff_Number_of_writes AS Diff_Number_of_writes,
       A.Diff_Bytes_written - B.Diff_Bytes_written       AS Diff_Bytes_written,
       A.Diff_Write_stall_time_ms - B.Diff_Write_stall_time_ms AS Diff_Write_stall_time_ms,
       A.Diff_Read_Write_stall_ms - B.Diff_Read_Write_stall_ms AS Diff_Read_Write_stall_ms ,
       DATEDIFF (hh,S1.dataHora, S.dataHora) AS Diff_time_hours     
   FROM 
       [snapshot] S   
  join  iosnapshot A on S.id = A.snapshotId   
  join  iosnapshot B on  A.[db_id] = B.[db_id] AND  A.[file_id] = B.[file_id] 
  join  [snapshot] S1 on  S1.id = B.snapshotId
  
   WHERE 
       S.id = @end_snp AND 
       B.snapshotId = @start_snp AND 
       S1.id = @start_snp 
       
   ORDER BY 
       A.database_name,
       A.physical_file_name       

  SET NOCOUNT OFF
END
GO

CREATE PROC [dbo].[sp_dba_compare_RowCountSnapshot] 
      (@start_snap_ID INT = NULL,
       @end_snap_ID INT = NULL)
AS
DECLARE @end_snp INT
DECLARE @start_snp INT
BEGIN

   SET NOCOUNT ON
   
   IF (@end_snap_ID IS NULL) 
      SELECT @end_snp = MAX(id) FROM [snapshot] where tipo = 'ROWCOUNT'
      ELSE SET @end_snp = @end_snap_ID

   IF (@start_snap_ID IS NULL) 
      SELECT @start_snp = Min(id) FROM [snapshot] where tipo = 'ROWCOUNT' and id < @end_snp and dataHora >= DATEADD(hh,-12,getdate())
      ELSE SET @start_snp = @start_snap_ID

  
   SELECT top 20
      a.db,a.tabela,s.datahora, a.linhas as Linhas_Antes,s1.dataHora, b.linhas as Linhas_Depois, b.linhas - a.linhas as Diferenca
   FROM 
       [snapshot] S   
  join  RowCountSnapshot A on S.id = A.snapshotId   
  join  RowCountSnapshot B on  A.db = B.db AND  A.tabela = B.tabela 
  join  [snapshot] S1 on  S1.id = B.snapshotId
  
   WHERE 
       S.id = @end_snp AND 
       B.snapshotId = @start_snp AND 
       S1.id = @start_snp 
   ORDER BY  b.linhas - a.linhas desc ,b.linhas desc
   
--old   
--          a.datahora = @startDate and b.datahora = @endDate 
--and a.id = (Select MAX(id) from rowCount_snapshot c where a.tabela = c.tabela and a.db = c.db and c.dataHora = @startDate)
--and b.id = (Select MAX(id) from rowCount_snapshot d where b.tabela = d.tabela and b.db = d.db and d.dataHora = @endDate)

  SET NOCOUNT OFF
END
GO

create PROC [dbo].[sp_dba_compare_SpaceSnapshot] 
      (@start_snap_ID INT = NULL,
       @end_snap_ID INT = NULL)
AS
DECLARE @end_snp INT
DECLARE @start_snp INT
BEGIN

   SET NOCOUNT ON
   
   IF (@end_snap_ID IS NULL) 
      SELECT @end_snp = MAX(id) FROM [snapshot] where tipo = 'SPACE'
      ELSE SET @end_snp = @end_snap_ID

   IF (@start_snap_ID IS NULL) 
      SELECT @start_snp = Min(id) FROM [snapshot] where tipo = 'SPACE' and id < @end_snp and dataHora >= DATEADD(hh,-12,getdate())
      ELSE SET @start_snp = @start_snap_ID

   
   SELECT 
      a.medida,s.datahora, a.tamanhoMB as TamanhoMB_Antes,s1.dataHora, b.tamanhoMB as TamanhoMB_Depois,
      a.tamanhoMB - b.tamanhoMB as DiferencaMB
   FROM 
       [snapshot] S   
  join  SpaceSnapshot A on S.id = A.snapshotId   
  join  SpaceSnapshot B on  A.medida = B.medida 
  join  [snapshot] S1 on  S1.id = B.snapshotId
  
   WHERE 
       S.id = @end_snp AND 
       B.snapshotId = @start_snp AND 
       S1.id = @start_snp 
       
   ORDER BY 
       s.dataHora,a.medida,
       s1.dataHora,b.medida

  SET NOCOUNT OFF
END
GO

create PROC [dbo].[sp_dba_compare_ProcSnapshot] 
      (@start_snap_ID INT = NULL,
       @end_snap_ID INT = NULL)
AS
DECLARE @end_snp INT
DECLARE @start_snp INT
BEGIN

   SET NOCOUNT ON
   
   IF (@end_snap_ID IS NULL) 
      SELECT @end_snp = MAX(id) FROM [snapshot] where tipo = 'PROC'
      ELSE SET @end_snp = @end_snap_ID

   IF (@start_snap_ID IS NULL) 
      SELECT @start_snp = Min(id) FROM [snapshot] where tipo = 'PROC' and id < @end_snp and dataHora >= DATEADD(hh,-12,getdate())
      ELSE SET @start_snp = @start_snap_ID
      
      
   SELECT *  FROM procsnapshot A (nolock) WHERE a.snapshotId = @start_snp order by spid
   SELECT *  FROM procsnapshot A (nolock) WHERE a.snapshotId = @end_snp order by spid

  SET NOCOUNT OFF
END
GO

create proc sp_dba_SnapshotReport
as
begin
set nocount on

select 'Last 12 hs',origem as Origem, COUNT(*) as Qtd from [Snapshot] where dataHora >= DATEADD(dd,-12,getdate()) group by origem
select 'Last 24 hs',origem as Origem, COUNT(*) as Qtd from [Snapshot] where dataHora >= DATEADD(dd,-24,getdate()) group by origem
select 'Last 48 hs',origem as Origem, COUNT(*) as Qtd from [Snapshot] where dataHora >= DATEADD(dd,-48,getdate()) group by origem

end
go

drop proc sp_dba_lista_io_snapshots
go
drop PROC [dbo].[sp_dba_carga_io_snapshots]
go
drop proc [dbo].[sp_dba_carga_proc_snapshot]
go
drop proc [dbo].[sp_dba_carga_space_snapshot]
go
drop PROC [dbo].[sp_dba_compare_rowCount_snapshot_bcp] 
go
drop PROC [dbo].[sp_dba_compare_rowCount_snapshot] 
go
drop PROC [dbo].[sp_dba_compare_space_snapshots_bcp] 
go
drop PROC [dbo].[sp_dba_compare_space_snapshots] 
go
drop PROC [dbo].[sp_dba_compare_proc_snapshots_bcp] 
go
drop PROC [dbo].[sp_dba_compare_proc_snapshots] 
go
drop PROC [dbo].[sp_dba_compare_io_snapshots_bcp] 
go
drop PROC [dbo].[sp_dba_compare_io_snapshots] 
go
drop proc sp_dba_carga_rowCount_snapshot
go

exec sp_dba_pr

sp_dba_lista_snapshots