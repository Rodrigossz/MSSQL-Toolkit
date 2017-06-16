/**********************
This is a demo script from http://brentozar.com
Scripts provided for testing/demo purposes only.
This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
http://creativecommons.org/licenses/by-nc-sa/3.0/
***********************/


/**********************
0. Preliminary Check
How long has our instance been up?
We want to know to contextualize the number of times the index was needed.
***********************/

select cast(
	datediff(hh,sqlserver_start_time,GETDATE())
	/24. 
	as numeric(10,1)) as [Days Uptime] 
from sys.dm_os_sys_info

--What does this mean for missing index data?


/**********************
1. Review missing indexes.
Let's create a view to look at them.
**************************/    
Use admin;
GO

if object_id('dbo.MissingIndexes') is null
	exec sp_executesql N'create view dbo.MissingIndexes as select ''''as Stub'
GO
ALTER VIEW dbo.MissingIndexes
as
SELECT 
		id.statement,
        cast(gs.avg_total_user_cost * gs.avg_user_impact * ( gs.user_seeks + gs.user_scans )as int) AS Impact,
        cast(gs.avg_total_user_cost as numeric(10,2)) as [Average Total Cost],
        cast(gs.avg_user_impact as int) as [% Reduction of Cost],
        gs.user_seeks + gs.user_scans as [Missed Opportunities],
        id.equality_columns as [Equality Columns],
        id.inequality_columns as [Inequality Columns],
        id.included_columns as [Included Columns]
FROM sys.dm_db_missing_index_group_stats AS gs
JOIN sys.dm_db_missing_index_groups AS ig ON gs.group_handle = ig.index_group_handle
JOIN sys.dm_db_missing_index_details AS id ON ig.index_handle = id.index_handle
go



--Run a fake workload using: MissingIndex_CreateMissingIndexStats.sql
--Time is passing....
--Queries are waking up, having a second cup of Sanka, and getting ready for the weekend.


--Check out your view

SELECT *
from admin.dbo.MissingIndexes
ORDER BY Impact desc

/**********************
2. Make a list of the columns which look interesting
**************************/ 
--Key:


--Include:



/**********************
3. Review indexes already on the table.
This will give you a sense of the current 'weight' of indexes for the table.
**************************/    
use ContosoRetailDW;
go

SELECT  
        OBJECT_NAME(ps.object_id) AS object_name ,
        ps.index_id ,
        ISNULL(si.name, '(heap)') AS index_name ,
        CAST(ps.reserved_page_count * 8 / 1024. / 1024. AS NUMERIC(10, 2)) AS reserved_GB ,
        ps.row_count ,
        ps.partition_number ,
        ps.in_row_reserved_page_count ,
        ps.lob_reserved_page_count ,
        ps.row_overflow_reserved_page_count
FROM    sys.dm_db_partition_stats ps
        LEFT JOIN sys.indexes AS si
            ON ps.object_id = si.object_id
               AND ps.index_id = si.index_id
WHERE   OBJECT_NAME(ps.object_id) = 'FactOnlineSales' 
 


--Check for indexes already on the table which may combine with your desired index.
--For example, there may be an existing index which you can add key columns or includes to, 
--That's always better than creating a new index!


--What is our table keyed on?
exec sp_helpindex FactOnlineSales


/**********************
4. Create an index
Let's try to play it safe and create a narrow index
**************************/  
use ContosoRetailDW;
go
   
CREATE NONCLUSTERED INDEX [ixFactOnlineSales_DateKey_Narrow] ON [dbo].[FactOnlineSales]
([DateKey] ASC) WITH (FILLFACTOR = 98) 
GO



--What did this do to our missing index recommendations?
SELECT *
from admin.dbo.MissingIndexes
ORDER BY Impact desc



--Run a fake workload using: MissingIndex_CreateMissingIndexStats.sql
--Time is passing....
--Queries are running marathons, taking long walks on beaches, and enjoying the sunset.



/**********************
5. Review index usage
**************************/  
use ContosoRetailDW;
go

SELECT  o.name as [Object Name],
        s.index_id as [Index ID],
		ps.partition_number as [Partition Num],
        i.name as [Index Name],
        i.type_desc as [Index Type],
        s.user_seeks + s.user_scans + s.user_lookups as [Total Queries Which Read] ,
        s.user_updates [Total Queries Which Wrote] ,
        ps.row_count as [Row Count],	
        CASE WHEN s.user_updates < 1 THEN 100
             ELSE ( s.user_seeks + s.user_scans + s.user_lookups ) / s.user_updates * 1.0
        END AS [Reads Per Write] 
FROM    sys.dm_db_index_usage_stats s
JOIN sys.dm_db_partition_stats ps on s.object_id=ps.object_id and s.index_id=ps.index_id
JOIN sys.indexes i ON i.index_id = s.index_id
	AND s.object_id = i.object_id
JOIN sys.objects o ON s.object_id = o.object_id
JOIN sys.schemas c ON o.schema_id = c.schema_id
WHERE 
		s.database_id=db_id()
		and o.name = 'FactOnlineSales'





/**********************
6. Do we still have missing indexes?
**************************/  
SELECT *
from admin.dbo.MissingIndexes
ORDER BY Impact desc

--Why is that?




/**********************
7. Let's try creating a covering index
**************************/  
Use ContosoRetailDW
GO

CREATE NONCLUSTERED INDEX [ixFactOnlineSales_DateKey_Covering] ON [dbo].[FactOnlineSales]
([DateKey],[ProductKey]) INCLUDE ([OnlineSalesKey], [StoreKey], [PromotionKey]) WITH (FILLFACTOR = 95) ON [PRIMARY]
GO

--I'm putting DateKey first, even though it was an 'Inequality'.
--This may not *always* be the best idea, but sometimes it works!



/**********************
8. Compare the size of our indexes
**************************/    
use ContosoRetailDW;
go

SELECT  
        OBJECT_NAME(ps.object_id) AS object_name ,
        ps.index_id ,
        ISNULL(si.name, '(heap)') AS index_name ,
        CAST(ps.reserved_page_count * 8 / 1024. / 1024. AS NUMERIC(10, 2)) AS reserved_GB ,
        ps.row_count ,
        ps.partition_number ,
        ps.in_row_reserved_page_count ,
        ps.lob_reserved_page_count ,
        ps.row_overflow_reserved_page_count
FROM    sys.dm_db_partition_stats ps
        LEFT JOIN sys.indexes AS si
            ON ps.object_id = si.object_id
               AND ps.index_id = si.index_id
WHERE   OBJECT_NAME(ps.object_id) = 'FactOnlineSales' 


--Let's drop that first index.
--Our second contains the same definition.
drop index [dbo].[FactOnlineSales].[ixFactOnlineSales_DateKey_Narrow]


--Run a fake workload using: MissingIndex_CreateMissingIndexStats.sql
--Time is passing....
--Queries are going to college, partying too much, and forgetting to go to class.



/**********************
9. Review index usage
**************************/  
use ContosoRetailDW;
go

SELECT  o.name as [Object Name],
        s.index_id as [Index ID],
		ps.partition_number as [Partition Num],
        i.name as [Index Name],
        i.type_desc as [Index Type],
        s.user_seeks + s.user_scans + s.user_lookups as [Total Queries Which Read] ,
        s.user_updates [Total Queries Which Wrote] ,
        ps.row_count as [Row Count],	
        CASE WHEN s.user_updates < 1 THEN 100
             ELSE ( s.user_seeks + s.user_scans + s.user_lookups ) / s.user_updates * 1.0
        END AS [Reads Per Write] 
FROM    sys.dm_db_index_usage_stats s
JOIN sys.dm_db_partition_stats ps on s.object_id=ps.object_id and s.index_id=ps.index_id
JOIN sys.indexes i ON i.index_id = s.index_id
	AND s.object_id = i.object_id
JOIN sys.objects o ON s.object_id = o.object_id
JOIN sys.schemas c ON o.schema_id = c.schema_id
WHERE 
		s.database_id=db_id()
		and o.name = 'FactOnlineSales'




/**********************
10. Do we still have missing indexes?
**************************/  
SELECT *
from admin.dbo.MissingIndexes
ORDER BY Impact desc





/**********************
11. ~ PROFIT ~
**************************/  

--We made things better, and we can prove it!




/**********************
THE END. Drop indexes
**************************/ 
use ContosoRetailDW
go

if indexproperty(object_id('FactOnlineSales'),'ixFactOnlineSales_DateKey_Covering','IsClustered') =0
	drop index [dbo].[FactOnlineSales].[ixFactOnlineSales_DateKey_Covering]
go

if indexproperty(object_id('FactOnlineSales'),'ixFactOnlineSales_DateKey_Covering','IsClustered') =0
	drop index [dbo].[FactOnlineSales].[ixFactOnlineSales_DateKey_Covering]
go

--sp_helpindex factonlinesales


