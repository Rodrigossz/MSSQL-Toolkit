USE [PSafeDb]
GO

/****** Object:  StoredProcedure [dbo].[pr_Acesso_sel_AssinaturaId]    Script Date: 04/27/2011 12:22:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Acesso_sel_AssinaturaId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Acesso_sel_AssinaturaId]
GO

/****** Object:  StoredProcedure [dbo].[pr_Acesso_sel_AssinaturaId_Total]    Script Date: 04/27/2011 12:22:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Acesso_sel_AssinaturaId_Total]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Acesso_sel_AssinaturaId_Total]
GO

/****** Object:  StoredProcedure [dbo].[pr_Acesso_sel_PcId_AssinaturaId]    Script Date: 04/27/2011 12:22:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Acesso_sel_PcId_AssinaturaId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Acesso_sel_PcId_AssinaturaId]
GO

/****** Object:  StoredProcedure [dbo].[pr_AcessoLog_sel_AcessoId_TipoLogId_Top]    Script Date: 04/27/2011 12:22:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_AcessoLog_sel_AcessoId_TipoLogId_Top]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_AcessoLog_sel_AcessoId_TipoLogId_Top]
GO

/****** Object:  StoredProcedure [dbo].[pr_Assinatura_sel_ClienteId]    Script Date: 04/27/2011 12:22:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Assinatura_sel_ClienteId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Assinatura_sel_ClienteId]
GO

/****** Object:  StoredProcedure [dbo].[pr_Indicacao_sel_assinaturaIndicadoId]    Script Date: 04/27/2011 12:22:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Indicacao_sel_assinaturaIndicadoId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Indicacao_sel_assinaturaIndicadoId]
GO

/****** Object:  StoredProcedure [dbo].[pr_Indicacao_sel_clienteId]    Script Date: 04/27/2011 12:22:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Indicacao_sel_clienteId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Indicacao_sel_clienteId]
GO

/****** Object:  StoredProcedure [dbo].[pr_Indicacao_sel_clienteId_Convertidas]    Script Date: 04/27/2011 12:22:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Indicacao_sel_clienteId_Convertidas]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Indicacao_sel_clienteId_Convertidas]
GO

/****** Object:  StoredProcedure [dbo].[pr_Indicacao_sel_clienteId_emailIndicado]    Script Date: 04/27/2011 12:22:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Indicacao_sel_clienteId_emailIndicado]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Indicacao_sel_clienteId_emailIndicado]
GO

/****** Object:  StoredProcedure [dbo].[pr_Indicacao_sel_clienteId_Total]    Script Date: 04/27/2011 12:22:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Indicacao_sel_clienteId_Total]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Indicacao_sel_clienteId_Total]
GO

/****** Object:  StoredProcedure [dbo].[pr_Indicacao_sel_ClienteId_Total_Convertidas]    Script Date: 04/27/2011 12:22:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Indicacao_sel_ClienteId_Total_Convertidas]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Indicacao_sel_ClienteId_Total_Convertidas]
GO

/****** Object:  StoredProcedure [dbo].[pr_Notificacao_sel_ClienteId_TipoNotificacaoId]    Script Date: 04/27/2011 12:22:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Notificacao_sel_ClienteId_TipoNotificacaoId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Notificacao_sel_ClienteId_TipoNotificacaoId]
GO

/****** Object:  StoredProcedure [dbo].[pr_Notificacao_sel_ClienteId_TipoNotificacaoIdMAX]    Script Date: 04/27/2011 12:22:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Notificacao_sel_ClienteId_TipoNotificacaoIdMAX]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Notificacao_sel_ClienteId_TipoNotificacaoIdMAX]
GO

/****** Object:  StoredProcedure [dbo].[pr_Notificacao_sel_NaoEnviada]    Script Date: 04/27/2011 12:22:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Notificacao_sel_NaoEnviada]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Notificacao_sel_NaoEnviada]
GO

/****** Object:  StoredProcedure [dbo].[pr_Notificacao_sel_Pendente]    Script Date: 04/27/2011 12:22:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Notificacao_sel_Pendente]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Notificacao_sel_Pendente]
GO

/****** Object:  StoredProcedure [dbo].[pr_Notificacao_sel_Pendente_Count]    Script Date: 04/27/2011 12:22:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Notificacao_sel_Pendente_Count]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Notificacao_sel_Pendente_Count]
GO

/****** Object:  StoredProcedure [dbo].[pr_OptOut_sel_Email]    Script Date: 04/27/2011 12:22:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_OptOut_sel_Email]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_OptOut_sel_Email]
GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_Indicacoes]    Script Date: 04/27/2011 12:22:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Relat_Indicacoes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Relat_Indicacoes]
GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_IndicacoesBcp]    Script Date: 04/27/2011 12:22:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Relat_IndicacoesBcp]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Relat_IndicacoesBcp]
GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_IndicacoesProvedor]    Script Date: 04/27/2011 12:22:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Relat_IndicacoesProvedor]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Relat_IndicacoesProvedor]
GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_IndicacoesProvedorBcp]    Script Date: 04/27/2011 12:22:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Relat_IndicacoesProvedorBcp]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Relat_IndicacoesProvedorBcp]
GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_Instalacoes]    Script Date: 04/27/2011 12:22:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Relat_Instalacoes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Relat_Instalacoes]
GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_InstalacoesBcp]    Script Date: 04/27/2011 12:22:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Relat_InstalacoesBcp]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Relat_InstalacoesBcp]
GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_InstalacoesErro]    Script Date: 04/27/2011 12:22:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Relat_InstalacoesErro]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Relat_InstalacoesErro]
GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_InstalacoesErro2]    Script Date: 04/27/2011 12:22:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Relat_InstalacoesErro2]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Relat_InstalacoesErro2]
GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_InstalacoesErro2Bcp]    Script Date: 04/27/2011 12:22:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Relat_InstalacoesErro2Bcp]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Relat_InstalacoesErro2Bcp]
GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_InstalacoesErroConfigXml]    Script Date: 04/27/2011 12:22:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Relat_InstalacoesErroConfigXml]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Relat_InstalacoesErroConfigXml]
GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_InstalacoesErroConfigXmlEmail]    Script Date: 04/27/2011 12:22:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Relat_InstalacoesErroConfigXmlEmail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Relat_InstalacoesErroConfigXmlEmail]
GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_Scans]    Script Date: 04/27/2011 12:22:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Relat_Scans]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Relat_Scans]
GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_ScansBcp]    Script Date: 04/27/2011 12:22:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Relat_ScansBcp]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Relat_ScansBcp]
GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_ScansConsSO]    Script Date: 04/27/2011 12:22:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Relat_ScansConsSO]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Relat_ScansConsSO]
GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_ScansFirstScan]    Script Date: 04/27/2011 12:22:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Relat_ScansFirstScan]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Relat_ScansFirstScan]
GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_ScansFirstScanSO]    Script Date: 04/27/2011 12:22:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Relat_ScansFirstScanSO]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Relat_ScansFirstScanSO]
GO

/****** Object:  StoredProcedure [dbo].[pr_VersaoAplic_sel_Max]    Script Date: 04/27/2011 12:22:28 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_VersaoAplic_sel_Max]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_VersaoAplic_sel_Max]
GO

/****** Object:  StoredProcedure [dbo].[pr_VersaoAplic_sel_Nome]    Script Date: 04/27/2011 12:22:28 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_VersaoAplic_sel_Nome]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_VersaoAplic_sel_Nome]
GO

/****** Object:  StoredProcedure [dbo].[sp_dba_identity]    Script Date: 04/27/2011 12:22:28 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_dba_identity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_dba_identity]
GO

/****** Object:  StoredProcedure [dbo].[sp_dba_OrphanUser]    Script Date: 04/27/2011 12:22:29 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_dba_OrphanUser]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_dba_OrphanUser]
GO

USE [PSafeDb]
GO

/****** Object:  StoredProcedure [dbo].[pr_Acesso_sel_AssinaturaId]    Script Date: 04/27/2011 12:22:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create PROC [dbo].[pr_Acesso_sel_AssinaturaId]	@AssinaturaId intWITH EXECUTE AS OWNERASSET NOCOUNT ONSELECT * FROM Acesso (nolock)WHERE AssinaturaId = @AssinaturaIdSET NOCOUNT OFF

GO

/****** Object:  StoredProcedure [dbo].[pr_Acesso_sel_AssinaturaId_Total]    Script Date: 04/27/2011 12:22:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create PROC [dbo].[pr_Acesso_sel_AssinaturaId_Total]	@AssinaturaId intWITH EXECUTE AS OWNERASSET NOCOUNT ONSELECT count(*) FROM Acesso (nolock)WHERE AssinaturaId = @AssinaturaIdSET NOCOUNT OFF

GO

/****** Object:  StoredProcedure [dbo].[pr_Acesso_sel_PcId_AssinaturaId]    Script Date: 04/27/2011 12:22:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[pr_Acesso_sel_PcId_AssinaturaId]
@pcid int, @AssinaturaId int
WITH EXECUTE AS OWNER

AS
SET NOCOUNT ON

SELECT * 
FROM Acesso (nolock)
WHERE assinaturaId = @AssinaturaId and pcId = @pcid


SET NOCOUNT OFF

GO

/****** Object:  StoredProcedure [dbo].[pr_AcessoLog_sel_AcessoId_TipoLogId_Top]    Script Date: 04/27/2011 12:22:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create PROC [dbo].[pr_AcessoLog_sel_AcessoId_TipoLogId_Top]	@Acessoid int, @tipologId smallint, @top intWITH EXECUTE AS OWNERASSET NOCOUNT ONset rowcount @topSELECT * FROM AcessoLog (nolock)WHERE acessoid = @acessoid and tipologid = @tipologid order by dataHora descset rowcount 0SET NOCOUNT OFF

GO

/****** Object:  StoredProcedure [dbo].[pr_Assinatura_sel_ClienteId]    Script Date: 04/27/2011 12:22:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[pr_Assinatura_sel_ClienteId]
	@Clienteid int
WITH EXECUTE AS OWNER

AS
SET NOCOUNT ON

SELECT * 
FROM Assinatura (nolock)
WHERE clienteid = @Clienteid


SET NOCOUNT OFF

GO

/****** Object:  StoredProcedure [dbo].[pr_Indicacao_sel_assinaturaIndicadoId]    Script Date: 04/27/2011 12:22:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[pr_Indicacao_sel_assinaturaIndicadoId]
	@assinaturaIndicadoId int
WITH EXECUTE AS OWNER

AS
SET NOCOUNT ON

SELECT * 
FROM Indicacao
WHERE assinaturaIndicadoId = @assinaturaIndicadoId


SET NOCOUNT OFF

GO

/****** Object:  StoredProcedure [dbo].[pr_Indicacao_sel_clienteId]    Script Date: 04/27/2011 12:22:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_Indicacao_sel_clienteId]
 @clienteId int -- , @emailIndicado tdemail
 with execute as owner
AS
BEGIN
SET NOCOUNT ON;
   
select * from Indicacao (nolock)
where clienteId = @clienteId --and emailIndicado = @emailIndicado 
END

GO

/****** Object:  StoredProcedure [dbo].[pr_Indicacao_sel_clienteId_Convertidas]    Script Date: 04/27/2011 12:22:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_Indicacao_sel_clienteId_Convertidas]
 @clienteId int -- , @emailIndicado tdemail
 with execute as owner
AS
BEGIN
SET NOCOUNT ON;
   
select * from Indicacao (nolock)
where clienteId = @clienteId and assinaturaIndicadoId is not null 
END

GO

/****** Object:  StoredProcedure [dbo].[pr_Indicacao_sel_clienteId_emailIndicado]    Script Date: 04/27/2011 12:22:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



create PROCEDURE [dbo].[pr_Indicacao_sel_clienteId_emailIndicado]
 @clienteId int  , @emailIndicado tdemail
 with execute as owner
AS
BEGIN
SET NOCOUNT ON;
   
select * from Indicacao (nolock)
where clienteId = @clienteId and emailIndicado = @emailIndicado
END

GO

/****** Object:  StoredProcedure [dbo].[pr_Indicacao_sel_clienteId_Total]    Script Date: 04/27/2011 12:22:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_Indicacao_sel_clienteId_Total]
 @clienteId int -- , @emailIndicado tdemail
 with execute as owner
AS
BEGIN
SET NOCOUNT ON;
   
select COUNT(*) from Indicacao (nolock)
where clienteId = @clienteId --and emailIndicado = @emailIndicado 
END

GO

/****** Object:  StoredProcedure [dbo].[pr_Indicacao_sel_ClienteId_Total_Convertidas]    Script Date: 04/27/2011 12:22:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_Indicacao_sel_ClienteId_Total_Convertidas]
 @clienteId int -- , @emailIndicado tdemail
 with execute as owner
AS
BEGIN
SET NOCOUNT ON;
   
select COUNT(*) from Indicacao (nolock)
where clienteId = @clienteId and assinaturaIndicadoId is not null 
END

GO

/****** Object:  StoredProcedure [dbo].[pr_Notificacao_sel_ClienteId_TipoNotificacaoId]    Script Date: 04/27/2011 12:22:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROC [dbo].[pr_Notificacao_sel_ClienteId_TipoNotificacaoId]
	@clienteid int, @tipoNotificacaoId tinyint
WITH EXECUTE AS OWNER

AS
SET NOCOUNT ON

SELECT * 
FROM Notificacao
WHERE clienteId = @clienteid and tipoNotificacaoId = @tipoNotificacaoId


SET NOCOUNT OFF





GO

/****** Object:  StoredProcedure [dbo].[pr_Notificacao_sel_ClienteId_TipoNotificacaoIdMAX]    Script Date: 04/27/2011 12:22:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROC [dbo].[pr_Notificacao_sel_ClienteId_TipoNotificacaoIdMAX]
	@clienteid int, @tipoNotificacaoId tinyint
WITH EXECUTE AS OWNER

AS
SET NOCOUNT ON

SELECT top 1 * 
FROM Notificacao (nolock)
WHERE clienteId = @clienteid and tipoNotificacaoId = @tipoNotificacaoId
order by 1 desc

SET NOCOUNT OFF



GO

/****** Object:  StoredProcedure [dbo].[pr_Notificacao_sel_NaoEnviada]    Script Date: 04/27/2011 12:22:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE proc [dbo].[pr_Notificacao_sel_NaoEnviada] 
	@clienteid int
WITH EXECUTE AS OWNER

AS
SET NOCOUNT ON

SELECT * 
FROM Notificacao
WHERE clienteid = @clienteid and enviada = 0 and lida = 0
and tipoNotificacaoId <> 5

SET NOCOUNT OFF



GO

/****** Object:  StoredProcedure [dbo].[pr_Notificacao_sel_Pendente]    Script Date: 04/27/2011 12:22:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE proc [dbo].[pr_Notificacao_sel_Pendente] 
	@clienteid intWITH EXECUTE AS OWNERASSET NOCOUNT ONSELECT * FROM NotificacaoWHERE clienteid = @clienteid and lida = 0 and tipoNotificacaoId <> 5 --LembreteSET NOCOUNT OFF


GO

/****** Object:  StoredProcedure [dbo].[pr_Notificacao_sel_Pendente_Count]    Script Date: 04/27/2011 12:22:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




create proc [dbo].[pr_Notificacao_sel_Pendente_Count] 
	@clienteid intWITH EXECUTE AS OWNERASSET NOCOUNT ONSELECT count(*) FROM NotificacaoWHERE clienteid = @clienteid and lida = 0 and tipoNotificacaoId <> 5 --LembreteSET NOCOUNT OFF

GO

/****** Object:  StoredProcedure [dbo].[pr_OptOut_sel_Email]    Script Date: 04/27/2011 12:22:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[pr_OptOut_sel_Email]	@email tdemailWITH EXECUTE AS OWNERASSET NOCOUNT ONSELECT isnull(1,0) FROM OptOut (nolock) WHERE email = @emailSET NOCOUNT OFF
GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_Indicacoes]    Script Date: 04/27/2011 12:22:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/****** Object:  StoredProcedure [dbo].[pr_Relat_Instalacoes]    Script Date: 04/07/2011 18:46:19 ******/
--indicacao
CREATE proc [dbo].[pr_Relat_Indicacoes]
@dtIni smalldatetime = null, @dtFim smalldatetime = null,@tipoCons char(1) = null
with execute as owner
as
begin
set nocount on

