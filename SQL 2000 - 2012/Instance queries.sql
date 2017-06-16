
-- SQL Server 2008 and R2 Instance Level Queries
-- Glenn Berry 
-- September 2011
-- http://sqlserverperformance.wordpress.com/
-- Twitter: GlennAlanBerry

-- Instance level queries *******************************

-- SQL and OS Version information for current instance
SELECT @@VERSION AS [SQL Server and OS Version Info];

-- SQL Server 2008 RTM is considered an "unsupported service pack" as of April 13, 2010
-- SQL Server 2008 RTM Builds   SQL Server 2008 SP1 Builds     SQL Server 2008 SP2 Builds
-- Build       Description      Build       Description		 Build     Description
-- 1600        Gold RTM
-- 1763        RTM CU1
-- 1779        RTM CU2
-- 1787        RTM CU3    -->	2531		SP1 RTM
-- 1798        RTM CU4    -->	2710        SP1 CU1
-- 1806        RTM CU5    -->	2714        SP1 CU2 
-- 1812		   RTM CU6    -->	2723        SP1 CU3
-- 1818        RTM CU7    -->	2734        SP1 CU4
-- 1823        RTM CU8    -->	2746		SP1 CU5
-- 1828		   RTM CU9    -->	2757		SP1 CU6
-- 1835		   RTM CU10   -->	2766		SP1 CU7
-- RTM Branch Retired     -->	2775		SP1 CU8		-->  4000	   SP2 RTM
--								2789		SP1 CU9
--								2799		SP1 CU10	
--								2804		SP1 CU11	-->  4266      SP2 CU1		
--								2808		SP1 CU12	-->  4272	   SP2 CU2	
--								2816	    SP1 CU13    -->  4279      SP2 CU3	
--								2821		SP1 CU14	-->  4285	   SP2 CU4	
--								2847		SP1 CU15	-->  4316	   SP2 CU5
--								2850		SP1 CU16	-->	 4321	   SP2 CU6				   

-- SQL Server 2008 R2 Builds				SQL Server 2008 R2 SP1 Builds
-- Build			Description				Build		Description
-- 10.50.1092		August 2009 CTP2		
-- 10.50.1352		November 2009 CTP3
-- 10.50.1450		Release Candidate
-- 10.50.1600		RTM
-- 10.50.1702		RTM CU1
-- 10.50.1720		RTM CU2
-- 10.50.1734		RTM CU3
-- 10.50.1746		RTM CU4
-- 10.50.1753		RTM CU5
-- 10.50.1765		RTM CU6	 --->			10.50.2500	SP1 RTM
-- 10.50.1777		RTM CU7
-- 10.50.1797		RTM CU8	 --->			10.50.2769  SP1 CU1
-- 10.50.1804       RTM CU9  --->			10.50.2772  SP1 CU2


-- When was SQL Server installed   
SELECT createdate AS [SQL Server Install Date] 
FROM sys.syslogins WITH (NOLOCK)
WHERE [sid] = 0x010100000000000512000000;


-- Hardware information from SQL Server 2008 
-- (Cannot distinguish between HT and multi-core)
SELECT cpu_count AS [Logical CPU Count], hyperthread_ratio AS [Hyperthread Ratio],
cpu_count/hyperthread_ratio AS [Physical CPU Count], 
physical_memory_in_bytes/1048576 AS [Physical Memory (MB)], 
sqlserver_start_time --, affinity_type_desc -- (affinity_type_desc is only in 2008 R2)
FROM sys.dm_os_sys_info WITH (NOLOCK) OPTION (RECOMPILE);


-- Get System Manufacturer and model number from 
-- SQL Server Error log. This query might take a few seconds 
-- if you have not recycled your error log recently
EXEC xp_readerrorlog 0,1,"Manufacturer"; 


-- Get processor description from Windows Registry
EXEC xp_instance_regread 
'HKEY_LOCAL_MACHINE',
'HARDWARE\DESCRIPTION\System\CentralProcessor\0',
'ProcessorNameString';


