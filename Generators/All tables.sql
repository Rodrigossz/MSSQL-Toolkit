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
