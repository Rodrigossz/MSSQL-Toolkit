USE [FidelidadeDb]
GO

/****** Object:  StoredProcedure [dbo].[pr_ClienteEscudo_sel_ClienteId]    Script Date: 04/27/2011 12:28:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_ClienteEscudo_sel_ClienteId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_ClienteEscudo_sel_ClienteId]
GO

/****** Object:  StoredProcedure [dbo].[pr_Lancamento_sel_clienteId]    Script Date: 04/27/2011 12:28:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Lancamento_sel_clienteId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Lancamento_sel_clienteId]
GO

/****** Object:  StoredProcedure [dbo].[pr_Lancamento_sel_clienteId_CreditoId]    Script Date: 04/27/2011 12:28:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Lancamento_sel_clienteId_CreditoId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Lancamento_sel_clienteId_CreditoId]
GO

/****** Object:  StoredProcedure [dbo].[pr_Lancamento_sel_NaoProc]    Script Date: 04/27/2011 12:28:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Lancamento_sel_NaoProc]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Lancamento_sel_NaoProc]
GO

/****** Object:  StoredProcedure [dbo].[pr_LancamentoResgate_sel_ResgateId]    Script Date: 04/27/2011 12:28:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_LancamentoResgate_sel_ResgateId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_LancamentoResgate_sel_ResgateId]
GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_Estoque]    Script Date: 04/27/2011 12:28:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Relat_Estoque]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Relat_Estoque]
GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_pontosDistribuidos]    Script Date: 04/27/2011 12:28:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Relat_pontosDistribuidos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Relat_pontosDistribuidos]
GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_premiosResgatados]    Script Date: 04/27/2011 12:28:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Relat_premiosResgatados]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Relat_premiosResgatados]
GO

/****** Object:  StoredProcedure [dbo].[pr_vwResgate_sel_ClienteId]    Script Date: 04/27/2011 12:28:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_vwResgate_sel_ClienteId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_vwResgate_sel_ClienteId]
GO

/****** Object:  StoredProcedure [dbo].[pr_vwResgate_sel_dataHoraResgate]    Script Date: 04/27/2011 12:28:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_vwResgate_sel_dataHoraResgate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_vwResgate_sel_dataHoraResgate]
GO

/****** Object:  StoredProcedure [dbo].[pr_vwResgate_sel_Pendente]    Script Date: 04/27/2011 12:28:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_vwResgate_sel_Pendente]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_vwResgate_sel_Pendente]
GO

/****** Object:  StoredProcedure [dbo].[sp_dba_identity]    Script Date: 04/27/2011 12:28:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_dba_identity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_dba_identity]
GO

/****** Object:  StoredProcedure [dbo].[sp_dba_OrphanUser]    Script Date: 04/27/2011 12:28:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_dba_OrphanUser]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_dba_OrphanUser]
GO

USE [FidelidadeDb]
GO

/****** Object:  StoredProcedure [dbo].[pr_ClienteEscudo_sel_ClienteId]    Script Date: 04/27/2011 12:28:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[pr_ClienteEscudo_sel_ClienteId]
	@ClienteId int
WITH EXECUTE AS OWNER

AS
SET NOCOUNT ON

SELECT * 
FROM ClienteEscudo
WHERE ClienteId = @ClienteId


SET NOCOUNT OFF

GO

/****** Object:  StoredProcedure [dbo].[pr_Lancamento_sel_clienteId]    Script Date: 04/27/2011 12:28:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create PROC [dbo].[pr_Lancamento_sel_clienteId]	@clienteId intWITH EXECUTE AS OWNERASSET NOCOUNT ONSELECT * FROM Lancamento (nolock)WHERE clienteid = @clienteIdSET NOCOUNT OFF

GO

/****** Object:  StoredProcedure [dbo].[pr_Lancamento_sel_clienteId_CreditoId]    Script Date: 04/27/2011 12:28:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create PROC [dbo].[pr_Lancamento_sel_clienteId_CreditoId]
	@clienteId int, @creditoId smallint
WITH EXECUTE AS OWNER

AS
SET NOCOUNT ON

SELECT * 
FROM Lancamento (nolock)
WHERE clienteid = @clienteId and creditoId = @creditoId


SET NOCOUNT OFF

GO

/****** Object:  StoredProcedure [dbo].[pr_Lancamento_sel_NaoProc]    Script Date: 04/27/2011 12:28:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[pr_Lancamento_sel_NaoProc] @clienteId int
WITH EXECUTE AS OWNERASSET NOCOUNT ONSELECT * FROM Lancamento (nolock)WHERE clienteId = @clienteId and processado = 0SET NOCOUNT OFF

GO

/****** Object:  StoredProcedure [dbo].[pr_LancamentoResgate_sel_ResgateId]    Script Date: 04/27/2011 12:28:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[pr_LancamentoResgate_sel_ResgateId]
	@ResgateId int
WITH EXECUTE AS OWNER

AS
SET NOCOUNT ON

SELECT * 
FROM LancamentoResgate (nolock)
WHERE ResgateId = @ResgateId


SET NOCOUNT OFF

GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_Estoque]    Script Date: 04/27/2011 12:28:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[pr_Relat_Estoque]
as
begin
select id,nome as Recompensa,pontos,descricao,qtdEstoque
from Recompensa (nolock) where ativo = 1
end

GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_pontosDistribuidos]    Script Date: 04/27/2011 12:28:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[pr_Relat_pontosDistribuidos]
@dtIni smalldatetime = null, @dtFim smalldatetime = null,@tipoCons char(1) = 'D'
as

-- ONTEM
if @dtIni is null 
begin
select @dtIni = CONVERT(char(8),dateadd(dd,-1,GETDATE()),112)
select @dtFim = CONVERT(char(8),GETDATE(),112)
end


-- NAO INFORMOU FIM, VAI SER 1 DIA
if @dtIni is not null and @dtFim is null 
select @dtFim = dateadd(dd,1,@dtIni)

-- HJ
if @dtIni is not null and @dtIni = @dtFim 
select @dtFim = CONVERT(char(8),@dtIni,112) + ' 23:59:59'


if @tipoCons = 'D' -- Agrupar por dia
select
CONVERT(char(8),dataHora,112) as Periodo, Cred.nome as Credito,COUNT(distinct Clienteid) as Clientes,
--COUNT(*) as LancamentosCredito, 
sum(qtd) as Quantidade,SUM(qtd*pontos) as TotalPontosDistribuidos
from Lancamento c (nolock) join credito cred on cred.id = c.creditoId
where dataHora between @dtIni and @dtFim
group by CONVERT(char(8),dataHora,112),cred.nome order by 1,2

else -- Agrupar por MES
select
CONVERT(char(6),dataHora,112) as Periodo, Cred.nome as Credito,COUNT(distinct Clienteid) as Clientes,
--COUNT(*) as LancamentosCredito, 
sum(qtd) as Quantidade,SUM(qtd*pontos) as TotalPontosDistribuidos
from Lancamento c (nolock) join credito cred on cred.id = c.creditoId
where dataHora between @dtIni and @dtFim
group by CONVERT(char(6),dataHora,112),cred.nome order by 1,2

GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_premiosResgatados]    Script Date: 04/27/2011 12:28:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[pr_Relat_premiosResgatados]
@dtIni smalldatetime = null, @dtFim smalldatetime = null,@tipoCons char(1) = 'D'
as

-- ONTEM
if @dtIni is null 
begin
select @dtIni = CONVERT(char(8),dateadd(dd,-1,GETDATE()),112)
select @dtFim = CONVERT(char(8),GETDATE(),112)
end


-- NAO INFORMOU FIM, VAI SER 1 DIA
if @dtIni is not null and @dtFim is null 
select @dtFim = dateadd(dd,1,@dtIni)

-- HJ
if @dtIni is not null and @dtIni = @dtFim 
select @dtFim = CONVERT(char(8),@dtIni,112) + ' 23:59:59'


if @tipoCons = 'D' -- Agrupar por dia
select
CONVERT(char(8),dataHora,112) as Periodo, rec.nome Recompensa,COUNT(distinct Clienteid) as Clientes,
--COUNT(*) as LancamentosCredito, 
sum(qtd) as QuantidadeResgatada,SUM(qtd*pontos) as PontosUtilizados
from Lancamento c (nolock) join Recompensa rec on rec.id = c.creditoId
where dataHora between @dtIni and @dtFim
group by CONVERT(char(8),dataHora,112),rec.nome order by 1,2

else -- Agrupar por MES
select
CONVERT(char(6),dataHora,112) as Periodo, rec.nome Recompensa,COUNT(distinct Clienteid) as Clientes,
--COUNT(*) as LancamentosCredito, 
sum(qtd) as QuantidadeResgatada,SUM(qtd*pontos) as PontosUtilizados
from Lancamento c (nolock) join Recompensa rec on rec.id = c.creditoId
where dataHora between @dtIni and @dtFim
group by CONVERT(char(6),dataHora,112),rec.nome order by 1,2

GO

/****** Object:  StoredProcedure [dbo].[pr_vwResgate_sel_ClienteId]    Script Date: 04/27/2011 12:28:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[pr_vwResgate_sel_ClienteId]
@clienteId int
--with execute as owner
ASSET NOCOUNT ONSELECT * FROM vwResgateWHERE clienteId = @clienteIdSET NOCOUNT OFF

GO

/****** Object:  StoredProcedure [dbo].[pr_vwResgate_sel_dataHoraResgate]    Script Date: 04/27/2011 12:28:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[pr_vwResgate_sel_dataHoraResgate]
@dataHoraResgate smalldatetime
--with execute as guest
ASSET NOCOUNT ONSELECT * FROM vwResgateWHERE dataHoraResgate >= @dataHoraResgateSET NOCOUNT OFF

GO

/****** Object:  StoredProcedure [dbo].[pr_vwResgate_sel_Pendente]    Script Date: 04/27/2011 12:28:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[pr_vwResgate_sel_Pendente]
--with execute as owner
ASSET NOCOUNT ONSELECT * FROM vwResgateWHERE dataHoraPacote is null or dataHoraPostagem is nullSET NOCOUNT OFF

GO

/****** Object:  StoredProcedure [dbo].[sp_dba_identity]    Script Date: 04/27/2011 12:28:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[sp_dba_identity]
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
    sys.identity_columns IC
    JOIN
    sys.types T ON IC.system_type_id = T.system_type_id
    JOIN
    sys.objects O ON IC.object_id = O.object_id
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

/****** Object:  StoredProcedure [dbo].[sp_dba_OrphanUser]    Script Date: 04/27/2011 12:28:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[sp_dba_OrphanUser]
as
ALTER USER [PSAFE\IIS_PROD] WITH LOGIN = [PSAFE\IIS_PROD]

GO

