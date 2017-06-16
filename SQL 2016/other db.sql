USE [Minuto]
GO

/****** Object:  StoredProcedure [dbo].[sp_dba_tb2]    Script Date: 3/11/2015 11:19:03 AM ******/
DROP PROCEDURE [dbo].[sp_dba_tb2]
GO

/****** Object:  StoredProcedure [dbo].[sp_dba_tableCheck]    Script Date: 3/11/2015 11:19:03 AM ******/
DROP PROCEDURE [dbo].[sp_dba_tableCheck]
GO

/****** Object:  StoredProcedure [dbo].[sp_dba_indexSizes]    Script Date: 3/11/2015 11:19:03 AM ******/
DROP PROCEDURE [dbo].[sp_dba_indexSizes]
GO

/****** Object:  StoredProcedure [dbo].[sp_dba_dupIndex]    Script Date: 3/11/2015 11:19:03 AM ******/
DROP PROCEDURE [dbo].[sp_dba_dupIndex]
GO

/****** Object:  StoredProcedure [dbo].[sp_dba_dupIndex]    Script Date: 3/11/2015 11:19:03 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create proc [dbo].[sp_dba_dupIndex]
as
WITH  CTE_INDEX_DATA 

AS ( SELECT SCHEMA_DATA.name AS schema_name 

, TABLE_DATA.name AS table_name 

, INDEX_DATA.name AS index_name 

, STUFF(( SELECT  ', ' + COLUMN_DATA_KEY_COLS.name 

FROM    sys.tables AS T 

INNER JOIN sys.indexes INDEX_DATA_KEY_COLS ON T.object_id = INDEX_DATA_KEY_COLS.object_id 

INNER JOIN sys.index_columns INDEX_COLUMN_DATA_KEY_COLS ON INDEX_DATA_KEY_COLS.object_id = INDEX_COLUMN_DATA_KEY_COLS.object_id 

                            AND INDEX_DATA_KEY_COLS.index_id = INDEX_COLUMN_DATA_KEY_COLS.index_id 

INNER JOIN sys.columns COLUMN_DATA_KEY_COLS ON T.object_id = COLUMN_DATA_KEY_COLS.object_id 

                            AND INDEX_COLUMN_DATA_KEY_COLS.column_id = COLUMN_DATA_KEY_COLS.column_id 

WHERE   INDEX_DATA.object_id = INDEX_DATA_KEY_COLS.object_id 

AND INDEX_DATA.index_id = INDEX_DATA_KEY_COLS.index_id 

AND INDEX_COLUMN_DATA_KEY_COLS.is_included_column = 0 

ORDER BY INDEX_COLUMN_DATA_KEY_COLS.key_ordinal 

FOR 

XML PATH('') 

), 1, 2, '') AS key_column_list 

, STUFF(( SELECT  ', ' + COLUMN_DATA_INC_COLS.name 

FROM    sys.tables AS T 

INNER JOIN sys.indexes INDEX_DATA_INC_COLS ON T.object_id = INDEX_DATA_INC_COLS.object_id 

INNER JOIN sys.index_columns INDEX_COLUMN_DATA_INC_COLS ON INDEX_DATA_INC_COLS.object_id = INDEX_COLUMN_DATA_INC_COLS.object_id 

                            AND INDEX_DATA_INC_COLS.index_id = INDEX_COLUMN_DATA_INC_COLS.index_id 

INNER JOIN sys.columns COLUMN_DATA_INC_COLS ON T.object_id = COLUMN_DATA_INC_COLS.object_id 

                            AND INDEX_COLUMN_DATA_INC_COLS.column_id = COLUMN_DATA_INC_COLS.column_id 

WHERE   INDEX_DATA.object_id = INDEX_DATA_INC_COLS.object_id 

AND INDEX_DATA.index_id = INDEX_DATA_INC_COLS.index_id 

AND INDEX_COLUMN_DATA_INC_COLS.is_included_column = 1 

ORDER BY INDEX_COLUMN_DATA_INC_COLS.key_ordinal 

FOR 

XML PATH('') 

), 1, 2, '') AS include_column_list 

FROM   sys.indexes INDEX_DATA 

INNER JOIN sys.tables TABLE_DATA ON TABLE_DATA.object_id = INDEX_DATA.object_id 

INNER JOIN sys.schemas SCHEMA_DATA ON SCHEMA_DATA.schema_id = TABLE_DATA.schema_id 

WHERE  TABLE_DATA.is_ms_shipped = 0 

AND INDEX_DATA.type_desc IN ( 'NONCLUSTERED', 'CLUSTERED' ) 

) 

SELECT  * 

FROM    CTE_INDEX_DATA DUPE1 

WHERE   EXISTS ( SELECT * 

FROM   CTE_INDEX_DATA DUPE2 

WHERE  DUPE1.schema_name = DUPE2.schema_name 

AND DUPE1.table_name = DUPE2.table_name 

AND ( DUPE1.key_column_list LIKE LEFT(DUPE2.key_column_list, 

                            LEN(DUPE1.key_column_list)) 

OR DUPE2.key_column_list LIKE LEFT(DUPE1.key_column_list, 

                            LEN(DUPE2.key_column_list)) 

) 

AND DUPE1.index_name <> DUPE2.index_name )



GO

/****** Object:  StoredProcedure [dbo].[sp_dba_indexSizes]    Script Date: 3/11/2015 11:19:04 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create proc [dbo].[sp_dba_indexSizes] as

SELECT OBJECT_NAME(i.OBJECT_ID) AS TableName,
i.name AS IndexName,
i.index_id AS IndexID,
8 * SUM(a.used_pages) AS 'Indexsize(KB)'
FROM sys.indexes AS i
JOIN sys.partitions AS p ON p.OBJECT_ID = i.OBJECT_ID AND p.index_id = i.index_id
JOIN sys.allocation_units AS a ON a.container_id = p.partition_id
GROUP BY i.OBJECT_ID,i.index_id,i.name
ORDER BY [Indexsize(KB)] desc

SELECT db_name()as db,OBJECT_NAME(i.OBJECT_ID) AS TableName,
i.name AS IndexName,
i.index_id AS IndexID,
(8 * SUM(a.used_pages))/1024 AS 'Indexsize(MB)'
FROM sys.indexes AS i
JOIN sys.partitions AS p ON p.OBJECT_ID = i.OBJECT_ID AND p.index_id = i.index_id
JOIN sys.allocation_units AS a ON a.container_id = p.partition_id
where i.index_id > 1 
GROUP BY i.OBJECT_ID,i.index_id,i.name
having (8 * SUM(a.used_pages)) > 500000
ORDER BY [Indexsize(MB)] desc

GO

/****** Object:  StoredProcedure [dbo].[sp_dba_tableCheck]    Script Date: 3/11/2015 11:19:05 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create proc [dbo].[sp_dba_tableCheck]
as
SELECT sys.tables.name AS [TABLE], sys.tables.create_date AS CREATE_DATE, 
sys.tables.modify_date AS MODIFY_DATE, 
CASE WHEN sys.database_principals.name IS NULL THEN SCHEMA_NAME(sys.tables.schema_id) 
ELSE sys.database_principals.name END AS OWNER, 
SUM(ISNULL(CASE INDEXES.TYPE WHEN 0 THEN COUNT_TYPE END, 0)) AS COUNT_HEAP_INDEX, 
SUM(ISNULL(CASE INDEXES.TYPE WHEN 1 THEN COUNT_TYPE END, 0)) AS COUNT_CLUSTERED_INDEX, 
SUM(ISNULL(CASE INDEXES.TYPE WHEN 2 THEN COUNT_TYPE END, 0)) AS COUNT_NONCLUSTERED_INDEX, 
SUM(ISNULL(CASE INDEXES.TYPE WHEN 3 THEN COUNT_TYPE END, 0)) AS COUNT_XML_INDEX, 
SUM(ISNULL(CASE INDEXES.TYPE WHEN 4 THEN COUNT_TYPE END, 0)) AS COUNT_SPATIAL_INDEX, 
sys.tables.max_column_id_used AS COUNT_COLUMNS, sys.partitions.rows AS COUNT_ROWS, 
SUM(ISNULL(CASE WHEN sys.allocation_units.type <> 1 THEN USED_PAGES 
WHEN SYS.partitions.INDEX_ID < 2 THEN DATA_PAGES ELSE 0 END, 0)) *
(SELECT low / 1024 AS VALUE FROM master.dbo.spt_values 
WHERE (number = 1) AND (type = N'E')) AS SIZE_DATA_KB, 
SUM(ISNULL(sys.allocation_units.used_pages - CASE WHEN sys.allocation_units.type <> 1 THEN USED_PAGES 
WHEN SYS.partitions.INDEX_ID < 2 THEN DATA_PAGES ELSE 0 END, 0)) * (SELECT low / 1024 AS VALUE 
FROM master.dbo.spt_values AS spt_values_2 WHERE (number = 1) AND (type = N'E')) AS SIZE_INDEX_KB
FROM sys.allocation_units INNER JOIN sys.partitions ON sys.allocation_units.container_id = sys.partitions.partition_id 
INNER JOIN (SELECT TOP (100) PERCENT object_id, index_id, type AS TYPE, COUNT(*) AS COUNT_TYPE
FROM sys.indexes AS indexes_1 GROUP BY object_id, type, index_id ORDER BY object_id) AS INDEXES ON 
sys.partitions.object_id = INDEXES.object_id AND sys.partitions.index_id = INDEXES.index_id RIGHT OUTER JOIN
sys.database_principals RIGHT OUTER JOIN sys.tables ON sys.database_principals.principal_id = sys.tables.principal_id ON 
INDEXES.object_id = sys.tables.object_id GROUP BY sys.tables.name, sys.tables.create_date, sys.tables.modify_date, 
CASE WHEN sys.database_principals.name IS NULL THEN SCHEMA_NAME(sys.tables.schema_id) ELSE sys.database_principals.name END, 
sys.tables.max_column_id_used, sys.partitions.rows
ORDER BY COUNT_ROWS DESC


GO

/****** Object:  StoredProcedure [dbo].[sp_dba_tb2]    Script Date: 3/11/2015 11:19:05 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create proc [dbo].[sp_dba_tb2]
as
SELECT object_name(idx.object_id),idx.name,
p.partition_number AS [PartitionNumber],
prv.value AS [RightBoundaryValue],
CAST(p.rows AS float) AS [RowCount],
fg.name AS [FileGroupName],
CAST(pf.boundary_value_on_right AS int) AS [RangeType],
p.data_compression AS [DataCompression], idx.fill_factor,idx.type_desc,user_name(tbl.schema_id) as owner
FROM
sys.tables AS tbl
INNER JOIN sys.indexes AS idx ON idx.object_id = tbl.object_id 
INNER JOIN sys.partitions AS p ON p.object_id=CAST(tbl.object_id AS int) AND p.index_id=idx.index_id
INNER JOIN sys.indexes AS indx ON p.object_id = indx.object_id and p.index_id = indx.index_id
LEFT OUTER JOIN sys.destination_data_spaces AS dds ON dds.partition_scheme_id = indx.data_space_id and dds.destination_id = p.partition_number
LEFT OUTER JOIN sys.partition_schemes AS ps ON ps.data_space_id = indx.data_space_id
LEFT OUTER JOIN sys.partition_range_values AS prv ON prv.boundary_id = p.partition_number and prv.function_id = ps.function_id
LEFT OUTER JOIN sys.filegroups AS fg ON fg.data_space_id = dds.data_space_id or fg.data_space_id = indx.data_space_id
LEFT OUTER JOIN sys.partition_functions AS pf ON pf.function_id = prv.function_id
--WHERE tbl.NAME LIKE 'foo%'
order by CAST(p.rows AS float) desc


GO

