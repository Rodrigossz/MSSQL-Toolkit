/*select * from TipoEstatistica

insert TipoEstatistica select 'Indicacoes Nao Convertidas',1
insert TipoEstatistica select 'Indicacoes Convertidas',1

USE [BiDb]
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_carga_Estatistica_2]    Script Date: 06/06/2011 19:42:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[sp_dba_carga_Estatistica_2]
@data date
as
begin
set nocount on
declare @dataId int, @tipoEstatisticaId tinyint, @qtd int

declare @estatistica table (dataId int,horaid int,tipoestatisticaid int,qtd int)

select @dataId = id from data where data = @data
if @@ROWCOUNT = 0 
exec sp_dba_carga_Data @data, @dataId output

--VOU MANTER A HORA POR ENQUANTO.

-- AcessoLog
--if @dataId < 63
--select 'ESTATISTICAS DE SCANS EM OUTRA TABELA PARA ESSA DATA. CHAME O DBA'

--Virus Eliminados
select @tipoEstatisticaId = ID from TipoEstatistica where nome = 'Virus Eliminados'

insert @Estatistica 
select @dataId,DATEPART(hh,GETDATE()),@tipoEstatisticaId,SUM(qtd)
from infeccao (nolock)
where dataId = @dataId


--Clientes 
select @tipoEstatisticaId = ID from TipoEstatistica where nome = 'Clientes'

insert @Estatistica 
select @dataId,DATEPART(hh,GETDATE()),@tipoEstatisticaId,count(*)
from GXC.clientedb.dbo.Cliente
where dataCadastro between @data and DATEADD(dd,1,@data)


--Pcs Protegidos 
select @tipoEstatisticaId = ID from TipoEstatistica where nome = 'Pcs Protegidos'

insert @Estatistica 
select @dataId,DATEPART(hh,GETDATE()),@tipoEstatisticaId,count(distinct pcId)
from Psafedb.dbo.acesso (nolock)
where dataHora between @data and DATEADD(dd,1,@data)


--Total Scans
select @tipoEstatisticaId = ID from TipoEstatistica where nome = 'Total Scans'

insert @Estatistica 
select @dataId,DATEPART(hh,GETDATE()),@tipoEstatisticaId,count(*)
from Psafedb.dbo.scan (nolock)
where dataHora between @data and DATEADD(dd,1,@data)


--Total Scans Com Vírus
select @tipoEstatisticaId = ID from TipoEstatistica where nome = 'Total Scans Com Vírus'

insert @Estatistica 
select @dataId,DATEPART(hh,GETDATE()),@tipoEstatisticaId,count(*)
from Psafedb.dbo.scan (nolock)
where dataHora between @data and DATEADD(dd,1,@data) and qtdVirus > 0


--Total Scans Sem Vírus
select @tipoEstatisticaId = ID from TipoEstatistica where nome = 'Total Scans Sem Vírus'

insert @Estatistica 
select @dataId,DATEPART(hh,GETDATE()),@tipoEstatisticaId,count(*)
from Psafedb.dbo.Scan (nolock)
where dataHora between @data and DATEADD(dd,1,@data) and qtdVirus = 0 or qtdVirus is null



--Total First Scans Com Vírus
select @tipoEstatisticaId = ID from TipoEstatistica where nome = 'Total First Scans Com Vírus'

insert @Estatistica 
select @dataId,DATEPART(hh,GETDATE()),@tipoEstatisticaId,count(*)
from FirstScan a (nolock)
where dataHora between @data and DATEADD(dd,1,@data) and qtdVirus > 0 


--Total First Scans Sem Vírus
select @tipoEstatisticaId = ID from TipoEstatistica where nome = 'Total First Scans Sem Vírus'

insert @Estatistica 
select @dataId,DATEPART(hh,GETDATE()),@tipoEstatisticaId,count(*)
from Psafedb.dbo.scan a (nolock)
where dataHora between @data and DATEADD(dd,1,@data) and qtdVirus = 0 


--Instalacao Com Falha
select @tipoEstatisticaId = ID from TipoEstatistica where nome = 'Instalacao Com Falha'

insert @Estatistica 
select @dataId,DATEPART(hh,GETDATE()),@tipoEstatisticaId,count(*)
from Psafedb.dbo.Instalacao a (nolock)
where dataHora between @data and DATEADD(dd,1,@data) and pcId is null and datahoraSucesso is null and upgrade = 0 


--Instalacao Sem Falha
select @tipoEstatisticaId = ID from TipoEstatistica where nome = 'Instalacao Sem Falha'

insert @Estatistica 
select @dataId,DATEPART(hh,GETDATE()),@tipoEstatisticaId,count(*)
from Psafedb.dbo.Instalacao a (nolock)
where dataHora between @data and DATEADD(dd,1,@data) and pcId is not null  and upgrade = 0


--Instalacao Desistencia
select @tipoEstatisticaId = ID from TipoEstatistica where nome = 'Instalacao Desistencia'

insert @Estatistica 
select @dataId,DATEPART(hh,GETDATE()),@tipoEstatisticaId,count(*)
from Psafedb.dbo.Instalacao a (nolock)
where dataHora between @data and DATEADD(dd,1,@data) and pcId is null and datahoraSucesso is not null and upgrade = 0


--Desinstalacao
select @tipoEstatisticaId = ID from TipoEstatistica where nome = 'Desinstalacao'

insert @Estatistica 
select @dataId,DATEPART(hh,GETDATE()),@tipoEstatisticaId,count(*)
from Psafedb.dbo.Desinstalacao a (nolock)
where dataHora between @data and DATEADD(dd,1,@data) 


--Upgrade Com Falha
select @tipoEstatisticaId = ID from TipoEstatistica where nome = 'Upgrade Com Falha'

insert @Estatistica 
select @dataId,DATEPART(hh,GETDATE()),@tipoEstatisticaId,count(*)
from Psafedb.dbo.Instalacao a (nolock)
where dataHora between @data and DATEADD(dd,1,@data) and upgrade = 1 and
datahoraSucesso is null

--Upgrade Sem Falha
select @tipoEstatisticaId = ID from TipoEstatistica where nome = 'Upgrade Sem Falha'

insert @Estatistica 
select @dataId,DATEPART(hh,GETDATE()),@tipoEstatisticaId,count(*)
from Psafedb.dbo.Instalacao a (nolock)
where dataHora between @data and DATEADD(dd,1,@data) and upgrade = 1 and
datahoraSucesso is not null


--Crédito Fidelidade 
select @tipoEstatisticaId = ID from TipoEstatistica where nome = 'Crédito Fidelidade'

insert @Estatistica 
select @dataId,DATEPART(hh,GETDATE()),@tipoEstatisticaId,count(*)
from GXC.Fidelidadedb.dbo.Lancamento
where dataHora between @data and DATEADD(dd,1,@data) and creditoId is not null


--Resgate Fidelidade
select @tipoEstatisticaId = ID from TipoEstatistica where nome = 'Resgate Fidelidade'

insert @Estatistica 
select @dataId,DATEPART(hh,GETDATE()),@tipoEstatisticaId,count(*)
from GXC.Fidelidadedb.dbo.Lancamento
where dataHora between @data and DATEADD(dd,1,@data) and recompensaId is not null


--Indicacoes Nao Convertidas
select @tipoEstatisticaId = ID from TipoEstatistica where nome = 'Indicacoes Nao Convertidas'

insert @Estatistica 
select @dataId,DATEPART(hh,GETDATE()),@tipoEstatisticaId,count(*)
from Psafedb.dbo.Indicacao a (nolock)
where dataHora between @data and DATEADD(dd,1,@data) and assinaturaIndicadoId is null


--Indicacoes Convertidas
select @tipoEstatisticaId = ID from TipoEstatistica where nome = 'Indicacoes Convertidas'

insert @Estatistica 
select @dataId,DATEPART(hh,GETDATE()),@tipoEstatisticaId,count(*)
from Psafedb.dbo.Indicacao a (nolock)
where dataHora between @data and DATEADD(dd,1,@data) and assinaturaIndicadoId is not null


-- FINAL

delete Estatistica
from Estatistica e1 join @estatistica e2 on e1.dataId = e2.dataId and e1.tipoEstatisticaId = e2.tipoestatisticaid
select @@rowcount , 'DELETES'


insert Estatistica
select dataid,horaid,tipoEstatisticaId,SUM(qtd)
from @estatistica
group by dataid,horaid,tipoEstatisticaId
select @@rowcount, 'INSERTS'

end --proc
go

declare @data date = '20110404'

while @data <= GETDATE()
begin
exec sp_dba_carga_Estatistica_2 @data
select @data = DATEADD(dd,1,@data)
end
go

*/

