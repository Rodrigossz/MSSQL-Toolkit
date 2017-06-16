USE [master]
GO

/****** Object:  StoredProcedure [dbo].[sp_who3]    Script Date: 3/11/2015 11:17:03 AM ******/
DROP PROCEDURE [dbo].[sp_who3]
GO

/****** Object:  StoredProcedure [dbo].[sp_dba_TopCPUQueries]    Script Date: 3/11/2015 11:17:03 AM ******/
DROP PROCEDURE [dbo].[sp_dba_TopCPUQueries]
GO

/****** Object:  StoredProcedure [dbo].[sp_dba_tableCheck]    Script Date: 3/11/2015 11:17:03 AM ******/
DROP PROCEDURE [dbo].[sp_dba_tableCheck]
GO

/****** Object:  StoredProcedure [dbo].[sp_dba_Runs]    Script Date: 3/11/2015 11:17:03 AM ******/
DROP PROCEDURE [dbo].[sp_dba_Runs]
GO

/****** Object:  StoredProcedure [dbo].[sp_dba_procMissingIndex]    Script Date: 3/11/2015 11:17:03 AM ******/
DROP PROCEDURE [dbo].[sp_dba_procMissingIndex]
GO

/****** Object:  StoredProcedure [dbo].[sp_dba_proc33]    Script Date: 3/11/2015 11:17:03 AM ******/
DROP PROCEDURE [dbo].[sp_dba_proc33]
GO

/****** Object:  StoredProcedure [dbo].[sp_dba_indexUsage]    Script Date: 3/11/2015 11:17:03 AM ******/
DROP PROCEDURE [dbo].[sp_dba_indexUsage]
GO

/****** Object:  StoredProcedure [dbo].[sp_dba_indexSizes]    Script Date: 3/11/2015 11:17:03 AM ******/
DROP PROCEDURE [dbo].[sp_dba_indexSizes]
GO

/****** Object:  StoredProcedure [dbo].[sp_dba_index2]    Script Date: 3/11/2015 11:17:03 AM ******/
DROP PROCEDURE [dbo].[sp_dba_index2]
GO

/****** Object:  StoredProcedure [dbo].[sp_dba_dupIndex]    Script Date: 3/11/2015 11:17:03 AM ******/
DROP PROCEDURE [dbo].[sp_dba_dupIndex]
GO

/****** Object:  StoredProcedure [dbo].[sp_blocked]    Script Date: 3/11/2015 11:17:03 AM ******/
DROP PROCEDURE [dbo].[sp_blocked]
GO

