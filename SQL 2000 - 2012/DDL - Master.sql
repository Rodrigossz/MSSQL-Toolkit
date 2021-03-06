USE [master]
GO
/****** Object:  User [PSAFE\Servico_SQL]    Script Date: 04/27/2011 12:01:43 ******/
CREATE USER [PSAFE\Servico_SQL] FOR LOGIN [PSAFE\Servico_SQL] WITH DEFAULT_SCHEMA=[PSAFE\Servico_SQL]
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_job2]    Script Date: 04/27/2011 12:01:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_dba_job2]
as
exec msdb..sp_dba_job2
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_job]    Script Date: 04/27/2011 12:01:41 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_dba_ix]    Script Date: 04/27/2011 12:01:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_dba_ix] @date datetime = null  
as  
set nocount on 
if @date is null  
select @date = dateadd(mm,-2,getdate())  
select 'Indexes that have been used and how they are being used'  
SELECT DB_NAME(DATABASE_ID) AS DATABASENAME,   
       OBJECT_NAME(B.OBJECT_ID) AS TABLENAME,   
       INDEX_NAME = (SELECT NAME   
                     FROM   SYS.INDEXES A   
                     WHERE  A.OBJECT_ID = B.OBJECT_ID   
                            AND A.INDEX_ID = B.INDEX_ID),   
       USER_SEEKS,   
       USER_SCANS,   
       USER_LOOKUPS,   
       USER_UPDATES   
FROM   SYS.DM_DB_INDEX_USAGE_STATS B   
       INNER JOIN SYS.OBJECTS C   
         ON B.OBJECT_ID = C.OBJECT_ID   
WHERE  DATABASE_ID = DB_ID(DB_NAME())   
       AND C.TYPE <> 'S'  
  
  
select 'Indexes that have not been used'  
SELECT   DB_NAME() AS DATABASENAME,   
         OBJECT_NAME(B.OBJECT_ID) AS TABLENAME,   
         B.NAME AS INDEXNAME,   
         B.INDEX_ID   
FROM     SYS.OBJECTS A   
         INNER JOIN SYS.INDEXES B   
           ON A.OBJECT_ID = B.OBJECT_ID   
WHERE    NOT EXISTS (SELECT *   
                     FROM   SYS.DM_DB_INDEX_USAGE_STATS C   
                     WHERE  B.OBJECT_ID = C.OBJECT_ID  and  
(last_user_seek >= @date or  
last_user_scan >= @date or  
last_user_lookup >= @date )  
--last_user_update >= '20091201' )  
                            AND B.INDEX_ID = C.INDEX_ID)   
         AND A.TYPE <> 'S'   
ORDER BY 1, 2, 3  
  
select 'Tables, indexes and columns'  
SELECT   TABLENAME, INDEXNAME, INDEXID, [1] AS COL1, [2] AS COL2, [3] AS COL3,   
         [4] AS COL4,  [5] AS COL5, [6] AS COL6, [7] AS COL7   
FROM     (SELECT A.NAME AS TABLENAME,   
                 B.NAME AS INDEXNAME,   
                 B.INDEX_ID AS INDEXID,   
                 D.NAME AS COLUMNNAME,   
                 C.KEY_ORDINAL   
          FROM   SYS.OBJECTS A   
                 INNER JOIN SYS.INDEXES B   
                   ON A.OBJECT_ID = B.OBJECT_ID   
                 INNER JOIN SYS.INDEX_COLUMNS C   
                   ON B.OBJECT_ID = C.OBJECT_ID   
                      AND B.INDEX_ID = C.INDEX_ID   
                 INNER JOIN SYS.COLUMNS D   
                   ON C.OBJECT_ID = D.OBJECT_ID   
                      AND C.COLUMN_ID = D.COLUMN_ID   
          WHERE  A.TYPE <> 'S') P   
         PIVOT   
         (MIN(COLUMNNAME)   
          FOR KEY_ORDINAL IN ( [1],[2],[3],[4],[5],[6],[7] ) ) AS PVT   
ORDER BY TABLENAME, INDEXNAME  
/*  
SELECT   A.NAME,          B.NAME,   
         C.KEY_ORDINAL,          D.NAME   
FROM     SYS.OBJECTS A          INNER JOIN SYS.INDEXES B   
           ON A.OBJECT_ID = B.OBJECT_ID   
         INNER JOIN SYS.INDEX_COLUMNS C   
           ON B.OBJECT_ID = C.OBJECT_ID   
              AND B.INDEX_ID = C.INDEX_ID   
         INNER JOIN SYS.COLUMNS D   
           ON C.OBJECT_ID = D.OBJECT_ID   
              AND C.COLUMN_ID = D.COLUMN_ID   
WHERE    A.TYPE <> 'S'   
ORDER BY 1, 2, 3  
  
*/  
select 'indexes that have been used since the last time the stats were reset'