-- Get configuration values for instance
SELECT name, value, value_in_use, [description] 
FROM sys.configurations WITH (NOLOCK)
ORDER BY name OPTION (RECOMPILE);

-- Focus on
-- backup compression default
-- clr enabled (only enable if it is needed)
-- lightweight pooling (should be zero)
-- max degree of parallelism (depends on your workload)
-- max server memory (MB) (set to an appropriate value)
-- optimize for ad hoc workloads (should be 1)
-- priority boost (should be zero)


-- File Names and Paths for TempDB and all user databases in instance 
SELECT DB_NAME([database_id])AS [Database Name], 
       [file_id], name, physical_name, type_desc, state_desc, 
       CONVERT( bigint, size/128.0) AS [Total Size in MB]
FROM sys.master_files WITH (NOLOCK)
WHERE [database_id] > 4 
AND [database_id] <> 32767
OR [database_id] = 2
ORDER BY DB_NAME([database_id]) OPTION (RECOMPILE);

-- Things to look at:
-- Are data files and log files on different drives?
-- Is everything on the C: drive?
-- Is TempDB on dedicated drives?
-- Are there multiple data files?


-- Recovery model, log reuse wait description, log file size, log usage size 
-- and compatibility level for all databases on instance
SELECT db.[name] AS [Database Name], db.recovery_model_desc AS [Recovery Model], 
db.log_reuse_wait_desc AS [Log Reuse Wait Description], 
ls.cntr_value AS [Log Size (KB)], lu.cntr_value AS [Log Used (KB)],
CAST(CAST(lu.cntr_value AS FLOAT) / CAST(ls.cntr_value AS FLOAT)AS DECIMAL(18,2)) * 100 AS [Log Used %], 
db.[compatibility_level] AS [DB Compatibility Level], 
db.page_verify_option_desc AS [Page Verify Option], db.is_auto_create_stats_on, db.is_auto_update_stats_on,
db.is_auto_update_stats_async_on, db.is_parameterization_forced, 
db.snapshot_isolation_state_desc, db.is_read_committed_snapshot_on
FROM sys.databases AS db WITH (NOLOCK)
INNER JOIN sys.dm_os_performance_counters AS lu WITH (NOLOCK)
ON db.name = lu.instance_name
INNER JOIN sys.dm_os_performance_counters AS ls WITH (NOLOCK)
ON db.name = ls.instance_name
WHERE lu.counter_name LIKE N'Log File(s) Used Size (KB)%' 
AND ls.counter_name LIKE N'Log File(s) Size (KB)%'
AND ls.cntr_value > 0 OPTION (RECOMPILE);

-- Things to look at:
-- How many databases are on the instance?
-- What recovery models are they using?
-- What is the log reuse wait description?
-- How full are the transaction logs ?
-- What compatibility level are they on?


-- Analyze total IO by database and file type, ranked by IO stall %
WITH DatabaseIOStats AS
(SELECT DB_NAME(ivfs.database_id) AS [DatabaseName], ivfs.database_id,
	CASE WHEN mf.[type] = 1 THEN 'Log' ELSE 'Data' END AS [file_type],
	SUM(ivfs.num_of_bytes_read + ivfs.num_of_bytes_written) AS [io_bytes],
	SUM(ivfs.io_stall) AS io_stall
  FROM sys.dm_io_virtual_file_stats(NULL, NULL) AS ivfs
  INNER JOIN sys.master_files AS mf WITH (NOLOCK)
  ON ivfs.database_id = mf.database_id
  AND ivfs.[file_id] = mf.[file_id]
  GROUP BY DB_NAME(ivfs.database_id), ivfs.database_id, mf.[type])

SELECT DatabaseName, database_id, file_type, 
  CAST(1. * io_bytes / (1024 * 1024) AS DECIMAL(12, 2)) AS [Total IO (MB)],
  CAST(io_stall / 1000. AS DECIMAL(12, 2)) AS [Total IO Stall (Sec)],
  CAST(100. * io_stall / SUM(io_stall) OVER() AS DECIMAL(10, 2)) AS [IO Stall %] 