/****** Object:  StoredProcedure [dbo].[sp_blocked]    Script Date: 3/11/2015 11:17:03 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[sp_blocked]
@spid int
as
create table #Blocked
(spid int)
insert into #Blocked
(spid)
values
(@spid)

while @@ROWCOUNT <> 0
BEGIN
insert into #Blocked
(spid)
select spid 
from master.sys.sysprocesses 
where blocked in (select spid from #Blocked)
and spid not in (select spid from #Blocked)
END

delete from #Blocked
where spid = @spid

delete from #Blocked
where spid is null

if exists(select * from #Blocked)
BEGIN
select *
from master.sys.sysprocesses
where spid in (select spid from #blocked)
END
else
BEGIN
select 'No Processes are being blocked by spid ' + convert(varchar(20), @spid) + '.' as 'System Message'
END

drop table #Blocked

GO

/****** Object:  StoredProcedure [dbo].[sp_dba_dupIndex]    Script Date: 3/11/2015 11:17:04 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[sp_dba_dupIndex]
as
WITH  CTE_INDEX_DATA 

AS ( SELECT SCHEMA_DATA.name AS schema_name 

, TABLE_DATA.name AS table_name 

, INDEX_DATA.name AS index_name 

, STUFF(( SELECT  ', ' + COLUMN_DATA_KEY_COLS.name 

FROM    sys.tables AS T 

INNER JOIN sys.indexes INDEX_DATA_KEY_COLS ON T.object_id = INDEX_DATA_KEY_COLS.object_id 

INNER JOIN sys.index_columns INDEX_COLUMN_DATA_KEY_COLS ON INDEX_DATA_KEY_COLS.object_id = INDEX_COLUMN_DATA_KEY_COLS.object_id 

                            AND INDEX_DATA_KEY_COLS.index_id = INDEX_COLUMN_DATA_KEY_COLS.index_id 

INNER JOIN sys.columns COLUMN_DATA_KEY_COLS ON T.object_id = COLUMN_DATA_KEY_COLS.object_id 

                            AND INDEX_COLUMN_DATA_KEY_COLS.column_id = COLUMN_DATA_KEY_COLS.column_id 

WHERE   INDEX_DATA.object_id = INDEX_DATA_KEY_COLS.object_id 

AND INDEX_DATA.index_id = INDEX_DATA_KEY_COLS.index_id 

AND INDEX_COLUMN_DATA_KEY_COLS.is_included_column = 0 

ORDER BY INDEX_COLUMN_DATA_KEY_COLS.key_ordinal 

FOR 

XML PATH('') 

), 1, 2, '') AS key_column_list 

, STUFF(( SELECT  ', ' + COLUMN_DATA_INC_COLS.name 

FROM    sys.tables AS T 

INNER JOIN sys.indexes INDEX_DATA_INC_COLS ON T.object_id = INDEX_DATA_INC_COLS.object_id 

INNER JOIN sys.index_columns INDEX_COLUMN_DATA_INC_COLS ON INDEX_DATA_INC_COLS.object_id = INDEX_COLUMN_DATA_INC_COLS.object_id 

                            AND INDEX_DATA_INC_COLS.index_id = INDEX_COLUMN_DATA_INC_COLS.index_id 

INNER JOIN sys.columns COLUMN_DATA_INC_COLS ON T.object_id = COLUMN_DATA_INC_COLS.object_id 

                            AND INDEX_COLUMN_DATA_INC_COLS.column_id = COLUMN_DATA_INC_COLS.column_id 

WHERE   INDEX_DATA.object_id = INDEX_DATA_INC_COLS.object_id 

AND INDEX_DATA.index_id = INDEX_DATA_INC_COLS.index_id 

AND INDEX_COLUMN_DATA_INC_COLS.is_included_column = 1 

ORDER BY INDEX_COLUMN_DATA_INC_COLS.key_ordinal 

FOR 

XML PATH('') 

), 1, 2, '') AS include_column_list 

FROM   sys.indexes INDEX_DATA 

INNER JOIN sys.tables TABLE_DATA ON TABLE_DATA.object_id = INDEX_DATA.object_id 

INNER JOIN sys.schemas SCHEMA_DATA ON SCHEMA_DATA.schema_id = TABLE_DATA.schema_id 

WHERE  TABLE_DATA.is_ms_shipped = 0 

AND INDEX_DATA.type_desc IN ( 'NONCLUSTERED', 'CLUSTERED' ) 

) 

SELECT  * 

FROM    CTE_INDEX_DATA DUPE1 

WHERE   EXISTS ( SELECT * 

FROM   CTE_INDEX_DATA DUPE2 

WHERE  DUPE1.schema_name = DUPE2.schema_name 

AND DUPE1.table_name = DUPE2.table_name 

AND ( DUPE1.key_column_list LIKE LEFT(DUPE2.key_column_list, 

                            LEN(DUPE1.key_column_list)) 

OR DUPE2.key_column_list LIKE LEFT(DUPE1.key_column_list, 

                            LEN(DUPE2.key_column_list)) 

) 

AND DUPE1.index_name <> DUPE2.index_name )


GO

/****** Object:  StoredProcedure [dbo].[sp_dba_index2]    Script Date: 3/11/2015 11:17:04 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[sp_dba_index2]
as
begin
set nocount on

select 'duplicated indexes'

;WITH MyDuplicate AS (SELECT 
	Sch.[name] AS SchemaName,
	Obj.[name] AS TableName,
	Idx.[name] AS IndexName,
	INDEX_Col(Sch.[name] + '.' + Obj.[name], Idx.index_id, 1) AS Col1,
	INDEX_Col(Sch.[name] + '.' + Obj.[name], Idx.index_id, 2) AS Col2,
	INDEX_Col(Sch.[name] + '.' + Obj.[name], Idx.index_id, 3) AS Col3,
	INDEX_Col(Sch.[name] + '.' + Obj.[name], Idx.index_id, 4) AS Col4,
	INDEX_Col(Sch.[name] + '.' + Obj.[name], Idx.index_id, 5) AS Col5,
	INDEX_Col(Sch.[name] + '.' + Obj.[name], Idx.index_id, 6) AS Col6,
	INDEX_Col(Sch.[name] + '.' + Obj.[name], Idx.index_id, 7) AS Col7,
	INDEX_Col(Sch.[name] + '.' + Obj.[name], Idx.index_id, 8) AS Col8,
	INDEX_Col(Sch.[name] + '.' + Obj.[name], Idx.index_id, 9) AS Col9,
	INDEX_Col(Sch.[name] + '.' + Obj.[name], Idx.index_id, 10) AS Col10,
	INDEX_Col(Sch.[name] + '.' + Obj.[name], Idx.index_id, 11) AS Col11,
	INDEX_Col(Sch.[name] + '.' + Obj.[name], Idx.index_id, 12) AS Col12,
	INDEX_Col(Sch.[name] + '.' + Obj.[name], Idx.index_id, 13) AS Col13,
	INDEX_Col(Sch.[name] + '.' + Obj.[name], Idx.index_id, 14) AS Col14,
	INDEX_Col(Sch.[name] + '.' + Obj.[name], Idx.index_id, 15) AS Col15,
	INDEX_Col(Sch.[name] + '.' + Obj.[name], Idx.index_id, 16) AS Col16
FROM sys.indexes Idx
INNER JOIN sys.objects Obj ON Idx.[object_id] = Obj.[object_id]
INNER JOIN sys.schemas Sch ON Sch.[schema_id] = Obj.[schema_id]
WHERE index_id > 0)

SELECT	MD1.SchemaName, MD1.TableName, MD1.IndexName, 
		MD2.IndexName AS OverLappingIndex,
		MD1.Col1, MD1.Col2, MD1.Col3, MD1.Col4, 
		MD1.Col5, MD1.Col6, MD1.Col7, MD1.Col8, 
		MD1.Col9, MD1.Col10, MD1.Col11, MD1.Col12, 
		MD1.Col13, MD1.Col14, MD1.Col15, MD1.Col16
FROM MyDuplicate MD1
INNER JOIN MyDuplicate MD2 ON MD1.tablename = MD2.tablename
	AND MD1.indexname <> MD2.indexname
	AND MD1.Col1 = MD2.Col1
	AND (MD1.Col2 IS NULL OR MD2.Col2 IS NULL OR MD1.Col2 = MD2.Col2)
	AND (MD1.Col3 IS NULL OR MD2.Col3 IS NULL OR MD1.Col3 = MD2.Col3)
	AND (MD1.Col4 IS NULL OR MD2.Col4 IS NULL OR MD1.Col4 = MD2.Col4)
	AND (MD1.Col5 IS NULL OR MD2.Col5 IS NULL OR MD1.Col5 = MD2.Col5)
	AND (MD1.Col6 IS NULL OR MD2.Col6 IS NULL OR MD1.Col6 = MD2.Col6)
	AND (MD1.Col7 IS NULL OR MD2.Col7 IS NULL OR MD1.Col7 = MD2.Col7)
	AND (MD1.Col8 IS NULL OR MD2.Col8 IS NULL OR MD1.Col8 = MD2.Col8)
	AND (MD1.Col9 IS NULL OR MD2.Col9 IS NULL OR MD1.Col9 = MD2.Col9)
	AND (MD1.Col10 IS NULL OR MD2.Col10 IS NULL OR MD1.Col10 = MD2.Col10)
	AND (MD1.Col11 IS NULL OR MD2.Col11 IS NULL OR MD1.Col11 = MD2.Col11)
	AND (MD1.Col12 IS NULL OR MD2.Col12 IS NULL OR MD1.Col12 = MD2.Col12)
	AND (MD1.Col13 IS NULL OR MD2.Col13 IS NULL OR MD1.Col13 = MD2.Col13)
	AND (MD1.Col14 IS NULL OR MD2.Col14 IS NULL OR MD1.Col14 = MD2.Col14)
	AND (MD1.Col15 IS NULL OR MD2.Col15 IS NULL OR MD1.Col15 = MD2.Col15)
	AND (MD1.Col16 IS NULL OR MD2.Col16 IS NULL OR MD1.Col16 = MD2.Col16)
ORDER BY
	MD1.SchemaName,MD1.TableName,MD1.IndexName
	

select 'Missing indexes'
select d.name AS DatabaseName, mid.* 
from sys.dm_db_missing_index_details mid  
join sys.databases d ON mid.database_id=d.database_id

SELECT TOP 25
dm_mid.database_id AS DatabaseID, 
dm_migs.avg_user_impact*(dm_migs.user_seeks+dm_migs.user_scans) Avg_Estimated_Impact,
dm_migs.last_user_seek AS Last_User_Seek,
object_name(dm_mid.object_id,dm_mid.database_id) AS [TableName],
'CREATE INDEX [IX_' + object_name(dm_mid.object_id,dm_mid.database_id) + '_'
+ REPLACE(REPLACE(REPLACE(ISNULL(dm_mid.equality_columns,''),', ','_'),'[',''),']','') +
CASE
	WHEN dm_mid.equality_columns IS NOT NULL AND dm_mid.inequality_columns IS NOT NULL THEN '_'
	ELSE ''
END
+ REPLACE(REPLACE(REPLACE(ISNULL(dm_mid.inequality_columns,''),', ','_'),'[',''),']','')
+ ']'
+ ' ON ' + dm_mid.statement
+ ' (' + ISNULL (dm_mid.equality_columns,'')
+ CASE WHEN dm_mid.equality_columns IS NOT NULL AND dm_mid.inequality_columns IS NOT NULL THEN ',' ELSE
'' END
+ ISNULL (dm_mid.inequality_columns, '')
+ ')'
+ ISNULL (' INCLUDE (' + dm_mid.included_columns + ')', '') AS Create_Statement
FROM sys.dm_db_missing_index_groups dm_mig
INNER JOIN sys.dm_db_missing_index_group_stats dm_migs
ON dm_migs.group_handle = dm_mig.index_group_handle
INNER JOIN sys.dm_db_missing_index_details dm_mid
ON dm_mig.index_handle = dm_mid.index_handle
WHERE dm_mid.database_ID = DB_ID()
ORDER BY Avg_Estimated_Impact DESC 



select 'Unused indexes'
SELECT TOP 25
 o.name AS ObjectName
 , i.name AS IndexName
 , i.index_id AS IndexID
 , dm_ius.user_seeks AS UserSeek
 , dm_ius.user_scans AS UserScans
 , dm_ius.user_lookups AS UserLookups
 , dm_ius.user_updates AS UserUpdates
 , p.TableRows
 , 'DROP INDEX ' + QUOTENAME(i.name)
 + ' ON ' + QUOTENAME(s.name) + '.' + QUOTENAME(OBJECT_NAME(dm_ius.OBJECT_ID)) AS 'drop statement'
 FROM sys.dm_db_index_usage_stats dm_ius
 INNER JOIN sys.indexes i ON i.index_id = dm_ius.index_id AND dm_ius.OBJECT_ID = i.OBJECT_ID
 INNER JOIN sys.objects o ON dm_ius.OBJECT_ID = o.OBJECT_ID
 INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
 INNER JOIN (SELECT SUM(p.rows) TableRows, p.index_id, p.OBJECT_ID
 FROM sys.partitions p GROUP BY p.index_id, p.OBJECT_ID) p
 ON p.index_id = dm_ius.index_id AND dm_ius.OBJECT_ID = p.OBJECT_ID
 WHERE OBJECTPROPERTY(dm_ius.OBJECT_ID,'IsUserTable') = 1
 AND dm_ius.database_id = DB_ID()
 AND i.type_desc = 'nonclustered'
 AND i.is_primary_key = 0
 AND i.is_unique_constraint = 0
 ORDER BY (dm_ius.user_seeks + dm_ius.user_scans + dm_ius.user_lookups) ASC
 
 
end

GO

/****** Object:  StoredProcedure [dbo].[sp_dba_indexSizes]    Script Date: 3/11/2015 11:17:05 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[sp_dba_indexSizes] as

SELECT OBJECT_NAME(i.OBJECT_ID) AS TableName,
i.name AS IndexName,
i.index_id AS IndexID,
8 * SUM(a.used_pages) AS 'Indexsize(KB)'
FROM sys.indexes AS i
JOIN sys.partitions AS p ON p.OBJECT_ID = i.OBJECT_ID AND p.index_id = i.index_id
JOIN sys.allocation_units AS a ON a.container_id = p.partition_id
GROUP BY i.OBJECT_ID,i.index_id,i.name
ORDER BY [Indexsize(KB)] desc

SELECT db_name()as db,OBJECT_NAME(i.OBJECT_ID) AS TableName,
i.name AS IndexName,
i.index_id AS IndexID,
(8 * SUM(a.used_pages))/1024 AS 'Indexsize(MB)'
FROM sys.indexes AS i
JOIN sys.partitions AS p ON p.OBJECT_ID = i.OBJECT_ID AND p.index_id = i.index_id
JOIN sys.allocation_units AS a ON a.container_id = p.partition_id
where i.index_id > 1 
GROUP BY i.OBJECT_ID,i.index_id,i.name
having (8 * SUM(a.used_pages)) > 500000
ORDER BY [Indexsize(MB)] desc
GO

/****** Object:  StoredProcedure [dbo].[sp_dba_indexUsage]    Script Date: 3/11/2015 11:17:06 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[sp_dba_indexUsage]
   @table_name NVARCHAR(520) = NULL
AS
BEGIN
   SET NOCOUNT ON;
   SELECT
       table_name = QUOTENAME(OBJECT_SCHEMA_NAME(i.object_id))
         + '.' + QUOTENAME(OBJECT_NAME(i.object_id)),
       index_name = QUOTENAME(i.name),
       s.user_seeks,       s.user_scans,       s.user_lookups,       s.user_updates,
       s.last_user_seek,       s.last_user_scan,       s.last_user_lookup,       s.last_user_update
   FROM
       sys.indexes  i    left JOIN
       sys.dm_db_index_usage_stats  s  ON i.[object_id] = s.[object_id]  AND i.[index_id] = s.[index_id]
   WHERE
       s.database_id = DB_ID()
       AND i.object_id = COALESCE(OBJECT_ID(@table_name), i.object_id)
       
union
SELECT
table_name = QUOTENAME(OBJECT_SCHEMA_NAME(i.object_id))
 + '.' + QUOTENAME(OBJECT_NAME(i.object_id)),
index_name = QUOTENAME(i.name),
s.user_seeks,       s.user_scans,       s.user_lookups,       s.user_updates,
s.last_user_seek,       s.last_user_scan,       s.last_user_lookup,       s.last_user_update
from sys.objects o 
inner join sys.indexes i ON i.[object_id] = o.[object_id] 
left join sys.dm_db_index_usage_stats s on i.index_id = s.index_id and s.object_id = i.object_id
where object_name (o.object_id) is not null
and object_name (s.object_id) is null
AND o.[type] = 'U' and isnull( i.name,'HEAP') <>'HEAP'       

   ORDER BY
       table_name,
       index_name;
END

GO

/****** Object:  StoredProcedure [dbo].[sp_dba_proc33]    Script Date: 3/11/2015 11:17:06 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[sp_dba_proc33] @type varchar(20) = 'TELA'
as
set nocount on

declare @result table (
Spid int,
Cmd sysname,
LoginName sysname,
HostName sysname,
BlkBy int,
TranCount int,
ResultCount int,
PerCentComplete smallint,
LastWaitType sysname,
CpuTime bigint,
DurationSeconds int,
ActualStatus sysname,
LogicalReads bigint,
Reads bigint,
Writes bigint,
DbName sysname,
ProgramName sysname,
WaitTime bigint, 
LastQuery varchar(400),
ProcType varchar(20),
ProcDateTime smalldatetime)

declare @sysprocesses table (
spid int,
kpid int,
blocked int,
waittime int,
dbid int,
cpu int,
physical_io int,
login_time datetime,
last_batch datetime,
open_tran int,
status sysname,
cmd sysname,
loginame sysname,
nt_username sysname,
hostname sysname, 
lastwaittype sysname,
program_name sysname)
--select * from master..sysprocesses
insert @sysprocesses select 
spid ,kpid ,blocked ,waittime ,dbid ,cpu ,physical_io ,login_time ,
last_batch ,open_tran ,status ,cmd ,loginame ,nt_username,hostname,lastwaittype,program_name 
from master..sysprocesses where spid > 50


insert @result
select spid=r.session_id,command,isnull(case 
when login_name is not null and login_name <> '' and login_name not like '% %' then login_name
else nt_user_name end,'unknown'),
host_name,blk=blocking_session_id,r.open_transaction_count,
Result_Count = open_resultset_count, percent_complete,r.last_wait_type,
r.cpu_time,duration_secs=r.total_elapsed_time/1000,r.status,r.logical_reads,r.reads,r.writes,
DB_NAME(r.database_id),program_name, r.wait_time/1000 , substring([text],1,400) ,@type,GETDATE()  
FROM sys.dm_exec_requests r  
inner join sys.dm_exec_sessions p on r.session_id = p.session_id 
CROSS APPLY sys.dm_exec_sql_text(sql_handle) st  
CROSS APPLY sys.dm_exec_query_plan(plan_handle) As P2
--WHERE --r.session_Id > 50   and r.session_Id <> @@spid
union all
select spid=p.session_id,'BEGIN TRAN',case 
when login_name is not null and login_name <> '' and login_name not like '% %' then login_name
else nt_user_name end,host_name,0,1,
0, 0,'AWAITNG COMMAND',0,
DATEDIFF(SECOND,dt.database_transaction_begin_time,GETDATE()),
p.status,p.logical_reads,p.reads,p.writes,
db_name(dt.database_id), program_name,DATEDIFF(SECOND,dt.database_transaction_begin_time,GETDATE()), 'AWAITING COMMAND',@type,GETDATE()
FROM sys.dm_exec_sessions p 
inner join sys.dm_tran_session_transactions st on p.session_id = st.session_id
inner join sys.dm_tran_active_transactions at on at.transaction_id = st.transaction_id 
inner join sys.dm_tran_database_transactions dt on at.transaction_id = dt.transaction_id
where not exists (select 1 from sys.dm_exec_requests r  where r.session_id = p.session_id) and
database_transaction_begin_time is not null --and p.session_id <> @@SPID

insert @result
select spid,cmd,case 
when loginame is not null and loginame <> '' and loginame not like '% %' then loginame
else nt_username end,
hostname,blocked,open_tran,0, 0,lastwaittype,cpu,0,status,physical_io,0,0,
DB_NAME(dbid),program_name, waittime/1000, 'NOT AVAILABLE',@type,GETDATE()  
from @sysprocesses s where not exists (select 1 from @result r where s.spid = r.Spid) and
exists (select 1 from @sysprocesses s2 where s2.blocked = s.spid)


if @type = 'TELA'
select * from @result order by Spid
ELSE
begin
insert master..ResultAlertaDBA (Spid,Cmd,LoginName,HostName,BlkBy,TranCount,ResultCount,PerCentComplete,
LastWaitType,CpuTime,DurationSeconds,ActualStatus,LogicalReads,Reads,Writes,DbName,ProgramName,
WaitTime,LastQuery,ProcType,ProcDateTime)
select Spid,Cmd,LoginName,HostName,BlkBy,TranCount,ResultCount,PerCentComplete,
LastWaitType,CpuTime,DurationSeconds,ActualStatus,LogicalReads,Reads,Writes,DbName,ProgramName,
WaitTime,LastQuery,ProcType,ProcDateTime from @result order by Spid

DECLARE @Subject VARCHAR (100)
SET @Subject= 'Alerta '+ ltrim(rtrim(@type))+ '- Problemas no Servidor ' + @@ServerName

DECLARE @tableHTML NVARCHAR(MAX) ;
SET @tableHTML =
N'<strong><font color="red">What is Currently Running in SQL Server</font></strong> <br>
<table border="1">' +
N'<tr>' +
N'<th>Cmd</th>' +
N'<th>Running Processes</th>' +
N'<th>Total Cpu</th>' +
N'<th>Total IO</th>' +
N'<th>Total Reads</th>' +
N'<th>Avg WaitTime(secs)</th>' +
N'</tr>' +
CAST ( (SELECT td=Cmd,''
,td= count(*),'',td=SUM(cpuTime),'',td=SUM(Reads),'',td=SUM(LogicalReads),'',td=avg(WaitTime),''
FROM @result
GROUP BY Cmd
ORDER BY count(*) desc
FOR XML PATH('tr'), TYPE
) AS NVARCHAR(MAX) ) +
N'</table>
<br><br>
<strong><font color="red">TOP 10 Processes using CPU from SQL Server</font></strong> <br>'

DECLARE @tableHTML4 NVARCHAR(MAX) ;
SET @tableHTML4 =
N'<table border="1">' +
N'<tr>' +
N'<th>SPID</th>' +
N'<th>Loginame</th>' +
N'<th>Pgm Name</th>' +
N'<th>Cmd</th>' +
N'<th>CPU</th>' +
N'<th>IO</th>' +
N'<th>Blocked By</th>' +
N'<th>Query</th>' +
N'<th>Status</th>' +
N'<th>CpuTime Seconds</th>' +
N'<th>Wait Type</th>' +
N'</tr>' +
CAST ((SELECT   top 10 td=spid,'',td=LoginName,'',td=ProgramName,''
,td=Cmd ,'',td= sum(cpuTime) ,'',td= sum(Reads) ,'',td=blkBy,''
,td=substring(LastQuery,1,150),'',td=ActualStatus,''
,td=max(CpuTime),'',td=LastWaitType,''
FROM @result a
group by spid,LoginName,ProgramName, cmd,blkBy,substring(LastQuery,1,50),ActualStatus,LastWaitType,substring(LastQuery,1,150)
order by sum(cpuTime) desc
FOR XML PATH('tr'), TYPE
) AS NVARCHAR(MAX) ) +
N'</table> 
<br><br>
<strong><font color="red">Top 10 Questionable SQL Server Processes</font></strong> <br>'

if @tableHTML4 is null
SET @tableHTML4 = 'No Active Processes '+
N'</table> 
<br><br>
<strong><font color="red">Top 30 Questionable SQL Server Processes + Related Problems</font></strong> <br>'


DECLARE @tableHTML5 NVARCHAR(MAX) ;
SET @tableHTML5 =
N'<table border="1">' +
N'<tr>' +
N'<th>SPID</th>' +
N'<th>Blocked</th>' +
N'<th>DB Name</th>' +
N'<th>CPU</th>' +
N'<th>IO</th>' +
N'<th>Seconds</th>' +
N'<th>Host Name</th>' +
N'<th>Login Name</th>' +
N'<th>Program Name</th>' +
N'<th>Query</th>' +
N'</tr>' +
CAST ((SELECT  top 30 td=spid,''
,td=blkBy,''
,td=dbname,''
,td=cpuTime,''
,td=Reads,''
,td=DurationSeconds,''
,td=convert(varchar(16), hostname),''
,td=convert(varchar(20), LoginName),''
,td=convert(varchar(20), ProgramName),'',td=substring(LastQuery,1,150),''
FROM @result r
WHERE (TranCount > 0 and Cmd = 'AWAITING COMMAND') or
(exists (select 1 from @result r2 where r2.BlkBy = r.Spid) ) or
(BlkBy > 0 )
order by cputime desc 
FOR XML PATH('tr'), TYPE
) AS NVARCHAR(MAX) ) +
N'</table> 

<br><br>
<strong><font color="red">SQL Server Resource Hogs</font></strong> <br>'

if @tableHTML5 is null
SET @tableHTML5 = 'No Questionable Processes '+
N'</table> 
<br><br>
<strong><font color="red">SQL Server Resource Hogs</font></strong> <br>'

DECLARE @tableHTML6 NVARCHAR(MAX) ;
SET @tableHTML6 =
N'<table border="1">' +
N'<tr>' +
N'<th>Program</th>' +
N'<th>Client Count</th>' +
N'<th>CPU Sum</th>' +
N'<th>IO Sum</th>' +
N'<th>Seconds Sum</th>' +
N'</tr>' +
CAST ((SELECT td=convert(varchar(50), ProgramName),''
,td=count(*),''
,td=sum(cpuTime),''
,td=sum(Reads),''
,td=max(DurationSeconds),''
FROM @result
WHERE spid > 50
GROUP BY convert(varchar(50), ProgramName)
ORDER BY 7 DESC 
FOR XML PATH('tr'), TYPE
) AS NVARCHAR(MAX) ) +
N'</table>

<br><br>
<strong><font color="red">All Active Processes</font></strong> <br>'

if @tableHTML6 is null
SET @tableHTML6 = 'No Resource Hogs Processes '+
N'</table> 
<br><br>
<strong><font color="red">All Active Processes</font></strong> <br>'

DECLARE @tableHTML7 NVARCHAR(MAX) ;
SET @tableHTML7 =
N'<table border="1">' +
N'<tr>' +
N'<th>SPID</th>' +
N'<th>Status</th>' +
N'<th>Login Name</th>' +
N'<th>Hostname</th>' +
N'<th>DB Name</th>' +
N'<th>Cmd</th>' +
N'</tr>' +
CAST ( (SELECT td=[spid],''
,td= [ActualStatus],''
,td=LoginName,''
,td=[hostname],''
,td=[dbname],''
,td=[cmd],''
FROM @result
--where dbname not IN ('master', 'msdb')  
ORDER BY 4,5 desc
FOR XML PATH('tr'), TYPE
) AS NVARCHAR(MAX) ) +
N'</table>'

if @tableHTML7 is null
SET @tableHTML7 = 'No Active Processes '+
N'</table>'


declare @body2 varchar(max)
set @body2 = @tableHTML + ' ' + @tableHTML4  + ' ' + @tableHTML5  + ' ' + @tableHTML6 + ' ' +@tableHTML7
--select @body2

EXEC msdb.dbo.sp_send_dbmail
@profile_name = 'SMTP - MTO-BDPRI',
@recipients = 'dba@minutoseguros.com.br',
--@recipients = 'rsouza@hp.com',
@subject = @Subject,
@body = @body2,
@body_format = 'HTML' 
end








GO

/****** Object:  StoredProcedure [dbo].[sp_dba_procMissingIndex]    Script Date: 3/11/2015 11:17:07 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[sp_dba_procMissingIndex]
as
SELECT 
	er.session_id,
	er.blocking_session_id,
	er.start_time,
	er.status,
	dbName = DB_NAME(er.database_id),
	er.wait_type,
	er.wait_time,
	er.last_wait_type,
	er.granted_query_memory,
	er.reads,
	er.logical_reads,
	er.writes,
	er.row_count,
	er.total_elapsed_time,
	er.cpu_time,
	er.open_transaction_count,
	er.open_transaction_count,
	s.text,
	qp.query_plan,
	logDate = CONVERT(DATE,GETDATE()),
	logTime = CONVERT(TIME,GETDATE())
FROM sys.dm_exec_requests er 
CROSS APPLY sys.dm_exec_sql_text(er.sql_handle) s
CROSS APPLY sys.dm_exec_query_plan(er.plan_handle) qp
WHERE 
	CONVERT(VARCHAR(MAX), qp.query_plan) LIKE '%<missing%'

GO

/****** Object:  StoredProcedure [dbo].[sp_dba_Runs]    Script Date: 3/11/2015 11:17:08 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

		
		create proc [dbo].[sp_dba_Runs]
as
select	T.text, R.Status, R.Command, DatabaseName = db_name(R.database_id)
		, R.cpu_time, R.total_elapsed_time, R.percent_complete, session_id
from	sys.dm_exec_requests R
		cross apply sys.dm_exec_sql_text(R.sql_handle) T
		order by DatabaseName
		


GO

/****** Object:  StoredProcedure [dbo].[sp_dba_tableCheck]    Script Date: 3/11/2015 11:17:08 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[sp_dba_tableCheck]
as
SELECT sys.tables.name AS [TABLE], sys.tables.create_date AS CREATE_DATE, 
sys.tables.modify_date AS MODIFY_DATE, 
CASE WHEN sys.database_principals.name IS NULL THEN SCHEMA_NAME(sys.tables.schema_id) 
ELSE sys.database_principals.name END AS OWNER, 
SUM(ISNULL(CASE INDEXES.TYPE WHEN 0 THEN COUNT_TYPE END, 0)) AS COUNT_HEAP_INDEX, 
SUM(ISNULL(CASE INDEXES.TYPE WHEN 1 THEN COUNT_TYPE END, 0)) AS COUNT_CLUSTERED_INDEX, 
SUM(ISNULL(CASE INDEXES.TYPE WHEN 2 THEN COUNT_TYPE END, 0)) AS COUNT_NONCLUSTERED_INDEX, 
SUM(ISNULL(CASE INDEXES.TYPE WHEN 3 THEN COUNT_TYPE END, 0)) AS COUNT_XML_INDEX, 
SUM(ISNULL(CASE INDEXES.TYPE WHEN 4 THEN COUNT_TYPE END, 0)) AS COUNT_SPATIAL_INDEX, 
sys.tables.max_column_id_used AS COUNT_COLUMNS, sys.partitions.rows AS COUNT_ROWS, 
SUM(ISNULL(CASE WHEN sys.allocation_units.type <> 1 THEN USED_PAGES 
WHEN SYS.partitions.INDEX_ID < 2 THEN DATA_PAGES ELSE 0 END, 0)) *
(SELECT low / 1024 AS VALUE FROM master.dbo.spt_values 
WHERE (number = 1) AND (type = N'E')) AS SIZE_DATA_KB, 
SUM(ISNULL(sys.allocation_units.used_pages - CASE WHEN sys.allocation_units.type <> 1 THEN USED_PAGES 
WHEN SYS.partitions.INDEX_ID < 2 THEN DATA_PAGES ELSE 0 END, 0)) * (SELECT low / 1024 AS VALUE 
FROM master.dbo.spt_values AS spt_values_2 WHERE (number = 1) AND (type = N'E')) AS SIZE_INDEX_KB
FROM sys.allocation_units INNER JOIN sys.partitions ON sys.allocation_units.container_id = sys.partitions.partition_id 
INNER JOIN (SELECT TOP (100) PERCENT object_id, index_id, type AS TYPE, COUNT(*) AS COUNT_TYPE
FROM sys.indexes AS indexes_1 GROUP BY object_id, type, index_id ORDER BY object_id) AS INDEXES ON 
sys.partitions.object_id = INDEXES.object_id AND sys.partitions.index_id = INDEXES.index_id RIGHT OUTER JOIN
sys.database_principals RIGHT OUTER JOIN sys.tables ON sys.database_principals.principal_id = sys.tables.principal_id ON 
INDEXES.object_id = sys.tables.object_id GROUP BY sys.tables.name, sys.tables.create_date, sys.tables.modify_date, 
CASE WHEN sys.database_principals.name IS NULL THEN SCHEMA_NAME(sys.tables.schema_id) ELSE sys.database_principals.name END, 
sys.tables.max_column_id_used, sys.partitions.rows
ORDER BY COUNT_ROWS DESC

GO

/****** Object:  StoredProcedure [dbo].[sp_dba_TopCPUQueries]    Script Date: 3/11/2015 11:17:09 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[sp_dba_TopCPUQueries]
as


IF object_id('tempdb..##FindTopCPUQueries_set1') is not null DROP TABLE [dbo].[##FindTopCPUQueries_set1]



declare @ServerTime datetime = getdate()

, @ConvertMiliSeconds bigint = 1000

, @FilterMoreThanMiliSeconds bigint = 1

, @FilterHours bigint = 2

, @execution_count bigint = 2

, @debugFlg bit = 0



if @debugFlg=1 select @ServerTime as ServerTime, @ConvertMiliSeconds as ConvertMiliSeconds

, @FilterMoreThanMiliSeconds as FilterMoreThanMiliSeconds, @FilterHours as FilterHours 

, @execution_count as execution_count





select TOP 300

@@servername as servername,@ServerTime as runtime

,isnull(db_name(QueryText.dbid),'PreparedSQL') as DBName 

 ,SUBSTRING(QueryText.text, (QueryStats.statement_start_offset/2)+1, 

(isnull((

CASE QueryStats.statement_end_offset

 WHEN -1 THEN DATALENGTH(QueryText.text)

 WHEN 0 THEN DATALENGTH(QueryText.text)

 ELSE QueryStats.statement_end_offset

 END - QueryStats.statement_start_offset),0)/2) 

 + 1) AS QueryExecuted

,total_worker_time AS total_worker_time

,QueryStats.execution_count as execution_count

,statement_start_offset,statement_end_offset

,(case when QueryText.dbid is null then OBJECT_NAME(QueryText.objectid) else OBJECT_NAME(QueryText.objectid, QueryText.dbid) end) as ObjectName

,query_hash

,plan_handle

,sql_handle

into ##FindTopCPUQueries_set1

from sys.dm_exec_query_stats as QueryStats

cross apply sys.dm_exec_sql_text(QueryStats.sql_handle) as QueryText

where QueryStats.query_hash IN 

(

select QueryStatsBaseTable.query_hash 

from sys.dm_exec_query_stats QueryStatsBaseTable

where last_execution_time > DATEADD(hh,-@FilterHours,GETDATE())

group by query_hash

having (sum(total_worker_time)/sum(execution_count))>@ConvertMiliSeconds and sum(execution_count)>@execution_count

)

ORDER BY total_worker_time/execution_count DESC;



if @debugFlg=1 select * from ##FindTopCPUQueries_set1 order by QueryExecuted



IF object_id('tempdb..##FindTopCPUQueries_set2') is not null DROP TABLE [dbo].[##FindTopCPUQueries_set2]



select 

servername,runtime,max(DBName) as DBName,max(QueryExecuted) as QueryExecuted,(sum(total_worker_time)/sum(execution_count))/@ConvertMiliSeconds as AvgCPUTime

,sum(execution_count) as execution_count,query_hash, max(ObjectName) as ObjectName

into ##FindTopCPUQueries_set2

from ##FindTopCPUQueries_set1

group by query_hash,servername,runtime

order by AvgCPUTime desc





select * from ##FindTopCPUQueries_set2

--where QueryExecuted like 'select TOP 300%'

order by AvgCPUTime desc

GO

/****** Object:  StoredProcedure [dbo].[sp_who3]    Script Date: 3/11/2015 11:17:09 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[sp_who3]
@spid sysname = null
as

/*
Date Creator Action
2007.02.15 mrdenny Birth
2007.05.18 mrdenny Correct Full Query Text
2007.10.08 mrdenny Added Waiting Statement to Full Query RecordSet
*/

