use master
go
create proc sp_dba_OS_Info
as
set nocount on
SELECT * FROM sys.dm_os_sys_info
