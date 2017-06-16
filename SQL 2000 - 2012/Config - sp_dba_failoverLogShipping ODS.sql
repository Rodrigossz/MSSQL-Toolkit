--sp_dba_job

use msdb
go

create proc sp_dba_failoverLogShipping
as

exec sp_start_job  'LSCopy_10.150.3.11\DBPRODODS001_PSafeDb'
exec sp_start_job  'LSRestore_10.150.3.11\DBPRODODS001_PSafeDb'

restore database PsafeDb with RECOVERY

exec PsafeDb..sp_dba_OrphanUser

exec sp_update_job @job_name =   'LSRestore_10.150.3.11\DBPRODODS001_PSafeDb',  @enabled = 0
exec sp_update_job @job_name =   'LSCopy_10.150.3.11\DBPRODODS001_PSafeDb',  @enabled = 0
exec sp_update_job @job_name =   'LSAlert_PSDB002\DBPRODODS002',  @enabled = 0
go
use master
go
create proc sp_dba_failoverLogShipping
as
exec msdb..sp_dba_failoverLogShipping
