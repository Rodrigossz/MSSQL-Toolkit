USE [master]
GO
/****** Object:  Database [master]    Script Date: 02/11/2012 12:30:16 ******/
CREATE DATABASE [master] ON  PRIMARY 
( NAME = N'master', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.DBPRODODS001\MSSQL\DATA\master.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10%)
 LOG ON 
( NAME = N'mastlog', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.DBPRODODS001\MSSQL\DATA\mastlog.ldf' , SIZE = 3136KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10%)
GO
ALTER DATABASE [master] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [master].[dbo].[sp_fulltext_database] @action = 'disable'
end
GO
ALTER DATABASE [master] SET ANSI_NULL_DEFAULT OFF
GO
ALTER DATABASE [master] SET ANSI_NULLS OFF
GO
ALTER DATABASE [master] SET ANSI_PADDING OFF
GO
ALTER DATABASE [master] SET ANSI_WARNINGS OFF
GO
ALTER DATABASE [master] SET ARITHABORT OFF
GO
ALTER DATABASE [master] SET AUTO_CLOSE OFF
GO
ALTER DATABASE [master] SET AUTO_CREATE_STATISTICS ON
GO
ALTER DATABASE [master] SET AUTO_SHRINK OFF
GO
ALTER DATABASE [master] SET AUTO_UPDATE_STATISTICS ON
GO
ALTER DATABASE [master] SET CURSOR_CLOSE_ON_COMMIT OFF
GO
ALTER DATABASE [master] SET CURSOR_DEFAULT  GLOBAL
GO
ALTER DATABASE [master] SET CONCAT_NULL_YIELDS_NULL OFF
GO
ALTER DATABASE [master] SET NUMERIC_ROUNDABORT OFF
GO
ALTER DATABASE [master] SET QUOTED_IDENTIFIER OFF
GO
ALTER DATABASE [master] SET RECURSIVE_TRIGGERS OFF
GO
ALTER DATABASE [master] SET  DISABLE_BROKER
GO
ALTER DATABASE [master] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO
ALTER DATABASE [master] SET DATE_CORRELATION_OPTIMIZATION OFF
GO
ALTER DATABASE [master] SET TRUSTWORTHY OFF
GO
ALTER DATABASE [master] SET ALLOW_SNAPSHOT_ISOLATION ON
GO
ALTER DATABASE [master] SET PARAMETERIZATION SIMPLE
GO
ALTER DATABASE [master] SET READ_COMMITTED_SNAPSHOT OFF
GO
ALTER DATABASE [master] SET HONOR_BROKER_PRIORITY OFF
GO
ALTER DATABASE [master] SET  READ_WRITE
GO
ALTER DATABASE [master] SET RECOVERY SIMPLE
GO
ALTER DATABASE [master] SET  MULTI_USER
GO
ALTER DATABASE [master] SET PAGE_VERIFY CHECKSUM
GO
ALTER DATABASE [master] SET DB_CHAINING ON
GO
/****** Object:  User [PSAFE\Servico_SQL]    Script Date: 02/11/2012 12:30:16 ******/
CREATE USER [PSAFE\Servico_SQL] FOR LOGIN [PSAFE\Servico_SQL] WITH DEFAULT_SCHEMA=[PSAFE\Servico_SQL]
GO
/****** Object:  User [##MS_PolicyEventProcessingLogin##]    Script Date: 02/11/2012 12:30:16 ******/
CREATE USER [##MS_PolicyEventProcessingLogin##] FOR LOGIN [##MS_PolicyEventProcessingLogin##] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [##MS_AgentSigningCertificate##]    Script Date: 02/11/2012 12:30:16 ******/
CREATE USER [##MS_AgentSigningCertificate##] FOR LOGIN [##MS_AgentSigningCertificate##]
GO
/****** Object:  Schema [PSAFE\Servico_SQL]    Script Date: 02/11/2012 12:30:16 ******/
CREATE SCHEMA [PSAFE\Servico_SQL] AUTHORIZATION [PSAFE\Servico_SQL]
GO
/****** Object:  UserDefinedDataType [dbo].[tdSmallDesc]    Script Date: 02/11/2012 12:30:17 ******/
CREATE TYPE [dbo].[tdSmallDesc] FROM [varchar](100) NULL
GO
/****** Object:  UserDefinedDataType [dbo].[tdSecret]    Script Date: 02/11/2012 12:30:17 ******/
CREATE TYPE [dbo].[tdSecret] FROM [varchar](100) NULL
GO
/****** Object:  UserDefinedDataType [dbo].[tdObs]    Script Date: 02/11/2012 12:30:17 ******/
CREATE TYPE [dbo].[tdObs] FROM [varchar](8000) NOT NULL
GO
/****** Object:  UserDefinedDataType [dbo].[tdHwGuId]    Script Date: 02/11/2012 12:30:17 ******/
CREATE TYPE [dbo].[tdHwGuId] FROM [varchar](36) NULL
GO
/****** Object:  UserDefinedDataType [dbo].[tdEmail]    Script Date: 02/11/2012 12:30:17 ******/
CREATE TYPE [dbo].[tdEmail] FROM [varchar](100) NULL
GO
/****** Object:  UserDefinedDataType [dbo].[tdDesc]    Script Date: 02/11/2012 12:30:17 ******/
CREATE TYPE [dbo].[tdDesc] FROM [varchar](1000) NULL
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_autokill]    Script Date: 02/11/2012 12:30:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_dba_autokill]
@tempo int = 7
as
begin
declare @procs table (spid int primary key)
insert @procs
select distinct spid from master..sysprocesses a where 
a.status = 'sleeping' and
a.cmd = 'AWAITING COMMAND' and
a.lastwaittype <> 'WRITELOG' and
DATEDIFF(mi  , a.last_batch,GETDATE()) >= @tempo

if @@ROWCOUNT = 0
return

declare @min int, @max int, @parm nvarchar(40)

select @min = MIN(spid), @max =max(spid) from @procs

while @min <= @max
begin
select 'Matando: ',@min

select @parm = N'Kill '+ convert(nvarchar(6),@min)
exec sp_executesql @parm    
select @min = MIN(spid)  from @procs where spid > @min
end
end
GO
/****** Object:  StoredProcedure [dbo].[sp_db_tb2]    Script Date: 02/11/2012 12:30:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_db_tb2]
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
/****** Object:  Table [dbo].[prodver]    Script Date: 02/11/2012 12:30:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[prodver](
	[index] [int] NULL,
	[Name] [nvarchar](50) NULL,
	[Internal_value] [int] NULL,
	[Charcater_Value] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dbaWaitTypes]    Script Date: 02/11/2012 12:30:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dbaWaitTypes](
	[waitType] [varchar](50) NOT NULL,
	[waitDesc] [varchar](400) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[waitType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dba_IndexWorkToDo]    Script Date: 02/11/2012 12:30:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dba_IndexWorkToDo](
	[DBID] [smallint] NULL,
	[Data] [datetime] NOT NULL,
	[objectid] [int] NULL,
	[objectName] [sysname] NULL,
	[indexid] [int] NULL,
	[partitionnum] [int] NULL,
	[frag] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_fragmentation]    Script Date: 02/11/2012 12:30:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_dba_fragmentation]
as
begin
declare @db nvarchar(200) = db_name()
declare @SQL nvarchar(4000) =  '
SELECT distinct
    OBJECT_SCHEMA_NAME(FRAG.[object_id]) , OBJECT_NAME(FRAG.[object_id]),
    SIX.[name],    FRAG.avg_fragmentation_in_percent,    FRAG.page_count
FROM
    sys.dm_db_index_physical_stats
    (
        DB_ID(),    --use the currently connected database
        0,          --Parameter for object_id.
        DEFAULT,    --Parameter for index_id.
        0,          --Parameter for partition_number.
        DEFAULT     --Scanning mode. Default to "LIMITED", which is good enough
    ) FRAG
    JOIN '+@db+'.sys.indexes SIX ON FRAG.[object_id] = SIX.[object_id] AND FRAG.index_id = SIX.index_id
WHERE
FRAG.index_type_desc <> ''HEAP''
ORDER BY
    FRAG.avg_fragmentation_in_percent DESC'
EXEC sp_executeSQL @SQL
end;
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_estspace]    Script Date: 02/11/2012 12:30:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_dba_estspace] as
begin

set nocount on
--create table #Result (tab sysname  collate database_default, )
declare @db nvarchar(200) = db_name()
declare @SQL nvarchar(4000) ='
SELECT ob.name [Table Name], convert(dec(8,2),sum(convert(dec(8,2),col.max_length))/1024) as MaxLenght_MB
from '+@db+'.sys.tables ob join '+@db+'.sys.columns col on ob.object_id = col.object_id group by ob.name';
EXEC sp_executeSQL @SQL; 
end
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_ErrorLogFull]    Script Date: 02/11/2012 12:30:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROC [dbo].[sp_dba_ErrorLogFull]( 
   @p1     INT = 0, 
   @p2     INT = NULL, 
   @p3     VARCHAR(255) = NULL, 
   @p4     VARCHAR(255) = NULL) 
AS 
BEGIN 

--This procedure takes four parameters:
--1) Value of error log file you want to read: 0 = current, 1 = Archive #1, 2 = Archive #2, etc...
--2) Log file type: 1 or NULL = error log, 2 = SQL Agent log
--3) Search string 1: String one you want to search for
--4) Search string 2: String two you want to search for to further refine the results


   IF (NOT IS_SRVROLEMEMBER(N'securityadmin') = 1) 
   BEGIN 
      RAISERROR(15003,-1,-1, N'securityadmin') 
      RETURN (1) 
   END 
    
   IF (@p2 IS NULL) 
       EXEC xp_readerrorlog @p1 
   ELSE 
       EXEC xp_readerrorlog @p1,@p2,@p3,@p4 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_Delete_Files_By_Date]    Script Date: 02/11/2012 12:30:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_dba_Delete_Files_By_Date] (@SourceDir varchar(1024), @SourceFile varchar(512), @DaysToKeep int)
-- EXEC Admin.dbo.usp_Admin_Delete_Files_By_Date @SourceDir = '\\FooServer\BarShare\'
-- , @SourceFile = 'FooFile_*'
-- , @DaysToKeep = 3

AS

/******************************************************************************
**
**Name: usp_Admin_Delete_Files_By_Date.sql
**
**Description: Delete files older than X-days based on path & extension.
**
**Depending on the output from xp_msver, we will execute either a
**Windows 2000 or Windows 2003 specific INSERT INTO #_File_Details_02
**operation as there is a small difference in the FOR output between
**Windows 2000 and 2003 (Operating system versions).
**
**Return values: 0 - Success
**-1 - Error
**
**Author: G. Rayburn
**
**Date: 03/26/2007
**
**Depends on: xp_cmdshell access to @SourceDir via SQLAgent account.
**
*******************************************************************************
**Modification History
*******************************************************************************
**
**Initial Creation: 03/26/2007 G. Rayburn
**
*******************************************************************************
**
******************************************************************************/
SET NOCOUNT ON

DECLARE @CurrentFileDate char(10)
, @OldFileDate char(10)
, @SourceDirFOR varchar(255)
, @FileName varchar(512)
, @DynDelete varchar(512)
, @ProcessName varchar(150)
, @OSVersion decimal(3,1)
, @Error int


SET @ProcessName = 'usp_Admin_Delete_Files_By_Date - [' + @SourceFile + ']'
SET @CurrentFileDate = CONVERT(char(10),getdate(),121)
SET @OldFileDate = CONVERT(char(10),DATEADD(dd,-@DaysToKeep,@CurrentFileDate),121)
SET @SourceDirFOR = 'FOR %I IN ("' + @SourceDir + @SourceFile + '") DO @ECHO %~nxtI'
SET @Error = 0


-- Get Windows OS Version info for proper OSVer statement block exec.
CREATE TABLE #_OSVersion
( [Index] int
, [Name] varchar(255)
, [Internal_Value] varchar(255)
, [Character_Value] varchar(255) )

INSERT INTO #_OSVersion
EXEC master..xp_msver 'WindowsVersion'

SET @OSVersion = (SELECT SUBSTRING([Character_Value],1,3) FROM #_OSVersion)



-- Start temp table population(s).
CREATE TABLE #_File_Details_01
( Ident int IDENTITY(1,1)
, Output varchar(512) )

INSERT INTO #_File_Details_01
EXEC master..xp_cmdshell @SourceDirFOR

CREATE TABLE #_File_Details_02
(Ident int
, [TimeStamp] datetime
, [FileName] varchar(255) )


-- OS Version specifics.
IF @OSVersion = '5.0'
BEGIN -- Exec Windows 2000 version.
INSERT INTO #_File_Details_02
SELECT Ident
, CONVERT(datetime, LEFT(CAST(SUBSTRING([Output],1,8) AS datetime),12)) AS [TimeStamp]
, SUBSTRING([Output],17,255) AS [FileName]
FROM #_File_Details_01

WHERE [Output] IS NOT NULL
ORDER BY Ident
END

IF @OSVersion = '5.2'
BEGIN -- Exec Windows 2003 version.
INSERT INTO #_File_Details_02
SELECT Ident
, CONVERT(char(10), SUBSTRING([Output],1,10), 121) AS [TimeStamp]
, SUBSTRING([Output],21,255) AS [FileName]
FROM #_File_Details_01

WHERE [Output] IS NOT NULL
ORDER BY Ident
END



-- Start delete ops cursor.
DECLARE curDelFile CURSOR
READ_ONLY
FOR

SELECT [FileName]
FROM #_File_Details_02
WHERE [TimeStamp] <= @OldFileDate

OPEN curDelFile

FETCH NEXT FROM curDelFile INTO @FileName
WHILE (@@fetch_status <> -1)
BEGIN
IF (@@fetch_status <> -2)
BEGIN

SET @DynDelete = 'DEL /Q/S "' + @SourceDir + @FileName + '"'

EXEC master..xp_cmdshell @DynDelete

END
FETCH NEXT FROM curDelFile INTO @FileName
END

CLOSE curDelFile
DEALLOCATE curDelFile

DROP TABLE #_OSVersion
DROP TABLE #_File_Details_01
DROP TABLE #_File_Details_02
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_dbUSe]    Script Date: 02/11/2012 12:30:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_dba_dbUSe]
as
WITH agg AS
(
    SELECT
        last_user_seek,
        last_user_scan,
        last_user_lookup,
        last_user_update,
        database_id
    FROM
        sys.dm_db_index_usage_stats
)
SELECT
    database_id = convert(char(40),db_name(database_id)),
    last_read   = MAX(last_read),
    last_write  = MAX(last_write)
FROM
(
    SELECT last_user_seek, NULL, database_id FROM agg
    UNION ALL
    SELECT last_user_scan, NULL, database_id FROM agg
    UNION ALL
    SELECT last_user_lookup, NULL, database_id FROM agg
    UNION ALL
    SELECT NULL, last_user_update, database_id FROM agg
) AS x (last_read, last_write, database_id)
GROUP BY db_name(database_id)
ORDER BY last_read, last_write;
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_DataCompress]    Script Date: 02/11/2012 12:30:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_dba_DataCompress]
as

SET NOCOUNT ON;

IF OBJECT_ID(N'tempdb..#Results') IS NOT NULL
DROP TABLE #Results

IF OBJECT_ID(N'tempdb..#Cur') IS NOT NULL
DROP TABLE #Cur


DECLARE @SQL NVARCHAR(4000) 
DECLARE @Schema SYSNAME  
DECLARE @Table SYSNAME  
DECLARE @PartitionNumber INT;
declare @db sysname = ltrim(rtrim(db_name()))

create table #Cur (sch sysname  collate database_default, tab sysname  collate database_default)

CREATE TABLE #Results (
 [Table] SYSNAME  collate database_default,
 [Schema] SYSNAME  collate database_default,
 IndexID INT,
 PartitionNumber INT,
 [CurrentSize(kb)] INT,
 [CompressedSize(kb)] INT,
 [SampleCurrentSize(kb)] INT,
 [SampleCompressedSize(kb)] INT)

 SET @SQL =  '
INSERT INTO #Cur 
select s.name, o.name FROM '+@db+'.sys.objects o JOIN '+ @db+'.sys.schemas s 
ON s.schema_id = o.schema_id WHERE o.[type] = ''U'';'
EXEC sp_executeSQL @SQL; 
--select @SQL
--select * from #Cur
--return

DECLARE TableCursor CURSOR FOR
select sch, tab
FROM #Cur
ORDER BY 1,2

OPEN TableCursor;
FETCH NEXT FROM TableCursor INTO @Schema,@Table
WHILE @@FETCH_STATUS = 0 
 BEGIN
  SET @SQL = '
 INSERT INTO #Results 
 ([Table],[Schema],IndexID,PartitionNumber,[CurrentSize(kb)],[CompressedSize(kb)],[SampleCurrentSize(kb)],[SampleCompressedSize(kb)]) 
 EXEC sp_estimate_data_compression_savings ''' + @Schema + ''',''' + @Table + ''',NULL,NULL,''ROW'';';
  --PRINT @SQL;
 EXEC sp_executeSQL @SQL; 
 FETCH NEXT FROM TableCursor INTO @Schema,@Table;
 END;
CLOSE TableCursor;
DEALLOCATE TableCursor;

