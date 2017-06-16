alter proc [dbo].[sp_dba_proc3]
as
set nocount on



SELECT  spid=r.session_id,command,login_name,host_name,blk=blocking_session_id,percent_complete,
r.cpu_time,duration_secs=r.total_elapsed_time/1000,r.status,r.logical_reads,r.reads,r.writes,
DB_NAME(database_id) AS [Database], r.wait_time ,[text] AS [LAST_Query]  
FROM sys.dm_exec_requests r  
CROSS APPLY sys.dm_exec_sql_text(r.plan_handle) st  
join sys.dm_exec_sessions p on r.session_id = p.session_id 
WHERE r.session_Id > 50   
union 
SELECT  spid=p.session_id,program_name,login_name,host_name,
blk=0,0,cpu_time,duration_secs=total_elapsed_time/1000,status,logical_reads,reads,writes,
null AS [Database], cpu_time ,null AS [LAST_Query]  
FROM sys.dm_exec_sessions p
WHERE 
exists (select 1 from sys.dm_exec_requests r2 where r2.blocking_session_id = p.session_id) 
order by 1