-- Estou ignorando o @tipoCons

-- Se NULL, ultimos 3 dias
if @dtIni is null 
select @dtIni = DATEADD(dd,-5,GETDATE()),@dtFim = dateadd(dd,1,GETDATE())


declare @tab table (Data date,tipo varchar(30),qtd int default 0)

insert @tab
select CONVERT(date,dataHora) ,'Total',isnull( count(*),0)  
from Indicacao c (nolock) 
--join Assinatura a on a.id = c.assinaturaIndicadoId
where dataHora between @dtIni and @dtFim
group by CONVERT(date,dataHora)

insert @tab
select CONVERT(date,dataHora) ,'Conversoes',isnull( count(*),0)  
from Indicacao c (nolock) 
--join Assinatura a on a.id = c.assinaturaIndicadoId
where dataHora between @dtIni and @dtFim and assinaturaIndicadoId is not null 
group by CONVERT(date,dataHora)

declare @result table (Data char(15),Total int,Conversoes int)

insert @result
select Data, 
isnull([Total], 0) as Total,
isnull([Conversoes],0) as Conversoes
from
(select data,tipo,qtd from @tab) tab
pivot (sum(qtd) for tipo in ([Total],[Conversoes]))  tabpivot
order by 1

insert @result select 'TOTAL PERIODO',SUM(total),SUM(conversoes) from @result

