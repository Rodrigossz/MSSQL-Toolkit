drop table FirstScan
go
create table FirstScan (
id int identity(1,1) primary key,
acessoId int not null,
dataHora smalldatetime not null,
qtdVirus int not null)
go
create index FirstScan_ID01 on FirstScan (dataHora);
create unique index FirstScan_ID02 on FirstScan (acessoId);
go

declare @result table (acessoid int, id int primary key)

insert @result
select acessoid,MIN(id)
from PSafeDb..AcessoLog
group by acessoId

insert FirstScan
select a1.acessoId,dataHora,isnull(qtdVirus,0)
from PSafeDb..AcessoLog a1
join @result r on a1.id = r.id

--teste
select acessoid,COUNT(*) from FirstScan group by acessoid having COUNT(*) > 1
go


declare @result table (acessoid int, id int primary key)

insert @result
select acessoid,MIN(id)
from PSafeDb..Scan a1 where
not exists (select 1 from FirstScan f where a1.acessoId = f.acessoId)
group by acessoId

insert FirstScan
select a1.acessoId,dataHora,isnull(qtdVirus,0)
from PSafeDb..Scan a1
join @result r on a1.id = r.id
--where not exists (select 1 from psafedb..Scan a2 where a1.acessoId = a2.acessoId and a2.dataHora < a1.dataHora) 

--teste
select acessoid,COUNT(*) from FirstScan group by acessoid having COUNT(*) > 1
go



alter proc sp_dba_carga_FirstScan
@data date
as
begin
set nocount on

declare @dataId int 

select @dataId = id from data where data = @data
if @@ROWCOUNT = 0 
exec sp_dba_carga_Data @data, @dataId output

declare @result table (acessoid int, id int primary key)

insert @result
select acessoid,MIN(id)
from PSafeDb..Scan a1 where dataHora between @data and DATEADD(dd,1,@data) and
not exists (select 1 from FirstScan f where a1.acessoId = f.acessoId)
group by acessoId

insert FirstScan
select a1.acessoId,dataHora,isnull(qtdVirus,0)
from PSafeDb..Scan a1
join @result r on a1.id = r.id
select @@ROWCOUNT,'Inserts'
end --proc
go
sp_dba_carga_FirstScan '20110606'
go