SELECT   TABLENAME, INDEXNAME, INDEX_ID, [1] AS COL1, [2] AS COL2, [3] AS COL3, 
         [4] AS COL4, [5] AS COL5, [6] AS COL6, [7] AS COL7 
FROM     (SELECT A.NAME AS TABLENAME, 
                 A.OBJECT_ID, 
                 B.NAME AS INDEXNAME, 
                 B.INDEX_ID, 
                 D.NAME AS COLUMNNAME, 
                 C.KEY_ORDINAL 
          FROM   SYS.OBJECTS A 
                 INNER JOIN SYS.INDEXES B 
                   ON A.OBJECT_ID = B.OBJECT_ID 
                 INNER JOIN SYS.INDEX_COLUMNS C 
                   ON B.OBJECT_ID = C.OBJECT_ID 
                      AND B.INDEX_ID = C.INDEX_ID 
                 INNER JOIN SYS.COLUMNS D 
                   ON C.OBJECT_ID = D.OBJECT_ID 
                      AND C.COLUMN_ID = D.COLUMN_ID 
          WHERE  A.TYPE <> 'S') P 
         PIVOT 
         (MIN(COLUMNNAME) 
          FOR KEY_ORDINAL IN ( [1],[2],[3],[4],[5],[6],[7] ) ) AS PVT 
WHERE    EXISTS (SELECT OBJECT_ID, 
                        INDEX_ID 
                 FROM   SYS.DM_DB_INDEX_USAGE_STATS B 
                 WHERE  DATABASE_ID = DB_ID(DB_NAME()) 
                        AND PVT.OBJECT_ID = B.OBJECT_ID 
                        AND PVT.INDEX_ID = B.INDEX_ID) 
ORDER BY TABLENAME, INDEXNAME
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_io]    Script Date: 04/27/2011 12:01:40 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_dba_indexCache]    Script Date: 04/27/2011 12:01:40 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_dba_helpindex]    Script Date: 04/27/2011 12:01:40 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_dba_helpdb]    Script Date: 04/27/2011 12:01:40 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_dba_help]    Script Date: 04/27/2011 12:01:40 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_dba_fragmentation]    Script Date: 04/27/2011 12:01:40 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_dba_estspace]    Script Date: 04/27/2011 12:01:40 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_dba_ErrorLogFull]    Script Date: 04/27/2011 12:01:40 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_dba_dbUSe]    Script Date: 04/27/2011 12:01:40 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_dba_DataCompress]    Script Date: 04/27/2011 12:01:40 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_dba_cachePlan]    Script Date: 04/27/2011 12:01:40 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_dba_cachedPlan]    Script Date: 04/27/2011 12:01:40 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_dba_cached_plans]    Script Date: 04/27/2011 12:01:40 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_dba_SearchCachedPlans]    Script Date: 04/27/2011 12:01:42 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_dba_role]    Script Date: 04/27/2011 12:01:42 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_dba_procHist]    Script Date: 04/27/2011 12:01:42 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_dba_proc5]    Script Date: 04/27/2011 12:01:42 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_dba_proc4]    Script Date: 04/27/2011 12:01:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_dba_proc4] as
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

ORDER BY dbname,AVG_CPU DESC
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_proc3]    Script Date: 04/27/2011 12:01:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_dba_proc3]
as
set nocount on
--SELECT spid,db_name(dbid),loginame,cmd,open_tran,blocked = case when blocked = spid then 0 else blocked end,status,io=sum(physical_io),mem_kb=sum(memusage),
--cpu_cycs=sum(cpu), (SELECT [text] FROM fn_get_sql(sql_handle))
--FROM master..sysprocesses p1
--WHERE ((spid > 50 and status <> 'sleeping') or (blocked <> 0) or 
--exists (select 1 from master..sysprocesses p2 where p1.spid = p2.blocked)) --and spid <> @@SPID
-- group by spid,dbid,loginame,cmd,open_tran,blocked,status,sql_handle
--Returns the all user process running on SQL Server   
--along with query being executed by each process  
SELECT  spid=session_id,command,loginame,hostname,open_tran,--kpid,
cpu_time,duration_secs=total_elapsed_time/1000,r.status,blk=blocking_session_id,logical_reads,reads,writes,
DB_NAME(database_id) AS [Database], r.wait_time ,[text] AS [LAST_Query]  
FROM sys.dm_exec_requests r  
CROSS APPLY sys.dm_exec_sql_text(r.plan_handle) st  
left join master..sysprocesses p on r.session_id = p.spid and kpid = (select max(kpid) from master..sysprocesses p2 
where p2.spid = p.spid )
WHERE session_Id > 50           -- Consider spids for users only, no system spids. 
union 
SELECT  spid,cmd,loginame,hostname,open_tran,--kpid,
cpu,duration_secs=DATEDIFF(ss,last_batch,getdate()),status,blk=blocked,physical_io,physical_io,physical_io,
DB_NAME(dbid) AS [Database], waittime ,null AS [LAST_Query]  
FROM master..sysprocesses p
where  p.blocked <> 0 and
p.kpid = (select max(kpid) from master..sysprocesses p2 where p2.spid = p.spid ) and
exists (select 1  from master..sysprocesses p3 where p3.blocked = p.spid )
order by 1
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_proc2]    Script Date: 04/27/2011 12:01:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_dba_proc2] as
set nocount on
SELECT T.[text], P.[query_plan], S.[program_name], S.[host_name],
S.[client_interface_name], S.[login_name], R.*
FROM sys.dm_exec_requests R
INNER JOIN sys.dm_exec_sessions S 
ON S.session_id = R.session_id
CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS T
CROSS APPLY sys.dm_exec_query_plan(plan_handle) As P
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_Proc]    Script Date: 04/27/2011 12:01:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_dba_Proc]           
@parm char(1) = 'S'          
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
            
  update @sysprocesses set hostname = 'FEP03' where hostname like '%B0%11%'    
  update @sysprocesses set hostname = 'FEP02' where hostname like '%18%92%'    
  update @sysprocesses set hostname = 'FEP01' where hostname like '%0F%A1%'    
      
         
       
            
    if @parm = 'S' --faz o dbcc          