FROM DatabaseIOStats
WHERE database_id > 4
OR database_id = 2
ORDER BY io_stall DESC OPTION (RECOMPILE);

-- Helps determine which databases and file types have the most percentage of IO stalls


-- Show cumulative I/O Stall times for reads and writes by database file
SELECT DB_NAME(database_id) AS [DatabaseName], database_id, [file_id], io_stall_read_ms, io_stall_write_ms
FROM sys.dm_io_virtual_file_stats(NULL, NULL)
WHERE database_id > 4
OR database_id = 2
ORDER BY io_stall_read_ms DESC OPTION (RECOMPILE);


-- Calculates average stalls per read, per write, and per total input/output for each database file. 
SELECT DB_NAME(fs.database_id) AS [Database Name], mf.physical_name, io_stall_read_ms, num_of_reads,
CAST(io_stall_read_ms/(1.0 + num_of_reads) AS NUMERIC(10,1)) AS [avg_read_stall_ms],io_stall_write_ms, 
num_of_writes,CAST(io_stall_write_ms/(1.0+num_of_writes) AS NUMERIC(10,1)) AS [avg_write_stall_ms],
io_stall_read_ms + io_stall_write_ms AS [io_stalls], num_of_reads + num_of_writes AS [total_io],
CAST((io_stall_read_ms + io_stall_write_ms)/(1.0 + num_of_reads + num_of_writes) AS NUMERIC(10,1)) 
AS [avg_io_stall_ms]
FROM sys.dm_io_virtual_file_stats(null,null) AS fs
INNER JOIN sys.master_files AS mf WITH (NOLOCK)
ON fs.database_id = mf.database_id
AND fs.[file_id] = mf.[file_id]
WHERE mf.database_id > 4
OR mf.database_id = 2
ORDER BY avg_io_stall_ms DESC OPTION (RECOMPILE);

-- Helps determine which database files on the entire instance have the most I/O bottlenecks


-- Max wait time for some I/O related wait types
SELECT wait_type, max_wait_time_ms, waiting_tasks_count, wait_time_ms, 
       signal_wait_time_ms, wait_time_ms - signal_wait_time_ms AS [io_wait_time_ms]
FROM sys.dm_os_wait_stats WITH (NOLOCK)
WHERE wait_type = N'WRITELOG' 
OR wait_type LIKE N'PAGEIOLATCH%'
ORDER BY max_wait_time_ms DESC OPTION (RECOMPILE);

-- I/O wait time by I/O related wait type
SELECT wait_type, wait_time_ms - signal_wait_time_ms AS [io_wait_time_ms], 
       waiting_tasks_count, wait_time_ms, signal_wait_time_ms, max_wait_time_ms
FROM sys.dm_os_wait_stats WITH (NOLOCK)
WHERE wait_type = N'WRITELOG' 
OR wait_type LIKE N'PAGEIOLATCH%'
ORDER BY io_wait_time_ms DESC OPTION (RECOMPILE);


-- Get CPU utilization by database (adapted from Robert Pearl)
WITH DB_CPU_Stats
AS
(SELECT DatabaseID, DB_Name(DatabaseID) AS [DatabaseName], SUM(total_worker_time) AS [CPU_Time_Ms]
 FROM sys.dm_exec_query_stats AS qs WITH (NOLOCK)
 CROSS APPLY (SELECT CONVERT(int, value) AS [DatabaseID] 
              FROM sys.dm_exec_plan_attributes(qs.plan_handle)
              WHERE attribute = N'dbid') AS F_DB
 GROUP BY DatabaseID)
SELECT ROW_NUMBER() OVER(ORDER BY [CPU_Time_Ms] DESC) AS [row_num],
       DatabaseName, [CPU_Time_Ms], 
       CAST([CPU_Time_Ms] * 1.0 / SUM([CPU_Time_Ms]) OVER() * 100.0 AS DECIMAL(5, 2)) AS [CPUPercent]
