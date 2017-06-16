USE [master]
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_index2]    Script Date: 07/21/2011 16:26:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[sp_dba_index2]
as
begin
set nocount on

select 'duplicated indexes'

;WITH MyDuplicate AS (SELECT 
	Sch.[name] AS SchemaName,
	Obj.[name] AS TableName,
	Idx.[name] AS IndexName,
	INDEX_Col(Sch.[name] + '.' + Obj.[name], Idx.index_id, 1) AS Col1,
	INDEX_Col(Sch.[name] + '.' + Obj.[name], Idx.index_id, 2) AS Col2,
	INDEX_Col(Sch.[name] + '.' + Obj.[name], Idx.index_id, 3) AS Col3,
	INDEX_Col(Sch.[name] + '.' + Obj.[name], Idx.index_id, 4) AS Col4,
	INDEX_Col(Sch.[name] + '.' + Obj.[name], Idx.index_id, 5) AS Col5,
	INDEX_Col(Sch.[name] + '.' + Obj.[name], Idx.index_id, 6) AS Col6,
	INDEX_Col(Sch.[name] + '.' + Obj.[name], Idx.index_id, 7) AS Col7,
	INDEX_Col(Sch.[name] + '.' + Obj.[name], Idx.index_id, 8) AS Col8,
	INDEX_Col(Sch.[name] + '.' + Obj.[name], Idx.index_id, 9) AS Col9,
	INDEX_Col(Sch.[name] + '.' + Obj.[name], Idx.index_id, 10) AS Col10,
	INDEX_Col(Sch.[name] + '.' + Obj.[name], Idx.index_id, 11) AS Col11,
	INDEX_Col(Sch.[name] + '.' + Obj.[name], Idx.index_id, 12) AS Col12,
	INDEX_Col(Sch.[name] + '.' + Obj.[name], Idx.index_id, 13) AS Col13,
	INDEX_Col(Sch.[name] + '.' + Obj.[name], Idx.index_id, 14) AS Col14,
	INDEX_Col(Sch.[name] + '.' + Obj.[name], Idx.index_id, 15) AS Col15,
	INDEX_Col(Sch.[name] + '.' + Obj.[name], Idx.index_id, 16) AS Col16
FROM sys.indexes Idx
INNER JOIN sys.objects Obj ON Idx.[object_id] = Obj.[object_id]
INNER JOIN sys.schemas Sch ON Sch.[schema_id] = Obj.[schema_id]
WHERE index_id > 0)

SELECT	MD1.SchemaName, MD1.TableName, MD1.IndexName, 
		MD2.IndexName AS OverLappingIndex,
		MD1.Col1, MD1.Col2, MD1.Col3, MD1.Col4, 
		MD1.Col5, MD1.Col6, MD1.Col7, MD1.Col8, 
		MD1.Col9, MD1.Col10, MD1.Col11, MD1.Col12, 
		MD1.Col13, MD1.Col14, MD1.Col15, MD1.Col16
FROM MyDuplicate MD1
INNER JOIN MyDuplicate MD2 ON MD1.tablename = MD2.tablename
	AND MD1.indexname <> MD2.indexname
	AND MD1.Col1 = MD2.Col1
	AND (MD1.Col2 IS NULL OR MD2.Col2 IS NULL OR MD1.Col2 = MD2.Col2)
	AND (MD1.Col3 IS NULL OR MD2.Col3 IS NULL OR MD1.Col3 = MD2.Col3)
	AND (MD1.Col4 IS NULL OR MD2.Col4 IS NULL OR MD1.Col4 = MD2.Col4)
	AND (MD1.Col5 IS NULL OR MD2.Col5 IS NULL OR MD1.Col5 = MD2.Col5)
	AND (MD1.Col6 IS NULL OR MD2.Col6 IS NULL OR MD1.Col6 = MD2.Col6)
	AND (MD1.Col7 IS NULL OR MD2.Col7 IS NULL OR MD1.Col7 = MD2.Col7)
	AND (MD1.Col8 IS NULL OR MD2.Col8 IS NULL OR MD1.Col8 = MD2.Col8)
	AND (MD1.Col9 IS NULL OR MD2.Col9 IS NULL OR MD1.Col9 = MD2.Col9)
	AND (MD1.Col10 IS NULL OR MD2.Col10 IS NULL OR MD1.Col10 = MD2.Col10)
	AND (MD1.Col11 IS NULL OR MD2.Col11 IS NULL OR MD1.Col11 = MD2.Col11)
	AND (MD1.Col12 IS NULL OR MD2.Col12 IS NULL OR MD1.Col12 = MD2.Col12)
	AND (MD1.Col13 IS NULL OR MD2.Col13 IS NULL OR MD1.Col13 = MD2.Col13)
	AND (MD1.Col14 IS NULL OR MD2.Col14 IS NULL OR MD1.Col14 = MD2.Col14)
	AND (MD1.Col15 IS NULL OR MD2.Col15 IS NULL OR MD1.Col15 = MD2.Col15)
	AND (MD1.Col16 IS NULL OR MD2.Col16 IS NULL OR MD1.Col16 = MD2.Col16)