DECLARE CompressionCursor CURSOR FOR
 SELECT [Schema], [Table], MAX(PartitionNumber) PartitionNumber
 FROM #Results r
 WHERE (IndexID = 0
 OR IndexID = 1  AND  EXISTS (Select 'x' FROM #Results r2 where r.[Schema] = r2.[Schema] and r.[Table] = r2.[Table] and r2.IndexID = 0))
 AND (ROUND(CASE WHEN [CurrentSize(kb)] = 0 THEN 100 ELSE [CompressedSize(kb)] * 100. / [CurrentSize(kb)] END,2) BETWEEN 0.01 AND 80.00)
 AND [CurrentSize(kb)] > 64
 GROUP BY [Schema], [Table]
 ORDER BY 1,2;

if @@CURSOR_ROWS = 0
begin
select 'Nada para comprimir.'
DROP TABLE #Results
DROP TABLE #CUR
return
end

OPEN CompressionCursor;

FETCH NEXT FROM CompressionCursor INTO @Schema, @Table, @PartitionNumber;


WHILE @@FETCH_STATUS = 0 
 BEGIN
 select @Table
 SET @SQL = CASE WHEN EXISTS (SELECT * FROM #Results WHERE [Schema] = @Schema AND [Table] = @Table AND PartitionNumber > 1) THEN 'ALTER TABLE ' + @Schema + '.' + @Table + ' REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = ROW,ONLINE = ON);'
 ELSE 'ALTER TABLE ' + @Schema + '.' + @Table + ' REBUILD WITH (DATA_COMPRESSION = ROW,ONLINE = ON);' END;
 PRINT @SQL;
-- EXEC sp_executeSQL @SQL; 
 FETCH NEXT FROM CompressionCursor INTO @Schema,@Table,@PartitionNumber;
 END;
CLOSE CompressionCursor;
DEALLOCATE CompressionCursor;
IF OBJECT_ID(N'tempdb..#Results') IS NOT NULL
DROP TABLE #Results
DROP TABLE #CUR
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_counters]    Script Date: 02/11/2012 12:30:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_dba_counters]
as
begin
set nocount on
DECLARE @CounterPrefix NVARCHAR(30)
SET @CounterPrefix = CASE
    WHEN @@SERVICENAME = 'MSSQLSERVER'
    THEN 'SQLServer:'
    ELSE 'MSSQL$'+@@SERVICENAME+':'
    END;


-- Capture the first counter set
SELECT CAST(1 AS INT) AS collection_instance ,
      [OBJECT_NAME] ,
      counter_name ,
      instance_name ,
      cntr_value ,
      cntr_type ,
      CURRENT_TIMESTAMP AS collection_time
INTO #perf_counters_init
FROM sys.dm_os_performance_counters
WHERE ( OBJECT_NAME = @CounterPrefix+'Access Methods'
         AND counter_name = 'Full Scans/sec'
      )
      OR ( OBJECT_NAME = @CounterPrefix+'Access Methods'
           AND counter_name = 'Index Searches/sec'
      )
      OR ( OBJECT_NAME = @CounterPrefix+'Buffer Manager'
           AND counter_name = 'Lazy Writes/sec'
      )
      OR ( OBJECT_NAME = @CounterPrefix+'Buffer Manager'
      AND counter_name = 'Page life expectancy'
      )
      OR ( OBJECT_NAME = @CounterPrefix+'General Statistics'
           AND counter_name = 'Processes Blocked'
      )
      OR ( OBJECT_NAME = @CounterPrefix+'General Statistics'
           AND counter_name = 'User Connections'
      )
      OR ( OBJECT_NAME = @CounterPrefix+'Locks'
           AND counter_name = 'Lock Waits/sec'
      )
      OR ( OBJECT_NAME = @CounterPrefix+'Locks'
           AND counter_name = 'Lock Wait Time (ms)'
      )
      OR ( OBJECT_NAME = @CounterPrefix+'SQL Statistics'
           AND counter_name = 'SQL Re-Compilations/sec'
      )
      OR ( OBJECT_NAME = @CounterPrefix+'Memory Manager'
           AND counter_name = 'Memory Grants Pending'
      )
      OR ( OBJECT_NAME = @CounterPrefix+'SQL Statistics'
           AND counter_name = 'Batch Requests/sec'
      )
      OR ( OBJECT_NAME = @CounterPrefix+'SQL Statistics'
           AND counter_name = 'SQL Compilations/sec'
)

-- Wait on Second between data collection
WAITFOR DELAY '00:00:01'

-- Capture the second counter set
SELECT CAST(2 AS INT) AS collection_instance ,
       OBJECT_NAME ,
       counter_name ,
       instance_name ,
       cntr_value ,
       cntr_type ,
       CURRENT_TIMESTAMP AS collection_time
INTO #perf_counters_second
FROM sys.dm_os_performance_counters
WHERE ( OBJECT_NAME = @CounterPrefix+'Access Methods'
      AND counter_name = 'Full Scans/sec'
      )
      OR ( OBJECT_NAME = @CounterPrefix+'Access Methods'
           AND counter_name = 'Index Searches/sec'
      )
      OR ( OBJECT_NAME = @CounterPrefix+'Buffer Manager'
           AND counter_name = 'Lazy Writes/sec'
      )
      OR ( OBJECT_NAME = @CounterPrefix+'Buffer Manager'
           AND counter_name = 'Page life expectancy'
      )
      OR ( OBJECT_NAME = @CounterPrefix+'General Statistics'
           AND counter_name = 'Processes Blocked'
      )
      OR ( OBJECT_NAME = @CounterPrefix+'General Statistics'
           AND counter_name = 'User Connections'
      )
      OR ( OBJECT_NAME = @CounterPrefix+'Locks'
           AND counter_name = 'Lock Waits/sec'
      )
      OR ( OBJECT_NAME = @CounterPrefix+'Locks'
           AND counter_name = 'Lock Wait Time (ms)'
      )
      OR ( OBJECT_NAME = @CounterPrefix+'SQL Statistics'
           AND counter_name = 'SQL Re-Compilations/sec'
      )
      OR ( OBJECT_NAME = @CounterPrefix+'Memory Manager'
           AND counter_name = 'Memory Grants Pending'
      )
      OR ( OBJECT_NAME = @CounterPrefix+'SQL Statistics'
           AND counter_name = 'Batch Requests/sec'
      )
      OR ( OBJECT_NAME = @CounterPrefix+'SQL Statistics'
           AND counter_name = 'SQL Compilations/sec'
)

-- Calculate the cumulative counter values
SELECT  i.OBJECT_NAME ,
        i.counter_name ,
        i.instance_name ,
        CASE WHEN i.cntr_type = 272696576
          THEN s.cntr_value - i.cntr_value
          WHEN i.cntr_type = 65792 THEN s.cntr_value
        END AS cntr_value
FROM #perf_counters_init AS i
  JOIN  #perf_counters_second AS s
    ON i.collection_instance + 1 = s.collection_instance
      AND i.OBJECT_NAME = s.OBJECT_NAME
      AND i.counter_name = s.counter_name
      AND i.instance_name = s.instance_name
ORDER BY OBJECT_NAME

-- Cleanup tables
DROP TABLE #perf_counters_init
DROP TABLE #perf_counters_second 
end
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_cachePlan]    Script Date: 02/11/2012 12:30:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_dba_cachePlan]
as
set nocount on
SELECT objtype AS 'Cached Object Type', 
  COUNT(*) AS 'Numberof Plans', 
  SUM(CAST(size_in_bytes AS BIGINT))/1048576 AS 'Plan Cache SIze (MB)', 
  AVG(usecounts) AS 'Avg Use Counts' 
FROM sys.dm_exec_cached_plans 
GROUP BY objtype  
ORDER BY objtype
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_cachedPlan]    Script Date: 02/11/2012 12:30:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_dba_cachedPlan] @proc sysname
as
set nocount on
SELECT plan_handle, query_plan, objtype, dbid, objectid 
FROM sys.dm_exec_cached_plans cp
CROSS APPLY sys.dm_exec_query_plan(cp.plan_handle)
WHERE objtype = 'Proc'
AND OBJECT_NAME(objectid, dbid) = @proc;


--sp_dba_cachedPlan 'sp_dba_proc'
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_cached_plans]    Script Date: 02/11/2012 12:30:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_dba_cached_plans]
as
SELECT top 10 st.text QueryText, usecounts
FROM sys.dm_exec_cached_plans 
CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS st
--WHERE text LIKE N'%uspPrintError%'
order by 2 desc
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_job2]    Script Date: 02/11/2012 12:30:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_dba_job2]
as
exec msdb..sp_dba_job2
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_job]    Script Date: 02/11/2012 12:30:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_dba_job] as
begin
set nocount on
exec msdb..sp_dba_job
end
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_io]    Script Date: 02/11/2012 12:30:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_dba_io]
as
set nocount on
begin


declare @grupos table (banco varchar(30), groupname varchar(30), groupid int)

insert @grupos 
--select 'ozdb_hist' ,groupname, groupid  from ozdb_hist..sysfilegroups union
select 'tempdb' ,groupname, groupid  from tempdb..sysfilegroups union
select 'master' ,groupname, groupid  from master..sysfilegroups union
select 'model' ,groupname, groupid  from model..sysfilegroups; 
--select 'ozdb' ,groupname, groupid  from ozdb..sysfilegroups union
--select 'ipdb' ,groupname, groupid  from ipdb..sysfilegroups union
--select 'dbawork' ,groupname, groupid  from dbawork..sysfilegroups union
--select 'distribution' ,groupname, groupid  from distribution..sysfilegroups 


with IO_por_Banco as (
select db_name(database_id) as Banco,FILE_ID as fileid,
cast(sum(num_of_bytes_read + num_of_bytes_written) / 1048576 as decimal(12,2)) 
as IO_Total_MB,
cast(sum(num_of_bytes_read) / 1048576 as decimal(12,2)) as IO_Leitura_MB,
cast(sum(num_of_bytes_written) / 1048576 as decimal(12,2)) as IO_Escrita_MB
from sys.dm_io_virtual_file_stats(NULL,NULL) as dm
group by database_id,file_id)

select row_number() over (order by IO_Total_MB DESC) as Ranking,
B.banco,s.name, size/1024 as size_MB,upper(substring(filename,1,1)) as drive, 
isnull(substring(groupname,1,20),'LOG') as file_group,IO_Leitura_MB, IO_Escrita_MB,
IO_Total_MB, cast(IO_Total_MB / sum(IO_Total_MB) over() * 100 as decimal(5,2)) as Percentual
from IO_por_Banco b 
join master..sysaltfiles s on DB_NAME(s.dbid) = b.Banco and s.fileid = b.fileid
left outer join @grupos g on DB_NAME(s.dbid) = g.Banco and s.groupid = g.groupid
order by Ranking
end
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_indexCache]    Script Date: 02/11/2012 12:30:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_dba_indexCache] 
as
set nocount on
SELECT top 10 count(*)AS cached_pages_count 
    ,name ,index_id 
FROM sys.dm_os_buffer_descriptors AS bd 
    INNER JOIN 
    (
        SELECT object_name(object_id) AS name 
            ,index_id ,allocation_unit_id
        FROM sys.allocation_units AS au
            INNER JOIN sys.partitions AS p 
                ON au.container_id = p.hobt_id 
                    AND (au.type = 1 OR au.type = 3)
        UNION ALL
        SELECT object_name(object_id) AS name   
            ,index_id, allocation_unit_id
        FROM sys.allocation_units AS au
            INNER JOIN sys.partitions AS p 
                ON au.container_id = p.partition_id 
                    AND au.type = 2
    ) AS obj 
        ON bd.allocation_unit_id = obj.allocation_unit_id
WHERE database_id = db_id()
GROUP BY name, index_id 
ORDER BY cached_pages_count DESC


SELECT count(*)AS cached_pages_count
    ,CASE database_id 
        WHEN 32767 THEN 'ResourceDb' 
        ELSE db_name(database_id) 
        END AS Database_name
FROM sys.dm_os_buffer_descriptors
GROUP BY db_name(database_id) ,database_id
ORDER BY cached_pages_count DESC;
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_helpindex]    Script Date: 02/11/2012 12:30:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_dba_helpindex] 
    @objname NVARCHAR(776)        -- the table to check for indexes 
            AS 
    -- PRELIM 
    SET nocount ON 
DECLARE @objid INT,            -- the object id of the table 
    @indid smallint,    -- the index id of an index 
    @groupid INT,        -- the filegroup id of an index 
    @indname sysname, 
    @groupname sysname, 
    @status INT, 
    @keys NVARCHAR(2126),    --Length (16*max_identifierLength)+(15*2)+(16*3) 
    @include_cols NVARCHAR(2126), 
    @dbname    sysname, 
    @ignore_dup_key    bit, 
    @is_unique        bit, 
    @is_hypothetical    bit, 
    @is_primary_key    bit, 
    @is_unique_key    bit, 
    @auto_created    bit, 
    @no_recompute    bit 
    -- Check to see that the object names are local to the current database. 
SELECT @dbname = PARSENAME(@objname,3) 
IF @dbname IS NULL 
    SELECT @dbname = DB_NAME() 
ELSE  
IF @dbname <> DB_NAME() 
    BEGIN 
    RAISERROR(15250,-1,-1) 
    RETURN (1) 
    END 
    -- Check to see the the table exists and initialize @objid. 
SELECT @objid = OBJECT_ID(@objname) 
IF @objid IS NULL 
    BEGIN 
    RAISERROR(15009,-1,-1,@objname,@dbname) 
    RETURN (1) 
    END 
    -- OPEN CURSOR OVER INDEXES (skip stats: bug shiloh_51196)
DECLARE ms_crs_ind CURSOR local static FOR 
SELECT i.index_id, i.data_space_id, i.name, 
            i.ignore_dup_key, i.is_unique, i.is_hypothetical, i.is_primary_key, i.is_unique_constraint, 
            s.auto_created, s.no_recompute 
    FROM sys.indexes i JOIN sys.stats s 
            ON i.OBJECT_ID = s.OBJECT_ID  
        AND i.index_id = s.stats_id 
    WHERE i.OBJECT_ID = @objid 
OPEN ms_crs_ind 
            FETCH ms_crs_ind INTO @indid, @groupid, @indname, @ignore_dup_key, @is_unique, @is_hypothetical, 
    @is_primary_key, @is_unique_key, @auto_created, @no_recompute 
    -- IF NO INDEX, QUIT 
IF @@fetch_status < 0 
    BEGIN 
                DEALLOCATE ms_crs_ind 
    RAISERROR(15472,-1,-1,@objname) -- Object does not have any indexes. 
    RETURN (0) 
    END 
    -- create temp table 
CREATE TABLE #spindtab 
    ( 
                index_name            sysname    collate database_default NOT NULL, 
                index_id                INT, 
                ignore_dup_key        bit, 
                is_unique                bit, 
                is_hypothetical        bit, 
                is_primary_key        bit, 
                is_unique_key            bit, 
                auto_created            bit, 
                no_recompute            bit, 
                groupname            sysname collate database_default NULL, 
                index_keys            NVARCHAR(2126)    collate database_default NOT NULL, -- see @keys above for length descr 
                includes            NVARCHAR(2126)  collate database_default NOT NULL 
    ) 
    -- Now check out each index, figure out its type and keys and 
    -- save the info in a temporary table that we'll print out at the end. 
WHILE @@fetch_status >= 0 
    BEGIN 
        -- First we'll figure out what the keys are. 
    DECLARE @i INT, @thiskey NVARCHAR(131) -- 128+3 
    SELECT @keys = INDEX_COL(@objname, @indid, 1), @i = 2 
    IF (INDEXKEY_PROPERTY(@objid, @indid, 1, 'isdescending') = 1) 
        SELECT @keys = @keys  + '(-)' 
    SELECT @thiskey = INDEX_COL(@objname, @indid, @i) 
    IF ((@thiskey IS NOT NULL)  
                AND (INDEXKEY_PROPERTY(@objid, @indid, @i, 'isdescending') = 1)) 
        SELECT @thiskey = @thiskey + '(-)' 
    WHILE (@thiskey IS NOT NULL ) 
        BEGIN 
        SELECT @keys = @keys + ', ' + @thiskey, @i = @i + 1 
        SELECT @thiskey = INDEX_COL(@objname, @indid, @i) 
        IF ((@thiskey IS NOT NULL)  
                    AND (INDEXKEY_PROPERTY(@objid, @indid, @i, 'isdescending') = 1)) 
            SELECT @thiskey = @thiskey + '(-)' 
        END 
    SELECT @groupname = NULL 
SELECT @groupname = name  
        FROM sys.data_spaces  
        WHERE data_space_id = @groupid 
    DECLARE IncludeColsCursor CURSOR FOR 
    SELECT obj.name 
        FROM sys.index_columns AS col 
                INNER JOIN sys.syscolumns AS obj 
                ON col.OBJECT_ID = obj.id 
            AND col.column_id = obj.colid 
        WHERE is_included_column = 1 
            AND col.OBJECT_ID = @objid 
            AND col.index_id = @indid 
        ORDER BY col.index_column_id 
    OPEN IncludeColsCursor 
                FETCH IncludeColsCursor INTO @thiskey
        SET @include_cols = '' 
    WHILE @@FETCH_STATUS = 0 
        BEGIN 
            SET @include_cols = @include_cols + CASE WHEN @include_cols = '' THEN ''  
            ELSE ', ' END + @thiskey 
                    FETCH IncludeColsCursor INTO @thiskey 
        END 
                CLOSE IncludeColsCursor 
                DEALLOCATE IncludeColsCursor 
        -- INSERT ROW FOR INDEX 
    INSERT INTO #spindtab  
            VALUES (@indname, @indid, @ignore_dup_key, @is_unique, @is_hypothetical, 
            @is_primary_key, @is_unique_key, @auto_created, @no_recompute, @groupname, @keys, @include_cols) 
        -- Next index 
                FETCH ms_crs_ind INTO @indid, @groupid, @indname, @ignore_dup_key, @is_unique, @is_hypothetical, 
        @is_primary_key, @is_unique_key, @auto_created, @no_recompute 
    END 
            DEALLOCATE ms_crs_ind 
    -- DISPLAY THE RESULTS 
SELECT 
    'index_name' = index_name, 
    'index_description' = CONVERT(VARCHAR(210), --bits 16 off, 1, 2, 16777216 on, located on group 
        CASE WHEN index_id = 1 THEN 'clustered'  
        ELSE 'nonclustered' END 
                + CASE WHEN ignore_dup_key <>0 THEN ', ignore duplicate keys'  
        ELSE '' END 
                + CASE WHEN is_unique <>0 THEN ', unique'  
        ELSE '' END 
                + CASE WHEN is_hypothetical <>0 THEN ', hypothetical'  
        ELSE '' END 
                + CASE WHEN is_primary_key <>0 THEN ', primary key'  
        ELSE '' END 
                + CASE WHEN is_unique_key <>0 THEN ', unique key'  
        ELSE '' END 
                + CASE WHEN auto_created <>0 THEN ', auto create'  
        ELSE '' END 
                + CASE WHEN no_recompute <>0 THEN ', stats no recompute'  
        ELSE '' END 
                + ' located on ' + groupname), 
    'index_keys' = index_keys, 
    'include_cols' = includes 
    FROM #spindtab 
    ORDER BY index_name 
RETURN (0) -- sp_dba_helpindex
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_helpdb]    Script Date: 02/11/2012 12:30:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_dba_helpdb]
as
SELECT d.name as Dbname,p.name as Owner,  collation_name,
       DATABASEPROPERTYEX(d.name, 'Recovery') as Recovery, 
       DATABASEPROPERTYEX(d.name, 'Status') as Status,
       DATABASEPROPERTYEX(d.name, 'IsAutoUpdateStatistics') as AutoUpdateStats,       
       d.is_auto_update_stats_async_on as AutoUpdateStatsAsync,       
       DATABASEPROPERTYEX(d.name, 'Updateability') as Updateability,
       DATABASEPROPERTYEX(d.name, 'UserAccess') as UserAccess,
       DATABASEPROPERTYEX(d.name, 'IsAutoShrink') as IsAutoShrink,
       d.is_cdc_enabled