FROM DB_CPU_Stats
WHERE DatabaseID > 4 -- system databases
AND DatabaseID <> 32767 -- ResourceDB
ORDER BY row_num OPTION (RECOMPILE);

-- Helps determine which database is using the most CPU resources on the instance
-- These statistics are drawn from what is in the procedure cache, so they will be affected by
-- if and when you have flushed the cache for a particular database


-- Get total buffer usage by database for current instance
SELECT DB_NAME(database_id) AS [Database Name],
COUNT(*) * 8/1024.0 AS [Cached Size (MB)]
FROM sys.dm_os_buffer_descriptors WITH (NOLOCK)
WHERE database_id > 4 -- system databases
AND database_id <> 32767 -- ResourceDB
GROUP BY DB_NAME(database_id)
ORDER BY [Cached Size (MB)] DESC OPTION (RECOMPILE);

-- Tells you how much memory (in the buffer pool) is being used by each database on the instance



-- Clear Wait Stats 
-- DBCC SQLPERF('sys.dm_os_wait_stats', CLEAR);

-- Isolate top waits for server instance since last restart or statistics clear
WITH Waits AS
(SELECT wait_type, wait_time_ms / 1000. AS wait_time_s,
100. * wait_time_ms / SUM(wait_time_ms) OVER() AS pct,
ROW_NUMBER() OVER(ORDER BY wait_time_ms DESC) AS rn
FROM sys.dm_os_wait_stats WITH (NOLOCK)
WHERE wait_type NOT IN ('CLR_SEMAPHORE','LAZYWRITER_SLEEP','RESOURCE_QUEUE','SLEEP_TASK',
'SLEEP_SYSTEMTASK','SQLTRACE_BUFFER_FLUSH','WAITFOR', 'LOGMGR_QUEUE','CHECKPOINT_QUEUE',
'REQUEST_FOR_DEADLOCK_SEARCH','XE_TIMER_EVENT','BROKER_TO_FLUSH','BROKER_TASK_STOP','CLR_MANUAL_EVENT',
'CLR_AUTO_EVENT','DISPATCHER_QUEUE_SEMAPHORE', 'FT_IFTS_SCHEDULER_IDLE_WAIT',
'XE_DISPATCHER_WAIT', 'XE_DISPATCHER_JOIN', 'SQLTRACE_INCREMENTAL_FLUSH_SLEEP',
'ONDEMAND_TASK_QUEUE', 'BROKER_EVENTHANDLER', 'SLEEP_BPOOL_FLUSH'))
SELECT W1.wait_type, 
CAST(W1.wait_time_s AS DECIMAL(12, 2)) AS wait_time_s,
CAST(W1.pct AS DECIMAL(12, 2)) AS pct,
CAST(SUM(W2.pct) AS DECIMAL(12, 2)) AS running_pct
FROM Waits AS W1
INNER JOIN Waits AS W2
ON W2.rn <= W1.rn
GROUP BY W1.rn, W1.wait_type, W1.wait_time_s, W1.pct
HAVING SUM(W2.pct) - W1.pct < 99 OPTION (RECOMPILE); -- percentage threshold

-- This gives you an idea of the most significant wait type for the instance since
-- SQL Server was started or the last time the wait stats were cleared  by
-- running the DBCC SQLPERF('sys.dm_os_wait_stats', CLEAR);  command
-- If your server is running well, you should not "fixate" as much on the top wait type...

-- Common Significant Wait types with BOL explanations

-- *** Network Related Waits ***
-- ASYNC_NETWORK_IO		Occurs on network writes when the task is blocked behind the network

-- *** Locking Waits ***
-- LCK_M_IX				Occurs when a task is waiting to acquire an Intent Exclusive (IX) lock
-- LCK_M_IU				Occurs when a task is waiting to acquire an Intent Update (IU) lock
-- LCK_M_S				Occurs when a task is waiting to acquire a Shared lock

