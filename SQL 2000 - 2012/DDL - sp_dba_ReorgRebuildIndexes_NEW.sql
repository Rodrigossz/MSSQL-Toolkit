USE [DBAdmin]
GO

/****** Object: StoredProcedure [dbo].[sp_Defrag_Indexes] Script Date: 08/31/2010 13:11:48 ******/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_et_Defrag_Indexes]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[sp_et_Defrag_Indexes]
GO

USE [DBAdmin]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/***********************************************************************************************************************

    SP for rebuilding or reorging indexes and updating statistics
    
    SQL 2005 or greater
    
        Version 1.0
            19 Aug 2010

        Version 1.1
            Added fragmentation before -- Fragmentation after is too resource instensive, and should be close to zero
            31 Aug 2010

        Version 1.2
            Added UpdateStats option
            Added elapsed time on a database level
            Check for the existance of the index (to allow for dropped indexes that were dropped after the start of the SP)
                This allows to a maintenance window on a database where the index may no longer exist after the indexes for defragmentation were chosen.
                Obviously some indexes can take a long time to rebuild/org, so there is the possibility that not all the chosen indexes remain in the
                databases at the time of execution.
            Checks for read-only and off-line databases
            Checks for the database being principal in a mirror (mirror's can't change recovery model)
            Checks for 2005 or later -(90)- compatibility level (2000 compatibility DB's [on a 2005/2008 server] don't support the use DMV's)
            Exclude TempDB and Model
            21 Sept 2010

        Version 1.3
            Resolved issue with blank DB Name -- I'm uncertain how @DBName is blank, but the SP no longer executes a statement that will error out. 
                --It may be an issue with the cursor going past the last database.
            Added page count to display the number of pages in the index
            Minor formatting changes
            21 Oct 2010

        Version 1.4
            Added @ExecAlter --This flag will determine if the SP executes the statements or just prints them.
            Resolved further issues with the blank @DBName
            29 Nov 2010

        Version 1.5
            Added option for updating stats only (no re-indexing)
            Added option for resampling stats
            Minor formatting changes
            Added check for database currently being restored
            Added database exclusion for upto three databases (the code can be modified to offer any number)
            Added verification that the database exists, is online, and is updatable for cases when *all* databases are being reindexed.
            25 Feb 2011

        Gregory Ferdinandsen
        greg@ferdinandsen.com


        Parameters:
            @DB = Either 'All' or the name of a single DB. If 'All' all databases on the server are examined; otherwise the name of a single DB.
            @Exclude = One or many databases to exclude; by default master, model, and TempDB are already excluded. Default is NULL.
                Primarily used in conjunction with all for @DB. Supports one database.
            @Exclude2 = One or many databases to exclude; by default master, model, and TempDB are already excluded. Default is NULL.
                Primarily used in conjunction with all for @DB. Supports one database.
            @Exclude3 = One or many databases to exclude; by default master, model, and TempDB are already excluded. Default is NULL.
                Primarily used in conjunction with all for @DB. Supports one database.
                ***NB: For @Exlude, this does not have to be a valid database name and there are no checks to indicate that the database does not exist
            @Stats = Statistical Sampling Method (Limited, Sampled, or Detailed) for determining what index will be impacted.
                --LIMITED - It is the fastest mode and scans the smallest number of pages. 
                        For an index, only the parent-level pages of the B-tree (that is, the pages above the leaf level) are scanned
                --SAMPLED - It returns statistics based on a 1 percent sample of all the pages in the index or heap. 
                        If the index or heap has fewer than 10,000 pages, DETAILED mode is used instead of SAMPLED.
                --DETAILED - It scans all pages and returns all statistics.
            @MinPageCount = Since index with few pages usually don't defrag (and a table scan is preferred), ignores small indexes
            @MaxPageCount = Maximum number of index pages to be considered. This can preclude very large indexes
            @Fill Factor = Specifies a percentage that indicates how full the Database Engine should make the leaf level of each index page 
                    during index creation or alteration. fillfactor must be an integer value from 1 to 100. The default is 0.
            @PAD_Index = The percentage of free space that is specified by FILLFACTOR is applied to the intermediate-level pages of the index. 
                If FILLFACTOR is not specified at the same time PAD_INDEX is set to ON, the fill factor value stored in sys.indexes is used.
            @SortInTempDB = The intermediate sort results that are used to build the index are stored in tempdb. 
                If tempdb is on a different set of disks than the user database, this may reduce the time needed to create an index. 
                However, this increases the amount of disk space that is used during the index build.
            @Online = Online rebuild (sometimes slower), for editions that support online rebuild (for editions that do not support online rebuild, this is ignored)
            @ReBuildTheshold = The threshold for deciding to rebuild v reorg (MSFT recommend's 30)
            @ReOrgThreshold = The threshold for deciding to rebuild v reorg (MSFT recommend's 5)
            @MaxFrag = The maximum amount of fragmentation to defrag (i.e. you don't want to defrag an index over 80%)
            @ChangeRecoveryModel = Set's the DB's in simple recovery mode prior to starting, reverts back to original mode on completion.
            @UpdateStats = Will update statistics for DB where needed
            @ResampleStats = Determines if stats will be resampled
            @UpdateStatsOnly = Will not alter indexes, will just update stats. The only other parameters that are used is @DB and @ExecAlter;
                however, all other parameters are parsed for validity, even though they are not in use.
            @ExecAlter = Will execute the alter statement statement and/or update stats SP

            NB:
            @Fill_Factor, @PAD_Index will only be applied to index that are rebuilt (Fragmentation >= @ReBuildTheshold)
            **There is a possible issue with database names containing GUID's**

            Unfortunatly, I would prefer to simply have one @Exclude, but creating the dynamic SQL would cause more errors that the added
                functionality would enhance.

            It is recommended that as part of a job, you create an appended text file output for this SP. It provides detailed information
                and is useful in troubleshooting any bugs


            Alter Index -- http://technet.microsoft.com/en-us/library/ms188388.aspx
            sys.dm_db_index_physical_stats -- http://msdn.microsoft.com/en-us/library/ms188917.aspx
            sp_updatestats -- http://msdn.microsoft.com/en-us/library/ms173804.aspx

        examples:
            Simple Execution (All default parameters; ie all databases, default thresholds, etc):
                exec dbadmin..sp_et_Defrag_Indexes

            More Complex Exection:
                exec dbadmin..sp_et_Defrag_Indexes, @FillFactor = 75, @Stats = 'Detailed'

            Execution Specifying all Parameters:
                exec dbadmin..sp_et_Defrag_Indexes
                    @DB = 'changepoint',
                    @Exclude = 'Workflow',
                    @Exclude2 = NULL,
                    @Exclude3 = NULL,
                    @Stats = 'Detailed',
                    @MinPageCount = 150,
                    @FillFactor = 65,
                    @PAD_Index = 'true',
                    @SortInTempDB = 'true',
                    @ReBuildTheshold = 50,
                    @ReOrgThreshold = 5,
                    @ChangeRecoveryModel = 'false',
                    @UpdateStats = 'false',
                    @ResampleStats = true',
                    @UpdateStatsOnly = 'false',
                    @ExecAlter = 'true'
***********************************************************************************************************************/