create proc pr_relat_Estatisticas
@dtIni date = null, @dtFim date = null
with execute as owner
as
begin
set nocount on


-- Se NULL, ultimos 5 dias
if @dtIni is null 
select @dtIni = GETDATE() --,@dtFim = dateadd(dd,1,GETDATE())

declare @data5 table (Estatistica tdsmalldesc,Data date,Qtd int)
insert @data5 
select nome,data,SUM(qtd)
from Estatistica e 
join TipoEstatistica te on e.tipoEstatisticaId = te.id
join Data d on e.dataId = d.id
where data = dateadd(dd,-5,@dtIni)
group by nome,data

declare @data4 table (Estatistica tdsmalldesc,Data date,Qtd int)
insert @data4 
select nome,data,SUM(qtd)
from Estatistica e 
join TipoEstatistica te on e.tipoEstatisticaId = te.id
join Data d on e.dataId = d.id
where data = dateadd(dd,-4,@dtIni)
group by nome,data

declare @data3 table (Estatistica tdsmalldesc,Data date,Qtd int)
insert @data3 
select nome,data,SUM(qtd)
from Estatistica e 
join TipoEstatistica te on e.tipoEstatisticaId = te.id
join Data d on e.dataId = d.id
where data = dateadd(dd,-3,@dtIni)
group by nome,data

