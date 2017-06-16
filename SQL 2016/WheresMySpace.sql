/*Listing 1: Creating the FileInfo table*/
USE [BaselineData];
GO
IF EXISTS ( SELECT  1
            FROM    [sys].[tables]
            WHERE   [name] = N'FileInfo' ) 
    DROP TABLE [dbo].[FileInfo]

CREATE TABLE [dbo].[FileInfo]
    (
      [DatabaseName] SYSNAME NOT NULL ,
      [FileID] INT NOT NULL ,
      [Type] TINYINT NOT NULL ,
      [DriveLetter] NVARCHAR(1) NULL ,
      [LogicalFileName] SYSNAME NOT NULL ,
      [PhysicalFileName] NVARCHAR(260) NOT NULL ,
      [SizeMB] DECIMAL(38, 2) NULL ,
      [SpaceUsedMB] DECIMAL(38, 2) NULL ,
      [FreeSpaceMB] DECIMAL(38, 2) NULL ,
      [MaxSize] DECIMAL(38, 2) NULL ,
      [IsPercentGrowth] BIT NULL ,
      [Growth] DECIMAL(38, 2) NULL ,
      [CaptureDate] DATETIME NOT NULL
    )
ON  [PRIMARY];
GO


/*Listing 2: Capturing file statistics for all database on an instance*/
USE [BaselineData];
GO
SET NOCOUNT ON;

DECLARE @sqlstring NVARCHAR(MAX);
DECLARE @DBName NVARCHAR(257);

DECLARE DBCursor CURSOR LOCAL FORWARD_ONLY STATIC READ_ONLY
FOR
    SELECT  QUOTENAME([name])
    FROM    [sys].[databases]
    WHERE   [state] = 0
    ORDER BY [name];

BEGIN
    OPEN DBCursor;
    FETCH NEXT FROM DBCursor INTO @DBName;
    WHILE @@FETCH_STATUS <> -1 
        BEGIN
            SET @sqlstring = N'USE ' + @DBName + '
      ; INSERT [BaselineData2012].[dbo].[FileInfo] (
      [DatabaseName],
      [FileID],
      [Type],
      [DriveLetter],
      [LogicalFileName],
      [PhysicalFileName],
      [SizeMB],
      [SpaceUsedMB],
      [FreeSpaceMB],
      [MaxSize],
      [IsPercentGrowth],
      [Growth],
      [CaptureDate]
      )
      SELECT ''' + @DBName
                + ''' 
      ,[file_id],
       [type],
      substring([physical_name],1,1),
      [name],
      [physical_name],
      CAST([size] as DECIMAL(38,0))/128., 
      CAST(FILEPROPERTY([name],''SpaceUsed'') AS DECIMAL(38,0))/128., 
      (CAST([size] as DECIMAL(38,0))/128) - (CAST(FILEPROPERTY([name],''SpaceUsed'') AS DECIMAL(38,0))/128.),
      [max_size],
      [is_percent_growth],
      [growth],
      GETDATE()
      FROM ' + @DBName + '.[sys].[database_files];'
            EXEC (@sqlstring)
            FETCH NEXT FROM DBCursor INTO @DBName;
        END

    CLOSE DBCursor;
    DEALLOCATE DBCursor;
END


/*Listing 3: Which database files on an instance have the least free space?*/
USE [BaselineData];
GO

SELECT  [DatabaseName] ,
        [FileID] ,
        [DriveLetter] ,
        [LogicalFileName] ,
        [PhysicalFileName] ,
        [SizeMB] ,
        [SpaceUsedMB] ,
        [FreeSpaceMB] ,
        CAST([FreeSpaceMB] / [SizeMB] * 100 AS DECIMAL(38, 2))
                                                     AS 'PercentFree' ,
        CASE WHEN [MaxSize] = 0
             THEN 'Max size = ' + CAST([SizeMB] / 128.00 AS VARCHAR(15))
                  + ' MB'
             WHEN [MaxSize] = -1 THEN 'No max size set'
             WHEN [MaxSize] = 268435456 THEN 'Max size = 2 TB'
             ELSE 'Max size = '
                  + CAST(CAST([MaxSize] / 128.00 AS DECIMAL(38, 2))
                                                     AS VARCHAR(15))
                  + ' MB'
        END AS "MaximumSize" ,
        CASE WHEN [Growth] = 0 THEN 'No growth'
             WHEN [Growth] > 0
                  AND [IsPercentGrowth] = 1
             THEN CAST([Growth] AS VARCHAR(15)) + '%'
             WHEN [Growth] > 0
                  AND [IsPercentGrowth] = 0
             THEN CAST(CAST([Growth] / 128.00 AS DECIMAL(38, 2))
                                                     AS VARCHAR(15))
                  + ' MB'
        END AS 'AutoGrowth' ,
        [CaptureDate]
FROM    [dbo].[FileInfo]
WHERE   CONVERT(VARCHAR(10), [CaptureDate], 112) = 
                               CONVERT(VARCHAR(10), GETDATE(), 112)
ORDER BY [PercentFree] ASC
-- WHERE [DatabaseName] = N'[AdventureWorks]'
-- ORDER BY [FileID], [CaptureDate];

/*Listing 4: Tracking total database size*/
SELECT  [DatabaseName] ,
        SUM([SizeMB]) AS 'DatabaseSizeMB' ,
        SUM([SpaceUsedMB]) AS 'SpaceUsedMB' ,
        SUM([FreeSpaceMB]) AS 'FreeSpaceMB' ,
        CAST(SUM([FreeSpaceMB]) / SUM([SizeMB]) * 100 AS DECIMAL(38, 2))
                                                       AS 'PercentFree' ,
        [CaptureDate]
FROM    [dbo].[FileInfo]
WHERE   [DatabaseName] = N'[AdventureWorks]'
GROUP BY [DatabaseName] ,
        [CaptureDate]
ORDER BY [CaptureDate] DESC;

/*Listing 5: Tracking total database size, excluding log files*/
SELECT  [DatabaseName] ,
        SUM([SizeMB]) AS 'DatabaseSizeMB' ,
        SUM([SpaceUsedMB]) AS 'SpaceUsedMB' ,
        SUM([FreeSpaceMB]) AS 'FreeSpaceMB' ,
        CAST(SUM([FreeSpaceMB]) / SUM([SizeMB]) * 100 AS DECIMAL(38, 2))
                                                       AS 'PercentFree' ,
        [CaptureDate]
FROM    [dbo].[FileInfo]
WHERE   [DatabaseName] = N'[AdventureWorks]'
        AND [Type] <> 1
GROUP BY [DatabaseName] ,
        [CaptureDate]
ORDER BY [CaptureDate] DESC;

/*Listing 6: Total size of all database files per drive*/
SELECT  [DriveLetter] ,
        SUM([SizeMB])
FROM    [dbo].[FileInfo]
WHERE   CONVERT(VARCHAR(10), [CaptureDate], 112) = CONVERT(VARCHAR(10), GETDATE(), 112)
GROUP BY [DriveLetter];

/*Listing 7: Using sys.dm_os_volume_stats can to capture free space per drive*/
SELECT DISTINCT
        ( [vs].[logical_volume_name] ) AS 'Drive' ,
        [vs].[available_bytes] / 1048576 AS 'MBFree'
FROM    [sys].[master_files] AS f
        CROSS APPLY [sys].[dm_os_volume_stats]([f].[database_id],
                                               [f].[file_id]) AS vs
ORDER BY [vs].[logical_volume_name];
