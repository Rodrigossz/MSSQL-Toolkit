USE [ClienteDb]
GO

/****** Object:  StoredProcedure [dbo].[pr_Cliente_del_cascade]    Script Date: 04/27/2011 12:27:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Cliente_del_cascade]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Cliente_del_cascade]
GO

/****** Object:  StoredProcedure [dbo].[pr_Cliente_sel_email]    Script Date: 04/27/2011 12:27:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Cliente_sel_email]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Cliente_sel_email]
GO

/****** Object:  StoredProcedure [dbo].[pr_Cliente_sel_emailLista]    Script Date: 04/27/2011 12:27:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Cliente_sel_emailLista]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Cliente_sel_emailLista]
GO

/****** Object:  StoredProcedure [dbo].[pr_Cliente_sel_RankingEscudos]    Script Date: 04/27/2011 12:27:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Cliente_sel_RankingEscudos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Cliente_sel_RankingEscudos]
GO

/****** Object:  StoredProcedure [dbo].[pr_Endereco_sel_ClienteId]    Script Date: 04/27/2011 12:27:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Endereco_sel_ClienteId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Endereco_sel_ClienteId]
GO

/****** Object:  StoredProcedure [dbo].[pr_Endereco_sel_ClienteId_Residencial]    Script Date: 04/27/2011 12:27:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Endereco_sel_ClienteId_Residencial]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Endereco_sel_ClienteId_Residencial]
GO

/****** Object:  StoredProcedure [dbo].[pr_Endereco_Sel_Count_ClienteId]    Script Date: 04/27/2011 12:27:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Endereco_Sel_Count_ClienteId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Endereco_Sel_Count_ClienteId]
GO

/****** Object:  StoredProcedure [dbo].[pr_OperacaoCliente_sel_Datas]    Script Date: 04/27/2011 12:27:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_OperacaoCliente_sel_Datas]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_OperacaoCliente_sel_Datas]
GO

/****** Object:  StoredProcedure [dbo].[pr_OrigemContatoInfo_sel_ClienteId]    Script Date: 04/27/2011 12:27:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_OrigemContatoInfo_sel_ClienteId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_OrigemContatoInfo_sel_ClienteId]
GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_Cancelamentos]    Script Date: 04/27/2011 12:27:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Relat_Cancelamentos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Relat_Cancelamentos]
GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_ClientesAtivos]    Script Date: 04/27/2011 12:27:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Relat_ClientesAtivos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Relat_ClientesAtivos]
GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_ClientesAtivosBcp]    Script Date: 04/27/2011 12:27:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Relat_ClientesAtivosBcp]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Relat_ClientesAtivosBcp]
GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_ClientesConsProvedor]    Script Date: 04/27/2011 12:27:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Relat_ClientesConsProvedor]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Relat_ClientesConsProvedor]
GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_ClientesConsProvedorBcp]    Script Date: 04/27/2011 12:27:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Relat_ClientesConsProvedorBcp]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Relat_ClientesConsProvedorBcp]
GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_ClientesSexo]    Script Date: 04/27/2011 12:27:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Relat_ClientesSexo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Relat_ClientesSexo]
GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_LogCliente]    Script Date: 04/27/2011 12:27:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Relat_LogCliente]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Relat_LogCliente]
GO

/****** Object:  StoredProcedure [dbo].[sp_dba_AtivaClientes]    Script Date: 04/27/2011 12:27:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_dba_AtivaClientes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_dba_AtivaClientes]
GO

/****** Object:  StoredProcedure [dbo].[sp_dba_identity]    Script Date: 04/27/2011 12:27:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_dba_identity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_dba_identity]
GO

/****** Object:  StoredProcedure [dbo].[sp_dba_monitorEncrypt]    Script Date: 04/27/2011 12:27:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_dba_monitorEncrypt]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_dba_monitorEncrypt]
GO

/****** Object:  StoredProcedure [dbo].[sp_dba_OrphanUser]    Script Date: 04/27/2011 12:27:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_dba_OrphanUser]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_dba_OrphanUser]
GO

USE [ClienteDb]
GO

/****** Object:  StoredProcedure [dbo].[pr_Cliente_del_cascade]    Script Date: 04/27/2011 12:27:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[pr_Cliente_del_cascade]  
@id int  
as  
begin  
select 'TEM CERTEZA Q QUER DELETAR? APERTE STOP EM ATÉ 10 SEGUNDOS'  
select * from Cliente where id = @id  
waitfor delay '00:00:10'  
delete endereco where clienteId = @id  
delete OrigemContatoInfo where clienteId = @id  
delete ClienteEmailAdicional where clienteId = @id  
delete EnderecoFinanceiro where clienteId = @id  
delete operacaoCliente where clienteId = @id  
delete Cliente where id = @id  
end  
GO

/****** Object:  StoredProcedure [dbo].[pr_Cliente_sel_email]    Script Date: 04/27/2011 12:27:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE proc [dbo].[pr_Cliente_sel_email]
@email tdEmail 
with execute as owner
AS
SET NOCOUNT ON
--exec pr_dba_OpenClosePasswordKey 'open'

SELECT *
FROM Cliente (nolock) where email = @email


--exec pr_dba_OpenClosePasswordKey 'close'
SET NOCOUNT OFF

GO

/****** Object:  StoredProcedure [dbo].[pr_Cliente_sel_emailLista]    Script Date: 04/27/2011 12:27:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create proc [dbo].[pr_Cliente_sel_emailLista]
@emails  tdTabEmail readonly
as
select * 
from Cliente c (nolock) join @emails e
on c.email = e.email


GO

/****** Object:  StoredProcedure [dbo].[pr_Cliente_sel_RankingEscudos]    Script Date: 04/27/2011 12:27:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[pr_Cliente_sel_RankingEscudos]
@qtd int = 10
WITH EXECUTE AS OWNER
as
begin
set nocount on
set rowcount @qtd

select id,primeiroNome,NomeMeio,SobreNome,saldoEscudo,dataCadastro from Cliente (nolock) 
where ativo = 1 and  dataHoraPontosCadastroCompleto is not null
order by saldoEscudo desc, dataCadastro asc
set rowcount 0
end

GO

/****** Object:  StoredProcedure [dbo].[pr_Endereco_sel_ClienteId]    Script Date: 04/27/2011 12:27:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[pr_Endereco_sel_ClienteId]
@clienteId int 
WITH EXECUTE AS OWNER
as
begin
set nocount on

select * from Endereco (nolock) 
where ativo = 1 and clienteId = @clienteId

end

GO

/****** Object:  StoredProcedure [dbo].[pr_Endereco_sel_ClienteId_Residencial]    Script Date: 04/27/2011 12:27:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[pr_Endereco_sel_ClienteId_Residencial]
@clienteId int 
WITH EXECUTE AS OWNER
as
begin
set nocount on

select * from Endereco (nolock) 
where ativo = 1 and clienteId = @clienteId and residencial = 1

end

GO

/****** Object:  StoredProcedure [dbo].[pr_Endereco_Sel_Count_ClienteId]    Script Date: 04/27/2011 12:27:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[pr_Endereco_Sel_Count_ClienteId]
@clienteId int
as
begin
set nocount on
select COUNT(*) from Endereco (nolock) where clienteId = @clienteId and ativo = 1
end

GO

/****** Object:  StoredProcedure [dbo].[pr_OperacaoCliente_sel_Datas]    Script Date: 04/27/2011 12:27:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[pr_OperacaoCliente_sel_Datas]	@clienteId int, @tipoOperacaoClienteId tinyint, @dataIni datetime, @datafim datetimeWITH EXECUTE AS OWNERASSET NOCOUNT ONSELECT * FROM OperacaoCliente (nolock)WHERE clienteid = @clienteId andtipoOperacaoClienteId = @tipoOperacaoClienteId anddataHora >= @dataIni and dataHora < dateadd(dd,1,@dataFim)SET NOCOUNT OFF

GO

/****** Object:  StoredProcedure [dbo].[pr_OrigemContatoInfo_sel_ClienteId]    Script Date: 04/27/2011 12:27:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[pr_OrigemContatoInfo_sel_ClienteId]	@clienteId int, @origemContatoId smallint = nullWITH EXECUTE AS OWNERASSET NOCOUNT ONSELECT * FROM OrigemContatoInfoWHERE Clienteid = @clienteId and origemcontatoId = isnull(@origemContatoId,origemContatoId)SET NOCOUNT OFF

GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_Cancelamentos]    Script Date: 04/27/2011 12:27:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE proc [dbo].[pr_Relat_Cancelamentos] 
@dtIni smalldatetime = null, @dtFim smalldatetime = null,@tipoCons char(1) = 'D'
as

-- Estou ignorando o @tipoCons
-- Se NULL, ultimos 3 dias
if @dtIni is null 
select @dtIni = DATEADD(dd,-5,GETDATE()),@dtFim = dateadd(dd,1,GETDATE())


--Comando DML __$operation 
-- 1 = DELETE
-- 2 = INSERT
-- 3 = Antes do UPDATE
-- 4 = Depois do UPDATE 



select convert(char(8),tran_begin_time,112) as Periodo, isnull(sexo,'N') as sexo,
COUNT(*) as Cancelamentos,sum(case  when dataHoraPontosCadastroCompleto is null then 1 else 0 end) as CancelamentosSemCadastro
from cdc.dbo_cliente_CT c join cdc.lsn_time_mapping m on c.__$start_lsn = m.start_lsn
where __$operation = 4 and ativo = 0 and tran_begin_time between @dtIni and @dtFim
and exists (select 1 from cdc.dbo_cliente_CT c2 where c.id = c2.id and c2.ativo = 1 
and c.__$start_lsn  = c2.__$start_lsn  and c.__$seqval  = c2.__$seqval  )
group by convert(char(8),tran_begin_time,112),isnull(sexo,'N')  order by 1




GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_ClientesAtivos]    Script Date: 04/27/2011 12:27:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE proc [dbo].[pr_Relat_ClientesAtivos]
@dtIni smalldatetime = null, @dtFim smalldatetime = null,@tipoCons char(1) = 'D'
as
set nocount on

-- Estou ignorando o @tipoCons
-- Se NULL, ultimos 3 dias
if @dtIni is null 
select @dtIni = DATEADD(dd,-5,GETDATE()),@dtFim = dateadd(dd,1,GETDATE())

declare @result table (Data char(20) , Inativos int, Ativos int, Total int)

insert @result
select Data,isnull([0],0) as Inativos,isnull([1],0) as Ativos, isnull([0],0)+isnull([1],0) as Total
from 
(select  convert(date,dataCadastro) as Data,ativo, 1 as qtd
from Cliente c (nolock) where dataCadastro between @dtIni and @dtFim) o

pivot
(sum(qtd) for ativo in ([0],[1])) as pvt
order by 1

insert @result select 'TOTAL PERIODO',SUM(inativos),SUM(ativos),SUM(total) from @result

insert @result
select 'TOTAL GERAL',isnull([0],0) as Inativos,isnull([1],0) as Ativos, isnull([0],0)+isnull([1],0) as Total
from 
(select  ativo, 1 as qtd
from Cliente c (nolock)  ) o
pivot
(sum(qtd) for ativo in ([0],[1])) as pvt
order by 1

select * from @result


GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_ClientesAtivosBcp]    Script Date: 04/27/2011 12:27:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





create proc [dbo].[pr_Relat_ClientesAtivosBcp]
@dtIni smalldatetime = null, @dtFim smalldatetime = null,@tipoCons char(1) = 'D'
as
begin
set nocount on

-- Estou ignorando o @tipoCons
-- Se NULL, ultimos 3 dias
if @dtIni is null 
select @dtIni = DATEADD(dd,-5,GETDATE()),@dtFim = dateadd(dd,1,GETDATE())

declare @result table (Data char(20) , Inativos int, Ativos int, Total int)

insert @result
select Data,isnull([0],0) as Inativos,isnull([1],0) as Ativos, isnull([0],0)+isnull([1],0) as Total
from 
(select  convert(date,dataCadastro) as Data,ativo, 1 as qtd
from Cliente c (nolock) where dataCadastro between @dtIni and @dtFim) o

pivot
(sum(qtd) for ativo in ([0],[1])) as pvt
order by 1

insert @result select 'TOTAL PERIODO',SUM(inativos),SUM(ativos),SUM(total) from @result

insert @result
select 'TOTAL GERAL',isnull([0],0) as Inativos,isnull([1],0) as Ativos, isnull([0],0)+isnull([1],0) as Total
from 
(select  ativo, 1 as qtd
from Cliente c (nolock)  ) o
pivot
(sum(qtd) for ativo in ([0],[1])) as pvt
order by 1

select CONVERT(char(15),'Data'),CONVERT(char(15),'Inativos'),CONVERT(char(15),'Ativos'),CONVERT(char(15),'Total') union all
select CONVERT(char(15),Data),CONVERT(char(15),Inativos),CONVERT(char(15),Ativos),CONVERT(char(15),Total) 
from @result


end --proc
GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_ClientesConsProvedor]    Script Date: 04/27/2011 12:27:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE proc [dbo].[pr_Relat_ClientesConsProvedor]
@dtIni smalldatetime = null, @dtFim smalldatetime = null, @tipo char(1) = 'd'
WITH EXECUTE AS OWNER
as
begin
set nocount on

-- Estou ignorando o @tipoCons
-- Se NULL, ultimos 3 dias
if @dtIni is null 
select @dtIni = DATEADD(dd,-5,GETDATE()),@dtFim = dateadd(dd,1,GETDATE())



declare @tab table (id tinyint identity(1,1) primary key,Provedor varchar(30),TotalClientes int, Ativos int)
insert @tab
select 
case 
when email like '%Gmail%' then 'Gmail'
when email like '%Hotmail%' then 'Hotmail'
when email like '%Terra%' then 'Terra'
when email like '%@ig%' then 'IG'
when email like '%yahoo%' then 'Yahoo'
when email like '%Bol%' then 'Bol'
when email like '%Muitofacil%' then 'Lemon'
when email like '%Lemon%' then 'Lemon'
when email like '%Msn%' then 'Msn'
when email like '%ibest%' then 'Ibest'
when email like '%Globo%' then 'Globo'
when email like '%uol%' then 'Uol'
when email like '%.gov%' then '.Gov'
when email like '%aol%' then 'Aol'
when email like '%Sulamerica%' then 'Sulamerica'
when email like '%Bradesco%' then 'Bradesco'
when email like '%Petrobras%' then 'Petrobras'
when email like '%Brturbo%' then 'BrTurbo'
when email like '%Microsoft%' then 'Microsoft'
when email like '%SuperIg%' then 'SuperIG'
when email like '%click21%' then 'Click21'
when email like '%.org%' then '.Org'
--else 'Outros'
end as Provedor,  
COUNT(*) as TotalClientes,
sum(case when ativo = 1 then 1 else 0 end) as Ativos 
from Cliente (nolock)
where (dataCadastro between @dtIni and @dtFim) and (
email  like  '%Gmail%' -- then 'Gmail'
or   email  like  '%Hotmail%' -- then 'Hotmail'
or   email  like  '%Terra%' -- then 'Terra'
or   email  like  '%@ig%' -- then 'IG'
or   email  like  '%yahoo%' -- then 'Yahoo'
or   email  like  '%Bol%' -- then 'Bol'
or   email  like  '%Muitofacil%' -- then 'Lemon'
or   email  like  '%Lemon%' -- then 'Lemon'
or   email  like  '%Msn%' -- then 'Msn'
or   email  like  '%ibest%' -- then 'Ibest'
or   email  like  '%Globo%' -- then 'Globo'
or   email  like  '%uol%' -- then 'Uol'
or   email  like  '%.gov%' -- then '.Gov'
or   email  like  '%aol%' -- then 'Aol'
or   email  like  '%Sulamerica%' -- then 'Sulamerica'
or   email  like  '%Bradesco%' -- then 'Bradesco'
or   email  like  '%Petrobras%' -- then 'Petrobras'
or   email  like  '%Brturbo%' -- then 'BrTurbo'
or   email  like  '%Microsoft%' -- then 'Microsoft'
or   email  like  '%SuperIg%' -- then 'SuperIG'
or   email  like  '%click21%' -- then 'Click21'
or   email  like  '%.org%') -- then '.Org'
group by case
when email like '%Gmail%' then 'Gmail'
when email like '%Hotmail%' then 'Hotmail'
when email like '%Terra%' then 'Terra'
when email like '%@ig%' then 'IG'
when email like '%yahoo%' then 'Yahoo'
when email like '%Bol%' then 'Bol'
when email like '%Muitofacil%' then 'Lemon'
when email like '%Lemon%' then 'Lemon'
when email like '%Msn%' then 'Msn'
when email like '%ibest%' then 'Ibest'
when email like '%Globo%' then 'Globo'
when email like '%uol%' then 'Uol'
when email like '%.gov%' then '.Gov'
when email like '%aol%' then 'Aol'
when email like '%Sulamerica%' then 'Sulamerica'
when email like '%Bradesco%' then 'Bradesco'
when email like '%Petrobras%' then 'Petrobras'
when email like '%Brturbo%' then 'BrTurbo'
when email like '%Microsoft%' then 'Microsoft'
when email like '%SuperIg%' then 'SuperIG'
when email like '%click21%' then 'Click21'
when email like '%.org%' then '.Org'
--else 'Outros'
end
order by 2 desc


insert @tab
select 'OUTROS',COUNT(*) ,
sum(case when ativo = 1 then 1 else 0 end) 
from Cliente (nolock)
where dataCadastro between @dtIni and @dtFim and 
email not like  '%Gmail%' -- then 'Gmail'
and  email not like  '%Hotmail%' -- then 'Hotmail'
and  email not like  '%Terra%' -- then 'Terra'
and  email not like  '%@ig%' -- then 'IG'
and  email not like  '%yahoo%' -- then 'Yahoo'
and  email not like  '%Bol%' -- then 'Bol'
and  email not like  '%Muitofacil%' -- then 'Lemon'
and  email not like  '%Lemon%' -- then 'Lemon'
and  email not like  '%Msn%' -- then 'Msn'
and  email not like  '%ibest%' -- then 'Ibest'
and  email not like  '%Globo%' -- then 'Globo'
and  email not like  '%uol%' -- then 'Uol'
and  email not like  '%.gov%' -- then '.Gov'
and  email not like  '%aol%' -- then 'Aol'
and  email not like  '%Sulamerica%' -- then 'Sulamerica'
and  email not like  '%Bradesco%' -- then 'Bradesco'
and  email not like  '%Petrobras%' -- then 'Petrobras'
and  email not like  '%Brturbo%' -- then 'BrTurbo'
and  email not like  '%Microsoft%' -- then 'Microsoft'
and  email not like  '%SuperIg%' -- then 'SuperIG'
and  email not like  '%click21%' -- then 'Click21'
and  email not like  '%.org%' -- then '.Org'

insert @tab select 'TOTAL PERIODO',sum (TotalClientes),sum(Ativos) from @tab

insert @tab
select 'TOTAL GERAL',COUNT(*),sum(case when ativo = 1 then 1 else 0 end) 
from Cliente c (nolock) 


select Provedor,TotalClientes,Ativos
from @tab --order by 1




end -- proc




GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_ClientesConsProvedorBcp]    Script Date: 04/27/2011 12:27:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[pr_Relat_ClientesConsProvedorBcp]
@dtIni smalldatetime = null, @dtFim smalldatetime = null, @tipo char(1) = 'd'
WITH EXECUTE AS OWNER
as
begin
set nocount on

-- Estou ignorando o @tipoCons
-- Se NULL, ultimos 3 dias
if @dtIni is null 
select @dtIni = DATEADD(dd,-5,GETDATE()),@dtFim = dateadd(dd,1,GETDATE())



declare @tab table (id tinyint identity(1,1) primary key,Provedor varchar(30),TotalClientes int, Ativos int)
insert @tab
select 
case 
when email like '%Gmail%' then 'Gmail'
when email like '%Hotmail%' then 'Hotmail'
when email like '%Terra%' then 'Terra'
when email like '%@ig%' then 'IG'
when email like '%yahoo%' then 'Yahoo'
when email like '%Bol%' then 'Bol'
when email like '%Muitofacil%' then 'Lemon'
when email like '%Lemon%' then 'Lemon'
when email like '%Msn%' then 'Msn'
when email like '%ibest%' then 'Ibest'
when email like '%Globo%' then 'Globo'
when email like '%uol%' then 'Uol'
when email like '%.gov%' then '.Gov'
when email like '%aol%' then 'Aol'
when email like '%Sulamerica%' then 'Sulamerica'
when email like '%Bradesco%' then 'Bradesco'
when email like '%Petrobras%' then 'Petrobras'
when email like '%Brturbo%' then 'BrTurbo'
when email like '%Microsoft%' then 'Microsoft'
when email like '%SuperIg%' then 'SuperIG'
when email like '%click21%' then 'Click21'
when email like '%.org%' then '.Org'
--else 'Outros'
end as Provedor,  
COUNT(*) as TotalClientes,
sum(case when ativo = 1 then 1 else 0 end) as Ativos 
from Cliente (nolock)
where (dataCadastro between @dtIni and @dtFim) and (
email  like  '%Gmail%' -- then 'Gmail'
or   email  like  '%Hotmail%' -- then 'Hotmail'
or   email  like  '%Terra%' -- then 'Terra'
or   email  like  '%@ig%' -- then 'IG'
or   email  like  '%yahoo%' -- then 'Yahoo'
or   email  like  '%Bol%' -- then 'Bol'
or   email  like  '%Muitofacil%' -- then 'Lemon'
or   email  like  '%Lemon%' -- then 'Lemon'
or   email  like  '%Msn%' -- then 'Msn'
or   email  like  '%ibest%' -- then 'Ibest'
or   email  like  '%Globo%' -- then 'Globo'
or   email  like  '%uol%' -- then 'Uol'
or   email  like  '%.gov%' -- then '.Gov'
or   email  like  '%aol%' -- then 'Aol'
or   email  like  '%Sulamerica%' -- then 'Sulamerica'
or   email  like  '%Bradesco%' -- then 'Bradesco'
or   email  like  '%Petrobras%' -- then 'Petrobras'
or   email  like  '%Brturbo%' -- then 'BrTurbo'
or   email  like  '%Microsoft%' -- then 'Microsoft'
or   email  like  '%SuperIg%' -- then 'SuperIG'
or   email  like  '%click21%' -- then 'Click21'
or   email  like  '%.org%') -- then '.Org'
group by case
when email like '%Gmail%' then 'Gmail'
when email like '%Hotmail%' then 'Hotmail'
when email like '%Terra%' then 'Terra'
when email like '%@ig%' then 'IG'
when email like '%yahoo%' then 'Yahoo'
when email like '%Bol%' then 'Bol'
when email like '%Muitofacil%' then 'Lemon'
when email like '%Lemon%' then 'Lemon'
when email like '%Msn%' then 'Msn'
when email like '%ibest%' then 'Ibest'
when email like '%Globo%' then 'Globo'
when email like '%uol%' then 'Uol'
when email like '%.gov%' then '.Gov'
when email like '%aol%' then 'Aol'
when email like '%Sulamerica%' then 'Sulamerica'
when email like '%Bradesco%' then 'Bradesco'
when email like '%Petrobras%' then 'Petrobras'
when email like '%Brturbo%' then 'BrTurbo'
when email like '%Microsoft%' then 'Microsoft'
when email like '%SuperIg%' then 'SuperIG'
when email like '%click21%' then 'Click21'
when email like '%.org%' then '.Org'
--else 'Outros'
end
order by 2 desc


insert @tab
select 'OUTROS',COUNT(*) ,
sum(case when ativo = 1 then 1 else 0 end) 
from Cliente (nolock)
where dataCadastro between @dtIni and @dtFim and 
email not like  '%Gmail%' -- then 'Gmail'
and  email not like  '%Hotmail%' -- then 'Hotmail'
and  email not like  '%Terra%' -- then 'Terra'
and  email not like  '%@ig%' -- then 'IG'
and  email not like  '%yahoo%' -- then 'Yahoo'
and  email not like  '%Bol%' -- then 'Bol'
and  email not like  '%Muitofacil%' -- then 'Lemon'
and  email not like  '%Lemon%' -- then 'Lemon'
and  email not like  '%Msn%' -- then 'Msn'
and  email not like  '%ibest%' -- then 'Ibest'
and  email not like  '%Globo%' -- then 'Globo'
and  email not like  '%uol%' -- then 'Uol'
and  email not like  '%.gov%' -- then '.Gov'
and  email not like  '%aol%' -- then 'Aol'
and  email not like  '%Sulamerica%' -- then 'Sulamerica'
and  email not like  '%Bradesco%' -- then 'Bradesco'
and  email not like  '%Petrobras%' -- then 'Petrobras'
and  email not like  '%Brturbo%' -- then 'BrTurbo'
and  email not like  '%Microsoft%' -- then 'Microsoft'
and  email not like  '%SuperIg%' -- then 'SuperIG'
and  email not like  '%click21%' -- then 'Click21'
and  email not like  '%.org%' -- then '.Org'

insert @tab select 'TOTAL PERIODO',sum (TotalClientes),sum(Ativos) from @tab

insert @tab
select 'TOTAL GERAL',COUNT(*),sum(case when ativo = 1 then 1 else 0 end) 
from Cliente c (nolock) 


select CONVERT(char(15),'Provedor'),CONVERT(char(15),'TotalClientes'),CONVERT(char(15),'Ativos') union all
select CONVERT(char(15),Provedor),CONVERT(char(15),TotalClientes),CONVERT(char(15),Ativos)
from @tab --order by 1




end -- proc




GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_ClientesSexo]    Script Date: 04/27/2011 12:27:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE proc [dbo].[pr_Relat_ClientesSexo]
@dtIni smalldatetime = null, @dtFim smalldatetime = null,@tipoCons char(1) = 'D'
as
set nocount on

-- Estou ignorando o @tipoCons
-- Se NULL, ultimos 3 dias
if @dtIni is null 
select @dtIni = DATEADD(dd,-5,GETDATE()),@dtFim = dateadd(dd,1,GETDATE())

declare @result table (Data char(20) , Mulheres int, Homens int, NaoInformou int,Total int)

insert @result
select Data,isnull([F],0) as Mulheres,[M] as Homens,[N] as NaoInformou, isnull([F],0)+[M]+[N] as Total
from 
(select  convert(date,dataCadastro) as Data,isnull(Sexo,'N') as sexo, 1 as qtd
from Cliente c (nolock)where dataCadastro between @dtIni and @dtFim ) o
pivot
(sum(qtd) for sexo in ([F],[M],[N])) as pvt
order by 1


insert @result select 'TOTAL PERIODO',SUM(Mulheres),SUM(Homens),SUM(naoinformou),SUM(total) from @result

insert @result
select 'TOTAL GERAL',isnull([F],0) as Mulheres,[M] as Homens,[N] as NaoInformou, isnull([F],0)+[M]+[N] as Total
from 
(select  isnull(Sexo,'N') as sexo, 1 as qtd
from Cliente c (nolock)) o
pivot
(sum(qtd) for sexo in ([F],[M],[N])) as pvt

select * from @result



GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_LogCliente]    Script Date: 04/27/2011 12:27:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[pr_Relat_LogCliente] @email tdemail
as
begin
select a2.id as AcessoId, a3.*, t.*
from cliente c
join ODS.psafedb.dbo.assinatura a on c.id = a.clienteid
join ODS.psafedb.dbo.Acesso a2 on a.id = a2.assinaturaId
join ODS.psafedb.dbo.AcessoLogSemXml a3 on a2.id = a3.acessoId
join ODS.psafedb.dbo.tipolog t on a3.tipologid = t.id
where email = @email
order by 1
end

GO

/****** Object:  StoredProcedure [dbo].[sp_dba_AtivaClientes]    Script Date: 04/27/2011 12:27:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[sp_dba_AtivaClientes]
as
begin
declare @cont int, @texto varchar (100)
update Cliente set ativo = 1 where ativo <> 1
select @cont = @@ROWCOUNT
select @texto = 'Total = ' + convert(varchar(10),@cont)

exec msdb.dbo.sp_send_dbmail  @profile_name = 'PSafeNotifier',
@recipients = 'marco@grupoxango.com ; Rodrigo@grupoxango.com ; Fabricio@grupoxango.com ; Diego@grupoxango.com',
@body = @texto,
@subject=  'Clientes ativados pela proc DBA',
@body_format= 'HTML'
--@execute_query_database = 'ClienteDb',
--@query = 'exec ClienteDb.dbo.pr_Relat_ClientesAtivos',
--@attach_query_result_as_file = 1,
--@query_attachment_filename = 'ClientesAtivos.txt',
--@query_result_width  = 100,
--@query_result_separator = ';'


end
GO

/****** Object:  StoredProcedure [dbo].[sp_dba_identity]    Script Date: 04/27/2011 12:27:24 ******/
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
    GxClienteDb.sys.identity_columns IC
    JOIN
    GxClienteDb.sys.types T ON IC.system_type_id = T.system_type_id
    JOIN
    GxClienteDb.sys.objects O ON IC.object_id = O.object_id
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

/****** Object:  StoredProcedure [dbo].[sp_dba_monitorEncrypt]    Script Date: 04/27/2011 12:27:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


create proc [dbo].[sp_dba_monitorEncrypt]
as
SELECT DB_NAME(e.database_id) AS DatabaseName, 
            e.database_id, 
            e.encryption_state, 
    CASE e.encryption_state 
                WHEN 0 THEN 'No database encryption key present, no encryption' 
                WHEN 1 THEN 'Unencrypted' 
                WHEN 2 THEN 'Encryption in progress' 
                WHEN 3 THEN 'Encrypted' 
                WHEN 4 THEN 'Key change in progress' 
                WHEN 5 THEN 'Decryption in progress' 
    END AS encryption_state_desc, 
            c.name, 
            e.percent_complete 
    FROM sys.dm_database_encryption_keys AS e 
    LEFT JOIN master.sys.certificates AS c 
    ON e.encryptor_thumbprint = c.thumbprint 
GO

/****** Object:  StoredProcedure [dbo].[sp_dba_OrphanUser]    Script Date: 04/27/2011 12:27:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[sp_dba_OrphanUser]
as
ALTER USER [PSAFE\IIS_PROD] WITH LOGIN = [PSAFE\IIS_PROD]

GO

