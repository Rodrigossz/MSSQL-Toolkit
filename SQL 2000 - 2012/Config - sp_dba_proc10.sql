use master
go

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON


-----------------------------------------------------------------------------------------------------------------------------
--	Error Trapping: Check If Procedure Already Exists And Drop If Applicable
-----------------------------------------------------------------------------------------------------------------------------

IF OBJECT_ID (N'[dbo].[usp_who5]', N'P') IS NOT NULL
BEGIN

	DROP PROCEDURE [dbo].sp_dba_proc10

END
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