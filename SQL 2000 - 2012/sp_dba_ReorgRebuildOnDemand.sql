use master
go
CREATE TABLE [dbo].[dba_IndexWorkToDo](
   [DBID] [smallint] NULL,
    [Data] [datetime] NOT NULL,
    [objectid] [int] NULL,
    objectName sysname null,
    [indexid] [int] NULL,
    [partitionnum] [int] NULL,
    [frag] [float] NULL
) ON [PRIMARY]
go


create proc sp_dba_ReorgRebuildOnDemand
as
begin

-- INICIO DO PROCESSO
SET NOCOUNT ON

SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER OFF


-- Declara Variáveis.
DECLARE @objectid int;
DECLARE @indexid int;
DECLARE @partitioncount bigint;
DECLARE @schemaname nvarchar(130); 
DECLARE @objectname nvarchar(130); 
DECLARE @indexname nvarchar(130); 
DECLARE @partitionnum bigint;
DECLARE @partitions bigint;
DECLARE @frag float;
DECLARE @command nvarchar(4000);
DECLARE @cmdupdt nvarchar(4000);
DECLARE @db_id SMALLINT;
SET @db_id = DB_ID()


-- Identifica Tabelas que farão parte do processo.
SELECT    object_id AS objectid,
            index_id AS indexid,
            partition_number AS partitionnum,
            avg_fragmentation_in_percent AS frag
       INTO #work_to_do
FROM    sys.dm_db_index_physical_stats (@db_id, NULL, NULL , NULL, 'LIMITED')
WHERE  avg_fragmentation_in_percent > 15.0 AND index_id > 0;



-- Declara o cursor.
DECLARE partitions CURSOR FOR SELECT * FROM #work_to_do;

-- Abre o cursor.
OPEN partitions;

-- Loop.
WHILE (1=1)

  BEGIN;
    BEGIN TRY
    FETCH NEXT
       FROM partitions
       INTO @objectid, @indexid, @partitionnum, @frag;
    IF @@FETCH_STATUS < 0 BREAK;
    SELECT @objectname = QUOTENAME(o.name), @schemaname = QUOTENAME(s.name)
    FROM sys.objects AS o
    JOIN sys.schemas as s ON s.schema_id = o.schema_id
    WHERE o.object_id = @objectid;
    SELECT @indexname = QUOTENAME(name)
    FROM sys.indexes
    WHERE object_id = @objectid AND index_id = @indexid;
    SELECT @partitioncount = count (*)
    FROM sys.partitions
    WHERE object_id = @objectid AND index_id = @indexid;

-- 15% é um ponto de decisão em que decidimos entre reorganizing e rebuilding.
    IF @frag < 15.0
        SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @objectname + N' REORGANIZE';
         SET @cmdupdt = N'UPDATE STATISTICS ['+ @schemaname + N'.' + @objectname
    IF @frag >= 15.0
        SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @objectname + N' REBUILD WITH (ONLINE=ON)';
         SET @cmdupdt = N'UPDATE STATISTICS '+ @schemaname + N'.' + @objectname
    IF @partitioncount > 1
         SET @command = @command + N' PARTITION=' + CAST(@partitionnum AS nvarchar(10));
    EXEC (@command);
    PRINT (@command);
       EXEC (@cmdupdt);
    PRINT (@cmdupdt);
        END TRY
       BEGIN CATCH
        SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;
        SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @objectname + N' REORGANIZE';
        IF @partitioncount > 1
         SET @command = @command + N' PARTITION=' + CAST(@partitionnum AS nvarchar(10));
          SET @cmdupdt = N'UPDATE STATISTICS '+ @schemaname + N'.' + @objectname
    EXEC (@command)
    PRINT (@command)
        EXEC (@cmdupdt);
    PRINT (@cmdupdt);
        END CATCH
 END

-- Fecha cursor.
CLOSE partitions;
DEALLOCATE partitions;

---- Guarda Histórico de Objetos Fragmentados
--if (select count(*) from sys.objects where name = 'work_to_do')=0
--begin
--CREATE TABLE [dbo].[work_to_do](
--   [DBID] [smallint] NULL,
--    [Data] [datetime] NOT NULL,
--    [objectid] [int] NULL,
--    [indexid] [int] NULL,
--    [partitionnum] [int] NULL,
--    [frag] [float] NULL
--) ON [PRIMARY]
--end

insert into master..dba_IndexWorkToDo
select    db_id(),
        getdate(),
        objectid,
        OBJECT_NAME(objectid),
        indexid,
        partitionnum,
        frag
from    #work_to_do

DROP TABLE #work_to_do
end--proc
GO

EXEC sp_ms_marksystemobject 'sp_dba_ReorgRebuildOnDemand'  
    

exec sp_dba_ReorgRebuildOnDemand
select * from master..dba_IndexWorkToDo





