USE [master]
GO
/****** Object:  Database [DbaDb]    Script Date: 02/11/2012 12:28:46 ******/
CREATE DATABASE [DbaDb] ON  PRIMARY 
( NAME = N'DbaDbDev1', FILENAME = N'd:\DBA\SQLFiles\DBA_ODS1.mdf' , SIZE = 409600KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10%), 
( NAME = N'DbaDbDev2', FILENAME = N'e:\DBA\SQLFiles\DBA_ODS2.ndf' , SIZE = 409600KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10%)
 LOG ON 
( NAME = N'DbaDbLog1', FILENAME = N'f:\DBA\SQLFiles\DBA_ODS1.ldf' , SIZE = 1410112KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [DbaDb] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DbaDb].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [DbaDb] SET ANSI_NULL_DEFAULT OFF
GO
ALTER DATABASE [DbaDb] SET ANSI_NULLS OFF
GO
ALTER DATABASE [DbaDb] SET ANSI_PADDING OFF
GO
ALTER DATABASE [DbaDb] SET ANSI_WARNINGS OFF
GO
ALTER DATABASE [DbaDb] SET ARITHABORT OFF
GO
ALTER DATABASE [DbaDb] SET AUTO_CLOSE OFF
GO
ALTER DATABASE [DbaDb] SET AUTO_CREATE_STATISTICS ON
GO
ALTER DATABASE [DbaDb] SET AUTO_SHRINK OFF
GO
ALTER DATABASE [DbaDb] SET AUTO_UPDATE_STATISTICS ON
GO
ALTER DATABASE [DbaDb] SET CURSOR_CLOSE_ON_COMMIT OFF
GO
ALTER DATABASE [DbaDb] SET CURSOR_DEFAULT  GLOBAL
GO
ALTER DATABASE [DbaDb] SET CONCAT_NULL_YIELDS_NULL OFF
GO
ALTER DATABASE [DbaDb] SET NUMERIC_ROUNDABORT OFF
GO
ALTER DATABASE [DbaDb] SET QUOTED_IDENTIFIER OFF
GO
ALTER DATABASE [DbaDb] SET RECURSIVE_TRIGGERS OFF
GO
ALTER DATABASE [DbaDb] SET  ENABLE_BROKER
GO
ALTER DATABASE [DbaDb] SET AUTO_UPDATE_STATISTICS_ASYNC ON
GO
ALTER DATABASE [DbaDb] SET DATE_CORRELATION_OPTIMIZATION OFF
GO
ALTER DATABASE [DbaDb] SET TRUSTWORTHY OFF
GO
ALTER DATABASE [DbaDb] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO
ALTER DATABASE [DbaDb] SET PARAMETERIZATION SIMPLE
GO
ALTER DATABASE [DbaDb] SET READ_COMMITTED_SNAPSHOT OFF
GO
ALTER DATABASE [DbaDb] SET HONOR_BROKER_PRIORITY OFF
GO
ALTER DATABASE [DbaDb] SET  READ_WRITE
GO
ALTER DATABASE [DbaDb] SET RECOVERY SIMPLE
GO
ALTER DATABASE [DbaDb] SET  MULTI_USER
GO
ALTER DATABASE [DbaDb] SET PAGE_VERIFY CHECKSUM
GO
ALTER DATABASE [DbaDb] SET DB_CHAINING OFF
GO
EXEC sys.sp_db_vardecimal_storage_format N'DbaDb', N'ON'
GO
USE [DbaDb]
GO
/****** Object:  User [PSAFE\Servico_SQL]    Script Date: 02/11/2012 12:28:46 ******/
CREATE USER [PSAFE\Servico_SQL] FOR LOGIN [PSAFE\Servico_SQL] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [PSAFE\IIS_PROD]    Script Date: 02/11/2012 12:28:46 ******/
CREATE USER [PSAFE\IIS_PROD] FOR LOGIN [PSAFE\IIS_PROD] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  Role [ODSDbRole]    Script Date: 02/11/2012 12:28:46 ******/
CREATE ROLE [ODSDbRole] AUTHORIZATION [dbo]
GO
/****** Object:  UserDefinedDataType [dbo].[tdSecret]    Script Date: 02/11/2012 12:28:46 ******/
CREATE TYPE [dbo].[tdSecret] FROM [varchar](100) NULL
GO
/****** Object:  UserDefinedDataType [dbo].[tdObs]    Script Date: 02/11/2012 12:28:46 ******/
CREATE TYPE [dbo].[tdObs] FROM [varchar](8000) NOT NULL
GO
/****** Object:  UserDefinedDataType [dbo].[tdHwGuId]    Script Date: 02/11/2012 12:28:46 ******/
CREATE TYPE [dbo].[tdHwGuId] FROM [varchar](36) NULL
GO
/****** Object:  UserDefinedDataType [dbo].[tdEmail]    Script Date: 02/11/2012 12:28:46 ******/
CREATE TYPE [dbo].[tdEmail] FROM [varchar](256) NULL
GO
/****** Object:  Table [dbo].[teste]    Script Date: 02/11/2012 12:28:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[teste](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[data] [smalldatetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedDataType [dbo].[tdSmallDesc]    Script Date: 02/11/2012 12:28:49 ******/
CREATE TYPE [dbo].[tdSmallDesc] FROM [varchar](100) NULL
GO
/****** Object:  UserDefinedDataType [dbo].[tdDesc]    Script Date: 02/11/2012 12:28:49 ******/
CREATE TYPE [dbo].[tdDesc] FROM [varchar](1000) NULL
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dba_nomeProc]    Script Date: 02/11/2012 12:28:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_dba_nomeProc] (@lastQuery varchar(max))
RETURNS varchar(50)
WITH EXECUTE AS CALLER
AS
BEGIN
     DECLARE @nomeProc varchar(50) 

