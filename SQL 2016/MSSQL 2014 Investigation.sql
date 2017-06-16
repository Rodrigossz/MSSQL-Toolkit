-- Scripts Criados e adaptados e "organizados" por Rodrigo Souza 
-- rodrigossz@outlook.com
-- rodrigossz@gmail.com


select 'Rodar no master!!!!!!!!!!!!!!'
go

exec sp_configure 'advanced', 1
reconfigure with override
exec sp_configure 
go
sp_helpdb tempdb
go
select * from sys.master_files
go


SELECT 'Open Transactions - block possible' as 'What', DMES.host_name AS 'Computer Name'
	, nt_user_name AS 'Windows Username'
	, mdsd.NAME AS 'Database with open Transaction'
	, DMES.session_id AS 'Session ID'
	,  spn.open_tran  as 'Open Transactions'
	, RTRIM(CAST(DMES.login_time AS NVARCHAR(30))) AS 'Date The Query window opened'
	, CASE 
		WHEN DMES.is_user_process = 0
			THEN 'No'
		WHEN DMES.is_user_process = 1
			THEN 'Yes'
		END AS 'User Process'
	, CASE 
		WHEN DMES.transaction_isolation_level = 0
			THEN 'Unspecified'
		WHEN DMES.transaction_isolation_level = 1
			THEN 'Read Uncommitted'
		WHEN DMES.transaction_isolation_level = 2
			THEN 'Read Committed'
		WHEN DMES.transaction_isolation_level = 3
			THEN 'Repeatable Read'
		WHEN DMES.transaction_isolation_level = 4
			THEN 'Serializable'
		WHEN DMES.transaction_isolation_level = 5
			THEN 'Snapshot'
		END AS 'Transaction Isolation Level'
	, CASE 
		WHEN DMES.LOCK_TIMEOUT = '-1'
			THEN 'No lock time out specified, the lock will expire when the transaction has completed'
		WHEN DMES.LOCK_TIMEOUT >= 0
			THEN ' A Lockout Time of' + ' ' + CAST(CONVERT(REAL, (DMES.LOCK_TIMEOUT) / (1000.00)) AS VARCHAR(MAX)) + ' ' + 'Seconds has been specified'
		END AS 'Lock Timeout'
FROM master..sysprocesses AS spn
JOIN sys.dm_exec_sessions AS DMES
	ON DMES.session_id = spn.spid
JOIN master.dbo.sysdatabases mdsd
	ON spn.dbid = mdsd.dbid
WHERE DMES.session_id = spn.spid
	AND spn.open_tran <> 0

	/******************* #1 **********************/
SELECT 'CPU USAGE PER DATABASE per plan' as 'What',
      dbs.name
    , cacheobjtype
    , total_cpu_time
    , total_execution_count
FROM
      (
        SELECT TOP 10
            SUM(qs.total_worker_time) AS total_cpu_time
          , SUM(qs.execution_count) AS total_execution_count
          , COUNT(*) AS number_of_statements
          , qs.plan_handle
        FROM
            sys.dm_exec_query_stats qs
        GROUP BY
            qs.plan_handle
        ORDER BY
            SUM(qs.total_worker_time) DESC
      ) a
      INNER JOIN (
                   SELECT
                        plan_handle
                      , pvt.dbid
                      , cacheobjtype
                   FROM
                        (
                          SELECT
                              plan_handle
                            , epa.attribute
                            , epa.value
                            , cacheobjtype
                          FROM
                              sys.dm_exec_cached_plans
                              OUTER APPLY sys.dm_exec_plan_attributes(plan_handle) AS epa
     /* WHERE cacheobjtype = 'Compiled Plan' AND objtype = 'adhoc' */
                        ) AS ecpa PIVOT ( MAX(ecpa.value) FOR ecpa.attribute IN ( "dbid" , "sql_handle" ) ) AS pvt
                 ) b
            ON a.plan_handle = b.plan_handle
      INNER JOIN sys.databases dbs
            ON dbid = dbs.database_id;


