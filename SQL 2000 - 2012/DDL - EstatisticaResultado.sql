--/*
--select * from sys.sysprocesses where blocked <> 0
--exec sp_who2 active
--exec sp_helpdb
--exec xp_fixeddrives
--exec sp_dba_job


--*/

--create table EstatisticaResultado (
--id int identity(1,1) primary key,
--data date not null,
--tipo varchar(20) not null,
--qtdPcsProtegidos int null,
--qtdAmeacasEliminadas bigint null,
--virus tdsmalldesc null,
--virusOcorrencia int)
--go

--create index EstatisticaResultado_ID01 on EstatisticaResultado (data);


alter proc sp_dba_cargaEstatisticaResultado
as
begin
set nocount on

declare @resultado table (data date,tipo varchar(20),qtdPcsProtegidos int,qtdAmeacasEliminadas bigint,virus tdsmalldesc,virusOcorrencia int)
declare @data date , @qtdPcsProtegidos int, @qtdAmeacasEliminadas bigint

--360 2 dias
insert @resultado
select top 2 data,'360',qtdPcsProtegidos,qtdAmeacasEliminadas,null,null from Estatistica360 (nolock) order by data desc

--Psafe hj
select @data = MAX(data),@qtdAmeacasEliminadas = SUM(qtd) 
from Estatistica (nolock) e
join Data d (nolock) on e.dataId = d.id
where tipoEstatisticaId = 1

select @qtdPcsProtegidos = SUM(qtd) 
from Estatistica (nolock) e
join Data d (nolock) on e.dataId = d.id
where tipoEstatisticaId = 3 

insert @resultado
select @data,'Psafe',@qtdPcsProtegidos,@qtdAmeacasEliminadas,null,null

insert @resultado (data,tipo,virus,virusOcorrencia)
select top 10 @data,'Ranking Vírus', v.nome,SUM(qtd)
from infeccao e (nolock)
join Data d (nolock) on e.dataId = d.id
join virus v (nolock) on e.virusId = v.id
where data <= @data
group by v.nome
order by 4 desc

--Psafe ontem
select @data = MAX(data),@qtdAmeacasEliminadas = SUM(qtd) 
from Estatistica (nolock) e
join Data d (nolock) on e.dataId = d.id
where tipoEstatisticaId = 1 and d.data < @data --ONTEM

select @qtdPcsProtegidos = SUM(qtd) 
from Estatistica (nolock) e
join Data d (nolock) on e.dataId = d.id
where tipoEstatisticaId = 3 and d.data < @data --ontem

insert @resultado
select @data,'Psafe',@qtdPcsProtegidos,@qtdAmeacasEliminadas,null,null

insert @resultado (data,tipo,virus,virusOcorrencia)
select top 10 @data,'Ranking Vírus', v.nome,SUM(qtd)
from infeccao e (nolock)
join Data d (nolock) on e.dataId = d.id
join virus v (nolock) on e.virusId = v.id
where data < @data
group by v.nome
order by 4 desc


-- No delete abaixo vão os virus junto
delete EstatisticaResultado
from EstatisticaResultado e
join @resultado r on e.data = r.data

insert EstatisticaResultado 
select * from @resultado
order by 2,1,6 desc

end--proc
go

alter proc pr_EstatisticaResultado_lst
WITH EXECUTE AS OWNER
as
begin
set nocount on
select * from EstatisticaResultado where data >= DATEADD(dd,-5,getdate()) order by data desc, tipo
end



create role ODSDbRole;
grant execute to ODSDbRole;


create user [PSAFE\IIS_PROD] from login [PSAFE\IIS_PROD]


exec sp_addrolemember 'ODSDbRole','PSAFE\IIS_PROD'