insert @result select 'TOTAL GERAL',COUNT(*),
SUM(case when assinaturaIndicadoId is Not null then 1 else 0 end) from Indicacao


select * from @result

end --proc



GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_IndicacoesBcp]    Script Date: 04/27/2011 12:22:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/****** Object:  StoredProcedure [dbo].[pr_Relat_Instalacoes]    Script Date: 04/07/2011 18:46:19 ******/
--indicacao
create proc [dbo].[pr_Relat_IndicacoesBcp]
@dtIni smalldatetime = null, @dtFim smalldatetime = null,@tipoCons char(1) = null
with execute as owner
as
begin
set nocount on

-- Estou ignorando o @tipoCons

-- Se NULL, ultimos 3 dias
if @dtIni is null 
select @dtIni = DATEADD(dd,-5,GETDATE()),@dtFim = dateadd(dd,1,GETDATE())


declare @tab table (Data date,tipo varchar(30),qtd int default 0)

insert @tab
select CONVERT(date,dataHora) ,'Total',isnull( count(*),0)  
from Indicacao c (nolock) where datahora between @dtIni and @dtFim
group by CONVERT(date,datahora)

insert @tab
select CONVERT(date,datahora) ,'Conversoes',isnull( count(*),0)  
from Indicacao c (nolock) where datahora between @dtIni and @dtFim and assinaturaIndicadoId is not null 
group by CONVERT(date,datahora)

declare @result table (Data char(15),Total int,Conversoes int)

insert @result
select Data, 
isnull([Total], 0) as Total,
isnull([Conversoes],0) as Conversoes
from
(select data,tipo,qtd from @tab) tab
pivot (sum(qtd) for tipo in ([Total],[Conversoes]))  tabpivot
order by 1

insert @result select 'TOTAL PERIODO',SUM(total),SUM(conversoes) from @result

insert @result select 'TOTAL GERAL',COUNT(*),
SUM(case when assinaturaIndicadoId is Not null then 1 else 0 end) from Indicacao

select CONVERT(char(15),'Data'),CONVERT(char(20),'Total'),CONVERT(char(15),'Conversoes') union all
select CONVERT(char(15),Data),CONVERT(char(15),Total),CONVERT(char(15),conversoes) 
from @result

end --proc



GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_IndicacoesProvedor]    Script Date: 04/27/2011 12:22:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE proc [dbo].[pr_Relat_IndicacoesProvedor]
@dtIni smalldatetime = null, @dtFim smalldatetime = null, @tipo char(1) = null
WITH EXECUTE AS OWNER
as
begin
set nocount on


-- Estou ignorando o @tipoCons

-- Se NULL, ultimos 3 dias
if @dtIni is null 
select @dtIni = DATEADD(dd,-5,GETDATE()),@dtFim = dateadd(dd,1,GETDATE())


declare @tab table (seq tinyint identity(1,1) primary key,Provedor varchar(20),TotalIndicacoes int, Convertidas int)

insert @tab
select 
case 
when emailIndicado like '%Gmail%' then 'Gmail'
when emailIndicado like '%Hotmail%' then 'Hotmail'
when emailIndicado like '%Terra%' then 'Terra'
when emailIndicado like '%@ig%' then 'IG'
when emailIndicado like '%yahoo%' then 'Yahoo'
when emailIndicado like '%Bol%' then 'Bol'
when emailIndicado like '%Muitofacil%' then 'Lemon'
when emailIndicado like '%Lemon%' then 'Lemon'
when emailIndicado like '%Msn%' then 'Msn'
when emailIndicado like '%ibest%' then 'Ibest'
when emailIndicado like '%Globo%' then 'Globo'
when emailIndicado like '%uol%' then 'Uol'
when emailIndicado like '%.gov%' then '.Gov'
when emailIndicado like '%aol%' then 'Aol'
when emailIndicado like '%Sulamerica%' then 'Sulamerica'
when emailIndicado like '%Bradesco%' then 'Bradesco'
when emailIndicado like '%Petrobras%' then 'Petrobras'
when emailIndicado like '%Brturbo%' then 'BrTurbo'
when emailIndicado like '%Microsoft%' then 'Microsoft'
when emailIndicado like '%SuperIg%' then 'SuperIG'
when emailIndicado like '%click21%' then 'Click21'
when emailIndicado like '%.org%' then '.Org'
--else 'Outros'
end as Provedor,  
COUNT(*) as TotalIndicacoes,
sum(case when assinaturaIndicadoId is not null then 1 else 0 end) as Convertidas 
from indicacao (nolock)
where datahora between @dtIni and @dtFim and (
emailIndicado  like  '%Gmail%' -- then 'Gmail'
or   emailIndicado  like  '%Hotmail%' -- then 'Hotmail'
or   emailIndicado  like  '%Terra%' -- then 'Terra'
or   emailIndicado  like  '%@ig%' -- then 'IG'
or   emailIndicado  like  '%yahoo%' -- then 'Yahoo'
or   emailIndicado  like  '%Bol%' -- then 'Bol'
or   emailIndicado  like  '%Muitofacil%' -- then 'Lemon'
or   emailIndicado  like  '%Lemon%' -- then 'Lemon'
or   emailIndicado  like  '%Msn%' -- then 'Msn'
or   emailIndicado  like  '%ibest%' -- then 'Ibest'
or   emailIndicado  like  '%Globo%' -- then 'Globo'
or   emailIndicado  like  '%uol%' -- then 'Uol'
or   emailIndicado  like  '%.gov%' -- then '.Gov'
or   emailIndicado  like  '%aol%' -- then 'Aol'
or   emailIndicado  like  '%Sulamerica%' -- then 'Sulamerica'
or   emailIndicado  like  '%Bradesco%' -- then 'Bradesco'
or   emailIndicado  like  '%Petrobras%' -- then 'Petrobras'
or   emailIndicado  like  '%Brturbo%' -- then 'BrTurbo'
or   emailIndicado  like  '%Microsoft%' -- then 'Microsoft'
or   emailIndicado  like  '%SuperIg%' -- then 'SuperIG'
or   emailIndicado  like  '%click21%' -- then 'Click21'
or   emailIndicado  like  '%.org%' -- then '.Org'
)
group by case
when emailIndicado like '%Gmail%' then 'Gmail'
when emailIndicado like '%Hotmail%' then 'Hotmail'
when emailIndicado like '%Terra%' then 'Terra'
when emailIndicado like '%@ig%' then 'IG'
when emailIndicado like '%yahoo%' then 'Yahoo'
when emailIndicado like '%Bol%' then 'Bol'
when emailIndicado like '%Muitofacil%' then 'Lemon'
when emailIndicado like '%Lemon%' then 'Lemon'
when emailIndicado like '%Msn%' then 'Msn'
when emailIndicado like '%ibest%' then 'Ibest'
when emailIndicado like '%Globo%' then 'Globo'
when emailIndicado like '%uol%' then 'Uol'
when emailIndicado like '%.gov%' then '.Gov'
when emailIndicado like '%aol%' then 'Aol'
when emailIndicado like '%Sulamerica%' then 'Sulamerica'
when emailIndicado like '%Bradesco%' then 'Bradesco'
when emailIndicado like '%Petrobras%' then 'Petrobras'
when emailIndicado like '%Brturbo%' then 'BrTurbo'
when emailIndicado like '%Microsoft%' then 'Microsoft'
when emailIndicado like '%SuperIg%' then 'SuperIG'
when emailIndicado like '%click21%' then 'Click21'
when emailIndicado like '%.org%' then '.Org'
--else 'Outros'
end
order by 2 desc


