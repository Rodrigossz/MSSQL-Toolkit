CREATE PROCEDURE dbo.USP_Compression_Savings_By_DB
											  @checkdb nvarchar(255) = null		-- database we will be checking (by default runs all databases)
											, @admindbname nvarchar(255) = null	-- administrative database for holding the data (defaults to database where the Procedure is created)

AS


/****************************************************************************************
* THIS IS FOR ESTIMATION PURPOSES ONLY, YOU SHOULD PERFORM FULL TESTS AS REGARDS ACTUAL *
* SAVINGS AND POTENTIAL NEGATIVE IMPACT TO PERFORMANCE PRIOR TO IMPLEMENTING ANY CHANGES*
* IN A PRODUCTION ENVIRONMENT.															*
*																						*
* RECOMMENDED TO RUN THIS AGAINST A STAGING OR DEVELOPMENT SYSTEM DUE TO THE POTENTIAL  *
* IMPACT UPON THE SERVER WHILE RUNNING. AT THE VERY LEAST RUN THIS DURING YOUR SERVERS  *
* QUIETIST PERIOD.																		*
****************************************************************************************/


/****************************************************************************************
* The procedure runs the procedure sp_estimate_data_compression_savings against all or  *
* a selected database with all tables and all schemas.									*
* It accepts two paramters, the first @checkdb will be the database that you wish to    *
* estimate compression for. The second @admindbname is the database into which you wish *
* to place the results table dbo.estimated_data_compression_savings. By default this    *
* will be located in the same database as the procedure was created.					*
* We ignore system databases, as they cannot be compressed anyway.						*
*																						*
* Limitations:																			*
*																						*
* cannot examine individual indexes, this could prove useful							*
* cannot evaluate different partitions, very useful in DW systems						*
* no ability to pass multiple databases to the @checkdb variable						*
****************************************************************************************/



SET NOCOUNT ON



--declare all the variables
declare   @varint int						-- integer value of the database
		, @SQLCmd1      NVARCHAR(4000)		-- Dynamic SQL statment for sp_execute sql statements  
		, @ParmDef1       NVARCHAR(4000)	-- Dynamic SQL statment for sp_execute sql statements  
		, @database varchar(200)			-- used by the cursor
		, @sql varchar(2000)				-- holds the query we'll use for running the estimations page
		, @sql2 varchar(2000)				-- holds the query we'll use for running the estimations row
		, @schema varchar(2000)				-- allows us to query multiple schemas
		, @table sysname					-- table we are testing compression estimations again
		, @kbsize bigint					-- how big the data is
		, @loop  int						-- what we use to loop around the table listing


/****** if there is no @admindbname variable we just use the current database ******/
if @admindbname is null
	begin
	select @admindbname = DB_NAME()
	end

/****** if we are checking just one database check that it exists ******/
if @checkdb is not null
begin
if exists (select DATABASE_id from master.sys.databases where @checkdb = name and state = 0)
begin
select name from master.sys.databases where name = @checkdb and state = 0
end
else
begin
raiserror (N'The Database %s does not exist.', 16, 0, @checkdb)
end
end

/****** if we have a single database to check set the cursor for that one db ******/
if @checkdb is not null
begin
	select @varint = DATABASE_id from master.sys.databases where @checkdb = name and state = 0


	DECLARE database_names CURSOR
	 FOR SELECT database_id FROM master.sys.databases 
			WHERE database_id = @varint
end

else
/****** otherwise set the cursor to work on all databases (non system that is) ******/
begin
	DECLARE database_names CURSOR
	 FOR SELECT database_id FROM master.sys.databases 
			WHERE database_id > 4 and state = 0
end



DECLARE @database_id int
OPEN database_names

FETCH NEXT FROM database_names INTO @database_id
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN

/****** initialize the @checkdb parameter even though defined at the start ******/
select @checkdb = name from master.sys.databases where database_id = @database_id
--print @checkdb	


/****** if the table we are dumping data into doesn't exist, let's create it ******/
 SET @SQLCmd1 = N'IF NOT EXISTS (SELECT 1 FROM '+@AdminDBName+'.sys.tables
	WHERE name = '+char(39)+'estimated_data_compression_savings'+char(39)+')
		CREATE TABLE '+@AdminDBName+'.dbo.estimated_data_compression_savings
	(database_name sysname
	, [object_name] sysname
	, [schema_name] sysname
	, current_size_KB bigint
	, estimated_size_page_KB bigint
	, estimated_page_savings_KB bigint
	, estimated_page_savings_percent decimal(10,2)
	, estimated_size_row_KB bigint
	, estimated_row_savings_KB bigint
	, estimated_row_savings_percent decimal(10,2)) '
SET @ParmDef1 = N'@AdminDBName VARCHAR(255)'		
  
EXEC sp_executesql @SQLCmd1  
                    ,@parmdef1  
                    ,@AdminDBName  


/****** clear out any existing data from the table for the database we are checking ******/
SET @SQLCmd1 = N'DELETE FROM '+@AdminDBName+'.dbo.estimated_data_compression_savings
				WHERE database_name = '+CHAR(39)+@checkdb+char(39)+''
