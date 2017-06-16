use master
go
create proc sp_dba_index2
as
begin
set nocount on

select 'Missing indexes'
select d.name AS DatabaseName, mid.* 
from sys.dm_db_missing_index_details mid  
join sys.databases d ON mid.database_id=d.database_id


select 'Unused indexes'
SELECT d.name, t.name, i.name, ius.* FROM sys.dm_db_index_usage_stats ius 
JOIN sys.databases d ON d.database_id = ius.database_id JOIN sys.tables t ON t.object_id = ius.object_id 
JOIN sys.indexes i ON i.object_id = ius.object_id AND i.index_id = ius.index_id 
ORDER BY user_updates DESC
end
go
EXEC sp_ms_marksystemobject 'sp_dba_index2'  
go