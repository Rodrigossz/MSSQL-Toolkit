
--insert TipoEstatistica select 'Total Scans',1
--insert TipoEstatistica select 'Total Scans Com Vírus',1
--insert TipoEstatistica select 'Total Scans Sem Vírus',1
--insert TipoEstatistica select 'Total First Scans Com Vírus',1
--insert TipoEstatistica select 'Total First Scans Sem Vírus',1

USE [BiDb]
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_cargaEstatistica]    Script Date: 05/26/2011 12:15:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER proc [dbo].[sp_dba_cargaEstatistica]
@data date
as
begin
declare @dataId int, @tipoEstatisticaId tinyint, @qtd int

select @dataId = id from data where data = @data
if @@ROWCOUNT = 0 
exec sp_dba_carga_Data @data, @dataId output



--Virus Eliminados
select @tipoEstatisticaId = ID from TipoEstatistica where nome = 'Virus Eliminados'

delete Estatistica where dataId = @dataId and TipoEstatisticaid = @tipoEstatisticaId 

insert Estatistica 
select @dataId,DATEPART(hh,dataHora),@tipoEstatisticaId,SUM(qtdvirus)
from psafedb.dbo.AcessoLog (nolock)
where dataHora between @data and DATEADD(dd,1,@data)
group by DATEPART(hh,dataHora)

--Clientes 
select @tipoEstatisticaId = ID from TipoEstatistica where nome = 'Clientes'

delete Estatistica where dataId = @dataId and TipoEstatisticaid = @tipoEstatisticaId 

insert Estatistica 
select @dataId,DATEPART(hh,dataCadastro),@tipoEstatisticaId,count(*)
from GXC.clientedb.dbo.Cliente
where dataCadastro between @data and DATEADD(dd,1,@data)
group by DATEPART(hh,dataCadastro)

--Pcs Protegidos 
select @tipoEstatisticaId = ID from TipoEstatistica where nome = 'Pcs Protegidos'

delete Estatistica where dataId = @dataId and TipoEstatisticaid = @tipoEstatisticaId 

insert Estatistica 
select @dataId,DATEPART(hh,dataHora),@tipoEstatisticaId,count(distinct pcId)
from Psafedb.dbo.acesso (nolock)
where dataHora between @data and DATEADD(dd,1,@data)
group by DATEPART(hh,dataHora)


--Total Scans
select @tipoEstatisticaId = ID from TipoEstatistica where nome = 'Total Scans'

delete Estatistica where dataId = @dataId and TipoEstatisticaid = @tipoEstatisticaId 

insert Estatistica 
select @dataId,DATEPART(hh,dataHora),@tipoEstatisticaId,count(*)
from Psafedb.dbo.AcessoLog (nolock)
where dataHora between @data and DATEADD(dd,1,@data)
group by DATEPART(hh,dataHora)


--Total Scans Com Vírus
select @tipoEstatisticaId = ID from TipoEstatistica where nome = 'Total Scans Com Vírus'

delete Estatistica where dataId = @dataId and TipoEstatisticaid = @tipoEstatisticaId 

insert Estatistica 
select @dataId,DATEPART(hh,dataHora),@tipoEstatisticaId,count(*)
from Psafedb.dbo.AcessoLog (nolock)
where dataHora between @data and DATEADD(dd,1,@data) and qtdVirus > 0
group by DATEPART(hh,dataHora)


--Total Scans Sem Vírus
select @tipoEstatisticaId = ID from TipoEstatistica where nome = 'Total Scans Sem Vírus'

delete Estatistica where dataId = @dataId and TipoEstatisticaid = @tipoEstatisticaId 

insert Estatistica 
select @dataId,DATEPART(hh,dataHora),@tipoEstatisticaId,count(*)
from Psafedb.dbo.AcessoLog (nolock)
where dataHora between @data and DATEADD(dd,1,@data) and qtdVirus = 0 or qtdVirus is null
group by DATEPART(hh,dataHora)


--Total First Scans Com Vírus
select @tipoEstatisticaId = ID from TipoEstatistica where nome = 'Total First Scans Com Vírus'

delete Estatistica where dataId = @dataId and TipoEstatisticaid = @tipoEstatisticaId 

