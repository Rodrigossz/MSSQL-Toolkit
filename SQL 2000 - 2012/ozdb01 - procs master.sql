USE [master]
GO

/****** Object:  StoredProcedure [dbo].[sp_dba_7z]    Script Date: 05/19/2010 17:48:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE proc [dbo].[sp_dba_7z] @data smalldatetime = null
as
begin
set nocount on
select 'Zipando bkps dos dbs ozdb jms master model msdb distribution dbaowrk. Mais nenhum!!!'

--exec xp_cmdshell 'del e:\ozonion\backup\jms\*2009*.bak'
--exec xp_cmdshell 'dir e:\ozonion\backup\jms'
--exec xp_cmdshell '"c:\Program Files (x86)\7-Zip\7z.exe" a e:\ozonion\backup\ozdb\20100107.7z E:\Ozonion\Backup\ozdb\*20100107*.*'

if @data is null
select @data = getdate()

select 'Zipando arquivos do dia',convert(char(8),@data,112)
-- ozdb
declare @cmd varchar(200)
select @cmd = '"c:\Program Files (x86)\7-Zip\7z.exe" a e:\ozonion\backup\ozdb\'
+convert(char(8),dateadd(dd,-1,@data),112)+'.7z e:\ozonion\backup\ozdb\*'+convert(char(8),dateadd(dd,-1,@data),112)+'*.*'
--select @cmd debug
exec xp_cmdshell  @cmd
exec xp_cmdshell ' dir e:\ozonion\backup\ozdb\*.7z'

--dbawork
select @cmd = '"c:\Program Files (x86)\7-Zip\7z.exe" a e:\ozonion\backup\dbawork\'
+convert(char(8),dateadd(dd,-1,@data),112)+'.7z e:\ozonion\backup\dbawork\*'+convert(char(8),dateadd(dd,-1,@data),112)+'*.*'
exec xp_cmdshell  @cmd
exec xp_cmdshell ' dir e:\ozonion\backup\dbawork\*.7z'

--distribution
select @cmd = '"c:\Program Files (x86)\7-Zip\7z.exe" a e:\ozonion\backup\distribution\'
+convert(char(8),dateadd(dd,-1,@data),112)+'.7z e:\ozonion\backup\distribution\*'+convert(char(8),dateadd(dd,-1,@data),112)+'*.*'
exec xp_cmdshell  @cmd
exec xp_cmdshell ' dir e:\ozonion\backup\distribution\*.7z'

--master
select @cmd = '"c:\Program Files (x86)\7-Zip\7z.exe" a e:\ozonion\backup\master\'
+convert(char(8),dateadd(dd,-1,@data),112)+'.7z e:\ozonion\backup\master\*'+convert(char(8),dateadd(dd,-1,@data),112)+'*.*'
exec xp_cmdshell  @cmd
exec xp_cmdshell ' dir e:\ozonion\backup\master\*.7z'

--model
select @cmd = '"c:\Program Files (x86)\7-Zip\7z.exe" a e:\ozonion\backup\model\'
+convert(char(8),dateadd(dd,-1,@data),112)+'.7z e:\ozonion\backup\model\*'+convert(char(8),dateadd(dd,-1,@data),112)+'*.*'
exec xp_cmdshell  @cmd
exec xp_cmdshell ' dir e:\ozonion\backup\model\*.7z'


--msdb
select @cmd = '"c:\Program Files (x86)\7-Zip\7z.exe" a e:\ozonion\backup\msdb\'
+convert(char(8),dateadd(dd,-1,@data),112)+'.7z e:\ozonion\backup\msdb\*'+convert(char(8),dateadd(dd,-1,@data),112)+'*.*'
exec xp_cmdshell  @cmd
exec xp_cmdshell ' dir e:\ozonion\backup\msdb\*.7z'
end


GO

/****** Object:  StoredProcedure [dbo].[sp_dba_bad]    Script Date: 05/19/2010 17:48:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[sp_dba_bad]
as
SELECT TOP 5 query_stats.query_hash AS "Query Hash", 

    SUM(query_stats.total_worker_time) / SUM(query_stats.execution_count) AS "Avg CPU Time",

    MIN(query_stats.statement_text) AS "Statement Text"

FROM 

    (SELECT QS.*, 

    SUBSTRING(ST.text, (QS.statement_start_offset/2) + 1,

    ((CASE statement_end_offset 

        WHEN -1 THEN DATALENGTH(st.text)

        ELSE QS.statement_end_offset END 

            - QS.statement_start_offset)/2) + 1) AS statement_text

     FROM sys.dm_exec_query_stats AS QS

     CROSS APPLY sys.dm_exec_sql_text(QS.sql_handle) as ST) as query_stats

GROUP BY query_stats.query_hash

ORDER BY 2 DESC;

GO

/****** Object:  StoredProcedure [dbo].[sp_dba_bkp]    Script Date: 05/19/2010 17:48:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[sp_dba_bkp]   
@discos char(1) = null  
as    
set nocount on    
--sp_helpdb dbawork    
  
if @discos is null  
select @discos = 'S'  
  
select 'Espaco livre e uso do log  
'  
if @discos = 'S'  
exec master..xp_fixeddrives  
DBCC SQLPERF (logspace)  
select '  
Databases FULL sem bkp log'    
SELECT substring (D.name,1,30) AS database_name,substring( D.recovery_model_desc ,1,15) as Model    
FROM sys.databases D LEFT JOIN      
   (     
   SELECT BS.database_name,      
       MAX(BS.backup_finish_date) AS last_log_backup_date     
   FROM msdb.dbo.backupset BS      
   WHERE BS.type = 'L'     
   GROUP BY BS.database_name     
   ) BS1 ON D.name = BS1.database_name     
WHERE D.recovery_model_desc <> 'SIMPLE'     
   AND BS1.last_log_backup_date IS NULL     
ORDER BY D.name    
    
/*    
SELECT     
substring (D.name,1,30) AS database_name,substring( D.recovery_model_desc ,1,15) as Model    
FROM     
sys.databases D LEFT JOIN      
(     
   SELECT BS.database_name,      
   MAX(BS.backup_finish_date) AS last_log_backup_date      
   FROM msdb.dbo.backupset BS      
   WHERE BS.type = 'L'      
   GROUP BY BS.database_name      
   ) BS1      
ON D.name = BS1.database_name     
LEFT JOIN      
(     
   SELECT BS.database_name,      
   MAX(BS.backup_finish_date) AS last_data_backup_date      
   FROM msdb.dbo.backupset BS      
   WHERE BS.type = 'D'      
   GROUP BY BS.database_name      
) BS2      
ON D.name = BS2.database_name     
WHERE     
D.recovery_model_desc <> 'SIMPLE'     
AND BS1.last_log_backup_date IS NULL OR BS1.last_log_backup_date < BS2.last_data_backup_date    
ORDER BY D.name    
*/    
select '    
Ultimos bkps    
'    
    
SELECT substring (D.name,1,25) AS database_name,substring( D.recovery_model_desc ,1,15) as DbLogModel ,    
convert(char(10),convert(numeric(8,2),backup_size/1024/1024)) as MB,    
case type    
when 'D' then 'Database'     
when 'I' then 'Database Differential'     
when 'L' then 'Log'     
when 'F' then 'File or Filegroup'     
when 'G' then 'File Differential'     
when 'P' then 'Partial'     
when 'Q' then 'Partial Differentil'    
end as Type,convert(char(19),[last_log_backup_date])  as 'Last Bkp'    
FROM sys.databases D LEFT JOIN      
   (     
   SELECT BS.[database_name],  bs.type, max(bs.backup_size) as backup_size,    
       MAX(BS.[backup_finish_date]) AS [last_log_backup_date]     
   FROM msdb.dbo.backupset BS      
   GROUP BY BS.[database_name] , bs.type    
   ) BS1 ON D.[name] = BS1.[database_name]    
ORDER BY 1,2,3

GO

