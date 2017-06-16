use master
go
create PROCEDURE sp_dba_identify_sparse_candidates
	@SchemaName SYSNAME
	,@TableName SYSNAME

AS
select @SchemaName ,@TableName
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
exec sp_msforeachtable 'exec sp_dba_identify_sparse_candidates "dbo","?"'
go