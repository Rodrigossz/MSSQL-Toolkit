-- Scripts Criados e adaptados e "organizados" por Rodrigo Souza 
-- rodrigossz@outlook.com
-- rodrigossz@gmail.com
select 'Rodar em cada database!!!!!!!!!!'
go
SELECT 'Tabelas com mais de 50% de fragmentacao' as 'What',

    object_id AS objectid,
	object_name(object_id) as name,
    index_id AS indexid,
    partition_number AS partitionnum,
    avg_fragmentation_in_percent AS frag
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL , NULL, 'LIMITED')
WHERE avg_fragmentation_in_percent > 50.0 AND index_id > 0;
go
create PROCEDURE sp_dba_identify_sparse_candidates
	@SchemaName SYSNAME
	,@TableName SYSNAME

AS

-- author: Jeff Reinhard
DECLARE @TableRows BIGINT
DECLARE @CommandRows INT
DECLARE @ColumnCounter INT = 1
DECLARE @SQLCommandTable TABLE (SQLLine INT IDENTITY (1,1), SQLCommand VARCHAR(MAX))
DECLARE @SQLString VARCHAR(MAX)
DECLARE @ResultsTable TABLE 
	(SchemaName SYSNAME, 
	TableName SYSNAME, 
	ColumnName SYSNAME, 
	NullCount INT, 
	PercentofRows MONEY, 
	SparseThresholdPct INT,
	SparseRecommendation CHAR(20))

SELECT @TableRows = SUM(p.rows) 
  FROM sys.partitions AS p
  INNER JOIN sys.tables AS t			 ON p.[object_id] = t.[object_id]
  INNER JOIN sys.schemas AS s			 ON t.[schema_id] = s.[schema_id]
  WHERE p.index_id IN (0,1) 
  AND t.name = @TableName
  AND s.name = @SchemaName
GROUP BY s.NAME, t.NAME