/****** Object:  StoredProcedure [dbo].[sp_dba_cachePlan]    Script Date: 05/19/2010 17:48:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[sp_dba_cachePlan]
as
set nocount on
SELECT objtype AS 'Cached Object Type', 
  COUNT(*) AS 'Numberof Plans', 
  SUM(CAST(size_in_bytes AS BIGINT))/1048576 AS 'Plan Cache SIze (MB)', 
  AVG(usecounts) AS 'Avg Use Counts' 
FROM sys.dm_exec_cached_plans 
GROUP BY objtype  
ORDER BY objtype 
GO

/****** Object:  StoredProcedure [dbo].[sp_dba_counters]    Script Date: 05/19/2010 17:48:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[sp_dba_counters]
as

set nocount on
declare @transec int
select @transec = cntr_value  FROM sys.dm_os_performance_counters  
WHERE counter_name = 'Transactions/sec' and instance_name = '_Total'
waitfor delay '00:00:01'

select @transec = cntr_value - @transec FROM sys.dm_os_performance_counters  
WHERE counter_name = 'Transactions/sec' and instance_name = '_Total'

SELECT 'Buffer cache hit ratio' as Counter, 
convert(numeric(7,2),ROUND(CAST(A.cntr_value1 AS NUMERIC(7,2)) / CAST(B.cntr_value2 AS NUMERIC(7,2)),3))*100 AS Value,
'Target = 100%' as 'Best Situation'
FROM (SELECT cntr_value AS cntr_value1
FROM sys.dm_os_performance_counters
WHERE object_name = 'SQLServer:Buffer Manager'
AND counter_name = 'Buffer cache hit ratio') AS A,
(SELECT cntr_value AS cntr_value2
FROM sys.dm_os_performance_counters
WHERE object_name = 'SQLServer:Buffer Manager'
AND counter_name = 'Buffer cache hit ratio base') AS B
union
SELECT counter_name,convert(numeric (10,2),cntr_value),'Target = above 300' 
FROM sys.dm_os_performance_counters  
WHERE counter_name = 'Page life expectancy'
AND OBJECT_NAME = 'SQLServer:Buffer Manager'
union
SELECT 'Transactions/sec',@transec,'Target = Between 30 and 300'
union 
SELECT counter_name,convert(numeric (10,2),cntr_value),'Target = Around 400' 
FROM sys.dm_os_performance_counters  
WHERE counter_name like 'User%Connections%'
union 
SELECT counter_name,convert(numeric (10,2),cntr_value),'Target = Minimum' 
FROM sys.dm_os_performance_counters  
WHERE counter_name like 'Processes%Blocked%'
union 
SELECT counter_name+' (historical)',sum(convert(numeric (10,2),cntr_value)),'Target = Minimum' 
FROM sys.dm_os_performance_counters  
WHERE counter_name like 'Number%deadlock%'
group by counter_name
union
SELECT 'Average Wait Time - seconds', convert(numeric(7,2),ROUND(CAST(A.cntr_value1 AS NUMERIC) / CAST(B.cntr_value2 AS NUMERIC),3))/1000 AS Value,
'Target = above 5' 
FROM (SELECT sum(cntr_value) AS cntr_value1
FROM sys.dm_os_performance_counters
WHERE object_name = 'SQLServer:Locks'
AND counter_name = 'Average Wait Time (ms)') AS A,
(SELECT sum(cntr_value) AS cntr_value2
FROM sys.dm_os_performance_counters
WHERE object_name = 'SQLServer:Locks'
AND counter_name = 'Average Wait Time Base') AS B
union
SELECT ltrim(rtrim(counter_name))+' - '+Ltrim(rtrim(instance_name)), cntr_value/1024 , 'Megabytes' 
FROM sys.dm_os_performance_counters
WHERE object_name = 'SQLServer:Databases'
AND counter_name like '%size%' and instance_name like 'ozdb%'
union
select 'KILLs on '+CONVERT(char(8),data,112),COUNT(*) ,'Target = Minimum'
from dbawork..logautokill (nolock) where data  >= DATEADD (dd,-2,convert(char(8),getdate(),112)) group by CONVERT(char(8),data,112)
union 
select 'General LPM Conversions on '+ CONVERT(char(8),requesttime,112),COUNT(*) ,'Target = Maximum'
from ozdb..LPM_TRANSACTION (nolock) where requesttime  >= DATEADD (dd,-2,convert(char(8),getdate(),112)) 
and TRANSACTION_STATE_TYPE_ID = 4
group by CONVERT(char(8),requesttime,112)
order by 3 desc, 1 asc


GO

/****** Object:  StoredProcedure [dbo].[sp_dba_ErrorLog]    Script Date: 05/19/2010 17:48:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[sp_dba_ErrorLog] (
  @dataReferencia smalldatetime = NULL,
  @mail char(1) = null,
  @minData        smalldatetime = NULL OUTPUT
) as
/************************************************************************
 Autor: Rodrigo Souza (Lemon Bank)
 Data de criação: 14/10/2004
 Data de Atualização: 21/08/2008
 Funcionalidade: Mostra o log atual do sql.
*************************************************************************/
begin
  set nocount on
  
  if @mail is null
  select @mail = 'N'

  if exists (select 1 from tempdb.dbo.sysobjects where name like '%#log%')
    drop table #log
  create table #log (
    rowId       int identity,
    logDate datetime,
    processInfo varchar (30),
    texto       varchar(500) null  )

  -- CARGA INICIAL
  insert #log
  EXEC master.dbo.xp_readerrorlog
  -- CARGA INICIAL

  -- PEGANDO A DATA INICIAL DO LOG PRA MOSTRAR NO EMAIL DO ERROR LOG A QUANTO TEMPO O SERVIDOR ESTA DE PÉ
  select  @minData = min(logdate)
  from #log
  

  -- DELETA O QUE NÃO PRECISA
  if (@dataReferencia is null)
    delete #log where logdate < dateadd(dd, -1, convert(char(8), getdate(), 112))
  else
    delete #log where convert(char(8),logdate,112) <> convert(char(8),@dataReferencia,112)
 
  delete #log where  rowId < 9
  delete #log where texto like '%Using%'
  delete #log where texto like '%DBCC CHECKDB%'
  delete #log where texto like '%Database backed up%'
  delete #log where texto like '%Log backed up%'
  delete #log where texto like '%Starting up database%'
  delete #log where texto like '%Log was backed up.%'
  delete #log where texto like '%SQL Server has encountered%'
  delete #log where texto like '%The time stamp counter of CPU on scheduler id%' 
  delete #log where texto like '%DBCC TRACEON 8033%'
  delete #log where texto like '%DBCC TRACEON 830%'
  
  if (@dataReferencia is null)
    delete #log where logdate < dateadd(dd, -1, convert(char(8), getdate(), 112))
  else
    delete #log where convert(char(8),logdate,112) <> convert(char(8),@dataReferencia,112)

  -- Controle de status do SQL AGENT --------------------------------------
  -- drop table #agent
  declare @out int
  if exists (select 1 from tempdb.dbo.sysobjects where name like '%#agent%')
    drop table #agent
  create table #agent (status varchar(100))
  insert #agent
  Exec @out = master.dbo.xp_servicecontrol 'QueryState', 'SQLServerAgent'
  if (@out = 0)
  update #agent set status = 'Status do SQL AGENT: ' + status
  else
   insert #agent select 'Status do SQL AGENT: NOT running.'

  insert into #log (logdate, processInfo,texto)
  select getdate(),'AGENT',status from #agent
  drop table #agent
  -- select * from #log
  -- Controle de status do SQL AGENT --------------------------------------

if @mail = 'N'
select * from #log order by logdate
else
select convert(varchar(19),logdate) as logdate,substring(texto,1,75) as MSG from #log order by logdate


if exists (select 1 from tempdb..sysobjects where name like '%ErrorLog%')
    drop table #log
end

GO

