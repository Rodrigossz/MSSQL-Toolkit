USE [PSafeDb]
GO

/****** Object:  View [dbo].[AcessoLogSemXml]    Script Date: 04/27/2011 12:29:17 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[AcessoLogSemXml]'))
DROP VIEW [dbo].[AcessoLogSemXml]
GO

/****** Object:  View [dbo].[InstalacaoSemXml]    Script Date: 04/27/2011 12:29:17 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[InstalacaoSemXml]'))
DROP VIEW [dbo].[InstalacaoSemXml]
GO

/****** Object:  View [dbo].[PcSemXml]    Script Date: 04/27/2011 12:29:17 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[PcSemXml]'))
DROP VIEW [dbo].[PcSemXml]
GO

/****** Object:  View [dbo].[vInstalacaoFalha]    Script Date: 04/27/2011 12:29:17 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vInstalacaoFalha]'))
DROP VIEW [dbo].[vInstalacaoFalha]
GO

USE [PSafeDb]
GO

/****** Object:  View [dbo].[AcessoLogSemXml]    Script Date: 04/27/2011 12:29:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[AcessoLogSemXml] as select id,datahora,acessoId,tipoLogId,qtdVirus from acessolog

GO

/****** Object:  View [dbo].[InstalacaoSemXml]    Script Date: 04/27/2011 12:29:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[InstalacaoSemXml] as select id,guId,dataHora,dataHoraSucesso,pcid from Instalacao  
GO

/****** Object:  View [dbo].[PcSemXml]    Script Date: 04/27/2011 12:29:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[PcSemXml] as select id,ativo,autoLogin,principalBackup,hwId,nome,dataHoraPontosIntalacao from Pc

GO

/****** Object:  View [dbo].[vInstalacaoFalha]    Script Date: 04/27/2011 12:29:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[vInstalacaoFalha]
as
SELECT 
id,
dataHora, 
configuracao.value('(//computername/node())[1]', 'nvarchar(30)') as ComputerName, configuracao
FROM Instalacao c (nolock) 
where pcId is null and datahorasucesso is null and convert(date,dataHora) >= DATEADD(dd,-2,getdate())
and not exists 
(select 1 from Instalacao c2 (nolock) where c.guId = c2.guId and c2.dataHora < c.dataHora and c2.pcId is not null)          
          
GO