insert @tab
select 'OUTROS',COUNT(*) ,
sum(case when assinaturaIndicadoId is not null then 1 else 0 end) 
from indicacao (nolock) 
where datahora between @dtIni and @dtFim and
emailIndicado not like  '%Gmail%' -- then 'Gmail'
and  emailIndicado not like  '%Hotmail%' -- then 'Hotmail'
and  emailIndicado not like  '%Terra%' -- then 'Terra'
and  emailIndicado not like  '%@ig%' -- then 'IG'
and  emailIndicado not like  '%yahoo%' -- then 'Yahoo'
and  emailIndicado not like  '%Bol%' -- then 'Bol'
and  emailIndicado not like  '%Muitofacil%' -- then 'Lemon'
and  emailIndicado not like  '%Lemon%' -- then 'Lemon'
and  emailIndicado not like  '%Msn%' -- then 'Msn'
and  emailIndicado not like  '%ibest%' -- then 'Ibest'
and  emailIndicado not like  '%Globo%' -- then 'Globo'
and  emailIndicado not like  '%uol%' -- then 'Uol'
and  emailIndicado not like  '%.gov%' -- then '.Gov'
and  emailIndicado not like  '%aol%' -- then 'Aol'
and  emailIndicado not like  '%Sulamerica%' -- then 'Sulamerica'
and  emailIndicado not like  '%Bradesco%' -- then 'Bradesco'
and  emailIndicado not like  '%Petrobras%' -- then 'Petrobras'
and  emailIndicado not like  '%Brturbo%' -- then 'BrTurbo'
and  emailIndicado not like  '%Microsoft%' -- then 'Microsoft'
and  emailIndicado not like  '%SuperIg%' -- then 'SuperIG'
and  emailIndicado not like  '%click21%' -- then 'Click21'
and  emailIndicado not like  '%.org%' -- then '.Org'

insert @tab select 'TOTAL PERIODO',sum (totalIndicacoes),sum(convertidas) from @tab

insert @tab select 'TOTAL GERAL',COUNT(*),
SUM(case when assinaturaIndicadoId is Not null then 1 else 0 end) from Indicacao


select Provedor,TotalIndicacoes,Convertidas
from @tab order by seq


end -- proc


GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_IndicacoesProvedorBcp]    Script Date: 04/27/2011 12:22:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create proc [dbo].[pr_Relat_IndicacoesProvedorBcp]
@dtIni smalldatetime = null, @dtFim smalldatetime = null, @tipo char(1) = null
WITH EXECUTE AS OWNER
as
begin
set nocount on


-- Estou ignorando o @tipoCons

-- Se NULL, ultimos 3 dias
if @dtIni is null 
select @dtIni = DATEADD(dd,-5,GETDATE()),@dtFim = dateadd(dd,1,GETDATE())


declare @tab table (seq tinyint identity(1,1) primary key,Provedor varchar(20),TotalIndicacoes int, Convertidas int)

insert @tab
select 
case 
when emailIndicado like '%Gmail%' then 'Gmail'
when emailIndicado like '%Hotmail%' then 'Hotmail'
when emailIndicado like '%Terra%' then 'Terra'
when emailIndicado like '%@ig%' then 'IG'
when emailIndicado like '%yahoo%' then 'Yahoo'
when emailIndicado like '%Bol%' then 'Bol'
when emailIndicado like '%Muitofacil%' then 'Lemon'
when emailIndicado like '%Lemon%' then 'Lemon'
when emailIndicado like '%Msn%' then 'Msn'
when emailIndicado like '%ibest%' then 'Ibest'
when emailIndicado like '%Globo%' then 'Globo'
when emailIndicado like '%uol%' then 'Uol'
when emailIndicado like '%.gov%' then '.Gov'
when emailIndicado like '%aol%' then 'Aol'
when emailIndicado like '%Sulamerica%' then 'Sulamerica'
when emailIndicado like '%Bradesco%' then 'Bradesco'
when emailIndicado like '%Petrobras%' then 'Petrobras'
when emailIndicado like '%Brturbo%' then 'BrTurbo'
when emailIndicado like '%Microsoft%' then 'Microsoft'
when emailIndicado like '%SuperIg%' then 'SuperIG'
when emailIndicado like '%click21%' then 'Click21'
when emailIndicado like '%.org%' then '.Org'
--else 'Outros'
end as Provedor,  
COUNT(*) as TotalIndicacoes,
sum(case when assinaturaIndicadoId is not null then 1 else 0 end) as Convertidas 
from indicacao (nolock)
where datahora between @dtIni and @dtFim and (
emailIndicado  like  '%Gmail%' -- then 'Gmail'
or   emailIndicado  like  '%Hotmail%' -- then 'Hotmail'
or   emailIndicado  like  '%Terra%' -- then 'Terra'
or   emailIndicado  like  '%@ig%' -- then 'IG'
or   emailIndicado  like  '%yahoo%' -- then 'Yahoo'
or   emailIndicado  like  '%Bol%' -- then 'Bol'
or   emailIndicado  like  '%Muitofacil%' -- then 'Lemon'
or   emailIndicado  like  '%Lemon%' -- then 'Lemon'
or   emailIndicado  like  '%Msn%' -- then 'Msn'
or   emailIndicado  like  '%ibest%' -- then 'Ibest'
or   emailIndicado  like  '%Globo%' -- then 'Globo'
or   emailIndicado  like  '%uol%' -- then 'Uol'
or   emailIndicado  like  '%.gov%' -- then '.Gov'
or   emailIndicado  like  '%aol%' -- then 'Aol'
or   emailIndicado  like  '%Sulamerica%' -- then 'Sulamerica'
or   emailIndicado  like  '%Bradesco%' -- then 'Bradesco'
or   emailIndicado  like  '%Petrobras%' -- then 'Petrobras'
or   emailIndicado  like  '%Brturbo%' -- then 'BrTurbo'
or   emailIndicado  like  '%Microsoft%' -- then 'Microsoft'
or   emailIndicado  like  '%SuperIg%' -- then 'SuperIG'
or   emailIndicado  like  '%click21%' -- then 'Click21'
or   emailIndicado  like  '%.org%' -- then '.Org'
)
group by case
when emailIndicado like '%Gmail%' then 'Gmail'
when emailIndicado like '%Hotmail%' then 'Hotmail'
when emailIndicado like '%Terra%' then 'Terra'
when emailIndicado like '%@ig%' then 'IG'
when emailIndicado like '%yahoo%' then 'Yahoo'
when emailIndicado like '%Bol%' then 'Bol'
when emailIndicado like '%Muitofacil%' then 'Lemon'
when emailIndicado like '%Lemon%' then 'Lemon'
when emailIndicado like '%Msn%' then 'Msn'
when emailIndicado like '%ibest%' then 'Ibest'
when emailIndicado like '%Globo%' then 'Globo'
when emailIndicado like '%uol%' then 'Uol'
when emailIndicado like '%.gov%' then '.Gov'
when emailIndicado like '%aol%' then 'Aol'
when emailIndicado like '%Sulamerica%' then 'Sulamerica'
when emailIndicado like '%Bradesco%' then 'Bradesco'
when emailIndicado like '%Petrobras%' then 'Petrobras'
when emailIndicado like '%Brturbo%' then 'BrTurbo'
when emailIndicado like '%Microsoft%' then 'Microsoft'
when emailIndicado like '%SuperIg%' then 'SuperIG'
when emailIndicado like '%click21%' then 'Click21'
when emailIndicado like '%.org%' then '.Org'
--else 'Outros'
end
order by 2 desc


insert @tab
select 'OUTROS',COUNT(*) ,
sum(case when assinaturaIndicadoId is not null then 1 else 0 end) 
from indicacao (nolock) 
where datahora between @dtIni and @dtFim and
emailIndicado not like  '%Gmail%' -- then 'Gmail'
and  emailIndicado not like  '%Hotmail%' -- then 'Hotmail'
and  emailIndicado not like  '%Terra%' -- then 'Terra'
and  emailIndicado not like  '%@ig%' -- then 'IG'
and  emailIndicado not like  '%yahoo%' -- then 'Yahoo'
and  emailIndicado not like  '%Bol%' -- then 'Bol'
and  emailIndicado not like  '%Muitofacil%' -- then 'Lemon'
and  emailIndicado not like  '%Lemon%' -- then 'Lemon'
and  emailIndicado not like  '%Msn%' -- then 'Msn'
and  emailIndicado not like  '%ibest%' -- then 'Ibest'
and  emailIndicado not like  '%Globo%' -- then 'Globo'
and  emailIndicado not like  '%uol%' -- then 'Uol'
and  emailIndicado not like  '%.gov%' -- then '.Gov'
and  emailIndicado not like  '%aol%' -- then 'Aol'
and  emailIndicado not like  '%Sulamerica%' -- then 'Sulamerica'
and  emailIndicado not like  '%Bradesco%' -- then 'Bradesco'
and  emailIndicado not like  '%Petrobras%' -- then 'Petrobras'
and  emailIndicado not like  '%Brturbo%' -- then 'BrTurbo'
and  emailIndicado not like  '%Microsoft%' -- then 'Microsoft'
and  emailIndicado not like  '%SuperIg%' -- then 'SuperIG'
and  emailIndicado not like  '%click21%' -- then 'Click21'
and  emailIndicado not like  '%.org%' -- then '.Org'

insert @tab select 'TOTAL PERIODO',sum (totalIndicacoes),sum(convertidas) from @tab

insert @tab select 'TOTAL GERAL',COUNT(*),
SUM(case when assinaturaIndicadoId is Not null then 1 else 0 end) from Indicacao