/****** Object:  StoredProcedure [dbo].[sp_dba_faltaBKP]    Script Date: 05/19/2010 17:48:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[sp_dba_faltaBKP]
as
set nocount on

select b.database_name as Banco,b.backup_finish_date as UltimoBackup,
case b.[type]
when 'D' then 'Database'
when 'I' then 'Database Differential'
when 'L' then 'Log'
when 'F' then 'File or Filegroup'
end as TipoBackup -- b.*
from msdb.dbo.backupset b join
(select database_name, max(backup_finish_date) backup_finish_date
from msdb.dbo.backupset group by database_name) u
on b.database_name = u.database_name and b.backup_finish_date = u.backup_finish_date
where b.backup_finish_date < (getdate() - 2) or b.backup_finish_date is null order by b.database_name 
GO

/****** Object:  StoredProcedure [dbo].[sp_dba_fragmentation]    Script Date: 05/19/2010 17:48:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[sp_dba_fragmentation]
as
set nocount on
SELECT top 20 a.index_id, name, object_name(a.object_id),avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats (DB_ID(), null,
     NULL, NULL, NULL) AS a
    JOIN sys.indexes AS b ON a.object_id = b.object_id AND a.index_id = b.index_id
   
    order by 4 desc

GO

/****** Object:  StoredProcedure [dbo].[sp_dba_indexCache]    Script Date: 05/19/2010 17:48:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[sp_dba_indexCache] 
as
SELECT top 10 count(*)AS cached_pages_count 
    ,name ,index_id 
FROM sys.dm_os_buffer_descriptors AS bd 
    INNER JOIN 
    (
        SELECT object_name(object_id) AS name 
            ,index_id ,allocation_unit_id
        FROM sys.allocation_units AS au
            INNER JOIN sys.partitions AS p 
                ON au.container_id = p.hobt_id 
                    AND (au.type = 1 OR au.type = 3)
        UNION ALL
        SELECT object_name(object_id) AS name   
            ,index_id, allocation_unit_id
        FROM sys.allocation_units AS au
            INNER JOIN sys.partitions AS p 
                ON au.container_id = p.partition_id 
                    AND au.type = 2
    ) AS obj 
        ON bd.allocation_unit_id = obj.allocation_unit_id
WHERE database_id = db_id()
GROUP BY name, index_id 
ORDER BY cached_pages_count DESC


SELECT count(*)AS cached_pages_count
    ,CASE database_id 
        WHEN 32767 THEN 'ResourceDb' 
        ELSE db_name(database_id) 
        END AS Database_name
FROM sys.dm_os_buffer_descriptors
GROUP BY db_name(database_id) ,database_id
ORDER BY cached_pages_count DESC;
GO

/****** Object:  StoredProcedure [dbo].[sp_dba_io]    Script Date: 05/19/2010 17:48:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--select * from ozdb..sysfilegroups

CREATE proc [dbo].[sp_dba_io]
as
begin

declare @grupos table (banco varchar(30), groupname varchar(30), groupid int)



if (select @@SERVERNAME) = 'ozdb01'
insert @grupos 
select 'ozdb_hist' ,groupname, groupid  from ozdb_hist..sysfilegroups union
select 'tempdb' ,groupname, groupid  from tempdb..sysfilegroups union
select 'master' ,groupname, groupid  from master..sysfilegroups union
select 'model' ,groupname, groupid  from model..sysfilegroups union
select 'ozdb' ,groupname, groupid  from ozdb..sysfilegroups union
select 'ipdb' ,groupname, groupid  from ipdb..sysfilegroups union
select 'dbawork' ,groupname, groupid  from dbawork..sysfilegroups union
select 'distribution' ,groupname, groupid  from distribution..sysfilegroups 
ELSE
insert @grupos 
select 'ozdb_hist' ,groupname, groupid  from ozdb_hist..sysfilegroups union
select 'tempdb' ,groupname, groupid  from tempdb..sysfilegroups union
select 'master' ,groupname, groupid  from master..sysfilegroups union
select 'model' ,groupname, groupid  from model..sysfilegroups union
select 'ozdb_rep' ,groupname, groupid  from ozdb_rep..sysfilegroups union
select 'ipdb' ,groupname, groupid  from ipdb..sysfilegroups union
select 'dbawork' ,groupname, groupid  from dbawork..sysfilegroups ;

with IO_por_Banco as (
select db_name(database_id) as Banco,FILE_ID as fileid,
cast(sum(num_of_bytes_read + num_of_bytes_written) / 1048576 as decimal(12,2)) 
as IO_Total_MB,
cast(sum(num_of_bytes_read) / 1048576 as decimal(12,2)) as IO_Leitura_MB,
cast(sum(num_of_bytes_written) / 1048576 as decimal(12,2)) as IO_Escrita_MB
from sys.dm_io_virtual_file_stats(NULL,NULL) as dm
group by database_id,file_id)

select row_number() over (order by IO_Total_MB DESC) as Ranking,
B.banco,s.name, size/1024 as size_MB,upper(substring(filename,1,1)) as drive, 
isnull(substring(groupname,1,20),'LOG') as file_group,IO_Leitura_MB, IO_Escrita_MB,
IO_Total_MB, cast(IO_Total_MB / sum(IO_Total_MB) over() * 100 as decimal(5,2)) as Percentual
from IO_por_Banco b 
join master..sysaltfiles s on DB_NAME(s.dbid) = b.Banco and s.fileid = b.fileid
left outer join @grupos g on DB_NAME(s.dbid) = g.Banco and s.groupid = g.groupid
order by Ranking
end

GO

/****** Object:  StoredProcedure [dbo].[sp_dba_ix]    Script Date: 05/19/2010 17:48:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[sp_dba_ix] @date datetime = null  
as  
if @date is null  
select @date = dateadd(mm,-2,getdate())  
select 'Indexes that have been used and how they are being used'  
SELECT DB_NAME(DATABASE_ID) AS DATABASENAME,   
       OBJECT_NAME(B.OBJECT_ID) AS TABLENAME,   
       INDEX_NAME = (SELECT NAME   
                     FROM   SYS.INDEXES A   
                     WHERE  A.OBJECT_ID = B.OBJECT_ID   
                            AND A.INDEX_ID = B.INDEX_ID),   
       USER_SEEKS,   
       USER_SCANS,   
       USER_LOOKUPS,   
       USER_UPDATES   
FROM   SYS.DM_DB_INDEX_USAGE_STATS B   
       INNER JOIN SYS.OBJECTS C   
         ON B.OBJECT_ID = C.OBJECT_ID   
WHERE  DATABASE_ID = DB_ID(DB_NAME())   
       AND C.TYPE <> 'S'  
  
  
select 'Indexes that have not been used'  
SELECT   DB_NAME() AS DATABASENAME,   
         OBJECT_NAME(B.OBJECT_ID) AS TABLENAME,   
         B.NAME AS INDEXNAME,   
         B.INDEX_ID   
FROM     SYS.OBJECTS A   
         INNER JOIN SYS.INDEXES B   
           ON A.OBJECT_ID = B.OBJECT_ID   
WHERE    NOT EXISTS (SELECT *   
                     FROM   SYS.DM_DB_INDEX_USAGE_STATS C   
                     WHERE  B.OBJECT_ID = C.OBJECT_ID  and  
(last_user_seek >= @date or  
last_user_scan >= @date or  
last_user_lookup >= @date )  
--last_user_update >= '20091201' )  
                            AND B.INDEX_ID = C.INDEX_ID)   
         AND A.TYPE <> 'S'   
ORDER BY 1, 2, 3  
  
select 'Tables, indexes and columns'  
SELECT   TABLENAME, INDEXNAME, INDEXID, [1] AS COL1, [2] AS COL2, [3] AS COL3,   
         [4] AS COL4,  [5] AS COL5, [6] AS COL6, [7] AS COL7   
FROM     (SELECT A.NAME AS TABLENAME,   
                 B.NAME AS INDEXNAME,   
                 B.INDEX_ID AS INDEXID,   
                 D.NAME AS COLUMNNAME,   
                 C.KEY_ORDINAL   
          FROM   SYS.OBJECTS A   
                 INNER JOIN SYS.INDEXES B   
                   ON A.OBJECT_ID = B.OBJECT_ID   
                 INNER JOIN SYS.INDEX_COLUMNS C   
                   ON B.OBJECT_ID = C.OBJECT_ID   
                      AND B.INDEX_ID = C.INDEX_ID   
                 INNER JOIN SYS.COLUMNS D   
                   ON C.OBJECT_ID = D.OBJECT_ID   
                      AND C.COLUMN_ID = D.COLUMN_ID   
          WHERE  A.TYPE <> 'S') P   
         PIVOT   
         (MIN(COLUMNNAME)   
          FOR KEY_ORDINAL IN ( [1],[2],[3],[4],[5],[6],[7] ) ) AS PVT   
ORDER BY TABLENAME, INDEXNAME  
/*  
SELECT   A.NAME,          B.NAME,   
         C.KEY_ORDINAL,          D.NAME   
FROM     SYS.OBJECTS A          INNER JOIN SYS.INDEXES B   
           ON A.OBJECT_ID = B.OBJECT_ID   
         INNER JOIN SYS.INDEX_COLUMNS C   
           ON B.OBJECT_ID = C.OBJECT_ID   
              AND B.INDEX_ID = C.INDEX_ID   
         INNER JOIN SYS.COLUMNS D   
           ON C.OBJECT_ID = D.OBJECT_ID   
              AND C.COLUMN_ID = D.COLUMN_ID   
WHERE    A.TYPE <> 'S'   
ORDER BY 1, 2, 3  
  
*/  
select 'indexes that have been used since the last time the stats were reset'

SELECT   TABLENAME, INDEXNAME, INDEX_ID, [1] AS COL1, [2] AS COL2, [3] AS COL3, 
         [4] AS COL4, [5] AS COL5, [6] AS COL6, [7] AS COL7 
FROM     (SELECT A.NAME AS TABLENAME, 
                 A.OBJECT_ID, 
                 B.NAME AS INDEXNAME, 
                 B.INDEX_ID, 
                 D.NAME AS COLUMNNAME, 
                 C.KEY_ORDINAL 
          FROM   SYS.OBJECTS A 
                 INNER JOIN SYS.INDEXES B 
                   ON A.OBJECT_ID = B.OBJECT_ID 
                 INNER JOIN SYS.INDEX_COLUMNS C 
                   ON B.OBJECT_ID = C.OBJECT_ID 
                      AND B.INDEX_ID = C.INDEX_ID 
                 INNER JOIN SYS.COLUMNS D 
                   ON C.OBJECT_ID = D.OBJECT_ID 
                      AND C.COLUMN_ID = D.COLUMN_ID 
          WHERE  A.TYPE <> 'S') P 
         PIVOT 
         (MIN(COLUMNNAME) 
          FOR KEY_ORDINAL IN ( [1],[2],[3],[4],[5],[6],[7] ) ) AS PVT 
WHERE    EXISTS (SELECT OBJECT_ID, 
                        INDEX_ID 
                 FROM   SYS.DM_DB_INDEX_USAGE_STATS B 
                 WHERE  DATABASE_ID = DB_ID(DB_NAME()) 
                        AND PVT.OBJECT_ID = B.OBJECT_ID 
                        AND PVT.INDEX_ID = B.INDEX_ID) 
ORDER BY TABLENAME, INDEXNAME

GO