INSERT INTO @SQLCommandTable (SQLCommand)
SELECT  'SELECT '''+@SchemaName+''' as SchemaName, '''+@TableName+''' as TableName, '''+COLUMN_NAME+''' as ColumnName
	,COUNT(1) [NullCount]
	,COUNT(1)/'+CAST(@TableRows AS VARCHAR)+'.0*100 as PercentofRows
	,CASE '''+DATA_TYPE+'''
	WHEN ''bit''			THEN 98
	WHEN ''tinyint''		THEN 86
	WHEN ''smallint''		THEN 76
	WHEN ''int''			THEN 64
	WHEN ''bigint''			THEN 52
	WHEN ''real''			THEN 64
	WHEN ''float''			THEN 52
	WHEN ''smallmoney''		THEN 64
	WHEN ''money''			THEN 52
	WHEN ''smalldatetime''	THEN 64
	WHEN ''datetime''		THEN 52
	WHEN ''uniqueidentifier'' THEN 43
	WHEN ''date''			THEN 69 
	WHEN ''datetime2''		THEN 52
	WHEN ''time''			THEN 60
	WHEN ''datetimetoffset'' THEN 49
	WHEN ''decimal''		THEN 42
	WHEN ''numeric''		THEN 42
	WHEN ''vardecimal''		THEN 42
	WHEN ''varchar''		THEN 60
	WHEN ''char''			THEN 60
	WHEN ''nvarchar''		THEN 60
	WHEN ''nchar''			THEN 60
	WHEN ''varbinary''		THEN 60
	WHEN ''binary''			THEN 60
	WHEN ''xml''			THEN 60
	WHEN ''hierarchyid''	THEN 60
	ELSE ''UNKNOWN''
	END as SparseThresholdPct
	,NULL as SparseRecommendation
FROM '+@SchemaName+'.'+@TableName+'
WHERE '+COLUMN_NAME+' IS NULL;

' 
 FROM INFORMATION_SCHEMA.COLUMNS
 WHERE TABLE_SCHEMA = @SchemaName AND TABLE_NAME = @TableName
 AND IS_NULLABLE = 'YES'
 AND DATA_TYPE NOT IN ('geography','text','geometry','timestamp','image','ntext')

SELECT @CommandRows = COUNT(1) FROM @SQLCommandTable

WHILE @ColumnCounter <= @CommandRows
	BEGIN
	SELECT @SQLString = SQLCommand FROM @SQLCommandTable WHERE SQLLine = @ColumnCounter

	--SELECT @SQLString
	INSERT INTO @ResultsTable (SchemaName, TableName, ColumnName, NullCount, PercentofRows, SparseThresholdPct, SparseRecommendation )
		EXECUTE (@SQLString)

	SET @ColumnCounter=@ColumnCounter+1
	END

UPDATE @ResultsTable
	SET SparseRecommendation = CASE WHEN PercentofRows >= SparseThresholdPct THEN 'Yes to Sparse' ELSE 'No' END

SELECT * FROM @ResultsTable
	ORDER BY ColumnName

GO

create table #ResultsTable  
	(SchemaName SYSNAME, 
	TableName SYSNAME, 
	ColumnName SYSNAME, 
	NullCount INT, 
	PercentofRows MONEY, 
	SparseThresholdPct INT,
	SparseRecommendation CHAR(20))
insert #ResultsTable
exec sp_msforeachtable 'exec sp_dba_identify_sparse_candidates "dbo","?"'
select 'Tabelas com possível ajuste de datatypes' as 'What',* from #ResultsTable
go
drop table #ResultsTable
drop proc sp_dba_identify_sparse_candidates
go


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

SELECT  'Duplicated indexes' as 'What', * 
FROM    CTE_INDEX_DATA DUPE1 
WHERE   EXISTS ( SELECT 1
FROM   CTE_INDEX_DATA DUPE2 
WHERE  DUPE1.schema_name = DUPE2.schema_name 
AND DUPE1.table_name = DUPE2.table_name 
AND ( DUPE1.key_column_list LIKE LEFT(DUPE2.key_column_list, 
                          LEN(DUPE1.key_column_list)) 
OR DUPE2.key_column_list LIKE LEFT(DUPE1.key_column_list, 
                           LEN(DUPE2.key_column_list)) 
						   ) AND DUPE1.index_name <> DUPE2.index_name )
GO

SELECT top 20 'Avaliar indices muito largos' as 'What',OBJECT_NAME(i.OBJECT_ID) AS TableName,
i.name AS IndexName,
i.index_id AS IndexID,
8 * SUM(a.used_pages) AS 'Indexsize(KB)', max([rows]) as 'Rows', max([rows])/(8 * SUM(a.used_pages) ) as 'Widith KB'
FROM sys.indexes AS i
JOIN sys.partitions AS p ON p.OBJECT_ID = i.OBJECT_ID AND p.index_id = i.index_id
JOIN sys.allocation_units AS a ON a.container_id = p.partition_id
where [rows] > 0 and a.used_pages > 0
GROUP BY i.OBJECT_ID,i.index_id,i.name
having max([rows])/(8 * SUM(a.used_pages) )  > 50
ORDER BY max(rows)/(8 * SUM(a.used_pages) ) desc



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
into #temp
FROM sys.allocation_units INNER JOIN sys.partitions ON sys.allocation_units.container_id = sys.partitions.partition_id 
INNER JOIN (SELECT TOP (100) PERCENT object_id, index_id, type AS TYPE, COUNT(*) AS COUNT_TYPE
FROM sys.indexes AS indexes_1 GROUP BY object_id, type, index_id ORDER BY object_id) AS INDEXES ON 
sys.partitions.object_id = INDEXES.object_id AND sys.partitions.index_id = INDEXES.index_id RIGHT OUTER JOIN
sys.database_principals RIGHT OUTER JOIN sys.tables ON sys.database_principals.principal_id = sys.tables.principal_id ON 
INDEXES.object_id = sys.tables.object_id GROUP BY sys.tables.name, sys.tables.create_date, sys.tables.modify_date, 
CASE WHEN sys.database_principals.name IS NULL THEN SCHEMA_NAME(sys.tables.schema_id) ELSE sys.database_principals.name END, 
sys.tables.max_column_id_used, sys.partitions.rows
select 'Big Tables with huge index area' as 'What', * from #temp
where size_data_kb/1024 > 300 and size_data_kb/SIZE_INDEX_KB < 10
drop table #temp


SELECT 'New missing indexes' as 'What', 
	er.session_id,
	er.blocking_session_id,
	er.start_time,
	er.status,
	dbName = DB_NAME(er.database_id),
	er.wait_type,
	er.wait_time,
	er.last_wait_type,
	er.granted_query_memory,
	er.reads,
	er.logical_reads,
	er.writes,
	er.row_count,
	er.total_elapsed_time,
	er.cpu_time,
	er.open_transaction_count,
	er.open_transaction_count,
	s.text,
	qp.query_plan,
	logDate = CONVERT(DATE,GETDATE()),
	logTime = CONVERT(TIME,GETDATE())
FROM sys.dm_exec_requests er 
CROSS APPLY sys.dm_exec_sql_text(er.sql_handle) s
CROSS APPLY sys.dm_exec_query_plan(er.plan_handle) qp
WHERE 
	CONVERT(VARCHAR(MAX), qp.query_plan) LIKE '%<missing%'
GO


SELECT 'Missing Indexes 2' as 'What', mid.index_handle,
    mid.database_id,
    mid.statement,
    mid.equality_columns,
    mid.inequality_columns,
    mid.included_columns,
    migs.user_seeks,
    migs.user_scans,
    migs.avg_total_user_cost,
    migs.avg_user_impact,
    migs.avg_total_user_cost * migs.avg_user_impact *
    (migs.user_seeks + migs.user_scans) AS potential_user_benefit
  FROM sys.dm_db_missing_index_details AS mid
    INNER JOIN sys.dm_db_missing_index_groups AS mig
      ON mid.index_handle = mig.index_handle
    INNER JOIN sys.dm_db_missing_index_group_stats AS migs
      ON mig.index_group_handle = migs.group_handle
  WHERE (mid.database_id = DB_ID())
  ORDER BY potential_user_benefit DESC;
go


CREATE FUNCTION max3datetimes
(
 @value1 DATETIME,
 @value2 DATETIME,
 @value3 DATETIME
)
RETURNS DATETIME
AS
BEGIN
  DECLARE @value DATETIME;
  SELECT @value = MAX(value)
    FROM (SELECT @value1 value
          UNION
          SELECT @value2 value
          UNION
          SELECT @value3 value) AS allvalues;
  RETURN @value;
END;
GO

CREATE VIEW droppable_indexes
AS
SELECT schemas.name AS schema_name,
    tables.name AS object_name,
    indexes.name AS index_name,
    ISNULL(ius.user_seeks + ius.user_scans +
           ius.user_lookups - ius.user_updates, 0) AS usefulness,
    dbo.max3datetimes(ius.last_user_seek,
                              ius.last_user_scan,
                              ius.last_user_lookup) AS last_user_read,
    ius.last_user_update
  FROM sys.schemas AS schemas
    INNER JOIN sys.tables AS tables
      ON schemas.schema_id = tables.schema_id
    INNER JOIN sys.indexes AS indexes
      ON tables.object_id = indexes.object_id
    LEFT OUTER JOIN sys.dm_db_index_usage_stats AS ius
      ON ius.database_id = DB_ID() AND
         indexes.object_id = ius.object_id AND
         indexes.index_id = ius.index_id
  WHERE (indexes.is_unique = 0)
GO
-- find the most-written-to and least-read-from indexes
SELECT TOP 10 'find the most-written-to and least-read-from indexes' as 'What', *
  FROM droppable_indexes
  ORDER BY usefulness;
-- find the least-recently-used indexes
SELECT TOP 10 'find the least-recently-used indexes' as 'What', *
  FROM droppable_indexes
  ORDER BY last_user_read;

drop view droppable_indexes
go
drop function dbo.max3datetimes
go


-- Tells you what tables and indexes are using the most memory in the buffer cache
 SELECT 'what tables and indexes are using the most memory in the buffer cache' as 'what',
      OBJECT_NAME(p.object_id) AS [ObjectName]
    , p.object_id
    , p.index_id
    , COUNT(*) / 128 AS [buffer size(MB)]
    , COUNT(*) AS [buffer_count]
 FROM
      sys.allocation_units AS a
      INNER JOIN sys.dm_os_buffer_descriptors AS b
            ON a.allocation_unit_id = b.allocation_unit_id
      INNER JOIN sys.partitions AS p
            ON a.container_id = p.hobt_id
 WHERE
      b.database_id = DB_ID()
      AND p.object_id > 100
 GROUP BY
      p.object_id
    , p.index_id
 ORDER BY
      buffer_count DESC;
go

	  WITH LastActivity (ObjectID, LastAction) AS 
  (
       SELECT object_id AS TableName,
              last_user_seek as LastAction
         FROM sys.dm_db_index_usage_stats u
        WHERE database_id = db_id(db_name())
        UNION 
       SELECT object_id AS TableName,
              last_user_scan as LastAction
         FROM sys.dm_db_index_usage_stats u
        WHERE database_id = db_id(db_name())
        UNION
       SELECT object_id AS TableName,
              last_user_lookup as LastAction
         FROM sys.dm_db_index_usage_stats u
        WHERE database_id = db_id(db_name())
  )
  SELECT 'Tabelas sem acesso há 90 dias' as 'What', OBJECT_NAME(so.object_id) AS TableName,
         MAX(la.LastAction) as LastSelect,
		 CASE WHEN so.type = 'U' THEN 'Table (user-defined)'
		 WHEN so.type = 'V' THEN 'View'
		 END  AS Table_View
		 ,CASE WHEN st.create_date IS NULL
		 THEN sv.create_date
		 ELSE st.create_date
		 END AS create_date
		 ,CASE WHEN st.modify_date IS NULL
		 THEN sv.modify_date
		 ELSE st.modify_date
		 END AS modify_date

    FROM sys.objects so
    LEFT JOIN LastActivity la
      on so.object_id = la.ObjectID
	  LEFT JOIN sys.tables st
	  on so.object_id = st.object_id
	  LEFT JOIN sys.views sv
	  on so.object_id = sv.object_id

   WHERE so.type in ('V','U')
     AND so.object_id > 100
GROUP BY OBJECT_NAME(so.object_id)
, so.type 
,st.create_date 
,st.modify_date
,sv.create_date
,sv.modify_date
having isnull(MAX(la.LastAction),'20160101') < dateadd(dd,-90, getdate())
ORDER BY 3 
go

SELECT 'Indices CLuster com Datatype nao indicado' as 'What',
t.name as TableName, col.name AS ColumnName, ty.name, i.name AS PrimaryKey_Name
FROM 
   sys.tables t 
   INNER JOIN sys.indexes i ON t.object_id = i.object_id
   INNER JOIN sys.index_columns c ON t.object_id = c.object_id 
                                     AND i.index_id = c.index_id 
   INNER JOIN sys.columns col ON c.object_id = col.object_id 
                                     AND c.column_id = col.column_id 
 INNER JOIN sys.types ty on ty.system_type_id = col.system_type_id
WHERE 
   i.is_primary_key = 1 AND t.name IN (SELECT name from sys.tables) and i.type_desc = 'CLUSTERED'
   and ty.name not in ('date','time','datetime2','tinyint','smallint','int','smalldatetime','datetime','decimal','numeric','bigint','timestamp')
ORDER BY t.name, c.key_ordinal