SET @ParmDef1 = N'@AdminDBName VARCHAR(255), @checkdb NVARCHAR(255)'
    
EXEC sp_executesql @SQLCmd1  
                    ,@parmdef1  
                    ,@AdminDBName, @checkdb  


/****** just in case the temp table exists, get rid of it ******/
 IF OBJECT_ID('tempdb..#temp') IS NOT NULL 
    DROP TABLE #temp
	
 --IF OBJECT_ID('tempdb..#thedata') IS NOT NULL 
 --   DROP TABLE #thedata	


/****** create the temp table to hold the current size information for each table in the database ******/
CREATE TABLE #temp (
                theid INT IDENTITY(1,1),
                table_name sysname ,
                row_count INT,
                reserved_size VARCHAR(50),
                data_size VARCHAR(50),
                index_size VARCHAR(50),
                unused_size VARCHAR(50))


/****** get the list of tables (with their schemas) for this database ******/
SET @SQLCmd1 = N'INSERT     #temp (table_name, row_count,reserved_size,data_size,index_size,unused_size)
EXEC     ['+@checkdb+']..sp_msforeachtable '+char(39)+'sp_spaceused'+char(39)+char(39)+'?'+char(39)+char(39)+char(39)+''
SET @ParmDef1 = N'@checkdb NVARCHAR(255)'
    EXEC sp_executesql @SQLCmd1  
                    ,@parmdef1  
                    ,@checkdb
                    

/****** and another temp table to create ******/
/****** for some reason this doesn't work with a # table ******/
 IF OBJECT_ID('tempdb..thedata') IS NOT NULL 
    DROP TABLE tempdb..thedata
    
CREATE TABLE tempdb..thedata (
	theid	int
	,table_name	nvarchar (750)
	,schemaname	sysname
	,row_count	int
	,col_count	int
	,data_size	int   ) 


/****** get the information about the tables ******/  
SET @SQLCmd1 =     N'INSERT INTO tempdb..thedata 
			SELECT a.theid,
			a.table_name,
			s.name as schemaname,
            a.row_count,
            COUNT(*) AS col_count,
            CAST(REPLACE(a.data_size, '+CHAR(39)+'KB'+CHAR(39)+','+CHAR(39)++CHAR(39)+') AS integer) as data_size
    FROM       #temp a
            INNER JOIN ['+@checkdb+'].information_schema.columns b
            ON a.table_name COLLATE database_default
    = b.table_name COLLATE database_default
			INNER JOIN ['+@checkdb+'].sys.objects o
			ON a.table_name COLLATE database_default
			= o.name COLLATE database_default
			INNER JOIN ['+@checkdb+'].sys.schemas s
			ON o.schema_id = s.schema_id
    GROUP BY   a.table_name, a.row_count, a.data_size, s.name,a.theid
    ORDER BY   CAST(REPLACE(a.data_size, '+CHAR(39)+'KB'+CHAR(39)+','+CHAR(39)++CHAR(39)+') AS integer) DESC'
 --select * from #thedata  
 SET @ParmDef1 = N'@checkdb NVARCHAR(255)'
  
 EXEC sp_executesql @SQLCmd1  
                    ,@parmdef1  
                    ,@checkdb 
                    

/****** get rid of the temp table, we don't need it any more ******/
DROP TABLE #temp



/****** create a couple of tables to hold the compression test information ******/
 IF OBJECT_ID('tempdb..#data_compression_page') IS NOT NULL 
    DROP TABLE #data_compression_page
 IF OBJECT_ID('tempdb..#data_compression_row') IS NOT NULL 
    DROP TABLE #data_compression_row
       
create table #data_compression_page
	([object_name] sysname
	, [schema_name] sysname
	, index_id int
	, partition_number int
	, [size_with_current_compression_setting(KB)] bigint
	, [size_with_requested_compression_setting(KB)] bigint
	, [sample_size_with_current_compression_setting(KB)] bigint
	, [sample_size_with_requested_compression_setting(KB)] bigint)

create table #data_compression_row
	([object_name] sysname
	, [schema_name] sysname
	, index_id int
	, partition_number int
	, [size_with_current_compression_setting(KB)] bigint
	, [size_with_requested_compression_setting(KB)] bigint
	, [sample_size_with_current_compression_setting(KB)] bigint
	, [sample_size_with_requested_compression_setting(KB)] bigint)
	
	
/****** here we are going to loop through the table/schema list and check the 
		estimated savings for both row and page compression					  ******/	
select @loop = min(theid) from tempdb..thedata

while @loop > 0 and @loop is not null
begin

select @table = table_name from tempdb..thedata where theid = @loop
select @schema = schemaname from tempdb..thedata where theid = @loop

/****** this is where we build the statement to estimate the savings that compression could provide ******/

/****** at the page level ******/                    
select @sql = 'insert into #data_compression_page exec ['+@checkdb+']..sp_estimate_data_compression_savings 
       @schema_name =  '''+@schema+'''  
     ,  @object_name = '''+@table+'''
    , @index_id =  null 
    , @partition_number = null
    , @data_compression =  ''page'';'
    