/****** Object:  StoredProcedure [dbo].[sp_dba_job]    Script Date: 05/19/2010 17:48:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[sp_dba_job] 
as
exec msdb..sp_dba_job

GO

/****** Object:  StoredProcedure [dbo].[sp_dba_JobsOutput]    Script Date: 05/19/2010 17:48:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[sp_dba_JobsOutput]
as
set nocount on
;WITH Flags (FlagID, FlagValue) 

AS

(

   SELECT 0 AS FlagID, 'Overwrite output file' AS FlagValue UNION ALL

   SELECT 2 AS FlagID, 'Append to output file' AS FlagValue UNION ALL

   SELECT 4 AS FlagID, 'Write Transact-SQL job step output to step history' AS FlagValue UNION ALL

   SELECT 8 AS FlagID, 'Write log to table (overwrite existing history)' UNION ALL 

   SELECT 16 AS FlagID, 'Write log to table (append to existing history)'

),

JobsInfo (Job_Name, Jobstep_ID, Jobstep_Name, Flags)

AS

(

SELECT 

   j.name as [Job_Name]

   , js.step_name as [Jobstep_Name]

   , js.step_id as [Jobstep_ID]

   , flags 

FROM msdb.dbo.sysjobsteps js JOIN msdb.dbo.sysjobs j 

ON js.job_id = j.job_id

),

FinalData (Job_Name, JobStep_Name, [Jobstep_ID], FlagValue)

AS

(

SELECT 

   Job_Name

   , Jobstep_Name

   , [Jobstep_ID]

   , F.FlagValue

FROM JobsInfo JI CROSS JOIN Flags F 

WHERE JI.Flags & F.FlagID <> 0 

)

SELECT DISTINCT 

   JI.Job_Name

   , JI.[Jobstep_ID]

   , JI.Jobstep_Name

   , ISNULL(STUFF (( SELECT ', ' + FD2.FlagValue FROM FinalData FD2 

WHERE FD2.Job_Name = FD1.Job_Name AND FD2.Jobstep_Name = FD1.Jobstep_Name 

ORDER BY ', ' + FD2.FlagValue FOR XML PATH('')), 1, 1, ' '), 'Overwrite output file') AS OptionsSet

FROM FinalData FD1 RIGHT OUTER JOIN JobsInfo JI

ON FD1.Job_Name = JI.Job_Name AND FD1.Jobstep_Name = JI.Jobstep_Name

ORDER BY Job_Name, Jobstep_Name
GO

/****** Object:  StoredProcedure [dbo].[sp_dba_kill]    Script Date: 05/19/2010 17:48:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[sp_dba_kill] @parm nvarchar(40)  
as  
set nocount on  
declare @kill table (spid nvarchar(20),id int)  
declare @min nvarchar(20), @max nvarchar(20)  

  
if isnumeric(@parm ) = 1  
begin  
select 'Matando: ', @parm  
select @parm = N'Kill '+@parm  
exec sp_executesql @parm  
return  
end  
  
if exists (select 1 from master..syslogins where name = @parm)  
begin  
select 'Matando todas as conexoes do login ',@parm  
  
insert @kill select rtrim(convert(nvarchar(10),spid))  ,spid 
from master..sysprocesses p left join master..syslogins l on p.sid = l.sid where l.name = @parm  and spid <> @@spid

select @min = min(id) , @max = max(id) from @kill  

while @min <= @max  
begin  
select 'matando: ',@min  
select @parm = N'Kill '+ltrim(rtrim(spid )) from @kill where id = @min
exec sp_executesql @parm  
select @min = min(spid) from @kill where id > @min  
end  
end




if exists (select 1 from master..sysdatabases where name = @parm)  
begin  
select 'Matando todas as conexoes do db ',@parm  
    
insert @kill select rtrim(convert(nvarchar(10),spid))  ,spid 
from master..sysprocesses p left 
join master..syslogins l on p.sid = l.sid 
join master..sysdatabases d on p.dbid = d.dbid
where d.name = @parm  and spid <> @@spid and spid > 50

select @min = min(id) , @max = max(id) from @kill  

while @min <= @max  
begin  
select 'matando: ',@min  
select @parm = N'Kill '+ltrim(rtrim(spid )) from @kill where id = @min
exec sp_executesql @parm  
select @min = min(spid) from @kill where id > @min  
end  
end


GO

/****** Object:  StoredProcedure [dbo].[sp_dba_limpaDisco]    Script Date: 05/19/2010 17:48:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[sp_dba_limpaDisco]
as
create table #temp (files varchar(400))
declare @cmd varchar (300)
select @cmd = 'dir i:\backup\ozdb' 
insert #temp
exec xp_cmdshell @cmd

delete #temp where files not like '%bak%' or files is null

--anteontem
declare @data char(10) --, @cmd varchar(300)
select @data = CONVERT(char(8),dateadd(dd,-2,getdate()),112)
declare  cr_cur cursor for 
select ltrim(rtrim(substring(files,CHARINDEX('ozdb_backup_',files,1),41))) from #temp where
convert(datetime,replace(substring(files,CHARINDEX('ozdb_backup_',files,1)+12,10),'_','')) < @data
 open cr_cur
 fetch cr_cur into @cmd
 while @@FETCH_STATUS = 0
 begin
 select @cmd = 'del i:\backup\ozdb\'+ @cmd
 select @cmd
 exec xp_cmdshell @cmd
fetch cr_cur into @cmd
end
close cr_cur
deallocate cr_cur
drop table #temp
select @cmd = 'dir i:\backup\ozdb' 
exec xp_cmdshell @cmd

GO

/****** Object:  StoredProcedure [dbo].[sp_dba_limpaDiscoLog]    Script Date: 05/19/2010 17:48:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 

CREATE proc [dbo].[sp_dba_limpaDiscoLog]
as
create table #temp (files varchar(400))
declare @cmd varchar (300)
select @cmd = 'dir i:\backup\ozdb_log' 
insert #temp
exec xp_cmdshell @cmd

delete #temp where files not like '%trn%' or files is null
--select * from #temp

--anteontem
declare @data char(10) --, @cmd varchar(300)
select @data = CONVERT(char(8),dateadd(dd,-1,getdate()),112)
declare  cr_cur cursor for 
select ltrim(rtrim(substring(files,CHARINDEX('ozdb_backup_',files,1),41))) from #temp 
where convert(datetime,replace(substring(files,CHARINDEX('ozdb_backup_',files,1)+12,10),'_','')) < @data
 
 open cr_cur
 fetch cr_cur into @cmd
 while @@FETCH_STATUS = 0
 begin
 select 1
 select @cmd = 'del i:\backup\ozdb_log\'+ @cmd
exec xp_cmdshell @cmd
fetch cr_cur into @cmd
end
close cr_cur
deallocate cr_cur
drop table #temp
select @cmd = 'dir i:\backup\ozdb_log' 
exec xp_cmdshell @cmd

GO

/****** Object:  StoredProcedure [dbo].[sp_dba_lock]    Script Date: 05/19/2010 17:48:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[sp_dba_lock]
as
SELECT 
        t1.resource_type,
        t1.resource_database_id,
        t1.resource_associated_entity_id,
        t1.request_mode,
        t1.request_session_id,
        t2.blocking_session_id
    FROM sys.dm_tran_locks as t1
    INNER JOIN sys.dm_os_waiting_tasks as t2
        ON t1.lock_owner_address = t2.resource_address

SELECT DTL.resource_type,  
   CASE   
       WHEN DTL.resource_type IN ('DATABASE', 'FILE', 'METADATA') THEN DTL.resource_type  
       WHEN DTL.resource_type = 'OBJECT' THEN OBJECT_NAME(DTL.resource_associated_entity_id)  
       WHEN DTL.resource_type IN ('KEY', 'PAGE', 'RID') THEN   
           (  
           SELECT OBJECT_NAME([object_id])  
           FROM sys.partitions  
           WHERE sys.partitions.hobt_id =   
           DTL.resource_associated_entity_id  
           )  
       ELSE 'Unidentified'  
   END AS requested_object_name, DTL.request_mode, DTL.request_status,    
   DOWT.wait_duration_ms, DOWT.wait_type, DOWT.session_id AS [blocked_session_id],  
   sp_blocked.[loginame] AS [blocked_user], DEST_blocked.[text] AS [blocked_command], 
   DOWT.blocking_session_id, sp_blocking.[loginame] AS [blocking_user],  
   DEST_blocking.[text] AS [blocking_command], DOWT.resource_description     
FROM sys.dm_tran_locks DTL  
   INNER JOIN sys.dm_os_waiting_tasks DOWT   
       ON DTL.lock_owner_address = DOWT.resource_address   
   INNER JOIN sys.sysprocesses sp_blocked  
       ON DOWT.[session_id] = sp_blocked.[spid] 
   INNER JOIN sys.sysprocesses sp_blocking  
       ON DOWT.[blocking_session_id] = sp_blocking.[spid] 
   CROSS APPLY sys.[dm_exec_sql_text](sp_blocked.[sql_handle]) AS DEST_blocked 
   CROSS APPLY sys.[dm_exec_sql_text](sp_blocking.[sql_handle]) AS DEST_blocking 
WHERE DTL.[resource_database_id] = DB_ID()


GO

/****** Object:  StoredProcedure [dbo].[sp_dba_mail]    Script Date: 05/19/2010 17:48:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[sp_dba_mail]
 as
SELECT m.mailitem_id,m.recipients,m.copy_recipients,m.subject,m.query,m.send_request_date,m.sent_status, e.description as ERROR
FROM msdb..sysmail_mailitems m join msdb..sysmail_log e on m.mailitem_id = e.mailitem_id
where m.sent_status <> 1 and m.send_request_date >= DATEADD(dd,-1,GETDATE()) and e.event_type <> 1

--SELECT * FROM msdb..sysmail_log where log_date >= DATEADD(dd,-1,GETDATE()) and event_type <> 1

GO

/****** Object:  StoredProcedure [dbo].[sp_dba_monitor]    Script Date: 05/19/2010 17:48:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[sp_dba_monitor]
as
begin
set nocount on
create table #result (result varchar (500))

insert #result select 'SERVER NAME: '+@@SERVERNAME + '  Date: '+CONVERT(CHAR(30),GETDATE())
insert #result select 'VERSION: '+ cast(serverproperty('productversion') as varchar(20)) + ' '+
cast(serverproperty('productlevel') as varchar(20))+ ' '+ cast(serverproperty('edition')  as varchar(40)) 

insert #result
SELECT --'MachineName: '+ serverproperty('ComputerNamePhysicalNetBIOS') +
'CPU Count: '+convert(nvarchar(2),CPU_COUNT) + '  '+
 'Physical Memory MB: '+convert(nvarchar(8),(physical_memory_in_bytes/1048576)) 
From sys.dm_os_sys_info
/*
insert #result
SELECT 
serverproperty('collation') as 'Collation'+
serverproperty('Isclustered') as 'ISClustered'+
serverproperty('IsFullTextInstalled') as 'ISFullText' +
SERVERPROPERTY('SqlCharSetName') as 'SqlCharSetName'+
SERVERPROPERTY('SqlSortOrderName') as 'SqlSortOrderName'
From sys.dm_os_sys_info
*/
 

IF NOT EXISTS (SELECT 1 FROM master.dbo.sysprocesses WHERE program_name = N'SQLAgent - Generic Refresher') 
insert #result select 'AGENT: The SQL Server Agent process is NOT running.'
ELSE 
insert #result select 'AGENT: The SQL Server Agent process is running.'

insert #result
select 'CONNECTIONS: ' + convert (char(30),COUNT(dbid)) 
FROM sys.sysprocesses WITH (nolock) WHERE dbid > 0 and spid > 50 

insert #result
select 'MAILS NOT SENT TODAY (ERROR): '+ CONVERT (char(30),count (*)) from msdb..sysmail_mailitems m where  m.sent_status <> 1 
and m.send_request_date >= DATEADD(dd,-1,GETDATE()) 

insert #result
select 'LAST SENT MAIL: '+ convert(char(30),max (send_request_date)) from msdb..sysmail_mailitems m where  m.sent_status = 1 

insert #result
select   
'ULTIMO EXPURGO: '+ convert(char(8),c1.data,112)+ ' - '+ ltrim(rtrim(upper(c1.tabela)))+' - LINHAS MOVIDAS: '+CONVERT(varchar(20), c2.qtd-c1.qtd )
from dbawork..controleExpurgo c1  
join dbawork..controleExpurgo c2 on c1.tabela = c2.tabela and c1.db = c2.db   
and convert(char(8),c1.data,112) = convert(char(8),c2.data,112)  
where c1.data >= dateadd(dd,-1,getdate())  
and c1.antesdepois = 'A' and c2.antesdepois = 'D' and c1.db = 'ozdb_hist' and c2.qtd-c1.qtd  <> 0  

if @@SERVERNAME = 'OZDB01'
begin
insert #result
select 'LOG SHIPPING - last_copied_date: '+CONVERT(varchar(22),last_copied_date)+' last_restored_date: '+ convert(varchar(22),last_restored_date)
+' last_restored_latency (minutes): '+convert(varchar(10),last_restored_latency) from ozdb03.msdb.dbo.log_shipping_monitor_secondary
insert #result
select 'LOG SHIPPING - last lpm_transaction: '+ CONVERT(varchar(22),MAX(requesttime))
from ozdb03.ozdb.dbo.lpm_transaction
end

if @@SERVERNAME = 'OZDB01'
begin
insert #result
select 'LOG AUTO KILL ' + CONVERT(char(8),data,112)+' -> '+ convert(varchar(10),COUNT(*) )
from dbawork..logautokill where data >= DATEADD(dd,-3,getdate()) 
group by CONVERT(char(8),data,112) order by 1
if @@ROWCOUNT = 0
insert #result
select 'ZERO KILLs'
end


--xp_fixeddrives