-- *** I/O Related Waits ***
-- ASYNC_IO_COMPLETION  Occurs when a task is waiting for I/Os to finish
-- IO_COMPLETION		Occurs while waiting for I/O operations to complete. 
--                      This wait type generally represents non-data page I/Os. Data page I/O completion waits appear 
--                      as PAGEIOLATCH_* waits
-- PAGEIOLATCH_SH		Occurs when a task is waiting on a latch for a buffer that is in an I/O request. 
--                      The latch request is in Shared mode. Long waits may indicate problems with the disk subsystem.
-- PAGEIOLATCH_EX		Occurs when a task is waiting on a latch for a buffer that is in an I/O request. 
--                      The latch request is in Exclusive mode. Long waits may indicate problems with the disk subsystem.
-- WRITELOG             Occurs while waiting for a log flush to complete. 
--                      Common operations that cause log flushes are checkpoints and transaction commits.
-- PAGELATCH_EX			Occurs when a task is waiting on a latch for a buffer that is not in an I/O request. 
--                      The latch request is in Exclusive mode.
-- BACKUPIO				Occurs when a backup task is waiting for data, or is waiting for a buffer in which to store data

-- *** CPU Related Waits ***
-- SOS_SCHEDULER_YIELD  Occurs when a task voluntarily yields the scheduler for other tasks to execute. 
--                      During this wait the task is waiting for its quantum to be renewed.

-- THREADPOOL			Occurs when a task is waiting for a worker to run on. 
--                      This can indicate that the maximum worker setting is too low, or that batch executions are taking 
--                      unusually long, thus reducing the number of workers available to satisfy other batches.
-- CX_PACKET			Occurs when trying to synchronize the query processor exchange iterator 
--						You may consider lowering the degree of parallelism if contention on this wait type becomes a problem
--						Often caused by missing indexes or poorly written queries


-- Signal Waits (CPU waits) for instance
SELECT CAST(100.0 * SUM(signal_wait_time_ms) / SUM (wait_time_ms) AS NUMERIC(20,2)) 
AS [%signal (cpu) waits],
CAST(100.0 * SUM(wait_time_ms - signal_wait_time_ms) / SUM (wait_time_ms) AS NUMERIC(20,2)) 
AS [%resource waits]
FROM sys.dm_os_wait_stats WITH (NOLOCK) OPTION (RECOMPILE);

-- Signal Waits above 10-15% is usually a sign of CPU pressure


-- Get Average Task Counts (run multiple times, note highest values)
SELECT AVG(current_tasks_count) AS [Avg Task Count], 
AVG(runnable_tasks_count) AS [Avg Runnable Task Count],
AVG(pending_disk_io_count) AS [AvgPendingDiskIOCount]
FROM sys.dm_os_schedulers WITH (NOLOCK)
WHERE scheduler_id < 255 OPTION (RECOMPILE);

-- Sustained values above 10 suggest further investigation in that area

-- Check SQL Server Schedulers to see if they are waiting on CPU or disk
SELECT scheduler_id, current_tasks_count, runnable_tasks_count, pending_disk_io_count, load_factor
FROM sys.dm_os_schedulers WITH (NOLOCK)
WHERE scheduler_id < 255 OPTION (RECOMPILE);

-- Sustained values above 10 suggest further investigation in that area


--  Get logins that are connected and how many sessions they have 
SELECT login_name, COUNT(session_id) AS [session_count] 
FROM sys.dm_exec_sessions WITH (NOLOCK)
GROUP BY login_name
ORDER BY COUNT(session_id) DESC OPTION (RECOMPILE);

-- This helps baseline and characterize your workload


--  Who is running what at this instant (run multiple times)
SELECT st.[text] AS [Command Text], s.login_time, [host_name], 
[program_name], r.session_id, c.client_net_address,
r.[status], r.command, DB_NAME(r.database_id) AS [DatabaseName]
FROM sys.dm_exec_requests AS r WITH (NOLOCK)
INNER JOIN sys.dm_exec_connections AS c WITH (NOLOCK)
ON r.session_id = c.session_id
INNER JOIN sys.dm_exec_sessions AS s WITH (NOLOCK)
ON s.session_id = r.session_id
CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS st
WHERE s.is_user_process = 1
AND r.session_id <> @@SPID OPTION (RECOMPILE);

