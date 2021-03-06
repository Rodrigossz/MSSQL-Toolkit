USE [model]
GO
/****** Object:  UserDefinedDataType [dbo].[tdSmallDesc]    Script Date: 04/27/2011 12:15:48 ******/
CREATE TYPE [dbo].[tdSmallDesc] FROM [varchar](100) NULL
GO
/****** Object:  UserDefinedDataType [dbo].[tdSecret]    Script Date: 04/27/2011 12:15:48 ******/
CREATE TYPE [dbo].[tdSecret] FROM [varchar](100) NULL
GO
/****** Object:  UserDefinedDataType [dbo].[tdObs]    Script Date: 04/27/2011 12:15:48 ******/
CREATE TYPE [dbo].[tdObs] FROM [varchar](8000) NOT NULL
GO
/****** Object:  UserDefinedDataType [dbo].[tdHwGuId]    Script Date: 04/27/2011 12:15:48 ******/
CREATE TYPE [dbo].[tdHwGuId] FROM [varchar](36) NULL
GO
/****** Object:  UserDefinedDataType [dbo].[tdEmail]    Script Date: 04/27/2011 12:15:48 ******/
CREATE TYPE [dbo].[tdEmail] FROM [varchar](100) NULL
GO
/****** Object:  UserDefinedDataType [dbo].[tdDesc]    Script Date: 04/27/2011 12:15:48 ******/
CREATE TYPE [dbo].[tdDesc] FROM [varchar](1000) NULL
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_OrphanUser]    Script Date: 04/27/2011 12:15:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_dba_OrphanUser]
as
ALTER USER [PSAFE\IIS_PROD] WITH LOGIN = [PSAFE\IIS_PROD]
GO