-- LOG
create table #log (data datetime, process varchar(15), log_text varchar(500))
insert #log
exec sp_dba_readerrorlog 0,1,'error:',null
insert #log
exec sp_dba_readerrorlog 0,1,'failed',null
insert #log
exec sp_dba_readerrorlog 0,1,'This instance of sql server has been',null
insert #log
exec sp_dba_readerrorlog 0,1,'This instance of sql server last',null
insert #log
exec sp_dba_readerrorlog 1,1,'shutdown.',null

insert #result select 'LAST SHUTDOWN: ' + CONVERT(varchar(30),data)+ ' '+ process +' '+ log_text 
from #log where log_text like '%SQL%system%shutdown.%' 
if @@ROWCOUNT = 0
insert #result select 'LAST SHUTDOWN: UNEXPECTED SHUTDOWN '
insert #result select 'LAST STARTUP: ' + CONVERT(varchar(30),data)+ ' '+ process +' '+ log_text from #log where log_text like '%This instance of sql server last%'
insert #result select 'ERRRORLOG: ERROS'
insert #result select CONVERT(varchar(30),data)+ ' '+ process +' '+ log_text from #log where data >= dateadd(dd,-1,getdate())
order by 1 desc

insert #result
select 'TRANSACTIONS/HOUR: '
insert #result
select 'DIA '+ CONVERT(varchar(5), DATEPART(dd,requesttime))+ ' HORA '+ convert(varchar(5),DATEPART(hh,requesttime))+ 
' CONVERSIONS '+CONVERT(varchar(5),COUNT(*))
from ozdb..LPM_TRANSACTION (nolock)
where
requestTime >= DATEADD(HH,-5,GETDATE()) and TRANSACTION_STATE_TYPE_ID = 4
group by DATEPART(dd,requesttime),DATEPART(hh,requesttime)
order by 1


insert #result
select 'DB SIZES: ' union
select DB_NAME(dbid) +' '+ convert (varchar(30),sum(size)*8/1024/1024) + ' GB'  from master..sysaltfiles
where DB_NAME(dbid) <> 'ipdb' and DB_NAME(dbid) <> 'dbawork' and DB_NAME(dbid) <> 'master' and DB_NAME(dbid) <> 'msdb' and DB_NAME(dbid) <> 'model'
 group by dbid

select * from #result
drop table #result
drop table #log
end





GO

/****** Object:  StoredProcedure [dbo].[sp_dba_monitorLS]    Script Date: 05/19/2010 17:48:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[sp_dba_monitorLS] 
as
if @@SERVERNAME = 'OZDB01'
begin
--select @@SERVERNAME
select primary_server,primary_database,secondary_server,secondary_database,last_copied_date,last_restored_date,
last_restored_latency_mins=last_restored_latency from ozdb03.msdb.dbo.log_shipping_monitor_secondary
exec sp_help_log_shipping_monitor_primary @primary_server= 'OZDB01', @primary_database= 'ozdb' --Monitor server or primary server
exec sp_help_log_shipping_alert_job --Monitor server, or primary or secondary server if no monitor is defined
exec sp_help_log_shipping_primary_database @database= 'ozdb'--Primary server
exec sp_help_log_shipping_primary_secondary @primary_database= 'ozdb'--Primary server
end
ELSE
begin 
--select @@SERVERNAME
select primary_server,primary_database,secondary_server,secondary_database,last_copied_date,last_restored_date,
last_restored_latency_mins=last_restored_latency from msdb.dbo.log_shipping_monitor_secondary
exec sp_help_log_shipping_monitor_secondary @secondary_server= 'OZDB03',@secondary_database= 'ozdb' --Monitor server or secondary server
exec sp_help_log_shipping_alert_job --Monitor server, or primary or secondary server if no monitor is defined
exec sp_help_log_shipping_secondary_database  @secondary_database = 'ozdb' --Secondary server
exec sp_help_log_shipping_secondary_primary @primary_server= 'OZDB01', @primary_database= 'ozdb' --secondary server.
end

GO

/****** Object:  StoredProcedure [dbo].[sp_dba_osbufferdescriptors_agg]    Script Date: 05/19/2010 17:48:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[sp_dba_osbufferdescriptors_agg]
as
  /*
SAMPLE EXECUTION:
exec sp_osbufferdescriptors_agg
*/
  set nocount  on ;
  
  set transaction  isolation  level  read  uncommitted ;
  
  select   case 
             when grouping(dbName) = 1 then '--- TOTAL ---'
             else dbName
           end as dbName,
           case 
             when grouping(fileId) = 1 then '--- TOTAL ---'
             else fileId
           end as fileId,
           case 
             when grouping(pageType) = 1 then '--- TOTAL ---'
             else pageType
           end as pageType,
           COUNT_BIG(* ) as countPages,
           sum(row_count) as sumRowCount,
           avg(row_count) as avgRowCount,
           sum(freeSpaceBytes) as sumFreeSpaceBytes,
           avg(freeSpaceBytes) as avgFreeSpaceBytes
  from     (select case 
                     when database_id = 32767 then 'resourceDb'
                     else cast(db_name(database_id) as varchar(25))
                   end as dbName,
                   cast(file_id as varchar(10)) as fileId,
                   cast(page_type as varchar(25)) as pageType,
                   row_count as row_count,
                   free_space_in_bytes as freeSpaceBytes
            from   sys.dm_os_buffer_descriptors bufferDescriptor with (nolock)) tmp
  group by dbName,fileId,pageType with rollup
  order by 2 , 5 desc;



GO

