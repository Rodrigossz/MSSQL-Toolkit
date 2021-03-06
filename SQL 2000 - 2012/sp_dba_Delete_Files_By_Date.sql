use master
go

create PROCEDURE sp_dba_Delete_Files_By_Date (@SourceDir varchar(1024), @SourceFile varchar(512), @DaysToKeep int)
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