insert Estatistica 
select @dataId,DATEPART(hh,dataHora),@tipoEstatisticaId,count(*)
from Psafedb.dbo.AcessoLog a (nolock)
where dataHora between @data and DATEADD(dd,1,@data) and qtdVirus > 0 and not exists
(select 1 from Psafedb.dbo.AcessoLog a2 (nolock) where a.acessoId = a2.acessoId and a2.dataHora < a.dataHora)
group by DATEPART(hh,dataHora)


--Total First Scans Sem Vírus
select @tipoEstatisticaId = ID from TipoEstatistica where nome = 'Total First Scans Sem Vírus'

delete Estatistica where dataId = @dataId and TipoEstatisticaid = @tipoEstatisticaId 

insert Estatistica 
select @dataId,DATEPART(hh,dataHora),@tipoEstatisticaId,count(*)
from Psafedb.dbo.AcessoLog a (nolock)
where dataHora between @data and DATEADD(dd,1,@data) and qtdVirus = 0 or qtdVirus is null and not exists
(select 1 from Psafedb.dbo.AcessoLog a2 (nolock) where a.acessoId = a2.acessoId and a2.dataHora < a.dataHora)
group by DATEPART(hh,dataHora)


end --proc
go

select * from Estatistica order by dataId desc
select * from Data


exec sp_dba_cargaEstatistica '20110401'
exec sp_dba_cargaEstatistica '20110402'
exec sp_dba_cargaEstatistica '20110403'
exec sp_dba_cargaEstatistica '20110404'
exec sp_dba_cargaEstatistica '20110405'
exec sp_dba_cargaEstatistica '20110406'
exec sp_dba_cargaEstatistica '20110407'
exec sp_dba_cargaEstatistica '20110408'
exec sp_dba_cargaEstatistica '20110409'
exec sp_dba_cargaEstatistica '20110410'
exec sp_dba_cargaEstatistica '20110411'
exec sp_dba_cargaEstatistica '20110412'
exec sp_dba_cargaEstatistica '20110413'
exec sp_dba_cargaEstatistica '20110414'
exec sp_dba_cargaEstatistica '20110415'
exec sp_dba_cargaEstatistica '20110416'
exec sp_dba_cargaEstatistica '20110417'
exec sp_dba_cargaEstatistica '20110418'
exec sp_dba_cargaEstatistica '20110419'
exec sp_dba_cargaEstatistica '20110420'
exec sp_dba_cargaEstatistica '20110421'
exec sp_dba_cargaEstatistica '20110422'
exec sp_dba_cargaEstatistica '20110423'
exec sp_dba_cargaEstatistica '20110424'
exec sp_dba_cargaEstatistica '20110425'
exec sp_dba_cargaEstatistica '20110426'
exec sp_dba_cargaEstatistica '20110427'
exec sp_dba_cargaEstatistica '20110428'
exec sp_dba_cargaEstatistica '20110429'
exec sp_dba_cargaEstatistica '20110430'



exec sp_dba_cargaEstatistica '20110501'
exec sp_dba_cargaEstatistica '20110502'
exec sp_dba_cargaEstatistica '20110503'
exec sp_dba_cargaEstatistica '20110504'
exec sp_dba_cargaEstatistica '20110505'
exec sp_dba_cargaEstatistica '20110506'
exec sp_dba_cargaEstatistica '20110507'
exec sp_dba_cargaEstatistica '20110508'
exec sp_dba_cargaEstatistica '20110509'
exec sp_dba_cargaEstatistica '20110510'
exec sp_dba_cargaEstatistica '20110511'
exec sp_dba_cargaEstatistica '20110512'
exec sp_dba_cargaEstatistica '20110513'
exec sp_dba_cargaEstatistica '20110514'
exec sp_dba_cargaEstatistica '20110515'
exec sp_dba_cargaEstatistica '20110516'
exec sp_dba_cargaEstatistica '20110517'
exec sp_dba_cargaEstatistica '20110518'
exec sp_dba_cargaEstatistica '20110519'
exec sp_dba_cargaEstatistica '20110520'
exec sp_dba_cargaEstatistica '20110521'
exec sp_dba_cargaEstatistica '20110522'
exec sp_dba_cargaEstatistica '20110523'
exec sp_dba_cargaEstatistica '20110524'
exec sp_dba_cargaEstatistica '20110525'
exec sp_dba_cargaEstatistica '20110526'