/****** Object:  StoredProcedure [dbo].[sp_dba_OverlapRole]    Script Date: 05/19/2010 17:48:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[sp_dba_OverlapRole]
as
set nocount on 
select 'ROLES' 
SELECT TOP 10 SPMember.name AS [login name], SPRole.name AS [role name] 
FROM master.sys.server_principals SPRole 
 INNER JOIN master.sys.server_role_members SRM ON SPRole.principal_id = SRM.role_principal_id 
 INNER JOIN master.sys.[server_principals] AS SPMember ON SRM.[member_principal_id] = SPMember.principal_id

select 'OVELAPS' 

SELECT SPMember.[login name], SPRole.name AS 'role name' 
FROM master.sys.server_principals SPRole 
 INNER JOIN master.sys.server_role_members SRM ON SPRole.principal_id = SRM.role_principal_id 
 INNER JOIN 
   ( 
   SELECT SP.name AS 'login name', SP.principal_id  
   FROM master.sys.server_principals sp_roles  
     INNER JOIN master.sys.server_role_members SRM ON sp_roles.principal_id = SRM.role_principal_id 
     INNER JOIN master.sys.server_principals SP ON  SRM.member_principal_id = SP.principal_id 
   WHERE sp_roles.type_desc = 'SERVER_ROLE' --AND SP_roles.name <> 'sysadmin' 
   GROUP BY SP.name, SP.principal_id 
   HAVING COUNT(SP.name) > 1 
   ) AS SPMember ON SRM.member_principal_id = SPMember.principal_id 
ORDER BY SPMember.[login name]  
GO

/****** Object:  StoredProcedure [dbo].[sp_dba_pr]    Script Date: 05/19/2010 17:48:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[sp_dba_pr]
as
set nocount on
select 
name, crdate
from sysobjects
where type = 'P'
order by 1

GO

/****** Object:  StoredProcedure [dbo].[sp_dba_Proc]    Script Date: 05/19/2010 17:48:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[sp_dba_Proc]           
@parm char(1) = null          
as            
            
  set nocount on            
            
  if @parm is null          
  select @parm = 'S'          
            
            
          
            
            
  -- PROCESSOS ATIVOS            
            
  declare  @sysprocesses table(            
    spid         smallint not null,            
    blocked      smallint null,            
--    waittime     int null,            
    dbid         smallint null,            
    uid          smallint  null,            
    cpu          int null,            
    physical_io  bigint null,            
    memusage     int null,            
    last_batch   datetime  null,            
    open_tran    smallint null,            
    status       varchar(60) null,            
    hostname     varchar(60) null,            
    program_name varchar(50) null,            
    cmd          varchar(50) null,            
  loginame     varchar(50) null,            
   sql_handle   binary (20) null,            
    stmt_start   int,            
    stmt_end     int , buffer varchar(600) ,        
    waittime bigint,        
lastwaittype nchar (64),onde varchar(300))    
            
            
  insert @sysprocesses            
  select            
    spid,            
    blocked ,            
  --  waittime,            
    dbid,            
    uid,            
    cpu,            
    physical_io,            
    memusage,            
    last_batch,            
    open_tran,            
    convert(char(60),status),            
    convert(char(60),hostname),            
    convert(char(50),program_name),            
    convert(char(50),cmd),            
    convert(char(50),loginame),            
    convert(binary(20),sql_handle),            
    stmt_start,            
    stmt_end,null,    waittime ,        
lastwaittype   ,null         
  from sysprocesses (NOLOCK)             
  where spid >= 50 and (open_tran > 0 or blocked <> 0 or status in         
  ('suspend','running' ,'runnable'))    
            
  update @sysprocesses set hostname = 'FEP03' where hostname like '%B0%11%'    
  update @sysprocesses set hostname = 'FEP02' where hostname like '%18%92%'    
  update @sysprocesses set hostname = 'FEP01' where hostname like '%0F%A1%'    
      
         
       
            
    if @parm = 'S' --faz o dbcc          
BEGIN            
            
  -- select * from @sysprocesses            
            
            
            
  declare  @syslockinfo table(            
    rsc_dbid   int null,            
    rsc_indid  int null,            
    rsc_objid  int null,            
    rsc_type   int null,            
    req_mode   int null,            
    req_status int null,            
    req_spid   int null )            
            
            
            
  insert @syslockinfo            
  select            
    rsc_dbid,            
    rsc_indid,            
    rsc_objid,            
    rsc_type,            
    req_mode,            
    req_status,            
    req_spid            
  from master..syslockinfo a (NOLOCK)            
  where exists (            
    select 1 from @sysprocesses p            
    where a.req_spid = p.spid  )            
            
declare @min int, @max int, @cmd varchar(50),@EventInfo varchar(500)            
select @min = min(spid), @max = max(spid) from @sysprocesses            
            
              
if exists (select 1 from tempdb..sysobjects where type = 'U' and name like 'buffer%')            
drop table #buffer            
create table #buffer  (eventType varchar(2000), parameters bigint, EventInfo varchar(2000))            
            
            
while @min <= @max            
begin            
select @cmd = 'dbcc inputbuffer ('+ltrim(rtrim(convert(char(5),@min)))+')'            
insert #buffer  (EventType, Parameters, EventInfo)             
exec (@cmd)            
select @EventInfo = EventInfo from #buffer            
update @sysprocesses set buffer = @EventInfo where spid = @min            
select @min = min(spid) from @sysprocesses where spid > @min            
delete #buffer            
end            
           
           
  update @sysprocesses set onde = 'Integrator' where buffer like '%integrator%'    
  update @sysprocesses set onde = 'Transaction' where buffer like '%transaction%'    
  update @sysprocesses set onde = 'Replicacao' where program_name like '%Repl%'    
  update @sysprocesses set onde = 'Reference' where buffer like '%Reference%'    
  update @sysprocesses set onde = 'Carrier' where buffer like '%Carrier%'     
  update @sysprocesses set onde = 'COMMIT' where buffer like '%@@TRANCOUNT%'     
  update @sysprocesses set onde = 'Brand' where buffer like '%Brand%'   
  update @sysprocesses set onde = 'Landing' where buffer like '%Landing%'    
  update @sysprocesses set onde = 'Template' where buffer like '%template%'    
    update @sysprocesses set onde = 'Outro' where onde is null    
       
      
            
  select            
    SPID = spid,                 
    LOGIN = substring(loginame,1,20),                  
    CPU = convert(char(7),cpu),                 
    IO = convert(char(7),physical_io),            
    MEM = convert(char(4),memusage),                 
    STATUS = substring(b.status,1,20),                 
    COMANDO = substring(cmd,1,20),                 
    blocked    ,   onde,        
    DB =  substring(db_name(dbid),1,30),           
    waittime_ms=SUM ( waittime) ,        
lastwaittype ,        
PARADO_SEGs=DATEDIFF(ss  , max(last_batch),GETDATE()),    
    HOSTNAME = substring(b.hostname,1,40),               
    PGM = substring(b.program_name,1,30),            
    TRANS = convert(char(2),b.open_tran),Buffer,            
Qtd_Obj = count (distinct rsc_objid)            
  from  @sysprocesses b left join @syslockinfo l on b.spid = l.req_spid            
  where cmd not in ('awaiting command', 'WAITFOR')            
    and spid <> @@spid            
group by spid, substring(loginame,1,20),convert(char(7),cpu), convert(char(7),physical_io),convert(char(4),memusage),                 
substring(b.status,1,20), substring(cmd,1,20),blocked, onde, substring(db_name(dbid),1,30),substring(b.hostname,1,40),                 
substring(b.program_name,1,30),convert(char(2),b.open_tran),Buffer , lastwaittype           
  union                 
  select            
    SPID = spid,                 
    LOGIN = 'Backup',                  
    CPU = convert(char(7),cpu),                 
    IO = convert(char(7),physical_io),            
    MEM = convert(char(4),memusage),                     
    STATUS = substring(b.status,1,20),                 
    COMANDO = substring(cmd,1,20),                 
    blocked  ,   onde,           
    DB =  substring(db_name(dbid),1,30),            
     waittime_ms=SUM ( waittime) ,        
lastwaittype ,        
PARADO_SEGs=DATEDIFF(ss  , max(last_batch),GETDATE()),    
    HOSTNAME = substring(b.hostname,1,40),                 
    PGM = substring(b.program_name,1,30),            
    TRANS = convert(char(2),b.open_tran),Buffer ,            
Qtd_Obj = count (distinct rsc_objid)            
from  @sysprocesses b left join @syslockinfo l on b.spid = l.req_spid            
  where cmd in ('DUMP DATABASE', 'LOAD DATABASE')            
    and spid <> @@spid            
group by spid, substring(loginame,1,20),convert(char(7),cpu), convert(char(7),physical_io),convert(char(4),memusage),                 
substring(b.status,1,20), substring(cmd,1,20),blocked, onde, substring(db_name(dbid),1,30),substring(b.hostname,1,40),                 
substring(b.program_name,1,30),convert(char(2),b.open_tran),Buffer,lastwaittype    
  union            
   select            
    SPID = spid,               
    LOGIN = substring(loginame,1,20),                
    CPU = convert(char(7),cpu),               
    IO = convert(char(7),physical_io),            
    MEM = convert(char(4),memusage),                   
    STATUS = substring(b.status,1,20),               
    COMANDO = substring(cmd,1,20),               
    blocked , onde,    
    DB =  substring(db_name(dbid),1,30),             
    waittime_ms=SUM ( waittime) ,        
lastwaittype ,        
PARADO_SEGs=DATEDIFF(ss  , max(last_batch),GETDATE()),     
    HOSTNAME = substring(b.hostname,1,40),               
    PGM = substring(b.program_name,1,30),            
    TRANS = convert(char(2),b.open_tran) ,Buffer,            
Qtd_Obj = count (distinct rsc_objid)            
from  @sysprocesses b left join @syslockinfo l on b.spid = l.req_spid            
  where exists (select 1 from @sysprocesses c where b.spid = c.blocked )            
    and spid <> @@spid            
group by spid, substring(loginame,1,20),convert(char(7),cpu), convert(char(7),physical_io),convert(char(4),memusage),                 
substring(b.status,1,20), substring(cmd,1,20),blocked, onde, substring(db_name(dbid),1,30),substring(b.hostname,1,40),                 
substring(b.program_name,1,30),convert(char(2),b.open_tran),Buffer  , lastwaittype      
  union                 
  select            
    SPID = spid,                 
    LOGIN = substring(loginame,1,20),                  
    CPU = convert(char(7),cpu),                 
    IO = convert(char(7),physical_io),            
    MEM = convert(char(4),memusage),                     
    STATUS = substring(b.status,1,20),                
    COMANDO = substring(cmd,1,20),                 
    blocked   ,    onde,        
    DB =  substring(db_name(dbid),1,30),              
 waittime_ms=SUM ( waittime) ,        
lastwaittype ,        
PARADO_SEGs=DATEDIFF(ss  , max(last_batch),GETDATE()),          
    HOSTNAME = substring(b.hostname,1,40),                 
    PGM = substring(b.program_name,1,30),            
    TRANS = convert(char(2),b.open_tran) ,Buffer   ,            
Qtd_Obj = count (distinct rsc_objid)            
from  @sysprocesses b left join @syslockinfo l on b.spid = l.req_spid            
  where (open_tran > 0 or blocked > 0)            
    and spid <> @@spid            
group by spid, substring(loginame,1,20),convert(char(7),cpu), convert(char(7),physical_io),convert(char(4),memusage),                 
substring(b.status,1,20), substring(cmd,1,20),blocked, onde, substring(db_name(dbid),1,30),substring(b.hostname,1,40),                 
substring(b.program_name,1,30),convert(char(2),b.open_tran),Buffer   , lastwaittype            
union
select '9999','DATA= '+CONVERT(char(8),data,112),null,null,null,
null,null,null,null,null,null,null,null,null,'KILLS= '+convert(char(5),isnull(COUNT(*),0)),null,null,null
from dbawork..logautokill where data >= CONVERT(char(8),dateadd(dd,-3,getdate()),112)
group by CONVERT(char(8),data,112)
order by 1            
drop table #buffer            
END --IF inicial          
ELSE          
begin          
  select            
    SPID = spid,                 
    LOGIN = substring(loginame,1,20),                  
    CPU = convert(char(7),cpu),                 
    IO = convert(char(7),physical_io),            
    MEM = convert(char(4),memusage),                 
    STATUS = substring(b.status,1,20),                 
    COMANDO = substring(cmd,1,20),                 
    blocked     ,    onde,       
    DB =  substring(db_name(dbid),1,30),          
 waittime_ms=SUM ( waittime) ,        
lastwaittype ,        
PARADO_SEGs=DATEDIFF(ss  , max(last_batch),GETDATE()),    
    HOSTNAME = substring(b.hostname,1,40),                 
    PGM = substring(b.program_name,1,30),            
    TRANS = convert(char(2),b.open_tran),Buffer,            
Qtd_Obj = count (distinct rsc_objid)            
  from  @sysprocesses b left join @syslockinfo l on b.spid = l.req_spid            
  where cmd not in ('awaiting command', 'WAITFOR')            
    and spid <> @@spid            
group by spid, substring(loginame,1,20),convert(char(7),cpu), convert(char(7),physical_io),convert(char(4),memusage),                 
substring(b.status,1,20), substring(cmd,1,20),blocked, onde, onde, substring(db_name(dbid),1,30),substring(b.hostname,1,40),                 
substring(b.program_name,1,30),convert(char(2),b.open_tran),Buffer  , lastwaittype             
  union                 
  select            
    SPID = spid,                 
    LOGIN = 'Backup',                  
    CPU = convert(char(7),cpu),                 
    IO = convert(char(7),physical_io),            
    MEM = convert(char(4),memusage),                     
    STATUS = substring(b.status,1,20),                 
    COMANDO = substring(cmd,1,20),                 
    blocked ,   onde,            
    DB =  substring(db_name(dbid),1,30),           
 waittime_ms=SUM ( waittime) ,        
lastwaittype ,        
PARADO_SEGs=DATEDIFF(ss  , max(last_batch),GETDATE()),           
    HOSTNAME = substring(b.hostname,1,40),                 
    PGM = substring(b.program_name,1,30),            
    TRANS = convert(char(2),b.open_tran),Buffer ,            
Qtd_Obj = count (distinct rsc_objid)            
from  @sysprocesses b left join @syslockinfo l on b.spid = l.req_spid            
  where cmd in ('DUMP DATABASE', 'LOAD DATABASE')            
    and spid <> @@spid         
group by spid, substring(loginame,1,20),convert(char(7),cpu), convert(char(7),physical_io),convert(char(4),memusage),                 
substring(b.status,1,20), substring(cmd,1,20),blocked, onde, substring(db_name(dbid),1,30),substring(b.hostname,1,40),                 
substring(b.program_name,1,30),convert(char(2),b.open_tran),Buffer , lastwaittype              
  union            
   select            
    SPID = spid,               
    LOGIN = substring(loginame,1,20),                
    CPU = convert(char(7),cpu),               
    IO = convert(char(7),physical_io),            
    MEM = convert(char(4),memusage),                   
    STATUS = substring(b.status,1,20),               
    COMANDO = substring(cmd,1,20),               
    blocked   ,      onde,     
    DB =  substring(db_name(dbid),1,30),              
    waittime_ms=SUM ( waittime) ,        
lastwaittype ,        
PARADO_SEGs=DATEDIFF(ss  , max(last_batch),GETDATE()),    
           
    HOSTNAME = substring(b.hostname,1,40),               
    PGM = substring(b.program_name,1,30),            
    TRANS = convert(char(2),b.open_tran) ,Buffer,            
Qtd_Obj = count (distinct rsc_objid)            
from  @sysprocesses b left join @syslockinfo l on b.spid = l.req_spid            
  where exists (select 1 from @sysprocesses c where b.spid = c.blocked )            
    and spid <> @@spid            
group by spid, substring(loginame,1,20),convert(char(7),cpu), convert(char(7),physical_io),convert(char(4),memusage),                 
substring(b.status,1,20), substring(cmd,1,20),blocked, onde, substring(db_name(dbid),1,30),substring(b.hostname,1,40),                 
substring(b.program_name,1,30),convert(char(2),b.open_tran),Buffer   , lastwaittype            
  union                 
  select            
    SPID = spid,                 
    LOGIN = substring(loginame,1,20),                  
    CPU = convert(char(7),cpu),                 
    IO = convert(char(7),physical_io),            
    MEM = convert(char(4),memusage),                     
    STATUS = substring(b.status,1,20),                
    COMANDO = substring(cmd,1,20),                 
    blocked ,   onde,           
    DB =  substring(db_name(dbid),1,30),            
    waittime_ms=SUM ( waittime) ,        
lastwaittype ,        
PARADO_SEGs=DATEDIFF(ss  , max(last_batch),GETDATE()),           
    HOSTNAME = substring(b.hostname,1,40),                 
    PGM = substring(b.program_name,1,30),            
    TRANS = convert(char(2),b.open_tran) ,Buffer   ,            
Qtd_Obj = count (distinct rsc_objid)            
from  @sysprocesses b left join @syslockinfo l on b.spid = l.req_spid            
  where (open_tran > 0 or blocked > 0)            
    and spid <> @@spid            
group by spid, substring(loginame,1,20),convert(char(7),cpu), convert(char(7),physical_io),convert(char(4),memusage),                 
substring(b.status,1,20), substring(cmd,1,20),blocked, onde, substring(db_name(dbid),1,30),substring(b.hostname,1,40),                 
substring(b.program_name,1,30),convert(char(2),b.open_tran),Buffer   , lastwaittype            
union
select '9999','DATA= '+CONVERT(char(8),data,112),null,null,null,
null,null,null,null,null,null,null,null,null,'KILLS= '+convert(char(5),isnull(COUNT(*),0)),null,null,null
from dbawork..logautokill where data >= CONVERT(char(8),dateadd(dd,-3,getdate()),112)
group by CONVERT(char(8),data,112)
order by 1            
          
end -- else 



GO

/****** Object:  StoredProcedure [dbo].[sp_dba_proc2]    Script Date: 05/19/2010 17:48:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[sp_dba_proc2] 
as
SELECT top 10
       (SELECT TOP 1 SUBSTRING(s2.text,statement_start_offset / 2+1 , 
      ( (CASE WHEN statement_end_offset = -1 
         THEN (LEN(CONVERT(nvarchar(max),s2.text)) * 2) 
         ELSE statement_end_offset END)  - statement_start_offset) / 2+1))  AS sql_statement,
    execution_count,     last_execution_time,   
    total_worker_time, max_worker_time,    total_physical_reads, 
    last_physical_reads, max_physical_reads,  
    total_logical_writes,last_logical_writes, 
    max_logical_writes  
FROM sys.dm_exec_query_stats AS s1 
CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS s2  
WHERE s2.objectid is null 
ORDER BY 6 desc

SELECT TOP 5 total_worker_time/execution_count AS [Avg CPU Time],
    SUBSTRING(st.text, (qs.statement_start_offset/2)+1, 
        ((CASE qs.statement_end_offset
          WHEN -1 THEN DATALENGTH(st.text)
         ELSE qs.statement_end_offset
         END - qs.statement_start_offset)/2) + 1) AS statement_text
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
ORDER BY total_worker_time/execution_count DESC


GO

/****** Object:  StoredProcedure [dbo].[sp_dba_proc3]    Script Date: 05/19/2010 17:48:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[sp_dba_proc3]
as
set nocount on
--SELECT spid,db_name(dbid),loginame,cmd,open_tran,blocked = case when blocked = spid then 0 else blocked end,status,io=sum(physical_io),mem_kb=sum(memusage),
--cpu_cycs=sum(cpu), (SELECT [text] FROM fn_get_sql(sql_handle))
--FROM master..sysprocesses p1
--WHERE ((spid > 50 and status <> 'sleeping') or (blocked <> 0) or 
--exists (select 1 from master..sysprocesses p2 where p1.spid = p2.blocked)) --and spid <> @@SPID
-- group by spid,dbid,loginame,cmd,open_tran,blocked,status,sql_handle
--Returns the all user process running on SQL Server   
--along with query being executed by each process  
SELECT  spid=session_id,command,loginame,hostname,open_tran,--kpid,
cpu_time,duration_secs=total_elapsed_time/1000,r.status,blk=blocking_session_id,logical_reads,reads,writes,
DB_NAME(database_id) AS [Database], r.wait_time ,[text] AS [LAST_Query]  
FROM sys.dm_exec_requests r  
CROSS APPLY sys.dm_exec_sql_text(r.plan_handle) st  
left join master..sysprocesses p on r.session_id = p.spid and kpid = (select max(kpid) from master..sysprocesses p2 
where p2.spid = p.spid )
WHERE session_Id > 50           -- Consider spids for users only, no system spids. 
union 
SELECT  spid,cmd,loginame,hostname,open_tran,--kpid,
cpu,duration_secs=DATEDIFF(ss,last_batch,getdate()),status,blk=blocked,physical_io,physical_io,physical_io,
DB_NAME(dbid) AS [Database], waittime ,null AS [LAST_Query]  
FROM master..sysprocesses p
where  p.blocked <> 0 and
p.kpid = (select max(kpid) from master..sysprocesses p2 where p2.spid = p.spid ) and
exists (select 1  from master..sysprocesses p3 where p3.blocked = p.spid )
union 
SELECT  spid,cmd,loginame,hostname,open_tran,--kpid,
cpu,duration_secs=DATEDIFF(ss,last_batch,getdate()),status,blk=blocked,physical_io,physical_io,physical_io,
DB_NAME(dbid) AS [Database], waittime ,null AS [LAST_Query]  
FROM master..sysprocesses p
where  p.blocked = 0 and status = 'sleeping' and open_tran > 0 and
exists (select 1  from master..sysprocesses p3 where p3.blocked = p.spid )
order by 1


GO

/****** Object:  StoredProcedure [dbo].[sp_dba_readerrorlog]    Script Date: 05/19/2010 17:48:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create PROC [dbo].[sp_dba_readerrorlog]( 
   @p1     INT = 0, 
   @p2     INT = NULL, 
   @p3     VARCHAR(255) = NULL, 
   @p4     VARCHAR(255) = NULL) 
AS 
BEGIN 

--This procedure takes four parameters:
--1) Value of error log file you want to read: 0 = current, 1 = Archive #1, 2 = Archive #2, etc...
--2) Log file type: 1 or NULL = error log, 2 = SQL Agent log
--3) Search string 1: String one you want to search for
--4) Search string 2: String two you want to search for to further refine the results


   IF (NOT IS_SRVROLEMEMBER(N'securityadmin') = 1) 
   BEGIN 
      RAISERROR(15003,-1,-1, N'securityadmin') 
      RETURN (1) 
   END 
    
   IF (@p2 IS NULL) 
       EXEC xp_readerrorlog @p1 
   ELSE 
       EXEC xp_readerrorlog @p1,@p2,@p3,@p4 
END

GO

/****** Object:  StoredProcedure [dbo].[sp_dba_SearchCachedPlans]    Script Date: 05/19/2010 17:48:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[sp_dba_SearchCachedPlans] 
@StringToSearchFor VARCHAR(255) = '%<MissingIndexes>%'
AS 
/*---------------------------------------------------------------------- 
Purpose: Inspects cached plans for a given string. 
------------------------------------------------------------------------

Parameters: @StringToSearchFor - string to search for e.g. '%<MissingIndexes>%'.

Revision History: 
03/06/2008 Ian_Stirk@yahoo.com Initial version 

Example Usage: 
1. exec dbo.sp_dba_SearchCachedPlans '%<MissingIndexes>%' 
2. exec dbo.sp_dba_SearchCachedPlans '%<ColumnsWithNoStatistics>%' 
3. exec dbo.sp_dba_SearchCachedPlans '%<TableScan%' 
4. exec dbo.sp_dba_SearchCachedPlans '%CREATE PROC%MessageWrite%'

-----------------------------------------------------------------------*/ 
BEGIN 
-- Do not lock anything, and do not get held up by any locks. 
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
SELECT TOP 20 
st.text AS [SQL] 
, cp.cacheobjtype 
, cp.objtype 
, DB_NAME(st.dbid)AS [DatabaseName] 
, cp.usecounts AS [Plan usage] 
, qp.query_plan 
FROM sys.dm_exec_cached_plans cp 
CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle) st 
CROSS APPLY sys.dm_exec_query_plan(cp.plan_handle) qp 
WHERE CAST(qp.query_plan AS NVARCHAR(MAX))LIKE @StringToSearchFor 
ORDER BY cp.usecounts DESC 