/******************* #2 **********************/
WITH  DB_CPU_Stats
        AS (
             SELECT
                  DatabaseID
                , DB_NAME(DatabaseID) AS [DatabaseName]
                , SUM(total_worker_time) AS [CPU_Time_Ms]
             FROM
                  sys.dm_exec_query_stats AS qs
                  CROSS APPLY (
                                SELECT
                                    CONVERT(INT , value) AS [DatabaseID]
                                FROM
                                    sys.dm_exec_plan_attributes(qs.plan_handle)
                                WHERE
                                    attribute = N'dbid'
                              ) AS F_DB
             GROUP BY
                  DatabaseID
           )
      SELECT 'CPU USAGE PER DATABASE per plan' as 'What',
            ROW_NUMBER() OVER ( ORDER BY [CPU_Time_Ms] DESC ) AS [row_num]
          , DatabaseName
          , [CPU_Time_Ms]
          , CAST([CPU_Time_Ms] * 1.0 / SUM([CPU_Time_Ms]) OVER ( ) * 100.0 AS DECIMAL(5 , 2)) AS [CPUPercent]
      FROM
            DB_CPU_Stats
      WHERE
            DatabaseID > 4 -- system databases
            AND DatabaseID <> 32767 -- ResourceDB
ORDER BY
            row_num
OPTION
            ( RECOMPILE );



/******************* #3 **********************/
-- Get CPU Utilization History for last 144 minutes (in one minute intervals)
-- This version works with SQL Server 2008 and SQL Server 2008 R2 only
DECLARE @ts_now BIGINT = (
                           SELECT
                              cpu_ticks / ( cpu_ticks / ms_ticks )
                           FROM
                              sys.dm_os_sys_info
                         ); 

SELECT TOP ( 144 ) 'CPU Utilization History for last 144 minutes'as 'What',
      SQLProcessUtilization AS [SQL Server Process CPU Utilization]
    , SystemIdle AS [System Idle Process]
    , 100 - SystemIdle - SQLProcessUtilization AS [Other Process CPU Utilization]
    , DATEADD(ms , -1 * ( @ts_now - [timestamp] ) , GETDATE()) AS [Event Time]
FROM
      (
        SELECT
            record.value('(./Record/@id)[1]' , 'int') AS record_id
          , record.value('(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]' , 'int') AS [SystemIdle]
          , record.value('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]' , 'int') AS [SQLProcessUtilization]
          , [timestamp]
        FROM
            (
              SELECT
                  [timestamp]
                , CONVERT(XML , record) AS [record]
              FROM
                  sys.dm_os_ring_buffers
              WHERE
                  ring_buffer_type = N'RING_BUFFER_SCHEDULER_MONITOR'
                  AND record LIKE N'%<SystemHealth>%'
            ) AS x
      ) AS y
ORDER BY
      record_id DESC
OPTION
      ( RECOMPILE );
go

/*	Last xx minutes of CPU usage from System Health trace	*/
DECLARE @ts_now BIGINT = ( SELECT   cpu_ticks / ( cpu_ticks / ms_ticks )
                           FROM     [sys].[dm_os_sys_info]
                         );

SELECT TOP ( 240 ) /* Set the number of minutes history that you want here	*/
        @@servername AS [Servername] ,
        DATEADD(ms, -1 * ( @ts_now - [timestamp] ), GETDATE()) AS [Sample Time] ,
        SQLProcessUtilisation
INTO    #Data
FROM    ( SELECT    [R].[sample].[value]('(./Record/@id)[1]', 'int') AS [record_id] ,
                    [R].[sample].[value]('(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]',
                                 'int') AS [SystemIdle] ,
                    [R].[sample].[value]('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]',
                                 'int') AS [SQLProcessUtilisation] ,
                    [timestamp]
          FROM      ( SELECT    [timestamp] ,
                                CONVERT(XML, record) AS [sample]
                      FROM      [sys].[dm_os_ring_buffers] AS DORB
                      WHERE     [ring_buffer_type] = N'RING_BUFFER_SCHEDULER_MONITOR'
                                AND [record] LIKE N'%<SystemHealth>%'
                    ) AS [R]
        ) AS y
ORDER BY [record_id] DESC;

