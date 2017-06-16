use BiDb
go
--exec sp_help firstscan
--desinstalacao
--select top 10 * from PSafeDB_Hist..AcessoLog order by 1 desc

drop table VersaoPc
go

create table VersaoPc (
id int identity(1,1) primary key,
pcId int not null,
versaoInicialId smallint not null,
versaoInicialOk bit not null,
dataHoraVersaoInicial smalldatetime  null,
versaoAtualId smallint not null,
versaoAtualOk bit not null,
dataHoraVersaoAtual smalldatetime  null,
versaoDesinstalacaoId smallint  null,
dataHoraDesinstalacao smalldatetime null,
scan30Dias bit,
scan7Dias bit)
go
create index VersaoPc_ID01 on versaoPC (pcId)
go

create index VersaoPc_ID02 on versaoPC (versaoDesinstalacaoId)
go

create index VersaoPc_ID03 on versaoPC (versaoAtualId) include (versaoAtualOk)
go
create index VersaoPc_ID04 on versaoPC (dataHoraVersaoInicial) include (pcid)
go


alter proc sp_dba_carga_VersaoPc
as
begin
set nocount on

--versao Inicial
insert  VersaoPc
select pcid,MIN(isnull(versaoid,0)),0,null,
Max(isnull(versaoid,0)),0,null,null,null,0,0
from PSafeDb..Instalacao i
where pcId is not null and not exists
(select 1 from VersaoPc v where i.pcId = v.pcId)
group by pcid,case when dataHoraSucesso IS not null then 1 else 0 end

--dataHoraVersaoInicial
update  VersaoPc
set dataHoraVersaoInicial = i.dataHora
from VersaoPc v
join PSafeDb..Instalacao i on v.pcId = i.pcId and  v.versaoInicialId = isnull(i.versaoid,0)
where dataHoraVersaoInicial is null

--Coisas atuais
update  VersaoPc
set versaoAtualId = i.versaoId, dataHoraVersaoAtual = i.dataHora
from VersaoPc v
join PSafeDb..Instalacao i on v.pcId = i.pcId 
where i.versaoId = (select MAX(versaoid) from PSafeDb..Instalacao i2 where i2.pcId = v.pcId)
and versaoAtualId < (select MAX(versaoid) from PSafeDb..Instalacao i2 where i2.pcId = v.pcId)

update versaoPc set scan30dias = 0 where scan7dias = 0
update versaoPc set scan30dias = 1 where scan7dias = 1
update versaoPc set scan7dias = 0

update VersaoPc 
set scan30dias = 1
from VersaoPc v
join PSafeDb..VersaoAplic v2 on v.versaoAtualId = v2.id
where
exists (select 1 from PSafeDb..Acesso a join PSafeDb..Scan s on a.id = s.acessoId 
where a.pcId = v.pcId and s.dataHora >= DATEADD(dd,-30,GETDATE())) and scan30dias = 0

update VersaoPc 
set scan30dias = 1
from VersaoPc v
join PSafeDb..VersaoAplic v2 on v.versaoAtualId = v2.id
where
exists (select 1 from PSafeDb..Acesso a join PSafeDB_Hist..AcessoLog s on a.id = s.acessoId 
where a.pcId = v.pcId and s.dataHora >= DATEADD(dd,-30,GETDATE())) and scan30dias = 0


update VersaoPc 
set scan7dias = 1
from VersaoPc v
join PSafeDb..VersaoAplic v2 on v.versaoAtualId = v2.id
where
exists (select 1 from PSafeDb..Acesso a join PSafeDb..Scan s on a.id = s.acessoId 
where a.pcId = v.pcId and s.dataHora >= DATEADD(dd,-7,GETDATE()))
and v2.dataProducao < DATEADD(dd,-7,GETDATE()) and scan7dias = 0


update VersaoPc
set versaoInicialOk = 1
from VersaoPc v
join PSafeDb..Instalacao i on v.pcId = i.pcId and v.versaoInicialId = isnull(i.versaoid,0)
where 
i.dataHoraSucesso is not null and versaoInicialOk = 0

update VersaoPc
set versaoAtualOk = 1
from VersaoPc v
join PSafeDb..Instalacao i on v.pcId = i.pcId and v.versaoAtualId = i.versaoid
where 
i.dataHoraSucesso is not null and versaoAtualOk = 0


update VersaoPc
set versaoDesinstalacaoId = d.versaoId, dataHoraDesinstalacao = d.dataHora
from VersaoPc v
join PSafeDb..Instalacao i on v.pcId = i.pcId and v.versaoAtualId = i.versaoid
join PSafeDb..Desinstalacao d on d.guId = i.guId and i.versaoId = d.versaoid
where 
versaoDesinstalacaoId is null

update VersaoPc
set versaoDesinstalacaoId = d.versaoId, dataHoraDesinstalacao = d.dataHora
from VersaoPc v
join PSafeDb..Instalacao i on v.pcId = i.pcId and v.versaoAtualId = i.versaoid
join PSafeDb..Desinstalacao d on d.guId = i.guId --and i.versaoId = d.versaoid
where 
versaoDesinstalacaoId is null

end
go

exec sp_dba_carga_VersaoPc
go

select v2.nome,SUM(convert(tinyint,versaoatualOk)) as Qtd, SUM(convert(tinyint,scan7Dias)) as TemScan7Dias,
SUM(convert(tinyint,scan30Dias)) as TemScan30Dias, SUM(case when versaoDesinstalacaoId IS not null then 1 else 0 end) as Desinstalacoes
--SUM(convert(tinyint,versaoatualOk))- SUM(convert(tinyint,scan7Dias))-SUM(convert(tinyint,scan30Dias)) as Inativos
from VersaoPc v
join PSafeDb..VersaoAplic v2 on v2.id = v.versaoAtualId
group by v2.nome
union
select 'Sem VersaoId',COUNT(*),null,null,null
from VersaoPc where versaoAtualId = 0
order by 1

select v2.nome,COUNT(*) as Qtd
from VersaoPc v
join PSafeDb..VersaoAplic v2 on v2.id = v.versaoDesinstalacaoId
group by v2.nome
union
select 'Sem VersaoId',COUNT(*) from VersaoPc where versaoAtualId = 0
order by 1





--select * from PSafeDb..Instalacao i
--where versaoId is null and not exists (select 1 from PSafeDb..Instalacao i2 where i.pcid = i2.pcId and i2.versaoId is not null)


--select top 100 * from VersaoPc

exec sp_dba_carga_VersaoPc
select COUNT(*) from PSafeDb..Pc a where not exists (select 1 from VersaoPc b where a.id = b.pcId)
select COUNT(*) from PSafeDb..Pc a where not exists (select 1 from PSafeDb..Acesso b where a.id = b.pcId)
select COUNT(*) from PSafeDb..Pc a where not exists (select 1 from PSafeDb..Instalacao b where a.id = b.pcId)
