use master
go
IF OBJECT_ID('sp_dba_tb2') IS NOT NULL DROP PROC sp_dba_tb2 
GO 

IF OBJECT_ID('sp_dba_tb3') IS NOT NULL DROP PROC sp_dba_tb3 
GO 

IF OBJECT_ID('sp_dba_tb4') IS NOT NULL DROP PROC sp_dba_tb4 
GO 

create proc sp_dba_tb2
as 
select DB_NAME(database_id) as DBName,OBJECT_NAME(object_id) as ObjName,record_count,index_type_desc as RecordCountFromIdxType
from sys.dm_db_index_physical_stats(db_id(),null,null,null,'DETAILED')
Where index_id in (0,1) And index_level = 0
order by record_count desc
go


CREATE PROCEDURE sp_dba_tb3
@tblPat SYSNAME = '%' 
,@sort CHAR(1) = 'm' 
AS 
--Written by Tibor Karaszi 2010-09-30
--Modified 2010-10-10, fixed rowcount multiplied by number of indexes.
--Modified 2010-10-11, fixed rowcount incorrect with BLOB and row overflow data.
WITH t AS
(
SELECT 
SCHEMA_NAME(t.schema_id) AS schema_name
,t.name AS table_name
,SUM(CASE WHEN p.index_id IN(0,1) AND a.type_desc = 'IN_ROW_DATA' THEN p.rows ELSE 0 END) AS rows
,SUM(CAST((a.total_pages * 8.00) / 1024 AS DECIMAL(9,2))) AS MB 
,SUM(a.total_pages) AS pages 
,ds.name AS location
FROM 
sys.tables AS t
INNER JOIN sys.partitions AS p ON t.OBJECT_ID = p.OBJECT_ID
INNER JOIN sys.allocation_units AS a ON p.hobt_id = a.container_id 
INNER JOIN sys.data_spaces AS ds ON a.data_space_id = ds.data_space_id
WHERE t.name LIKE @tblPat 
GROUP BY SCHEMA_NAME(t.schema_id), t.name, ds.name 
)
SELECT schema_name, table_name, rows, MB, pages, location
FROM t
ORDER BY
CASE WHEN @sort = 'n' THEN table_name END
,CASE WHEN @sort = 'r' THEN rows END DESC
,CASE WHEN @sort = 'm' THEN MB END DESC
,CASE WHEN @sort = 's' THEN schema_name END
GO

create PROCEDURE sp_dba_tb4 
  @DbName sysname = NULL,  
  @SchemaName sysname = NULL,  
  @ObjectName sysname = N'%',  
  @TopClause nvarchar(20) = NULL,
  @ObjectType nvarchar(50) = NULL,  
  @ShowInternalTable nvarchar(3) = NULL, 
  @OrderBy nvarchar(100) = NULL,  
  @UpdateUsage bit = 0 
AS

/*=================================================================================================

Author:     Richard Ding

Created:    Mar. 03, 2008

Modified:   Mar. 17, 2008

Purpose:    Manipulate object size calculation and display for SS 2000/2005/2008

Parameters: 
  @DbName:            default is the current database
  @SchemaName:        default is null showing all schemas
  @ObjectName:        default is "%" including all objects in "LIKE" clause
  @TopClause:         default is null showing all objects. Can be "TOP N" or "TOP N PERCENT"
  @ObjectType:        default is "S", "U", "V", "SQ" and "IT". All objects that can be sized
  @ShowInternalTable: default is "Yes", when listing IT, the Parent excludes it in size 
  @OrderBy:           default is by object name, can be any size related column
  @UpdateUsage:       default is 0, meaning "do not run DBCC UPDATEUSAGE" 

Note:       SS 2000/2005/2008 portable using dynamic SQL to bypass validation error;
            Use ISNULL to allow prefilled default parameter values;
            Use "DBCC UPDATEUSAGE" with caution as it can hold up large databases;
            Unicode compatible and case insensitive; 

Sample codes:

   EXEC dbo.sp_SOS;
   EXEC dbo.sp_SOS 'AdventureWorks', NULL, '%', NULL, 'U', 'No', 'T', 1;
   sp_SOS 'TRACE', NULL, NULL, Null, '  ,,, ,;SQ,;  u  ;;;,,  v  ,,;iT     ,  ;', 'No', N'N', 0;
   sp_SOS NULL, NULL, NULL, NULL, 'U', 'Yes', N'U', 1;
   sp_SOS 'AdventureWorks', 'Person%', 'Contact%', NULL, 'U', 'no', 'N', 0;
   sp_SOS 'AdventureWorks', NULL, NULL, N'Top 100 Percent', 'S', 'yes', N'N', 1;
   sp_SOS 'AdventureWorks', NULL, 'xml_index_nodes_309576141_32000', NULL, 'IT', 'yes', 'N', 1;
   sp_SOS 'TRACE', NULL, 'Vw_DARS_217_overnight_activity_11142007', ' top 10 ', 'v', 'yes', 'N', 0;
   sp_SOS 'AdventureWorks', NULL, 'xml%', ' top 10 ', null, 'yes', 'N', 1;
   sp_SOS 'AdventureWorks2008', NULL, 'sales%', NULL, '  ,,;  u  ;;;,,  v  ', 'No', N'N', 1;
   sp_SOS NULL, NULL, NULL, N'Top 100 Percent', ' ;;Q, U;V,', N'Y', 1;

=================================================================================================*/

