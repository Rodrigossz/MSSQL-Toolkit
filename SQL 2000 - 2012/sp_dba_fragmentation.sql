alter proc sp_dba_fragmentation
as
set nocount on
SELECT top 20 a.index_id, b.name, object_name(a.object_id),avg_fragmentation_in_percent,rowcnt
FROM sys.dm_db_index_physical_stats (DB_ID(), null,
     NULL, NULL, NULL) AS a
    JOIN sys.indexes AS b ON a.object_id = b.object_id AND a.index_id = b.index_id
   join sysindexes si on si.id = b.object_id AND si.indid = b.index_id
    order by 4 desc