select 'Outras opcoes: ',' exec dbo.sp_dba_SearchCachedPlans ''%<MissingIndexes>%''' 
select 'Outras opcoes: ',' exec dbo.sp_dba_SearchCachedPlans ''%<ColumnsWithNoStatistics>%''' 
select 'Outras opcoes: ',' exec dbo.sp_dba_SearchCachedPlans ''%<TableScan%''' 
select 'Outras opcoes: ',' exec dbo.sp_dba_SearchCachedPlans ''%CREATE PROC%MessageWrite%''' 

END


GO

/****** Object:  StoredProcedure [dbo].[sp_dba_startup]    Script Date: 05/19/2010 17:48:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[sp_dba_startup]
as
dbcc traceon (8033)
dbcc traceon (830)

declare @assunto varchar(100)
select @assunto = rtrim(substring(@@servername,1,30))+': Servidor Reiniciando em: '+convert(varchar(19),getdate())

EXEC msdb.dbo.sp_send_dbmail
    @profile_name = 'oznotifier',
	@execute_query_database = 'master',
	--@recipients = 'rodrigo.souza@ozonion.com',
    @recipients = 'sergio.bazilio@ozonion.com;eduardo.paredes@ozonion.com;rodrigo.souza@ozonion.com', 
    @subject = @assunto,
    @query = 'exec sp_dba_monitor',
    @query_result_header = 1,
    @importance = 'high',
@attach_query_result_as_file = 1,@query_attachment_filename= 'startup.xls',
@query_result_width = 3000,@query_no_truncate=1,
    @body_format = 'HTML' 

GO

EXEC sp_procoption N'[dbo].[sp_dba_startup]', 'startup', '1'

GO

/****** Object:  StoredProcedure [dbo].[sp_dba_string]    Script Date: 05/19/2010 17:48:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[sp_dba_string]
@string varchar (50) 
as
set nocount on
select 'Objetos que usam: ',@string
select @string = '''%'+@string+'%'''
declare @comm varchar(600)
select @comm = 'select o.name from ?..syscomments c join ?..sysobjects o on o.id = c.id where text like '+@string+' order by 1'
--select @comm
exec sp_msforeachdb @command1 = @comm

SELECT name AS SSISPackageName
, CONVERT(XML, CONVERT(VARBINARY(MAX), packagedata)) AS SSISPackageXML
, CONVERT(VARCHAR(MAX), CONVERT(VARBINARY(MAX), packagedata)) AS SSISPackageVarchar
INTO #SSISObjectSearch
FROM msdb.dbo.sysdtspackages

SELECT *
FROM #SSISObjectSearch
WHERE SSISPackageVarchar LIKE @string

drop table #SSISObjectSearch



GO

/****** Object:  StoredProcedure [dbo].[sp_dba_tb]    Script Date: 05/19/2010 17:48:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE proc [dbo].[sp_dba_tb]    
@tb varchar(100) = null  
as    
begin    
set nocount on    
if exists (select 1 from tempdb.sys.sysobjects where name like '%space%')    
drop table #space    
create table #space (tabela varchar(50), linhas varchar(18), reserved varchar(18), dados varchar(18), indice varchar(18), livre varchar(18))    
    
    
--if exists (select 1 from tempdb.sys.sysobjects where name like '%tab%')    
--drop table #tab    
    
    
select     
substring (o.name,1,50) as Tabela,o.crdate, user_name(o.uid) as Owner,max(rows) as Linhas, count(*) as Indices     
into #tab    
from sys.sysobjects o left join sys.sysindexes i on o.id = i.id    
where user_name(o.uid) <> 'sys' and o.name not like 'spt_%' and o.name not like 'MS%' and o.type = 'U'    
and o.name not like 'sys%'  and o.name = isnull(@tb,o.name)  
group by o.name,o.crdate,o.uid    
order by 4 desc    
    
declare @min varchar(50), @max varchar(50)    
select @min=min(tabela), @max = max(tabela) from #tab    
    
while @min <= @max    
begin    
    
insert #space     
exec sp_spaceused @min    
    
select @min=min(tabela) from #tab where tabela > @min    
end    
update #space set    
dados = replace (dados,' KB',''),    
indice = replace (indice,' KB',''),    
livre = replace (livre,' KB','') ,   
reserved = replace (reserved,' KB','')  
    
if @tb is not null    
begin
select t.*,     
(convert(bigint,s.dados)/1024) as AreaDados_MB,    
(convert(bigint,s.indice)/1024) as AreaIndice_MB,    
(convert(bigint,s.livre)/1024) as AreaLivre_MB  ,  
(convert(bigint,s.reserved)/1024) as AreaTotal_MB    
from #tab t left join #space s on t.tabela = s.tabela  and t.tabela = @tb
order by linhas desc   

if @@rowcount = 0  
begin  
select 'Objeto nao achado.'   
return  
end  

if @tb is not null  
exec sp_help @tb  
end

else
select t.*,     
(convert(bigint,s.dados)/1024) as AreaDados_MB,    
(convert(bigint,s.indice)/1024) as AreaIndice_MB,    
(convert(bigint,s.livre)/1024) as AreaLivre_MB  ,  
(convert(bigint,s.reserved)/1024) as AreaTotal_MB    
from #tab t left join #space s on t.tabela = s.tabela 
  
drop table #space    
drop table #tab    
end    



GO

/****** Object:  StoredProcedure [dbo].[sp_dba_tbUse]    Script Date: 05/19/2010 17:48:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE proc [dbo].[sp_dba_tbUse] as
set nocount on
declare @use varchar(30)
select @use = 'USE ' + db_name()
exec(@use)

SELECT 
 DB_NAME(ius.database_id) AS DBName,
 OBJECT_NAME(ius.object_id) AS TableName,
 SUM(ius.user_scans) AS Scans ,
 SUM(ius.user_lookups) AS Lookups ,
 SUM(ius.user_seeks) AS Seeks,
 SUM(ius.user_updates) AS Updates 
FROM sys.indexes i
INNER JOIN sys.dm_db_index_usage_stats ius
 ON ius.object_id = i.object_id
 AND ius.index_id = i.index_id 
 where database_id = DB_ID()
 GROUP BY DB_NAME(ius.database_id), OBJECT_NAME(ius.object_id)
ORDER BY 3 DESC


SELECT OBJECT_NAME(A.[OBJECT_ID]) AS [OBJECT NAME], 
       I.[NAME] AS [INDEX NAME], 
       A.LEAF_INSERT_COUNT, 
       A.LEAF_UPDATE_COUNT, 
       A.LEAF_DELETE_COUNT 
FROM   SYS.DM_DB_INDEX_OPERATIONAL_STATS (NULL,NULL,NULL,NULL ) A 
       INNER JOIN SYS.INDEXES AS I 
         ON I.[OBJECT_ID] = A.[OBJECT_ID] 
            AND I.INDEX_ID = A.INDEX_ID 
WHERE  OBJECTPROPERTY(A.[OBJECT_ID],'IsUserTable') = 1 
 





GO

/****** Object:  StoredProcedure [dbo].[sp_dba_tran]    Script Date: 05/19/2010 17:48:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[sp_dba_tran] @horas int = 5
as
set nocount on
select @horas = @horas * -1

declare @TRAN table (DIA int, HORA int, TRANSACTIONS int)
declare @CONV table (DIA int, HORA int, CONVERSIONS int)
declare @RESC table (DIA int, HORA int, RESCUES int)

insert @TRAN 
select DATEPART(dd,requesttime),DATEPART(hh,requesttime), COUNT(*)
from ozdb..LPM_TRANSACTION (nolock)
where
requestTime >= DATEADD(HH,@horas,GETDATE()) 
group by DATEPART(dd,requesttime),DATEPART(hh,requesttime)

insert @CONV 
select DATEPART(dd,requesttime),DATEPART(hh,requesttime), COUNT(*)
from ozdb..LPM_TRANSACTION (nolock)
where
requestTime >= DATEADD(HH,@horas,GETDATE()) and TRANSACTION_STATE_TYPE_ID = 4
group by DATEPART(dd,requesttime),DATEPART(hh,requesttime)


insert @RESC
select DATEPART(dd,requesttime),DATEPART(hh,requesttime), COUNT(*)
from ozdb..LPM_TRANSACTION (nolock)
where
requestTime >= DATEADD(HH,@horas,GETDATE()) and TRANSACTION_STATE_TYPE_ID = 7
group by DATEPART(dd,requesttime),DATEPART(hh,requesttime)


select t.DIA, t.HORA, TRANSACTIONS=isnull(t.TRANSACTIONS,0), CONVERSIONS=ISNULL( C.CONVERSIONS,0), RESCUES=ISNULL( R.RESCUES,0)
from @TRAN t
left outer join @CONV c  on t.dia = c.DIA and t.hora = c.HORA
left outer join @RESC r  on t.dia = r.DIA and t.hora = r.HORA
order by 1,2

GO

/****** Object:  StoredProcedure [dbo].[sp_dba_version]    Script Date: 05/19/2010 17:48:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[sp_dba_version]
as
begin
 
 select getdate(),
           cast(serverproperty('machinename') as varchar(20)),
           cast(serverproperty('productversion') as varchar(20)),
           cast(serverproperty('productlevel') as varchar(20)),
           cast(serverproperty('edition')  as varchar(40))
end

GO

/****** Object:  StoredProcedure [dbo].[sp_dba_vw]    Script Date: 05/19/2010 17:48:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[sp_dba_vw]
as
set nocount on
select 
name, crdate
from sysobjects
where type = 'v'
order by 1

GO

/****** Object:  StoredProcedure [dbo].[sp_dba_wait]    Script Date: 05/19/2010 17:48:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[sp_dba_wait] as
SELECT W1.wait_type, w3.wait_desc,
 CAST(W1.wait_time_s AS DECIMAL(12, 2)) AS wait_time_s, 
 CAST(W1.waiting_tasks_count AS DECIMAL(12,0)) AS tasks_count, 
 CAST(W1.max_wait_time_s AS DECIMAL(12, 2)) AS max_wait_time_s, 
 CAST(W1.pct AS DECIMAL(12, 2)) AS pct, 
 CAST(SUM(W2.pct) AS DECIMAL(12, 2)) AS running_pct 
FROM Waits AS W1  INNER JOIN Waits AS W2 ON W2.ranking <= W1.ranking 
join  dbawork..waittypes w3 on w1.wait_type = w3.wait_type
GROUP BY W1.ranking,  
 W1.wait_type, w3.wait_desc, W1.wait_time_s ,w1.max_wait_time_s,w1.waiting_tasks_count,W1.pct
HAVING SUM(W2.pct) - W1.pct < 99; -- percentage threshold

GO