SET NOCOUNT ON;

--  Input parameter validity checking
DECLARE @SELECT nvarchar(2500), 
        @WHERE_Schema nvarchar(200),
        @WHERE_Object nvarchar(200), 
        @WHERE_Type nvarchar(200), 
        @WHERE_Final nvarchar(1000), 
        @ID int, 
        @Version nchar(2), 
        @String nvarchar(4000), 
        @Count bigint,
        @GroupBy nvarchar(450);

IF ISNULL(@OrderBy, N'N') NOT IN (N'', N'N', N'R', N'T', N'U', N'I', N'D', N'F', N'Y')
  BEGIN
    RAISERROR (N'Incorrect value for @OrderBy. Valid parameters are: 
      ''N''  -->  Listing by object name 
      ''R''  -->  Listing by number of records  
      ''T''  -->  Listing by total size 
      ''U''  -->  Listing by used portion (excluding free space) 
      ''I''  -->  Listing by index size 
      ''D''  -->  Listing by data size
      ''F''  -->  Listing by unused (free) space 
      ''Y''  -->  Listing by object type ',  16, 1)
    RETURN (-1)
  END;

--  Object Type Validation and Clean up
DECLARE @OTV nvarchar(10), @OTC nvarchar(10);
SELECT @OTV = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(@ObjectType, 
              N'S, U, V, SQ, IT'), N' ', N''), N',', N''), N';', N''), N'SQ', N''), N'U', N''), 
              N'V', N''), N'IT', N''), N'S', N'');
IF LEN(@OTV) <> 0    --  only allow comma, semi colon and space around S,U,V,SQ,IT
  BEGIN
    RAISERROR (N'Parameter error. Choose ''S'', ''U'', ''V'', ''SQ'', ''IT'' or any combination of them, 
separated by space, comma or semicolon.

  S   ->   System table;
  U   ->   User table;
  V   ->   Indexed view;
  SQ  ->   Service Queue;
  IT  ->   Internal Table',  16, 1)
    RETURN (-1)
  END
ELSE    --  passed validation
  BEGIN
    SET @OTC = UPPER(REPLACE(REPLACE(REPLACE(ISNULL(@ObjectType,N'S,U,V,SQ,IT'),N' ',N''),N',',N''),N';',N''))
    SELECT @ObjectType = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ISNULL
               (@ObjectType, N'S,U,V,SQ,IT'),N',',N''),N';',N''),N'SQ',N'''QQ'''),N'IT',N'''IT'''),N'S',
                             N'''S'''),N'U',N'''U'''),N'V',N'''V'''),N'QQ',N'SQ'),N' ',N''),N'''''',N''',''')
  END

----  common  ----
SELECT @DbName = ISNULL(@DbName, DB_NAME()), 
       @Version = SUBSTRING(CONVERT(nchar(20), SERVERPROPERTY (N'ProductVersion')), 1, 
                    CHARINDEX(N'.', CONVERT(nchar(20), SERVERPROPERTY (N'ProductVersion')))-1),
       @OrderBy = N'ORDER BY [' + 
                    CASE ISNULL(@OrderBy, N'N') 
                      WHEN N'N' THEN N'Object Name] ASC ' 
                      WHEN N'R' THEN N'Rows] DESC, [Object Name] ASC '
                      WHEN N'T' THEN N'Total(MB)] DESC, [Object Name] ASC '
                      WHEN N'U' THEN N'Used(MB)] DESC, [Object Name] ASC '
                      WHEN N'I' THEN N'Index(MB)] DESC, [Object Name] ASC '
                      WHEN N'D' THEN N'Data(MB)] DESC, [Object Name] ASC ' 
                      WHEN N'F' THEN N'Unused(MB)] DESC, [Object Name] ASC '
                      WHEN N'Y' THEN N'Type] ASC, [Object Name] ASC ' 
                    END;

