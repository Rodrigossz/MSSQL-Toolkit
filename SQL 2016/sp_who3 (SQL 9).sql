use master
if exists(select * from master.sys.objects where name = 'sp_blocked')
drop procedure sp_blocked
go
create procedure dbo.sp_blocked
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
go
print 'sp_blocked created.'

USE master
print 'Creating sp_who3'

if exists (select * from sys.objects where name = 'sp_who3')
drop procedure [dbo].[sp_who3]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE procedure sp_who3
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