FROM   sys.databases d join sys.database_principals p on d.owner_sid = p.sid
ORDER BY 1
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_help]    Script Date: 02/11/2012 12:30:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[sp_dba_help] as
--select 'Master','select 'Master','''+name+'',''''from sys.objects where type = 'p'and name like 'sp_dba%'order by 1
set nocount on

;with DBA_PROCS as (
select 'Master' as Db,'sp_dba_autokill'as Nome,'Mata qq processo parado prendendo outros'as Help union
select 'Master','sp_dba_AuthenticationMode','Mostra o Authentication Mode do SQL' union
select 'Master','sp_dba_bkp','Analisa espaço em disco e os tamanhos de database, bkp, etc' union
select 'Master','sp_dba_BkpMissing','Mostra databases sem Bkp' union
select 'Master','sp_dba_cached_plans','Comandos mais executados' union
select 'Master','sp_dba_cachePlan','Consumo de Cache por tipo de comando / Objeto' union
select 'Master','sp_dba_CheckMail','Mostra envios de email com problema nas últimas 24 horas' union
select 'Master','sp_dba_ErrorLog','Lista o que há de crítico no errorlog' union
select 'Master','sp_dba_ErrorLogFull','Lista todo o errorlog' union
select 'Master','sp_dba_Help','Help das proc' union
select 'Master','sp_dba_Helpdb','Lista os databases de forma mais objetiva, com detalhes importantes' union
select 'Master','sp_dba_identity','Tabelas com campo identity e o risco de estourar o limite do campo' union
select 'Master','sp_dba_indexCache','Uso de cache por índice e por database' union
select 'Master','sp_dba_indexUsage','Lista de índices com uso' union
select 'Master','sp_dba_io','Size e Disk Time por datafile' union
select 'Master','sp_dba_ix','Lista os índices do database atual' union
select 'Master','sp_dba_job','Chama a sp_dba_job do msdb. Status e duração dos jobs' union
select 'Master','sp_dba_JobsOutput','Forma de output de cada step de cada job' union
select 'Master','sp_dba_kill','Mata um processo ou todos q estiverem num database' union
select 'Master','sp_dba_lock','Análise completa dos locks atuais do servidor' union
select 'Master','sp_dba_monitor','Checkup completo do servidor' union
select 'Master','sp_dba_monitorLS','Status do Log shipping' union
select 'Master','sp_dba_network','Sql Server Network configurations' union
select 'Master','sp_dba_osbufferdescriptors_agg','Descriptors do Cache' union
select 'Master','sp_dba_OverlapRole','users com sobreposição de roles' union
select 'Master','sp_dba_pr','Lista as procs do database atual' union
select 'Master','sp_dba_Proc','Processos ativos no sql c/ Comando atual' union
select 'Master','sp_dba_Proc2','Processos ativos no sql c/ Comando atual - LIGHT' union
select 'Master','sp_dba_proc3','Processos ativos no sql c/ Comando anterior' union
select 'Master','sp_dba_role','Security roles do servidor' union
select 'Master','sp_dba_SearchCachedPlans','Missing statistics and indexes, Scans' union
select 'Master','sp_dba_startup','Comandos do DBA executados a cada restart do SQL' union
select 'Master','sp_dba_string','Procura uma string no create de todos os objetos de todos os databases' union
select 'Master','sp_dba_tb','Lista as user tables do database atual' union
select 'Master','sp_dba_tbUse','Estatísticas de uso para tabelas e índices do database atual: lookups, seeks, scans, etc' union
select 'Master','sp_dba_version','Versão atual do BD' union
select 'Master','sp_dba_vw','Lista as user views do database atual' union
select 'Master','sp_dba_wait','Análise de processos demorando: % do wait time por wait type' union
select 'Master','sp_dba_wait2','Análise de processos demorando: % do wait time por wait type' union
select 'Master','sp_dba_wait3','Análise de processos demorando: % do wait time por wait type' union
select 'Master','sp_dba_estspace','Estima o tamanho máximo de cada tabela do database, para uma linha.'  union
select 'Master','sp_dba_XEvent','Lista os Extended Events de monitoramento'  union
select 'Msdb','sp_dba_get_composite_job_info','Ajuda a sp_dba_job do msdb'  union
select 'Msdb','sp_dba_job','Status e duração dos jobs' )

select h.Db, p.name as nome, help 
from Master.sys.procedures p left outer join DBA_PROCS h on p.name = h.Nome
where name like 'sp_dba_%' and db = 'Master' union
select  Db, p.name as nome, help 
from msdb.sys.procedures p left outer join DBA_PROCS h on p.name = h.Nome
where name like 'sp_dba_%' and db = 'Msdb'
order by 1
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_GetMetrics]    Script Date: 02/11/2012 12:30:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_dba_GetMetrics]

AS

SET NOCOUNT ON;

 

-- Variables for Counters

DECLARE @BatchRequestsPerSecond BIGINT;

DECLARE @CompilationsPerSecond BIGINT;

DECLARE @ReCompilationsPerSecond BIGINT;

DECLARE @LockWaitsPerSecond BIGINT;

DECLARE @PageSplitsPerSecond BIGINT;

DECLARE @CheckpointPagesPerSecond BIGINT;

 

-- Variable for date

DECLARE @stat_date DATETIME;

 

-- Table for First Sample

DECLARE @RatioStatsX TAbLE(

       [object_name] varchar(128)

      ,[counter_name] varchar(128)

      ,[instance_name] varchar(128)

      ,[cntr_value] bigint

      ,[cntr_type] int

      )

 

-- Table for Second Sample

DECLARE @RatioStatsY TABLE(

       [object_name] VARCHAR(128)

      ,[counter_name] VARCHAR(128)

      ,[instance_name] VARCHAR(128)

      ,[cntr_value] BIGINT

      ,[cntr_type] INT

      );

 

-- Capture stat time

SET @stat_date = getdate();

 

INSERT INTO @RatioStatsX (

     [object_name]

      ,[counter_name]

      ,[instance_name]

      ,[cntr_value]

      ,[cntr_type] )

      SELECT [object_name]

            ,[counter_name]

            ,[instance_name]

            ,[cntr_value]

            ,[cntr_type] FROM sys.dm_os_performance_counters;

 

-- Capture each per second counter for first sampling

SELECT TOP 1 @BatchRequestsPerSecond = cntr_value

      FROM @RatioStatsX

    WHERE counter_name = 'Batch Requests/sec'

      AND object_name LIKE '%SQL Statistics%';

 

SELECT TOP 1 @CompilationsPerSecond = cntr_value

      FROM @RatioStatsX

    WHERE counter_name = 'SQL Compilations/sec'

      AND object_name LIKE '%SQL Statistics%';

 

SELECT TOP 1 @ReCompilationsPerSecond = cntr_value

      FROM @RatioStatsX

    WHERE counter_name = 'SQL Re-Compilations/sec'

      AND object_name LIKE '%SQL Statistics%';

 

SELECT TOP 1 @LockWaitsPerSecond = cntr_value

      FROM @RatioStatsX

    WHERE counter_name = 'Lock Waits/sec'

      AND instance_name = '_Total'

      AND object_name LIKE '%Locks%';

 

SELECT TOP 1 @PageSplitsPerSecond = cntr_value

      FROM @RatioStatsX

    WHERE counter_name = 'Page Splits/sec'

      AND object_name LIKE '%Access Methods%'; 

 

SELECT TOP 1 @CheckpointPagesPerSecond = cntr_value

      FROM @RatioStatsX

      WHERE counter_name = 'Checkpoint Pages/sec'

        AND object_name LIKE '%Buffer Manager%';                                         

 

WAITFOR DELAY '00:00:01'

 

-- Table for second sample

INSERT INTO @RatioStatsY (

            [object_name]

            ,[counter_name]

            ,[instance_name]

            ,[cntr_value]

            ,[cntr_type] )

   SELECT [object_name]

            ,[counter_name]

            ,[instance_name]

            ,[cntr_value]

            ,[cntr_type] FROM sys.dm_os_performance_counters

 

SELECT (a.cntr_value * 1.0 / b.cntr_value) * 100.0 [BufferCacheHitRatio]

      ,c.cntr_value  AS [PageLifeExpectency]

      ,d.[BatchRequestsPerSecond]

      ,e.[CompilationsPerSecond]

      ,f.[ReCompilationsPerSecond]

      ,g.cntr_value AS [UserConnections]

      ,h.LockWaitsPerSecond 

      ,i.PageSplitsPerSecond

      ,j.cntr_value AS [ProcessesBlocked]

      ,k.CheckpointPagesPerSecond

      ,GETDATE() AS StatDate                                     

FROM (SELECT * FROM @RatioStatsY

               WHERE counter_name = 'Buffer cache hit ratio'

               AND object_name LIKE '%Buffer Manager%') a  

     CROSS JOIN  

      (SELECT * FROM @RatioStatsY

                WHERE counter_name = 'Buffer cache hit ratio base'

                AND object_name LIKE '%Buffer Manager%') b    

     CROSS JOIN

      (SELECT * FROM @RatioStatsY

                WHERE counter_name = 'Page life expectancy '

                AND object_name LIKE '%Buffer Manager%') c

     CROSS JOIN

     (SELECT (cntr_value - @BatchRequestsPerSecond) /

                     (CASE WHEN datediff(ss,@stat_date, getdate()) = 0

                           THEN  1

                           ELSE datediff(ss,@stat_date, getdate()) END) AS [BatchRequestsPerSecond]

                FROM @RatioStatsY

                WHERE counter_name = 'Batch Requests/sec'

                AND object_name LIKE '%SQL Statistics%') d   

     CROSS JOIN

     (SELECT (cntr_value - @CompilationsPerSecond) /

                     (CASE WHEN datediff(ss,@stat_date, getdate()) = 0

                           THEN  1

                           ELSE datediff(ss,@stat_date, getdate()) END) AS [CompilationsPerSecond]

                FROM @RatioStatsY

                WHERE counter_name = 'SQL Compilations/sec'

                AND object_name LIKE '%SQL Statistics%') e 

     CROSS JOIN

     (SELECT (cntr_value - @ReCompilationsPerSecond) /

                     (CASE WHEN datediff(ss,@stat_date, getdate()) = 0

                           THEN  1

                           ELSE datediff(ss,@stat_date, getdate()) END) AS [ReCompilationsPerSecond]

                FROM @RatioStatsY

                WHERE counter_name = 'SQL Re-Compilations/sec'

                AND object_name LIKE '%SQL Statistics%') f

     CROSS JOIN

     (SELECT * FROM @RatioStatsY

               WHERE counter_name = 'User Connections'

               AND object_name LIKE '%General Statistics%') g

     CROSS JOIN

     (SELECT (cntr_value - @LockWaitsPerSecond) /

                     (CASE WHEN datediff(ss,@stat_date, getdate()) = 0

                           THEN  1

                           ELSE datediff(ss,@stat_date, getdate()) END) AS [LockWaitsPerSecond]

                FROM @RatioStatsY

                WHERE counter_name = 'Lock Waits/sec'

                AND instance_name = '_Total'

                AND object_name LIKE '%Locks%') h

     CROSS JOIN

     (SELECT (cntr_value - @PageSplitsPerSecond) /

                     (CASE WHEN datediff(ss,@stat_date, getdate()) = 0

                           THEN  1

                           ELSE datediff(ss,@stat_date, getdate()) END) AS [PageSplitsPerSecond]

                FROM @RatioStatsY

                WHERE counter_name = 'Page Splits/sec'

                AND object_name LIKE '%Access Methods%') i

     CROSS JOIN

     (SELECT * FROM @RatioStatsY

               WHERE counter_name = 'Processes blocked'

               AND object_name LIKE '%General Statistics%') j

     CROSS JOIN

     (SELECT (cntr_value - @CheckpointPagesPerSecond) /

                     (CASE WHEN datediff(ss,@stat_date, getdate()) = 0

                           THEN  1

                           ELSE datediff(ss,@stat_date, getdate()) END) AS [CheckpointPagesPerSecond]

                FROM @RatioStatsY

                WHERE counter_name = 'Checkpoint Pages/sec'

                AND object_name LIKE '%Buffer Manager%') k
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_SearchCachedPlans]    Script Date: 02/11/2012 12:30:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_dba_SearchCachedPlans] 
@StringToSearchFor VARCHAR(255) = '%<MissingIndexes>%'
AS 
/*---------------------------------------------------------------------- 
Purpose: Inspects cached plans for a given string. 
------------------------------------------------------------------------

Parameters: @StringToSearchFor - string to search for e.g. '%<MissingIndexes>%'.

Revision History: 
03/06/2008 Ian_Stirk@yahoo.com Initial version 

Example Usage: 
1. exec dbo.sp_dba_SearchCachedPlans '%<MissingIndexes>%' 
2. exec dbo.sp_dba_SearchCachedPlans '%<ColumnsWithNoStatistics>%' 
3. exec dbo.sp_dba_SearchCachedPlans '%<TableScan%' 
4. exec dbo.sp_dba_SearchCachedPlans '%CREATE PROC%MessageWrite%'

-----------------------------------------------------------------------*/ 
BEGIN 
-- Do not lock anything, and do not get held up by any locks. 
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
SELECT TOP 20 
st.text AS [SQL] 
, cp.cacheobjtype 
, cp.objtype 
, DB_NAME(st.dbid)AS [DatabaseName] 
, cp.usecounts AS [Plan usage] 
, qp.query_plan 
FROM sys.dm_exec_cached_plans cp 
CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle) st 
CROSS APPLY sys.dm_exec_query_plan(cp.plan_handle) qp 
WHERE CAST(qp.query_plan AS NVARCHAR(MAX))LIKE @StringToSearchFor 
ORDER BY cp.usecounts DESC 

select 'Outras opcoes: ',' exec dbo.sp_dba_SearchCachedPlans ''%<MissingIndexes>%''' 
select 'Outras opcoes: ',' exec dbo.sp_dba_SearchCachedPlans ''%<ColumnsWithNoStatistics>%''' 
select 'Outras opcoes: ',' exec dbo.sp_dba_SearchCachedPlans ''%<TableScan%''' 
select 'Outras opcoes: ',' exec dbo.sp_dba_SearchCachedPlans ''%CREATE PROC%MessageWrite%''' 

END
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_role]    Script Date: 02/11/2012 12:30:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_dba_role]
as
EXEC sp_helprolemember'db_owner'
EXEC sp_helprolemember 'db_datareader'
EXEC sp_helprolemember 'db_datawriter'
SELECT l.name AS 'login'
FROM sysusers u 
INNER JOIN master..syslogins l 
ON u.sid = l.sid
WHERE u.name = 'dbo'
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_procHist]    Script Date: 02/11/2012 12:30:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_dba_procHist] 
as
SELECT SUBSTRING(qt.TEXT, (qs.statement_start_offset/2)+1,
((CASE qs.statement_end_offset
WHEN -1 THEN DATALENGTH(qt.TEXT)
ELSE qs.statement_end_offset
END - qs.statement_start_offset)/2)+1),
qs.execution_count,
qs.total_logical_reads, qs.total_logical_reads/qs.execution_count as AvgReadsCost,
qs.last_logical_reads,
qs.total_logical_writes, qs.last_logical_writes,
qs.total_physical_reads, qs.last_logical_reads,
qs.total_worker_time,
qs.total_elapsed_time/1000000 total_elapsed_time_in_S
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
ORDER BY qs.total_logical_reads/qs.execution_count  DESC;
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_proc5]    Script Date: 02/11/2012 12:30:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_dba_proc5] as
SELECT CASE WHEN dbid = 32767 then 'Resource' ELSE DB_NAME(dbid)END AS DBName

      ,OBJECT_SCHEMA_NAME(objectid,dbid) AS [SCHEMA_NAME]  

      ,OBJECT_NAME(objectid,dbid)AS [OBJECT_NAME]

      ,MAX(qs.creation_time) AS 'cache_time'

      ,MAX(last_execution_time) AS 'last_execution_time'

      ,MAX(usecounts) AS [execution_count]

      ,SUM(total_worker_time) / SUM(usecounts) AS AVG_CPU

      ,SUM(total_elapsed_time) / SUM(usecounts) AS AVG_ELAPSED

      ,SUM(total_logical_reads) / SUM(usecounts) AS AVG_LOGICAL_READS

      ,SUM(total_logical_writes) / SUM(usecounts) AS AVG_LOGICAL_WRITES

      ,SUM(total_physical_reads) / SUM(usecounts)AS AVG_PHYSICAL_READS        

FROM sys.dm_exec_query_stats qs  

   join sys.dm_exec_cached_plans cp on qs.plan_handle = cp.plan_handle 

   CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle) 

WHERE objtype = 'Proc' 

  AND text

       NOT LIKE '%CREATE FUNC%' 

       GROUP BY cp.plan_handle,DBID,objectid
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_proc4]    Script Date: 02/11/2012 12:30:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_dba_proc4] as
SELECT CASE WHEN database_id = 32767 then 'Resource' ELSE DB_NAME(database_id)END AS DBName

      ,OBJECT_SCHEMA_NAME(object_id,database_id) AS [SCHEMA_NAME]  

      ,OBJECT_NAME(object_id,database_id)AS [OBJECT_NAME]

      ,cached_time

      ,last_execution_time

      ,execution_count

      ,total_worker_time / execution_count AS AVG_CPU

      ,total_elapsed_time / execution_count AS AVG_ELAPSED

      ,total_logical_reads / execution_count AS AVG_LOGICAL_READS

      ,total_logical_writes / execution_count AS AVG_LOGICAL_WRITES

      ,total_physical_reads  / execution_count AS AVG_PHYSICAL_READS

FROM sys.dm_exec_procedure_stats  where OBJECT_NAME(object_id,database_id) is not null

ORDER BY execution_count DESC
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_proc3]    Script Date: 02/11/2012 12:30:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_dba_proc3]
as
set nocount on



SELECT  spid=r.session_id,command,login_name,host_name,blk=blocking_session_id,percent_complete,
r.cpu_time,duration_secs=r.total_elapsed_time/1000,r.status,r.logical_reads,r.reads,r.writes,
DB_NAME(database_id) AS [Database], r.wait_time ,[text] AS [LAST_Query]  
FROM sys.dm_exec_requests r  
CROSS APPLY sys.dm_exec_sql_text(r.plan_handle) st  
join sys.dm_exec_sessions p on r.session_id = p.session_id 
WHERE r.session_Id > 50   and r.session_Id <> @@spid
union 
SELECT  spid=p.session_id,program_name,login_name,host_name,
blk=0,0,cpu_time,duration_secs=total_elapsed_time/1000,status,logical_reads,reads,writes,
null AS [Database], cpu_time ,null AS [LAST_Query]  
FROM sys.dm_exec_sessions p
WHERE 
exists (select 1 from sys.dm_exec_requests r2 where r2.blocking_session_id = p.session_id) 
order by 1
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_proc2]    Script Date: 02/11/2012 12:30:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_dba_proc2] as
set nocount on
SELECT r.SESSION_id, T.[text], P.[query_plan], S.[program_name], r.blocking_session_id,percent_complete,r.status,S.[host_name],
S.[client_interface_name], S.[login_name], R.*
FROM sys.dm_exec_requests R
INNER JOIN sys.dm_exec_sessions S 
ON S.session_id = R.session_id
CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS T
CROSS APPLY sys.dm_exec_query_plan(plan_handle) As P
where r.session_id <> @@spid
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_proc10]    Script Date: 02/11/2012 12:30:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-----------------------------------------------------------------------------------------------------------------------------
--	Stored Procedure Details: Listing Of Standard Details Related To The Stored Procedure
-----------------------------------------------------------------------------------------------------------------------------

--	Purpose: Return Information Regarding Current Users / Sessions / Processes On A SQL Server Instance
--	Create Date (MM/DD/YYYY): 10/27/2009
--	Developer: Sean Smith (s(DOT)smith(DOT)sql(AT)gmail(DOT)com)
--	Additional Notes: N/A


-----------------------------------------------------------------------------------------------------------------------------
--	Modification History: Listing Of All Modifications Since Original Implementation
-----------------------------------------------------------------------------------------------------------------------------

--	Description: Converted Script To Dynamic-SQL
--	Date (MM/DD/YYYY): 11/05/2009
--	Developer: Sean Smith (s(DOT)smith(DOT)sql(AT)gmail(DOT)com)
--	Additional Notes: N/A


--	Description: Minor Changes To Code Style And Added "@v_Filter_Database_Name" Filter Variable
--	Date (MM/DD/YYYY): 08/08/2011
--	Developer: Sean Smith (s(DOT)smith(DOT)sql(AT)gmail(DOT)com)
--	Additional Notes: N/A


--	Description: Added "Last_Wait_Type", "Query_Plan_XML", And "Wait_Type" Fields To Output
--	Date (MM/DD/YYYY): 08/12/2011
--	Developer: Sean Smith (s(DOT)smith(DOT)sql(AT)gmail(DOT)com)
--	Additional Notes: N/A


--	Description: No Modifications To Date
--	Date (MM/DD/YYYY): N/A
--	Developer: N/A
--	Additional Notes: N/A


-----------------------------------------------------------------------------------------------------------------------------
--	Main Query: Create Procedure
-----------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[sp_dba_proc10]

	 @v_Filter_Active_Blocked_System AS VARCHAR (5) = NULL
	,@v_Filter_SPID AS SMALLINT = NULL
	,@v_Filter_NT_Username_Or_Loginame AS NVARCHAR (128) = NULL
	,@v_Filter_Database_Name AS NVARCHAR (512) = NULL
	,@v_Filter_SQL_Statement AS NVARCHAR (MAX) = NULL

AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON
SET ANSI_WARNINGS OFF
SET ARITHABORT OFF
SET ARITHIGNORE ON


