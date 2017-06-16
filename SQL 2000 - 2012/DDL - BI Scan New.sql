USE [BiDb]
GO
--select * from tipoEstatistica
--select * from Virus order by 1
--select * from PSafeDb..ScanArquivos
--delete Virus where id = 0
alter table virus alter column nome tdDesc not null
alter table virus add md5 tdsmalldesc null
alter table virus add severidade tdSmallDesc null
go
create index Virus_ID02 on virus (md5) include (id,nome)
go


CREATE proc [dbo].[sp_dba_carga_Estatistica_2]
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
from psafedb.dbo.scan (nolock)
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
from Psafedb.dbo.scan (nolock)
where dataHora between @data and DATEADD(dd,1,@data)
group by DATEPART(hh,dataHora)


--Total Scans Com Vírus
select @tipoEstatisticaId = ID from TipoEstatistica where nome = 'Total Scans Com Vírus'

delete Estatistica where dataId = @dataId and TipoEstatisticaid = @tipoEstatisticaId 

insert Estatistica 
select @dataId,DATEPART(hh,dataHora),@tipoEstatisticaId,count(*)
from Psafedb.dbo.scan (nolock)
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
from Psafedb.dbo.scan a (nolock)
where dataHora between @data and DATEADD(dd,1,@data) and qtdVirus > 0 and 
--DEPOIS TIRAR A PARTE DE CIMA
not exists (select 1 from Psafedb.dbo.AcessoLog a2 (nolock) where a.acessoId = a2.acessoId and a2.dataHora < a.dataHora) and 
not exists (select 1 from Psafedb.dbo.Scan a2 (nolock) where a.acessoId = a2.acessoId and a2.dataHora < a.dataHora)
group by DATEPART(hh,dataHora)

--Total First Scans Sem Vírus
select @tipoEstatisticaId = ID from TipoEstatistica where nome = 'Total First Scans Sem Vírus'

delete Estatistica where dataId = @dataId and TipoEstatisticaid = @tipoEstatisticaId 

insert Estatistica 
select @dataId,DATEPART(hh,dataHora),@tipoEstatisticaId,count(*)
from Psafedb.dbo.AcessoLog a (nolock)
where dataHora between @data and DATEADD(dd,1,@data) and qtdVirus = 0 or qtdVirus is null and 
--DEPOIS TIRAR A PARTE DE CIMA
not exists (select 1 from Psafedb.dbo.AcessoLog a2 (nolock) where a.acessoId = a2.acessoId and a2.dataHora < a.dataHora) and 
not exists (select 1 from Psafedb.dbo.Scan a2 (nolock) where a.acessoId = a2.acessoId and a2.dataHora < a.dataHora)
group by DATEPART(hh,dataHora)


end --proc


GO

/****** Object:  StoredProcedure [dbo].[sp_dba_carga_Estatistica360]    Script Date: 06/01/2011 17:08:25 ******/


alter proc [dbo].[sp_dba_carga_Infeccao_2]
@data date
as
begin
set nocount on

declare @dataId int 

select @dataId = id from data where data = @data
if @@ROWCOUNT = 0 
exec sp_dba_carga_Data @data, @dataId output

declare @tab table (virus tdDesc, acessoId int,md5 tdSmallDesc ,severidade tdSmallDesc ,limpou varchar(10))



insert @tab
select 
sca.nomeArquivo,acessoid,sca.md5,sca.severidade,sca.limpou
from psafedb.dbo.scanarquivos sca (nolock) 
join psafedb.dbo.Scan s (nolock) on sca.scanId = s.id
where dataHora between @data and DATEADD(dd,1,@data) and qtdVirus > 0


insert Virus
select distinct Virus,md5,severidade from @tab t where not exists (select 1 from Virus v where v.md5 = t.md5)

delete Infeccao 
from Infeccao i 
join Virus v on i.virusId = v.id and v.md5 is not null
where dataId = @dataId
select 'DELETES: ',@@ROWCOUNT

insert Infeccao 
select 
acessoId,@dataId,v.id,case 
when limpou = 'true' then 1
else 0 end,count(v.id)
from @tab t
join Virus v on t.md5 = v.md5
group by acessoId,v.id,case 
when limpou = 'true' then 1
else 0 end
select 'INSERTS: ',@@ROWCOUNT

end -- proc


GO