/****** at the row level ******/    
select @sql2 = 'insert into #data_compression_row exec ['+@checkdb+']..sp_estimate_data_compression_savings 
   @schema_name =  '''+@schema+'''  
 ,  @object_name = '''+@table+'''
, @index_id =  null 
, @partition_number = null
, @data_compression =  ''row'';'

/****** get the data ******/
exec(@sql)
exec(@sql2)


/****** loop around ******/
select @loop = MIN(theid) from tempdb..thedata where theid > @loop and @loop is not null 

end

/****** get rid of the data table, we no longer need it ******/
drop table tempdb..thedata


		
 /****** update the main table with the page estimations ******/
 SET @SQLCmd1 = N'INSERT INTO '+@AdminDBName+'.dbo.estimated_data_compression_savings
	(database_name
	, [object_name] 
	, [schema_name] 
	, current_size_KB 
	, estimated_size_page_KB 
 ) 
	SELECT 
		'+CHAR(39)+@checkdb+char(39)+'
		,[object_name]
		,[schema_name]
		,sum([size_with_current_compression_setting(KB)])
		,sum([size_with_requested_compression_setting(KB)])
	FROM #data_compression_page
	group by [object_name]
		,[schema_name]
		'
		
SET @ParmDef1 = N'@AdminDBName VARCHAR(255), @checkdb NVARCHAR(255)'
	EXEC sp_executesql @SQLCmd1 
                    ,@parmdef1  
                    ,@AdminDBName, @checkdb  


/****** we create a table to hold the results of estimated row compression ******/
 IF OBJECT_ID('tempdb..#rowupdates') IS NOT NULL 
    DROP TABLE #rowupdates
    
    
CREATE TABLE #rowupdates
	(database_name sysname
	, [object_name] sysname
	, [schema_name] sysname
	, current_size_KB bigint
	, estimated_size_row_KB bigint
	, estimated_row_savings_KB bigint
	, estimated_row_savings_percent int)
	
/****** then we insert the estimated savings based on row compression ******/	
SET @SQLCmd1 = N'INSERT INTO #rowupdates
	(database_name
	, [object_name] 
	, [schema_name] 
	, current_size_KB 
	, estimated_size_row_KB 
 ) 
	SELECT 
		'+CHAR(39)+@checkdb+char(39)+'
		,[object_name]
		,[schema_name]
		,sum([size_with_current_compression_setting(KB)])
		,sum([size_with_requested_compression_setting(KB)])
	FROM #data_compression_row
	group by [object_name]
		,[schema_name]
		'		
SET @ParmDef1 = N'@AdminDBName VARCHAR(255), @checkdb NVARCHAR(255)'
	EXEC sp_executesql @SQLCmd1 
                    ,@parmdef1  
                    ,@AdminDBName, @checkdb
                    
                    
/****** now update the master table with the row compression estimations ******/                    
    SET @SQLCmd1 = N'UPDATE '+@AdminDBName+'.dbo.estimated_data_compression_savings
set estimated_size_row_KB = r.estimated_size_row_KB
from #rowupdates r
INNER JOIN '+@AdminDBName+'.dbo.estimated_data_compression_savings e
ON r.object_name = e.object_name
and r.schema_name = e.schema_name
and r.database_name = e.database_name'				
				
SET @ParmDef1 = N'@AdminDBName VARCHAR(255)'

	EXEC sp_executesql @SQLCmd1 
                      ,@parmdef1  
                      ,@AdminDBName  
                    
/****** provide diff data between current and estimated ******/
SET @SQLCmd1 = N'UPDATE '+@AdminDBName+'.dbo.estimated_data_compression_savings
				set estimated_page_savings_KB = current_size_KB - estimated_size_page_KB
				, estimated_row_savings_KB = current_size_KB - estimated_size_row_KB
				'
SET @ParmDef1 = N'@AdminDBName VARCHAR(255)'
	EXEC sp_executesql @SQLCmd1 
                      ,@parmdef1  
                      ,@AdminDBName 
                    
/****** finally run a percentage calculation to show the estimated savings ******/
SET @SQLCmd1 = N'UPDATE '+@AdminDBName+'.dbo.estimated_data_compression_savings
set estimated_page_savings_percent = 
	((isnull(CAST(estimated_page_savings_KB AS Decimal(10,2)) / nullif(CAST(current_size_kb AS decimal(10,2)),0),0)) * 100)
, estimated_row_savings_percent = 
	((isnull(CAST(estimated_row_savings_KB AS Decimal(10,2)) / nullif(CAST(current_size_kb as decimal(10,2)),0),0)) * 100)
				'
SET @ParmDef1 = N'@AdminDBName VARCHAR(255)'
	EXEC sp_executesql @SQLCmd1 
                      ,@parmdef1  
                      ,@AdminDBName

 	END
/****** loop around the cursor ******/
	FETCH NEXT FROM database_names INTO @database_id
END

CLOSE database_names
DEALLOCATE database_names



GO