-- This gives you a quick snapshot of currently running queries and activity
-- This can be helpful for troubleshooting



-- Get CPU Utilization History for last 256 minutes (in one minute intervals)
-- This version works with SQL Server 2008 and SQL Server 2008 R2 only
DECLARE @ts_now bigint = (SELECT cpu_ticks/(cpu_ticks/ms_ticks)FROM sys.dm_os_sys_info); 

SELECT TOP(256) SQLProcessUtilization AS [SQL Server Process CPU Utilization], 
               SystemIdle AS [System Idle Process], 
               100 - SystemIdle - SQLProcessUtilization AS [Other Process CPU Utilization], 
               DATEADD(ms, -1 * (@ts_now - [timestamp]), GETDATE()) AS [Event Time] 
FROM ( 
	  SELECT record.value('(./Record/@id)[1]', 'int') AS record_id, 
			record.value('(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]', 'int') 
			AS [SystemIdle], 
			record.value('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]', 
			'int') 
			AS [SQLProcessUtilization], [timestamp] 
	  FROM ( 
			SELECT [timestamp], CONVERT(xml, record) AS [record] 
			FROM sys.dm_os_ring_buffers WITH (NOLOCK)
			WHERE ring_buffer_type = N'RING_BUFFER_SCHEDULER_MONITOR' 
			AND record LIKE N'%<SystemHealth>%') AS x 
	  ) AS y 
ORDER BY record_id DESC OPTION (RECOMPILE);

-- This gives you some historical trending information for your CPU utilization
-- for SQL Server and other processes on your machine.


-- System Memory Information
SELECT total_physical_memory_kb, available_physical_memory_kb, 
       total_page_file_kb, available_page_file_kb, 
       system_memory_state_desc
FROM sys.dm_os_sys_memory WITH (NOLOCK) OPTION (RECOMPILE);

-- Good basic information about memory amounts and state at the OS level
-- You want to see "Available physical memory is high" (for operating system)


-- SQL Server Process Address space info 
--(shows whether locked pages is enabled, among other things)
SELECT physical_memory_in_use_kb,locked_page_allocations_kb, 
       page_fault_count, memory_utilization_percentage, 
       available_commit_limit_kb, process_physical_memory_low, 
       process_virtual_memory_low
FROM sys.dm_os_process_memory WITH (NOLOCK) OPTION (RECOMPILE);

-- You want to see 0 for process_physical_memory_low
-- You want to see 0 for process_virtual_memory_low


-- Page Life Expectancy (PLE) value for default instance
SELECT cntr_value AS [Page Life Expectancy]
FROM sys.dm_os_performance_counters WITH (NOLOCK)
WHERE [object_name] = N'SQLServer:Buffer Manager' -- Modify this if you have named instances
AND counter_name = N'Page life expectancy' OPTION (RECOMPILE);

-- PLE is one good measurement of memory pressure. Higher PLE is better. 
-- Watch the trend over time, not the absolute value.


-- Memory Grants Pending value for default instance
SELECT cntr_value AS [Memory Grants Pending]                                                                                                      
FROM sys.dm_os_performance_counters WITH (NOLOCK)
WHERE [object_name] = N'SQLServer:Memory Manager' -- Modify this if you have named instances
AND counter_name = N'Memory Grants Pending' OPTION (RECOMPILE);

-- Memory Grants Pending above zero for a sustained period is a pretty strong indicator of memory pressure


-- Memory Clerk Usage for instance
-- Look for high value for CACHESTORE_SQLCP (Ad-hoc query plans)
SELECT TOP(10) [type] AS [Memory Clerk Type], SUM(single_pages_kb) AS [SPA Mem, Kb] 
FROM sys.dm_os_memory_clerks WITH (NOLOCK)
GROUP BY [type]  
ORDER BY SUM(single_pages_kb) DESC OPTION (RECOMPILE);

