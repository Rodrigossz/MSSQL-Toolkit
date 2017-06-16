truncate table FirstScan
go
dbcc checkident (FirstScan,'reseed',0)
go
--select * from FirstScan
update statistics FirstScan
go

declare @temp table (pcid int primary key, id int,dataHora smalldatetime, qtdvirus int)
insert @temp
select pcid, min(al.id),null,null
from PSafeDB_Hist..AcessoLog al 
join PSafeDb..Acesso a on al.acessoId = a.id
where not exists (select 1 from FirstScan f where a.pcId = f.pcid)  and
al.dataHora = (select MIN(dataHora) from PSafeDB_Hist..AcessoLog al2 where al2.acessoId = a.id)
group by pcId

--select pcid,COUNT(*) from @temp group by pcid having COUNT(*) > 1

update @temp
set qtdvirus = isnull(al.qtdVirus,0),dataHora = al.dataHora
from PSafeDB_Hist..AcessoLog al 
join @temp t on al.id = t.id

insert FirstScan (dataHora,qtdVirus,pcId,acessoLogId)
select dataHora,isnull(qtdVirus,0),pcid,id
from @temp 
select @@ROWCOUNT,'Inserts'
go

declare @temp table (pcid int primary key, id int,dataHora smalldatetime, qtdvirus int)
insert @temp
select pcid, min(al.id),null,null
from PSafeDB_Hist..Scan al 
join PSafeDb..Acesso a on al.acessoId = a.id
where not exists (select 1 from FirstScan f where a.pcId = f.pcid)  and
al.dataHora = (select MIN(dataHora) from PSafeDB_Hist..Scan al2 where al2.acessoId = al.acessoId)
group by pcId

--select pcid,COUNT(*) from @temp group by pcid having COUNT(*) > 1

update @temp
set qtdvirus = isnull(al.qtdVirus,0),dataHora = al.dataHora
from PSafeDB_Hist..Scan al 
join @temp t on al.id = t.id

select * from @temp order by dataHora desc

insert FirstScan (dataHora,qtdVirus,pcId,scanId)
select dataHora,isnull(qtdVirus,0),pcid,id
from @temp 
select @@ROWCOUNT,'Inserts'
go


declare @temp table (pcid int primary key, id int,dataHora smalldatetime, qtdvirus int)
insert @temp
select pcid, min(al.id),null,null
from PSafeDb..Scan al 
join PSafeDb..Acesso a on al.acessoId = a.id
where not exists (select 1 from FirstScan f where a.pcId = f.pcid)  and
al.dataHora = (select MIN(dataHora) from PSafeDB..Scan al2 where al2.acessoId = al.acessoId)
group by pcId

--select pcid,COUNT(*) from @temp group by pcid having COUNT(*) > 1

update @temp
set qtdvirus = isnull(al.qtdVirus,0),dataHora = al.dataHora
from PSafeDb..Scan al 
join @temp t on al.id = t.id

select * from @temp order by dataHora desc

insert FirstScan (dataHora,qtdVirus,pcId,scanId)
select dataHora,isnull(qtdVirus,0),pcid,id
from @temp 
select @@ROWCOUNT,'Inserts'
go