-----------------------------------------------------------------------------------------------------------------------------
--	Error Trapping: Check If "@v_Filter_Active_Blocked_System" Parameter Is An Input / Output Help Request
-----------------------------------------------------------------------------------------------------------------------------

IF @v_Filter_Active_Blocked_System = 'I?'
BEGIN

	RAISERROR

		(
			 '
Syntax:

	EXECUTE [dbo].[usp_who5]


Optional Input Parameters:

	@v_Filter_Active_Blocked_System   : Limit result set by passing one or more values listed below (can be used individually or combined in any manner):

		A - Active SPIDs Only
		B - Blocked SPIDs Only
		X - Exclude System Reserved SPIDs (1-50)

	@v_Filter_SPID                    : Limit result set to a specific SPID
	@v_Filter_NT_Username_Or_Loginame : Limit result set to a specific Windows user name (if populated), otherwise by SQL Server login name
	@v_Filter_Database_Name           : Limit result set to a specific database
	@v_Filter_SQL_Statement           : Limit result set to SQL statement(s) containing specific text


Notes:

	Blocked SPIDs (Blocked / Blocking / Parallelism) will always be displayed first in the result set
			 '
			,16
			,1
		)


	GOTO Skip_Query

END


IF @v_Filter_Active_Blocked_System = 'O?'
BEGIN

	RAISERROR

		(
			 '
Output:

	SPECID                  : System Process ID with Execution Context ID
	Blocked                 : Blocking indicator (includes type of block and blocking SPID)
	Running                 : Indicates if SPID is currently executing, waiting, inactive, or has open transactions
	Login_ID                : Displays Windows user name (or login name if user name is unavailable)
	Login_Name              : Full name of the user associated to the Login_ID (if available)
	Elapsed_Time            : Total elapsed time since the request began (HH:MM:SS)
	CPU_Total               : Cumulative CPU time since login (HH:MM:SS)
	CPU_Current             : Cumulative CPU time for current process (HH:MM:SS)
	Logical_Reads           : Number of logical reads performed by current process
	Physical_Reads          : Number of physical reads performed by current process
	Writes                  : Number of writes performed by current process
	Pages_Used              : Number of pages in the procedure cache currently allocated to the process
	Nesting_Level           : Nesting level of the statement currently executing
	Open_Trans              : Number of open transactions for the process
	Wait_Time               : Current wait time (HH:MM:SS)
	Wait_Type               : Current wait type
	Last_Wait_Type          : Previous wait type
	Status                  : Status of the current process
	Command                 : Command currently being executed
	SQL_Statement           : SQL statement of the associated SPID
	Query_Plan_XML          : Execution plan (XML)
	Since_SPID_Login        : Total elapsed time since client login (HH:MM:SS)
	Since_Last_Batch        : Total elapsed time since client last completed a remote stored procedure call or an EXECUTE statement (HH:MM:SS)
	Workstation_Name        : Workstation name
	Database_Name           : Database context of the SPID
	Application_Description : Application accessing SQL Server
	SPECID                  : System Process ID with Execution Context ID
			 '
			,16
			,1
		)


	GOTO Skip_Query

END


-----------------------------------------------------------------------------------------------------------------------------
--	Declarations / Sets: Declare And Set Variables
-----------------------------------------------------------------------------------------------------------------------------

DECLARE @v_Filter_Active AS BIT
DECLARE @v_Filter_Blocked AS BIT
DECLARE @v_Filter_System AS BIT
DECLARE @v_SQL_String AS VARCHAR (MAX)


