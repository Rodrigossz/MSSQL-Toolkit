--select MAX(dataid) from Infeccao
--select * from data where ID = 25


create table Virus (
id int identity(1,1) primary key,
nome tdsmalldesc not null)
go
create index Virus_ID01 on Virus (nome) include (id)
go
set identity_insert.virus on
insert virus (id,nome) values (0,'Sem Vírus')
set identity_insert.virus off


create table Infeccao (
id int identity(1,1) primary key,
acessoId int not null,
dataId int not null references data,
virusId int not null references virus,
limpou bit not null,
qtd smallint not null)
go
create index Infeccao_ID01 on Infeccao (acessoId);
create index Infeccao_ID02 on Infeccao (dataId);
create index Infeccao_ID03 on Infeccao (VirusId);
go

alter proc sp_dba_cargaInfeccao
@data date
as
begin
set nocount on

declare @dataId int 

select @dataId = id from data where data = @data
if @@ROWCOUNT = 0 
exec sp_dba_carga_Data @data, @dataId output

declare @tab table (virus tdsmalldesc, acessoId int, limpou varchar(10))


--insert @tab
--select 'Sem Vírus',acessoid,0
--from psafedb.dbo.acessolog (nolock) where dataHora between @data and DATEADD(dd,1,@data) and qtdVirus = 0 or qtdVirus is null


insert @tab
select 
logExecXml.value('(//AmeacaList/Ameaca/Nome)[1]', 'nvarchar(80)'),
acessoid,
logExecXml.value('(//AmeacaList/Ameaca/Limpou)[1]', 'nvarchar(10)')
from psafedb.dbo.acessolog (nolock) where dataHora between @data and DATEADD(dd,1,@data) and qtdVirus = 1
and logExecXml.value('(//AmeacaList/Ameaca/Nome)[1]', 'nvarchar(80)') is not null

insert @tab
select 
logExecXml.value('(//AmeacaList/Ameaca/Nome)[2]', 'nvarchar(80)'),
acessoid,
logExecXml.value('(//AmeacaList/Ameaca/Limpou)[2]', 'nvarchar(10)')
from psafedb.dbo.acessolog (nolock) where dataHora between @data and DATEADD(dd,1,@data)  and qtdVirus = 2
and logExecXml.value('(//AmeacaList/Ameaca/Nome)[2]', 'nvarchar(80)') is not null

insert @tab
select 
logExecXml.value('(//AmeacaList/Ameaca/Nome)[3]', 'nvarchar(80)'),
acessoid,
logExecXml.value('(//AmeacaList/Ameaca/Limpou)[3]', 'nvarchar(10)')
from psafedb.dbo.acessolog (nolock) where dataHora between @data and DATEADD(dd,1,@data)  and qtdVirus = 3
and logExecXml.value('(//AmeacaList/Ameaca/Nome)[3]', 'nvarchar(80)') is not null


insert @tab
select 
logExecXml.value('(//AmeacaList/Ameaca/Nome)[4]', 'nvarchar(80)'),
acessoid,
logExecXml.value('(//AmeacaList/Ameaca/Limpou)[4]', 'nvarchar(10)')
from psafedb.dbo.acessolog (nolock) where dataHora between @data and DATEADD(dd,1,@data)  and qtdVirus = 4
and logExecXml.value('(//AmeacaList/Ameaca/Nome)[4]', 'nvarchar(80)') is not null


insert @tab
select 
logExecXml.value('(//AmeacaList/Ameaca/Nome)[5]', 'nvarchar(80)'),
acessoid,
logExecXml.value('(//AmeacaList/Ameaca/Limpou)[5]', 'nvarchar(10)')
from psafedb.dbo.acessolog (nolock) where dataHora between @data and DATEADD(dd,1,@data)  and qtdVirus = 4
and logExecXml.value('(//AmeacaList/Ameaca/Nome)[5]', 'nvarchar(80)') is not null



delete @tab where virus is null
delete @tab where virus like '?%'
update @tab set virus = substring (virus,CHARINDEX('/',virus,1)+1,80)

insert Virus
select distinct Virus from @tab t where not exists (select 1 from Virus v where v.nome = t.virus)

--select acessoId,virus,limpou,COUNT(*) from @tab where acessoId = 15227
--group by acessoId,virus,limpou