select CONVERT(char(15),'Provedor'),CONVERT(char(20),'Total Indicacoes'),CONVERT(char(15),'Convertidas') union all
select CONVERT(char(15),Provedor),CONVERT(char(15),TotalIndicacoes),CONVERT(char(15),Convertidas) 
from @tab --order by seq


end -- proc


GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_Instalacoes]    Script Date: 04/27/2011 12:22:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE proc [dbo].[pr_Relat_Instalacoes]
@dtIni smalldatetime = null, @dtFim smalldatetime = null,@tipoCons char(1) = null
with execute as owner
as
begin
set nocount on

-- Estou ignorando o @tipoCons

-- Se NULL, ultimos 3 dias
if @dtIni is null 
select @dtIni = convert(char(8),DATEADD(dd,-5,GETDATE()),112),@dtFim = convert (char(8),dateadd(dd,1,GETDATE()),112)

declare @tab table (Data date,tipo varchar(30),qtd int default 0)

insert @tab
select CONVERT(date,dataHora) ,'Total',isnull( count(*),0)  
from Instalacao c (nolock) where dataHora between @dtIni and @dtFim
group by CONVERT(date,dataHora)

insert @tab
select CONVERT(date,dataHora) ,'Sucesso',isnull( count(*),0)  
from Instalacao c (nolock) where dataHora between @dtIni and @dtFim and not exists 
(select 1 from Instalacao c2 (nolock) where c.guId = c2.guId and c2.dataHora < c.dataHora and c2.pcId is not null) and
pcId is not null 
group by CONVERT(date,dataHora)


insert @tab
select CONVERT(date,dataHora) ,'SemHwId',isnull( count(*),0)  
from Instalacao c (nolock) where dataHora between @dtIni and @dtFim and not exists 
(select 1 from Instalacao c2 (nolock) where c.guId = c2.guId and c2.dataHora < c.dataHora and c2.pcId is not null) and
pcId is null and datahoraSucesso is not null
group by CONVERT(date,dataHora)
/*
insert @tab
select CONVERT(date,dataHora) ,'SemDataSucesso',isnull( count(*),0)  
from Instalacao c (nolock) where dataHora between @dtIni and @dtFim and not exists 
(select 1 from Instalacao c2 (nolock) where c.guId = c2.guId and c2.dataHora < c.dataHora and c2.dataSucesso is not null) and
dataSucesso is null 
group by CONVERT(date,dataHora)
*/
insert @tab
select CONVERT(date,dataHora) ,'Falhas',isnull( count(*),0)  
from Instalacao c (nolock) where dataHora between @dtIni and @dtFim and not exists 
(select 1 from Instalacao c2 (nolock) where c.guId = c2.guId and c2.dataHora < c.dataHora and c2.pcId is not null) and
pcId is null and datahoraSucesso is null
group by CONVERT(date,dataHora)

insert @tab
select CONVERT(date,dataHora) ,'UpgradeReinstalacoes',isnull( count(*),0)  
from Instalacao c (nolock) where dataHora between @dtIni and @dtFim and exists 
(select 1 from Instalacao c2 (nolock) where c.guId = c2.guId and c2.dataHora < c.dataHora and c2.pcId is not null)
--and (c.pcId is null or c.datasucesso is null)
group by CONVERT(date,dataHora)

declare @result table (Data char(15),Total int,Sucesso int,DesistenciaCadastro int,Falhas int,UpgradeReinstalacoes int)

insert @result
select Data, 
isnull([Total], 0) as Total,
isnull([Sucesso],0) as Sucesso,
isnull([SemHwId],0) as DesistenciaCadastro,
--isnull([SemDataSucesso],0) as SemDataSucesso_NaoComunicou,
isnull([Falhas],0) as Falhas,
isnull([UpgradeReinstalacoes], 0) as UpgradeReinstalacoes
from
(select data,tipo,qtd from @tab) tab
pivot (sum(qtd) for tipo in ([Total],[Sucesso], [SemHwId],--[SemDataSucesso],
[Falhas],[UpgradeReinstalacoes]))  tabpivot
order by 1

insert @result
select 'TOTAL PERIODO', sum(total),sum(Sucesso),sum(DesistenciaCadastro),sum(Falhas),sum(UpgradeReinstalacoes) from @result


insert @result
select 'TOTAL GERAL' ,count(*),
SUM(case when pcId is not null then 1 else 0 end) ,
SUM(case when pcId is null then 1 else 0 end) ,
SUM(case when pcId is null and datahoraSucesso is null then 1 else 0 end) ,null
from Instalacao c (nolock) -- where dataHora between @dtIni and @dtFim 
--and not exists 
--(select 1 from Instalacao c2 (nolock) where c.guId = c2.guId and c2.dataHora < c.dataHora and c2.pcId is not null)

declare @upgrade int
select @upgrade = COUNT(*)
from Instalacao c (nolock) where exists 
(select 1 from Instalacao c2 (nolock) where c.guId = c2.guId and c2.dataHora < c.dataHora and c2.pcId is not null)

update @result
set UpgradeReinstalacoes = @upgrade where data = 'TOTAL GERAL' 


select * from @result

end --proc


GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_InstalacoesBcp]    Script Date: 04/27/2011 12:22:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE proc [dbo].[pr_Relat_InstalacoesBcp]
@dtIni date = null, @dtFim date = null,@tipoCons char(1) = null
with execute as owner
as
begin
set nocount on

-- Estou ignorando o @tipoCons

-- Se NULL, ultimos 3 dias
if @dtIni is null 
select @dtIni = DATEADD(dd,-5,GETDATE()),@dtFim = dateadd(dd,1,GETDATE())

declare @tab table (Data date,tipo varchar(30),qtd int default 0)

insert @tab
select CONVERT(date,dataHora) ,'Total',isnull( count(*),0)  
from Instalacao c (nolock) where dataHora between @dtIni and @dtFim
group by CONVERT(date,dataHora)

insert @tab
select CONVERT(date,dataHora) ,'Sucesso',isnull( count(*),0)  
from Instalacao c (nolock) where dataHora between @dtIni and @dtFim and not exists 
(select 1 from Instalacao c2 (nolock) where c.guId = c2.guId and c2.dataHora < c.dataHora and c2.pcId is not null) and
pcId is not null 
group by CONVERT(date,dataHora)


insert @tab
select CONVERT(date,dataHora) ,'SemHwId',isnull( count(*),0)  
from Instalacao c (nolock) where dataHora between @dtIni and @dtFim and not exists 
(select 1 from Instalacao c2 (nolock) where c.guId = c2.guId and c2.dataHora < c.dataHora and c2.pcId is not null) and
pcId is null and datahoraSucesso is not null
group by CONVERT(date,dataHora)
/*
insert @tab
select CONVERT(date,dataHora) ,'SemDataSucesso',isnull( count(*),0)  
from Instalacao c (nolock) where dataHora between @dtIni and @dtFim and not exists 
(select 1 from Instalacao c2 (nolock) where c.guId = c2.guId and c2.dataHora < c.dataHora and c2.dataSucesso is not null) and
dataSucesso is null 
group by CONVERT(date,dataHora)
*/
insert @tab
select CONVERT(date,dataHora) ,'Falhas',isnull( count(*),0)  
from Instalacao c (nolock) where dataHora between @dtIni and @dtFim and not exists 
(select 1 from Instalacao c2 (nolock) where c.guId = c2.guId and c2.dataHora < c.dataHora and c2.pcId is not null) and
pcId is null and datahoraSucesso is null
group by CONVERT(date,dataHora)

insert @tab
select CONVERT(date,dataHora) ,'UpgradeReinstalacoes',isnull( count(*),0)  
from Instalacao c (nolock) where dataHora between @dtIni and @dtFim and exists 
(select 1 from Instalacao c2 (nolock) where c.guId = c2.guId and c2.dataHora < c.dataHora and c2.pcId is not null)
--and (c.pcId is null or c.datasucesso is null)
group by CONVERT(date,dataHora)

declare @result table (Data char(15),Total int,Sucesso int,DesistenciaCadastro int,Falhas int,UpgradeReinstalacoes int)

insert @result
select Data, 
isnull([Total], 0) as Total,
isnull([Sucesso],0) as Sucesso,
isnull([SemHwId],0) as DesistenciaCadastro,
--isnull([SemDataSucesso],0) as SemDataSucesso_NaoComunicou,
isnull([Falhas],0) as Falhas,
isnull([UpgradeReinstalacoes], 0) as UpgradeReinstalacoes
from
(select data,tipo,qtd from @tab) tab
pivot (sum(qtd) for tipo in ([Total],[Sucesso], [SemHwId],--[SemDataSucesso],
[Falhas],[UpgradeReinstalacoes]))  tabpivot
order by 1