select @lastQuery = (replace(@lastQuery,'create proc [dbo].',''))
select @lastQuery = (replace(@lastQuery,'create procedure [sys].',''))
select @lastQuery = (replace(@lastQuery,'create procedure sys.',''))
select @lastQuery = (replace(@lastQuery,' [',''))
select @lastQuery = (replace(@lastQuery,'--',''))
select @lastQuery = (replace(@lastQuery,char(10),''))
select @lastQuery = (replace(@lastQuery,char(13),''))
select @nomeProc = SUBSTRING (@lastQuery,1,CHArindex(']',@lastQuery,1))

     RETURN(@nomeProc)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_SnapshotEmail]    Script Date: 02/11/2012 12:29:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_dba_SnapshotEmail]
as
begin


EXEC master..xp_cmdshell 'bcp "exec dbadb.dbo.sp_dba_compare_IoSnapshot" queryout "b:\io_snapshot.csv" -SPSDB001\DBPRODODS001 -T -URodrigo -c -t;'
EXEC master..xp_cmdshell 'bcp "exec dbadb.dbo.sp_dba_compare_ProcSnapshot" queryout "b:\proc_snapshot.csv" -SPSDB001\DBPRODODS001 -T -URodrigo -c -t;'
EXEC master..xp_cmdshell 'bcp "exec dbadb.dbo.sp_dba_compare_RowCountSnapshot" queryout "b:\rowcount_snapshot.csv" -SPSDB001\DBPRODODS001 -T -URodrigo -c -t;'
EXEC master..xp_cmdshell 'bcp "exec dbadb.dbo.sp_dba_compare_SpaceSnapshot" queryout "b:\space_snapshot.csv" -SPSDB001\DBPRODODS001 -T -URodrigo -c -t;'
EXEC master..xp_cmdshell 'bcp "exec dbadb.dbo.sp_dba_SnapshotReport" queryout "b:\Report.csv" -SPSDB001\DBPRODODS001 -T -URodrigo -c -t;'
EXEC master..xp_cmdshell 'bcp "exec msdb..sp_dba_get_composite_job_infoProblem" queryout "b:\Job.csv" -SPSDB001\DBPRODODS001 -T -URodrigo -c -t;'
EXEC master..xp_cmdshell 'bcp "exec dbadb.dbo.sp_dba_compare_ProcSnapshot_Alertas" queryout "b:\alerta.csv" -SPSDB001\DBPRODODS001 -T -URodrigo -c -t;'
EXEC master..xp_cmdshell 'bcp "exec dbadb.dbo.sp_dba_ranking_Alerta_Procs" queryout "b:\ranking.csv" -SPSDB001\DBPRODODS001 -T -URodrigo -c -t;'

declare @subj nchar(255), @msg varchar(max)
select @subj = @@servername+' Dba Alerts: '+CONVERT(char(20),getdate())
select @msg = 'All Alerts
[io]
Data Db File Last_Size_MB Diff_Size_MB Diff_Number_of_reads	Diff_Bytes_read	
Diff_Read_stall_time_ms	Diff_Number_of_writes	Diff_Bytes_written	
Diff_Write_stall_time_ms	Diff_Read_Write_stall_ms	Diff_time_hours' + char(10)+char(13)+'

[proc]
id	snapshotId	spid command	login_name	host_name	blk	percent_complete cpu_time
duration_secs	status	logical_reads	reads	writes	db	wait_time	last_Query'+char(10)+char(13)+'

[Rowcount]
db	tabela	datahora	Linhas_Antes	dataHora	Linhas_Depois	Diferenca'+char(10)+char(13)+'

[Space]
medida	datahora	TamanhoMB_Antes	dataHora	TamanhoMB_Depois	DiferencaMB'