create procedure [dbo].[sp_et_Defrag_Indexes]
    (
    @DB varchar(256) = 'all',
    @Exclude varchar(2048) = NULL,
    @Exclude2 varchar(2048) = NULL,
    @Exclude3 varchar(2048) = NULL,
    @Stats varchar(8) = 'sampled',
    @MinPageCount int = 24, --As a general rule, indexes with less than 24 pages are rarely used, SQL usually performs a table scan in that case. This can be checked by looking at the query plan.
    @MaxPageCount float = 1000000000000000, --A very large default number (few index would be this large, therefore we can think of this as approaching infinity)
    @FillFactor int = NULL, --NULL defaults to what the index was originally built with
    @PAD_Index varchar(8) = 'true',
    @SortInTempDB varchar(8) = 'true',
    @OnlineReq varchar(8) = 'true',
    @ReBuildTheshold real = 30.0, --MSFT recommendation
    @ReOrgThreshold real = 5.0, --MSFT recommendation
    @MaxFrag real = 100.0,
    @ChangeRecoveryModel varchar(8) = 'false',
    @UpdateStats varchar(8) = 'false',
    @ResampleStats varchar(8) = 'false',
    @UpdateStatsOnly varchar(8) = 'false',
    @ExecAlter varchar(8) = 'true'
    )

    as

    declare @SQLCmd as varchar (8000)
    declare @SQLCmdBk as varchar(4096)
    declare @SQLCmdWith as varchar(4096)
    declare @SQLCmdFill varchar(1024)
    declare @SQLCmdOnline varchar(1024)
    declare @SQLCmdPad varchar(1024)
    declare @SQLCmdSort varchar(1024)
    declare @SQLCmdRecovery varchar(2048)
    declare @SQLCmdStats varchar(1024)
    declare @SQLCmdExist as nvarchar(2048)
    declare @exit varchar(8)
    declare @ErrorTxt as varchar(128)
    declare @SQLEdition as varchar(64)
    declare @Online as varchar(8)
    declare @RestoringStatus as varchar(64)
    declare @DBName as varchar(512)
    declare @ObjectID int
    declare @IndexID int
    declare @PartitionNum as bigint
    declare @Frag as float
    declare @FragOld as float
    declare @FragTxt as varchar(2048)
    declare @PageCount as bigint
    declare @PartitionCount as bigint
    declare @ParititionNum as bigint
    declare @IndexName as varchar(256)
    declare @SchemaName as varchar(256)
    declare @ObjectName as varchar(256)
    declare @ParmDef nvarchar(1024)
    declare @SQLCmdID as nvarchar(2048)
    declare @RecoveryModel as varchar(16)
    declare @IndexNameExists varchar (256)
    declare @PDExist nvarchar(1024)
    declare @IndexExists nvarchar(256)
    declare @Start datetime
    declare @Finish datetime
    declare @Total varchar(64)
    declare @RO as varchar(256)
    declare @CompatibilityLevel as varchar(64)
    declare @Mirrored as varchar(8)
    declare @TotalIndexes as int
    declare @DBStatus as varchar(128)
    declare @StartTimeIndex as datetime
    declare @FinishTimeIndex as datetime
    declare @TotalTimeIndex as varchar(64)
    declare @StartTimeStats as datetime
    declare @FinishTimeStats as datetime
    declare @TotalTimeStats as varchar(64)
    declare @DBNameError as varchar(8)

    --Verify that proper parameters were passed to SP
    if lower(@Stats) not in ('limited', 'sampled', 'detailed')
        begin
            RaisError ('@Stats must be "limited", "sampled", or "detailed"', 16, 1)
            return
        end

    if lower(@PAD_Index) not in ('true', 'false')
        begin
            RaisError ('@PAD_Index must be "true" or "false"', 16, 1)
            return
        end

    if lower(@SortInTempDB) not in ('true', 'false')
        begin
            RaisError ('@SortInTempDB must be "true" or "false"', 16, 1)
            return
        end

    if lower(@OnlineReq) not in ('true', 'false')
        begin
            RaisError ('@OnlineReq must be "true" or "false"', 16, 1)
            return
        end

    if lower(@ExecAlter) not in ('true', 'false')
        begin
            RaisError ('@ExecAlter must be "true" or "false"', 16, 1)
            return
        end

    if lower(@ResampleStats) not in ('true', 'false')
        begin
            RaisError ('@ResampleStats must be "true" or "false"', 16, 1)
            return
        end

    if lower(@UpdateStatsOnly) not in ('true', 'false')
        begin
            RaisError ('@UpdateStatsOnly must be "true" or "false"', 16, 1)
            return
        end

    if @FillFactor not between 0 and 100
        begin
            RaisError ('@FillFactor must be between 0 and 100', 16, 1)
            return
        end

    if @ReBuildTheshold not between 1 and 99.999
        begin
            RaisError ('@ReBuildTheshold must be between 1 and 99.999', 16, 1)
            return
        end

    if @ReOrgThreshold not between .1 and 99.5
        begin
            RaisError ('@ReOrgThreshold must be between .1 and 99.5', 16, 1)
            return
        end

    --You can't have rebuild be at a lower level than reorg
    if @ReBuildTheshold <= @ReOrgThreshold set @ReOrgThreshold = @ReBuildTheshold - 0.01

    --There would be nothing returned if MaxFrag was less than the reorg threshold.
    if @MaxFrag not between @ReOrgThreshold and 100
        begin
            RaisError ('@MaxFrag must be between the @ReOrgThreshold value (default of 5) and 100', 16, 1)
            return
        end

    if @MinPageCount < 0
        begin
            RaisError ('@MinPageCount must be positive', 16, 1)
            return
        end

    if @MaxPageCount < 10
        begin
            RaisError ('@MaxPageCount must be greater than 10', 16, 1)
            return
        end

    if lower(@ChangeRecoveryModel) not in ('true', 'false')
        begin
            RaisError ('@ChangeRecoveryModel must be "true" or "false"', 16, 1)
            return
        end

    if lower(@UpdateStats) not in ('true', 'false')
        begin
            RaisError ('@UpdateStats must be in "true" or "false"', 16, 1)
            return
        end

    if @MinPageCount > @MaxPageCount
        begin
            RaisError ('@MinPageCount cannot be greater than @MaxPageCount', 16, 1)
            return
        end

    if @UpdateStatsOnly = 'true' set @UpdateStats = 'true'

    --Make checks for individual databases (Valid Name, On-Line, Not Read-Only, 2005 or Later Compatibility Level)
    --NB: these check only apply if the database name is specified.
    if lower(@DB) <> 'all'
        begin
            if not exists (select name from sys.databases where name = @DB)
                begin
                    set @ErrorTxt = 'The supplied database (' + @DB + ') does not exist.'
                    RaisError (@ErrorTxt, 16, 1)
                    return
                end

            --DB has been verified to exist; now make sure it's able to be defragged
            --Granted the restoring check is redundant since the SP checks for ONLINE; however, during one job execution it failed because the DB was restoring
            set @RO = cast(DatabasePropertyEx(@DB, 'Updateability') as varchar(128))
            set @DBStatus = lower(cast(DatabasePropertyEx(@DB, 'Status') as varchar(128)))
            select @CompatibilityLevel = compatibility_level from sys.databases where name = @DB
            set @RestoringStatus = lower(cast(DatabasePropertyEx(@DB, 'Status') as varchar(128)))

            if @DBStatus <> 'online'
                begin
                    set @ErrorTxt = 'Database ' + @DB + ' is not online. The database is currently ' + @DBStatus + '. No operations can be performed.'
                    RaisError (@ErrorTxt, 16, 1)
                    return
                end

            if upper(@RO) = 'READ_ONLY'
                begin
                    set @ErrorTxt = 'Database ' + @DB + ' is read only. No operations can be performed.'
                    RaisError (@ErrorTxt, 16, 1)
                    return
                end

            if @CompatibilityLevel < 90
                begin
                    set @ErrorTxt = 'Database ' + @DB + ' is in an older compatibility mode and is not compatibile with this SP. ' +
                        'Compatibility Level = ' + @CompatibilityLevel
                    RaisError (@ErrorTxt, 16, 1)
                    return
                end

            if lower(@RestoringStatus) = 'restoring'
                begin
                    set @ErrorTxt = 'Database ' + @DB + ' is currently being restored. Reindexing will be aborted' + @CompatibilityLevel
                    RaisError (@ErrorTxt, 16, 1)
                    return
                end
        end

    --Determine SQL Edition (for online rebuild -- Enterprise and Developer support online rebuild)
    set @SQLEdition = cast(ServerProperty('Edition') as varchar)
    set @SQLEdition =
        case 
            when @SQLEdition = 'Enterprise Edition' then 'Enterprise'
            when @SQLEdition = 'Standard Edition' then 'Standard'
            when @SQLEdition = 'Developer Edition' then 'Developer'
        end
    if @SQLEdition = 'Enterprise' or @SQLEdition = 'Developer'
        begin
            set @Online = 'true'
        end
    else set @Online = 'false'