insert @result
select 'TOTAL PERIODO', sum(total),sum(Sucesso),sum(DesistenciaCadastro),sum(Falhas),sum(UpgradeReinstalacoes) from @result


insert @result
select 'TOTAL GERAL' ,count(*),
SUM(case when pcId is not null then 1 else 0 end) ,
SUM(case when pcId is null then 1 else 0 end) ,
SUM(case when pcId is null and datahoraSucesso is null then 1 else 0 end) ,null
from Instalacao c (nolock) -- where dataHora between @dtIni and @dtFim and not exists 
--(select 1 from Instalacao c2 (nolock) where c.guId = c2.guId and c2.dataHora < c.dataHora and c2.pcId is not null)

declare @upgrade int
select @upgrade = COUNT(*)
from Instalacao c (nolock) where exists 
(select 1 from Instalacao c2 (nolock) where c.guId = c2.guId and c2.dataHora < c.dataHora and c2.pcId is not null)

update @result
set UpgradeReinstalacoes = @upgrade where data = 'TOTAL GERAL' 


select CONVERT(char(15),'Data'),CONVERT(char(20),'Total'),CONVERT(char(15),'Sucesso') ,
CONVERT(char(15),'DesistenciaCadastro'),CONVERT(char(15),'Falhas'),CONVERT(char(15),'UpgradeReinstalacoes')
union all
select CONVERT(char(15),Data),CONVERT(char(15),Total),CONVERT(char(15),Sucesso) ,
CONVERT(char(15),DesistenciaCadastro),CONVERT(char(15),Falhas),CONVERT(char(15),UpgradeReinstalacoes)
from @result

end --proc


GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_InstalacoesErro]    Script Date: 04/27/2011 12:22:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[pr_Relat_InstalacoesErro]
@dtIni date = null, @dtFim date = null,@tipoCons char(1) = 'D'
with execute as owner
as
begin
set nocount on
-- Estou ignorando o @tipoCons

-- Se NULL, ultimos 3 dias
if @dtIni is null 
select @dtIni = DATEADD(dd,-5,GETDATE()),@dtFim = dateadd(dd,1,GETDATE())

declare @result table (Data date, OS nvarchar(50))
insert @result
select CONVERT(date,dataHora) ,
configuracao.value('(//os/node())[1]', 'nvarchar(50)') 
from Instalacao c (nolock) where dataHora between @dtIni and @dtFim and pcId is null and datahorasucesso is null and not exists 
(select 1 from Instalacao c2 (nolock) where c.guId = c2.guId and c2.dataHora < c.dataHora and c2.pcId is not null)    
order by 1

declare @tab table (Data char(15), OS nvarchar(50), TotalFalhas int)
insert @tab select data,os,COUNT(*) from @result group by data,os order by 1

insert @tab
select 'TOTAL PERIODO','TODOS SOs',SUM(TotalFalhas) from @tab

insert @tab
select 'TOTAL GERAL','TODOS SOs',COUNT(*) 
from Instalacao c (nolock) where  pcId is null and datahorasucesso is null and not exists 
(select 1 from Instalacao c2 (nolock) where c.guId = c2.guId and c2.dataHora < c.dataHora and c2.pcId is not null)    

select * from @tab order by 1,2

end --proc

GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_InstalacoesErro2]    Script Date: 04/27/2011 12:22:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[pr_Relat_InstalacoesErro2]
@dtIni date = null, @dtFim date = null,@tipoCons char(1) = 'D'
with execute as owner
as
begin
set nocount on
-- Estou ignorando o @tipoCons

-- Se NULL, ultimos 3 dias
if @dtIni is null 
select @dtIni = DATEADD(dd,-5,GETDATE()),@dtFim = dateadd(dd,1,GETDATE())

declare @result table (Data date, OS nvarchar(50),sucesso tinyint)
insert @result
select CONVERT(date,dataHora) ,
configuracao.value('(//os/node())[1]', 'nvarchar(50)') ,0
from Instalacao c (nolock) where dataHora between @dtIni and @dtFim and pcId is null and datahorasucesso is null and not exists 
(select 1 from Instalacao c2 (nolock) where c.guId = c2.guId and c2.dataHora < c.dataHora and c2.pcId is not null)    
order by 1

insert @result
select CONVERT(date,dataHora) ,
configuracao.value('(//os/node())[1]', 'nvarchar(50)') ,1
from Instalacao c (nolock) where dataHora between @dtIni and @dtFim and pcId is not null and not exists 
(select 1 from Instalacao c2 (nolock) where c.guId = c2.guId and c2.dataHora < c.dataHora and c2.pcId is not null)    
order by 1


declare @tab table (Data char(15), OS nvarchar(50), TotalFalhas int, TotalSucessos int)
insert @tab select data,os,SUM(case when sucesso = 0 then 1 else 0 end),SUM(sucesso) from @result group by data,os order by 1

insert @tab
select 'TOTAL PERIODO','TODOS SOs',SUM(TotalFalhas),SUM(totalsucessos) from @tab

insert @tab
select 'TOTAL GERAL','TODOS SOs',SUM(case when pcId is null and datahorasucesso is null then 1 else 0 end) ,SUM(case when pcId is not null then 1 else 0 end)
from Instalacao c (nolock) where  not exists 
(select 1 from Instalacao c2 (nolock) where c.guId = c2.guId and c2.dataHora < c.dataHora and c2.pcId is not null)    

select * from @tab order by 1,2

end --proc

GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_InstalacoesErro2Bcp]    Script Date: 04/27/2011 12:22:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[pr_Relat_InstalacoesErro2Bcp]
@dtIni date = null, @dtFim date = null,@tipoCons char(1) = 'D'
with execute as owner
as
begin
set nocount on
-- Estou ignorando o @tipoCons

-- Se NULL, ultimos 3 dias
if @dtIni is null 
select @dtIni = DATEADD(dd,-5,GETDATE()),@dtFim = dateadd(dd,1,GETDATE())

declare @result table (Data date, OS nvarchar(50),sucesso tinyint)
insert @result
select CONVERT(date,dataHora) ,
configuracao.value('(//os/node())[1]', 'nvarchar(50)') ,0
from Instalacao c (nolock) where dataHora between @dtIni and @dtFim and pcId is null and datahorasucesso is null and not exists 
(select 1 from Instalacao c2 (nolock) where c.guId = c2.guId and c2.dataHora < c.dataHora and c2.pcId is not null)    
order by 1

insert @result
select CONVERT(date,dataHora) ,
configuracao.value('(//os/node())[1]', 'nvarchar(50)') ,1
from Instalacao c (nolock) where dataHora between @dtIni and @dtFim and pcId is not null and not exists 
(select 1 from Instalacao c2 (nolock) where c.guId = c2.guId and c2.dataHora < c.dataHora and c2.pcId is not null)    
order by 1


declare @tab table (Data char(15), OS nvarchar(50), TotalFalhas int, TotalSucessos int)
insert @tab select data,os,SUM(case when sucesso = 0 then 1 else 0 end),SUM(sucesso) from @result group by data,os order by 1

insert @tab
select 'TOTAL PERIODO','TODOS SOs',SUM(TotalFalhas),SUM(totalsucessos) from @tab

insert @tab
select 'TOTAL GERAL','TODOS SOs',SUM(case when pcId is null and datahorasucesso is null then 1 else 0 end) ,SUM(case when pcId is not null then 1 else 0 end)
from Instalacao c (nolock) where  not exists 
(select 1 from Instalacao c2 (nolock) where c.guId = c2.guId and c2.dataHora < c.dataHora and c2.pcId is not null)    


select CONVERT(char(15),'Data'),CONVERT(char(50),'OS'),CONVERT(char(15),'TotalFalhas'),CONVERT(char(15),'TotalSucessos') union all
select CONVERT(char(15),Data),CONVERT(char(50),OS),CONVERT(char(15),TotalFalhas),CONVERT(char(15),TotalSucessos) 
from @tab order by 1,2

end --proc

GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_InstalacoesErroConfigXml]    Script Date: 04/27/2011 12:22:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


           
CREATE proc [dbo].[pr_Relat_InstalacoesErroConfigXml]
@dtIni date = null, @dtFim date = null,@tipoCons char(1) = 'D'
with execute as owner
as
begin
set nocount on
-- Estou ignorando o @tipoCons

-- Se NULL, ultimos 3 dias
if @dtIni is null 
select @dtIni = DATEADD(dd,-5,GETDATE()),@dtFim = dateadd(dd,1,GETDATE())