-- CACHESTORE_SQLCP  SQL Plans         These are cached SQL statements or batches that aren't in 
--                                     stored procedures, functions and triggers
-- CACHESTORE_OBJCP  Object Plans      These are compiled plans for stored procedures, functions and triggers


-- Find single-use, ad-hoc queries that are bloating the plan cache
SELECT TOP(50) [text] AS [QueryText], cp.size_in_bytes
FROM sys.dm_exec_cached_plans AS cp WITH (NOLOCK)
CROSS APPLY sys.dm_exec_sql_text(plan_handle) 
WHERE cp.cacheobjtype = N'Compiled Plan' 
AND cp.objtype = N'Adhoc' 
AND cp.usecounts = 1
ORDER BY cp.size_in_bytes DESC OPTION (RECOMPILE);

-- Gives you the text and size of single-use ad-hoc queries that waste space in the plan cache
-- Enabling 'optimize for ad hoc workloads' for the instance can help (SQL Server 2008 and 2008 R2 only)
-- Enabling forced parameterization for the database can help, but test first!


-- Lists the top statements by average input/output usage for the current instance
SELECT TOP(100) OBJECT_NAME(qt.objectid) AS [SP Name],
(qs.total_logical_reads + qs.total_logical_writes) /qs.execution_count AS [Avg IO],
SUBSTRING(qt.[text],qs.statement_start_offset/2, 
	(CASE 
		WHEN qs.statement_end_offset = -1 
	 THEN LEN(CONVERT(nvarchar(max), qt.[text])) * 2 
		ELSE qs.statement_end_offset 
	 END - qs.statement_start_offset)/2) AS [Query Text]	
FROM sys.dm_exec_query_stats AS qs WITH (NOLOCK)
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS qt
ORDER BY [Avg IO] DESC OPTION (RECOMPILE);

-- Helps you find the most expensive statements for average I/O



-- Missing Indexes in current instance by Index Advantage
SELECT user_seeks * avg_total_user_cost * (avg_user_impact * 0.01) AS [index_advantage], 
migs.last_user_seek, mid.[statement] AS [Database.Schema.Table],
mid.equality_columns, mid.inequality_columns, mid.included_columns,
migs.unique_compiles, migs.user_seeks, migs.avg_total_user_cost, migs.avg_user_impact
FROM sys.dm_db_missing_index_group_stats AS migs WITH (NOLOCK)
INNER JOIN sys.dm_db_missing_index_groups AS mig WITH (NOLOCK)
ON migs.group_handle = mig.index_group_handle
INNER JOIN sys.dm_db_missing_index_details AS mid WITH (NOLOCK)
ON mig.index_handle = mid.index_handle
ORDER BY index_advantage DESC OPTION (RECOMPILE);

-- Look at last user seek time, number of user seeks to help determine source and importance
-- SQL Server is overly eager to add included columns, so beware
-- Do not just blindly add indexes that show up from this query!!!


-- Find missing index warnings for cached plans in the current instance
-- Note: This query could take some time to run on a busy instance
SELECT TOP(100) DB_NAME(qp.dbid) AS [Database Name], 
               query_plan, cp.objtype, cp.usecounts
FROM sys.dm_exec_cached_plans AS cp WITH (NOLOCK)
CROSS APPLY sys.dm_exec_query_plan(cp.plan_handle) AS qp
WHERE CAST(query_plan AS NVARCHAR(MAX)) LIKE N'%MissingIndex%'
ORDER BY cp.usecounts DESC OPTION (RECOMPILE);

-- Helps you connect "missing indexes" to specific stored procedures,
-- Prepared, or ad-hoc query plans
-- This can help you decide whether to add the requested index or not
-- Use in conjunction with the overall missing index query
-- Use your own good judgement rather than just wildly adding indexes!

-- The query_plan XML column does not transfer well to an Excel spreadsheet

