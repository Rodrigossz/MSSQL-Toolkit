use master
go
create proc sp_dba_lock4
as
set nocount on

declare @ExecRequests table (
id int IDENTITY(1,1) PRIMARY KEY
,session_id smallint not null
,request_id int
,start_time datetime
,status nvarchar(60)
,command nvarchar(32)
,sql_handle varbinary(64)
,statement_start_offset int
,statement_end_offset int
,plan_handle varbinary (64)
,database_id smallint
,user_id int
,blocking_session_id smallint
,wait_type nvarchar (120)
,wait_time int
,cpu_time int
,tot_time int
,reads bigint
,writes bigint
,logical_reads bigint
,[host_name] nvarchar(256)
,[program_name] nvarchar(256)
,blocking_these varchar(1000) null
)

insert into @ExecRequests (session_id,request_id, start_time,status,command,sql_handle,statement_start_offset,statement_end_offset,plan_handle,database_id,user_id,blocking_session_id,wait_type,wait_time,cpu_time,tot_time,reads,writes,logical_reads,host_name, program_name)
select r.session_id,request_id, start_time,r.status,command,sql_handle,statement_start_offset,statement_end_offset,plan_handle,r.database_id,user_id,blocking_session_id,wait_type,wait_time,r.cpu_time,r.total_elapsed_time,r.reads,r.writes,r.logical_reads,s.host_name, s.program_name
from sys.dm_exec_requests r
left outer join sys.dm_exec_sessions s on r.session_id = s.session_id
where 1=1
and r.session_id > 35 --retrieve only user spids
and r.session_id <> @@SPID --ignore myself

update @ExecRequests set blocking_these = (select isnull(convert(varchar(5), er.session_id),'') + ', '
from @ExecRequests er
where er.blocking_session_id = isnull(er.session_id ,0)
and er.blocking_session_id <> 0
FOR XML PATH('')
)

select
r.session_id, r.host_name, r.program_name, r.status
, r.blocking_these
, 'LEN(Blocking)' = LEN(r.blocking_these)
, blocked_by = r.blocking_session_id
, r.tot_time
, DBName = db_name(r.database_id), r.command, r.wait_type, r.tot_time, r.wait_time, r.cpu_time, r.reads, r.writes, r.logical_reads
, [text] = est.[text]
, offsettext = CASE WHEN r.statement_start_offset = 0 and r.statement_end_offset= 0 THEN null
ELSE
SUBSTRING (est.[text], r.statement_start_offset/2 + 1,
CASE WHEN r.statement_end_offset = -1 THEN LEN (CONVERT(nvarchar(max), est.[text]))
ELSE r.statement_end_offset/2 - r.statement_start_offset/2 + 1
END)
END
, r.statement_start_offset, r.statement_end_offset
from @ExecRequests r
outer apply sys.dm_exec_sql_text (r.sql_handle) est
order by LEN(r.blocking_these) desc, r.session_id asc
go
--drop table #ExecRequests