select id as IntalacaoId,dataHora, ' ',
configuracao.value('(//computername/node())[1]', 'nvarchar(30)') as ComputerName,
configuracao.value('(//os/node())[1]', 'nvarchar(50)') as OS,
configuracao.value('(//cpu/node())[1]', 'nvarchar(50)') as CPU,
configuracao.value('(//totalhdd/node())[1]', 'nvarchar(20)') as totalhdd,--,configuracao
configuracao.value('(//sizeofmydoc/node())[1]', 'nvarchar(20)') as sizeofmydoc,--,configuracao
configuracao.value('(//ram/node())[1]', 'nvarchar(20)') as ram,configuracao
from Instalacao c (nolock) where dataHora between @dtIni and @dtFim and pcId is null and datahorasucesso is null and not exists 
(select 1 from Instalacao c2 (nolock) where c.guId = c2.guId and c2.dataHora < c.dataHora and c2.pcId is not null)    
order by 1

end --proc


GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_InstalacoesErroConfigXmlEmail]    Script Date: 04/27/2011 12:22:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


           
CREATE proc [dbo].[pr_Relat_InstalacoesErroConfigXmlEmail]
@cont int = 200
as
begin
set nocount on
--SEMPRE ULTIMOS 2 DIAS POR CAUSA DA VIEW

--alter view vInstalacaoFalha
--as
--SELECT 
--id,
--dataHora, 
--configuracao.value('(//computername/node())[1]', 'nvarchar(30)') as ComputerName, configuracao
--FROM Instalacao c (nolock) 
--where pcId is null and datahorasucesso is null and convert(date,dataHora) >= DATEADD(dd,-2,getdate())
--and not exists 
--(select 1 from Instalacao c2 (nolock) where c.guId = c2.guId and c2.dataHora < c.dataHora and c2.pcId is not null)          
          
set rowcount @cont          

DECLARE @tableHTML NVARCHAR(MAX) ; 
    SET @tableHTML = 
    N'<html><body><h1>SEM UPGRADE DE VERSAO PSAFE</h1>' + 
    N'<table border="1" width="100%">' + 
    N'<tr bgcolor="gray"><td>ID</td><td>DateTime</td><td>ComputerName</td><td>Config</td></tr>' + 
            CAST(( 
        SELECT 
                    td = convert(char(10),id), '', 
                    td = CONVERT(char(20),dataHora,100), '', 
                    td = convert(varchar(30),computername), '' ,
                    td = convert(nvarchar(max),configuracao), '' 
            FROM vInstalacaoFalha c order by c.dataHora desc
            FOR XML PATH('tr'), TYPE) AS NVARCHAR(MAX)) + N'</table></body></html>' 
   
 
    
--select id as IntalacaoId,dataHora, ' ',
--configuracao.value('(//computername/node())[1]', 'nvarchar(30)') as ComputerName,
--configuracao.value('(//os/node())[1]', 'nvarchar(50)') as OS,CONVERT(nvarchar(max),configuracao) as config
--configuracao.value('(//cpu/node())[1]', 'nvarchar(50)') as CPU,
--configuracao.value('(//totalhdd/node())[1]', 'nvarchar(20)') as totalhdd,--,configuracao
--configuracao.value('(//sizeofmydoc/node())[1]', 'nvarchar(20)') as sizeofmydoc,--,configuracao
--configuracao.value('(//ram/node())[1]', 'nvarchar(20)') as ram--,configuracao
--from Instalacao c (nolock) where dataHora between @dtIni and @dtFim and pcId is null and datahorasucesso is null
--order by 1




--declare @qry nvarchar(200) = 'exec pr_Relat_InstalacoesErroConfigXml'

exec msdb..sp_send_dbmail  @profile_name = 'PSafeNotifier',
@recipients = 'Luciana@grupoxango.com',
--@body = 'Instalações com falha dos últimos 5 dias em anexo.',
@subject=  '200 Instalações falhas dos últimos 2 dias. Mais? Fale com o DBA',
 @body = @tableHTML, 
@body_format= 'HTML',
@execute_query_database = 'PsafeDb',
--@query = @qry,
@attach_query_result_as_file = 0--,
--@query_attachment_filename = 'InstalacoesErro.csv',
--@query_result_width  = 300--,
--@query_result_separator = ';'
end --proc


GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_Scans]    Script Date: 04/27/2011 12:22:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE proc [dbo].[pr_Relat_Scans]
@dtIni smalldatetime = null, @dtFim smalldatetime = null, @tipo char(1) = null
WITH EXECUTE AS OWNER
as
begin
set nocount on


-- Estou ignorando o @tipoCons

-- Se NULL, ultimos 3 dias
if @dtIni is null 
select @dtIni = DATEADD(dd,-5,GETDATE()),@dtFim = dateadd(dd,1,GETDATE())

declare @result table (id int identity(1,1) primary key, Data char(20),TotalScans int,ComVirus int, TotalVirus int)

insert @result
select
CONVERT(date,dataHora) , 
isnull(COUNT(*),0) , 
sum(case when qtdVirus > 0 then 1 else 0 end),
isnull(SUM(qtdVirus),0) 
from AcessoLog c (nolock) 
where dataHora between @dtIni and @dtFim
group by CONVERT(date,dataHora) order by 1



insert @result select 'TOTAL PERIODO',sum (isnull(TotalScans,0)),sum(isnull(ComVirus,0)),sum(isnull(TotalVirus,0)) from @result

insert @result 
select
'TOTAL GERAL' , 
isnull(COUNT(*),0) , 
sum(case when qtdVirus > 0 then 1 else 0 end),
isnull(SUM(qtdVirus),0) 
from AcessoLog c (nolock) 



select data as Data,TotalScans,ComVirus,
convert(dec(5,2),convert(dec(10,2),ComVirus)/convert(dec(10,2),TotalScans)*100) as [%Virus],
TotalVirus, 
convert(dec(5,2),convert(dec(10,2),TotalVirus)/convert(dec(10,2),TotalScans)) as [AvgVirusScan]
from @result 
order by id 

end -- proc

GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_ScansBcp]    Script Date: 04/27/2011 12:22:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE proc [dbo].[pr_Relat_ScansBcp]
@dtIni smalldatetime = null, @dtFim smalldatetime = null, @tipo char(1) = null
WITH EXECUTE AS OWNER
as
begin
set nocount on


-- Estou ignorando o @tipoCons

-- Se NULL, ultimos 3 dias
if @dtIni is null 
select @dtIni = DATEADD(dd,-5,GETDATE()),@dtFim = dateadd(dd,1,GETDATE())

declare @result table (Data char(20),TotalScans int,ComVirus int, TotalVirus int)

insert @result
select
CONVERT(date,dataHora) , 
isnull(COUNT(*),0) , 
sum(case when qtdVirus > 0 then 1 else 0 end),
isnull(SUM(qtdVirus),0) 
from AcessoLog c (nolock) 
where dataHora between @dtIni and @dtFim
group by CONVERT(date,dataHora) order by 1



insert @result select 'TOTAL PERIODO',sum (isnull(TotalScans,0)),sum(isnull(ComVirus,0)),sum(isnull(TotalVirus,0)) from @result

insert @result 
select
'TOTAL GERAL' , 
isnull(COUNT(*),0) , 
sum(case when qtdVirus > 0 then 1 else 0 end),
isnull(SUM(qtdVirus),0) 
from AcessoLog c (nolock) 



select CONVERT(char(15),'Data'),CONVERT(char(15),'Total Scans'),CONVERT(char(15),'ComVirus'),convert(char(10),'%Virus'),
CONVERT(char(15),'TotalVirus') ,convert(char(15),'AvgVirusScan') union all
select CONVERT(char(15),data),CONVERT(char(15),TotalScans),CONVERT(char(15),ComVirus),
convert(char(10),convert(dec(5,2),convert(dec(10,2),ComVirus)/convert(dec(10,2),TotalScans)*100)) as [%Virus],
CONVERT(char(15),TotalVirus), 
convert(char(10),convert(dec(5,2),convert(dec(10,2),TotalVirus)/convert(dec(10,2),TotalScans))) as [AvgVirusScan]
from @result 


--order by 1 desc

end -- proc


GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_ScansConsSO]    Script Date: 04/27/2011 12:22:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[pr_Relat_ScansConsSO]
@dtIni smalldatetime = null, @dtFim smalldatetime = null, @tipo char(1) = null
WITH EXECUTE AS OWNER
as
begin
set nocount on


-- Estou ignorando o @tipoCons

-- Se NULL, ultimos 3 dias
if @dtIni is null 
select @dtIni = DATEADD(dd,-5,GETDATE()),@dtFim = dateadd(dd,1,GETDATE())

declare @tab table (id int identity(1,1) primary key,SO nvarchar(50),qtdVirus int)
insert @tab
select
configuracao.value('(//os/node())[1]', 'nvarchar(50)')  , isnull(qtdVirus,0)
from AcessoLog c (nolock) 
join acesso a (nolock) on c.acessoId = a.id
join Instalacao i (nolock) on a.pcid = i.pcid
--where c.dataHora between @dtIni and @dtFim

