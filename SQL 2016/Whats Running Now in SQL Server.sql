
--Create the database
USE [master]
GO

CREATE DATABASE [SQL_Monitoring] ON  PRIMARY 
( NAME = N'SQL_Monitoring', FILENAME = N'<ADD YOUR PATH HERE>\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\SQL_Monitoring.mdf' , SIZE = 95040KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'SQL_Monitoring_log', FILENAME = N'<ADD YOUR PATH HERE>\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\SQL_Monitoring_log.ldf' , SIZE = 69760KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO

ALTER DATABASE [SQL_Monitoring] SET COMPATIBILITY_LEVEL = 100
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [SQL_Monitoring].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [SQL_Monitoring] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [SQL_Monitoring] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [SQL_Monitoring] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [SQL_Monitoring] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [SQL_Monitoring] SET ARITHABORT OFF 
GO

ALTER DATABASE [SQL_Monitoring] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [SQL_Monitoring] SET AUTO_CREATE_STATISTICS ON 
GO

ALTER DATABASE [SQL_Monitoring] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [SQL_Monitoring] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [SQL_Monitoring] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [SQL_Monitoring] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [SQL_Monitoring] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [SQL_Monitoring] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [SQL_Monitoring] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [SQL_Monitoring] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [SQL_Monitoring] SET  DISABLE_BROKER 
GO

ALTER DATABASE [SQL_Monitoring] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [SQL_Monitoring] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [SQL_Monitoring] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [SQL_Monitoring] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [SQL_Monitoring] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [SQL_Monitoring] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [SQL_Monitoring] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [SQL_Monitoring] SET  READ_WRITE 
GO

ALTER DATABASE [SQL_Monitoring] SET RECOVERY SIMPLE 
GO

ALTER DATABASE [SQL_Monitoring] SET  MULTI_USER 
GO

ALTER DATABASE [SQL_Monitoring] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [SQL_Monitoring] SET DB_CHAINING OFF 
GO

--Create The Table

USE [SQL_Monitoring]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[SP_Who_Results](
	[SPID] [nchar](10) NULL,
	[ecid] [nchar](10) NULL,
	[status] [varchar](200) NULL,
	[loginame] [varchar](50) NULL,
	[hostname] [varchar](100) NULL,
	[blk] [nchar](10) NULL,
	[dbname] [varchar](max) NULL,
	[cmd] [varchar](max) NULL,
	[request_id] [nchar](10) NULL
) ON [PRIMARY]

GO

--Create the job

USE [msdb]
GO

BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0

IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'Data Collector' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'Data Collector'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N' Report Whats Running Now', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Collects process data for:
What is Currently Running in SQL Server
Processes using a lot of CPU from SQL Server
Top 10 Questionable SQL Server Processes
SQL Server Resource Hogs', 
		@category_name=N'Data Collector', 
		@owner_login_name=N'sa', 
		@notify_email_operator_name=N'<Add Your Operator Name Here>', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
 
 EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Run the Report', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'SET nocount ON

DECLARE @Subject VARCHAR (100)
SET @Subject=''SQL Server Whats Causing the High CPU & Performance Issues on '' + @@ServerName

--clean up sp_who
Truncate table [SP_Who_Results]

--run SP_Who
Insert into [SP_Who_Results]
execute sp_who

--Reports

DECLARE @tableHTML NVARCHAR(MAX) ;
SET @tableHTML =
N''<strong><font color="red">What is Currently Running in SQL Server</font></strong> <br>
<table border="1">'' +
N''<tr>'' +
N''<th>Program Name</th>'' +
N''<th>Running Processes</th>'' +
N''</tr>'' +
CAST ( (SELECT td=program_name,''''
,td= count(*),''''
FROM Master..sysprocesses
WHERE ecid=0 and program_name <> '' ''
GROUP BY program_name
ORDER BY count(*) desc
FOR XML PATH(''tr''), TYPE
) AS NVARCHAR(MAX) ) +
N''</table>
<br><br>
<strong><font color="red">Processes using a lot of CPU from SQL Server</font></strong> <br>''

DECLARE @tableHTML4 NVARCHAR(MAX) ;
SET @tableHTML4 =
N''<table border="1">'' +
N''<tr>'' +
N''<th>SPID</th>'' +
N''<th>Program Name</th>'' +
N''<th>Connected Seconds</th>'' +
N''</tr>'' +
CAST ((SELECT  td=spid,''''
,td=program_name ,''''
,td=datediff(second,login_time, getdate()),''''
FROM master..sysprocesses WHERE spid > 50 and PROGRAM_NAME not in (''Microsoft SQL Server Management Studio '')
FOR XML PATH(''tr''), TYPE
) AS NVARCHAR(MAX) ) +
N''</table> 
<br><br>
<strong><font color="red">Top 10 Questionable SQL Server Processes</font></strong> <br>''

DECLARE @tableHTML5 NVARCHAR(MAX) ;
SET @tableHTML5 =
N''<table border="1">'' +
N''<tr>'' +
N''<th>SPID</th>'' +
N''<th>Blocked</th>'' +
N''<th>DB Name</th>'' +
N''<th>CPU</th>'' +
N''<th>Seconds</th>'' +
N''<th>Host Name</th>'' +
N''<th>Program</th>'' +
N''<th>Login Name</th>'' +
N''</tr>'' +
CAST ((SELECT  top 10 td=spid,''''
,td=blocked,''''
,td=convert(varchar(50),db_name(dbid)),''''
,td=cpu,''''
,td=datediff(second,login_time, getdate()),''''
,td=convert(varchar(16), hostname),''''
,td=convert(varchar(50), program_name),''''
,td=convert(varchar(20), loginame),''''
FROM master..sysprocesses 
WHERE datediff(second,login_time, getdate()) > 0 and spid > 50 and cpu >=1024
ORDER BY 6 desc
FOR XML PATH(''tr''), TYPE
) AS NVARCHAR(MAX) ) +
N''</table> 

<br><br>
<strong><font color="red">SQL Server Resource Hogs</font></strong> <br>''

DECLARE @tableHTML6 NVARCHAR(MAX) ;
SET @tableHTML6 =
N''<table border="1">'' +
N''<tr>'' +
N''<th>Program</th>'' +
N''<th>Client Count</th>'' +
N''<th>CPU Sum</th>'' +
N''<th>Seconds Sum</th>'' +
N''</tr>'' +
CAST ((SELECT td=convert(varchar(50), program_name),''''
,td=count(*),''''
,td=sum(cpu),''''
,td=sum(datediff(second, login_time, getdate())),''''
FROM master..sysprocesses 
WHERE spid > 50
GROUP BY convert(varchar(50), program_name)
ORDER BY 7 DESC 
FOR XML PATH(''tr''), TYPE
) AS NVARCHAR(MAX) ) +
N''</table>

<br><br>
<strong><font color="red">Who is connected</font></strong> <br>''

DECLARE @tableHTML7 NVARCHAR(MAX) ;
SET @tableHTML7 =
N''<table border="1">'' +
N''<tr>'' +
N''<th>SPID</th>'' +
N''<th>Status</th>'' +
N''<th>Login Name</th>'' +
N''<th>Hostname</th>'' +
N''<th>DB Name</th>'' +
N''<th>Cmd</th>'' +
N''</tr>'' +
CAST ( (SELECT td=[spid],''''
,td= [status],''''
,td=[loginame],''''
,td=[hostname],''''
,td=[dbname],''''
,td=[cmd],''''
FROM [SP_Who_Results]
where dbname not IN (''master'', ''msdb'')  
ORDER BY 4,5 desc
FOR XML PATH(''tr''), TYPE
) AS NVARCHAR(MAX) ) +
N''</table>''

declare @body2 varchar(max)
set @body2 = @tableHTML + '' '' + @tableHTML4  + '' '' + @tableHTML5  + '' '' + @tableHTML6 + '' '' +@tableHTML7

EXEC msdb.dbo.sp_send_dbmail
@profile_name = ''<Add Mail Profile Here>'',
@recipients = ''<Add DBA Email Here>'',
@subject = @Subject,
@body = @body2,
@body_format = ''HTML'' ;



', 
		@database_name=N'master', 
		@output_file_name=N'<Add Path Here\WhatsRunningErrors.txt', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO



/*************************************************************************/
/*Script Minuto****************************/
SET nocount ON

DECLARE @Subject VARCHAR (100)
SET @Subject='SQL Server Whats Causing the High CPU & Performance Issues on ' + @@ServerName

--clean up sp_who
Truncate table [SP_Who_Results]

--run SP_Who
Insert into [SP_Who_Results]
execute sp_who

--Reports

DECLARE @tableHTML NVARCHAR(MAX) ;
SET @tableHTML =
N'<strong><font color="red">What is Currently Running in SQL Server</font></strong> <br>
<table border="1">' +
N'<tr>' +
N'<th>Program Name</th>' +
N'<th>Running Processes</th>' +
N'<th>Total Cpu</th>' +
N'<th>Hs Connected</th>' +
N'</tr>' +
CAST ( (SELECT td=program_name,''
,td= count(*),'',td=SUM(cpu),'',td=max(datediff(mm,login_time,GETDATE())),''
FROM Master..sysprocesses
WHERE ecid=0 and program_name <> ' '
GROUP BY program_name
ORDER BY count(*) desc
FOR XML PATH('tr'), TYPE
) AS NVARCHAR(MAX) ) +
N'</table>
<br><br>
<strong><font color="red">TOP 10 Processes using a lot of CPU from SQL Server</font></strong> <br>'

DECLARE @tableHTML4 NVARCHAR(MAX) ;
SET @tableHTML4 =
N'<table border="1">' +
N'<tr>' +
N'<th>SPID</th>' +
N'<th>Loginame</th>' +
N'<th>Program Name</th>' +
N'<th>CPU</th>' +
N'<th>Cmd</th>' +
N'<th>Status</th>' +
N'<th>Connected Seconds</th>' +
N'</tr>' +
CAST ((SELECT   top 10 td=spid,'',td=loginame,''
,td=program_name ,'',td= sum(cpu) ,'',td=cmd,'',td=status,''
,td=max(datediff(second,login_time, getdate())),''
FROM master..sysprocesses a
WHERE a.spid > 50 and 
(a.cmd not like 'awaiting%' or blocked > 0 or exists (Select 1 from master..sysprocesses b where a.spid = b.blocked and a.spid <> b.spid)) 
group by spid,loginame,program_name,cmd,status
order by sum(cpu) desc
FOR XML PATH('tr'), TYPE
) AS NVARCHAR(MAX) ) +
N'</table> 
<br><br>
<strong><font color="red">Top 10 Questionable SQL Server Processes</font></strong> <br>'

if @tableHTML4 is null
SET @tableHTML4 = 'No Active Processes '+
N'</table> 
<br><br>
<strong><font color="red">Top 10 Questionable SQL Server Processes</font></strong> <br>'


DECLARE @tableHTML5 NVARCHAR(MAX) ;
SET @tableHTML5 =
N'<table border="1">' +
N'<tr>' +
N'<th>SPID</th>' +
N'<th>Blocked</th>' +
N'<th>DB Name</th>' +
N'<th>CPU</th>' +
N'<th>Seconds</th>' +
N'<th>Host Name</th>' +
N'<th>Program</th>' +
N'<th>Login Name</th>' +
N'</tr>' +
CAST ((SELECT  top 10 td=spid,''
,td=blocked,''
,td=convert(varchar(50),db_name(dbid)),''
,td=cpu,''
,td=datediff(second,login_time, getdate()),''
,td=convert(varchar(16), hostname),''
,td=convert(varchar(50), program_name),''
,td=convert(varchar(20), loginame),''
FROM master..sysprocesses 
WHERE datediff(second,login_time, getdate()) > 0 and spid > 50 and cpu >=1024
ORDER BY cpu desc
FOR XML PATH('tr'), TYPE
) AS NVARCHAR(MAX) ) +
N'</table> 

<br><br>
<strong><font color="red">SQL Server Resource Hogs</font></strong> <br>'

DECLARE @tableHTML6 NVARCHAR(MAX) ;
SET @tableHTML6 =
N'<table border="1">' +
N'<tr>' +
N'<th>Program</th>' +
N'<th>Client Count</th>' +
N'<th>CPU Sum</th>' +
N'<th>Seconds Sum</th>' +
N'</tr>' +
CAST ((SELECT td=convert(varchar(50), program_name),''
,td=count(*),''
,td=sum(cpu),''
,td=sum(datediff(second, login_time, getdate())),''
FROM master..sysprocesses 
WHERE spid > 50
GROUP BY convert(varchar(50), program_name)
ORDER BY 7 DESC 
FOR XML PATH('tr'), TYPE
) AS NVARCHAR(MAX) ) +
N'</table>

<br><br>
<strong><font color="red">Who is connected</font></strong> <br>'

DECLARE @tableHTML7 NVARCHAR(MAX) ;
SET @tableHTML7 =
N'<table border="1">' +
N'<tr>' +
N'<th>SPID</th>' +
N'<th>Status</th>' +
N'<th>Login Name</th>' +
N'<th>Hostname</th>' +
N'<th>DB Name</th>' +
N'<th>Cmd</th>' +
N'</tr>' +
CAST ( (SELECT td=[spid],''
,td= [status],''
,td=[loginame],''
,td=[hostname],''
,td=[dbname],''
,td=[cmd],''
FROM [SP_Who_Results]
where dbname not IN ('master', 'msdb')  
ORDER BY 4,5 desc
FOR XML PATH('tr'), TYPE
) AS NVARCHAR(MAX) ) +
N'</table>'

declare @body2 varchar(max)
set @body2 = @tableHTML + ' ' + @tableHTML4  + ' ' + @tableHTML5  + ' ' + @tableHTML6 + ' ' +@tableHTML7

EXEC msdb.dbo.sp_send_dbmail
@profile_name = 'SMTP - MTO-BD02',
@recipients = 'dba@minutoseguros.com.br',
@subject = @Subject,
@body = @body2,
@body_format = 'HTML' ;


