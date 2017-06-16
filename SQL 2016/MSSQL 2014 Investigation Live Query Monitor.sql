-- Scripts Criados e adaptados e "organizados" por Rodrigo Souza 
-- rodrigossz@outlook.com
-- rodrigossz@gmail.com

select 'Executar no master durante a execuçao dos jobs'
go

		SELECT
			S.[host_name], 
			DB_NAME(R.database_id) as [database_name],
			(CASE WHEN S.program_name like 'SQLAgent - TSQL JobStep (Job %' THEN  j.name ELSE S.program_name END) as Name , 
			S.login_name, 
			cast(('<?query --'+b.text+'--?>') as XML) as sql_text,
			R.blocking_session_id, 
			R.session_id,
			COALESCE(R.CPU_time, S.CPU_time) AS CPU_ms,
			isnull(DATEDIFF(mi, S.last_request_start_time, getdate()), 0) [MinutesRunning],
			GETDATE()
		FROM sys.dm_exec_requests R with (nolock)
		INNER JOIN sys.dm_exec_sessions S with (nolock)
			ON R.session_id = S.session_id
		OUTER APPLY sys.dm_exec_sql_text(R.sql_handle) b
		OUTER APPLY sys.dm_exec_query_plan (R.plan_handle) AS qp
		LEFT OUTER JOIN msdb.dbo.sysjobs J with (nolock)
			ON (substring(left(j.job_id,8),7,2) +
				substring(left(j.job_id,8),5,2) +
				substring(left(j.job_id,8),3,2) +
				substring(left(j.job_id,8),1,2))  = substring(S.program_name,32,8)
		WHERE R.session_id <> @@SPID
			and S.[host_name] IS NOT NULL
		ORDER BY s.[host_name],S.login_name;
	
	SELECT percent_complete,
            CAST((estimated_completion_time/3600000) as varchar) + ' hour(s), '
                  + CAST((estimated_completion_time %3600000)/60000 as varchar) + 'min, '
                  + CAST((estimated_completion_time %60000)/1000 as varchar) + ' sec' as est_time_to_go,command,
            s.text,
            start_time,           
CAST(((DATEDIFF(s,start_time,GetDate()))/3600) as varchar) + ' hour(s), '
                  + CAST((DATEDIFF(s,start_time,GetDate())%3600)/60 as varchar) + 'min, '
                  + CAST((DATEDIFF(s,start_time,GetDate())%60) as varchar) + ' sec' as running_time,
            dateadd(second,estimated_completion_time/1000, getdate()) as est_completion_time 
FROM sys.dm_exec_requests r
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) s
WHERE r.command in ('RESTORE DATABASE', 'BACKUP DATABASE', 'RESTORE LOG', 'BACKUP LOG')
go

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
WaitTime int, 
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
select spid=r.session_id,command,case 
when login_name is not null and login_name <> '' and login_name not like '% %' then login_name
else nt_user_name end,
host_name,blk=blocking_session_id,r.open_transaction_count,
Result_Count = open_resultset_count, percent_complete,r.last_wait_type,
r.cpu_time,duration_secs=r.total_elapsed_time/1000,r.status,r.logical_reads,r.reads,r.writes,
DB_NAME(r.database_id),program_name, r.wait_time/1000 , substring([text],1,400) ,'TELA',GETDATE()  
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
db_name(dt.database_id), program_name,DATEDIFF(SECOND,dt.database_transaction_begin_time,GETDATE()), 'AWAITING COMMAND','TELA',GETDATE()
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
DB_NAME(dbid),program_name, waittime/1000, 'NOT AVAILABLE','TELA',GETDATE()  
from @sysprocesses s where not exists (select 1 from @result r where s.spid = r.Spid) and
exists (select 1 from @sysprocesses s2 where s2.blocked = s.spid)

select * from @result order by Spid
go

create view cpu_usage as
	 SELECT 
			record.value('(./Record/@id)[1]', 'int') AS record_id,
			record.value('(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]', 'int') AS SystemIdle,
			record.value('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]', 'int') AS SQLProcessUtilization,
			TIMESTAMP
		FROM (
			SELECT TIMESTAMP, CONVERT(XML, record) AS record 
			FROM sys.dm_os_ring_buffers with (nolock)
			WHERE ring_buffer_type = N'RING_BUFFER_SCHEDULER_MONITOR'
			AND record LIKE '% %') as X;
	go		

	
		SELECT
			S.[host_name], 
			DB_NAME(R.database_id) as [database_name],
			(CASE WHEN S.program_name like 'SQLAgent - TSQL JobStep (Job %' THEN  j.name ELSE S.program_name END) as Name , 
			S.login_name, 
			cast(('<?query --'+b.text+'--?>') as XML) as sql_text,
			R.blocking_session_id, 
			R.session_id,
			COALESCE(R.CPU_time, S.CPU_time) AS CPU_ms,
			isnull(DATEDIFF(mi, S.last_request_start_time, getdate()), 0) [MinutesRunning],
			GETDATE()
		FROM sys.dm_exec_requests R with (nolock)
		INNER JOIN sys.dm_exec_sessions S with (nolock)
			ON R.session_id = S.session_id
		OUTER APPLY sys.dm_exec_sql_text(R.sql_handle) b
		OUTER APPLY sys.dm_exec_query_plan (R.plan_handle) AS qp
		LEFT OUTER JOIN msdb.dbo.sysjobs J with (nolock)
			ON (substring(left(j.job_id,8),7,2) +
				substring(left(j.job_id,8),5,2) +
				substring(left(j.job_id,8),3,2) +
				substring(left(j.job_id,8),1,2))  = substring(S.program_name,32,8)
		WHERE R.session_id <> @@SPID
			and S.[host_name] IS NOT NULL
		ORDER BY s.[host_name],S.login_name;
drop view cpu_usage
go