BEGIN            
            
  -- select * from @sysprocesses            
            
            
            
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
END --IF inicial          
ELSE          
begin          
  select            
    SPID = spid,                 
    LOGIN = substring(loginame,1,20),                  
    CPU = convert(char(7),cpu),                 
    IO = convert(char(7),physical_io),            
    MEM = convert(char(4),memusage),                 
    STATUS = substring(b.status,1,20),                 
    COMANDO = substring(cmd,1,20),                 
    blocked     , 
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
substring(b.program_name,1,30),convert(char(2),b.open_tran),Buffer  , lastwaittype             
  union                 
  select            
    SPID = spid,                 
    LOGIN = 'Backup',                  
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
    TRANS = convert(char(2),b.open_tran),Buffer ,            
Qtd_Obj = count (distinct rsc_objid)            
from  @sysprocesses b left join @syslockinfo l on b.spid = l.req_spid            
  where cmd in ('DUMP DATABASE', 'LOAD DATABASE')            
    and spid <> @@spid         
group by spid, substring(loginame,1,20),convert(char(7),cpu), convert(char(7),physical_io),convert(char(4),memusage),                 
substring(b.status,1,20), substring(cmd,1,20),blocked,  substring(db_name(dbid),1,30),substring(b.hostname,1,40),                 
substring(b.program_name,1,30),convert(char(2),b.open_tran),Buffer , lastwaittype              
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
    TRANS = convert(char(2),b.open_tran) ,Buffer,            
Qtd_Obj = count (distinct rsc_objid)            
from  @sysprocesses b left join @syslockinfo l on b.spid = l.req_spid            
  where exists (select 1 from @sysprocesses c where b.spid = c.blocked )            
    and spid <> @@spid            
group by spid, substring(loginame,1,20),convert(char(7),cpu), convert(char(7),physical_io),convert(char(4),memusage),                 
substring(b.status,1,20), substring(cmd,1,20),blocked,  substring(db_name(dbid),1,30),substring(b.hostname,1,40),                 
substring(b.program_name,1,30),convert(char(2),b.open_tran),Buffer   , lastwaittype            
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
    TRANS = convert(char(2),b.open_tran) ,Buffer   ,            
Qtd_Obj = count (distinct rsc_objid)            
from  @sysprocesses b left join @syslockinfo l on b.spid = l.req_spid            
  where (open_tran > 0 or blocked > 0)            
    and spid <> @@spid            
group by spid, substring(loginame,1,20),convert(char(7),cpu), convert(char(7),physical_io),convert(char(4),memusage),                 
substring(b.status,1,20), substring(cmd,1,20),blocked,  substring(db_name(dbid),1,30),substring(b.hostname,1,40),                 
substring(b.program_name,1,30),convert(char(2),b.open_tran),Buffer   , lastwaittype            

order by 1            
          
