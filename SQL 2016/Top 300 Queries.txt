/*------------------------------------------------------------------------------+ 

#| = : = : = : = : = : = : = : = : = : = : = : = : = : = : = : = : = : = : = : | 

#|{>/------------------------------------------------------------------------\<}| 

#|: | Script Name:FindTopCPUQueries| 

#|: | Author :Patrick Akhamie| 

#|: | Description:This script return top queries taxing sql server CPU's|

#|: | |

#|: | SQL Version:SQL 2012, SQL 2008 R2, SQL 2008|

#|: | Copyright :Free to use and share /^(o.o)^\|

#|: | |

#|: | Create Date:01-15-2012 Version: 1.0 |

#|: | Revision :01-19-2012 Version: 1.1 updated with standard variables |

#|:| History02-21-2012 Version: 1.2 updated with query_hash logic|

#|{>\------------------------------------------------------------------------/<}| 

#| = : = : = : = : = : = : = : = : = : = : = : = : = : = : = : = : = : = : = :| 

# Detect worst performing sql queries which is slowing down Microsoft SQL Server, this script return top queries taxing sql server CPUs. |

# Applicable to SQL Server 2008 or above. |

#+-----------------------------------------------------------------------------*/ 



use tempdb

go

IF object_id('tempdb..##FindTopCPUQueries_set1') is not null DROP TABLE [dbo].[##FindTopCPUQueries_set1]

GO

declare @ServerTime datetime = getdate()

, @ConvertMiliSeconds bigint = 1000

, @FilterMoreThanMiliSeconds bigint = 1

, @FilterHours bigint = 2

, @execution_count bigint = 2

, @debugFlg bit = 0



if @debugFlg=1 select @ServerTime as ServerTime, @ConvertMiliSeconds as ConvertMiliSeconds

, @FilterMoreThanMiliSeconds as FilterMoreThanMiliSeconds, @FilterHours as FilterHours 

, @execution_count as execution_count





select TOP 300

@@servername as servername,@ServerTime as runtime

,isnull(db_name(QueryText.dbid),'PreparedSQL') as DBName 

 ,SUBSTRING(QueryText.text, (QueryStats.statement_start_offset/2)+1, 

(isnull((

CASE QueryStats.statement_end_offset

 WHEN -1 THEN DATALENGTH(QueryText.text)

 WHEN 0 THEN DATALENGTH(QueryText.text)

 ELSE QueryStats.statement_end_offset

 END - QueryStats.statement_start_offset),0)/2) 

 + 1) AS QueryExecuted

,total_worker_time AS total_worker_time

,QueryStats.execution_count as execution_count

,statement_start_offset,statement_end_offset

,(case when QueryText.dbid is null then OBJECT_NAME(QueryText.objectid) else OBJECT_NAME(QueryText.objectid, QueryText.dbid) end) as ObjectName

,query_hash

,plan_handle

,sql_handle

into ##FindTopCPUQueries_set1

from sys.dm_exec_query_stats as QueryStats

cross apply sys.dm_exec_sql_text(QueryStats.sql_handle) as QueryText

where QueryStats.query_hash IN 

(

select QueryStatsBaseTable.query_hash 

from sys.dm_exec_query_stats QueryStatsBaseTable

where last_execution_time > DATEADD(hh,-@FilterHours,GETDATE())

group by query_hash

having (sum(total_worker_time)/sum(execution_count))>@ConvertMiliSeconds and sum(execution_count)>@execution_count

)

ORDER BY total_worker_time/execution_count DESC;



if @debugFlg=1 select * from ##FindTopCPUQueries_set1 order by QueryExecuted



IF object_id('tempdb..##FindTopCPUQueries_set2') is not null DROP TABLE [dbo].[##FindTopCPUQueries_set2]



select 

servername,runtime,max(DBName) as DBName,max(QueryExecuted) as QueryExecuted,(sum(total_worker_time)/sum(execution_count))/@ConvertMiliSeconds as AvgCPUTime

,sum(execution_count) as execution_count,query_hash, max(ObjectName) as ObjectName

into ##FindTopCPUQueries_set2

from ##FindTopCPUQueries_set1

group by query_hash,servername,runtime

order by AvgCPUTime desc





select * from ##FindTopCPUQueries_set2

--where QueryExecuted like 'select TOP 300%'

order by AvgCPUTime desc