----------------------  SS 2000  -----------------------------------
IF @Version = N'8'
  BEGIN
    SELECT @SELECT = N'USE ' + @DbName + N' SELECT ' + ISNULL(@TopClause, N' ') +   
    N''''' + USER_NAME(o.uid) + ''.'' + OBJECT_NAME(i.id) + '''' AS ''Object Name'',
    o.type AS ''Type'',
    MAX(i.[rows]) AS ''Rows'',
    CONVERT(dec(10,3), SUM(i.reserved * 8.000/1024)) AS ''Total(MB)'', 
    CONVERT(dec(10,3), SUM((i.reserved - i.used) * 8.000/1024)) AS ''Unused(MB)'',
    CONVERT(dec(10,3), SUM(i.used * 8.000/1024)) AS ''Used(MB)'',
    CONVERT(dec(10,3), SUM((i.used - CASE WHEN indid <> 255 THEN i.dpages ELSE i.used END)
      * 8.000/1024)) AS ''Index(MB)'',
    CONVERT(dec(10,3), SUM(CASE WHEN indid <> 255 THEN i.dpages ELSE i.used END 
      * 8.000/1024)) AS ''Data(MB)''
    FROM dbo.sysindexes i WITH (NOLOCK) 
    JOIN dbo.sysobjects o WITH (NOLOCK) 
    ON i.id = o.id 
    WHERE i.name NOT LIKE ''_WA_Sys_%'' 
    AND i.indid IN (0, 1, 255) AND USER_NAME(o.uid) LIKE ''' + ISNULL(@SchemaName, N'%') + N''' ',
    -- SS 2000 calculation as below:
    --  "reserved" = total size;
    --  "dpages" = data used;
    --  "used" = used portion (contains data and index);
    --  text or image column: use "used" for data size 
    --  Nonclustered index take tiny space, somehow it is not counted (see sp_spaceused).
    @WHERE_Final = N' AND OBJECT_NAME(i.id) LIKE ''' + ISNULL(@ObjectName, N'%') 
                 + N''' AND o.type IN (' + @ObjectType + N') ',
    @GroupBy = N' GROUP BY '''' + USER_NAME(o.uid) + ''.'' + OBJECT_NAME(i.id) + '''', o.type ',
    @String =  @SELECT + @WHERE_Final + @GroupBy + @OrderBy
  END

-------------------  ss 2k5 ------------------------------------------------------
IF @Version IN (N'9', N'10')
  BEGIN
    SELECT @String = N' 
IF OBJECT_ID (''tempdb.dbo.##BO'', ''U'') IS NOT NULL
  DROP TABLE dbo.##BO 

CREATE TABLE dbo.##BO (
  ID int identity,
  DOI bigint null,        -- Daughter Object Id
  DON sysname null,       -- Daughter Object Name
  DSI int null,           -- Daughter Schema Id
  DSN sysname null,       -- Daughter Schema Name
  DOT varchar(10) null,   -- Daughter Object Type
  DFN sysname null,       -- Daughter Full Name
  POI bigint null,        -- Parent Object Id
  PON sysname null,       -- Parent Object Name
  PSI bigint null,        -- Parent Schema Id
  PSN sysname null,       -- Parent Schema Name
  POT varchar(10) null,   -- Parent Object Type
  PFN sysname null        -- Parent Full Name
) 

INSERT INTO dbo.##BO (DOI, DSI, DOT, POI)
  SELECT object_id, schema_id, type, Parent_object_id 
FROM ' + @DbName + N'.sys.objects o WHERE type IN (''S'',''U'',''V'',''SQ'',''IT'') 
USE ' + @DbName + N' 
UPDATE dbo.##BO SET DON = object_name(DOI), DSN = schema_name(DSI), POI = CASE POI WHEN 0 THEN DOI ELSE POI END
UPDATE dbo.##BO SET PSI = o.schema_id, POT = o.type FROM sys.objects o JOIN dbo.##BO t ON o.object_id = t.POI
UPDATE dbo.##BO SET PON = object_name(POI), PSN = schema_name(PSI), DFN = DSN + ''.'' + DON, 
                    PFN = schema_name(PSI)+ ''.'' + object_name(POI)
'
EXEC (@String)

SELECT 
@WHERE_Type = CASE WHEN ISNULL(@ShowInternalTable, N'Yes') = N'Yes' THEN N't.DOT ' ELSE N't.POT ' END,  
@SELECT = N'USE ' + @DbName + N' 
  SELECT ' + ISNULL(@TopClause, N'TOP 100 PERCENT ') + 
      N' CASE WHEN ''' + isnull(@ShowInternalTable, N'Yes') + N''' = ''Yes'' THEN CASE t.DFN WHEN t.PFN THEN t.PFN 
          ELSE t.DFN + '' (''+ t.PFN + '')'' END ELSE t.PFN END AS ''Object Name'', 
         ' + @WHERE_Type + N' AS ''Type'',
         SUM (CASE WHEN ''' + isnull(@ShowInternalTable, N'Yes') + N''' = ''Yes'' THEN 
           CASE WHEN (ps.index_id < 2 ) THEN ps.row_count ELSE 0 END
             ELSE CASE WHEN (ps.index_id < 2 and t.DON = t.PON) THEN ps.row_count ELSE 0 END END) AS ''Rows'',
         SUM (CASE WHEN t.DON NOT LIKE ''fulltext%'' OR t.DON LIKE ''fulltext_index_map%'' 
                THEN ps.reserved_page_count ELSE 0 END)* 8.000/1024 AS ''Total(MB)'',
         SUM (CASE WHEN t.DON NOT LIKE ''fulltext%'' OR t.DON LIKE ''fulltext_index_map%'' 
                THEN ps.reserved_page_count ELSE 0 END 
              - CASE WHEN t.DON NOT LIKE ''fulltext%'' OR t.DON LIKE ''fulltext_index_map%'' THEN 
                  ps.used_page_count ELSE 0 END)* 8.000/1024 AS ''Unused(MB)'',
	     SUM (CASE WHEN t.DON NOT LIKE ''fulltext%'' OR t.DON LIKE ''fulltext_index_map%'' 
                THEN ps.used_page_count ELSE 0 END)* 8.000/1024 AS ''Used(MB)'',
         SUM (CASE WHEN t.DON NOT LIKE ''fulltext%'' OR t.DON LIKE ''fulltext_index_map%'' 
                THEN ps.used_page_count ELSE 0 END
              - CASE WHEN t.POT NOT IN (''SQ'',''IT'') AND t.DOT IN (''IT'') and ''' + isnull(@ShowInternalTable, N'Yes')
                + N''' = ''No'' THEN 0 ELSE CASE WHEN (ps.index_id<2) 
                  THEN (ps.in_row_data_page_count+ps.lob_used_page_count+ps.row_overflow_used_page_count)
			    ELSE ps.lob_used_page_count + ps.row_overflow_used_page_count END END) * 8.000/1024 AS ''Index(MB)'',
	     SUM (CASE WHEN t.POT NOT IN (''SQ'',''IT'') AND t.DOT IN (''IT'') and ''' + isnull(@ShowInternalTable, N'Yes') 
	            + N''' = ''No'' THEN 0 ELSE CASE WHEN (ps.index_id<2) 
	              THEN (ps.in_row_data_page_count+ps.lob_used_page_count+ps.row_overflow_used_page_count)
			  ELSE ps.lob_used_page_count + ps.row_overflow_used_page_count END END) * 8.000/1024 AS ''Data(MB)''
    FROM sys.dm_db_partition_stats ps INNER JOIN dbo.##BO t
      ON ps.object_id = t.DOI 
',
@ObjectType = CASE WHEN ISNULL(@ShowInternalTable, N'Yes') = N'Yes' THEN N'''IT'',' + ISNULL(@ObjectType, N'''S'',''U'', 
                ''V'', ''SQ'', ''IT''') ELSE ISNULL(@ObjectType, N'''S'', ''U'', ''V'', ''SQ'', ''IT''') END,
@WHERE_Schema = CASE WHEN ISNULL(@ShowInternalTable, N'Yes') = N'Yes' THEN N' t.DSN ' ELSE N' t.PSN ' END, -- DSN or PSN
@WHERE_Object = CASE WHEN ISNULL(@ShowInternalTable, N'Yes') = N'Yes' THEN N' t.DON LIKE ''' + ISNULL(@ObjectName, N'%')
                + ''' OR t.PON LIKE ''' + ISNULL(@ObjectName, N'%') + N''' ' 
                ELSE N' t.pon LIKE ''' + ISNULL(@ObjectName, N'%') + N''' ' END,      -- DON or PON
@WHERE_Final = N' WHERE (' + @WHERE_Schema + N' LIKE ''' + ISNULL(@SchemaName, N'%') + N''' OR ' + @WHERE_Schema + 
               N' = ''sys'') AND (' + @WHERE_Object + N' ) AND ' + @WHERE_Type + N' IN (' + @ObjectType + N') ',
@GroupBy = N'GROUP BY CASE WHEN ''' + ISNULL(@ShowInternalTable, N'Yes') + N''' = ''Yes'' THEN CASE t.DFN WHEN t.PFN 
            THEN t.PFN ELSE t.DFN + '' (''+ t.PFN + '')'' END ELSE t.PFN END, ' + @WHERE_Type + N''
SELECT @String =  @SELECT + @WHERE_Final + @GroupBy + @OrderBy
 -- SELECT @String AS 'STRING'
END

-----  common  ------
IF OBJECT_ID(N'tempdb.dbo.##FO', N'U') IS NOT NULL
  DROP TABLE dbo.##FO;

CREATE TABLE dbo.##FO (
    ID int identity, 
    [Object Name] sysname, 
    [Type] varchar(2),
    [Rows] bigint, 
    [Total(MB)] dec(10,3), 
    [-] nchar(1), 
    [Unused(MB)] dec(10,3), 
    [==] nchar(2), 
    [Used(MB)] dec(10,3), 
    [=] nchar(1), 
    [Index(MB)] dec(10,3), 
    [+] nchar(1), 
    [Data(MB)] dec(10,3) );

INSERT INTO dbo.##FO ([Object Name], [Type], [Rows], [Total(MB)],[Unused(MB)],[Used(MB)],[Index(MB)],[Data(MB)])
  EXEC (@String);

SELECT @Count = COUNT(*) FROM dbo.##FO;

IF @Count = 0
  BEGIN
    RAISERROR (N'No records were found macthcing your criteria.',  16, 1)
    RETURN (-1)
  END
ELSE    -- There're at least one records
  BEGIN
    --  Run DBCC UPDATEUSAGE to correct wrong values 
    IF ISNULL(@UpdateUsage, 0) = 1 
      BEGIN
        SELECT @ObjectName = N'', @ID = 0 
          WHILE 1 = 1
		        BEGIN
		          SELECT TOP 1 @ObjectName = CASE WHEN [Object Name] LIKE N'%(%' THEN 
                     SUBSTRING([Object Name], 1, CHARINDEX(N'(', [Object Name])-2) ELSE [Object Name] END
                      , @ID = ID FROM dbo.##FO WHERE ID > @ID ORDER BY ID ASC
		          IF @@ROWCOUNT = 0
		            BREAK
              PRINT N'==> DBCC UPDATEUSAGE (' + @DbName + N', ''' + @ObjectName + N''') WITH COUNT_ROWS' 
			        DBCC UPDATEUSAGE (@DbName, @ObjectName) WITH COUNT_ROWS
              PRINT N''
		        END

          PRINT N''
        TRUNCATE TABLE dbo.##FO
        INSERT INTO dbo.##FO ([Object Name], [Type], [Rows], [Total(MB)],[Unused(MB)],
                              [Used(MB)],[Index(MB)],[Data(MB)]) EXEC (@String)
      END
    ELSE
      PRINT N'(Warning: Run "DBCC UPDATEUSAGE" on suspicious objects. It may incur overhead on big databases.)'
    PRINT N''

    UPDATE dbo.##FO SET [-] = N'-', [==] = N'==', [=] = N'=', [+] = N'+'

    IF @Count = 1  -- when only 1 row, no need to sum up total
      SELECT [Object Name], [Type], [Rows], [Total(MB)],[-], [Unused(MB)],[==], [Used(MB)],[=],
             [Index(MB)],[+],[Data(MB)] 
      FROM dbo.##FO ORDER BY ID ASC 
    ELSE
      BEGIN
        SELECT [Object Name], [Type], [Rows], [Total(MB)],[-], [Unused(MB)],[==], [Used(MB)],[=],
               [Index(MB)],[+],[Data(MB)] 
          FROM dbo.##FO ORDER BY ID ASC 
       COMPUTE SUM([Total(MB)]), SUM([Unused(MB)]), SUM([Used(MB)]), SUM([Index(MB)]), SUM([Data(MB)])
      END
  END

RETURN (0)

GO
EXEC sp_MS_Marksystemobject 'sp_dba_tb2' 
go
EXEC sp_MS_Marksystemobject 'sp_dba_tb3' 
go
EXEC sp_MS_Marksystemobject 'sp_dba_tb4' 
go