ORDER BY
	MD1.SchemaName,MD1.TableName,MD1.IndexName
	

select 'Missing indexes'
select d.name AS DatabaseName, mid.* 
from sys.dm_db_missing_index_details mid  
join sys.databases d ON mid.database_id=d.database_id

SELECT TOP 25
dm_mid.database_id AS DatabaseID, 
dm_migs.avg_user_impact*(dm_migs.user_seeks+dm_migs.user_scans) Avg_Estimated_Impact,
dm_migs.last_user_seek AS Last_User_Seek,
object_name(dm_mid.object_id,dm_mid.database_id) AS [TableName],
'CREATE INDEX [IX_' + object_name(dm_mid.object_id,dm_mid.database_id) + '_'
+ REPLACE(REPLACE(REPLACE(ISNULL(dm_mid.equality_columns,''),', ','_'),'[',''),']','') +
CASE
	WHEN dm_mid.equality_columns IS NOT NULL AND dm_mid.inequality_columns IS NOT NULL THEN '_'
	ELSE ''
END
+ REPLACE(REPLACE(REPLACE(ISNULL(dm_mid.inequality_columns,''),', ','_'),'[',''),']','')
+ ']'
+ ' ON ' + dm_mid.statement
+ ' (' + ISNULL (dm_mid.equality_columns,'')
+ CASE WHEN dm_mid.equality_columns IS NOT NULL AND dm_mid.inequality_columns IS NOT NULL THEN ',' ELSE
'' END
+ ISNULL (dm_mid.inequality_columns, '')
+ ')'
+ ISNULL (' INCLUDE (' + dm_mid.included_columns + ')', '') AS Create_Statement
FROM sys.dm_db_missing_index_groups dm_mig
INNER JOIN sys.dm_db_missing_index_group_stats dm_migs
ON dm_migs.group_handle = dm_mig.index_group_handle
INNER JOIN sys.dm_db_missing_index_details dm_mid
ON dm_mig.index_handle = dm_mid.index_handle
WHERE dm_mid.database_ID = DB_ID()
ORDER BY Avg_Estimated_Impact DESC 



select 'Unused indexes'
SELECT TOP 25
 o.name AS ObjectName
 , i.name AS IndexName
 , i.index_id AS IndexID
 , dm_ius.user_seeks AS UserSeek
 , dm_ius.user_scans AS UserScans
 , dm_ius.user_lookups AS UserLookups
 , dm_ius.user_updates AS UserUpdates
 , p.TableRows
 , 'DROP INDEX ' + QUOTENAME(i.name)
 + ' ON ' + QUOTENAME(s.name) + '.' + QUOTENAME(OBJECT_NAME(dm_ius.OBJECT_ID)) AS 'drop statement'
 FROM sys.dm_db_index_usage_stats dm_ius
 INNER JOIN sys.indexes i ON i.index_id = dm_ius.index_id AND dm_ius.OBJECT_ID = i.OBJECT_ID
 INNER JOIN sys.objects o ON dm_ius.OBJECT_ID = o.OBJECT_ID
 INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
 INNER JOIN (SELECT SUM(p.rows) TableRows, p.index_id, p.OBJECT_ID
 FROM sys.partitions p GROUP BY p.index_id, p.OBJECT_ID) p
 ON p.index_id = dm_ius.index_id AND dm_ius.OBJECT_ID = p.OBJECT_ID
 WHERE OBJECTPROPERTY(dm_ius.OBJECT_ID,'IsUserTable') = 1
 AND dm_ius.database_id = DB_ID()
 AND i.type_desc = 'nonclustered'
 AND i.is_primary_key = 0
 AND i.is_unique_constraint = 0
 ORDER BY (dm_ius.user_seeks + dm_ius.user_scans + dm_ius.user_lookups) ASC
 
 
end
go

EXEC sp_ms_marksystemobject 'sp_dba_index2'  
go
exec sp_dba_index2
go