WITH    datas
          AS ( SELECT   ROW_NUMBER() OVER ( ORDER BY [Sample Time] ) AS r_n ,
                        [SQLProcessUtilisation]
               FROM     [#Data] AS D
             )
    SELECT  10 AS [Last n minutes range] ,
            AVG([SQLProcessUtilisation]) AS [Avg SQL CPU] ,
            MIN([SQLProcessUtilisation]) AS [Min SQL CPU] ,
            MAX([SQLProcessUtilisation]) AS [Max SQL CPU]
    FROM    [datas]
    WHERE   [r_n] < 11
    UNION
    SELECT  30 ,
            AVG([SQLProcessUtilisation]) ,
            MIN([SQLProcessUtilisation]) ,
            MAX([SQLProcessUtilisation])
    FROM    [datas]
    WHERE   [r_n] < 31
    UNION
    SELECT  60 ,
            AVG([SQLProcessUtilisation]) ,
            MIN([SQLProcessUtilisation]) ,
            MAX([SQLProcessUtilisation])
    FROM    [datas]
    WHERE   [r_n] < 61
    UNION
    SELECT  120 ,
            AVG([SQLProcessUtilisation]) ,
            MIN([SQLProcessUtilisation]) ,
            MAX([SQLProcessUtilisation])
    FROM    [datas]
    WHERE   [r_n] < 121
    UNION
    SELECT  240 ,
            AVG([SQLProcessUtilisation]) ,
            MIN([SQLProcessUtilisation]) ,
            MAX([SQLProcessUtilisation])
    FROM    [datas];

DROP TABLE [#Data];


create table #dbcclogspace([Database Name] nvarchar(200),[Log Size (MB)] float,[Log Space Used (%)] float,[Status] int)
 insert into #dbcclogspace([Database Name],[Log Size (MB)],[Log Space Used (%)],[Status])
 exec('DBCC sqlperf(logspace)')
 select 'Deve ser até 20% do tamanho do database.',[Database Name],(size * 8) / 1024 as 'SizeMB', 
 ([Log Space Used (%)]*[Log Size (MB)])/100 as [LogBackupSize in MB],(([Log Space Used (%)]*[Log Size (MB)])/100)/1024 as [LogBackupSize in GB] 
 from #dbcclogspace a
 join sys.master_files b on ltrim(rtrim(a.[Database Name])) = rtrim(ltrim(db_name(database_id)))
where type_desc <> 'LOG'
 drop table #dbcclogspace
 go

CREATE TABLE #temp1
   (
       
	   [ErrorLogDate] DATETIME,
	   [ProcessInfo] VARCHAR(50),
       [Text] NVARCHAR(4000),
   );
   
Insert into #temp1 ( ErrorLogDate , processinfo , [text] ) 
EXEC sp_readerrorlog 0,1
Insert into #temp1 ( ErrorLogDate , processinfo , [text] ) 
EXEC sp_readerrorlog 1,1
select * from #temp1 where [text] like '%erro%' or [text] like '%invalid%' or [text] like '%failed%' or [text] like '%reason%' or [text] like '%problem%' or 
[text] like '%timeout%' or [text] like '%dead%'
drop table #temp1
go
SELECT 	'Find the most executed stored procedure(s)', DB_NAME(SQTX.DBID) AS [DBNAME] , 
         OBJECT_SCHEMA_NAME(SQTX.OBJECTID,DBID) 
AS [SCHEMA], OBJECT_NAME(SQTX.OBJECTID,DBID) 
AS [STORED PROC]  , MAX(CPLAN.USECOUNTS)  [EXEC COUNT]     
FROM	 SYS.DM_EXEC_CACHED_PLANS CPLAN  
		 CROSS APPLY SYS.DM_EXEC_SQL_TEXT(CPLAN.PLAN_HANDLE) SQTX  
WHERE	 DB_NAME(SQTX.DBID) IS NOT NULL AND CPLAN.OBJTYPE = 'PROC' 
GROUP BY CPLAN.PLAN_HANDLE ,DB_NAME(SQTX.DBID) ,OBJECT_SCHEMA_NAME(OBJECTID,SQTX.DBID)  ,OBJECT_NAME(OBJECTID,SQTX.DBID)  
ORDER BY MAX(CPLAN.USECOUNTS) DESC 

SELECT 'Worst Procs' as 'What' , DB_NAME(SQTX.DBID) AS [DBNAME]
	,OBJECT_SCHEMA_NAME(SQTX.OBJECTID, DBID) AS [SCHEMA]
	,OBJECT_NAME(SQTX.OBJECTID, DBID) AS [STORED PROC]
	,MAX(CPLAN.USECOUNTS) [EXEC COUNT]
FROM SYS.DM_EXEC_CACHED_PLANS CPLAN
CROSS APPLY SYS.DM_EXEC_SQL_TEXT(CPLAN.PLAN_HANDLE) SQTX
WHERE DB_NAME(SQTX.DBID) IS NOT NULL
	AND CPLAN.OBJTYPE = 'PROC'
GROUP BY CPLAN.PLAN_HANDLE
	,DB_NAME(SQTX.DBID)
	,OBJECT_SCHEMA_NAME(OBJECTID, SQTX.DBID)
	,OBJECT_NAME(OBJECTID, SQTX.DBID)
ORDER BY MAX(CPLAN.USECOUNTS) DESC
go


/*------------------------------------------------------------------------------+ 

#| = : = : = : = : = : = : = : = : = : = : = : = : = : = : = : = : = : = : = : | 

#|{>/------------------------------------------------------------------------\<}| 

#|: | Script Name:FindTopCPUQueries| 

#|: | Author :Patrick Akhamie| 

#|: | Description:This script return top queries taxing sql server CPU's|

#|: | |

#|: | SQL Version:SQL 2012, SQL 2008 R2, SQL 2008|

#|: | Copyright :Free to use and share /^(o.o)^\|

#|: | |

#|: | Create Date:01-15-2012 Version: 1.0 |

#|: | Revision :01-19-2012 Version: 1.1 updated with standard variables |

#|:| History02-21-2012 Version: 1.2 updated with query_hash logic|

#|{>\------------------------------------------------------------------------/<}| 

#| = : = : = : = : = : = : = : = : = : = : = : = : = : = : = : = : = : = : = :| 

# Detect worst performing sql queries which is slowing down Microsoft SQL Server, this script return top queries taxing sql server CPUs. |

# Applicable to SQL Server 2008 or above. |

#+-----------------------------------------------------------------------------*/ 



use tempdb

go

IF object_id('tempdb..##FindTopCPUQueries_set1') is not null DROP TABLE [dbo].[##FindTopCPUQueries_set1]

GO

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



select 'Top CPU QUERIES' as 'What', * from ##FindTopCPUQueries_set2
--where QueryExecuted like 'select TOP 300%'
order by AvgCPUTime desc
go 
use master
go


select '[' + db_name(m.database_id) + ']' as DBName,
m.name as [FileName],m.physical_name,m.type_desc,
cast(m.size/128.0 as decimal(38,2)) as SizeInMB,
m.size/128.0 - cast(FILEPROPERTY(m.name,'Spaceused')as int)/128.0 as FreeSpaceInMB,
case m.is_percent_growth
	when 1 then cast(m.growth as varchar) + '%'
	else cast(cast(m.growth/128.0 as decimal(38,2))as varchar) + ' MB'
end as GrowthRate,
case
	when m.max_size = -1 then 'Unrestricted'
	else cast(cast(m.max_size/128.0 as decimal(38,2)) as varchar(256))
end as max_size
from sys.master_files m
inner join sys.databases db on
m.database_id = db.database_id
where db.state_desc = 'ONLINE'
go

SELECT 'CPU COUNT' as 'What',cpu_count AS Logical_CPU_Count , cpu_count / hyperthread_ratio AS Physical_CPU_Count FROM sys.dm_os_sys_info ;
go

SET  QUOTED_IDENTIFIER ON
WITH XMLNAMESPACES   (DEFAULT 'http://schemas.microsoft.com/sqlserver/2004/07/showplan') 
SELECT top 10 'Biggests Single Plans in cache' as 'What',   
 query_plan AS CompleteQueryPlan
,t.text
,n.value('(@StatementOptmLevel)[1]', 'VARCHAR(25)') AS StatementOptimizationLevel
,ecp.usecounts,      ecp.size_in_bytes ,ecp.objtype
FROM sys.dm_exec_cached_plans AS ecp 
CROSS APPLY sys.dm_exec_query_plan(ecp.plan_handle) AS eqp 
CROSS APPLY query_plan.nodes('/ShowPlanXML/BatchSequence/Batch/Statements/StmtSimple') AS qn(n) 
cross apply sys.dm_exec_sql_text (ecp.plan_handle) AS t
WHERE  objtype = 'Adhoc' and cacheobjtype = 'Compiled Plan'
and usecounts = 1 
and n.value('(@StatementOptmLevel)[1]', 'VARCHAR(25)') is not null 
and text not like '%sys.dm%'
order by 6 desc

go
Use msdb 
go
SELECT 'Jobs Exec times' as 'What', name, 
   step_id 
  ,run_date 
  ,count(*) howMany
  ,min((run_duration/10000*3600 + (run_duration/100)%100*60 + run_duration%100 + 31 ) / 60) lowest_Min 
  ,avg((run_duration/10000*3600 + (run_duration/100)%100*60 + run_duration%100 + 31 ) / 60) average_Min 
  ,max((run_duration/10000*3600 + (run_duration/100)%100*60 + run_duration%100 + 31 ) / 60) highest_Min 
  ,stdev((run_duration/10000*3600 + (run_duration/100)%100*60 + run_duration%100 + 31 ) / 60) stdev_Min 
 from sysJobHistory h 
inner join sysjobs j  on 
(h.job_id = j.job_id) 
where name =''
group by name, step_id, run_date 
order by run_date desc
go
use master
go