/*********************************************************************************************************************
    If only one db is specified, make sure that it is not excluded
    If blank spaces are put in @Exclude, simply set to junk name (NB, change this is a DB is named ZZZ); if no parameter is passed, set a value
    There is no need for this to be a valid database name. Since the select is encapsulated within a NOT IN statement, it won't return anything
        i.e. a database name that does not exist won't be in the statement, hence the not in
*********************************************************************************************************************/

    if @DB <> 'all'
        begin
            if @Exclude = @DB
                begin
                    set @ErrorTxt = 'You can not exclude the only database to have operations performed upon it'
                    RaisError (@ErrorTxt, 16, 1)
                    return
                end

            if @Exclude2 = @DB
                begin
                    set @ErrorTxt = 'You can not exclude the only database to have operations performed upon it'
                    RaisError (@ErrorTxt, 16, 1)
                    return
                end

            if @Exclude3 = @DB
                begin
                    set @ErrorTxt = 'You can not exclude the only database to have operations performed upon it'
                    RaisError (@ErrorTxt, 16, 1)
                    return
                end
        end

    if @Exclude is not null
        begin
            if len(ltrim(rtrim(@Exclude))) = 0 set @Exclude = 'ZZZ'
        end
    else set @Exclude = 'OldZZZ'

    if @Exclude2 is not null
        begin
            if len(ltrim(rtrim(@Exclude2))) = 0 set @Exclude2 = 'ZZZ'
        end
    else set @Exclude2 = 'OldZZZ'

    if @Exclude3 is not null
        begin
            if len(ltrim(rtrim(@Exclude3))) = 0 set @Exclude3 = 'ZZZ'
        end
    else set @Exclude3 = 'OldZZZ'

    /*********************************************************************************************************************
        Since I set up the job to run this SP with output to a text file (appended) it is very helpful to have
        large sections replete with formatted spacing to indicate the start of various functions:
                    1: Start of the job with datetime
                    2: Name of the database on which the operation is being performed
                    3: Updating indexes
                    4: Updating stats
                    5: Completion of the SP (hence completion of the job) with datetime

    *********************************************************************************************************************/

    print '¤¤¤¤                                                                                                                 '
    print '¤¤¤¤¤¤¤¤¤¤¤¤                                                                                                         '
    print '¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤                                                                                         '
    print '¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤                                                                     '
    print '°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°'
    print '******************************************************************************************************************'
    print '°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°'
    print '                                                                                                                     '
    print '                                                                                                                     '
    print '                                        Indexing/Stats Job For: ' + cast(getdate() as varchar) + '                     '
    print '                                                                                                                     '
    print '                                                                                                                     '
    print '°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°'
    print '******************************************************************************************************************'
    print '°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°'
    print '¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤                                                                     '
    print '¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤                                                                                         '
    print '¤¤¤¤¤¤¤¤¤¤¤¤                                                                                                         '
    print '¤¤¤¤                                                                                                                 '
    print '                                                                                                                     '
    print '                                                                                                                     '
    print '                                                                                                                     '
    print '                                                                                                                     '
    print '                                                                                                                     '
    

    --If only one database, then go to the inner cursor (The Index Cursor) then exit that cursor before without executing the fetch next command
    set @Exit = 'false'
    If @DB <> 'All'
        begin
            set @Exit = 'true'
            set @DBName = @DB
            goto ExecuteForEachDatabase
        end

    /*********************************************************************************************************************

                                                            Outer Cursor [for DBName]

    *********************************************************************************************************************/
    declare DatabaseNames cursor
        for select name from sys.databases
            where state_desc = 'ONLINE' and is_read_only = 0 and compatibility_level >= 90 and state = 0
                and name not in ('TempDB', 'Model', 'Master', @Exclude, @Exclude2, @Exclude3)
            order by name

        open DatabaseNames
        fetch next from DatabaseNames into @DBName

        while @@fetch_status <> -1
            begin
