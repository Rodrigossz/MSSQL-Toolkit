
create PROCEDURE [dbo].[sp_dba_indexUsage]
   @table_name NVARCHAR(520) = NULL
AS
BEGIN
   SET NOCOUNT ON;
   SELECT
       table_name = QUOTENAME(OBJECT_SCHEMA_NAME(i.object_id))
         + '.' + QUOTENAME(OBJECT_NAME(i.object_id)),
       index_name = QUOTENAME(i.name),
       s.user_seeks,       s.user_scans,       s.user_lookups,       s.user_updates,
       s.last_user_seek,       s.last_user_scan,       s.last_user_lookup,       s.last_user_update
   FROM
       sys.indexes  i    left JOIN
       sys.dm_db_index_usage_stats  s  ON i.[object_id] = s.[object_id]  AND i.[index_id] = s.[index_id]
   WHERE
       s.database_id = DB_ID()
       AND i.object_id = COALESCE(OBJECT_ID(@table_name), i.object_id)
       
union
SELECT
table_name = QUOTENAME(OBJECT_SCHEMA_NAME(i.object_id))
 + '.' + QUOTENAME(OBJECT_NAME(i.object_id)),
index_name = QUOTENAME(i.name),
s.user_seeks,       s.user_scans,       s.user_lookups,       s.user_updates,
s.last_user_seek,       s.last_user_scan,       s.last_user_lookup,       s.last_user_update
from sys.objects o 
inner join sys.indexes i ON i.[object_id] = o.[object_id] 
left join sys.dm_db_index_usage_stats s on i.index_id = s.index_id and s.object_id = i.object_id
where object_name (o.object_id) is not null
and object_name (s.object_id) is null
AND o.[type] = 'U' and isnull( i.name,'HEAP') <>'HEAP'       

   ORDER BY
       table_name,
       index_name;
END

GO

exec sys.sp_MS_marksystemobject 'sp_dba_indexUsage';