delete Infeccao where dataId = @dataId
select 'DELETES: ',@@ROWCOUNT

insert Infeccao 
select 
acessoId,@dataId,v.id,case 
when limpou = 'true' then 1
else 0 end,count(v.id)
from @tab t
join Virus v on t.virus = v.nome
group by acessoId,v.id,case 
when limpou = 'true' then 1
else 0 end
select 'INSERTS: ',@@ROWCOUNT

end -- proc
go


exec sp_dba_cargaInfeccao '20110401'
exec sp_dba_cargaInfeccao '20110402'
exec sp_dba_cargaInfeccao '20110403'
exec sp_dba_cargaInfeccao '20110404'
exec sp_dba_cargaInfeccao '20110405'
exec sp_dba_cargaInfeccao '20110406'
exec sp_dba_cargaInfeccao '20110407'
exec sp_dba_cargaInfeccao '20110408'

exec sp_dba_cargaInfeccao '20110409'
exec sp_dba_cargaInfeccao '20110410'
exec sp_dba_cargaInfeccao '20110411'
exec sp_dba_cargaInfeccao '20110412'
exec sp_dba_cargaInfeccao '20110413'
exec sp_dba_cargaInfeccao '20110414'
exec sp_dba_cargaInfeccao '20110415'

exec sp_dba_cargaInfeccao '20110416'
exec sp_dba_cargaInfeccao '20110417'
exec sp_dba_cargaInfeccao '20110418'
exec sp_dba_cargaInfeccao '20110419'
exec sp_dba_cargaInfeccao '20110420'
exec sp_dba_cargaInfeccao '20110421'

exec sp_dba_cargaInfeccao '20110422'
exec sp_dba_cargaInfeccao '20110423'
exec sp_dba_cargaInfeccao '20110424'
exec sp_dba_cargaInfeccao '20110425'
exec sp_dba_cargaInfeccao '20110426'

exec sp_dba_cargaInfeccao '20110427'
exec sp_dba_cargaInfeccao '20110428'
exec sp_dba_cargaInfeccao '20110429'
exec sp_dba_cargaInfeccao '20110430'


exec sp_dba_cargaInfeccao '20110501'
exec sp_dba_cargaInfeccao '20110502'
exec sp_dba_cargaInfeccao '20110503'
exec sp_dba_cargaInfeccao '20110504'
exec sp_dba_cargaInfeccao '20110505'
exec sp_dba_cargaInfeccao '20110506'
exec sp_dba_cargaInfeccao '20110507'

exec sp_dba_cargaInfeccao '20110508'
exec sp_dba_cargaInfeccao '20110509'
exec sp_dba_cargaInfeccao '20110510'
exec sp_dba_cargaInfeccao '20110511'
exec sp_dba_cargaInfeccao '20110512'
exec sp_dba_cargaInfeccao '20110513'

exec sp_dba_cargaInfeccao '20110514'
exec sp_dba_cargaInfeccao '20110515'
exec sp_dba_cargaInfeccao '20110516'
exec sp_dba_cargaInfeccao '20110517'
exec sp_dba_cargaInfeccao '20110518'

exec sp_dba_cargaInfeccao '20110519'
exec sp_dba_cargaInfeccao '20110520'
exec sp_dba_cargaInfeccao '20110521'
exec sp_dba_cargaInfeccao '20110522'
exec sp_dba_cargaInfeccao '20110523'
exec sp_dba_cargaInfeccao '20110524'
exec sp_dba_cargaInfeccao '20110525'
exec sp_dba_cargaInfeccao '20110526'
exec sp_dba_cargaInfeccao '20110527'



select COUNT(*) from Virus

select v.nome,SUM(qtd)
from Infeccao i
join Virus v on i.virusId = v.id 
where limpou = 0
group by v.nome
order by 2 desc


select v.nome,SUM(qtd)
from Infeccao i
join Virus v on i.virusId = v.id 
where limpou = 1
group by v.nome
order by 2 desc


select data, avg(qtd)
from Infeccao i
join data d on i.dataId = d.id 
where limpou = 0
group by data


select avg(qtd)
from Infeccao
where limpou = 0


select * from Infeccao where dataId = 44 order by qtd desc
select * from data where id = 56

select * from psafedb..AcessoLog where acessoId = 15227 and dataHora >= '20110514' and dataHora < '20110515'

select * from Estatistica order by 1 desc