SET @v_Filter_NT_Username_Or_Loginame = NULLIF (@v_Filter_NT_Username_Or_Loginame, '')
SET @v_Filter_Database_Name = NULLIF (@v_Filter_Database_Name, '')
SET @v_Filter_SQL_Statement = NULLIF (REPLACE (@v_Filter_SQL_Statement, '''', ''''''), '')
SET @v_Filter_Active = (CASE
							WHEN @v_Filter_Active_Blocked_System LIKE '%A%' THEN 1
							ELSE 0
							END)
SET @v_Filter_Blocked = (CASE
							WHEN @v_Filter_Active_Blocked_System LIKE '%B%' THEN 1
							ELSE 0
							END)
SET @v_Filter_System = (CASE
							WHEN @v_Filter_Active_Blocked_System LIKE '%X%' THEN 1
							ELSE 0
							END)


-----------------------------------------------------------------------------------------------------------------------------
--	Main Query: Final Display / Output
-----------------------------------------------------------------------------------------------------------------------------

SET @v_SQL_String =

	'
		SELECT
			 CONVERT (VARCHAR (6), SP.spid)+''.''+CONVERT (VARCHAR (6), SP.ecid)+(CASE
																					WHEN SP.spid = @@SPID THEN '' •••''
																					ELSE ''''
																					END) AS SPECID
			,(CASE
				WHEN SP.blocked = 0 AND Y.blocked IS NULL THEN ''·············''
				WHEN SP.blocked = SP.spid THEN ''> Parallelism <''
				WHEN SP.blocked = 0 AND Y.blocked IS NOT NULL THEN ''>> BLOCKING <<''
				ELSE ''SPID: ''+CONVERT (VARCHAR (6), B.spid)+''  •  ''+(CASE
																			WHEN B.Login_ID_Blocking = ''sa'' THEN ''<< System Administrator >>''
																			ELSE ISNULL (B.Login_ID_Blocking, ''N/A'')
																			END)
				END) AS Blocked
			,(CASE
				WHEN SP.spid <= 50 THEN ''     --''
				WHEN SP.[status] IN (''dormant'', ''sleeping'') AND SP.open_tran = 0 THEN ''''
				WHEN SP.[status] IN (''dormant'', ''sleeping'') THEN ''     •''
				WHEN SP.[status] IN (''defwakeup'', ''pending'', ''spinloop'', ''suspended'') THEN ''     *''
				ELSE ''     X''
				END) AS Running
			,ISNULL (NULLIF (SP.nt_username, ''''), SP.loginame) AS Login_ID
			,ISNULL ((CASE
						WHEN SP.loginame = ''sa'' THEN ''<< System Administrator >>''
						ELSE SP.loginame
						END), '''') AS Login_Name
			,(CASE
				WHEN SP.spid >= 51 AND LEN ((DMER.total_elapsed_time/1000)/3600) > 2 THEN ''99:59:59+''
				WHEN SP.spid >= 51 THEN ISNULL (RIGHT (''00''+CONVERT (VARCHAR (2), (DMER.total_elapsed_time/1000)/3600), 2)+'':''+RIGHT (''00''+CONVERT (VARCHAR (2), ((DMER.total_elapsed_time/1000)%3600)/60), 2)+'':''+RIGHT (''00''+CONVERT (VARCHAR (2), ((DMER.total_elapsed_time/1000)%3600)%60), 2), '''')
				ELSE ''''
				END) AS Elapsed_Time
			,(CASE
				WHEN SP.cpu = 0 THEN ''''
				WHEN LEN ((SP.cpu/1000)/3600) > 2 THEN ''99:59:59+''
				ELSE RIGHT (''00''+CONVERT (VARCHAR (2), (SP.cpu/1000)/3600), 2)+'':''+RIGHT (''00''+CONVERT (VARCHAR (2), ((SP.cpu/1000)%3600)/60), 2)+'':''+RIGHT (''00''+CONVERT (VARCHAR (2), ((SP.cpu/1000)%3600)%60), 2)
				END) AS CPU_Total
			,(CASE
				WHEN DMER.cpu_time = 0 THEN ''''
				WHEN LEN ((DMER.cpu_time/1000)/3600) > 2 THEN ''99:59:59+''
				ELSE ISNULL (RIGHT (''00''+CONVERT (VARCHAR (2), (DMER.cpu_time/1000)/3600), 2)+'':''+RIGHT (''00''+CONVERT (VARCHAR (2), ((DMER.cpu_time/1000)%3600)/60), 2)+'':''+RIGHT (''00''+CONVERT (VARCHAR (2), ((DMER.cpu_time/1000)%3600)%60), 2), '''')
				END) AS CPU_Current
			,ISNULL (CONVERT (VARCHAR (20), DMER.logical_reads), '''') AS Logical_Reads
			,ISNULL (CONVERT (VARCHAR (20), DMER.reads), '''') AS Physical_Reads
			,ISNULL (CONVERT (VARCHAR (20), DMER.writes), '''') AS Writes
			,(CASE
				WHEN SP.memusage = 0 THEN ''''
				ELSE CONVERT (VARCHAR (10), SP.memusage)
				END) AS Pages_Used
			,ISNULL (CONVERT (VARCHAR (15), DMER.nest_level), '''') AS Nesting_Level
			,(CASE
				WHEN SP.open_tran = 0 THEN ''''
				ELSE CONVERT (VARCHAR (10), SP.open_tran)
				END) AS Open_Trans
			,(CASE
				WHEN SP.waittime = 0 THEN ''''
				WHEN SP.spid >= 51 AND LEN ((SP.waittime/1000)/3600) > 2 THEN ''99:59:59+''
				WHEN SP.spid >= 51 THEN RIGHT (''00''+CONVERT (VARCHAR (2), (SP.waittime/1000)/3600), 2)+'':''+RIGHT (''00''+CONVERT (VARCHAR (2), ((SP.waittime/1000)%3600)/60), 2)+'':''+RIGHT (''00''+CONVERT (VARCHAR (2), ((SP.waittime/1000)%3600)%60), 2)
				ELSE ''''
				END) AS Wait_Time
			,ISNULL (DMER.wait_type, '''') AS Wait_Type
			,ISNULL (DMER.last_wait_type, '''') AS Last_Wait_Type
			,RTRIM ((CASE
						WHEN SP.[status] NOT IN (''dormant'', ''sleeping'') THEN UPPER (SP.[status])
						ELSE LOWER (SP.[status])
						END)) AS [Status]
			,RTRIM ((CASE
						WHEN SP.cmd = ''awaiting command'' THEN LOWER (SP.cmd)
						ELSE UPPER (SP.cmd)
						END)) AS Command
			,ISNULL (DEST.[text], '''') AS SQL_Statement
			,ISNULL (DMEQP.query_plan, '''') AS Query_Plan_XML
			,(CASE
				WHEN LEN (DATEDIFF (SECOND, SP.login_time, GETDATE ())/3600) > 2 THEN ''99:59:59+''
				ELSE RIGHT (''00''+CONVERT (VARCHAR (2), DATEDIFF (SECOND, SP.login_time, GETDATE ())/3600), 2)+'':''+RIGHT (''00''+CONVERT (VARCHAR (2), (DATEDIFF (SECOND, SP.login_time, GETDATE ())%3600)/60), 2)+'':''+RIGHT (''00''+CONVERT (VARCHAR (2), (DATEDIFF (SECOND, SP.login_time, GETDATE ())%3600)%60), 2)
				END) AS Since_SPID_Login
			,(CASE
				WHEN LEN (DATEDIFF (SECOND, SP.last_batch, GETDATE ())/3600) > 2 THEN ''99:59:59+''
				ELSE RIGHT (''00''+CONVERT (VARCHAR (2), DATEDIFF (SECOND, SP.last_batch, GETDATE ())/3600), 2)+'':''+RIGHT (''00''+CONVERT (VARCHAR (2), (DATEDIFF (SECOND, SP.last_batch, GETDATE ())%3600)/60), 2)+'':''+RIGHT (''00''+CONVERT (VARCHAR (2), (DATEDIFF (SECOND, SP.last_batch, GETDATE ())%3600)%60), 2)
				END) AS Since_Last_Batch
			,RTRIM (SP.hostname) AS Workstation_Name
			,DB_NAME (SP.[dbid]) AS Database_Name
			,CONVERT (NVARCHAR (128), RTRIM (REPLACE (REPLACE (SP.[program_name], ''Microsoft® Windows® Operating System'', ''Windows OS''), ''Microsoft'', ''MS''))) AS Application_Description
			,CONVERT (VARCHAR (6), SP.spid)+''.''+CONVERT (VARCHAR (6), SP.ecid)+(CASE
																					WHEN SP.spid = @@SPID THEN '' •••''
																					ELSE ''''
																					END) AS SPECID
		FROM
			[master].[sys].[sysprocesses] SP
			LEFT JOIN

				(
					SELECT
						 A.spid
						,ISNULL (NULLIF (A.nt_username, ''''), A.loginame) AS Login_ID_Blocking
						,ROW_NUMBER () OVER
											(
												PARTITION BY
													A.spid
												ORDER BY
													 (CASE
														WHEN ISNULL (NULLIF (A.nt_username, ''''), A.loginame) = '''' THEN 2
														ELSE 1
														END)
													,A.ecid
											) AS sort_id
					FROM
						[master].[sys].[sysprocesses] A
				) B ON B.spid = SP.blocked AND B.sort_id = 1

			LEFT JOIN

				(
					SELECT DISTINCT
						X.blocked
					FROM
						[master].[sys].[sysprocesses] X
				) Y ON Y.blocked = SP.spid

			LEFT JOIN [master].[sys].[dm_exec_requests] DMER ON DMER.session_id = SP.spid
			OUTER APPLY [master].[sys].[dm_exec_sql_text] (SP.[sql_handle]) AS DEST
			OUTER APPLY [master].[sys].[dm_exec_query_plan] (DMER.plan_handle) DMEQP
		WHERE
			1 = 1
	'


IF @v_Filter_Active = 1
BEGIN

	SET @v_SQL_String = @v_SQL_String+

		'
			AND (CASE
					WHEN SP.open_tran <> 0 THEN ''''
					ELSE SP.[status]
					END) NOT IN (''dormant'', ''sleeping'')
		'

END


IF @v_Filter_Blocked = 1
BEGIN

	SET @v_SQL_String = @v_SQL_String+

		'
			AND SP.blocked <> 0
		'

END


IF @v_Filter_System = 1
BEGIN

	SET @v_SQL_String = @v_SQL_String+

		'
			AND SP.spid >= 51
		'

END


IF @v_Filter_SPID IS NOT NULL
BEGIN

	SET @v_SQL_String = @v_SQL_String+

		'
			AND SP.spid = '+CONVERT (VARCHAR (10), @v_Filter_SPID)+'
		'

END


IF @v_Filter_NT_Username_Or_Loginame IS NOT NULL
BEGIN

	SET @v_SQL_String = @v_SQL_String+

		'
			AND CONVERT (NVARCHAR (128), ISNULL (NULLIF (SP.nt_username, ''''), SP.loginame)) = '''+@v_Filter_NT_Username_Or_Loginame+'''
		'

END


IF @v_Filter_Database_Name IS NOT NULL
BEGIN

	SET @v_SQL_String = @v_SQL_String+

		'
			AND DB_NAME (SP.[dbid]) = '''+@v_Filter_Database_Name+'''
		'

END


IF @v_Filter_SQL_Statement IS NOT NULL
BEGIN

	SET @v_SQL_String = @v_SQL_String+

		'
			AND DEST.[text] LIKE ''%''+REPLACE (REPLACE (REPLACE ('''+@v_Filter_SQL_Statement+''', ''['', ''[[]''), ''%'', ''[%]''), ''_'', ''[_]'')+''%''
		'

END


SET @v_SQL_String = @v_SQL_String+

	'
		ORDER BY
			 (CASE
				WHEN SP.blocked = 0 AND Y.blocked IS NULL THEN 999
				WHEN SP.blocked = SP.spid THEN 30
				WHEN SP.blocked = 0 AND Y.blocked IS NOT NULL THEN 20
				ELSE 10
				END)
			,SP.spid
			,SP.ecid
	'


EXECUTE (@v_SQL_String)


Skip_Query:
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_Proc]    Script Date: 02/11/2012 12:30:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_dba_Proc]           
as
            
  set nocount on            
  
            
          
            
            
  -- PROCESSOS ATIVOS            
            
  declare  @sysprocesses table(            
    spid         smallint not null,            
    blocked      smallint null,            
--    waittime     int null,            
    dbid         smallint null,            
    uid          smallint  null,            
    cpu          int null,            
    physical_io  bigint null,            
    memusage     int null,            
    last_batch   datetime  null,            
    open_tran    smallint null,            
    status       varchar(60) null,            
    hostname     varchar(60) null,            
    program_name varchar(50) null,            
    cmd          varchar(50) null,            
  loginame     varchar(50) null,            
   sql_handle   binary (20) null,            
    stmt_start   int,            
    stmt_end     int , buffer varchar(600) ,        
    waittime bigint,        
lastwaittype nchar (64))
            
            
  insert @sysprocesses            
  select            
    spid,            
    blocked ,            
  --  waittime,            
    dbid,            
    uid,            
    cpu,            
    physical_io,            
    memusage,            
    last_batch,            
    open_tran,            
    convert(char(60),status),            
    convert(char(60),hostname),            
    convert(char(50),program_name),            
    convert(char(50),cmd),            
    convert(char(50),loginame),            
    convert(binary(20),sql_handle),            
    stmt_start,            
    stmt_end,null,    waittime ,        
lastwaittype            
  from sysprocesses (NOLOCK)             
  where spid >= 50 and (open_tran > 0 or blocked <> 0 or status in         
  ('suspend','running' ,'runnable'))    
            
           
       
            

            
            
  declare  @syslockinfo table(            
    rsc_dbid   int null,            
    rsc_indid  int null,            
    rsc_objid  int null,            
    rsc_type   int null,            
    req_mode   int null,            
    req_status int null,            
    req_spid   int null )            
            
            
            
  insert @syslockinfo            
  select            
    rsc_dbid,            
    rsc_indid,            
    rsc_objid,            
    rsc_type,            
    req_mode,            
    req_status,            
    req_spid            
  from master..syslockinfo a (NOLOCK)            
  where exists (            
    select 1 from @sysprocesses p            
    where a.req_spid = p.spid  )            
            
declare @min int, @max int, @cmd varchar(50),@EventInfo varchar(500)            
select @min = min(spid), @max = max(spid) from @sysprocesses            
            
              
if exists (select 1 from tempdb..sysobjects where type = 'U' and name like 'buffer%')            
drop table #buffer            
create table #buffer  (eventType varchar(2000), parameters bigint, EventInfo varchar(2000))            
            
            
while @min <= @max            
begin            
select @cmd = 'dbcc inputbuffer ('+ltrim(rtrim(convert(char(5),@min)))+')'            
insert #buffer  (EventType, Parameters, EventInfo)             
exec (@cmd)            
select @EventInfo = EventInfo from #buffer            
update @sysprocesses set buffer = @EventInfo where spid = @min            
select @min = min(spid) from @sysprocesses where spid > @min            
delete #buffer            
end            
      
      
            
  select            
    SPID = spid,                 
    LOGIN = substring(loginame,1,20),                  
    CPU = convert(char(7),cpu),                 
    IO = convert(char(7),physical_io),            
    MEM = convert(char(4),memusage),                 
    STATUS = substring(b.status,1,20),                 
    COMANDO = substring(cmd,1,20),                 
    blocked    ,   
    DB =  substring(db_name(dbid),1,30),           
    waittime_ms=SUM ( waittime) ,        
lastwaittype ,        
PARADO_SEGs=DATEDIFF(ss  , max(last_batch),GETDATE()),    
    HOSTNAME = substring(b.hostname,1,40),               
    PGM = substring(b.program_name,1,30),            
    TRANS = convert(char(2),b.open_tran),Buffer,            
Qtd_Obj = count (distinct rsc_objid)            
  from  @sysprocesses b left join @syslockinfo l on b.spid = l.req_spid            
  where cmd not in ('awaiting command', 'WAITFOR')            
    and spid <> @@spid            
group by spid, substring(loginame,1,20),convert(char(7),cpu), convert(char(7),physical_io),convert(char(4),memusage),                 
substring(b.status,1,20), substring(cmd,1,20),blocked,  substring(db_name(dbid),1,30),substring(b.hostname,1,40),                 
substring(b.program_name,1,30),convert(char(2),b.open_tran),Buffer , lastwaittype           
  union                 
  select            
    SPID = spid,                 
    LOGIN = 'Backup',                  
    CPU = convert(char(7),cpu),                 
    IO = convert(char(7),physical_io),            
    MEM = convert(char(4),memusage),                     
    STATUS = substring(b.status,1,20),                 
    COMANDO = substring(cmd,1,20),                 
    blocked  ,  
    DB =  substring(db_name(dbid),1,30),            
     waittime_ms=SUM ( waittime) ,        
lastwaittype ,        
PARADO_SEGs=DATEDIFF(ss  , max(last_batch),GETDATE()),    
    HOSTNAME = substring(b.hostname,1,40),                 
    PGM = substring(b.program_name,1,30),            
    TRANS = convert(char(2),b.open_tran),Buffer ,            
Qtd_Obj = count (distinct rsc_objid)            
from  @sysprocesses b left join @syslockinfo l on b.spid = l.req_spid            
  where cmd in ('DUMP DATABASE', 'LOAD DATABASE')            
    and spid <> @@spid            
group by spid, substring(loginame,1,20),convert(char(7),cpu), convert(char(7),physical_io),convert(char(4),memusage),                 
substring(b.status,1,20), substring(cmd,1,20),blocked,  substring(db_name(dbid),1,30),substring(b.hostname,1,40),                 
substring(b.program_name,1,30),convert(char(2),b.open_tran),Buffer,lastwaittype    
  union            
   select            
    SPID = spid,               
    LOGIN = substring(loginame,1,20),                
    CPU = convert(char(7),cpu),               
    IO = convert(char(7),physical_io),            
    MEM = convert(char(4),memusage),                   
    STATUS = substring(b.status,1,20),               
    COMANDO = substring(cmd,1,20),               
    blocked ,
    DB =  substring(db_name(dbid),1,30),             
    waittime_ms=SUM ( waittime) ,        
lastwaittype ,        
PARADO_SEGs=DATEDIFF(ss  , max(last_batch),GETDATE()),     
    HOSTNAME = substring(b.hostname,1,40),               
    PGM = substring(b.program_name,1,30),            
    TRANS = convert(char(2),b.open_tran) ,Buffer,            
Qtd_Obj = count (distinct rsc_objid)            
from  @sysprocesses b left join @syslockinfo l on b.spid = l.req_spid            
  where exists (select 1 from @sysprocesses c where b.spid = c.blocked )            
    and spid <> @@spid            
group by spid, substring(loginame,1,20),convert(char(7),cpu), convert(char(7),physical_io),convert(char(4),memusage),                 
substring(b.status,1,20), substring(cmd,1,20),blocked,  substring(db_name(dbid),1,30),substring(b.hostname,1,40),                 
substring(b.program_name,1,30),convert(char(2),b.open_tran),Buffer  , lastwaittype      
  union                 
  select            
    SPID = spid,                 
    LOGIN = substring(loginame,1,20),                  
    CPU = convert(char(7),cpu),                 
    IO = convert(char(7),physical_io),            
    MEM = convert(char(4),memusage),                     
    STATUS = substring(b.status,1,20),                
    COMANDO = substring(cmd,1,20),                 
    blocked   ,  
    DB =  substring(db_name(dbid),1,30),              
 waittime_ms=SUM ( waittime) ,        
lastwaittype ,        
PARADO_SEGs=DATEDIFF(ss  , max(last_batch),GETDATE()),          
    HOSTNAME = substring(b.hostname,1,40),                 
    PGM = substring(b.program_name,1,30),            
    TRANS = convert(char(2),b.open_tran) ,Buffer   ,            
Qtd_Obj = count (distinct rsc_objid)            
from  @sysprocesses b left join @syslockinfo l on b.spid = l.req_spid            
  where (open_tran > 0 or blocked > 0)            
    and spid <> @@spid            
group by spid, substring(loginame,1,20),convert(char(7),cpu), convert(char(7),physical_io),convert(char(4),memusage),                 
substring(b.status,1,20), substring(cmd,1,20),blocked,  substring(db_name(dbid),1,30),substring(b.hostname,1,40),                 
substring(b.program_name,1,30),convert(char(2),b.open_tran),Buffer   , lastwaittype            
order by 1            
drop table #buffer
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_pr]    Script Date: 02/11/2012 12:30:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_dba_pr]
as
begin
set nocount on
declare @db nvarchar(200) = db_name()
declare @SQL nvarchar(4000) ='
select name, create_date from '+@db+'.sys.procedures order by 1';
EXEC sp_executeSQL @SQL; 
end
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_OverlapRole]    Script Date: 02/11/2012 12:30:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_dba_OverlapRole]
as
set nocount on 
select 'ROLES' 
SELECT TOP 10 SPMember.name AS [login name], SPRole.name AS [role name] 
FROM master.sys.server_principals SPRole 
 INNER JOIN master.sys.server_role_members SRM ON SPRole.principal_id = SRM.role_principal_id 
 INNER JOIN master.sys.[server_principals] AS SPMember ON SRM.[member_principal_id] = SPMember.principal_id

select 'OVELAPS' 

SELECT SPMember.[login name], SPRole.name AS 'role name' 
FROM master.sys.server_principals SPRole 
 INNER JOIN master.sys.server_role_members SRM ON SPRole.principal_id = SRM.role_principal_id 
 INNER JOIN 
   ( 
   SELECT SP.name AS 'login name', SP.principal_id  
   FROM master.sys.server_principals sp_roles  
     INNER JOIN master.sys.server_role_members SRM ON sp_roles.principal_id = SRM.role_principal_id 
     INNER JOIN master.sys.server_principals SP ON  SRM.member_principal_id = SP.principal_id 
   WHERE sp_roles.type_desc = 'SERVER_ROLE' --AND SP_roles.name <> 'sysadmin' 
   GROUP BY SP.name, SP.principal_id 
   HAVING COUNT(SP.name) > 1 
   ) AS SPMember ON SRM.member_principal_id = SPMember.principal_id 
ORDER BY SPMember.[login name]
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_osbufferdescriptors_agg]    Script Date: 02/11/2012 12:30:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_dba_osbufferdescriptors_agg]
as
  /*
SAMPLE EXECUTION:
exec sp_osbufferdescriptors_agg
*/
  set nocount  on ;
  
  set transaction  isolation  level  read  uncommitted ;
  
  select   case 
             when grouping(dbName) = 1 then '-- TOTAL ---'
             else dbName
           end as dbName,
           case 
             when grouping(fileId) = 1 then '-- TOTAL ---'
             else fileId
           end as fileId,
           case 
             when grouping(pageType) = 1 then '-- TOTAL ---'
             else pageType
           end as pageType,
           count(* ) as countPages,
           sum(row_count) as sumRowCount,
           avg(row_count) as avgRowCount,
           sum(freeSpaceBytes) as sumFreeSpaceBytes,
           avg(freeSpaceBytes) as avgFreeSpaceBytes
  from     (select case 
                     when database_id = 32767 then 'resourceDb'
                     else cast(db_name(database_id) as varchar(25))
                   end as dbName,
                   cast(file_id as varchar(10)) as fileId,
                   cast(page_type as varchar(25)) as pageType,
                   row_count as row_count,
                   free_space_in_bytes as freeSpaceBytes
            from   sys.dm_os_buffer_descriptors bufferDescriptor with (nolock)) tmp
  group by dbName,fileId,pageType with rollup
  order by 1 ,2  , 5 desc;
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_OS_Info]    Script Date: 02/11/2012 12:30:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_dba_OS_Info]
as
set nocount on
SELECT * FROM sys.dm_os_sys_info
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_OrphanUser]    Script Date: 02/11/2012 12:30:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_dba_OrphanUser]
as
ALTER USER [PSAFE\IIS_PROD] WITH LOGIN = [PSAFE\IIS_PROD]
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_network]    Script Date: 02/11/2012 12:30:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_dba_network] as
Select 'SQL PORTS AND PROTOCOLS'

SELECT      e.name,
            e.endpoint_id,
            e.principal_id,
            e.protocol,
            e.protocol_desc,
            ec.local_net_address,
            ec.local_tcp_port,
            e.[type],
            e.type_desc,
            e.[state],
            e.state_desc,
            e.is_admin_endpoint
FROM        sys.endpoints e 
            LEFT OUTER JOIN sys.dm_exec_connections ec
                ON ec.endpoint_id = e.endpoint_id
GROUP BY    e.name,
            e.endpoint_id,
            e.principal_id,
            e.protocol,
            e.protocol_desc,
            ec.local_net_address,
            ec.local_tcp_port,
            e.[type],
            e.type_desc,
            e.[state],
            e.state_desc,
            e.is_admin_endpoint
            
SELECT session_id, protocol_type, driver_version = 
CASE SUBSTRING(CAST(protocol_version AS BINARY(4)), 1,1)
WHEN 0x70 THEN 'SQL Server 7.0'
WHEN 0x71 THEN 'SQL Server 2000'
WHEN 0x72 THEN 'SQL Server 2005'
WHEN 0x73 THEN 'SQL Server 2008'
ELSE 'Unknown driver'  
END,client_net_address ,client_tcp_port,local_tcp_port ,
DATEDIFF(s,last_write,getdate()) as 'LAST_WRITE_MS',
DATEDIFF(s,last_read,getdate()) as 'LAST_READ_MS',
T.text
FROM sys.dm_exec_connections
CROSS APPLY sys.dm_exec_sql_text(most_recent_sql_handle) AS T
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_monitorLS]    Script Date: 02/11/2012 12:30:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_dba_monitorLS] 
as
begin
return
/*
select primary_server,primary_database,secondary_server,secondary_database,last_copied_date,last_restored_date,
last_restored_latency_mins=last_restored_latency from ozdb03.msdb.dbo.log_shipping_monitor_secondary
exec sp_help_log_shipping_monitor_primary @primary_server= 'OZDB01', @primary_database= 'ozdb' --Monitor server or primary server
exec sp_help_log_shipping_alert_job --Monitor server, or primary or secondary server if no monitor is defined
exec sp_help_log_shipping_primary_database @database= 'ozdb'--Primary server
exec sp_help_log_shipping_primary_secondary @primary_database= 'ozdb'--Primary server
*/
end
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_monitorEncrypt]    Script Date: 02/11/2012 12:30:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_dba_monitorEncrypt]
as
SELECT DB_NAME(e.database_id) AS DatabaseName, 
            e.database_id, 
            e.encryption_state, 
    CASE e.encryption_state 
                WHEN 0 THEN 'No database encryption key present, no encryption' 
                WHEN 1 THEN 'Unencrypted' 
                WHEN 2 THEN 'Encryption in progress' 
                WHEN 3 THEN 'Encrypted' 
                WHEN 4 THEN 'Key change in progress' 
                WHEN 5 THEN 'Decryption in progress' 
    END AS encryption_state_desc, 
            c.name, 
            e.percent_complete 
    FROM sys.dm_database_encryption_keys AS e 
    LEFT JOIN master.sys.certificates AS c 
    ON e.encryptor_thumbprint = c.thumbprint
GO
/****** Object:  View [dbo].[Waits2]    Script Date: 02/11/2012 12:30:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[Waits2] AS
SELECT 
wait_type,wait_time_ms / 1000.0 AS WaitS,(wait_time_ms - signal_wait_time_ms) / 1000.0 AS ResourceS,
signal_wait_time_ms / 1000.0 AS SignalS,waiting_tasks_count AS WaitCount,
100.0 * wait_time_ms / SUM (wait_time_ms) OVER() AS Percentage,
ROW_NUMBER() OVER(ORDER BY wait_time_ms DESC) AS RowNum
FROM sys.dm_os_wait_stats
WHERE wait_time_ms > 0 and wait_type NOT IN (
'CLR_SEMAPHORE', 'LAZYWRITER_SLEEP', 'RESOURCE_QUEUE', 'SLEEP_TASK',
'SLEEP_SYSTEMTASK', 'SQLTRACE_BUFFER_FLUSH', 'WAITFOR', 'LOGMGR_QUEUE',
'CHECKPOINT_QUEUE', 'REQUEST_FOR_DEADLOCK_SEARCH', 'XE_TIMER_EVENT', 'BROKER_TO_FLUSH',
'BROKER_TASK_STOP', 'CLR_MANUAL_EVENT', 'CLR_AUTO_EVENT', 'DISPATCHER_QUEUE_SEMAPHORE',
'FT_IFTS_SCHEDULER_IDLE_WAIT', 'XE_DISPATCHER_WAIT', 'XE_DISPATCHER_JOIN', 'BROKER_EVENTHANDLER',
'TRACEWRITE', 'FT_IFTSHC_MUTEX', 'SQLTRACE_INCREMENTAL_FLUSH_SLEEP',
'BROKER_RECEIVE_WAITFOR', 'ONDEMAND_TASK_QUEUE', 'DBMIRROR_EVENTS_QUEUE',
'DBMIRRORING_CMD', 'BROKER_TRANSMITTER', 'SQLTRACE_WAIT_ENTRIES',
'SLEEP_BPOOL_FLUSH', 'SQLTRACE_LOCK');
GO
/****** Object:  View [dbo].[Waits]    Script Date: 02/11/2012 12:30:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[Waits] AS SELECT  
wait_type, wait_time_ms / 1000. AS wait_time_s,100. * wait_time_ms / SUM(wait_time_ms) OVER() AS pct, 
ROW_NUMBER() OVER(ORDER BY wait_time_ms DESC) AS ranking ,waiting_tasks_count,max_wait_time_ms/1000 as max_wait_time_s
 FROM sys.dm_os_wait_stats
--where wait_time_ms   > 0
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_CheckMail]    Script Date: 02/11/2012 12:30:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_dba_CheckMail]
 as
SELECT m.mailitem_id,m.recipients,m.copy_recipients,m.subject,m.query,m.send_request_date,m.sent_status, e.description as ERROR
FROM msdb..sysmail_mailitems m join msdb..sysmail_log e on m.mailitem_id = e.mailitem_id
where m.sent_status <> 1 and m.send_request_date >= DATEADD(dd,-1,GETDATE()) and e.event_type <> 1

--SELECT * FROM msdb..sysmail_log where log_date >= DATEADD(dd,-1,GETDATE()) and event_type <> 1
GO
/****** Object:  StoredProcedure [dbo].[sp_SOS]    Script Date: 02/11/2012 12:30:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_SOS] 
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
/****** Object:  StoredProcedure [dbo].[sp_dbaDatatypeError]    Script Date: 02/11/2012 12:30:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_dbaDatatypeError] as
SELECT
	   COLUMN_NAME
	   ,[%] = CONVERT(DECIMAL(12,2),COUNT(COLUMN_NAME)* 100.0 / COUNT(*)OVER())
 INTO #Prevalence
 FROM INFORMATION_SCHEMA.COLUMNS
 GROUP BY COLUMN_NAME
 -- Do the columns differ on datatype across the schemas and tables?
 SELECT DISTINCT
		 C1.COLUMN_NAME
	   , C1.TABLE_SCHEMA
	   , C1.TABLE_NAME
	   , C1.DATA_TYPE
	   , C1.CHARACTER_MAXIMUM_LENGTH
	   , C1.NUMERIC_PRECISION
	   , C1.NUMERIC_SCALE
	   , [%]
 FROM INFORMATION_SCHEMA.COLUMNS C1
 INNER JOIN INFORMATION_SCHEMA.COLUMNS C2 ON C1.COLUMN_NAME = C2.COLUMN_NAME
 INNER JOIN #Prevalence p ON p.COLUMN_NAME = C1.COLUMN_NAME
 WHERE ((C1.DATA_TYPE != C2.DATA_TYPE)
	   OR (C1.CHARACTER_MAXIMUM_LENGTH != C2.CHARACTER_MAXIMUM_LENGTH)
	   OR (C1.NUMERIC_PRECISION != C2.NUMERIC_PRECISION)
	   OR (C1.NUMERIC_SCALE != C2.NUMERIC_SCALE))
 ORDER BY [%] DESC, C1.COLUMN_NAME, C1.TABLE_SCHEMA, C1.TABLE_NAME
 -- Tidy up.
 DROP TABLE #Prevalence
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_XEvent]    Script Date: 02/11/2012 12:30:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_dba_XEvent]
as
SELECT pkg.name, pkg.description, mod.* 
FROM sys.dm_os_loaded_modules mod 
INNER JOIN sys.dm_xe_packages pkg 
ON mod.base_address = pkg.module_address

select pkg.name as PackageName, obj.name as EventName 
from sys.dm_xe_packages pkg 
inner join sys.dm_xe_objects obj on pkg.guid = obj.package_guid 
where obj.object_type = 'event' 
order by 1, 2


select * from sys.dm_xe_object_columns 
where object_name = 'sql_statement_completed' 

select * from sys.dm_xe_object_columns 
where object_name = 'error_reported'

SELECT map_value [Event Keywords] 
FROM sys.dm_xe_map_values 
WHERE name = 'keyword_map'

select pkg.name as PackageName, obj.name as ActionName 
from sys.dm_xe_packages pkg 
inner join sys.dm_xe_objects obj on pkg.guid = obj.package_guid 
where obj.object_type = 'action' 
order by 1, 2

select pkg.name as PackageName, obj.name as TargetName 
from sys.dm_xe_packages pkg 
inner join sys.dm_xe_objects obj on pkg.guid = obj.package_guid 
where obj.object_type = 'target' 
order by 1, 2


select pkg.name as PackageName, obj.name as PredicateName 
from sys.dm_xe_packages pkg 
inner join sys.dm_xe_objects obj on pkg.guid = obj.package_guid 
where obj.object_type = 'pred_source' 
order by 1, 2



SELECT sessions.name AS SessionName, sevents.package as PackageName, 
sevents.name AS EventName, 
sevents.predicate, sactions.name AS ActionName, stargets.name AS TargetName 
FROM sys.server_event_sessions sessions 
INNER JOIN sys.server_event_session_events sevents 
ON sessions.event_session_id = sevents.event_session_id 
INNER JOIN sys.server_event_session_actions sactions 
ON sessions.event_session_id = sactions.event_session_id 
INNER JOIN sys.server_event_session_targets stargets 
ON sessions.event_session_id = stargets.event_session_id 
--WHERE sessions.name = '<your event session name>'
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_who3]    Script Date: 02/11/2012 12:30:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_dba_who3]
as
SELECT SDES.[session_id], SDES.[login_name], 
SDES.[text_size], SDES.[language], SDES.[date_format], SDES.[date_first],  
 CASE SDES.[date_first] 
   WHEN 1 THEN 'Monday' 
   WHEN 2 THEN 'Tuesday' 
   WHEN 3 THEN 'Wednesday' 
   WHEN 4 THEN 'Thursday' 
   WHEN 5 THEN 'Friday' 
   WHEN 6 THEN 'Saturday' 
   WHEN 7 THEN 'Sunday (default)' 
 END AS [date_first_desc], SDES.[quoted_identifier], SDES.[arithabort],  
    SDES.[ansi_null_dflt_on], SDES.[ansi_defaults], SDES.[ansi_warnings], SDES.[ansi_padding],  
    SDES.[ansi_nulls], SDES.[concat_null_yields_null], SDES.[transaction_isolation_level],  
    CASE SDES.[transaction_isolation_level] 
   WHEN 0 THEN 'Unspecified' 
   WHEN 1 THEN 'READUNCOMMITTED' 
   WHEN 2 THEN 'READCOMMITTED' 
   WHEN 3 THEN 'REPEATABLE' 
   WHEN 4 THEN 'SERIALIZABLE' 
   WHEN 5 THEN 'SNAPSHOT' 
 END AS [transaction_isolation_level_desc], 
    SDES.[lock_timeout], SDES.[deadlock_priority]   
FROM sys.[dm_exec_sessions] SDES  
WHERE SDES.[session_id] > 50 
ORDER BY SDES.[session_id]
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_wait3]    Script Date: 02/11/2012 12:30:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_dba_wait3]
as
set nocount on
 Select signalWaitTimeMs=sum(signal_wait_time_ms)
    ,'%signal waits' = cast(100.0 * sum(signal_wait_time_ms) / sum (wait_time_ms) as numeric(20,2))
    ,resourceWaitTimeMs=sum(wait_time_ms - signal_wait_time_ms)
    ,'%resource waits'= cast(100.0 * sum(wait_time_ms - signal_wait_time_ms) / sum (wait_time_ms) as numeric(20,2))
from sys.dm_os_wait_stats
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_lock4]    Script Date: 02/11/2012 12:30:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_dba_lock4]
as
set nocount on

declare @ExecRequests table (
id int IDENTITY(1,1) PRIMARY KEY
,session_id smallint not null
,request_id int
,start_time datetime
,status nvarchar(60)
,command nvarchar(32)
,sql_handle varbinary(64)
,statement_start_offset int
,statement_end_offset int
,plan_handle varbinary (64)
,database_id smallint
,user_id int
,blocking_session_id smallint
,wait_type nvarchar (120)
,wait_time int
,cpu_time int
,tot_time int
,reads bigint
,writes bigint
,logical_reads bigint
,[host_name] nvarchar(256)
,[program_name] nvarchar(256)
,blocking_these varchar(1000) null
)

insert into @ExecRequests (session_id,request_id, start_time,status,command,sql_handle,statement_start_offset,statement_end_offset,plan_handle,database_id,user_id,blocking_session_id,wait_type,wait_time,cpu_time,tot_time,reads,writes,logical_reads,host_name, program_name)
select r.session_id,request_id, start_time,r.status,command,sql_handle,statement_start_offset,statement_end_offset,plan_handle,r.database_id,user_id,blocking_session_id,wait_type,wait_time,r.cpu_time,r.total_elapsed_time,r.reads,r.writes,r.logical_reads,s.host_name, s.program_name
from sys.dm_exec_requests r
left outer join sys.dm_exec_sessions s on r.session_id = s.session_id
where 1=1
and r.session_id > 35 --retrieve only user spids
and r.session_id <> @@SPID --ignore myself

update @ExecRequests set blocking_these = (select isnull(convert(varchar(5), er.session_id),'') + ', '
from @ExecRequests er
where er.blocking_session_id = isnull(er.session_id ,0)
and er.blocking_session_id <> 0
FOR XML PATH('')
)

select
r.session_id, r.host_name, r.program_name, r.status
, r.blocking_these
, 'LEN(Blocking)' = LEN(r.blocking_these)
, blocked_by = r.blocking_session_id
, r.tot_time
, DBName = db_name(r.database_id), r.command, r.wait_type, r.tot_time, r.wait_time, r.cpu_time, r.reads, r.writes, r.logical_reads
, [text] = est.[text]
, offsettext = CASE WHEN r.statement_start_offset = 0 and r.statement_end_offset= 0 THEN null
ELSE
SUBSTRING (est.[text], r.statement_start_offset/2 + 1,
CASE WHEN r.statement_end_offset = -1 THEN LEN (CONVERT(nvarchar(max), est.[text]))
ELSE r.statement_end_offset/2 - r.statement_start_offset/2 + 1
END)
END
, r.statement_start_offset, r.statement_end_offset
from @ExecRequests r
outer apply sys.dm_exec_sql_text (r.sql_handle) est
order by LEN(r.blocking_these) desc, r.session_id asc
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_lock2]    Script Date: 02/11/2012 12:30:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_dba_lock2]
as
set nocount on 
SELECT
   DB_NAME() AS database_name, 
   GETDATE() AS audit_time, 
   s.spid AS process_id, 
   s.blocked AS blocking_process_id,
   s.hostname, 
   s.loginame, 
   s.program_name,
   blocking_s.hostname AS blocking_hostname, 
   blocking_s.loginame AS blocking_loginame, 
   blocking_s.program_name AS blocking_program_name,
   REPLACE(REPLACE(buffer.[text], CHAR(10), ''), 
           CHAR(9), '') AS sql_statement,
   SUBSTRING (buffer.[text], request.statement_start_offset/2, 
   (CASE 
      WHEN request.statement_end_offset = -1 
      THEN LEN(CONVERT(NVARCHAR(MAX), buffer.[text])) * 2 
      ELSE request.statement_end_offset 
    END - request.statement_start_offset)/2) AS specific_sql,
   REPLACE(REPLACE(blocking_buffer.[text], CHAR(10), ''), 
           CHAR(9), '') AS blocking_sql_statement,
   o.[name] AS blocking_object, 
   blocking_tr_locks.request_mode
FROM 
   sys.sysprocesses s INNER JOIN
   sys.dm_exec_connections conn
ON
   s.spid = conn.session_id CROSS APPLY 
   sys.dm_exec_sql_text(conn.most_recent_sql_handle) AS buffer 
   LEFT JOIN sys.dm_exec_requests request
ON
   conn.session_id = request.session_id INNER JOIN
   sys.dm_exec_connections blocking_conn 
ON
   s.blocked = blocking_conn.session_id CROSS APPLY 
   sys.dm_exec_sql_text(blocking_conn.most_recent_sql_handle) 
   AS blocking_buffer INNER JOIN
   sys.dm_tran_locks blocking_tr_locks
ON
   s.blocked = blocking_tr_locks.request_session_id INNER JOIN
   sys.objects o 
ON
   blocking_tr_locks.resource_associated_entity_id = o.object_id 
   INNER JOIN sys.sysprocesses blocking_s
ON
   s.blocked = blocking_s.spid
WHERE
   s.blocked <> 0
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_lock]    Script Date: 02/11/2012 12:30:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_dba_lock]
as
SELECT 
        t1.resource_type,
        t1.resource_database_id,
        t1.resource_associated_entity_id,
        t1.request_mode,
        t1.request_session_id,
        t2.blocking_session_id
    FROM sys.dm_tran_locks as t1
    INNER JOIN sys.dm_os_waiting_tasks as t2
        ON t1.lock_owner_address = t2.resource_address

SELECT DTL.resource_type,  
   CASE   
       WHEN DTL.resource_type IN ('DATABASE', 'FILE', 'METADATA') THEN DTL.resource_type  
       WHEN DTL.resource_type = 'OBJECT' THEN OBJECT_NAME(DTL.resource_associated_entity_id)  
       WHEN DTL.resource_type IN ('KEY', 'PAGE', 'RID') THEN   
           (  
           SELECT OBJECT_NAME([object_id])  
           FROM sys.partitions  
           WHERE sys.partitions.hobt_id =   
           DTL.resource_associated_entity_id  
           )  
       ELSE 'Unidentified'  
   END AS requested_object_name, DTL.request_mode, DTL.request_status,    
   DOWT.wait_duration_ms, DOWT.wait_type, DOWT.session_id AS [blocked_session_id],  
   sp_blocked.[loginame] AS [blocked_user], DEST_blocked.[text] AS [blocked_command], 
   DOWT.blocking_session_id, sp_blocking.[loginame] AS [blocking_user],  
   DEST_blocking.[text] AS [blocking_command], DOWT.resource_description     
FROM sys.dm_tran_locks DTL  
   INNER JOIN sys.dm_os_waiting_tasks DOWT   
       ON DTL.lock_owner_address = DOWT.resource_address   
   INNER JOIN sys.sysprocesses sp_blocked  
       ON DOWT.[session_id] = sp_blocked.[spid] 
   INNER JOIN sys.sysprocesses sp_blocking  
       ON DOWT.[blocking_session_id] = sp_blocking.[spid] 
   CROSS APPLY sys.[dm_exec_sql_text](sp_blocked.[sql_handle]) AS DEST_blocked 
   CROSS APPLY sys.[dm_exec_sql_text](sp_blocking.[sql_handle]) AS DEST_blocking 
WHERE DTL.[resource_database_id] = DB_ID()
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_kill]    Script Date: 02/11/2012 12:30:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_dba_kill] @parm nvarchar(40)  
as  
set nocount on  
declare @kill table (spid nvarchar(20),id int)  
declare @min nvarchar(20), @max nvarchar(20)  

  
if isnumeric(@parm ) = 1  
begin  
select 'Matando: ', @parm  
select @parm = N'Kill '+@parm  
exec sp_executesql @parm  
return  
end  
  
if exists (select 1 from master..syslogins where name = @parm)  
begin  
select 'Matando todas as conexoes do login ',@parm  
  
insert @kill select rtrim(convert(nvarchar(10),spid))  ,spid 
from master..sysprocesses p left join master..syslogins l on p.sid = l.sid where l.name = @parm  and spid <> @@spid

select @min = min(id) , @max = max(id) from @kill  

while @min <= @max  
begin  
select 'matando: ',@min  
select @parm = N'Kill '+ltrim(rtrim(spid )) from @kill where id = @min
exec sp_executesql @parm  
select @min = min(spid) from @kill where id > @min  
end  
end




if exists (select 1 from master..sysdatabases where name = @parm)  
begin  
select 'Matando todas as conexoes do db ',@parm  
    
insert @kill select rtrim(convert(nvarchar(10),spid))  ,spid 
from master..sysprocesses p left 
join master..syslogins l on p.sid = l.sid 
join master..sysdatabases d on p.dbid = d.dbid
where d.name = @parm  and spid <> @@spid and spid > 50

select @min = min(id) , @max = max(id) from @kill  

while @min <= @max  
begin  
select 'matando: ',@min  
select @parm = N'Kill '+ltrim(rtrim(spid )) from @kill where id = @min
exec sp_executesql @parm  
select @min = min(spid) from @kill where id > @min  
end  
end
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_vw]    Script Date: 02/11/2012 12:30:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_dba_vw]
as
begin
set nocount on
declare @db nvarchar(200) = db_name()
declare @SQL nvarchar(4000) ='
select name, create_date from '+@db+'.sys.views order by 1';
EXEC sp_executeSQL @SQL; 
end
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_version]    Script Date: 02/11/2012 12:30:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_dba_version]
as
begin
 
 select getdate(),
           cast(serverproperty('machinename') as varchar(20)),
           cast(serverproperty('productversion') as varchar(20)),
           cast(serverproperty('productlevel') as varchar(20)),
           cast(serverproperty('edition')  as varchar(40))
end
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_tran]    Script Date: 02/11/2012 12:30:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_dba_tran]
as
set nocount on
SELECT 
	tat.transaction_id [TransactionID],
	tat.transaction_begin_time [TranBeginTime],
	CASE tat.transaction_type
		WHEN 1 THEN 'Read/Write transaction'
		WHEN 2 THEN 'Read-only transaction'
		WHEN 3 THEN 'System transaction'
		WHEN 4 THEN 'Distributed transaction'
	END [TranType],
	CASE tat.transaction_state
		WHEN 0 THEN 'Not completely initialized'
		WHEN 1 THEN 'Initialized but not started'
		WHEN 2 THEN 'Active'
		WHEN 3 THEN 'Ended(read-only transaction)'
		WHEN 4 THEN 'Commit initiated for distributed transaction'
		WHEN 5 THEN 'Transaction prepared and waiting for resolution'
		WHEN 6 THEN 'Committed'
		WHEN 7 THEN 'Transaction is being rolled back'
		WHEN 8 THEN 'Rolled back'
	END [TranStatus],
	tst.session_id [SPID],
	tst.is_user_transaction [IsUserTransaction],
	s.[text] [MostRecentSQLRun]
FROM 
	sys.dm_tran_active_transactions [tat] 
	
	JOIN sys.dm_tran_session_transactions [tst]
		ON tat.transaction_id = tat.transaction_id
		
	JOIN sys.dm_exec_connections [dec]
		ON [dec].session_id = tst.session_id
	
	CROSS APPLY sys.dm_exec_sql_text([dec].most_recent_sql_handle) s

ORDER BY
	[TranBeginTime]
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_tbUse]    Script Date: 02/11/2012 12:30:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_dba_tbUse] as
set nocount on
SELECT 
isnull(DB_NAME(ios.database_id),DB_NAME(ius.database_id)) AS DBName,
isnull(OBJECT_NAME(ios.object_id),OBJECT_NAME(ius.object_id)) AS TableName,
max(ips.record_count) as Rows,
convert(dec(12,2),SUM (ips.avg_record_size_in_bytes/1024)* max(ips.record_count)) as Size_MB,
SUM(ius.user_scans) AS Scans ,
SUM(ius.user_lookups) AS Lookups ,
SUM(ius.user_seeks) AS Seeks,
SUM(ius.user_updates) AS Updates ,
sum(ios.LEAF_INSERT_COUNT) as LeafInserts, 
sum(ios.LEAF_UPDATE_COUNT)as LeafUpdates, 
sum(ios.LEAF_DELETE_COUNT) as LeafDeletes, 
sum(ios.range_scan_count) as RangeScans, 
sum(ios.row_lock_count) as Locks,
sum(ios.row_lock_wait_in_ms) as LockWait_Ms,
max(ips.avg_fragmentation_in_percent) as FragmentationPct,
max(ips.avg_page_space_used_in_percent) as SpaceUsedPct
FROM SYS.DM_DB_INDEX_OPERATIONAL_STATS (DB_ID(),null,NULL,NULL )  ios
left outer join sys.dm_db_index_usage_stats ius  on ius.database_id = ios.database_id and ios.object_id = ius.object_id and ios.index_id = ius.index_id
right outer join SYS.dm_db_index_physical_stats (DB_ID(),null,NULL,NULL,'DETAILED' )  ips on ips.database_id = ios.database_id and ios.object_id = ips.object_id and ios.index_id = ips.index_id
where 
ios.database_id = DB_ID() and 
OBJECTPROPERTY(ios.object_id,'IsUserTable') = 1 and
ios.index_id in (0,1) and OBJECT_NAME(ios.object_id) <> 'sysdiagrams' 
GROUP BY isnull(DB_NAME(ios.database_id),DB_NAME(ius.database_id)), isnull(OBJECT_NAME(ios.object_id),OBJECT_NAME(ius.object_id))
ORDER BY 3 DESC
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_tb]    Script Date: 02/11/2012 12:30:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_dba_tb]    
@tb varchar(100) = null  
as    
begin    
set nocount on    
SELECT 
DB_NAME(ios.database_id) AS DBName,
OBJECT_NAME(ios.object_id) AS TableName,
max(ips.record_count) as Rows,
convert(dec(10,4),SUM (ips.avg_record_size_in_bytes/1024/1024)* max(ips.record_count))*0.4 as Size_MB
FROM SYS.DM_DB_INDEX_OPERATIONAL_STATS (DB_ID(),null,NULL,NULL )  ios
--left outer join sys.dm_db_index_usage_stats ius  on ius.database_id = ios.database_id and ios.object_id = ius.object_id and ios.index_id = ius.index_id
right outer join SYS.dm_db_index_physical_stats (DB_ID(),null,NULL,NULL,'DETAILED' )  ips on ips.database_id = ios.database_id and ios.object_id = ips.object_id and ios.index_id = ips.index_id
where 
ios.database_id = DB_ID() and 
OBJECTPROPERTY(ios.object_id,'IsUserTable') = 1 and
ios.index_id in (0,1) and OBJECT_NAME(ios.object_id) <> 'sysdiagrams' and OBJECT_NAME(ios.object_id) = ISNULL(@tb,OBJECT_NAME(ios.object_id))
GROUP BY DB_NAME(ios.database_id),OBJECT_NAME(ios.object_id)
ORDER BY 3 DESC
   
if @@ROWCOUNT = 0
begin
declare @db nvarchar(200) = db_name()
declare @SQL nvarchar(4000) ='
select name, create_date from '+@db+'.sys.tables order by 1';
EXEC sp_executeSQL @SQL; 
end    
end
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_string]    Script Date: 02/11/2012 12:30:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_dba_string]
@string varchar (50) 
as
set nocount on
select 'Objetos que usam: ',@string
select @string = '''%'+@string+'%'''
declare @comm varchar(600)
select @comm = 'select o.name from ?..syscomments c join ?..sysobjects o on o.id = c.id where text like '+@string+' order by 1'
--select @comm
exec sp_msforeachdb @command1 = @comm
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_monitor]    Script Date: 02/11/2012 12:30:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_dba_monitor] @horas int = -24
as
begin
set nocount on
create table #result (result varchar (500))
create table #result2 (drive varchar (5), MbFree int)


insert #result select 'SERVER: '+@@SERVERNAME + '  Date: '+CONVERT(CHAR(30),GETDATE())
insert #result select 'VERSION: '+ cast(serverproperty('productversion') as varchar(20)) + ' '+
cast(serverproperty('productlevel') as varchar(20))+ ' '+ cast(serverproperty('edition')  as varchar(40))  

IF NOT EXISTS (SELECT 1 FROM master.dbo.sysprocesses WHERE program_name = N'SQLAgent - Generic Refresher') 
insert #result select 'AGENT: The SQL Server Agent process is NOT running.'
ELSE 
insert #result select 'AGENT: The SQL Server Agent process is running.'

insert #result
select 'CONNECTIONS: ' + convert (char(30),COUNT(dbid)) 
FROM sys.sysprocesses WITH (nolock) WHERE dbid > 0 and spid > 50 

insert #result
select 'MAILS NOT SENT TODAY (ERROR): '+ CONVERT (char(30),count (*)) from msdb..sysmail_mailitems m where  m.sent_status <> 1 
and m.send_request_date >= DATEADD(dd,-1,GETDATE()) 

insert #result
select 'LAST SENT MAIL: '+ isnull(convert(char(30),max (send_request_date)),0) from msdb..sysmail_mailitems m where  m.sent_status = 1 


--xp_fixeddrives
insert #result2
exec master..xp_fixeddrives

insert #result
select 'FREE SPACE ON DRIVE '+ drive +' = '+ CONVERT(varchar(15),MbFree) + ' MbFree' from #result2

-- LOG

---- HELP da xp_readerrrorlog

--Even though sp_readerrolog accepts only 4 parameters, the extended stored procedure accepts at least 7 parameters.
--If this extended stored procedure is called directly the parameters are as follows:

--1.Value of error log file you want to read: 0 = current, 1 = Archive #1, 2 = Archive #2, etc... 
--2.Log file type: 1 or NULL = error log, 2 = SQL Agent log 
--3.Search string 1: String one you want to search for 
--4.Search string 2: String two you want to search for to further refine the results 
--5.Search from start time   
--6.Search to end time 
--7.Sort order for results: N'asc' = ascending, N'desc' = descending


declare @dataIni datetime = dateadd (hh,@horas,getdate()), @dataFim datetime = getdate()  
create table #log (data datetime, process varchar(15), log_text varchar(500))
-- FILE 0 - Current
insert #log exec xp_readerrorlog 0,1,'error:',null,@dataIni, @dataFim, N'asc'
insert #log exec xp_readerrorlog 0,1,'failed',null,@dataIni, @dataFim, N'asc'
insert #log exec xp_readerrorlog 0,1,'This instance of sql server has been',null,@dataIni, @dataFim, N'asc'
insert #log exec xp_readerrorlog 0,1,'shutdown',null,@dataIni, @dataFim, N'asc'
insert #log exec xp_readerrorlog 0,1,'shutting down',null,@dataIni, @dataFim, N'asc'
insert #log exec xp_readerrorlog 0,1,'start',null,@dataIni, @dataFim, N'asc'
insert #log exec xp_readerrorlog 0,1,'using',null,@dataIni, @dataFim, N'asc'
-- FILE 1 - Current + 1
insert #log exec xp_readerrorlog 1,1,'error:',null,@dataIni, @dataFim, N'asc'
insert #log exec xp_readerrorlog 1,1,'failed',null,@dataIni, @dataFim, N'asc'
insert #log exec xp_readerrorlog 1,1,'shutdown',null,@dataIni, @dataFim, N'asc'
insert #log exec xp_readerrorlog 1,1,'shutting down',null,@dataIni, @dataFim, N'asc'
insert #log exec xp_readerrorlog 1,1,'start',null,@dataIni, @dataFim, N'asc'
insert #log exec xp_readerrorlog 1,1,'using',null,@dataIni, @dataFim, N'asc'

insert #result
select 'DB SIZES: ' union
select DB_NAME(dbid) +' '+ convert (varchar(30),sum(size)*8/1024/1024) + ' GB'  from master..sysaltfiles where
--where DB_NAME(dbid) <> 'ipdb' and DB_NAME(dbid) <> 'dbawork' and 
DB_NAME(dbid) <> 'master' and DB_NAME(dbid) <> 'msdb' and DB_NAME(dbid) <> 'model'
 group by dbid

----insert #result select 'LAST SHUTDOWN: ' + CONVERT(varchar(30),data)+ ' '+ process +' '+ log_text 
----from #log where log_text like '%SQL%system%shutdown.%' 
----if @@ROWCOUNT = 0
----insert #result select 'LAST SHUTDOWN: UNEXPECTED SHUTDOWN '
--insert #result select distinct 'LAST STARTUP: ' + CONVERT(varchar(30),data)+ ' '+ process +' '+ log_text from #log
--where log_text like 'This instance of sql server last%' 
----and convert(int,substring( process,5,2) ) < 50
--and log_text is not null and data is not null

insert #result select 'ERRRORLOG:'
insert #result select distinct CONVERT(varchar(30),data)+ ' '+ process +' '+ log_text from #log 
where log_text is not null and data is not null
order by 1 desc

-- FIM
select * from #result where result is not null


drop table #result
drop table #log
end
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_mail]    Script Date: 02/11/2012 12:31:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_dba_mail]
 as
SELECT m.mailitem_id,m.recipients,m.copy_recipients,m.subject,m.query,m.send_request_date,m.sent_status, e.description as ERROR
FROM msdb..sysmail_mailitems m join msdb..sysmail_log e on m.mailitem_id = e.mailitem_id
where m.sent_status <> 1 and m.send_request_date >= DATEADD(dd,-1,GETDATE()) and e.event_type <> 1

SELECT * FROM msdb..sysmail_log where log_date >= DATEADD(dd,-1,GETDATE()) and event_type <> 1
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_log]    Script Date: 02/11/2012 12:31:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_dba_log]
as
begin
declare  @trx_log_size TABLE
 (
 database_name nvarchar(128) NOT NULL,
 [name] nvarchar(128) NOT NULL,
 physical_name nvarchar(260) NOT NULL,
 size_mb int NOT NULL
 )
 
--+-----------------------------------------------
--Populate temp table with current log file sizes 
--+-----------------------------------------------
INSERT INTO @trx_log_size
SELECT db_name(database_id), name, physical_name, size*8/1024 
FROM sys.master_files WHERE type = 1;
--+-----------------------------------------------
/*
File size::backup size (Full recovery DBs)
 ctl+shift+m to replace days param to include in
  analysis of backup history
*/
--+-----------------------------------------------
SELECT
 L.[database_name], 
 L.[physical_name], 
 L.[size_mb], 
 MAX(CEILING(BF.[backup_size]/1024/1024)) AS max_backup_file_size_mb,
 L.[size_mb] - MAX(CEILING(BF.[backup_size]/1024/1024)) AS file_excess_mb
FROM msdb.dbo.[backupfile] BF 
 INNER JOIN msdb.dbo.[backupset] BS ON [BF].[backup_set_id] = [BS].[backup_set_id]
 INNER JOIN @trx_log_size L ON [BS].[database_name] = L.[database_name]
 INNER JOIN master.sys.[databases] SD ON L.[database_name] = SD.[name]
WHERE BS.[type] = 'L'
-- AND BS.[backup_start_date] > DATEADD(d,<days_in_backup_sample,int,-1>,GETDATE())
 AND SD.[recovery_model_desc] = 'FULL'
GROUP BY SD.[name], L.[database_name], L.[physical_name], L.[size_mb]
HAVING  L.[size_mb] > MAX(CEILING(BF.[backup_size]/1024/1024))
ORDER BY L.[size_mb] - MAX(CEILING(BF.[backup_size]/1024/1024)) DESC;
--+-----------------------------------------------
--Clean up your messes when you're done!
--+-----------------------------------------------
end
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_startup]    Script Date: 02/11/2012 12:31:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_dba_startup]
as
--dbcc traceon (8033)
--dbcc traceon (830)
dbcc traceon (1204)

declare @assunto varchar(100)
select @assunto = rtrim(substring(@@servername,1,30))+': Servidor Reiniciando em: '+convert(varchar(19),getdate())

EXEC msdb.dbo.sp_send_dbmail
    @profile_name = 'bdnotifier',
	@execute_query_database = 'master',
	@recipients = 'rodrigo@grupoxango.com', 
    @subject = @assunto,
    @query = 'select name,state_Desc,is_cdc_enabled,is_encrypted from sys.databases',
    @query_result_header = 1,
    @importance = 'high',
--@attach_query_result_as_file = 1,@query_attachment_filename= 'startup.xls',
@query_result_width = 3000,@query_no_truncate=1,
    @body_format = 'HTML'
GO
EXEC sp_procoption N'[dbo].[sp_dba_startup]', 'startup', '1'
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_JobsOutput]    Script Date: 02/11/2012 12:31:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_dba_JobsOutput]
as
set nocount on
;WITH Flags (FlagID, FlagValue) 

AS

(

   SELECT 0 AS FlagID, 'Overwrite output file' AS FlagValue UNION ALL

   SELECT 2 AS FlagID, 'Append to output file' AS FlagValue UNION ALL

   SELECT 4 AS FlagID, 'Write Transact-SQL job step output to step history' AS FlagValue UNION ALL

   SELECT 8 AS FlagID, 'Write log to table (overwrite existing history)' UNION ALL 

   SELECT 16 AS FlagID, 'Write log to table (append to existing history)'

),

JobsInfo (Job_Name, Jobstep_ID, Jobstep_Name, Flags)

AS

(

SELECT 

   j.name as [Job_Name]

   , js.step_name as [Jobstep_Name]

   , js.step_id as [Jobstep_ID]

   , flags 

FROM msdb.dbo.sysjobsteps js JOIN msdb.dbo.sysjobs j 

ON js.job_id = j.job_id

),

FinalData (Job_Name, JobStep_Name, [Jobstep_ID], FlagValue)

AS

(

SELECT 

   Job_Name

   , Jobstep_Name

   , [Jobstep_ID]

   , F.FlagValue

FROM JobsInfo JI CROSS JOIN Flags F 

WHERE JI.Flags & F.FlagID <> 0 

)

SELECT DISTINCT 

   JI.Job_Name

   , JI.[Jobstep_ID]

   , JI.Jobstep_Name

   , ISNULL(STUFF (( SELECT ', ' + FD2.FlagValue FROM FinalData FD2 

WHERE FD2.Job_Name = FD1.Job_Name AND FD2.Jobstep_Name = FD1.Jobstep_Name 

ORDER BY ', ' + FD2.FlagValue FOR XML PATH('')), 1, 1, ' '), 'Overwrite output file') AS OptionsSet

FROM FinalData FD1 RIGHT OUTER JOIN JobsInfo JI

ON FD1.Job_Name = JI.Job_Name AND FD1.Jobstep_Name = JI.Jobstep_Name

ORDER BY Job_Name, Jobstep_Name
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_wait2]    Script Date: 02/11/2012 12:31:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_dba_wait2]
as
SELECT
    W1.wait_type AS WaitType,w3.waitdesc, 
    CAST (W1.WaitS AS DECIMAL(14, 2)) AS Wait_S,
    CAST (W1.ResourceS AS DECIMAL(14, 2)) AS Resource_S,
    CAST (W1.SignalS AS DECIMAL(14, 2)) AS Signal_S,
    W1.WaitCount AS WaitCount,
    CAST (W1.Percentage AS DECIMAL(4, 2)) AS Percentage,
    CAST ((W1.WaitS / W1.WaitCount) AS DECIMAL (14, 4)) AS AvgWait_S,
    CAST ((W1.ResourceS / W1.WaitCount) AS DECIMAL (14, 4)) AS AvgRes_S,
    CAST ((W1.SignalS / W1.WaitCount) AS DECIMAL (14, 4)) AS AvgSig_S
FROM Waits2 AS W1
    INNER JOIN Waits2 AS W2 ON W2.RowNum <= W1.RowNum
    join  dbawaittypes w3 on w1.wait_type = w3.waittype
GROUP BY W1.RowNum, W1.wait_type, w3.waitdesc,W1.WaitS, W1.ResourceS, W1.SignalS, W1.WaitCount, W1.Percentage
HAVING SUM (W2.Percentage) - W1.Percentage < 95 -- percentage threshold
order by 7 desc
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_wait]    Script Date: 02/11/2012 12:31:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_dba_wait] as
SELECT W1.wait_type, w3.waitdesc,
 CAST(W1.wait_time_s AS DECIMAL(12, 2)) AS wait_time_s, 
 CAST(W1.waiting_tasks_count AS DECIMAL(12,0)) AS tasks_count, 
 CAST(W1.max_wait_time_s AS DECIMAL(12, 2)) AS max_wait_time_s, 
 CAST(W1.pct AS DECIMAL(12, 2)) AS pct, 
 CAST(SUM(W2.pct) AS DECIMAL(12, 2)) AS running_pct 
FROM Waits AS W1  INNER JOIN Waits AS W2 ON W2.ranking <= W1.ranking 
join  dbawaittypes w3 on w1.wait_type = w3.waittype
GROUP BY W1.ranking,  
 W1.wait_type, w3.waitdesc, W1.wait_time_s ,w1.max_wait_time_s,w1.waiting_tasks_count,W1.pct
HAVING SUM(W2.pct) - W1.pct < 95 -- percentage threshold
order by 6 desc;
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_monitor2]    Script Date: 02/11/2012 12:31:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_dba_monitor2] as
begin
set nocount on
SELECT '*** Start of DAC Report ***'

SELECT '-- Shows SQL Servers information'EXEC ('USE MASTER') 
SELECT  CONVERT(char(20), SERVERPROPERTY('MachineName')) AS 'MACHINE NAME',  CONVERT(char(20), SERVERPROPERTY('ServerName')) AS 'SQL SERVER NAME', (CASE WHEN CONVERT(char(20), SERVERPROPERTY('InstanceName')) IS NULL THEN 'Default Instance' ELSE CONVERT(char(20), SERVERPROPERTY('InstanceName')) END) AS 'INSTANCE NAME',

CONVERT(char(20), SERVERPROPERTY('EDITION')) AS EDITION, CONVERT(char(20), SERVERPROPERTY('ProductVersion')) AS 'PRODUCT VERSION', CONVERT(char(20), SERVERPROPERTY('ProductLevel')) AS 'PRODUCT LEVL',

(CASE WHEN CONVERT(char(20), SERVERPROPERTY('ISClustered')) = 1 THEN 'Clustered' WHEN CONVERT(char(20), SERVERPROPERTY('ISClustered')) = 0 THEN 'NOT Clustered' ELSE 'INVALID INPUT/ERROR' END) AS 'FAILOVER CLUSTERED',

(CASE WHEN CONVERT(char(20), SERVERPROPERTY('ISIntegratedSecurityOnly')) = 1 THEN 'Integrated Security ' WHEN CONVERT(char(20), SERVERPROPERTY('ISIntegratedSecurityOnly')) = 0 THEN 'SQL Server Security ' ELSE 'INVALID INPUT/ERROR' END) AS 'SECURITY',

(CASE WHEN CONVERT(char(20), SERVERPROPERTY('ISSingleUser')) = 1 THEN 'Single User' WHEN CONVERT(char(20), SERVERPROPERTY('ISSingleUser')) = 0 THEN 'Multi User' ELSE 'INVALID INPUT/ERROR' END) AS 'USER MODE',

CONVERT(char(30), SERVERPROPERTY('COLLATION')) AS COLLATION



SELECT '-- Shows top 5 high cpu used statemants'SELECT TOP 5 total_worker_time/execution_count AS [Avg CPU Time], SUBSTRING(st.text, (qs.statement_start_offset/2)+1,  ((CASE qs.statement_end_offset WHEN -1 THEN DATALENGTH(st.text) ELSE qs.statement_end_offset END - qs.statement_start_offset)/2) + 1) AS statement_text FROM sys.dm_exec_query_stats AS qs CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st ORDER BY total_worker_time/execution_count DESC;



SELECT '-- Shows who so logged in'SELECT login_name ,COUNT(session_id) AS session_count FROM sys.dm_exec_sessions GROUP BY login_name;



SELECT '-- Shows long running cursors'EXEC ('USE master')

SELECT creation_time ,cursor_id  ,name ,c.session_id ,login_name FROM sys.dm_exec_cursors(0) AS c JOIN sys.dm_exec_sessions AS s  ON c.session_id = s.session_id WHERE DATEDIFF(mi, c.creation_time, GETDATE()) > 5;

SELECT '-- Shows idle sessions that have open transactions'SELECT s.* FROM sys.dm_exec_sessions AS s WHERE EXISTS  ( SELECT *  FROM sys.dm_tran_session_transactions AS t WHERE t.session_id = s.session_id ) AND NOT EXISTS  ( SELECT *  FROM sys.dm_exec_requests AS r WHERE r.session_id = s.session_id );

SELECT '-- Shows free space in tempdb database'SELECT SUM(unallocated_extent_page_count) AS [free pages], (SUM(unallocated_extent_page_count)*1.0/128) AS [free space in MB]FROM sys.dm_db_file_space_usage;



SELECT '-- Shows total disk allocated to tempdb database'SELECT SUM(size)*1.0/128 AS [size in MB]FROM tempdb.sys.database_files

SELECT '-- Show active jobs'SELECT DB_NAME(database_id) AS [Database], COUNT(*) AS [Active Async Jobs]FROM sys.dm_exec_background_job_queue WHERE in_progress = 1GROUP BY database_id;



SELECT '--Shows clients connected'SELECT session_id, client_net_address, client_tcp_port FROM sys.dm_exec_connections;

SELECT '--Shows running batch'SELECT * FROM sys.dm_exec_requests;



SELECT '--Shows currently blocked requests'SELECT session_id ,status ,blocking_session_id ,wait_type ,wait_time ,wait_resource  ,transaction_id FROM sys.dm_exec_requests WHERE status = N'suspended'



SELECT '--Shows last backup dates ' as ' 'SELECT B.name as Database_Name,  ISNULL(STR(ABS(DATEDIFF(day, GetDate(),  MAX(Backup_finish_date)))), 'NEVER')  as DaysSinceLastBackup, ISNULL(Convert(char(10),  MAX(backup_finish_date), 101), 'NEVER')  as LastBackupDate FROM master.dbo.sysdatabases B LEFT OUTER JOIN msdb.dbo.backupset A  ON A.database_name = B.name AND A.type = 'D' GROUP BY B.Name ORDER BY B.name

SELECT '--Shows jobs that are still executing' as ' ' exec msdb.dbo.sp_get_composite_job_info NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL

SELECT '--Shows failed MS SQL jobs report' as ' ' SELECT name FROM msdb.dbo.sysjobs A, msdb.dbo.sysjobservers B WHERE A.job_id = B.job_id AND B.last_run_outcome = 0

SELECT '--Shows disabled jobs ' as ' ' SELECT name FROM msdb.dbo.sysjobs WHERE enabled = 0 ORDER BY name

SELECT '--Shows avail free DB space ' as ' ' exec sp_MSForEachDB 'Use ? SELECT name AS ''Name of File'', size/128.0 -CAST(FILEPROPERTY(name, ''SpaceUsed'' ) AS int)/128.0 AS ''Available Space In MB'' FROM .SYSFILES'

SELECT '--Shows total DB size (.MDF+.LDF)' as ' '  set nocount on declare @name sysname declare @SQL nvarchar(600) -- Use temporary table to sum up database size w/o using group by  
create table #databases ( DATABASE_NAME sysname NOT NULL, size int NOT NULL) 
declare c1 cursor for  select name from master.dbo.sysdatabases -- 
where has_dbaccess(name) = 1 -- Only look at databases to which we have access 
open c1 fetch c1 into @name

while @@fetch_status >= 0 
begin 
select @SQL = 'insert into #databases select N'''+ @name + ''', sum(size) from ' + QuoteName(@name) + '.dbo.sysfiles' -- Insert row for each database  
execute (@SQL) 
fetch c1 into @name 
end 
deallocate c1

select 
DATABASE_NAME, DATABASE_SIZE_MB = size*8/1000 -- Convert from 8192 byte pages to K and then convert to MB 
from #databases order by 1 

select SUM(size*8/1000) as '--Shows disk space used - ALL DBs - MB ' 
from #databases 
drop table #databases

SELECT '--Show hard drive space available ' as ' ' EXEC master..xp_fixeddrives

SELECT '*** End of Report ****'
end
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_GeralServer]    Script Date: 02/11/2012 12:31:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_dba_GeralServer]
as
 
--Step 1: Setting NULLs and quoted identifiers to ON and checking the version of SQL Server 
		
		SET ANSI_NULLS ON
		
		SET QUOTED_IDENTIFIER ON
		

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'prodver') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)                        
drop table prodver
create table prodver ([index] int, Name nvarchar(50),Internal_value int, Charcater_Value nvarchar(50))
insert into prodver exec xp_msver 'ProductVersion'
	if (select substring(Charcater_Value,1,1)from prodver)!=8
	begin
	
                   
-- Step 2: This code will be used if the instance is Not SQL Server 2000 

		Declare @image_path nvarchar(100)                        
		Declare @startup_type int                        
		Declare @startuptype nvarchar(100)                        
		Declare @start_username nvarchar(100)                        
		Declare @instance_name nvarchar(100)                        
		Declare @system_instance_name nvarchar(100)                        
		Declare @log_directory nvarchar(100)                        
		Declare @key nvarchar(1000)                        
		Declare @registry_key nvarchar(100)                        
		Declare @registry_key1 nvarchar(300)                        
		Declare @registry_key2 nvarchar(300)                        
		Declare @IpAddress nvarchar(20)                        
		Declare @domain nvarchar(50)                        
		Declare @cluster int                        
		Declare @instance_name1 nvarchar(100)                        
-- Step 3: Reading registry keys for IP,Binaries,Startup type ,startup username, errorlogs location and domain.
		SET @instance_name = coalesce(convert(nvarchar(100), serverproperty('InstanceName')),'MSSQLSERVER');                        
		If @instance_name!='MSSQLSERVER'                        
		Set @instance_name=@instance_name                       
	 
    		Set @instance_name1= coalesce(convert(nvarchar(100), serverproperty('InstanceName')),'MSSQLSERVER');                        
		If @instance_name1!='MSSQLSERVER'                        
		Set @instance_name1='MSSQL$'+@instance_name1                        
		EXEC master.dbo.xp_regread N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\Microsoft SQL Server\Instance Names\SQL', @instance_name, @system_instance_name output;                        
                        
		Set @key=N'SYSTEM\CurrentControlSet\Services\' +@instance_name1;                        
		SET @registry_key = N'Software\Microsoft\Microsoft SQL Server\' + @system_instance_name + '\MSSQLServer\Parameters';                        
		If @registry_key is NULL                        
		set @instance_name=coalesce(convert(nvarchar(100), serverproperty('InstanceName')),'MSSQLSERVER');                        
		EXEC master.dbo.xp_regread N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\Microsoft SQL Server\Instance Names\SQL', @instance_name, @system_instance_name output;                        

		SET @registry_key = N'Software\Microsoft\Microsoft SQL Server\' + @system_instance_name + '\MSSQLServer\Parameters';                        
		SET @registry_key1 = N'Software\Microsoft\Microsoft SQL Server\' + @system_instance_name + '\MSSQLServer\supersocketnetlib\TCP\IP1';                        
		SET @registry_key2 = N'SYSTEM\ControlSet001\Services\Tcpip\Parameters\';                        
                        
		EXEC master.dbo.xp_regread 'HKEY_LOCAL_MACHINE',@key,@value_name='ImagePath',@value=@image_path OUTPUT                        
		EXEC master.dbo.xp_regread 'HKEY_LOCAL_MACHINE',@key,@value_name='Start',@value=@startup_type OUTPUT                        
		EXEC master.dbo.xp_regread 'HKEY_LOCAL_MACHINE',@key,@value_name='ObjectName',@value=@start_username OUTPUT                        
		EXEC master.dbo.xp_regread 'HKEY_LOCAL_MACHINE',@registry_key,@value_name='SQLArg1',@value=@log_directory OUTPUT                        
		EXEC master.dbo.xp_regread 'HKEY_LOCAL_MACHINE',@registry_key1,@value_name='IpAddress',@value=@IpAddress OUTPUT                        
		EXEC master.dbo.xp_regread 'HKEY_LOCAL_MACHINE',@registry_key2,@value_name='Domain',@value=@domain OUTPUT                        
                        
		Set @startuptype= 	(select 'Start Up Mode' =                        
					CASE                        
					WHEN @startup_type=2 then 'AUTOMATIC'                        
					WHEN @startup_type=3 then 'MANUAL'                        
					WHEN @startup_type=4 then 'Disabled'                        
					END)                        
                        
--Step 4: Getting the cluster node names if the server is on cluster .else this value will be NULL.

		declare @Out nvarchar(400)                        
		SELECT @Out = COALESCE(@Out+'' ,'') + Nodename                        
		from sys.dm_os_cluster_nodes                        
                        
-- Step 5: printing Server details 
                        
			SELECT                       
			@domain as 'Domain',                      
			serverproperty('ComputerNamePhysicalNetBIOS') as 'MachineName',                      
			CPU_COUNT as 'CPUCount',
			(physical_memory_in_bytes/1048576) as 'PhysicalMemoryMB',                      
			@Ipaddress as 'IP_Address',                      
			@instance_name1 as 'InstanceName',
			@image_path as 'BinariesPath',                      
			@log_directory as 'ErrorLogsLocation',                      
			@start_username as 'StartupUser',                      
			@Startuptype as 'StartupType',                      
			serverproperty('Productlevel') as 'ServicePack',                      
			serverproperty('edition') as 'Edition',                      
			serverproperty('productversion') as 'Version',                      
			serverproperty('collation') as 'Collation',                      
			serverproperty('Isclustered') as 'ISClustered',                      
			@out as 'ClusterNodes',                      
			serverproperty('IsFullTextInstalled') as 'ISFullText'                       
			From sys.dm_os_sys_info                         
                      

-- Step 6: Printing database details 
				
			SELECT                       
			serverproperty ('ComputerNamePhysicalNetBIOS') as 'Machine'                      
			,@instance_name1 as InstanceName,                      
			(SELECT 'file_type' =                      
		 		CASE                      
		 			WHEN s.groupid <> 0 THEN 'data'                      
		 			WHEN s.groupid = 0 THEN 'log'                      
		 		END) AS 'fileType'                      
		 	, d.dbid as 'DBID'                      
		 	, d.name AS 'DBName'                      
		 	, s.name AS 'LogicalFileName'                      
		 	, s.filename AS 'PhysicalFileName'                      
 		 	, (s.size * 8 / 1024) AS 'FileSizeMB' -- file size in MB                      
 		 	, d.cmptlevel as 'CompatibilityLevel'                      
 		 	, DATABASEPROPERTYEX (d.name,'Recovery') as 'RecoveryModel'                      
 		 	, DATABASEPROPERTYEX (d.name,'Status') as 'DatabaseStatus' ,                     
 		 	--, d.is_published as 'Publisher'                      
 		 	--, d.is_subscribed as 'Subscriber'                      
 		 	--, d.is_distributor as 'Distributor' 
 		 	(SELECT 'is_replication' =                      
			 CASE                      
			WHEN d.category = 1 THEN 'Published'                      
			WHEN d.category = 2 THEN 'subscribed'                      
			WHEN d.category = 4 THEN 'Merge published'
			WHEN d.category = 8 THEN 'merge subscribed'
			Else 'NO replication'
			END) AS 'Is_replication'                      
 		 	, m.mirroring_state as 'MirroringState'                      
			--INTO master.[dbo].[databasedetails]                      
			FROM                      
			sys.sysdatabases d INNER JOIN sys.sysaltfiles s                      
			ON                      
			d.dbid=s.dbid                      
			INNER JOIN sys.database_mirroring m                      
			ON                      
			d.dbid=m.database_id                      
			ORDER BY                      
			d.name                      
          
          
          


--Step 7 :printing Backup details                       

			Select distinct                             
			b.machine_name as 'ServerName',                        
			b.server_name as 'InstanceName',                        
			b.database_name as 'DatabaseName',                            
			d.database_id 'DBID',                            
			CASE b.[type]                                  
			WHEN 'D' THEN 'Full'                                  
			WHEN 'I' THEN 'Differential'                                  
			WHEN 'L' THEN 'Transaction Log'                                  
			END as 'BackupType'                                 
			--INTO [dbo].[backupdetails]                        
			from sys.databases d inner join msdb.dbo.backupset b                            
			On b.database_name =d.name                        


End
else

	begin



--Step 8: If the instance is 2000 this code will be used.

	declare @registry_key4 nvarchar(100)                        
	declare @Host_Name varchar(100)
	declare @CPU varchar(3)
	declare @nodes nvarchar(400)
	set @nodes =null /* We are not able to trap the node names for SQL Server 2000 so far*/
	declare @mirroring varchar(15)
	set @mirroring ='NOT APPLICABLE' /*Mirroring does not exist in SQL Server 2000*/
	Declare @reg_node1 varchar(100)
	Declare @reg_node2 varchar(100)
	Declare @reg_node3 varchar(100)
	Declare @reg_node4 varchar(100)
	  
	SET @reg_node1 = N'Cluster\Nodes\1'
	SET @reg_node2 = N'Cluster\Nodes\2'
	SET @reg_node3 = N'Cluster\Nodes\3'
	SET @reg_node4 = N'Cluster\Nodes\4'
	  
	Declare @image_path1 varchar(100)
	Declare @image_path2 varchar(100)
	Declare @image_path3 varchar(100)
	Declare @image_path4 varchar(100)
	
	set @image_path1=null
	set @image_path2=null
	set @image_path3=null
	set @image_path4=null
	
	
	Exec master.dbo.xp_regread 'HKEY_LOCAL_MACHINE',@reg_node1, @value_name='NodeName',@value=@image_path1 OUTPUT
	Exec master.dbo.xp_regread 'HKEY_LOCAL_MACHINE',@reg_node2, @value_name='NodeName',@value=@image_path2 OUTPUT
	Exec master.dbo.xp_regread 'HKEY_LOCAL_MACHINE',@reg_node3, @value_name='NodeName',@value=@image_path3 OUTPUT
	Exec master.dbo.xp_regread 'HKEY_LOCAL_MACHINE',@reg_node4, @value_name='NodeName',@value=@image_path4 OUTPUT
	
    IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'nodes') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)                        
	drop table nodes
	Create table nodes (name varchar (20))
		  insert into nodes values (@image_path1)
		  insert into nodes values (@image_path2)
		  insert into nodes values (@image_path3)
		  insert into nodes values (@image_path4)
		  --declare @Out nvarchar(400)                        
		  --declare @value nvarchar (20)
		  SELECT @Out = COALESCE(@Out+'/' ,'') + name from nodes where name is not null
	  	  
-- Step 9: Reading registry keys for Number of CPUs,Binaries,Startup type ,startup username, errorlogs location and domain.
	
	SET @instance_name = coalesce(convert(nvarchar(100), serverproperty('InstanceName')),'MSSQLSERVER');
	IF @instance_name!='MSSQLSERVER'

	BEGIN
		set @system_instance_name=@instance_name
		set @instance_name='MSSQL$'+@instance_name

		SET @key=N'SYSTEM\CurrentControlSet\Services\' +@instance_name;
		SET @registry_key = N'Software\Microsoft\Microsoft SQL Server\' + @system_instance_name + '\MSSQLServer\Parameters';
		SET @registry_key1 = N'Software\Microsoft\Microsoft SQL Server\' + @system_instance_name + '\Setup';
		SET @registry_key2 = N'SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\';
		SET @registry_key4 = N'SYSTEM\CurrentControlSet\Control\Session Manager\Environment'
	

		EXEC master.dbo.xp_regread 'HKEY_LOCAL_MACHINE',@registry_key1,@value_name='SQLPath',@value=@image_path OUTPUT
		EXEC master.dbo.xp_regread 'HKEY_LOCAL_MACHINE',@key,@value_name='Start',@value=@startup_type OUTPUT
		EXEC master.dbo.xp_regread 'HKEY_LOCAL_MACHINE',@key,@value_name='ObjectName',@value=@start_username OUTPUT
		EXEC master.dbo.xp_regread 'HKEY_LOCAL_MACHINE',@registry_key,@value_name='SQLArg1',@value=@log_directory OUTPUT
		EXEC master.dbo.xp_regread 'HKEY_LOCAL_MACHINE',@registry_key2,@value_name='Domain',@value=@domain OUTPUT
		EXEC master.dbo.xp_regread 'HKEY_LOCAL_MACHINE',@registry_key4,@value_name='NUMBER_OF_PROCESSORS',@value=@CPU OUTPUT                        
	

	END

	IF @instance_name='MSSQLSERVER'
		BEGIN
			SET @key=N'SYSTEM\CurrentControlSet\Services\' +@instance_name;
			SET @registry_key = N'Software\Microsoft\MSSQLSERVER\MSSQLServer\Parameters';
			SET @registry_key1 = N'Software\Microsoft\MSSQLSERVER\Setup';
			SET @registry_key2 = N'SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\';
			SET @registry_key4 = N'SYSTEM\CurrentControlSet\Control\Session Manager\Environment'	                                               

 

			EXEC master.dbo.xp_regread 'HKEY_LOCAL_MACHINE',@registry_key1,@value_name='SQLPath',@value=@image_path OUTPUT
			EXEC master.dbo.xp_regread 'HKEY_LOCAL_MACHINE',@key,@value_name='Start',@value=@startup_type OUTPUT
			EXEC master.dbo.xp_regread 'HKEY_LOCAL_MACHINE',@key,@value_name='ObjectName',@value=@start_username OUTPUT
			EXEC master.dbo.xp_regread 'HKEY_LOCAL_MACHINE',@registry_key,@value_name='SQLArg1',@value=@log_directory OUTPUT
			--EXEC master.dbo.xp_regread 'HKEY_LOCAL_MACHINE',@registry_key1,@value_name='IpAddress',@value=@IpAddress OUTPUT
			EXEC master.dbo.xp_regread 'HKEY_LOCAL_MACHINE',@registry_key2,@value_name='Domain',@value=@domain OUTPUT
			EXEC master.dbo.xp_regread 'HKEY_LOCAL_MACHINE',@registry_key4,@value_name='NUMBER_OF_PROCESSORS',@value=@CPU OUTPUT                        	

		END
			set @startuptype= (select 'Start Up Mode' =
					CASE
					WHEN @startup_type=2 then 'AUTOMATIC'
					WHEN @startup_type=3 then 'MANUAL'
					WHEN @startup_type=4 then 'Disabled'
					END)

--Step 10 : Using ipconfig and xp_msver to get physical memory and IP

			IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'tmp') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)                      
			DROP TABLE tmp
			create table tmp (server varchar(100)default cast( serverproperty ('Machinename') as varchar),[index] int, name sysname,internal_value int,character_value varchar(30))
			insert into tmp([index],name,internal_value,character_value) exec xp_msver PhysicalMemory
	
			IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'ipadd') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)                      
			drop table ipadd
			create table ipadd (server varchar(100)default cast( serverproperty ('Machinename') as varchar),IP varchar (100))
			insert into ipadd (IP)exec xp_cmdshell 'ipconfig'
			delete from ipadd where ip not like '%IP Address.%' or IP is null


-- Step 11 : Getting the Server details 

			SELECT  top 1              
			@domain as 'Domain',                      
			serverproperty('Machinename') as 'MachineName',                      
			@CPU as 'CPUCount',
			cast (t.internal_value as bigint) as PhysicalMemoryMB,
			cast(substring ( I.IP , 44,41) as nvarchar(20))as IP_Address,
			serverproperty('Instancename') as 'InstanceName',                      
			@image_path as 'BinariesPath',                      
			@log_directory as 'ErrorLogsLocation',                      
			@start_username as 'StartupUser',                      
			@Startuptype as 'StartupType',                      
			serverproperty('Productlevel') as 'ServicePack',                      
			serverproperty('edition') as 'Edition',                      
			serverproperty('productversion') as 'Version',                      
			serverproperty('collation') as 'Collation',                      
			serverproperty('Isclustered') as 'ISClustered',                      
			@Out as 'ClustreNodes',
			serverproperty('IsFullTextInstalled') as 'ISFullText'                       
			From tmp t inner join IPAdd I
			on t.server = I.server

-- Step 12 : Getting the instance details 

			SELECT                       
			serverproperty ('Machinename') as 'Machine',                      
			serverproperty ('Instancename') as 'InstanceName',                      
			(SELECT 'file_type' =                      
				 CASE                      
				 WHEN s.groupid <> 0 THEN 'data'                      
				 WHEN s.groupid = 0 THEN 'log'                      
			 END) AS 'fileType'                      
			 , d.dbid as 'DBID'                      
			 , d.name AS 'DBName'                      
			 , s.name AS 'LogicalFileName'                      
			 , s.filename AS 'PhysicalFileName'                      
			 , (s.size * 8 / 1024) AS 'FileSizeMB' -- file size in MB                      
			 ,d.cmptlevel as 'CompatibilityLevel'                      
			 , DATABASEPROPERTYEX (d.name,'Recovery') as 'RecoveryModel'                      
			 , DATABASEPROPERTYEX (d.name,'Status') as 'DatabaseStatus' ,                     
			 (SELECT 'is_replication' =                      
			 CASE                      
			 WHEN d.category = 1 THEN 'Published'                      
			 WHEN d.category = 2 THEN 'subscribed'                      
			 WHEN d.category = 4 THEN 'Merge published'
			 WHEN d.category = 8 THEN 'merge subscribed'
			 Else 'NO replication'
			  END) AS 'Is_replication',
			  @Mirroring as 'MirroringState'
			 FROM                      
			sysdatabases d INNER JOIN sysaltfiles s                      
			ON                      
			d.dbid=s.dbid                      
			ORDER BY                      
			d.name                      

-- Step 13 : Getting backup details 

			Select distinct                             
			b.machine_name as 'ServerName',                        
			b.server_name as 'InstanceName',                        
			b.database_name as 'DatabaseName',                            
			d.dbid 'DBID',                            
			CASE b.[type]                                  
			WHEN 'D' THEN 'Full'                                  
			WHEN 'I' THEN 'Differential'                                  
			WHEN 'L' THEN 'Transaction Log'                                  
			END as 'BackupType'                                 
			from sysdatabases d inner join msdb.dbo.backupset b                            
			On b.database_name =d.name   


-- Step 14: Dropping the table we created for IP and Physical memory

			Drop Table TMP
			Drop Table IPADD
			drop table Nodes
		
			end
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_BkpMissing]    Script Date: 02/11/2012 12:31:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_dba_BkpMissing]
as
set nocount on

select s.name as Banco,b.backup_finish_date as UltimoBackup,
case b.[type]
when 'D' then 'Database'
when 'I' then 'Database Differential'
when 'L' then 'Log'
when 'F' then 'File or Filegroup'
end as TipoBackup -- b.*
from
sysdatabases s left outer join  msdb.dbo.backupset b  on s.name = b.database_name  left outer join
(select database_name, max(backup_finish_date) backup_finish_date
from msdb.dbo.backupset group by database_name) u
on b.database_name = u.database_name and b.backup_finish_date = u.backup_finish_date
where b.backup_finish_date < (getdate() - 2) or b.backup_finish_date is null order by b.database_name
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_bkp]    Script Date: 02/11/2012 12:31:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_dba_bkp]   
@discos char(1) = null  
as    
set nocount on    
--sp_helpdb dbawork    
  
if @discos is null  
select @discos = 'S'  
  
select 'Espaco livre e uso do log  
'  
if @discos = 'S'  
exec master..xp_fixeddrives  
DBCC SQLPERF (logspace)  
select '  
Databases FULL sem bkp log'    
SELECT substring (D.name,1,30) AS database_name,substring( D.recovery_model_desc ,1,15) as Model    
FROM sys.databases D LEFT JOIN      
   (     
   SELECT BS.database_name,      
       MAX(BS.backup_finish_date) AS last_log_backup_date     
   FROM msdb.dbo.backupset BS      
   WHERE BS.type = 'L'     
   GROUP BY BS.database_name     
   ) BS1 ON D.name = BS1.database_name     
WHERE D.recovery_model_desc <> 'SIMPLE'     
   AND BS1.last_log_backup_date IS NULL     
ORDER BY D.name    
    
/*    
SELECT     
substring (D.name,1,30) AS database_name,substring( D.recovery_model_desc ,1,15) as Model    
FROM     
sys.databases D LEFT JOIN      
(     
   SELECT BS.database_name,      
   MAX(BS.backup_finish_date) AS last_log_backup_date      
   FROM msdb.dbo.backupset BS      
   WHERE BS.type = 'L'      
   GROUP BY BS.database_name      
   ) BS1      
ON D.name = BS1.database_name     
LEFT JOIN      
(     
   SELECT BS.database_name,      
   MAX(BS.backup_finish_date) AS last_data_backup_date      
   FROM msdb.dbo.backupset BS      
   WHERE BS.type = 'D'      
   GROUP BY BS.database_name      
) BS2      
ON D.name = BS2.database_name     
WHERE     
D.recovery_model_desc <> 'SIMPLE'     
AND BS1.last_log_backup_date IS NULL OR BS1.last_log_backup_date < BS2.last_data_backup_date    
ORDER BY D.name    
*/    
select '    
Ultimos bkps    
'    
    
SELECT substring (D.name,1,25) AS database_name,substring( D.recovery_model_desc ,1,15) as DbLogModel ,    
convert(char(10),convert(numeric(8,2),backup_size/1024/1024)) as MB,    
case type    
when 'D' then 'Database'     
when 'I' then 'Database Differential'     
when 'L' then 'Log'     
when 'F' then 'File or Filegroup'     
when 'G' then 'File Differential'     
when 'P' then 'Partial'     
when 'Q' then 'Partial Differentil'    
end as Type,convert(char(19),[last_log_backup_date])  as 'Last Bkp'    
FROM sys.databases D LEFT JOIN      
   (     
   SELECT BS.[database_name],  bs.type, max(bs.backup_size) as backup_size,    
       MAX(BS.[backup_finish_date]) AS [last_log_backup_date]     
   FROM msdb.dbo.backupset BS      
   GROUP BY BS.[database_name] , bs.type    
   ) BS1 ON D.[name] = BS1.[database_name]    
ORDER BY 1,2,3
GO
