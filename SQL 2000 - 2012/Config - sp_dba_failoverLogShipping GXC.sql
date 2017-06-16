--sp_dba_job

use msdb
go

create proc sp_dba_failoverLogShipping
as

exec sp_start_job  'LSCopy_10.150.3.11\DBPRODGXC001_CommonDb'
exec sp_start_job  'LSCopy_10.150.3.11\DBPRODGXC001_FidelidadeDb'
exec sp_start_job  'LSCopy_10.150.3.11\DBPRODGXC001_TicketDb'
exec sp_start_job  'LSCopy_PSDB001\DBPRODGXC001_ClienteDb'
exec sp_start_job  'LSRestore_10.150.3.11\DBPRODGXC001_ClienteDb'
exec sp_start_job  'LSRestore_10.150.3.11\DBPRODGXC001_CommonDb'
exec sp_start_job  'LSRestore_10.150.3.11\DBPRODGXC001_FidelidadeDb'
exec sp_start_job  'LSRestore_10.150.3.11\DBPRODGXC001_TicketDb'

restore database ClienteDb with RECOVERY
restore database Commondb with RECOVERY
restore database FidelidadeDb with RECOVERY
restore database TicketDb with RECOVERY

exec ClienteDb..sp_dba_OrphanUser
exec Commondb..sp_dba_OrphanUser
exec FidelidadeDb..sp_dba_OrphanUser
exec TicketDb..sp_dba_OrphanUser


exec sp_update_job @job_name =   'LSCopy_10.150.3.11\DBPRODGXC001_CommonDb',  @enabled = 0
exec sp_update_job @job_name =   'LSCopy_10.150.3.11\DBPRODGXC001_FidelidadeDb',  @enabled = 0
exec sp_update_job @job_name =   'LSCopy_10.150.3.11\DBPRODGXC001_TicketDb',  @enabled = 0
exec sp_update_job @job_name =   'LSCopy_PSDB001\DBPRODGXC001_ClienteDb',  @enabled = 0
exec sp_update_job @job_name =   'LSRestore_10.150.3.11\DBPRODGXC001_ClienteDb',  @enabled = 0
exec sp_update_job @job_name =   'LSRestore_10.150.3.11\DBPRODGXC001_CommonDb',  @enabled = 0
exec sp_update_job @job_name =   'LSRestore_10.150.3.11\DBPRODGXC001_FidelidadeDb',  @enabled = 0
exec sp_update_job @job_name =   'LSRestore_10.150.3.11\DBPRODGXC001_TicketDb',  @enabled = 0
go
use master
go
create proc sp_dba_failoverLogShipping
as
exec msdb..sp_dba_failoverLogShipping