exec msdb.dbo.sp_send_dbmail  @profile_name = 'bdNotifier',
@recipients = 'rodrigo@grupoxango.com',
@body = @msg,
@subject=  @subj,
@body_format= 'text',
@file_attachments = 
'b:\io_snapshot.csv;b:\proc_snapshot.csv;b:\rowcount_snapshot.csv;b:\space_snapshot.csv;b:\Report.csv;b:\Job.csv;b:\alerta.csv;b:\ranking.csv'
end
GO
/****** Object:  Table [dbo].[Snapshot]    Script Date: 02/11/2012 12:29:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Snapshot](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[dataHora] [smalldatetime] NOT NULL,
	[tipo] [dbo].[tdSmallDesc] NOT NULL,
	[origem] [dbo].[tdSmallDesc] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [snapshot_id01] ON [dbo].[Snapshot] 
(
	[dataHora] ASC
)
INCLUDE ( [id]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [snapshot_id02] ON [dbo].[Snapshot] 
(
	[tipo] ASC
)
INCLUDE ( [id],
[dataHora]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RowCountSnapshot]    Script Date: 02/11/2012 12:29:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RowCountSnapshot](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[snapshotId] [int] NOT NULL,
	[db] [sysname] NOT NULL,
	[tabela] [sysname] NOT NULL,
	[linhas] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RowCountSnapshot_ID01] ON [dbo].[RowCountSnapshot] 
(
	[snapshotId] ASC
)
INCLUDE ( [id]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RowCountSnapshot_ID02] ON [dbo].[RowCountSnapshot] 
(
	[tabela] ASC,
	[db] ASC
)
INCLUDE ( [id]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProcSnapshot]    Script Date: 02/11/2012 12:29:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProcSnapshot](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[snapshotId] [int] NOT NULL,
	[spid] [int] NULL,
	[command] [dbo].[tdDesc] NULL,
	[login_name] [dbo].[tdDesc] NULL,
	[host_name] [dbo].[tdDesc] NULL,
	[blk] [int] NULL,
	[percent_complete] [numeric](5, 2) NULL,
	[cpu_time] [bigint] NULL,
	[duration_secs] [int] NULL,
	[status] [dbo].[tdDesc] NULL,
	[logical_reads] [bigint] NULL,
	[reads] [bigint] NULL,
	[writes] [bigint] NULL,
	[db] [dbo].[tdDesc] NULL,
	[wait_time] [int] NULL,
	[last_Query] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProcSnapshot_ID01] ON [dbo].[ProcSnapshot] 
(
	[snapshotId] ASC
)
INCLUDE ( [id]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ProcSnapshot_ID02] ON [dbo].[ProcSnapshot] 
(
	[spid] ASC
)
INCLUDE ( [id]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IoSnapshot]    Script Date: 02/11/2012 12:29:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IoSnapshot](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[snapshotId] [int] NOT NULL,
	[db_id] [smallint] NOT NULL,
	[file_id] [smallint] NOT NULL,
	[database_name] [sysname] NOT NULL,
	[physical_file_name] [sysname] NOT NULL,
	[Diff_Number_of_reads] [bigint] NULL,
	[Diff_Bytes_Read] [bigint] NULL,
	[Diff_Read_stall_time_ms] [bigint] NULL,
	[Diff_Number_of_writes] [bigint] NULL,
	[Diff_Bytes_written] [bigint] NULL,
	[Diff_Write_stall_time_ms] [bigint] NULL,
	[Diff_Read_Write_stall_ms] [bigint] NULL,
	[size_on_disk_MB] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IoSnapshot_ID01] ON [dbo].[IoSnapshot] 
(
	[snapshotId] ASC
)
INCLUDE ( [id]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IoSnapshot_ID02] ON [dbo].[IoSnapshot] 
(
	[db_id] ASC,
	[file_id] ASC
)
INCLUDE ( [id]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_lista_snapshots]    Script Date: 02/11/2012 12:29:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_dba_lista_snapshots]
@dtIni smalldatetime = null, @dtFim smalldatetime = null
as
begin
if @dtIni is null
select @dtIni = DATEADD(hh,-12,getdate()), @dtFim = GETDATE()

select top 20 * from [snapshot] (nolock)
where dataHora between @dtIni and @dtFim
order by dataHora desc
end
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_lista_Alertas]    Script Date: 02/11/2012 12:29:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_dba_lista_Alertas]
@dtIni smalldatetime = null, @dtFim smalldatetime = null
as
begin
if @dtIni is not null
select top 30 * from [snapshot] (nolock)
where dataHora between @dtIni and @dtFim and origem = 'ALERTA'
order by dataHora desc
else
select top 30 * from [snapshot] (nolock)
where origem = 'ALERTA'
order by dataHora desc
end
GO
/****** Object:  Table [dbo].[SpaceSnapshot]    Script Date: 02/11/2012 12:29:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SpaceSnapshot](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[snapshotId] [int] NOT NULL,
	[medida] [dbo].[tdDesc] NOT NULL,
	[tamanhoMB] [numeric](10, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SpaceSnapshot_ID01] ON [dbo].[SpaceSnapshot] 
(
	[snapshotId] ASC
)
INCLUDE ( [id]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_SnapshotReport]    Script Date: 02/11/2012 12:29:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_dba_SnapshotReport]
as
begin
set nocount on

select 'Last 12 hs',origem as Origem, COUNT(*)/4 as Qtd from [Snapshot] where dataHora >= DATEADD(dd,-12,getdate()) group by origem
select 'Last 24 hs',origem as Origem, COUNT(*)/4 as Qtd from [Snapshot] where dataHora >= DATEADD(dd,-24,getdate()) group by origem
select 'Last 48 hs',origem as Origem, COUNT(*)/4 as Qtd from [Snapshot] where dataHora >= DATEADD(dd,-48,getdate()) group by origem

end
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_ranking_Alerta_Procs]    Script Date: 02/11/2012 12:29:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_dba_ranking_Alerta_Procs]
as
set nocount on

select dbo.fn_dba_nomeProc (last_query) , COUNT(*)
FROM procsnapshot A (nolock) 
join [snapshot] s on a.snapshotId = s.id and s.origem = 'Alerta'
group by dbo.fn_dba_nomeProc (last_query)
order by 2 desc
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_DeleteDbaDb]    Script Date: 02/11/2012 12:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_dba_DeleteDbaDb]
as
begin
set nocount on
set rowcount 1000

delete ProcSnapshot from ProcSnapshot p join Snapshot s on p.snapshotId = s.id where dataHora <= DATEADD(dd,-5,getdate())
while @@ROWCOUNT > 0
delete ProcSnapshot from ProcSnapshot p join Snapshot s on p.snapshotId = s.id where dataHora <= DATEADD(dd,-5,getdate())


delete IoSnapshot from IoSnapshot p join Snapshot s on p.snapshotId = s.id where dataHora <= DATEADD(dd,-5,getdate())
while @@ROWCOUNT > 0
delete IoSnapshot from IoSnapshot p join Snapshot s on p.snapshotId = s.id where dataHora <= DATEADD(dd,-5,getdate())


delete RowCountSnapshot from RowCountSnapshot p join Snapshot s on p.snapshotId = s.id where dataHora <= DATEADD(dd,-5,getdate())
while @@ROWCOUNT > 0
delete RowCountSnapshot from RowCountSnapshot p join Snapshot s on p.snapshotId = s.id where dataHora <= DATEADD(dd,-5,getdate())

delete SpaceSnapshot  from SpaceSnapshot p join Snapshot s on p.snapshotId = s.id where dataHora <= DATEADD(dd,-5,getdate())
while @@ROWCOUNT > 0
delete SpaceSnapshot  from SpaceSnapshot p join Snapshot s on p.snapshotId = s.id where dataHora <= DATEADD(dd,-5,getdate())

set rowcount 0

delete Snapshot where dataHora <= DATEADD(dd,-5,getdate()) 

end
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_compare_SpaceSnapshot]    Script Date: 02/11/2012 12:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_dba_compare_SpaceSnapshot] 
      (@start_snap_ID INT = NULL,
       @end_snap_ID INT = NULL)
AS
DECLARE @end_snp INT
DECLARE @start_snp INT
BEGIN

   SET NOCOUNT ON
   
   IF (@end_snap_ID IS NULL) 
      SELECT @end_snp = MAX(id) FROM [snapshot] s where tipo = 'SPACE' and exists (select 1 from SpaceSnapshot rc where rc.snapshotId = s.id)
      ELSE SET @end_snp = @end_snap_ID

   IF (@start_snap_ID IS NULL) 
      SELECT @start_snp = Min(id) FROM [snapshot] s where tipo = 'SPACE' and id < @end_snp and dataHora >= DATEADD(hh,-12,getdate())
      and exists (select 1 from SpaceSnapshot rc where rc.snapshotId = s.id)
      ELSE SET @start_snp = @start_snap_ID

   
   SELECT 
      a.medida,s.datahora, a.tamanhoMB as TamanhoMB_Antes,s1.dataHora, b.tamanhoMB as TamanhoMB_Depois,
      a.tamanhoMB - b.tamanhoMB as DiferencaMB
   FROM 
       [snapshot] S   
  join  SpaceSnapshot A on S.id = A.snapshotId   
  join  SpaceSnapshot B on  A.medida = B.medida 
  join  [snapshot] S1 on  S1.id = B.snapshotId
  
   WHERE 
       S.id = @end_snp AND 
       B.snapshotId = @start_snp AND 
       S1.id = @start_snp 
       
   ORDER BY 
       s.dataHora,a.medida,
       s1.dataHora,b.medida

  SET NOCOUNT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_compare_RowCountSnapshotAll]    Script Date: 02/11/2012 12:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROC [dbo].[sp_dba_compare_RowCountSnapshotAll] 
      (@start_snap_ID INT = NULL,
       @end_snap_ID INT = NULL)
AS
DECLARE @end_snp INT
DECLARE @start_snp INT
BEGIN

   SET NOCOUNT ON
   
   IF (@end_snap_ID IS NULL) 
      SELECT @end_snp = MAX(id) FROM [snapshot] where tipo = 'ROWCOUNT'
      ELSE SET @end_snp = @end_snap_ID

   IF (@start_snap_ID IS NULL) 
      SELECT @start_snp = Min(id) FROM [snapshot] where tipo = 'ROWCOUNT' and id < @end_snp and dataHora >= DATEADD(hh,-12,getdate())
      ELSE SET @start_snp = @start_snap_ID

  
   SELECT 
      a.db,a.tabela,s.datahora, a.linhas as Linhas_Antes,s1.dataHora, b.linhas as Linhas_Depois, b.linhas - a.linhas as Diferenca
   FROM 
       [snapshot] S   
  join  RowCountSnapshot A on S.id = A.snapshotId   
  join  RowCountSnapshot B on  A.db = B.db AND  A.tabela = B.tabela 
  join  [snapshot] S1 on  S1.id = B.snapshotId
  
   WHERE 
       S.id = @end_snp AND 
       B.snapshotId = @start_snp AND 
       S1.id = @start_snp 
   ORDER BY  b.linhas - a.linhas desc ,b.linhas desc
   
--old   
--          a.datahora = @startDate and b.datahora = @endDate 
--and a.id = (Select MAX(id) from rowCount_snapshot c where a.tabela = c.tabela and a.db = c.db and c.dataHora = @startDate)
--and b.id = (Select MAX(id) from rowCount_snapshot d where b.tabela = d.tabela and b.db = d.db and d.dataHora = @endDate)

  SET NOCOUNT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_compare_RowCountSnapshot]    Script Date: 02/11/2012 12:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_dba_compare_RowCountSnapshot] 
      (@start_snap_ID INT = NULL,
       @end_snap_ID INT = NULL)
AS
DECLARE @end_snp INT
DECLARE @start_snp INT
BEGIN

   SET NOCOUNT ON
   
   IF (@end_snap_ID IS NULL) 
      SELECT @end_snp = MAX(id) FROM [snapshot] s where tipo = 'ROWCOUNT' and exists (select 1 from RowCountSnapshot rc where rc.snapshotId = s.id)
      ELSE SET @end_snp = @end_snap_ID

   IF (@start_snap_ID IS NULL) 
      SELECT @start_snp = Min(id) FROM [snapshot] s where tipo = 'ROWCOUNT' and id < @end_snp and dataHora >= DATEADD(hh,-12,getdate()) and exists (select 1 from RowCountSnapshot rc where rc.snapshotId = s.id)
      ELSE SET @start_snp = @start_snap_ID

--select @start_snp ,@end_snp
  
   SELECT top 20
      a.db,s1.dataHora, b.linhas as Linhas_Antes,a.tabela,s.datahora, a.linhas as Linhas_Depois, a.linhas - b.linhas as Diferenca
   FROM 
       [snapshot] S   
  join  RowCountSnapshot A on S.id = A.snapshotId   
  join  RowCountSnapshot B on  A.db = B.db AND  A.tabela = B.tabela 
  join  [snapshot] S1 on  S1.id = B.snapshotId
  
   WHERE a.db not like '%temp%' and a.db not like '%hist%' and 
       S.id = @end_snp AND 
       B.snapshotId = @start_snp AND 
       S1.id = @start_snp 
   ORDER BY  --a.linhas desc,
   a.linhas - b.linhas desc ,b.linhas desc
   
--old   
--          a.datahora = @startDate and b.datahora = @endDate 
--and a.id = (Select MAX(id) from rowCount_snapshot c where a.tabela = c.tabela and a.db = c.db and c.dataHora = @startDate)
--and b.id = (Select MAX(id) from rowCount_snapshot d where b.tabela = d.tabela and b.db = d.db and d.dataHora = @endDate)

  SET NOCOUNT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_compare_ProcSnapshot_Data]    Script Date: 02/11/2012 12:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROC [dbo].[sp_dba_compare_ProcSnapshot_Data] 
      (@DtIni smalldatetime = null,
       @DtFim smalldatetime = NULL)
AS
DECLARE @end_snp INT
DECLARE @start_snp INT
BEGIN

   SET NOCOUNT ON
   
   IF (@DtIni IS NULL) select @DtIni = GETDATE()
   IF (@DtFim IS NULL) select @DtFim = dateadd(hh,-3,GETDATE())
   
      SELECT @end_snp = MAX(id) FROM [snapshot] where tipo = 'PROC' and dataHora <= @DtFim
     
      SELECT @start_snp = Min(id) FROM [snapshot] where tipo = 'PROC' and dataHora >= @DtIni
      
      
      
   SELECT spid,command,login_name,host_name,blk,percent_complete,cpu_time,duration_secs,status,logical_reads,reads,writes,
db,wait_time, last_Query 
FROM procsnapshot A (nolock) WHERE a.snapshotId >= @start_snp and a.snapshotId < @end_snp 
   
  SET NOCOUNT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_compare_ProcSnapshot_Alertas]    Script Date: 02/11/2012 12:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_dba_compare_ProcSnapshot_Alertas] 
 AS
DECLARE @end_snp INT
DECLARE @start_snp INT
BEGIN

   SET NOCOUNT ON
   
      
   SELECT top 20 'ALERTA = ',s.dataHora,spid,command,login_name,blk,percent_complete,cpu_time,duration_secs,status,logical_reads,reads,writes,
db,wait_time,dbo.fn_dba_nomeProc (last_query) as last_Query,host_name
FROM procsnapshot A (nolock) 
join [snapshot] s on a.snapshotId = s.id and s.origem = 'Alerta'
WHERE  last_Query like '%create %'
  



order by 2 desc,3

  SET NOCOUNT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_compare_ProcSnapshot]    Script Date: 02/11/2012 12:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_dba_compare_ProcSnapshot] 
      (@start_snap_ID INT = NULL,
       @end_snap_ID INT = NULL)
AS
DECLARE @end_snp INT
DECLARE @start_snp INT
BEGIN

   SET NOCOUNT ON
   
   IF (@end_snap_ID IS NULL) 
      SELECT @end_snp = MAX(id) FROM [snapshot] s where tipo = 'PROC' and exists (select 1 from procSnapshot rc where rc.snapshotId = s.id)
      ELSE SET @end_snp = @end_snap_ID

   IF (@start_snap_ID IS NULL) 
      SELECT @start_snp = Min(id) FROM [snapshot] s where tipo = 'PROC' and id < @end_snp and dataHora >= DATEADD(hh,-12,getdate())
      and exists (select 1 from procSnapshot rc where rc.snapshotId = s.id)
      ELSE SET @start_snp = @start_snap_ID
      
      
   SELECT 'START = ',spid,command,login_name,blk,percent_complete,cpu_time,duration_secs,status,logical_reads,reads,writes,
db,wait_time,dbo.fn_dba_nomeProc (last_query) as last_Query,host_name
FROM procsnapshot A (nolock) WHERE a.snapshotId = @start_snp and last_Query like '%create %'
   union
   SELECT 'END = ',spid,command,login_name,blk,percent_complete,cpu_time,duration_secs,status,logical_reads,reads,writes,
db,wait_time, dbo.fn_dba_nomeProc (last_query) as last_Query,host_name
FROM procsnapshot A (nolock) WHERE a.snapshotId = @end_snp and last_Query like '%create %' 
union
   SELECT 'START = ',spid,command,login_name,blk,percent_complete,cpu_time,duration_secs,status,logical_reads,reads,writes,
db,wait_time, substring(last_query,CHArindex('begin',last_Query,1)  ,50) as last_Query,host_name
FROM procsnapshot A (nolock) WHERE a.snapshotId = @start_snp and last_Query not like '%create %'
   union
   SELECT 'END = ',spid,command,login_name,blk,percent_complete,cpu_time,duration_secs,status,logical_reads,reads,writes,
db,wait_time, substring(last_query,CHArindex('begin',last_Query,1)  ,50) as last_Query,host_name
FROM procsnapshot A (nolock) WHERE a.snapshotId = @end_snp and last_Query not like '%create %' 



order by 1 desc,2

  SET NOCOUNT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_compare_IoSnapshot]    Script Date: 02/11/2012 12:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_dba_compare_IoSnapshot] 
      (@start_snap_ID INT = NULL,
       @end_snap_ID INT = NULL)
AS
DECLARE @end_snp INT
DECLARE @start_snp INT
BEGIN

   SET NOCOUNT ON
   
   IF (@end_snap_ID IS NULL) 
      SELECT @end_snp = MAX(id) FROM [snapshot] s where tipo = 'IO' and exists (select 1 from ioSnapshot rc where rc.snapshotId = s.id)
      ELSE SET @end_snp = @end_snap_ID

   IF (@start_snap_ID IS NULL) 
      SELECT @start_snp = Min(id) FROM [snapshot] s where tipo = 'IO' and id < @end_snp and dataHora >= DATEADD(hh,-12,getdate())
      and exists (select 1 from ioSnapshot rc where rc.snapshotId = s.id)
      ELSE SET @start_snp = @start_snap_ID

   
   SELECT 
       CONVERT(VARCHAR(12),S.dataHora,101) AS snapshot_creation_date,
       A.database_name,
       A.physical_file_name,
       A.size_on_disk_MB as Last_Size_MB,
       A.size_on_disk_MB - B.size_on_disk_MB as Diff_Size_MB,
       A.Diff_Number_of_reads - B.Diff_Number_of_reads   AS Diff_Number_of_reads,
       A.Diff_Bytes_read - B.Diff_Bytes_read             AS Diff_Bytes_read,
       A.Diff_Read_stall_time_ms -  B.Diff_Read_stall_time_ms AS Diff_Read_stall_time_ms,
       A.Diff_Number_of_writes - B.Diff_Number_of_writes AS Diff_Number_of_writes,
       A.Diff_Bytes_written - B.Diff_Bytes_written       AS Diff_Bytes_written,
       A.Diff_Write_stall_time_ms - B.Diff_Write_stall_time_ms AS Diff_Write_stall_time_ms,
       A.Diff_Read_Write_stall_ms - B.Diff_Read_Write_stall_ms AS Diff_Read_Write_stall_ms ,
       DATEDIFF (hh,S1.dataHora, S.dataHora) AS Diff_time_hours     
   FROM 
       [snapshot] S   
  join  iosnapshot A on S.id = A.snapshotId   
  join  iosnapshot B on  A.[db_id] = B.[db_id] AND  A.[file_id] = B.[file_id] 
  join  [snapshot] S1 on  S1.id = B.snapshotId
  
   WHERE 
       S.id = @end_snp AND 
       B.snapshotId = @start_snp AND 
       S1.id = @start_snp 
       
   ORDER BY 
       A.database_name,
       A.physical_file_name       

  SET NOCOUNT OFF
END
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_carga_SpaceSnapshot]    Script Date: 02/11/2012 12:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_dba_carga_SpaceSnapshot]
@origem tdsmalldesc = 'NORMAL'
AS
BEGIN
   SET NOCOUNT ON
   declare @snapshotid int
   
   INSERT INTO [snapshot] SELECT GETDATE(), 'SPACE',@origem
   select @snapshotid = @@IDENTITY
   
declare @dataHora smalldatetime = getdate()

CREATE TABLE #TEMPSPACE
(DRIVE VARCHAR(20),
SPACE INT)

CREATE TABLE #TEMPDB
(name sysname,
db_size tdsmalldesc,
owner tdsmalldesc,
dbid smallint,
created datetime,
status tddesc,
compatibility_level smallint)


INSERT INTO #TEMPSPACE
EXEC XP_FIXEDDRIVES

INSERT INTO #TEMPDB
exec sp_helpdb

update #TEMPDB set db_size = REPLACE(db_size,' MB','')
update #TEMPDB set db_size = REPLACE(db_size,' ','')

insert spacesnapshot
select @snapshotid, 'Database '+name,db_size from #TEMPDB

insert spacesnapshot
select @snapshotid, 'Drive - Espaco Livre '+DRIVE,space from #TEMPSPACE

drop table #TEMPDB
drop table #TEMPSPACE
end --proc
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_carga_RowCountSnapshot]    Script Date: 02/11/2012 12:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_dba_carga_RowCountSnapshot]
@origem tdsmalldesc = 'NORMAL'
AS
BEGIN
   SET NOCOUNT ON
   declare @snapshotid int
   
   INSERT INTO [snapshot] SELECT GETDATE(), 'ROWCOUNT',@origem
   select @snapshotid = @@IDENTITY
   
declare @dataHora smalldatetime = getdate()

--OLD
--select object_name(object_id) as Name,sum(rows) as Rows
--from sys.partitions 
--where objectproperty(object_id, 'IsUserTable') = 1 and index_id < 2
--group by object_name(object_id)
--order by 1


DECLARE @query VARCHAR(4000) 
DECLARE @temp TABLE (DBName VARCHAR(200),TABLEName VARCHAR(300), COUNT INT) 
SET @query='SELECT  ''?'',sysobjects.Name, sysindexes.Rows FROM   ?..sysobjects INNER JOIN ?..sysindexes ON sysobjects.id = sysindexes.id WHERE  type = ''U''  AND sysindexes.IndId < 2 order by sysobjects.Name' 
INSERT @temp EXEC sp_msforeachdb @query 

insert RowCountSnapshot select @snapshotid,DBName,TABLEName,count FROM @temp WHERE DBName not in ('tempdb','msdb','master','msdb')
end --proc
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_carga_ProcSnapshot]    Script Date: 02/11/2012 12:29:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_dba_carga_ProcSnapshot]
@origem tdsmalldesc = 'NORMAL'
AS
BEGIN
   SET NOCOUNT ON
   declare @snapshotid int
   
   INSERT INTO [snapshot] SELECT GETDATE(), 'PROC',@origem
   select @snapshotid = @@IDENTITY


declare @dataHora smalldatetime = getdate()

insert ProcSnapshot (snapshotid,spid,command,login_name,host_name,blk,percent_complete,cpu_time,duration_secs,status,
logical_reads,reads,writes,db,wait_time,last_Query)
SELECT  @snapshotid, r.session_id,command,login_name,host_name,blocking_session_id,percent_complete,
r.cpu_time,r.total_elapsed_time/1000,r.status,r.logical_reads,r.reads,r.writes,
DB_NAME(database_id) AS [Database], r.wait_time ,[text] AS [LAST_Query]  
FROM sys.dm_exec_requests r  
CROSS APPLY sys.dm_exec_sql_text(r.plan_handle) st  
join sys.dm_exec_sessions p on r.session_id = p.session_id 
WHERE r.session_Id > 50   

union 
SELECT  @snapshotid, p.session_id,program_name,login_name,host_name,
blk=0,0,cpu_time,total_elapsed_time/1000,status,logical_reads,reads,writes,
null AS [Database], cpu_time ,null AS [LAST_Query]  
FROM sys.dm_exec_sessions p
WHERE 
exists (select 1 from sys.dm_exec_requests r2 where r2.blocking_session_id = p.session_id) 

end
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_carga_IoSnapshot]    Script Date: 02/11/2012 12:29:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROC [dbo].[sp_dba_carga_IoSnapshot]
@origem tdsmalldesc = 'NORMAL'
AS
BEGIN
   SET NOCOUNT ON
   declare @snapshotid int
   
   INSERT INTO [snapshot] SELECT GETDATE(), 'IO',@origem
   select @snapshotid = @@IDENTITY
  
  
   INSERT INTO IoSnapshot 
       (snapshotId,
       [db_id],
       [file_id],
       database_name ,
       physical_file_name,
       Diff_Number_of_reads,
       Diff_Bytes_Read,
       Diff_Read_stall_time_ms,
       Diff_Number_of_writes,
       Diff_Bytes_written,
       Diff_Write_stall_time_ms,
       Diff_Read_Write_stall_ms,
       size_on_disk_MB)
   SELECT
       @snapshotid,
       db_files.database_id,
       db_files.FILE_ID,
       DB_NAME(db_files.database_id) AS Database_Name,
       db_files.physical_name        AS File_actual_name,
       num_of_reads                  AS Number_of_reads,
       num_of_bytes_read             AS Bytes_Read,
       io_stall_read_ms              AS Read_time_stall_ms,
       num_of_writes                 AS Number_of_writes,
       num_of_bytes_written          AS Bytes_written,
       io_stall_write_ms             AS Write_time_stall_ms,
       io_stall                      AS Read_Write_stall_ms,
       size_on_disk_bytes / POWER(1024,2) AS size_on_disk_MB
   FROM 
       sys.dm_io_virtual_file_stats(NULL,NULL) dm_io_vf_stats ,
       sys.master_files db_files
   WHERE 
       db_files.database_id = dm_io_vf_stats.database_id
       AND db_files.[file_id] = dm_io_vf_stats.[file_id];

  SET NOCOUNT OFF

END
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_alerta]    Script Date: 02/11/2012 12:29:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_dba_alerta] as
exec sp_dba_lista_alertas
GO
/****** Object:  ForeignKey [FK__RowCountS__snaps__3F466844]    Script Date: 02/11/2012 12:29:24 ******/
ALTER TABLE [dbo].[RowCountSnapshot]  WITH CHECK ADD FOREIGN KEY([snapshotId])
REFERENCES [dbo].[Snapshot] ([id])
GO
/****** Object:  ForeignKey [FK__ProcSnaps__snaps__440B1D61]    Script Date: 02/11/2012 12:29:24 ******/
ALTER TABLE [dbo].[ProcSnapshot]  WITH CHECK ADD FOREIGN KEY([snapshotId])
REFERENCES [dbo].[Snapshot] ([id])
GO
/****** Object:  ForeignKey [FK__IoSnapsho__snaps__48CFD27E]    Script Date: 02/11/2012 12:29:24 ******/
ALTER TABLE [dbo].[IoSnapshot]  WITH CHECK ADD FOREIGN KEY([snapshotId])
REFERENCES [dbo].[Snapshot] ([id])
GO
/****** Object:  ForeignKey [FK__SpaceSnap__snaps__4D94879B]    Script Date: 02/11/2012 12:29:24 ******/
ALTER TABLE [dbo].[SpaceSnapshot]  WITH CHECK ADD FOREIGN KEY([snapshotId])
REFERENCES [dbo].[Snapshot] ([id])
GO