declare @data2 table (Estatistica tdsmalldesc,Data date,Qtd int)
insert @data2 
select nome,data,SUM(qtd)
from Estatistica e 
join TipoEstatistica te on e.tipoEstatisticaId = te.id
join Data d on e.dataId = d.id
where data = dateadd(dd,-2,@dtIni)
group by nome,data

declare @data1 table (Estatistica tdsmalldesc,Data date,Qtd int)
insert @data1 
select nome,data,SUM(qtd)
from Estatistica e 
join TipoEstatistica te on e.tipoEstatisticaId = te.id
join Data d on e.dataId = d.id
where data = dateadd(dd,-1,@dtIni)
group by nome,data

declare @data table (Estatistica tdsmalldesc,Data date,Qtd int)
insert @data 
select nome,data,SUM(qtd)
from Estatistica e 
join TipoEstatistica te on e.tipoEstatisticaId = te.id
join Data d on e.dataId = d.id
where data = @dtIni
group by nome,data

select d.Estatistica, d5.Qtd as 'D-5',d4.Qtd as 'D-4',d3.Qtd as 'D-3',d2.Qtd as 'D-2',d1.Qtd as 'D-1',d.Qtd as 'HOJE'
from @data d
left outer join @data1 d1 on d.Estatistica = d1.Estatistica
left outer join @data2 d2 on d.Estatistica = d2.Estatistica
left outer join @data3 d3 on d.Estatistica = d3.Estatistica
left outer join @data4 d4 on d.Estatistica = d4.Estatistica
left outer join @data5 d5 on d.Estatistica = d5.Estatistica

end