declare @result table (SO nvarchar(50),TotalScans int,ComVirus int, TotalVirus int)

insert @result
select
SO, 
isnull(COUNT(*),0) , 
sum(case when qtdVirus > 0 then 1 else 0 end),
isnull(SUM(qtdVirus),0) 
from @tab
group by SO
order by 2 desc



insert @result select 'TOTAL',sum (isnull(TotalScans,0)),sum(isnull(ComVirus,0)),sum(isnull(TotalVirus,0)) from @result


select SO,TotalScans,
convert(dec(5,2),convert(dec(10,2),ComVirus)/convert(dec(10,2),TotalScans)*100) as [%infeccao],
TotalVirus as qtdVirus
from @result 
--order by 3 desc

end -- proc

GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_ScansFirstScan]    Script Date: 04/27/2011 12:22:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE proc [dbo].[pr_Relat_ScansFirstScan]
@dtIni datetime = null, @dtFim datetime = null, @tipo char(1) = null
WITH EXECUTE AS OWNER
as
begin
set nocount on


-- Estou ignorando o @tipoCons

-- Se NULL, ultimos 3 dias
if @dtIni is null 
select @dtIni = DATEADD(dd,-2,GETDATE()),@dtFim = GETDATE()

declare @fs table (pcid int primary key, logId int not null, qtdVirus int null, dataHora date null)

insert @fs (pcid,logId)
select pcid, MIN(al.id)
from AcessoLog al (nolock) 
join Acesso a (nolock) on al.acessoId = a.id
group by pcId

update @fs
set qtdVirus = isnull(al.qtdVirus,0), dataHora = al.dataHora
from @fs fs join AcessoLog al on fs.logId = al.id

--select top 100 * from @fs order by qtdVirus desc
--return

declare @result table (Data char(15),TotalScans int,ComVirus int, TotalVirus int)

insert @result
select
dataHora , 
COUNT(*) , 
sum(case when qtdVirus > 0 then 1 else 0 end),
isnull(SUM(qtdVirus),0) 
from @fs
where dataHora between @dtIni and @dtFim
group by dataHora order by 1


insert @result select 'TOTAL PERIODO',sum (isnull(TotalScans,0)),sum(isnull(ComVirus,0)),sum(isnull(TotalVirus,0)) from @result

insert @result 
select
'TOTAL GERAL' , 
isnull(COUNT(*),0) , 
sum(case when qtdVirus > 0 then 1 else 0 end),
isnull(SUM(qtdVirus),0) 
from @fs


select data as Data,TotalScans as TotalFirstScans,ComVirus,
convert(dec(5,2),convert(dec(10,2),ComVirus)/convert(dec(10,2),TotalScans)*100) as [%Virus],
TotalVirus, 
convert(dec(5,2),convert(dec(10,2),TotalVirus)/convert(dec(10,2),TotalScans)) as [AvgVirusScan]
from @result 
--order by 1 desc

end -- proc

GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_ScansFirstScanSO]    Script Date: 04/27/2011 12:22:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE proc [dbo].[pr_Relat_ScansFirstScanSO]
@dtIni datetime = null, @dtFim datetime = null, @tipo char(1) = null
WITH EXECUTE AS OWNER
as
begin
set nocount on


-- Estou ignorando o @tipoCons

-- Se NULL, ultimos 3 dias
if @dtIni is null 
select @dtIni = DATEADD(dd,-2,GETDATE()),@dtFim = GETDATE()

declare @fs table (pcid int primary key, logId int not null, qtdVirus int null, SO nvarchar(50) null)

insert @fs (pcid,logId)
select pcid, MIN(al.id)
from AcessoLog al (nolock) 
join Acesso a (nolock) on al.acessoId = a.id
group by pcId

update @fs
set qtdVirus = isnull(al.qtdVirus,0)
from @fs fs join AcessoLog al on fs.logId = al.id

update @fs
set SO = configuracao.value('(//os/node())[1]', 'nvarchar(50)')
from @fs fs
join Instalacao i (nolock) on fs.pcid = i.pcid

update @fs
set SO = 'INDISPONIVEL'
where SO is null



--select top 100 * from @fs order by qtdVirus desc
--return

declare @result table (SO nvarchar(50),TotalScans int,ComVirus int, TotalVirus int)

insert @result
select
SO , 
COUNT(*) , 
sum(case when qtdVirus > 0 then 1 else 0 end),
isnull(SUM(qtdVirus),0) 
from @fs
group by SO order by 2 desc


insert @result select 'TOTAL',sum (isnull(TotalScans,0)),sum(isnull(ComVirus,0)),sum(isnull(TotalVirus,0)) from @result



select SO as SO,TotalScans as TotalFirstScans,ComVirus,
convert(dec(5,2),convert(dec(10,2),ComVirus)/convert(dec(10,2),TotalScans)*100) as [%Virus],
TotalVirus, 
convert(dec(5,2),convert(dec(10,2),TotalVirus)/convert(dec(10,2),TotalScans)) as [AvgVirusScan]
from @result 
--order by 1 desc

end -- proc

GO

/****** Object:  StoredProcedure [dbo].[pr_VersaoAplic_sel_Max]    Script Date: 04/27/2011 12:22:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[pr_VersaoAplic_sel_Max]
WITH EXECUTE AS OWNER
AS
SET NOCOUNT ON
SET rowcount 1000

SELECT top 1 * 
FROM VersaoAplic
where ativo = 1
order by dataProducao desc


SET NOCOUNT OFF


SET rowcount 0

GO

/****** Object:  StoredProcedure [dbo].[pr_VersaoAplic_sel_Nome]    Script Date: 04/27/2011 12:22:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[pr_VersaoAplic_sel_Nome]
	@nome tddesc
WITH EXECUTE AS OWNER

AS
SET NOCOUNT ON

SELECT * 
FROM VersaoAplic (nolock) 
WHERE nome = @nome


SET NOCOUNT OFF

GO

/****** Object:  StoredProcedure [dbo].[sp_dba_identity]    Script Date: 04/27/2011 12:22:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[sp_dba_identity]
as
;WITH TypeRange AS (
SELECT 
    'bigint' AS [name], 
    9223372036854775807 AS MaxValue, 
    -9223372036854775808 AS MinValue
UNION ALL
SELECT 
    'int', 
    2147483647, 
    -2147483648
UNION ALL
SELECT 
    'smallint', 
    32767, 
    -32768
UNION ALL 
SELECT 
    'tinyint', 
    255, 
    0
), 
IdentBuffer AS (
SELECT
    OBJECT_SCHEMA_NAME(IC.object_id) AS [schema_name],
    O.name AS table_name,
    IC.name AS column_name,
    T.name AS data_typ,
    CAST(IC.seed_value AS decimal(38, 0)) AS seed_value,
    IC.increment_value,
    CAST(IC.last_value AS decimal(38, 0)) AS last_value,
    CAST(TR.MaxValue AS decimal(38, 0)) - 
        CAST(ISNULL(IC.last_value, 0) AS decimal(38, 0)) AS [buffer],
    CAST(CASE 
            WHEN seed_value < 0
            THEN TR.MaxValue - TR.MinValue
            ELSE TR.maxValue
        END AS decimal(38, 0)) AS full_type_range,
    TR.MaxValue AS max_type_value        
FROM
    PsafeDb.sys.identity_columns IC
    JOIN
    PsafeDb.sys.types T ON IC.system_type_id = T.system_type_id
    JOIN
    PsafeDb.sys.objects O ON IC.object_id = O.object_id
    JOIN
    TypeRange TR ON T.name = TR.name
WHERE
    O.is_ms_shipped = 0)
    
SELECT
    IdentBuffer.[schema_name],
    IdentBuffer.table_name,
    IdentBuffer.column_name,
    IdentBuffer.data_typ,
    IdentBuffer.seed_value,
    IdentBuffer.increment_value,
    IdentBuffer.last_value,
    IdentBuffer.max_type_value,
    IdentBuffer.full_type_range,
    IdentBuffer.buffer,
    CASE 
        WHEN IdentBuffer.seed_value < 0 
        THEN (-1 * IdentBuffer.seed_value + 
          IdentBuffer.last_value) / IdentBuffer.full_type_range
        ELSE (IdentBuffer.last_value * 1.0) / IdentBuffer.full_type_range
    END AS [identityvalue_consumption_in_percent]
FROM
    IdentBuffer
ORDER BY
    [identityvalue_consumption_in_percent] DESC;

GO

/****** Object:  StoredProcedure [dbo].[sp_dba_OrphanUser]    Script Date: 04/27/2011 12:22:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[sp_dba_OrphanUser]
as
ALTER USER [PSAFE\IIS_PROD] WITH LOGIN = [PSAFE\IIS_PROD]

GO