DECLARE @spid_i INT
DECLARE @spid_only bit
SET NOCOUNT ON
if @spid is null
BEGIN
exec sp_who2
END
ELSE
BEGIN
set @spid_only = 1
if lower(cast(@spid as varchar(10))) = 'active'
BEGIN
set @spid_only = 0
exec sp_who2 'active'
END
if lower(cast(@spid as varchar(10))) = 'blocked' or (isnumeric(@spid) = 1 and @spid < 0)
BEGIN
DECLARE @blocked TABLE
(spid int,
blocked int)

INSERT INTO @blocked
select spid, blocked
from sys.sysprocesses
where blocked <> 0

insert into @blocked
select spid, blocked
from sys.sysprocesses
where spid in (select blocked from @blocked)

set @spid_only = 0
select sys.sysprocesses.spid as 'SPID', 
sys.sysprocesses.status, 
sys.sysprocesses.loginame as 'Login',
sys.sysprocesses.hostname as 'HostName',
sys.sysprocesses.blocked as 'BlkBy',
sys.databases.name as 'DBName',
sys.sysprocesses.cmd as 'Command',
sys.sysprocesses.cpu as 'CPUTime',
sys.sysprocesses.physical_io as 'DiskIO',
sys.sysprocesses.last_batch as 'LastBatch',
sys.sysprocesses.program_name as 'ProgramName',
sys.sysprocesses.spid as 'SPID'
from sys.sysprocesses
left outer join sys.databases on sys.sysprocesses.dbid = sys.databases.database_id
where spid in (select spid from @blocked)
END

if @spid_only = 1
BEGIN
DECLARE @sql_handle varbinary(64)
DECLARE @stmt_start int
DECLARE @stmt_end int

set @spid_i = @spid

SELECT @sql_handle = sql_handle,
    @stmt_start = stmt_start,
    @stmt_end = stmt_end
from sys.sysprocesses
where spid = @spid_i

exec sp_who @spid_i
exec sp_who2 @spid_i
dbcc inputbuffer (@spid_i)
/*Start Get Output Buffer*/
select text as 'Full Query', 
    case when @stmt_start < 0 then 
        substring(text, @stmt_start/2, (@stmt_end/2)-(@stmt_start/2)) 
    else 
        null 
    end as 'Current Command'
from sys.dm_exec_sql_text(@sql_handle)
/*End Get Output Buffer*/
select * from master.sys.sysprocesses where spid = @spid_i
exec sp_blocked @spid_i
exec sp_lock @spid_i
END
END

GO

