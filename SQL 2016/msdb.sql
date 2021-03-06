USE [master]
GO
/****** Object:  Database [msdb]    Script Date: 02/11/2012 12:33:13 ******/
CREATE DATABASE [msdb] ON  PRIMARY 
( NAME = N'MSDBData', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.DBPRODODS001\MSSQL\DATA\MSDBData.mdf' , SIZE = 267008KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10%)
 LOG ON 
( NAME = N'MSDBLog', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.DBPRODODS001\MSSQL\DATA\MSDBLog.ldf' , SIZE = 39296KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [msdb] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [msdb].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [msdb] SET ANSI_NULL_DEFAULT OFF
GO
ALTER DATABASE [msdb] SET ANSI_NULLS OFF
GO
ALTER DATABASE [msdb] SET ANSI_PADDING OFF
GO
ALTER DATABASE [msdb] SET ANSI_WARNINGS OFF
GO
ALTER DATABASE [msdb] SET ARITHABORT OFF
GO
ALTER DATABASE [msdb] SET AUTO_CLOSE OFF
GO
ALTER DATABASE [msdb] SET AUTO_CREATE_STATISTICS ON
GO
ALTER DATABASE [msdb] SET AUTO_SHRINK OFF
GO
ALTER DATABASE [msdb] SET AUTO_UPDATE_STATISTICS ON
GO
ALTER DATABASE [msdb] SET CURSOR_CLOSE_ON_COMMIT OFF
GO
ALTER DATABASE [msdb] SET CURSOR_DEFAULT  GLOBAL
GO
ALTER DATABASE [msdb] SET CONCAT_NULL_YIELDS_NULL OFF
GO
ALTER DATABASE [msdb] SET NUMERIC_ROUNDABORT OFF
GO
ALTER DATABASE [msdb] SET QUOTED_IDENTIFIER OFF
GO
ALTER DATABASE [msdb] SET RECURSIVE_TRIGGERS OFF
GO
ALTER DATABASE [msdb] SET  ENABLE_BROKER
GO
ALTER DATABASE [msdb] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO
ALTER DATABASE [msdb] SET DATE_CORRELATION_OPTIMIZATION OFF
GO
ALTER DATABASE [msdb] SET TRUSTWORTHY ON
GO
ALTER DATABASE [msdb] SET ALLOW_SNAPSHOT_ISOLATION ON
GO
ALTER DATABASE [msdb] SET PARAMETERIZATION SIMPLE
GO
ALTER DATABASE [msdb] SET READ_COMMITTED_SNAPSHOT OFF
GO
ALTER DATABASE [msdb] SET HONOR_BROKER_PRIORITY OFF
GO
ALTER DATABASE [msdb] SET  READ_WRITE
GO
ALTER DATABASE [msdb] SET RECOVERY SIMPLE
GO
ALTER DATABASE [msdb] SET  MULTI_USER
GO
ALTER DATABASE [msdb] SET PAGE_VERIFY CHECKSUM
GO
ALTER DATABASE [msdb] SET DB_CHAINING ON
GO
USE [msdb]
GO
/****** Object:  User [PSAFE\Servico_SQL]    Script Date: 02/11/2012 12:33:14 ******/
CREATE USER [PSAFE\Servico_SQL] FOR LOGIN [PSAFE\Servico_SQL] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [MS_DataCollectorInternalUser]    Script Date: 02/11/2012 12:33:14 ******/
CREATE USER [MS_DataCollectorInternalUser] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [##MS_PolicyTsqlExecutionLogin##]    Script Date: 02/11/2012 12:33:14 ******/
CREATE USER [##MS_PolicyTsqlExecutionLogin##] FOR LOGIN [##MS_PolicyTsqlExecutionLogin##] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [##MS_PolicyEventProcessingLogin##]    Script Date: 02/11/2012 12:33:14 ******/
CREATE USER [##MS_PolicyEventProcessingLogin##] FOR LOGIN [##MS_PolicyEventProcessingLogin##] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  Role [DatabaseMailUserRole]    Script Date: 02/11/2012 12:33:14 ******/
CREATE ROLE [DatabaseMailUserRole] AUTHORIZATION [dbo]
GO
/****** Object:  Role [SQLAgentUserRole]    Script Date: 02/11/2012 12:33:14 ******/
CREATE ROLE [SQLAgentUserRole] AUTHORIZATION [dbo]
GO
/****** Object:  Role [db_ssisltduser]    Script Date: 02/11/2012 12:33:14 ******/
CREATE ROLE [db_ssisltduser] AUTHORIZATION [dbo]
GO
/****** Object:  Role [db_ssisoperator]    Script Date: 02/11/2012 12:33:14 ******/
CREATE ROLE [db_ssisoperator] AUTHORIZATION [dbo]
GO
/****** Object:  Role [dc_proxy]    Script Date: 02/11/2012 12:33:14 ******/
CREATE ROLE [dc_proxy] AUTHORIZATION [dbo]
GO
/****** Object:  Role [dc_admin]    Script Date: 02/11/2012 12:33:14 ******/
CREATE ROLE [dc_admin] AUTHORIZATION [dbo]
GO
/****** Object:  Role [dc_operator]    Script Date: 02/11/2012 12:33:14 ******/
CREATE ROLE [dc_operator] AUTHORIZATION [dbo]
GO
/****** Object:  Role [SQLAgentReaderRole]    Script Date: 02/11/2012 12:33:14 ******/
CREATE ROLE [SQLAgentReaderRole] AUTHORIZATION [dbo]
GO
/****** Object:  Role [SQLAgentOperatorRole]    Script Date: 02/11/2012 12:33:14 ******/
CREATE ROLE [SQLAgentOperatorRole] AUTHORIZATION [dbo]
GO
/****** Object:  Role [PolicyAdministratorRole]    Script Date: 02/11/2012 12:33:15 ******/
CREATE ROLE [PolicyAdministratorRole] AUTHORIZATION [dbo]
GO
/****** Object:  Role [ServerGroupReaderRole]    Script Date: 02/11/2012 12:33:15 ******/
CREATE ROLE [ServerGroupReaderRole] AUTHORIZATION [dbo]
GO
/****** Object:  Role [ServerGroupAdministratorRole]    Script Date: 02/11/2012 12:33:15 ******/
CREATE ROLE [ServerGroupAdministratorRole] AUTHORIZATION [dbo]
GO
/****** Object:  Role [TargetServersRole]    Script Date: 02/11/2012 12:33:15 ******/
CREATE ROLE [TargetServersRole] AUTHORIZATION [dbo]
GO
/****** Object:  Role [UtilityCMRReader]    Script Date: 02/11/2012 12:33:15 ******/
CREATE ROLE [UtilityCMRReader] AUTHORIZATION [dbo]
GO
/****** Object:  Role [UtilityIMRReader]    Script Date: 02/11/2012 12:33:15 ******/
CREATE ROLE [UtilityIMRReader] AUTHORIZATION [dbo]
GO
/****** Object:  Role [UtilityIMRWriter]    Script Date: 02/11/2012 12:33:15 ******/
CREATE ROLE [UtilityIMRWriter] AUTHORIZATION [dbo]
GO
/****** Object:  Role [db_ssisadmin]    Script Date: 02/11/2012 12:33:15 ******/
CREATE ROLE [db_ssisadmin] AUTHORIZATION [dbo]
GO
/****** Object:  Schema [TargetServersRole]    Script Date: 02/11/2012 12:33:15 ******/
CREATE SCHEMA [TargetServersRole] AUTHORIZATION [TargetServersRole]
GO
/****** Object:  Schema [SQLAgentUserRole]    Script Date: 02/11/2012 12:33:15 ******/
CREATE SCHEMA [SQLAgentUserRole] AUTHORIZATION [SQLAgentUserRole]
GO
/****** Object:  Schema [SQLAgentReaderRole]    Script Date: 02/11/2012 12:33:15 ******/
CREATE SCHEMA [SQLAgentReaderRole] AUTHORIZATION [SQLAgentReaderRole]
GO
/****** Object:  Schema [SQLAgentOperatorRole]    Script Date: 02/11/2012 12:33:16 ******/
CREATE SCHEMA [SQLAgentOperatorRole] AUTHORIZATION [SQLAgentOperatorRole]
GO
/****** Object:  Schema [db_ssisoperator]    Script Date: 02/11/2012 12:33:16 ******/
CREATE SCHEMA [db_ssisoperator] AUTHORIZATION [db_ssisoperator]
GO
/****** Object:  Schema [db_ssisltduser]    Script Date: 02/11/2012 12:33:16 ******/
CREATE SCHEMA [db_ssisltduser] AUTHORIZATION [db_ssisltduser]
GO
/****** Object:  Schema [db_ssisadmin]    Script Date: 02/11/2012 12:33:16 ******/
CREATE SCHEMA [db_ssisadmin] AUTHORIZATION [db_ssisadmin]
GO
/****** Object:  Schema [DatabaseMailUserRole]    Script Date: 02/11/2012 12:33:16 ******/
CREATE SCHEMA [DatabaseMailUserRole] AUTHORIZATION [DatabaseMailUserRole]
GO
/****** Object:  ExtendedProperty [Microsoft_Management_Utility_Version]    Script Date: 02/11/2012 12:33:13 ******/
EXEC sys.sp_addextendedproperty @name=N'Microsoft_Management_Utility_Version', @value=N'___SQLVERSION___NEW___'
GO
/****** Object:  Default [dbo].[default_zero]    Script Date: 02/11/2012 12:33:16 ******/
CREATE DEFAULT [dbo].[default_zero] AS 0
GO
/****** Object:  Default [dbo].[default_sdl_error_message]    Script Date: 02/11/2012 12:33:16 ******/
CREATE DEFAULT [dbo].[default_sdl_error_message] AS NULL
GO
/****** Object:  Table [dbo].[sysjobschedules]    Script Date: 02/11/2012 12:33:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sysjobschedules](
	[schedule_id] [int] NULL,
	[job_id] [uniqueidentifier] NULL,
	[next_run_date] [int] NOT NULL,
	[next_run_time] [int] NOT NULL
) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [clust] ON [dbo].[sysjobschedules] 
(
	[job_id] ASC,
	[schedule_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NC_sysjobschedules_schedule_id] ON [dbo].[sysjobschedules] 
(
	[schedule_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sysoriginatingservers]    Script Date: 02/11/2012 12:33:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sysoriginatingservers](
	[originating_server_id] [int] NULL,
	[originating_server] [sysname] NOT NULL,
	[master_server] [bit] NULL,
UNIQUE NONCLUSTERED 
(
	[originating_server] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
UNIQUE CLUSTERED 
(
	[originating_server_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[sysoriginatingservers_view]    Script Date: 02/11/2012 12:33:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[sysoriginatingservers_view](originating_server_id, originating_server, master_server)
AS 
   SELECT
      0 AS originating_server_id, 
      UPPER(CONVERT(sysname, SERVERPROPERTY('ServerName'))) AS originating_server,
      0 AS master_server
   UNION
   SELECT 
      originating_server_id,
      originating_server,
      master_server
   FROM
      dbo.sysoriginatingservers
GO
/****** Object:  Table [dbo].[sysschedules]    Script Date: 02/11/2012 12:33:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sysschedules](
	[schedule_id] [int] IDENTITY(1,1) NOT NULL,
	[schedule_uid] [uniqueidentifier] NOT NULL,
	[originating_server_id] [int] NOT NULL,
	[name] [sysname] NOT NULL,
	[owner_sid] [varbinary](85) NOT NULL,
	[enabled] [int] NOT NULL,
	[freq_type] [int] NOT NULL,
	[freq_interval] [int] NOT NULL,
	[freq_subday_type] [int] NOT NULL,
	[freq_subday_interval] [int] NOT NULL,
	[freq_relative_interval] [int] NOT NULL,
	[freq_recurrence_factor] [int] NOT NULL,
	[active_start_date] [int] NOT NULL,
	[active_end_date] [int] NOT NULL,
	[active_start_time] [int] NOT NULL,
	[active_end_time] [int] NOT NULL,
	[date_created] [datetime] NOT NULL,
	[date_modified] [datetime] NOT NULL,
	[version_number] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[schedule_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sysjobs]    Script Date: 02/11/2012 12:33:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sysjobs](
	[job_id] [uniqueidentifier] NOT NULL,
	[originating_server_id] [int] NOT NULL,
	[name] [sysname] NOT NULL,
	[enabled] [tinyint] NOT NULL,
	[description] [nvarchar](512) NULL,
	[start_step_id] [int] NOT NULL,
	[category_id] [int] NOT NULL,
	[owner_sid] [varbinary](85) NOT NULL,
	[notify_level_eventlog] [int] NOT NULL,
	[notify_level_email] [int] NOT NULL,
	[notify_level_netsend] [int] NOT NULL,
	[notify_level_page] [int] NOT NULL,
	[notify_email_operator_id] [int] NOT NULL,
	[notify_netsend_operator_id] [int] NOT NULL,
	[notify_page_operator_id] [int] NOT NULL,
	[delete_level] [int] NOT NULL,
	[date_created] [datetime] NOT NULL,
	[date_modified] [datetime] NOT NULL,
	[version_number] [int] NOT NULL
) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [clust] ON [dbo].[sysjobs] 
(
	[job_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [nc1] ON [dbo].[sysjobs] 
(
	[name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [nc3] ON [dbo].[sysjobs] 
(
	[category_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [nc4] ON [dbo].[sysjobs] 
(
	[owner_sid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  XmlSchemaCollection [dbo].[schema_collection_Performance Counters Collector Type]    Script Date: 02/11/2012 12:33:21 ******/
CREATE XML SCHEMA COLLECTION [dbo].[schema_collection_Performance Counters Collector Type] AS N'<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:t="DataCollectorType" targetNamespace="DataCollectorType"><xsd:element name="PerformanceCountersCollector"><xsd:complexType><xsd:complexContent><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:element name="PerformanceCounters" minOccurs="0" maxOccurs="unbounded"><xsd:complexType><xsd:complexContent><xsd:restriction base="xsd:anyType"><xsd:sequence /><xsd:attribute name="Objects" type="xsd:string" use="required" /><xsd:attribute name="Counters" type="xsd:string" use="required" /><xsd:attribute name="Instances" type="xsd:string" /></xsd:restriction></xsd:complexContent></xsd:complexType></xsd:element></xsd:sequence><xsd:attribute name="StoreLocalizedCounterNames" type="xsd:boolean" default="false" /></xsd:restriction></xsd:complexContent></xsd:complexType></xsd:element></xsd:schema>'
GO
/****** Object:  XmlSchemaCollection [dbo].[schema_collection_Generic T-SQL Query Collector Type]    Script Date: 02/11/2012 12:33:21 ******/
CREATE XML SCHEMA COLLECTION [dbo].[schema_collection_Generic T-SQL Query Collector Type] AS N'<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:t="DataCollectorType" targetNamespace="DataCollectorType"><xsd:element name="TSQLQueryCollector"><xsd:complexType><xsd:complexContent><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:element name="Query" maxOccurs="unbounded"><xsd:complexType><xsd:complexContent><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:element name="Value" type="xsd:string" /><xsd:element name="OutputTable" type="xsd:string" /></xsd:sequence></xsd:restriction></xsd:complexContent></xsd:complexType></xsd:element><xsd:element name="Databases" minOccurs="0"><xsd:complexType><xsd:complexContent><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:element name="Database" type="xsd:string" minOccurs="0" maxOccurs="unbounded" /></xsd:sequence><xsd:attribute name="UseSystemDatabases" type="xsd:boolean" /><xsd:attribute name="UseUserDatabases" type="xsd:boolean" /></xsd:restriction></xsd:complexContent></xsd:complexType></xsd:element></xsd:sequence></xsd:restriction></xsd:complexContent></xsd:complexType></xsd:element></xsd:schema>'
GO
/****** Object:  XmlSchemaCollection [dbo].[schema_collection_Generic SQL Trace Collector Type]    Script Date: 02/11/2012 12:33:21 ******/
CREATE XML SCHEMA COLLECTION [dbo].[schema_collection_Generic SQL Trace Collector Type] AS N'<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:t="DataCollectorType" targetNamespace="DataCollectorType"><xsd:element name="SqlTraceCollector"><xsd:complexType><xsd:complexContent><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:element name="Events"><xsd:complexType><xsd:complexContent><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:element name="EventType" minOccurs="0" maxOccurs="unbounded"><xsd:complexType><xsd:complexContent><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:element name="Event" maxOccurs="unbounded"><xsd:complexType><xsd:complexContent><xsd:restriction base="xsd:anyType"><xsd:sequence /><xsd:attribute name="id" type="xsd:unsignedByte" use="required" /><xsd:attribute name="name" type="xsd:string" use="required" /><xsd:attribute name="columnslist" type="xsd:string" /></xsd:restriction></xsd:complexContent></xsd:complexType></xsd:element></xsd:sequence><xsd:attribute name="id" type="xsd:unsignedByte" /><xsd:attribute name="name" type="xsd:string" use="required" /></xsd:restriction></xsd:complexContent></xsd:complexType></xsd:element></xsd:sequence></xsd:restriction></xsd:complexContent></xsd:complexType></xsd:element><xsd:element name="Filters"><xsd:complexType><xsd:complexContent><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:element name="Filter" minOccurs="0" maxOccurs="unbounded"><xsd:complexType><xsd:complexContent><xsd:restriction base="xsd:anyType"><xsd:sequence /><xsd:attribute name="columnid" type="xsd:unsignedByte" use="required" /><xsd:attribute name="columnname" type="xsd:string" use="required" /><xsd:attribute name="logical_operator" type="xsd:string" use="required" /><xsd:attribute name="comparison_operator" type="xsd:string" use="required" /><xsd:attribute name="value" type="xsd:string" use="required" /></xsd:restriction></xsd:complexContent></xsd:complexType></xsd:element></xsd:sequence></xsd:restriction></xsd:complexContent></xsd:complexType></xsd:element></xsd:sequence><xsd:attribute name="use_default" type="xsd:boolean" /></xsd:restriction></xsd:complexContent></xsd:complexType></xsd:element></xsd:schema>'
GO
/****** Object:  Default [dbo].[default_one]    Script Date: 02/11/2012 12:33:21 ******/
CREATE DEFAULT [dbo].[default_one] AS 1
GO
/****** Object:  Default [dbo].[default_current_date]    Script Date: 02/11/2012 12:33:21 ******/
CREATE DEFAULT [dbo].[default_current_date] AS GETDATE()
GO
/****** Object:  Table [dbo].[syscategories]    Script Date: 02/11/2012 12:33:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[syscategories](
	[category_id] [int] IDENTITY(1,1) NOT NULL,
	[category_class] [int] NOT NULL,
	[category_type] [tinyint] NOT NULL,
	[name] [sysname] NOT NULL
) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [clust] ON [dbo].[syscategories] 
(
	[name] ASC,
	[category_class] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[SQLAGENT_SUSER_SID]    Script Date: 02/11/2012 12:33:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[SQLAGENT_SUSER_SID](@user_name sysname) RETURNS VARBINARY(85)
AS
BEGIN
  DECLARE @ret VARBINARY(85)
  IF @user_name = N'$(SQLAgentAccount)'
    SELECT @ret = 0xFFFFFFFF
  ELSE
    SELECT @ret = SUSER_SID(@user_name, 0)
  RETURN @ret
END
GO
/****** Object:  Table [dbo].[sysoperators]    Script Date: 02/11/2012 12:33:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sysoperators](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [sysname] NOT NULL,
	[enabled] [tinyint] NOT NULL,
	[email_address] [nvarchar](100) NULL,
	[last_email_date] [int] NOT NULL,
	[last_email_time] [int] NOT NULL,
	[pager_address] [nvarchar](100) NULL,
	[last_pager_date] [int] NOT NULL,
	[last_pager_time] [int] NOT NULL,
	[weekday_pager_start_time] [int] NOT NULL,
	[weekday_pager_end_time] [int] NOT NULL,
	[saturday_pager_start_time] [int] NOT NULL,
	[saturday_pager_end_time] [int] NOT NULL,
	[sunday_pager_start_time] [int] NOT NULL,
	[sunday_pager_end_time] [int] NOT NULL,
	[pager_days] [tinyint] NOT NULL,
	[netsend_address] [nvarchar](100) NULL,
	[last_netsend_date] [int] NOT NULL,
	[last_netsend_time] [int] NOT NULL,
	[category_id] [int] NOT NULL
) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [ByName] ON [dbo].[sysoperators] 
(
	[name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ByID] ON [dbo].[sysoperators] 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sysjobsteps]    Script Date: 02/11/2012 12:33:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sysjobsteps](
	[job_id] [uniqueidentifier] NOT NULL,
	[step_id] [int] NOT NULL,
	[step_name] [sysname] NOT NULL,
	[subsystem] [nvarchar](40) NOT NULL,
	[command] [nvarchar](max) NULL,
	[flags] [int] NOT NULL,
	[additional_parameters] [ntext] NULL,
	[cmdexec_success_code] [int] NOT NULL,
	[on_success_action] [tinyint] NOT NULL,
	[on_success_step_id] [int] NOT NULL,
	[on_fail_action] [tinyint] NOT NULL,
	[on_fail_step_id] [int] NOT NULL,
	[server] [sysname] NULL,
	[database_name] [sysname] NULL,
	[database_user_name] [sysname] NULL,
	[retry_attempts] [int] NOT NULL,
	[retry_interval] [int] NOT NULL,
	[os_run_priority] [int] NOT NULL,
	[output_file_name] [nvarchar](200) NULL,
	[last_run_outcome] [int] NOT NULL,
	[last_run_duration] [int] NOT NULL,
	[last_run_retries] [int] NOT NULL,
	[last_run_date] [int] NOT NULL,
	[last_run_time] [int] NOT NULL,
	[proxy_id] [int] NULL,
	[step_uid] [uniqueidentifier] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [clust] ON [dbo].[sysjobsteps] 
(
	[job_id] ASC,
	[step_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [nc1] ON [dbo].[sysjobsteps] 
(
	[job_id] ASC,
	[step_name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [nc2] ON [dbo].[sysjobsteps] 
(
	[step_uid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sysjobservers]    Script Date: 02/11/2012 12:33:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sysjobservers](
	[job_id] [uniqueidentifier] NOT NULL,
	[server_id] [int] NOT NULL,
	[last_run_outcome] [tinyint] NOT NULL,
	[last_outcome_message] [nvarchar](4000) NULL,
	[last_run_date] [int] NOT NULL,
	[last_run_time] [int] NOT NULL,
	[last_run_duration] [int] NOT NULL
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [clust] ON [dbo].[sysjobservers] 
(
	[job_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [nc1] ON [dbo].[sysjobservers] 
(
	[server_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  View [dbo].[sysjobs_view]    Script Date: 02/11/2012 12:33:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[sysjobs_view]
AS
SELECT jobs.job_id,
       svr.originating_server,
       jobs.name,
       jobs.enabled,
       jobs.description,
       jobs.start_step_id,
       jobs.category_id,
       jobs.owner_sid,
       jobs.notify_level_eventlog,
       jobs.notify_level_email,
       jobs.notify_level_netsend,
       jobs.notify_level_page,
       jobs.notify_email_operator_id,
       jobs.notify_netsend_operator_id,
       jobs.notify_page_operator_id,
       jobs.delete_level,
       jobs.date_created,
       jobs.date_modified,
       jobs.version_number,
       jobs.originating_server_id,
       svr.master_server
FROM msdb.dbo.sysjobs as jobs
  JOIN msdb.dbo.sysoriginatingservers_view as svr
    ON jobs.originating_server_id = svr.originating_server_id
  --LEFT JOIN msdb.dbo.sysjobservers js ON jobs.job_id = js.job_id
WHERE (owner_sid = SUSER_SID())
   OR (ISNULL(IS_SRVROLEMEMBER(N'sysadmin'), 0) = 1)
   OR (ISNULL(IS_MEMBER(N'SQLAgentReaderRole'), 0) = 1)
   OR ( (ISNULL(IS_MEMBER(N'TargetServersRole'), 0) = 1) AND
        (EXISTS(SELECT * FROM msdb.dbo.sysjobservers js 
         WHERE js.server_id <> 0 AND js.job_id = jobs.job_id))) -- filter out local jobs
GO
/****** Object:  UserDefinedTableType [dbo].[syspolicy_target_filters_type]    Script Date: 02/11/2012 12:33:26 ******/
CREATE TYPE [dbo].[syspolicy_target_filters_type] AS TABLE(
	[target_filter_id] [int] NULL,
	[policy_id] [int] NULL,
	[type] [sysname] NOT NULL,
	[filter] [nvarchar](max) NOT NULL,
	[type_skeleton] [sysname] NOT NULL
)
GO
/****** Object:  StoredProcedure [dbo].[sp_is_sqlagent_starting]    Script Date: 02/11/2012 12:34:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[sp_is_sqlagent_starting]
AS
BEGIN
  DECLARE @retval INT

  SELECT @retval = 0
  EXECUTE master.dbo.xp_sqlagent_is_starting @retval OUTPUT
  IF (@retval = 1)
    RAISERROR(14258, -1, -1)

  RETURN(@retval)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_verify_job_identifiers]    Script Date: 02/11/2012 12:34:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[sp_verify_job_identifiers]
  @name_of_name_parameter  VARCHAR(60),             -- Eg. '@job_name'
  @name_of_id_parameter    VARCHAR(60),             -- Eg. '@job_id'
  @job_name                sysname          OUTPUT, -- Eg. 'My Job'
  @job_id                  UNIQUEIDENTIFIER OUTPUT,
  @sqlagent_starting_test  VARCHAR(7) = 'TEST',      -- By default we DO want to test if SQLServerAgent is running (caller should specify 'NO_TEST' if not desired)
  @owner_sid                VARBINARY(85) = NULL OUTPUT  
AS
BEGIN
  DECLARE @retval         INT
  DECLARE @job_id_as_char VARCHAR(36)

  SET NOCOUNT ON

  -- Remove any leading/trailing spaces from parameters
  SELECT @name_of_name_parameter = LTRIM(RTRIM(@name_of_name_parameter))
  SELECT @name_of_id_parameter   = LTRIM(RTRIM(@name_of_id_parameter))
  SELECT @job_name               = LTRIM(RTRIM(@job_name))

  IF (@job_name = N'') SELECT @job_name = NULL

  IF ((@job_name IS NULL)     AND (@job_id IS NULL)) OR
     ((@job_name IS NOT NULL) AND (@job_id IS NOT NULL))
  BEGIN
    RAISERROR(14294, -1, -1, @name_of_id_parameter, @name_of_name_parameter)
    RETURN(1) -- Failure
  END

  -- Check job id
  IF (@job_id IS NOT NULL)
  BEGIN
    SELECT @job_name = name,
           @owner_sid = owner_sid
    FROM msdb.dbo.sysjobs_view
    WHERE (job_id = @job_id)
    
    -- the view would take care of all the permissions issues.
    IF (@job_name IS NULL) 
    BEGIN
      SELECT @job_id_as_char = CONVERT(VARCHAR(36), @job_id)
      RAISERROR(14262, -1, -1, '@job_id', @job_id_as_char)
      RETURN(1) -- Failure
    END
  END
  ELSE
  -- Check job name
  IF (@job_name IS NOT NULL)
  BEGIN
    -- Check if the job name is ambiguous
    IF ((SELECT COUNT(*)
         FROM msdb.dbo.sysjobs_view
         WHERE (name = @job_name)) > 1)
    BEGIN
      RAISERROR(14293, -1, -1, @job_name, @name_of_id_parameter, @name_of_name_parameter)
      RETURN(1) -- Failure
    END

    -- The name is not ambiguous, so get the corresponding job_id (if the job exists)
    SELECT @job_id = job_id,
           @owner_sid = owner_sid
    FROM msdb.dbo.sysjobs_view
    WHERE (name = @job_name)
    
    -- the view would take care of all the permissions issues.
    IF (@job_id IS NULL) 
    BEGIN
      RAISERROR(14262, -1, -1, '@job_name', @job_name)
      RETURN(1) -- Failure
    END
  END

  IF (@sqlagent_starting_test = 'TEST')
  BEGIN
    -- Finally, check if SQLServerAgent is in the process of starting and if so prevent the
    -- calling SP from running
    EXECUTE @retval = msdb.dbo.sp_is_sqlagent_starting
    IF (@retval <> 0)
      RETURN(1) -- Failure
  END

  RETURN(0) -- Success
END
GO
/****** Object:  UserDefinedFunction [dbo].[sp_dba_udf_schedule_description]    Script Date: 02/11/2012 12:34:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[sp_dba_udf_schedule_description] (@freq_type INT , 
  @freq_interval INT , 
  @freq_subday_type INT , 
  @freq_subday_interval INT , 
  @freq_relative_interval INT , 
  @freq_recurrence_factor INT , 
  @active_start_date INT , 
  @active_end_date INT, 
  @active_start_time INT , 
  @active_end_time INT ) 
RETURNS NVARCHAR(255) 
WITH EXECUTE AS OWNER
BEGIN 
DECLARE @schedule_description NVARCHAR(255) 
DECLARE @loop INT 
DECLARE @idle_cpu_percent INT 
DECLARE @idle_cpu_duration INT 

IF (@freq_type = 0x1) -- OneTime 
BEGIN 
SELECT @schedule_description = N'Once on ' + CONVERT(NVARCHAR, @active_start_date) + N' at ' + CONVERT(NVARCHAR, cast((@active_start_time / 10000) as varchar(10)) + ':' + right('00' + cast((@active_start_time % 10000) / 100 as varchar(10)),2)) 
RETURN @schedule_description 
END 
IF (@freq_type = 0x4) -- Daily 
BEGIN 
SELECT @schedule_description = N'Every day ' 
END 
IF (@freq_type = 0x8) -- Weekly 
BEGIN 
SELECT @schedule_description = N'Every ' + CONVERT(NVARCHAR, @freq_recurrence_factor) + N' week(s) on ' 
SELECT @loop = 1 
WHILE (@loop <= 7) 
BEGIN 
IF (@freq_interval & POWER(2, @loop - 1) = POWER(2, @loop - 1)) 
SELECT @schedule_description = @schedule_description + DATENAME(dw, N'1996120' + CONVERT(NVARCHAR, @loop)) + N', ' 
SELECT @loop = @loop + 1 
END 
IF (RIGHT(@schedule_description, 2) = N', ') 
SELECT @schedule_description = SUBSTRING(@schedule_description, 1, (DATALENGTH(@schedule_description) / 2) - 2) + N' ' 
END 
IF (@freq_type = 0x10) -- Monthly 
BEGIN 
SELECT @schedule_description = N'Every ' + CONVERT(NVARCHAR, @freq_recurrence_factor) + N' months(s) on day ' + CONVERT(NVARCHAR, @freq_interval) + N' of that month ' 
END 
IF (@freq_type = 0x20) -- Monthly Relative 
BEGIN 
SELECT @schedule_description = N'Every ' + CONVERT(NVARCHAR, @freq_recurrence_factor) + N' months(s) on the ' 
SELECT @schedule_description = @schedule_description + 
CASE @freq_relative_interval 
WHEN 0x01 THEN N'first ' 
WHEN 0x02 THEN N'second ' 
WHEN 0x04 THEN N'third ' 
WHEN 0x08 THEN N'fourth ' 
WHEN 0x10 THEN N'last ' 
END + 
CASE 
WHEN (@freq_interval > 00) 
AND (@freq_interval < 08) THEN DATENAME(dw, N'1996120' + CONVERT(NVARCHAR, @freq_interval)) 
WHEN (@freq_interval = 08) THEN N'day' 
WHEN (@freq_interval = 09) THEN N'week day' 
WHEN (@freq_interval = 10) THEN N'weekend day' 
END + N' of that month ' 
END 
IF (@freq_type = 0x40) -- AutoStart 
BEGIN 
SELECT @schedule_description = FORMATMESSAGE(14579) 
RETURN @schedule_description 
END 
IF (@freq_type = 0x80) -- OnIdle 
BEGIN 
EXECUTE master.dbo.xp_instance_regread N'HKEY_LOCAL_MACHINE', 
N'SOFTWARE\Microsoft\MSSQLServer\SQLServerAgent', 
N'IdleCPUPercent', 
@idle_cpu_percent OUTPUT, 
N'no_output' 
EXECUTE master.dbo.xp_instance_regread N'HKEY_LOCAL_MACHINE', 
N'SOFTWARE\Microsoft\MSSQLServer\SQLServerAgent', 
N'IdleCPUDuration', 
@idle_cpu_duration OUTPUT, 
N'no_output' 
SELECT @schedule_description = FORMATMESSAGE(14578, ISNULL(@idle_cpu_percent, 10), ISNULL(@idle_cpu_duration, 600)) 
RETURN @schedule_description 
END 
-- Subday stuff 
SELECT @schedule_description = @schedule_description + 
CASE @freq_subday_type 
WHEN 0x1 THEN N'at ' + CONVERT(NVARCHAR, cast((@active_start_time / 10000) as varchar(10)) + ':' + right('00' + cast((@active_start_time % 10000) / 100 as varchar(10)),2)) 
WHEN 0x2 THEN N'every ' + CONVERT(NVARCHAR, @freq_subday_interval) + N' second(s)' 
WHEN 0x4 THEN N'every ' + CONVERT(NVARCHAR, @freq_subday_interval) + N' minute(s)' 
WHEN 0x8 THEN N'every ' + CONVERT(NVARCHAR, @freq_subday_interval) + N' hour(s)' 
END 
IF (@freq_subday_type IN (0x2, 0x4, 0x8)) 
SELECT @schedule_description = @schedule_description + N' between ' + 
CONVERT(NVARCHAR, cast((@active_start_time / 10000) as varchar(10)) + ':' + right('00' + cast((@active_start_time % 10000) / 100 as varchar(10)),2) ) + N' and ' + CONVERT(NVARCHAR, cast((@active_end_time / 10000) as varchar(10)) + ':' + right('00' + cast((@active_end_time % 10000) / 100 as varchar(10)),2) ) 

RETURN @schedule_description 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_job2]    Script Date: 02/11/2012 12:34:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_dba_job2]
WITH EXECUTE AS OWNER
as
begin
SELECT dbo.sysjobs.name, CAST(dbo.sysschedules.active_start_time / 10000 AS VARCHAR(10))   
+ ':' + RIGHT('00' + CAST(dbo.sysschedules.active_start_time % 10000 / 100 AS VARCHAR(10)), 2) AS active_start_time,   
dbo.sp_dba_udf_schedule_description(dbo.sysschedules.freq_type, dbo.sysschedules.freq_interval,  
dbo.sysschedules.freq_subday_type, dbo.sysschedules.freq_subday_interval, dbo.sysschedules.freq_relative_interval,  
dbo.sysschedules.freq_recurrence_factor, dbo.sysschedules.active_start_date, dbo.sysschedules.active_end_date,  
dbo.sysschedules.active_start_time, dbo.sysschedules.active_end_time) AS ScheduleDscr, dbo.sysjobs.enabled  
FROM dbo.sysjobs INNER JOIN  
dbo.sysjobschedules ON dbo.sysjobs.job_id = dbo.sysjobschedules.job_id INNER JOIN  
dbo.sysschedules ON dbo.sysjobschedules.schedule_id = dbo.sysschedules.schedule_id  
end
GO
/****** Object:  Table [dbo].[syssubsystems]    Script Date: 02/11/2012 12:34:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[syssubsystems](
	[subsystem_id] [int] NOT NULL,
	[subsystem] [nvarchar](40) NOT NULL,
	[description_id] [int] NULL,
	[subsystem_dll] [nvarchar](255) NULL,
	[agent_exe] [nvarchar](255) NULL,
	[start_entry_point] [nvarchar](30) NULL,
	[event_entry_point] [nvarchar](30) NULL,
	[stop_entry_point] [nvarchar](30) NULL,
	[max_worker_threads] [int] NULL
) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [clust] ON [dbo].[syssubsystems] 
(
	[subsystem_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [nc1] ON [dbo].[syssubsystems] 
(
	[subsystem] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sysssislog]    Script Date: 02/11/2012 12:34:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sysssislog](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[event] [sysname] NOT NULL,
	[computer] [nvarchar](128) NOT NULL,
	[operator] [nvarchar](128) NOT NULL,
	[source] [nvarchar](1024) NOT NULL,
	[sourceid] [uniqueidentifier] NOT NULL,
	[executionid] [uniqueidentifier] NOT NULL,
	[starttime] [datetime] NOT NULL,
	[endtime] [datetime] NOT NULL,
	[datacode] [int] NOT NULL,
	[databytes] [image] NULL,
	[message] [nvarchar](2048) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sysjobactivity]    Script Date: 02/11/2012 12:34:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sysjobactivity](
	[session_id] [int] NOT NULL,
	[job_id] [uniqueidentifier] NOT NULL,
	[run_requested_date] [datetime] NULL,
	[run_requested_source] [sysname] NULL,
	[queued_date] [datetime] NULL,
	[start_execution_date] [datetime] NULL,
	[last_executed_step_id] [int] NULL,
	[last_executed_step_date] [datetime] NULL,
	[stop_execution_date] [datetime] NULL,
	[job_history_id] [int] NULL,
	[next_scheduled_run_date] [datetime] NULL
) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [clust] ON [dbo].[sysjobactivity] 
(
	[session_id] ASC,
	[job_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[syssessions]    Script Date: 02/11/2012 12:34:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[syssessions](
	[session_id] [int] IDENTITY(1,1) NOT NULL,
	[agent_start_date] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[session_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [nonclust] ON [dbo].[syssessions] 
(
	[agent_start_date] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[systargetservers]    Script Date: 02/11/2012 12:34:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[systargetservers](
	[server_id] [int] IDENTITY(1,1) NOT NULL,
	[server_name] [sysname] NOT NULL,
	[location] [nvarchar](200) NULL,
	[time_zone_adjustment] [int] NOT NULL,
	[enlist_date] [datetime] NOT NULL,
	[last_poll_date] [datetime] NOT NULL,
	[status] [int] NOT NULL,
	[local_time_at_last_poll] [datetime] NOT NULL,
	[enlisted_by_nt_user] [nvarchar](100) NOT NULL,
	[poll_interval] [int] NOT NULL
) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [clust] ON [dbo].[systargetservers] 
(
	[server_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [nc1] ON [dbo].[systargetservers] 
(
	[server_name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_get_composite_job_infoProblem]    Script Date: 02/11/2012 12:34:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc  [dbo].[sp_dba_get_composite_job_infoProblem]  
  @job_id             UNIQUEIDENTIFIER = NULL,  
  @job_type           VARCHAR(12)      = NULL,  -- LOCAL or MULTI-SERVER  
  @owner_login_name   sysname          = NULL,  
  @subsystem          NVARCHAR(40)     = NULL,  
  @category_id        INT              = NULL,  
  @enabled            TINYINT          = NULL,  
  @execution_status   INT              = NULL,  -- 0 = Not idle or suspended, 1 = Executing, 2 = Waiting For Thread, 3 = Between Retries, 4 = Idle, 5 = Suspended, [6 = WaitingForStepToFinish], 7 = PerformingCompletionActions  
  @date_comparator    CHAR(1)          = NULL,  -- >, < or =  
  @date_created       DATETIME         = NULL,  
  @date_last_modified DATETIME         = NULL,  
  @description        NVARCHAR(512)    = NULL,  -- We do a LIKE on this so it can include wildcards  
  @schedule_id        INT              = NULL   -- if supplied only return the jobs that use this schedule  
  WITH EXECUTE AS OWNER
AS  
BEGIN  
  DECLARE @can_see_all_running_jobs INT  
  DECLARE @job_owner   sysname  
  
  SET NOCOUNT ON  
  
  -- By 'composite' we mean a combination of sysjobs and xp_sqlagent_enum_jobs data.  
  -- This proc should only ever be called by sp_help_job, so we don't verify the  
  -- parameters (sp_help_job has already done this).  
  
  -- Step 1: Create intermediate work tables  
  DECLARE @job_execution_state TABLE (job_id                  UNIQUEIDENTIFIER NOT NULL,  
                                     date_started            INT              NOT NULL,  
                                     time_started            INT              NOT NULL,  
                                     execution_job_status    INT              NOT NULL,  
                                     execution_step_id       INT              NULL,  
                                     execution_step_name     sysname          COLLATE database_default NULL,  
                                     execution_retry_attempt INT              NOT NULL,  
                                     next_run_date           INT              NOT NULL,  
                                     next_run_time           INT              NOT NULL,  
                                     next_run_schedule_id    INT              NOT NULL)  
  DECLARE @filtered_jobs TABLE (job_id                   UNIQUEIDENTIFIER NOT NULL,  
                               date_created             DATETIME         NOT NULL,  
                               date_last_modified       DATETIME         NOT NULL,  
                               current_execution_status INT              NULL,  
                               current_execution_step   sysname          COLLATE database_default NULL,  
                               current_retry_attempt    INT              NULL,  
                               last_run_date            INT              NOT NULL,  
                               last_run_time            INT              NOT NULL,  
                               last_run_outcome         INT              NOT NULL,  
                               next_run_date            INT              NULL,  
                               next_run_time            INT              NULL,  
                               next_run_schedule_id     INT              NULL,  
                               type                     INT              NOT NULL)  
  DECLARE @xp_results TABLE (job_id                UNIQUEIDENTIFIER NOT NULL,  
                            last_run_date         INT              NOT NULL,  
                            last_run_time         INT              NOT NULL,  
                            next_run_date         INT              NOT NULL,  
                            next_run_time         INT              NOT NULL,  
                            next_run_schedule_id  INT              NOT NULL,  
                            requested_to_run      INT              NOT NULL, -- BOOL  
                            request_source        INT              NOT NULL,  
                            request_source_id     sysname          COLLATE database_default NULL,  
                            running               INT              NOT NULL, -- BOOL  
                            current_step          INT              NOT NULL,  
                            current_retry_attempt INT              NOT NULL,  
                            job_state             INT              NOT NULL)  
  
  -- Step 2: Capture job execution information (for local jobs only since that's all SQLServerAgent caches)  
  SELECT @can_see_all_running_jobs = ISNULL(IS_SRVROLEMEMBER(N'sysadmin'), 0)  
  IF (@can_see_all_running_jobs = 0)  
  BEGIN  
    SELECT @can_see_all_running_jobs = ISNULL(IS_MEMBER(N'SQLAgentReaderRole'), 0)  
  END  
  SELECT @job_owner = SUSER_SNAME()  
  
  IF ((@@microsoftversion / 0x01000000) >= 8) -- SQL Server 8.0 or greater  
    INSERT INTO @xp_results  
    EXECUTE master.dbo.xp_sqlagent_enum_jobs @can_see_all_running_jobs, @job_owner, @job_id  
  ELSE  
    INSERT INTO @xp_results  
    EXECUTE master.dbo.xp_sqlagent_enum_jobs @can_see_all_running_jobs, @job_owner  
  
  INSERT INTO @job_execution_state  
  SELECT xpr.job_id,  
         xpr.last_run_date,  
         xpr.last_run_time,  
         xpr.job_state,  
         sjs.step_id,  
         sjs.step_name,  
         xpr.current_retry_attempt,  
         xpr.next_run_date,  
         xpr.next_run_time,  
         xpr.next_run_schedule_id  
  FROM @xp_results                          xpr  
       LEFT OUTER JOIN msdb.dbo.sysjobsteps sjs ON ((xpr.job_id = sjs.job_id) AND (xpr.current_step = sjs.step_id)),  
       msdb.dbo.sysjobs_view                sjv  
  WHERE (sjv.job_id = xpr.job_id)  
  
  -- Step 3: Filter on everything but dates and job_type  
  IF ((@subsystem        IS NULL) AND  
      (@owner_login_name IS NULL) AND  
      (@enabled          IS NULL) AND  
      (@category_id      IS NULL) AND  
      (@execution_status IS NULL) AND  
      (@description      IS NULL) AND  
      (@job_id           IS NULL))  
  BEGIN  
    -- Optimize for the frequently used case...  
    INSERT INTO @filtered_jobs  
    SELECT sjv.job_id,  
           sjv.date_created,  
           sjv.date_modified,  
           ISNULL(jes.execution_job_status, 4), -- Will be NULL if the job is non-local or is not in @job_execution_state (NOTE: 4 = STATE_IDLE)  
           CASE ISNULL(jes.execution_step_id, 0)  
             WHEN 0 THEN NULL                   -- Will be NULL if the job is non-local or is not in @job_execution_state  
             ELSE CONVERT(NVARCHAR, jes.execution_step_id) + N' (' + jes.execution_step_name + N')'  
           END,  
           jes.execution_retry_attempt,         -- Will be NULL if the job is non-local or is not in @job_execution_state  
           0,  -- last_run_date placeholder    (we'll fix it up in step 3.3)  
           0,  -- last_run_time placeholder    (we'll fix it up in step 3.3)  
           5,  -- last_run_outcome placeholder (we'll fix it up in step 3.3 - NOTE: We use 5 just in case there are no jobservers for the job)  
           jes.next_run_date,                   -- Will be NULL if the job is non-local or is not in @job_execution_state  
           jes.next_run_time,                   -- Will be NULL if the job is non-local or is not in @job_execution_state  
           jes.next_run_schedule_id,            -- Will be NULL if the job is non-local or is not in @job_execution_state  
           0   -- type placeholder             (we'll fix it up in step 3.4)  
    FROM msdb.dbo.sysjobs_view                sjv  
         LEFT OUTER JOIN @job_execution_state jes ON (sjv.job_id = jes.job_id)  
    WHERE ((@schedule_id IS NULL)  
      OR   (EXISTS(SELECT *   
                 FROM sysjobschedules as js  
                 WHERE (sjv.job_id = js.job_id)  
                   AND (js.schedule_id = @schedule_id))))  
  END  
  ELSE  
  BEGIN  
    INSERT INTO @filtered_jobs  
    SELECT DISTINCT  
           sjv.job_id,  
           sjv.date_created,  
           sjv.date_modified,  
           ISNULL(jes.execution_job_status, 4), -- Will be NULL if the job is non-local or is not in @job_execution_state (NOTE: 4 = STATE_IDLE)  
           CASE ISNULL(jes.execution_step_id, 0)  
             WHEN 0 THEN NULL                   -- Will be NULL if the job is non-local or is not in @job_execution_state  
             ELSE CONVERT(NVARCHAR, jes.execution_step_id) + N' (' + jes.execution_step_name + N')'  
           END,  
           jes.execution_retry_attempt,         -- Will be NULL if the job is non-local or is not in @job_execution_state  
           0,  -- last_run_date placeholder    (we'll fix it up in step 3.3)  
           0,  -- last_run_time placeholder    (we'll fix it up in step 3.3)  
           5,  -- last_run_outcome placeholder (we'll fix it up in step 3.3 - NOTE: We use 5 just in case there are no jobservers for the job)  
           jes.next_run_date,                   -- Will be NULL if the job is non-local or is not in @job_execution_state  
           jes.next_run_time,                   -- Will be NULL if the job is non-local or is not in @job_execution_state  
           jes.next_run_schedule_id,            -- Will be NULL if the job is non-local or is not in @job_execution_state  
           0   -- type placeholder             (we'll fix it up in step 3.4)  
    FROM msdb.dbo.sysjobs_view                sjv  
         LEFT OUTER JOIN @job_execution_state jes ON (sjv.job_id = jes.job_id)  
         LEFT OUTER JOIN msdb.dbo.sysjobsteps sjs ON (sjv.job_id = sjs.job_id)  
    WHERE ((@subsystem        IS NULL) OR (sjs.subsystem            = @subsystem))  
      AND ((@owner_login_name IS NULL)   
          OR (sjv.owner_sid            = dbo.SQLAGENT_SUSER_SID(@owner_login_name)))--force case insensitive comparation for NT users  
      AND ((@enabled          IS NULL) OR (sjv.enabled              = @enabled))  
      AND ((@category_id      IS NULL) OR (sjv.category_id          = @category_id))  
      AND ((@execution_status IS NULL) OR ((@execution_status > 0) AND (jes.execution_job_status = @execution_status))  
                                       OR ((@execution_status = 0) AND (jes.execution_job_status <> 4) AND (jes.execution_job_status <> 5)))  
      AND ((@description      IS NULL) OR (sjv.description       LIKE @description))  
      AND ((@job_id           IS NULL) OR (sjv.job_id               = @job_id))  
      AND ((@schedule_id IS NULL)  
        OR (EXISTS(SELECT *   
                 FROM sysjobschedules as js  
                 WHERE (sjv.job_id = js.job_id)  
                   AND (js.schedule_id = @schedule_id))))  
  END  
  
  -- Step 3.1: Change the execution status of non-local jobs from 'Idle' to 'Unknown'  
  UPDATE @filtered_jobs  
  SET current_execution_status = NULL  
  WHERE (current_execution_status = 4)  
    AND (job_id IN (SELECT job_id  
                    FROM msdb.dbo.sysjobservers  
                    WHERE (server_id <> 0)))  
  
  -- Step 3.2: Check that if the user asked to see idle jobs that we still have some.  
  --           If we don't have any then the query should return no rows.  
  IF (@execution_status = 4) AND  
     (NOT EXISTS (SELECT *  
                  FROM @filtered_jobs  
                  WHERE (current_execution_status = 4)))  
  BEGIN  
    DELETE FROM @filtered_jobs  
  END  
  
  -- Step 3.3: Populate the last run date/time/outcome [this is a little tricky since for  
  --           multi-server jobs there are multiple last run details in sysjobservers, so  
  --           we simply choose the most recent].  
  IF (EXISTS (SELECT *  
              FROM msdb.dbo.systargetservers))  
  BEGIN  
    UPDATE @filtered_jobs  
    SET last_run_date = sjs.last_run_date,  
        last_run_time = sjs.last_run_time,  
        last_run_outcome = sjs.last_run_outcome  
    FROM @filtered_jobs         fj,  
         msdb.dbo.sysjobservers sjs  
    WHERE (CONVERT(FLOAT, sjs.last_run_date) * 1000000) + sjs.last_run_time =  
           (SELECT MAX((CONVERT(FLOAT, last_run_date) * 1000000) + last_run_time)  
            FROM msdb.dbo.sysjobservers  
            WHERE (job_id = sjs.job_id))  
      AND (fj.job_id = sjs.job_id)  
  END  
  ELSE  
  BEGIN  
    UPDATE @filtered_jobs  
    SET last_run_date = sjs.last_run_date,  
        last_run_time = sjs.last_run_time,  
        last_run_outcome = sjs.last_run_outcome  
    FROM @filtered_jobs         fj,  
         msdb.dbo.sysjobservers sjs  
    WHERE (fj.job_id = sjs.job_id)  
  END  
  
  -- Step 3.4 : Set the type of the job to local (1) or multi-server (2)  
  --            NOTE: If the job has no jobservers then it wil have a type of 0 meaning  
  --                  unknown.  This is marginally inconsistent with the behaviour of  
  --                  defaulting the category of a new job to [Uncategorized (Local)], but  
  --                  prevents incompletely defined jobs from erroneously showing up as valid  
  --                  local jobs.  
  UPDATE @filtered_jobs  
  SET type = 1 -- LOCAL  
  FROM @filtered_jobs         fj,  
       msdb.dbo.sysjobservers sjs  
  WHERE (fj.job_id = sjs.job_id)  
    AND (server_id = 0)  
  UPDATE @filtered_jobs  
  SET type = 2 -- MULTI-SERVER  
  FROM @filtered_jobs         fj,  
       msdb.dbo.sysjobservers sjs  
  WHERE (fj.job_id = sjs.job_id)  
    AND (server_id <> 0)  
  
  -- Step 4: Filter on job_type  
  IF (@job_type IS NOT NULL)  
  BEGIN  
    IF (UPPER(@job_type collate SQL_Latin1_General_CP1_CS_AS) = 'LOCAL')  
      DELETE FROM @filtered_jobs  
      WHERE (type <> 1) -- IE. Delete all the non-local jobs  
    IF (UPPER(@job_type collate SQL_Latin1_General_CP1_CS_AS) = 'MULTI-SERVER')  
      DELETE FROM @filtered_jobs  
      WHERE (type <> 2) -- IE. Delete all the non-multi-server jobs  
  END  
  
  -- Step 5: Filter on dates  
  IF (@date_comparator IS NOT NULL)  
  BEGIN  
    IF (@date_created IS NOT NULL)  
    BEGIN  
      IF (@date_comparator = '=')  
        DELETE FROM @filtered_jobs WHERE (date_created <> @date_created)  
      IF (@date_comparator = '>')  
        DELETE FROM @filtered_jobs WHERE (date_created <= @date_created)  
      IF (@date_comparator = '<')  
        DELETE FROM @filtered_jobs WHERE (date_created >= @date_created)  
    END  
    IF (@date_last_modified IS NOT NULL)  
    BEGIN  
      IF (@date_comparator = '=')  
        DELETE FROM @filtered_jobs WHERE (date_last_modified <> @date_last_modified)  
      IF (@date_comparator = '>')  
        DELETE FROM @filtered_jobs WHERE (date_last_modified <= @date_last_modified)  
      IF (@date_comparator = '<')  
        DELETE FROM @filtered_jobs WHERE (date_last_modified >= @date_last_modified)  
    END  
  END  
  
  SELECT sjv.name,  
         sjv.enabled,  
         last_run_status= case  
         when fj.last_run_outcome = 0 THEN 'Failed'  
         when fj.last_run_outcome = 1 THEN 'Succeeded'  
         when fj.last_run_outcome = 3 THEN 'Canceled/Running'  
         when fj.last_run_outcome = 5 THEN 'Unknown' end,  
         STATUS=   
CASE  
WHEN ja.start_execution_date IS NOT NULL AND  
ja.stop_execution_date IS NULL THEN 'Running'  
ELSE  
'Idle'  
END,     
duration_Min=isnull(datediff(MI,ja.start_execution_date,ja.stop_execution_date), 0),  
last_execution_date=ja.stop_execution_date,  
        ja.next_scheduled_run_date  
         FROM @filtered_jobs                         fj  
       LEFT OUTER JOIN msdb.dbo.sysjobs_view  sjv ON (fj.job_id = sjv.job_id)  
       LEFT OUTER JOIN msdb.dbo.sysjobactivity  ja ON (fj.job_id = ja.job_id)  
       LEFT OUTER JOIN msdb.dbo.sysoperators  so1 ON (sjv.notify_email_operator_id = so1.id)  
       LEFT OUTER JOIN msdb.dbo.sysoperators  so2 ON (sjv.notify_netsend_operator_id = so2.id)  
       LEFT OUTER JOIN msdb.dbo.sysoperators  so3 ON (sjv.notify_page_operator_id = so3.id)  
       LEFT OUTER JOIN msdb.dbo.syscategories sc  ON (sjv.category_id = sc.category_id)   
       where  
       ja.start_execution_date = (select MAX(start_execution_date) from msdb.dbo.sysjobactivity  ja2 where  
       ja.job_id = ja2.job_id)  
       and (
       (last_run_outcome <> 1 ) or
(isnull(datediff(MI,ja.start_execution_date,ja.stop_execution_date), 0) > 5) or
(start_execution_date IS NOT NULL AND  ja.stop_execution_date is null))
        
  ORDER BY sjv.name  
  
END
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_get_composite_job_info]    Script Date: 02/11/2012 12:34:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc  [dbo].[sp_dba_get_composite_job_info]  
  @job_id             UNIQUEIDENTIFIER = NULL,  
  @job_type           VARCHAR(12)      = NULL,  -- LOCAL or MULTI-SERVER  
  @owner_login_name   sysname          = NULL,  
  @subsystem          NVARCHAR(40)     = NULL,  
  @category_id        INT              = NULL,  
  @enabled            TINYINT          = NULL,  
  @execution_status   INT              = NULL,  -- 0 = Not idle or suspended, 1 = Executing, 2 = Waiting For Thread, 3 = Between Retries, 4 = Idle, 5 = Suspended, [6 = WaitingForStepToFinish], 7 = PerformingCompletionActions  
  @date_comparator    CHAR(1)          = NULL,  -- >, < or =  
  @date_created       DATETIME         = NULL,  
  @date_last_modified DATETIME         = NULL,  
  @description        NVARCHAR(512)    = NULL,  -- We do a LIKE on this so it can include wildcards  
  @schedule_id        INT              = NULL   -- if supplied only return the jobs that use this schedule  
  WITH EXECUTE AS OWNER
AS  
BEGIN  
  DECLARE @can_see_all_running_jobs INT  
  DECLARE @job_owner   sysname  
  
  SET NOCOUNT ON  
  
  -- By 'composite' we mean a combination of sysjobs and xp_sqlagent_enum_jobs data.  
  -- This proc should only ever be called by sp_help_job, so we don't verify the  
  -- parameters (sp_help_job has already done this).  
  
  -- Step 1: Create intermediate work tables  
  DECLARE @job_execution_state TABLE (job_id                  UNIQUEIDENTIFIER NOT NULL,  
                                     date_started            INT              NOT NULL,  
                                     time_started            INT              NOT NULL,  
                                     execution_job_status    INT              NOT NULL,  
                                     execution_step_id       INT              NULL,  
                                     execution_step_name     sysname          COLLATE database_default NULL,  
                                     execution_retry_attempt INT              NOT NULL,  
                                     next_run_date           INT              NOT NULL,  
                                     next_run_time           INT              NOT NULL,  
                                     next_run_schedule_id    INT              NOT NULL)  
  DECLARE @filtered_jobs TABLE (job_id                   UNIQUEIDENTIFIER NOT NULL,  
                               date_created             DATETIME         NOT NULL,  
                               date_last_modified       DATETIME         NOT NULL,  
                               current_execution_status INT              NULL,  
                               current_execution_step   sysname          COLLATE database_default NULL,  
                               current_retry_attempt    INT              NULL,  
                               last_run_date            INT              NOT NULL,  
                               last_run_time            INT              NOT NULL,  
                               last_run_outcome         INT              NOT NULL,  
                               next_run_date            INT              NULL,  
                               next_run_time            INT              NULL,  
                               next_run_schedule_id     INT              NULL,  
                               type                     INT              NOT NULL)  
  DECLARE @xp_results TABLE (job_id                UNIQUEIDENTIFIER NOT NULL,  
                            last_run_date         INT              NOT NULL,  
                            last_run_time         INT              NOT NULL,  
                            next_run_date         INT              NOT NULL,  
                            next_run_time         INT              NOT NULL,  
                            next_run_schedule_id  INT              NOT NULL,  
                            requested_to_run      INT              NOT NULL, -- BOOL  
                            request_source        INT              NOT NULL,  
                            request_source_id     sysname          COLLATE database_default NULL,  
                            running               INT              NOT NULL, -- BOOL  
                            current_step          INT              NOT NULL,  
                            current_retry_attempt INT              NOT NULL,  
                            job_state             INT              NOT NULL)  
  
  -- Step 2: Capture job execution information (for local jobs only since that's all SQLServerAgent caches)  
  SELECT @can_see_all_running_jobs = ISNULL(IS_SRVROLEMEMBER(N'sysadmin'), 0)  
  IF (@can_see_all_running_jobs = 0)  
  BEGIN  
    SELECT @can_see_all_running_jobs = ISNULL(IS_MEMBER(N'SQLAgentReaderRole'), 0)  
  END  
  SELECT @job_owner = SUSER_SNAME()  
  
  IF ((@@microsoftversion / 0x01000000) >= 8) -- SQL Server 8.0 or greater  
    INSERT INTO @xp_results  
    EXECUTE master.dbo.xp_sqlagent_enum_jobs @can_see_all_running_jobs, @job_owner, @job_id  
  ELSE  
    INSERT INTO @xp_results  
    EXECUTE master.dbo.xp_sqlagent_enum_jobs @can_see_all_running_jobs, @job_owner  
  
  INSERT INTO @job_execution_state  
  SELECT xpr.job_id,  
         xpr.last_run_date,  
         xpr.last_run_time,  
         xpr.job_state,  
         sjs.step_id,  
         sjs.step_name,  
         xpr.current_retry_attempt,  
         xpr.next_run_date,  
         xpr.next_run_time,  
         xpr.next_run_schedule_id  
  FROM @xp_results                          xpr  
       LEFT OUTER JOIN msdb.dbo.sysjobsteps sjs ON ((xpr.job_id = sjs.job_id) AND (xpr.current_step = sjs.step_id)),  
       msdb.dbo.sysjobs_view                sjv  
  WHERE (sjv.job_id = xpr.job_id)  
  
  -- Step 3: Filter on everything but dates and job_type  
  IF ((@subsystem        IS NULL) AND  
      (@owner_login_name IS NULL) AND  
      (@enabled          IS NULL) AND  
      (@category_id      IS NULL) AND  
      (@execution_status IS NULL) AND  
      (@description      IS NULL) AND  
      (@job_id           IS NULL))  
  BEGIN  
    -- Optimize for the frequently used case...  
    INSERT INTO @filtered_jobs  
    SELECT sjv.job_id,  
           sjv.date_created,  
           sjv.date_modified,  
           ISNULL(jes.execution_job_status, 4), -- Will be NULL if the job is non-local or is not in @job_execution_state (NOTE: 4 = STATE_IDLE)  
           CASE ISNULL(jes.execution_step_id, 0)  
             WHEN 0 THEN NULL                   -- Will be NULL if the job is non-local or is not in @job_execution_state  
             ELSE CONVERT(NVARCHAR, jes.execution_step_id) + N' (' + jes.execution_step_name + N')'  
           END,  
           jes.execution_retry_attempt,         -- Will be NULL if the job is non-local or is not in @job_execution_state  
           0,  -- last_run_date placeholder    (we'll fix it up in step 3.3)  
           0,  -- last_run_time placeholder    (we'll fix it up in step 3.3)  
           5,  -- last_run_outcome placeholder (we'll fix it up in step 3.3 - NOTE: We use 5 just in case there are no jobservers for the job)  
           jes.next_run_date,                   -- Will be NULL if the job is non-local or is not in @job_execution_state  
           jes.next_run_time,                   -- Will be NULL if the job is non-local or is not in @job_execution_state  
           jes.next_run_schedule_id,            -- Will be NULL if the job is non-local or is not in @job_execution_state  
           0   -- type placeholder             (we'll fix it up in step 3.4)  
    FROM msdb.dbo.sysjobs_view                sjv  
         LEFT OUTER JOIN @job_execution_state jes ON (sjv.job_id = jes.job_id)  
    WHERE ((@schedule_id IS NULL)  
      OR   (EXISTS(SELECT *   
                 FROM sysjobschedules as js  
                 WHERE (sjv.job_id = js.job_id)  
                   AND (js.schedule_id = @schedule_id))))  
  END  
  ELSE  
  BEGIN  
    INSERT INTO @filtered_jobs  
    SELECT DISTINCT  
           sjv.job_id,  
           sjv.date_created,  
           sjv.date_modified,  
           ISNULL(jes.execution_job_status, 4), -- Will be NULL if the job is non-local or is not in @job_execution_state (NOTE: 4 = STATE_IDLE)  
           CASE ISNULL(jes.execution_step_id, 0)  
             WHEN 0 THEN NULL                   -- Will be NULL if the job is non-local or is not in @job_execution_state  
             ELSE CONVERT(NVARCHAR, jes.execution_step_id) + N' (' + jes.execution_step_name + N')'  
           END,  
           jes.execution_retry_attempt,         -- Will be NULL if the job is non-local or is not in @job_execution_state  
           0,  -- last_run_date placeholder    (we'll fix it up in step 3.3)  
           0,  -- last_run_time placeholder    (we'll fix it up in step 3.3)  
           5,  -- last_run_outcome placeholder (we'll fix it up in step 3.3 - NOTE: We use 5 just in case there are no jobservers for the job)  
           jes.next_run_date,                   -- Will be NULL if the job is non-local or is not in @job_execution_state  
           jes.next_run_time,                   -- Will be NULL if the job is non-local or is not in @job_execution_state  
           jes.next_run_schedule_id,            -- Will be NULL if the job is non-local or is not in @job_execution_state  
           0   -- type placeholder             (we'll fix it up in step 3.4)  
    FROM msdb.dbo.sysjobs_view                sjv  
         LEFT OUTER JOIN @job_execution_state jes ON (sjv.job_id = jes.job_id)  
         LEFT OUTER JOIN msdb.dbo.sysjobsteps sjs ON (sjv.job_id = sjs.job_id)  
    WHERE ((@subsystem        IS NULL) OR (sjs.subsystem            = @subsystem))  
      AND ((@owner_login_name IS NULL)   
          OR (sjv.owner_sid            = dbo.SQLAGENT_SUSER_SID(@owner_login_name)))--force case insensitive comparation for NT users  
      AND ((@enabled          IS NULL) OR (sjv.enabled              = @enabled))  
      AND ((@category_id      IS NULL) OR (sjv.category_id          = @category_id))  
      AND ((@execution_status IS NULL) OR ((@execution_status > 0) AND (jes.execution_job_status = @execution_status))  
                                       OR ((@execution_status = 0) AND (jes.execution_job_status <> 4) AND (jes.execution_job_status <> 5)))  
      AND ((@description      IS NULL) OR (sjv.description       LIKE @description))  
      AND ((@job_id           IS NULL) OR (sjv.job_id               = @job_id))  
      AND ((@schedule_id IS NULL)  
        OR (EXISTS(SELECT *   
                 FROM sysjobschedules as js  
                 WHERE (sjv.job_id = js.job_id)  
                   AND (js.schedule_id = @schedule_id))))  
  END  
  
  -- Step 3.1: Change the execution status of non-local jobs from 'Idle' to 'Unknown'  
  UPDATE @filtered_jobs  
  SET current_execution_status = NULL  
  WHERE (current_execution_status = 4)  
    AND (job_id IN (SELECT job_id  
                    FROM msdb.dbo.sysjobservers  
                    WHERE (server_id <> 0)))  
  
  -- Step 3.2: Check that if the user asked to see idle jobs that we still have some.  
  --           If we don't have any then the query should return no rows.  
  IF (@execution_status = 4) AND  
     (NOT EXISTS (SELECT *  
                  FROM @filtered_jobs  
                  WHERE (current_execution_status = 4)))  
  BEGIN  
    DELETE FROM @filtered_jobs  
  END  
  
  -- Step 3.3: Populate the last run date/time/outcome [this is a little tricky since for  
  --           multi-server jobs there are multiple last run details in sysjobservers, so  
  --           we simply choose the most recent].  
  IF (EXISTS (SELECT *  
              FROM msdb.dbo.systargetservers))  
  BEGIN  
    UPDATE @filtered_jobs  
    SET last_run_date = sjs.last_run_date,  
        last_run_time = sjs.last_run_time,  
        last_run_outcome = sjs.last_run_outcome  
    FROM @filtered_jobs         fj,  
         msdb.dbo.sysjobservers sjs  
    WHERE (CONVERT(FLOAT, sjs.last_run_date) * 1000000) + sjs.last_run_time =  
           (SELECT MAX((CONVERT(FLOAT, last_run_date) * 1000000) + last_run_time)  
            FROM msdb.dbo.sysjobservers  
            WHERE (job_id = sjs.job_id))  
      AND (fj.job_id = sjs.job_id)  
  END  
  ELSE  
  BEGIN  
    UPDATE @filtered_jobs  
    SET last_run_date = sjs.last_run_date,  
        last_run_time = sjs.last_run_time,  
        last_run_outcome = sjs.last_run_outcome  
    FROM @filtered_jobs         fj,  
         msdb.dbo.sysjobservers sjs  
    WHERE (fj.job_id = sjs.job_id)  
  END  
  
  -- Step 3.4 : Set the type of the job to local (1) or multi-server (2)  
  --            NOTE: If the job has no jobservers then it wil have a type of 0 meaning  
  --                  unknown.  This is marginally inconsistent with the behaviour of  
  --                  defaulting the category of a new job to [Uncategorized (Local)], but  
  --                  prevents incompletely defined jobs from erroneously showing up as valid  
  --                  local jobs.  
  UPDATE @filtered_jobs  
  SET type = 1 -- LOCAL  
  FROM @filtered_jobs         fj,  
       msdb.dbo.sysjobservers sjs  
  WHERE (fj.job_id = sjs.job_id)  
    AND (server_id = 0)  
  UPDATE @filtered_jobs  
  SET type = 2 -- MULTI-SERVER  
  FROM @filtered_jobs         fj,  
       msdb.dbo.sysjobservers sjs  
  WHERE (fj.job_id = sjs.job_id)  
    AND (server_id <> 0)  
  
  -- Step 4: Filter on job_type  
  IF (@job_type IS NOT NULL)  
  BEGIN  
    IF (UPPER(@job_type collate SQL_Latin1_General_CP1_CS_AS) = 'LOCAL')  
      DELETE FROM @filtered_jobs  
      WHERE (type <> 1) -- IE. Delete all the non-local jobs  
    IF (UPPER(@job_type collate SQL_Latin1_General_CP1_CS_AS) = 'MULTI-SERVER')  
      DELETE FROM @filtered_jobs  
      WHERE (type <> 2) -- IE. Delete all the non-multi-server jobs  
  END  
  
  -- Step 5: Filter on dates  
  IF (@date_comparator IS NOT NULL)  
  BEGIN  
    IF (@date_created IS NOT NULL)  
    BEGIN  
      IF (@date_comparator = '=')  
        DELETE FROM @filtered_jobs WHERE (date_created <> @date_created)  
      IF (@date_comparator = '>')  
        DELETE FROM @filtered_jobs WHERE (date_created <= @date_created)  
      IF (@date_comparator = '<')  
        DELETE FROM @filtered_jobs WHERE (date_created >= @date_created)  
    END  
    IF (@date_last_modified IS NOT NULL)  
    BEGIN  
      IF (@date_comparator = '=')  
        DELETE FROM @filtered_jobs WHERE (date_last_modified <> @date_last_modified)  
      IF (@date_comparator = '>')  
        DELETE FROM @filtered_jobs WHERE (date_last_modified <= @date_last_modified)  
      IF (@date_comparator = '<')  
        DELETE FROM @filtered_jobs WHERE (date_last_modified >= @date_last_modified)  
    END  
  END  
  
  -- Return the result set (NOTE: No filtering occurs here)  
  SELECT sjv.name,  
         sjv.enabled,  
         last_run_status= case  
         when fj.last_run_outcome = 0 THEN 'Failed'  
         when fj.last_run_outcome = 1 THEN 'Succeeded'  
         when fj.last_run_outcome = 3 THEN 'Canceled/Running'  
         when fj.last_run_outcome = 5 THEN 'Unknown' end,  
         STATUS=   
CASE  
WHEN ja.start_execution_date IS NOT NULL AND  
ja.stop_execution_date IS NULL THEN 'Running'  
ELSE  
'Idle'  
END,     
duration_Min=isnull(datediff(MI,ja.start_execution_date,ja.stop_execution_date), 0),  
last_execution_date=ja.stop_execution_date,  
        ja.next_scheduled_run_date  
         FROM @filtered_jobs                         fj  
       LEFT OUTER JOIN msdb.dbo.sysjobs_view  sjv ON (fj.job_id = sjv.job_id)  
       LEFT OUTER JOIN msdb.dbo.sysjobactivity  ja ON (fj.job_id = ja.job_id)  
       LEFT OUTER JOIN msdb.dbo.sysoperators  so1 ON (sjv.notify_email_operator_id = so1.id)  
       LEFT OUTER JOIN msdb.dbo.sysoperators  so2 ON (sjv.notify_netsend_operator_id = so2.id)  
       LEFT OUTER JOIN msdb.dbo.sysoperators  so3 ON (sjv.notify_page_operator_id = so3.id)  
       LEFT OUTER JOIN msdb.dbo.syscategories sc  ON (sjv.category_id = sc.category_id)   
       where  
       ja.start_execution_date = (select MAX(start_execution_date) from msdb.dbo.sysjobactivity  ja2 where  
       ja.job_id = ja2.job_id)  
        
  ORDER BY sjv.name  
  
END
GO
/****** Object:  View [dbo].[sysdtslog90]    Script Date: 02/11/2012 12:34:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[sysdtslog90]
AS
	SELECT [id]
		  ,[event]
		  ,[computer]
		  ,[operator]
		  ,[source]
		  ,[sourceid]
		  ,[executionid]
		  ,[starttime]
		  ,[endtime]
		  ,[datacode]
		  ,[databytes]
		  ,[message]
	  FROM [msdb].[dbo].[sysssislog]
GO
/****** Object:  StoredProcedure [dbo].[sp_verify_subsystems]    Script Date: 02/11/2012 12:34:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[sp_verify_subsystems]
   @syssubsytems_refresh_needed BIT = 0
AS
BEGIN
  SET NOCOUNT ON
   
  DECLARE @retval         INT
  DECLARE @InstRootPath nvarchar(512)
  DECLARE @VersionRootPath nvarchar(512)
  DECLARE @ComRootPath nvarchar(512)
  DECLARE @DtsRootPath nvarchar(512)
  DECLARE @SQLPSPath nvarchar(512)
  DECLARE @DTExec nvarchar(512)
  DECLARE @DTExecExists INT
  DECLARE @ToolsPath nvarchar(512)

  IF ( (@syssubsytems_refresh_needed=1) OR (NOT EXISTS(select * from syssubsystems)) )
  BEGIN
     EXEC master.dbo.xp_instance_regread N'HKEY_LOCAL_MACHINE', N'SOFTWARE\Microsoft\MSSQLServer\Setup', N'SQLPath', @InstRootPath OUTPUT
     IF @InstRootPath IS NULL
     BEGIN
       RAISERROR(14658, -1, -1) WITH LOG
       RETURN (1)
     END
     SELECT @InstRootPath = @InstRootPath + N'\binn\'

     EXEC master.dbo.xp_regread N'HKEY_LOCAL_MACHINE', N'SOFTWARE\Microsoft\Microsoft Sql Server\100', N'VerSpecificRootDir', @VersionRootPath OUTPUT
     IF @VersionRootPath IS NULL
     BEGIN
       RAISERROR(14659, -1, -1) WITH LOG
       RETURN(1)
     END

     EXEC master.dbo.xp_regread N'HKEY_LOCAL_MACHINE', N'SOFTWARE\Microsoft\Microsoft SQL Server\100\SSIS\Setup\DTSPath', N'', @DtsRootPath OUTPUT, N'no_output'
     IF (@DtsRootPath IS NOT NULL)
     BEGIN
       SELECT @DtsRootPath  = @DtsRootPath  + N'Binn\'
       SELECT @DTExec = @DtsRootPath + N'DTExec.exe'
       CREATE TABLE #t (file_exists int, is_directory int, parent_directory_exists int)
       INSERT #t EXEC xp_fileexist @DTExec
       SELECT TOP 1 @DTExecExists=file_exists from #t
       DROP TABLE #t
       IF ((@DTExecExists IS NULL) OR (@DTExecExists = 0))
         SET @DtsRootPath = NULL
     END

     SELECT @ComRootPath  = @VersionRootPath  + N'COM\'

     create table #Platform(ID int,  Name  sysname, Internal_Value int NULL, Value nvarchar(512))
     insert #Platform exec master.dbo.xp_msver 'Platform'
     if EXISTS(select * from #Platform where Value like '%64%')
     EXEC master.dbo.xp_regread N'HKEY_LOCAL_MACHINE', N'SOFTWARE\Wow6432Node\Microsoft\Microsoft Sql Server\100\Tools\ClientSetup', N'SQLPath', @ToolsPath OUTPUT
  else
     EXEC master.dbo.xp_regread N'HKEY_LOCAL_MACHINE', N'SOFTWARE\Microsoft\Microsoft Sql Server\100\Tools\ClientSetup', N'SQLPath', @ToolsPath OUTPUT
     drop table #Platform
     SELECT @SQLPSPath  = @ToolsPath  + N'\Binn\SQLPS.exe'
     
     -- Procedure must start its own transaction if we don't have one already.
     DECLARE @TranCounter INT;
     SET @TranCounter = @@TRANCOUNT;
     IF @TranCounter = 0
     BEGIN
        BEGIN TRANSACTION;
     END

     -- Obtain processor count to determine maximum number of threads per subsystem
     DECLARE @xp_results TABLE
     (
     id              INT           NOT NULL,
     name            NVARCHAR(30)  COLLATE database_default NOT NULL,
     internal_value  INT           NULL,
     character_value NVARCHAR(212) COLLATE database_default NULL
     )
     INSERT INTO @xp_results
     EXECUTE master.dbo.xp_msver

     DECLARE @processor_count INT
     SELECT @processor_count = internal_value from @xp_results where id=16 -- ProcessorCount

     -- Modify database.
     BEGIN TRY

       --create subsystems
       --TSQL subsystem
       IF NOT EXISTS(SELECT * FROM syssubsystems WHERE subsystem = N'TSQL')
       INSERT syssubsystems
       VALUES
       (
          1, N'TSQL',14556, FORMATMESSAGE(14557), FORMATMESSAGE(14557), FORMATMESSAGE(14557), FORMATMESSAGE(14557), FORMATMESSAGE(14557), 20 * @processor_count
       )
       --ActiveScripting subsystem
       IF NOT EXISTS(SELECT * FROM syssubsystems WHERE subsystem = N'ActiveScripting')
       INSERT syssubsystems
       VALUES
       (
          2, N'ActiveScripting',  14555, @InstRootPath + N'SQLATXSS.DLL',NULL,N'ActiveScriptStart',N'ActiveScriptEvent',N'ActiveScriptStop', 10 * @processor_count
       )

       --CmdExec subsystem
       IF NOT EXISTS(SELECT * FROM syssubsystems WHERE subsystem = N'CmdExec')
       INSERT syssubsystems
       VALUES
       (
          3, N'CmdExec', 14550, @InstRootPath + N'SQLCMDSS.DLL',NULL,N'CmdExecStart',N'CmdEvent',N'CmdExecStop', 10 * @processor_count
       )

       --Snapshot subsystem
       IF NOT EXISTS(SELECT * FROM syssubsystems WHERE subsystem = N'Snapshot')
       INSERT syssubsystems
       VALUES
       (
          4, N'Snapshot',   14551, @InstRootPath + N'SQLREPSS.DLL', @ComRootPath + N'SNAPSHOT.EXE', N'ReplStart',N'ReplEvent',N'ReplStop',100 * @processor_count
       )

       --LogReader subsystem
       IF NOT EXISTS(SELECT * FROM syssubsystems WHERE subsystem = N'LogReader')
       INSERT syssubsystems
       VALUES
       (
          5, N'LogReader',  14552, @InstRootPath + N'SQLREPSS.DLL', @ComRootPath + N'logread.exe',N'ReplStart',N'ReplEvent',N'ReplStop',25 * @processor_count
       )

       --Distribution subsystem
       IF NOT EXISTS(SELECT * FROM syssubsystems WHERE subsystem = N'Distribution')
       INSERT syssubsystems
       VALUES
       (
          6, N'Distribution',  14553, @InstRootPath + N'SQLREPSS.DLL', @ComRootPath + N'DISTRIB.EXE',N'ReplStart',N'ReplEvent',N'ReplStop',100 * @processor_count
       )

       --Merge subsystem
       IF NOT EXISTS(SELECT * FROM syssubsystems WHERE subsystem = N'Merge')
       INSERT syssubsystems
       VALUES
       (
          7, N'Merge',   14554, @InstRootPath + N'SQLREPSS.DLL',@ComRootPath + N'REPLMERG.EXE',N'ReplStart',N'ReplEvent',N'ReplStop',100 * @processor_count
       )

       --QueueReader subsystem
       IF NOT EXISTS(SELECT * FROM syssubsystems WHERE subsystem = N'QueueReader')
       INSERT syssubsystems
       VALUES
       (
          8, N'QueueReader',   14581, @InstRootPath + N'SQLREPSS.dll',@ComRootPath + N'qrdrsvc.exe',N'ReplStart',N'ReplEvent',N'ReplStop',100 * @processor_count
       )

       --ANALYSISQUERY subsystem
       IF NOT EXISTS(SELECT * FROM syssubsystems WHERE subsystem = N'ANALYSISQUERY')
       INSERT syssubsystems
       VALUES
       (
          9, N'ANALYSISQUERY', 14513, @InstRootPath + N'SQLOLAPSS.DLL',NULL,N'OlapStart',N'OlapQueryEvent',N'OlapStop',100 * @processor_count
       )

       --ANALYSISCOMMAND subsystem
       IF NOT EXISTS(SELECT * FROM syssubsystems WHERE subsystem = N'ANALYSISCOMMAND')
       INSERT syssubsystems
       VALUES
       (
          10, N'ANALYSISCOMMAND', 14514, @InstRootPath + N'SQLOLAPSS.DLL',NULL,N'OlapStart',N'OlapCommandEvent',N'OlapStop',100 * @processor_count
       )

       IF(@DtsRootPath IS NOT NULL)
       BEGIN
          --DTS subsystem
          IF (NOT EXISTS(SELECT * FROM syssubsystems WHERE subsystem = N'SSIS') )
             INSERT syssubsystems
             VALUES
             (
                11, N'SSIS', 14538, @InstRootPath + N'SQLDTSSS.DLL',@DtsRootPath + N'DTExec.exe',N'DtsStart',N'DtsEvent',N'DtsStop',100 * @processor_count
             )
          ELSE
             UPDATE syssubsystems SET agent_exe = @DtsRootPath + N'DTExec.exe' WHERE subsystem = N'SSIS'
       END
       ELSE
       BEGIN
          IF EXISTS(SELECT * FROM syssubsystems WHERE subsystem = N'SSIS')
            DELETE FROM syssubsystems WHERE subsystem = N'SSIS' 
       END
       
       --PowerShell subsystem     
	   IF NOT EXISTS(SELECT * FROM syssubsystems WHERE subsystem = N'PowerShell')
	   INSERT syssubsystems
	   VALUES
	   (
		  12, N'PowerShell', 14698, @InstRootPath + N'SQLPOWERSHELLSS.DLL', @SQLPSPath, N'PowerShellStart',N'PowerShellEvent',N'PowerShellStop',2
	   )
	   

   END TRY
   BEGIN CATCH

       DECLARE @ErrorMessage NVARCHAR(400)
       DECLARE @ErrorSeverity INT
       DECLARE @ErrorState INT

       SELECT @ErrorMessage = ERROR_MESSAGE()
       SELECT @ErrorSeverity = ERROR_SEVERITY()
       SELECT @ErrorState = ERROR_STATE()

       -- Roll back the transaction that we started if we are not nested
       IF @TranCounter = 0
       BEGIN
         ROLLBACK TRANSACTION;
       END
       -- if we are nested inside another transaction just raise the 
       -- error and let the outer transaction do the rollback
       RAISERROR (@ErrorMessage, -- Message text.
                   @ErrorSeverity, -- Severity.
                   @ErrorState -- State.
                   )
       RETURN (1)                  
     END CATCH
  END --(NOT EXISTS(select * from syssubsystems))
  
  -- commit the transaction we started
  IF @TranCounter = 0
  BEGIN
    COMMIT TRANSACTION;
  END
  
  RETURN(0) -- Success
END
GO
/****** Object:  StoredProcedure [dbo].[sp_verify_subsystem]    Script Date: 02/11/2012 12:34:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[sp_verify_subsystem]
  @subsystem NVARCHAR(40)
AS
BEGIN
  DECLARE @retval         INT
  SET NOCOUNT ON

  -- this call will populate subsystems table if necessary
  EXEC @retval = msdb.dbo.sp_verify_subsystems
  IF @retval <> 0
     RETURN(@retval)

  -- Remove any leading/trailing spaces from parameters
  SELECT @subsystem = LTRIM(RTRIM(@subsystem))

  -- Make sure Dts is translated into new subsystem's name SSIS
  IF (@subsystem IS NOT NULL AND UPPER(@subsystem collate SQL_Latin1_General_CP1_CS_AS) = N'DTS')
  BEGIN
    SET @subsystem = N'SSIS'
  END

  IF EXISTS (SELECT * FROM syssubsystems 
          WHERE  UPPER(@subsystem collate SQL_Latin1_General_CP1_CS_AS) =
                 UPPER(subsystem collate SQL_Latin1_General_CP1_CS_AS))
    RETURN(0) -- Success
  ELSE
  BEGIN
    RAISERROR(14234, -1, -1, '@subsystem', 'sp_enum_sqlagent_subsystems')
    RETURN(1) -- Failure
  END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_jobProblem]    Script Date: 02/11/2012 12:34:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc  [dbo].[sp_dba_jobProblem]
  -- Individual job parameters
  @job_id                     UNIQUEIDENTIFIER = NULL,  -- If provided should NOT also provide job_name
  @job_name                   sysname          = NULL,  -- If provided should NOT also provide job_id
  @job_aspect                 VARCHAR(9)       = NULL,  -- JOB, STEPS, SCHEDULES, TARGETS or ALL
  -- Job set parameters
  @job_type                   VARCHAR(12)      = NULL,  -- LOCAL or MULTI-SERVER
  @owner_login_name           sysname          = NULL,
  @subsystem                  NVARCHAR(40)     = NULL,
  @category_name              sysname          = NULL,
  @enabled                    TINYINT          = NULL,
  @execution_status           INT              = NULL,  -- 1 = Executing, 2 = Waiting For Thread, 3 = Between Retries, 4 = Idle, 5 = Suspended, 6 = [obsolete], 7 = PerformingCompletionActions
  @date_comparator            CHAR(1)          = NULL,  -- >, < or =
  @date_created               DATETIME         = NULL,
  @date_last_modified         DATETIME         = NULL,
  @description                NVARCHAR(512)    = NULL   -- We do a LIKE on this so it can include wildcards
WITH EXECUTE AS OWNER

AS
BEGIN
  DECLARE @retval          INT
  DECLARE @category_id     INT
  DECLARE @job_id_as_char  VARCHAR(36)
  DECLARE @res_valid_range NVARCHAR(200)

  SET NOCOUNT ON

  -- Remove any leading/trailing spaces from parameters (except @owner_login_name)
  SELECT @job_name         = LTRIM(RTRIM(@job_name))
  SELECT @job_aspect       = LTRIM(RTRIM(@job_aspect))
  SELECT @job_type         = LTRIM(RTRIM(@job_type))
  SELECT @subsystem        = LTRIM(RTRIM(@subsystem))
  SELECT @category_name    = LTRIM(RTRIM(@category_name))
  SELECT @description      = LTRIM(RTRIM(@description))

  -- Turn [nullable] empty string parameters into NULLs
  IF (@job_name         = N'') SELECT @job_name = NULL
  IF (@job_aspect       = '')  SELECT @job_aspect = NULL
  IF (@job_type         = '')  SELECT @job_type = NULL
  IF (@owner_login_name = N'') SELECT @owner_login_name = NULL
  IF (@subsystem        = N'') SELECT @subsystem = NULL
  IF (@category_name    = N'') SELECT @category_name = NULL
  IF (@description      = N'') SELECT @description = NULL

  IF ((@job_id IS NOT NULL) OR (@job_name IS NOT NULL))
  BEGIN
    EXECUTE @retval = sp_verify_job_identifiers '@job_name',
                                                '@job_id',
                                                 @job_name OUTPUT,
                                                 @job_id   OUTPUT
    IF (@retval <> 0)
      RETURN(1) -- Failure
  END

  SELECT @job_id_as_char = CONVERT(VARCHAR(36), @job_id)

  -- If the user provided a job name or id but no aspect, default to ALL
  IF ((@job_name IS NOT NULL) OR (@job_id IS NOT NULL)) AND (@job_aspect IS NULL)
    SELECT @job_aspect = 'ALL'

  -- The caller must supply EITHER job name (or job id) and aspect OR one-or-more of the set
  -- parameters OR no parameters at all
  IF (((@job_name IS NOT NULL) OR (@job_id IS NOT NULL))
      AND ((@job_aspect          IS NULL)     OR
           (@job_type            IS NOT NULL) OR
           (@owner_login_name    IS NOT NULL) OR
           (@subsystem           IS NOT NULL) OR
           (@category_name       IS NOT NULL) OR
           (@enabled             IS NOT NULL) OR
           (@date_comparator     IS NOT NULL) OR
           (@date_created        IS NOT NULL) OR
           (@date_last_modified  IS NOT NULL)))
     OR
     ((@job_name IS NULL) AND (@job_id IS NULL) AND (@job_aspect IS NOT NULL))
  BEGIN
    RAISERROR(14280, -1, -1)
    RETURN(1) -- Failure
  END

  IF (@job_id IS NOT NULL)
  BEGIN
    -- Individual job...

    -- Check job aspect
    SELECT @job_aspect = UPPER(@job_aspect collate SQL_Latin1_General_CP1_CS_AS)
    IF (@job_aspect NOT IN ('JOB', 'STEPS', 'SCHEDULES', 'TARGETS', 'ALL'))
    BEGIN
      RAISERROR(14266, -1, -1, '@job_aspect', 'JOB, STEPS, SCHEDULES, TARGETS, ALL')
      RETURN(1) -- Failure
    END

    -- Generate results set...

    IF (@job_aspect IN ('JOB', 'ALL'))
    BEGIN
      IF (@job_aspect = 'ALL')
      BEGIN
        RAISERROR(14213, 0, 1)
        PRINT REPLICATE('=', DATALENGTH(FORMATMESSAGE(14213)) / 2)
      END
      EXECUTE sp_dba_get_composite_job_infoProblem @job_id,
                                        @job_type,
                                        @owner_login_name,
                                        @subsystem,
                                        @category_id,
                                        @enabled,
                                        @execution_status,
                                        @date_comparator,
                                        @date_created,
                                        @date_last_modified,
                                        @description
    END

    IF (@job_aspect IN ('STEPS', 'ALL'))
    BEGIN
      IF (@job_aspect = 'ALL')
      BEGIN
        PRINT ''
        RAISERROR(14214, 0, 1)
        PRINT REPLICATE('=', DATALENGTH(FORMATMESSAGE(14214)) / 2)
      END
      EXECUTE ('EXECUTE sp_help_jobstep @job_id = ''' + @job_id_as_char + ''', @suffix = 1')
    END

    IF (@job_aspect IN ('SCHEDULES', 'ALL'))
    BEGIN
      IF (@job_aspect = 'ALL')
      BEGIN
        PRINT ''
        RAISERROR(14215, 0, 1)
        PRINT REPLICATE('=', DATALENGTH(FORMATMESSAGE(14215)) / 2)
      END
      EXECUTE ('EXECUTE sp_help_jobschedule @job_id = ''' + @job_id_as_char + '''')
    END

    IF (@job_aspect IN ('TARGETS', 'ALL'))
    BEGIN
      IF (@job_aspect = 'ALL')
      BEGIN
        PRINT ''
        RAISERROR(14216, 0, 1)
        PRINT REPLICATE('=', DATALENGTH(FORMATMESSAGE(14216)) / 2)
      END
      EXECUTE ('EXECUTE sp_help_jobserver @job_id = ''' + @job_id_as_char + ''', @show_last_run_details = 1')
    END
  END
  ELSE
  BEGIN
    -- Set of jobs...

    -- Check job type
    IF (@job_type IS NOT NULL)
    BEGIN
      SELECT @job_type = UPPER(@job_type collate SQL_Latin1_General_CP1_CS_AS)
      IF (@job_type NOT IN ('LOCAL', 'MULTI-SERVER'))
      BEGIN
        RAISERROR(14266, -1, -1, '@job_type', 'LOCAL, MULTI-SERVER')
        RETURN(1) -- Failure
      END
    END

    -- Check owner
    IF (@owner_login_name IS NOT NULL)
    BEGIN
      IF (SUSER_SID(@owner_login_name, 0) IS NULL)--force case insensitive comparation for NT users
      BEGIN
        RAISERROR(14262, -1, -1, '@owner_login_name', @owner_login_name)
        RETURN(1) -- Failure
      END
    END

    -- Check subsystem
    IF (@subsystem IS NOT NULL)
    BEGIN
      EXECUTE @retval = sp_verify_subsystem @subsystem
      IF (@retval <> 0)
        RETURN(1) -- Failure
    END

    -- Check job category
    IF (@category_name IS NOT NULL)
    BEGIN
      SELECT @category_id = category_id
      FROM msdb.dbo.syscategories
      WHERE (category_class = 1) -- Job
        AND (name = @category_name)
      IF (@category_id IS NULL)
      BEGIN
        RAISERROR(14262, -1, -1, '@category_name', @category_name)
        RETURN(1) -- Failure
      END
    END

    -- Check enabled state
    IF (@enabled IS NOT NULL) AND (@enabled NOT IN (0, 1))
    BEGIN
      RAISERROR(14266, -1, -1, '@enabled', '0, 1')
      RETURN(1) -- Failure
    END

    -- Check current execution status
    IF (@execution_status IS NOT NULL)
    BEGIN
      IF (@execution_status NOT IN (0, 1, 2, 3, 4, 5, 7))
      BEGIN
        SELECT @res_valid_range = FORMATMESSAGE(14204)
        RAISERROR(14266, -1, -1, '@execution_status', @res_valid_range)
        RETURN(1) -- Failure
      END
    END

    -- If a date comparator is supplied, we must have either a date-created or date-last-modified
    IF ((@date_comparator IS NOT NULL) AND (@date_created IS NOT NULL) AND (@date_last_modified IS NOT NULL)) OR
       ((@date_comparator IS NULL)     AND ((@date_created IS NOT NULL) OR (@date_last_modified IS NOT NULL)))
    BEGIN
      RAISERROR(14282, -1, -1)
      RETURN(1) -- Failure
    END

    -- Check dates / comparator
    IF (@date_comparator IS NOT NULL) AND (@date_comparator NOT IN ('=', '<', '>'))
    BEGIN
      RAISERROR(14266, -1, -1, '@date_comparator', '=, >, <')
      RETURN(1) -- Failure
    END
    IF (@date_created IS NOT NULL) AND
       ((@date_created < '19900101') OR (@date_created > '99991231 23:59'))
    BEGIN
      RAISERROR(14266, -1, -1, '@date_created', '1990-01-01 12:00am .. 9999-12-31 11:59pm')
      RETURN(1) -- Failure
    END
    IF (@date_last_modified IS NOT NULL) AND
       ((@date_last_modified < '19900101') OR (@date_last_modified > '99991231 23:59'))
    BEGIN
      RAISERROR(14266, -1, -1, '@date_last_modified', '1990-01-01 12:00am .. 9999-12-31 11:59pm')
      RETURN(1) -- Failure
    END

    -- Generate results set...
    EXECUTE sp_dba_get_composite_job_infoProblem @job_id,
                                      @job_type,
                                      @owner_login_name,
                                      @subsystem,
                                      @category_id,
                                      @enabled,
                                      @execution_status,
                                      @date_comparator,
                                      @date_created,
                                      @date_last_modified,
                                      @description
  END

  RETURN(0) -- Success
END
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_job]    Script Date: 02/11/2012 12:34:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc  [dbo].[sp_dba_job]
  -- Individual job parameters
  @job_id                     UNIQUEIDENTIFIER = NULL,  -- If provided should NOT also provide job_name
  @job_name                   sysname          = NULL,  -- If provided should NOT also provide job_id
  @job_aspect                 VARCHAR(9)       = NULL,  -- JOB, STEPS, SCHEDULES, TARGETS or ALL
  -- Job set parameters
  @job_type                   VARCHAR(12)      = NULL,  -- LOCAL or MULTI-SERVER
  @owner_login_name           sysname          = NULL,
  @subsystem                  NVARCHAR(40)     = NULL,
  @category_name              sysname          = NULL,
  @enabled                    TINYINT          = NULL,
  @execution_status           INT              = NULL,  -- 1 = Executing, 2 = Waiting For Thread, 3 = Between Retries, 4 = Idle, 5 = Suspended, 6 = [obsolete], 7 = PerformingCompletionActions
  @date_comparator            CHAR(1)          = NULL,  -- >, < or =
  @date_created               DATETIME         = NULL,
  @date_last_modified         DATETIME         = NULL,
  @description                NVARCHAR(512)    = NULL   -- We do a LIKE on this so it can include wildcards
WITH EXECUTE AS OWNER

AS
BEGIN
  DECLARE @retval          INT
  DECLARE @category_id     INT
  DECLARE @job_id_as_char  VARCHAR(36)
  DECLARE @res_valid_range NVARCHAR(200)

  SET NOCOUNT ON

  -- Remove any leading/trailing spaces from parameters (except @owner_login_name)
  SELECT @job_name         = LTRIM(RTRIM(@job_name))
  SELECT @job_aspect       = LTRIM(RTRIM(@job_aspect))
  SELECT @job_type         = LTRIM(RTRIM(@job_type))
  SELECT @subsystem        = LTRIM(RTRIM(@subsystem))
  SELECT @category_name    = LTRIM(RTRIM(@category_name))
  SELECT @description      = LTRIM(RTRIM(@description))

  -- Turn [nullable] empty string parameters into NULLs
  IF (@job_name         = N'') SELECT @job_name = NULL
  IF (@job_aspect       = '')  SELECT @job_aspect = NULL
  IF (@job_type         = '')  SELECT @job_type = NULL
  IF (@owner_login_name = N'') SELECT @owner_login_name = NULL
  IF (@subsystem        = N'') SELECT @subsystem = NULL
  IF (@category_name    = N'') SELECT @category_name = NULL
  IF (@description      = N'') SELECT @description = NULL

  IF ((@job_id IS NOT NULL) OR (@job_name IS NOT NULL))
  BEGIN
    EXECUTE @retval = sp_verify_job_identifiers '@job_name',
                                                '@job_id',
                                                 @job_name OUTPUT,
                                                 @job_id   OUTPUT
    IF (@retval <> 0)
      RETURN(1) -- Failure
  END

  SELECT @job_id_as_char = CONVERT(VARCHAR(36), @job_id)

  -- If the user provided a job name or id but no aspect, default to ALL
  IF ((@job_name IS NOT NULL) OR (@job_id IS NOT NULL)) AND (@job_aspect IS NULL)
    SELECT @job_aspect = 'ALL'

  -- The caller must supply EITHER job name (or job id) and aspect OR one-or-more of the set
  -- parameters OR no parameters at all
  IF (((@job_name IS NOT NULL) OR (@job_id IS NOT NULL))
      AND ((@job_aspect          IS NULL)     OR
           (@job_type            IS NOT NULL) OR
           (@owner_login_name    IS NOT NULL) OR
           (@subsystem           IS NOT NULL) OR
           (@category_name       IS NOT NULL) OR
           (@enabled             IS NOT NULL) OR
           (@date_comparator     IS NOT NULL) OR
           (@date_created        IS NOT NULL) OR
           (@date_last_modified  IS NOT NULL)))
     OR
     ((@job_name IS NULL) AND (@job_id IS NULL) AND (@job_aspect IS NOT NULL))
  BEGIN
    RAISERROR(14280, -1, -1)
    RETURN(1) -- Failure
  END

  IF (@job_id IS NOT NULL)
  BEGIN
    -- Individual job...

    -- Check job aspect
    SELECT @job_aspect = UPPER(@job_aspect collate SQL_Latin1_General_CP1_CS_AS)
    IF (@job_aspect NOT IN ('JOB', 'STEPS', 'SCHEDULES', 'TARGETS', 'ALL'))
    BEGIN
      RAISERROR(14266, -1, -1, '@job_aspect', 'JOB, STEPS, SCHEDULES, TARGETS, ALL')
      RETURN(1) -- Failure
    END

    -- Generate results set...

    IF (@job_aspect IN ('JOB', 'ALL'))
    BEGIN
      IF (@job_aspect = 'ALL')
      BEGIN
        RAISERROR(14213, 0, 1)
        PRINT REPLICATE('=', DATALENGTH(FORMATMESSAGE(14213)) / 2)
      END
      EXECUTE sp_dba_get_composite_job_info @job_id,
                                        @job_type,
                                        @owner_login_name,
                                        @subsystem,
                                        @category_id,
                                        @enabled,
                                        @execution_status,
                                        @date_comparator,
                                        @date_created,
                                        @date_last_modified,
                                        @description
    END

    IF (@job_aspect IN ('STEPS', 'ALL'))
    BEGIN
      IF (@job_aspect = 'ALL')
      BEGIN
        PRINT ''
        RAISERROR(14214, 0, 1)
        PRINT REPLICATE('=', DATALENGTH(FORMATMESSAGE(14214)) / 2)
      END
      EXECUTE ('EXECUTE sp_help_jobstep @job_id = ''' + @job_id_as_char + ''', @suffix = 1')
    END

    IF (@job_aspect IN ('SCHEDULES', 'ALL'))
    BEGIN
      IF (@job_aspect = 'ALL')
      BEGIN
        PRINT ''
        RAISERROR(14215, 0, 1)
        PRINT REPLICATE('=', DATALENGTH(FORMATMESSAGE(14215)) / 2)
      END
      EXECUTE ('EXECUTE sp_help_jobschedule @job_id = ''' + @job_id_as_char + '''')
    END

    IF (@job_aspect IN ('TARGETS', 'ALL'))
    BEGIN
      IF (@job_aspect = 'ALL')
      BEGIN
        PRINT ''
        RAISERROR(14216, 0, 1)
        PRINT REPLICATE('=', DATALENGTH(FORMATMESSAGE(14216)) / 2)
      END
      EXECUTE ('EXECUTE sp_help_jobserver @job_id = ''' + @job_id_as_char + ''', @show_last_run_details = 1')
    END
  END
  ELSE
  BEGIN
    -- Set of jobs...

    -- Check job type
    IF (@job_type IS NOT NULL)
    BEGIN
      SELECT @job_type = UPPER(@job_type collate SQL_Latin1_General_CP1_CS_AS)
      IF (@job_type NOT IN ('LOCAL', 'MULTI-SERVER'))
      BEGIN
        RAISERROR(14266, -1, -1, '@job_type', 'LOCAL, MULTI-SERVER')
        RETURN(1) -- Failure
      END
    END

    -- Check owner
    IF (@owner_login_name IS NOT NULL)
    BEGIN
      IF (SUSER_SID(@owner_login_name, 0) IS NULL)--force case insensitive comparation for NT users
      BEGIN
        RAISERROR(14262, -1, -1, '@owner_login_name', @owner_login_name)
        RETURN(1) -- Failure
      END
    END

    -- Check subsystem
    IF (@subsystem IS NOT NULL)
    BEGIN
      EXECUTE @retval = sp_verify_subsystem @subsystem
      IF (@retval <> 0)
        RETURN(1) -- Failure
    END

    -- Check job category
    IF (@category_name IS NOT NULL)
    BEGIN
      SELECT @category_id = category_id
      FROM msdb.dbo.syscategories
      WHERE (category_class = 1) -- Job
        AND (name = @category_name)
      IF (@category_id IS NULL)
      BEGIN
        RAISERROR(14262, -1, -1, '@category_name', @category_name)
        RETURN(1) -- Failure
      END
    END

    -- Check enabled state
    IF (@enabled IS NOT NULL) AND (@enabled NOT IN (0, 1))
    BEGIN
      RAISERROR(14266, -1, -1, '@enabled', '0, 1')
      RETURN(1) -- Failure
    END

    -- Check current execution status
    IF (@execution_status IS NOT NULL)
    BEGIN
      IF (@execution_status NOT IN (0, 1, 2, 3, 4, 5, 7))
      BEGIN
        SELECT @res_valid_range = FORMATMESSAGE(14204)
        RAISERROR(14266, -1, -1, '@execution_status', @res_valid_range)
        RETURN(1) -- Failure
      END
    END

    -- If a date comparator is supplied, we must have either a date-created or date-last-modified
    IF ((@date_comparator IS NOT NULL) AND (@date_created IS NOT NULL) AND (@date_last_modified IS NOT NULL)) OR
       ((@date_comparator IS NULL)     AND ((@date_created IS NOT NULL) OR (@date_last_modified IS NOT NULL)))
    BEGIN
      RAISERROR(14282, -1, -1)
      RETURN(1) -- Failure
    END

    -- Check dates / comparator
    IF (@date_comparator IS NOT NULL) AND (@date_comparator NOT IN ('=', '<', '>'))
    BEGIN
      RAISERROR(14266, -1, -1, '@date_comparator', '=, >, <')
      RETURN(1) -- Failure
    END
    IF (@date_created IS NOT NULL) AND
       ((@date_created < '19900101') OR (@date_created > '99991231 23:59'))
    BEGIN
      RAISERROR(14266, -1, -1, '@date_created', '1990-01-01 12:00am .. 9999-12-31 11:59pm')
      RETURN(1) -- Failure
    END
    IF (@date_last_modified IS NOT NULL) AND
       ((@date_last_modified < '19900101') OR (@date_last_modified > '99991231 23:59'))
    BEGIN
      RAISERROR(14266, -1, -1, '@date_last_modified', '1990-01-01 12:00am .. 9999-12-31 11:59pm')
      RETURN(1) -- Failure
    END

    -- Generate results set...
    EXECUTE sp_dba_get_composite_job_info @job_id,
                                      @job_type,
                                      @owner_login_name,
                                      @subsystem,
                                      @category_id,
                                      @enabled,
                                      @execution_status,
                                      @date_comparator,
                                      @date_created,
                                      @date_last_modified,
                                      @description
  END

  RETURN(0) -- Success
END
GO
/****** Object:  Synonym [dbo].[syn_sysutility_ucp_computers]    Script Date: 02/11/2012 12:34:06 ******/
CREATE SYNONYM [dbo].[syn_sysutility_ucp_computers] FOR [sysutility_mdw].[sysutility_ucp_core].[latest_computers]
GO
/****** Object:  Synonym [dbo].[syn_sysutility_ucp_cpu_utilization]    Script Date: 02/11/2012 12:34:06 ******/
CREATE SYNONYM [dbo].[syn_sysutility_ucp_cpu_utilization] FOR [sysutility_mdw].[sysutility_ucp_core].[cpu_utilization]
GO
/****** Object:  Synonym [dbo].[syn_sysutility_ucp_dacs]    Script Date: 02/11/2012 12:34:06 ******/
CREATE SYNONYM [dbo].[syn_sysutility_ucp_dacs] FOR [sysutility_mdw].[sysutility_ucp_core].[latest_dacs]
GO
/****** Object:  Synonym [dbo].[syn_sysutility_ucp_databases]    Script Date: 02/11/2012 12:34:07 ******/
CREATE SYNONYM [dbo].[syn_sysutility_ucp_databases] FOR [sysutility_mdw].[sysutility_ucp_core].[latest_databases]
GO
/****** Object:  Synonym [dbo].[syn_sysutility_ucp_datafiles]    Script Date: 02/11/2012 12:34:07 ******/
CREATE SYNONYM [dbo].[syn_sysutility_ucp_datafiles] FOR [sysutility_mdw].[sysutility_ucp_core].[latest_datafiles]
GO
/****** Object:  Synonym [dbo].[syn_sysutility_ucp_filegroups]    Script Date: 02/11/2012 12:34:07 ******/
CREATE SYNONYM [dbo].[syn_sysutility_ucp_filegroups] FOR [sysutility_mdw].[sysutility_ucp_core].[latest_filegroups]
GO
/****** Object:  Synonym [dbo].[syn_sysutility_ucp_logfiles]    Script Date: 02/11/2012 12:34:07 ******/
CREATE SYNONYM [dbo].[syn_sysutility_ucp_logfiles] FOR [sysutility_mdw].[sysutility_ucp_core].[latest_logfiles]
GO
/****** Object:  Synonym [dbo].[syn_sysutility_ucp_smo_servers]    Script Date: 02/11/2012 12:34:07 ******/
CREATE SYNONYM [dbo].[syn_sysutility_ucp_smo_servers] FOR [sysutility_mdw].[sysutility_ucp_core].[latest_smo_servers]
GO
/****** Object:  Synonym [dbo].[syn_sysutility_ucp_space_utilization]    Script Date: 02/11/2012 12:34:07 ******/
CREATE SYNONYM [dbo].[syn_sysutility_ucp_space_utilization] FOR [sysutility_mdw].[sysutility_ucp_core].[space_utilization]
GO
/****** Object:  Synonym [dbo].[syn_sysutility_ucp_volumes]    Script Date: 02/11/2012 12:34:07 ******/
CREATE SYNONYM [dbo].[syn_sysutility_ucp_volumes] FOR [sysutility_mdw].[sysutility_ucp_core].[latest_volumes]
GO
/****** Object:  Default [DF__sysjobsch__next___33D4B598]    Script Date: 02/11/2012 12:33:19 ******/
ALTER TABLE [dbo].[sysjobschedules] ADD  DEFAULT ((0)) FOR [next_run_date]
GO
/****** Object:  Default [DF__sysjobsch__next___34C8D9D1]    Script Date: 02/11/2012 12:33:19 ******/
ALTER TABLE [dbo].[sysjobschedules] ADD  DEFAULT ((0)) FOR [next_run_time]
GO
/****** Object:  Default [DF__sysorigin__origi__117F9D94]    Script Date: 02/11/2012 12:33:19 ******/
ALTER TABLE [dbo].[sysoriginatingservers] ADD  DEFAULT ((1)) FOR [originating_server_id]
GO
/****** Object:  Default [DF__sysorigin__maste__1367E606]    Script Date: 02/11/2012 12:33:19 ******/
ALTER TABLE [dbo].[sysoriginatingservers] ADD  DEFAULT ((1)) FOR [master_server]
GO
/****** Object:  Default [DF__sysschedu__date___2C3393D0]    Script Date: 02/11/2012 12:33:21 ******/
ALTER TABLE [dbo].[sysschedules] ADD  DEFAULT (getdate()) FOR [date_created]
GO
/****** Object:  Default [DF__sysschedu__date___2D27B809]    Script Date: 02/11/2012 12:33:21 ******/
ALTER TABLE [dbo].[sysschedules] ADD  DEFAULT (getdate()) FOR [date_modified]
GO
/****** Object:  Default [DF__sysschedu__versi__2E1BDC42]    Script Date: 02/11/2012 12:33:21 ******/
ALTER TABLE [dbo].[sysschedules] ADD  DEFAULT ((1)) FOR [version_number]
GO
/****** Object:  Check [CK_master_server_MustBe_1]    Script Date: 02/11/2012 12:33:19 ******/
ALTER TABLE [dbo].[sysoriginatingservers]  WITH CHECK ADD  CONSTRAINT [CK_master_server_MustBe_1] CHECK  (([master_server]=(1)))
GO
ALTER TABLE [dbo].[sysoriginatingservers] CHECK CONSTRAINT [CK_master_server_MustBe_1]
GO
/****** Object:  Check [CK_originating_server_id_MustBe_1]    Script Date: 02/11/2012 12:33:19 ******/
ALTER TABLE [dbo].[sysoriginatingservers]  WITH CHECK ADD  CONSTRAINT [CK_originating_server_id_MustBe_1] CHECK  (([originating_server_id]=(1)))
GO
ALTER TABLE [dbo].[sysoriginatingservers] CHECK CONSTRAINT [CK_originating_server_id_MustBe_1]
GO
/****** Object:  ForeignKey [FK__sysjobsch__job_i__32E0915F]    Script Date: 02/11/2012 12:33:19 ******/
ALTER TABLE [dbo].[sysjobschedules]  WITH CHECK ADD FOREIGN KEY([job_id])
REFERENCES [dbo].[sysjobs] ([job_id])
GO
/****** Object:  ForeignKey [FK__sysjobsch__sched__31EC6D26]    Script Date: 02/11/2012 12:33:19 ******/
ALTER TABLE [dbo].[sysjobschedules]  WITH CHECK ADD FOREIGN KEY([schedule_id])
REFERENCES [dbo].[sysschedules] ([schedule_id])
GO
/****** Object:  ForeignKey [FK__sysjobact__job_i__1FCDBCEB]    Script Date: 02/11/2012 12:34:05 ******/
ALTER TABLE [dbo].[sysjobactivity]  WITH CHECK ADD FOREIGN KEY([job_id])
REFERENCES [dbo].[sysjobs] ([job_id])
ON DELETE CASCADE
GO
/****** Object:  ForeignKey [FK__sysjobact__sessi__1ED998B2]    Script Date: 02/11/2012 12:34:05 ******/
ALTER TABLE [dbo].[sysjobactivity]  WITH CHECK ADD FOREIGN KEY([session_id])
REFERENCES [dbo].[syssessions] ([session_id])
GO