ExecuteForEachDatabase:
                print '//////////////////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\'
                print '                                                                                                     -'
                print '                                            ' + @DBName + '                                             '
                print '                                                                                                     -'
                print '\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\//////////////////////////////////////////////////'

                set @Start = getdate()
                set @StartTimeIndex = @Start

                --Check for the existance of the #tmpTable, if it exists, then delete the #tmpTable (In case the SP exited ugly w/out deleting the table)
                if exists (Select * from tempdb.sys.objects where name = '#Fragmentation' and type in('U'))
                    begin
                        drop table #Fragmentation
                    end

                --Determine Mirrored Status, Recovery Model (If DB is mirrored, recovery model cannot be changed)
                set @Mirrored = 'false'
                if exists (select db_id(@DBName) from sys.database_mirroring where mirroring_state is not null) set @Mirrored = 'true'
                    else set @Mirrored = 'false'

                set @RecoveryModel = cast(DatabasePropertyEx(@DBName, 'Recovery') as varchar(16))
                if upper(@RecoveryModel) in ('FULL', 'BULK_LOGGED') and @ChangeRecoveryModel = 'true' and @Mirrored = 'false'
                    begin
                        set @SQLCmdRecovery = 'alter database ' + quotename(@DBName) + ' set recovery SIMPLE with no_wait'
                        print @DBName + ' recovery model set to simple. -- {' + @SQLCmdRecovery + '}'
                        exec (@SQLCmdRecovery)
                    end

                if upper(@RecoveryModel) in ('FULL', 'BULK_LOGGED') and @ChangeRecoveryModel = 'true' and @Mirrored = 'true'
                    begin
                        print 'The database ' + @DBName + ' is currently mirrored, changing the recovery model is not supported.'
                        print 'Reindex will continue without changing recovery model...'
                        print '                                    -'
                    end

                /*********************************************************************************************************************
                
                    Check to see that the DB is online.
                        When the databases were inserted into the cursor, that is a static view at that point in time.
                        A database that may have been online at 1:45AM, may be offline by 4:15AM.
                        Since the cursor sequentially goes through each database, and some databases may take an hour to run, verify that the current DB is still good.
                        At the same time, check to make sure it was not dropped.
                    
                *********************************************************************************************************************/
                set @DBStatus = lower(cast(DatabasePropertyEx(@DBName, 'Status') as varchar(128)))
                set @RO = cast(DatabasePropertyEx(@DB, 'Updateability') as varchar(128))

                if @DBStatus <> 'online'
                    begin
                        set @ErrorTxt = 'Database ' + @DB + ' is not online. The database is currently ' + @DBStatus + '. No operations can be performed. '
                        print 'Continuing on to next database... '
                        print @ErrorTxt + ' '
                        goto NextDB
                    end

                if upper(@RO) = 'READ_ONLY'
                        begin
                            set @ErrorTxt = 'Database ' + @DB + ' is read only. No operations can be performed. '
                            print 'Continuing on to next database... '
                            print @ErrorTxt + ' '
                            goto NextDB
                        end

                if not exists (select name from sys.databases where name = @DBName)
                    begin
                        set @ErrorTxt = 'Database ' + @DBName + ' no longer exists. Continuing on to next database.                    '
                        print @ErrorTxt + ' '
                        goto NextDB
                    end

                --If only updating stats and not altering indexes, go directly to the stats portions of the code
                if @UpdateStatsOnly = 'true' goto UpdateStatsOnly

                --Index_ID of 0 is a heap index, no need to defrag
                select object_id as ObjectID, index_id as IndexID, partition_number as PartitionNum, avg_fragmentation_in_percent as Frag, page_count as Pages
                    into #Fragmentation
                    from sys.dm_db_index_physical_stats (db_id(@DBName), null, null , null, @Stats)
                    where avg_fragmentation_in_percent >= @ReOrgThreshold and avg_fragmentation_in_percent < = @MaxFrag
                        and index_id > 0
                        and Page_Count >= @MinPageCount and Page_Count <= @MaxPageCount
                        order by avg_fragmentation_in_percent desc

                select @TotalIndexes = count(*) from #Fragmentation
                print '                                    -'
                print 'Total indexes to be altered in ' + @DBName + ': ' + cast(@TotalIndexes as varchar)
                print '                                    -'

                /*********************************************************************************************************************
                
                                                            Inner Cursor [for Index Objects]

                *********************************************************************************************************************/
                declare CurPartitions cursor
                    for select * from #Fragmentation

                    open CurPartitions
                    fetch next from CurPartitions into @ObjectID, @IndexID, @ParititionNum, @Frag, @PageCount

                    while @@fetch_status <> -1
                        begin
                            --select @ObjectName = quotename(obj.name), @SchemaName = quotename(sch.name)
                            --    from sys.objects as obj
                            --    join sys.schemas as sch on sch.schema_id = obj.schema_id
                            --    where obj.object_id = @ObjectID
                            set @SQLCmdID = 'select @ObjectName = quotename(obj.name), @SchemaName = quotename(sch.name) from ' + @DBName + 
                                '.sys.objects as obj join ' + @DBName + '.sys.schemas as sch on sch.schema_id = obj.schema_id where obj.object_id = @ObjectID'
                            set @ParmDef = N'@ObjectID int, @ObjectName sysname output, @SchemaName sysname output'
                            exec sp_executesql @SQLCmdID, @ParmDef, @ObjectID = @ObjectID, @ObjectName = @ObjectName output, @SchemaName = @SchemaName output

                            --select @IndexName = quotename(name)
                            --    from sys.indexes
                            --    where object_id = @ObjectID and index_id = @IndexID
                            set @SQLCmdID = 'select @IndexName = quotename(name) from ' + @DBName + '.sys.indexes where object_id = @ObjectID and index_id = @IndexID'
                            set @ParmDef = N'@ObjectId int, @IndexId int, @IndexName sysname output'
                            exec sp_executesql @SQLCmdID, @ParmDef, @ObjectId = @ObjectId, @IndexId = @IndexId, @IndexName = @IndexName output

                            --select @PartitionCount = count (*)
                            --    from sys.partitions
                            --    where object_id = @ObjectID and index_id = @IndexID
                            set @SQLCmdID = 'select @PartitionCount = count (*) from ' + @DBName + '.sys.partitions where object_id = @ObjectID and index_id = @IndexID'
                            set @ParmDef = N'@ObjectId int, @IndexId int, @PartitionCount int output'
                            exec sp_executesql @SQLCmdID, @ParmDef, @ObjectId = @ObjectId, @IndexId = @IndexId, @PartitionCount = @PartitionCount output

                            --ReOrg/ReBuild Command
                            if @frag < @ReBuildTheshold
                                begin
                                    set @SQLCmdBk = 'alter index ' + @IndexName + ' on ' + quotename(@DBName) + '.' + @SchemaName + '.' + @ObjectName + ' reorganize'
                                end
                            if @frag >= @ReBuildTheshold
                                begin
                                    set @SQLCmdBk = 'alter index ' + @IndexName + ' on ' + quotename(@DBName) + '.' + @SchemaName + '.' + @ObjectName + ' rebuild'
                                end

                            --set options
                            if @FillFactor is not null set @SQLCmdFill = 'fillfactor = ' + cast(@FillFactor as varchar(3)) + ', '
                            if ((@Online = 'true') and (@OnlineReq = 'true')) set @SQLCmdOnline = 'online = on, '
                            if @PAD_Index = 'true' set @SQLCmdPad = 'PAD_Index = on, '
                            if @SortInTempDB = 'true' set @SQLCmdSort = 'Sort_in_TempDB = on, '

                            if @PartitionCount > 1 set @SQLCmdBk = @SQLCmdBk + ' partition = ' + cast(@PartitionNum as nvarchar(10))

                            set @SQLCmdWith = ' with ('

                            --With options only apply to rebuilds, not to re-org
                            if @frag >= @ReBuildTheshold
                                begin
                                    if @SQLCmdFill is not null set @SQLCmdWith = @SQLCmdWith + @SQLCmdFill
                                    if @SQLCmdOnline is not null set @SQLCmdWith = @SQLCmdWith + @SQLCmdOnline
                                    if @SQLCmdPad is not null set @SQLCmdWith = @SQLCmdWith + @SQLCmdPad
                                    if @SQLCmdSort is not null set @SQLCmdWith = @SQLCmdWith + @SQLCmdSort
                                end

                            if @SQLCmdWith <> ' with (' set @SQLCmdWith = left(@SQLCmdWith, len(@SQLCmdWith) - 1) + ')'
                            if @SQLCmdWith <> ' with (' set @SQLCmd = @SQLCmdBk + @SQLCmdWith
                            else set @SQLCmd = @SQLCmdBk

                            --Determine old fragmentation levels and page count; it can be assumed that current fragmentation is close to zero
                            set @FragOld = @Frag
                            set @FragTxt = ' -- Fragmentation had been: ' + 
                                cast(cast((cast((@FragOld * 100) as int)) as real) / 100 as varchar) + '% <<->> Page Count = ' + cast(@PageCount as varchar)

                            /*********************************************************************************************************************
                            Check to find out that index still exists (eliminates the possibility of dynamic index creation/dropped)
                                This will also cover a CR executed during this time to drop/rename an object
                                In very few cases, I have seen the DMV return a corrupt name, this should also eliminate that possibility
                            *********************************************************************************************************************/
                            set @IndexNameExists = substring(@IndexName, 2, len(@IndexName) - 2) --Get rid of the brackets :<>: [IndexName] --> IndexName
                            set @SQLCmdExist = N'select @IndexExists = name from ' + @DBName + '.sys.indexes where name = ''' + @IndexNameExists + ''''
                            set @PDExist = N'@IndexExists varchar(128) output'
                            exec sp_executesql @SQLCmdExist, @PDExist, @IndexExists output

                            /*********************************************************************************************************************
                            An issue exists where the db name is blank, it may be filled with unprintable characters, this will resolve the issue
                                by going to the next database in the cursor. Without this statement, SQL wil be unable to find the object.
                            *********************************************************************************************************************/
                            if quotename(@DBName) = '[ ]'
                                begin
                                    print 'Error: Database name is blank'
                                    drop table #Fragmentation
                                    close CurPartitions
                                    deallocate CurPartitions
                                    goto NextDB
                                end

                            --If the index is still there, then print and execute
                            --NB, @IndexExists is the name of the Index (from sys.indexes), it should be greater than two characters
                            if ((len(@IndexExists) > 2) or (len(ltrim(rtrim(@DBName))) = 0))
                                begin
                                    print @SQLCmd + @FragTxt
                                    if @ExecAlter = 'true' exec (@SQLCmd)
                                end
                                else
                                    begin
                                        print 'ERROR:'
                                        print ' Unable to execute command: ' + @SQLCmd
                                        print ' Error: index ' + @IndexName + ' cannot be located in ' + @DBName + 'sys.indexes'
                                        print ' This may indicate the the index has been dropped from the database since this SP has started or that the DMV is corrupt.'
                                        print ' Continuing with next index... ... ... ...'
                                        print '                                    -'
                                        print '                                    -'
                                    end

                            fetch next from CurPartitions into @ObjectID, @IndexID, @ParititionNum, @Frag, @PageCount
                        end --CurPartitions
                    close CurPartitions
                    deallocate CurPartitions
                    drop table #Fragmentation

                    set @FinishTimeIndex = getdate()
                    set @TotalTimeIndex = datediff(second, @StartTimeIndex, @FinishTimeIndex)
                    print ''

                    --If DB was in Full or Bulk_Logged and t-logging was disabled, then re-enable
                    if upper(@RecoveryModel) in ('FULL', 'BULK_LOGGED') and @ChangeRecoveryModel = 'true' and @Mirrored <> 'true'
                        begin
                            set @SQLCmdRecovery = 'alter database ' + quotename(@DBName) + ' set recovery ' + @RecoveryModel + ' with no_wait'
                            print @DBName + ' recovery model set to ' + lower(@RecoveryModel) + '. -- {' + @SQLCmdRecovery + '}'
                            exec (@SQLCmdRecovery)
                        end

                    --Update Statistics
UpdateStatsOnly:
                    if @UpdateStats = 'true'
                        begin
                            set @StartTimeStats = getdate()
                            set @SQLCmdStats = 'exec ' + quotename(@DBName) + '..sp_updatestats'

                            if @ResampleStats = 'true'
                                begin
                                    set @SQLCmdStats = @SQLCmdStats + ' @resample = ' + '''resample'''
                                end
                            print '                                                                                                                 '
                            print '¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶'
                            print '¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶'
                            print '                                                                                                                 '
                            print '                                            Updating Stats for ' + @DBName + ' '
                            print '                                                                                                                 '
                            print '¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶'
                            print '¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶'
                            print '                                                                                                                 '
                            print @SQLCmdStats
                            print '                                                                                                                 '
                            print '                                                                                                                 '
                            if @ExecAlter = 'true' exec (@SQLCmdStats)
                            print '                                                                                                                 '
                            print '                                                                                                                 '
                            set @FinishTimeStats = getdate()
                            set @TotalTimeStats = datediff(second, @StartTimeStats, @FinishTimeStats)
                        end

                    --Display total elapsed time per database
                    set @Finish = getdate()
                    set @Total = datediff(second, @Start, @Finish)
                    print '                                                                                        -'
                    print 'Total Time Elapsed For ' + @DBName + ' = ' + @Total + ' second(s)'
                    print '                                                                                        -'
                    print cast(getdate() as varchar) + '                                                                            -'
                    print '                                                                                        -'
                    --If stats are updated, break down time by index and stats
                    if @UpdateStats = 'true'
                        begin
                            print '                                                                                        -'
                            print 'Total Index Time = ' + @TotalTimeIndex + ' second(s)'
                            print 'Total Stats Time = ' + @TotalTimeStats + ' second(s)'
                        end
                    print '                                                                                        -'
                    print '                                                                                        -'
                    print '                                                                                        -'

                    --If only defragging a single database {@DBName has a value other than 'All'}, then return out of the SP, otherwise fetch next
                    if @Exit = 'true' 
                        begin
                            print '§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§ '
                            print '§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§ '
                            print '                                                                                                                                         '
                            print '                                                            Indexing/Stats Complete                                                             '
                            print '                                                                    ' + cast(getdate() as varchar) + '                                                     '
                            print '                                                                                                                                         '
                            print '§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§ '
                            print '§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§ '
                            print '                                                                                                                                         '
                            print '                                                                                                                                         '
                            print '                                                                                                                                         '
                            return
                        end
NextDB:
                --This exits out of the DB objects cursor and fetches the next database.
                fetch next from DatabaseNames into @DBName
            end --DatabaseNames
    close DatabaseNames
    deallocate DatabaseNames

    print '§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§ '
    print '§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§ '
    print '                                                                                                                                         '
    print '                                                            Indexing/Stats Complete                                                             '
    print '                                                            ' + cast(getdate() as varchar) + '                                                 '
    print '                                                                                                                                         '
    print '§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§ '
    print '§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§ '
    print '                                                                                                                                         '
    print '                                                                                                                                         '
    print '                                                                                                                                         '
    print '                                                                                                                                         '
    print '                                                                                                                                         '
    print '                                                                                                                                         '
go


