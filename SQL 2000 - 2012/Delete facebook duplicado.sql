/*
select * from sys.sysprocesses where blocked <> 0
exec sp_who2 active
exec sp_helpdb
exec xp_fixeddrives
exec sp_dba_job


*/
drop table #temp

select clienteid, COUNT(*) as qtd, MAX(id) as maiorId
into #temp
from OrigemContatoInfo where origemContatoId = 5
group by clienteId having COUNT(*) > 1

delete OrigemContatoInfo
from OrigemContatoInfo o
join #temp t on o.clienteId = t.clienteId
where
o.origemContatoId = 5 and
o.id <> t.maiorId

drop table #temp