end -- else
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_pr]    Script Date: 04/27/2011 12:01:42 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_dba_OverlapRole]    Script Date: 04/27/2011 12:01:41 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_dba_osbufferdescriptors_agg]    Script Date: 04/27/2011 12:01:41 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_dba_OrphanUser]    Script Date: 04/27/2011 12:01:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_dba_OrphanUser]
as
ALTER USER [PSAFE\IIS_PROD] WITH LOGIN = [PSAFE\IIS_PROD]
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_network]    Script Date: 04/27/2011 12:01:41 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_dba_monitorLS]    Script Date: 04/27/2011 12:01:41 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_dba_monitorEncrypt]    Script Date: 04/27/2011 12:01:41 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_dba_autokill]    Script Date: 04/27/2011 12:01:39 ******/
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
/****** Object:  Table [dbo].[dbaWaitTypes]    Script Date: 04/27/2011 12:00:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
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
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_lock2]    Script Date: 04/27/2011 12:01:41 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_dba_lock]    Script Date: 04/27/2011 12:01:41 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_dba_kill]    Script Date: 04/27/2011 12:01:41 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_dba_vw]    Script Date: 04/27/2011 12:01:42 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_dba_version]    Script Date: 04/27/2011 12:01:42 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_dba_tbUse]    Script Date: 04/27/2011 12:01:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_dba_tbUse] as
set nocount on
SELECT 
isnull(DB_NAME(ios.database_id),DB_NAME(ius.database_id)) AS DBName,
isnull(OBJECT_NAME(ios.object_id),OBJECT_NAME(ius.object_id)) AS TableName,
max(ips.record_count) as Rows,
convert(dec(8,2),SUM (ips.avg_record_size_in_bytes/1024)* max(ips.record_count)) as Size_MB,
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
/****** Object:  StoredProcedure [dbo].[sp_dba_tb]    Script Date: 04/27/2011 12:01:42 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_dba_string]    Script Date: 04/27/2011 12:01:42 ******/
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
/****** Object:  View [dbo].[Waits2]    Script Date: 04/27/2011 12:00:54 ******/
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
/****** Object:  View [dbo].[Waits]    Script Date: 04/27/2011 12:00:53 ******/
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
/****** Object:  UserDefinedDataType [dbo].[tdSmallDesc]    Script Date: 04/27/2011 12:01:43 ******/
CREATE TYPE [dbo].[tdSmallDesc] FROM [varchar](100) NULL
GO
/****** Object:  UserDefinedDataType [dbo].[tdSecret]    Script Date: 04/27/2011 12:01:43 ******/
CREATE TYPE [dbo].[tdSecret] FROM [varchar](100) NULL
GO
/****** Object:  UserDefinedDataType [dbo].[tdObs]    Script Date: 04/27/2011 12:01:43 ******/
CREATE TYPE [dbo].[tdObs] FROM [varchar](8000) NOT NULL
GO
/****** Object:  UserDefinedDataType [dbo].[tdHwGuId]    Script Date: 04/27/2011 12:01:43 ******/
CREATE TYPE [dbo].[tdHwGuId] FROM [varchar](36) NULL
GO
/****** Object:  UserDefinedDataType [dbo].[tdEmail]    Script Date: 04/27/2011 12:01:43 ******/
CREATE TYPE [dbo].[tdEmail] FROM [varchar](100) NULL
GO
/****** Object:  UserDefinedDataType [dbo].[tdDesc]    Script Date: 04/27/2011 12:01:43 ******/
CREATE TYPE [dbo].[tdDesc] FROM [varchar](1000) NULL
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_CheckMail]    Script Date: 04/27/2011 12:01:40 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_dbaDatatypeError]    Script Date: 04/27/2011 12:01:43 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_dba_XEvent]    Script Date: 04/27/2011 12:01:43 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_dba_who3]    Script Date: 04/27/2011 12:01:43 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_dba_wait3]    Script Date: 04/27/2011 12:01:43 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_dba_monitor]    Script Date: 04/27/2011 12:01:41 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_dba_mail]    Script Date: 04/27/2011 12:01:41 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_dba_log]    Script Date: 04/27/2011 12:01:41 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_dba_wait2]    Script Date: 04/27/2011 12:01:42 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_dba_wait]    Script Date: 04/27/2011 12:01:42 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_dba_startup]    Script Date: 04/27/2011 12:01:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_dba_startup]
as
--dbcc traceon (8033)
--dbcc traceon (830)

declare @assunto varchar(100)
select @assunto = rtrim(substring(@@servername,1,30))+': Servidor Reiniciando em: '+convert(varchar(19),getdate())

EXEC msdb.dbo.sp_send_dbmail
    @profile_name = 'Psafenotifier',
	@execute_query_database = 'master',
	@recipients = 'rodrigo@grupoxango.com ; daniel@grupoxango.com', 
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
/****** Object:  StoredProcedure [dbo].[sp_dba_JobsOutput]    Script Date: 04/27/2011 12:01:41 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_dba_monitor2]    Script Date: 04/27/2011 12:01:41 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_dba_BkpMissing]    Script Date: 04/27/2011 12:01:40 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_dba_bkp]    Script Date: 04/27/2011 12:01:40 ******/
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
