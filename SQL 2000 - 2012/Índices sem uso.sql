use ba_automacao

CREATE TABLE #tables(
	rowid int identity (1,1),
	tabid int,
	tabname varchar(100)
)

CREATE TABLE CompileIndexesShowContig(
	rowid int identity (1,1),
	ObjectName sysname,
	ObjectId int,
	IndexName sysname,
	IndexId int,
	[Level] int,
	Pages int,
	[Rows] int,
	MinimumRecordSize int,
	MaximumRecordSize int,
	AverageRecordSize float,
	ForwardedRecords int,
	Extents int,
	ExtentSwitches int,
	AverageFreeBytes float,
	AveragePageDensity float,
	ScanDensity float,
	BestCount int,
	ActualCount int,
	LogicalFragmentation float,
	ExtentFragmentation float,
)


declare @tabcount int
	, @tabname varchar(100)

--set up "cursorless cursor"
INSERT INTO #tables(tabid, tabname)
select id, so.name
from sysobjects so
where so.xtype = 'U'

select @tabcount = @@rowcount

--count down all the rowids to loop on all tables
WHILE @tabcount > 0 
BEGIN

	SELECT @tabname = ltrim(rtrim([tabname]))
	FROM #tables
	WHERE rowid = @tabcount 

	INSERT INTO CompileIndexesShowContig(ObjectName, ObjectId, IndexName, IndexId, Level, Pages, Rows
	   , MinimumRecordSize, MaximumRecordSize, AverageRecordSize, ForwardedRecords, Extents
	   , ExtentSwitches, AverageFreeBytes, AveragePageDensity, ScanDensity, BestCount, ActualCount
	   , LogicalFragmentation, ExtentFragmentation)
	EXEC('DBCC SHOWCONTIG (' + @tabname + ') WITH ALL_INDEXES, TABLERESULTS')

	SET @tabcount = @tabcount - 1

END

drop table #tables

/***********************************************************/


CREATE TABLE IndexCaptureSummary (
	rowid int IDENTITY (1,1) not null,
	objectid int NULL ,
	indexid int NULL ,
	scans bigint NULL )

insert into IndexCaptureSummary (ObjectId, IndexID, Scans)
select objectid, indexid, count(*) as scans
from bA_dba..dba_trace (nolock)
group by objectid, indexid
option (maxdop 1)

select min(StartTime), max(StartTime) from dba_trace (nolock)
--2006-09-01 11:00:17.623                                2006-09-01 17:41:09.423

select cisc.objectname, cisc.indexname,averagerecordsize, ic.scans, floor(scans*cisc.averagerecordsize) as flow
from IndexCaptureSummary ic
inner join ba_automacao..CompileIndexesShowContig cisc on cisc.objectid = ic.objectid and cisc.indexid = ic.indexid
order by flow desc

select object_name(id), name
from sysindexes i
where  object_name(id) not like 'sys%' and name not like '_W%' and not exists (select 1 from IndexCaptureSummary ic
where
ic.ObjectId = i.id and ic.IndexID = i.indid)
order by 1,2