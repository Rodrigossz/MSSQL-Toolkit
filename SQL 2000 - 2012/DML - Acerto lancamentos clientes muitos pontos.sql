--select * from clientedb..cliente where primeironome like 'eser%'

--select sum(totalpontos) from lancamento where clienteid = 202 and creditoid in ( 2,7)
--select sum(totalpontos) from lancamento where clienteid = 1 and creditoid in (2,7)
--select sum(totalpontos) from lancamento where clienteid = 12

--delete lancamento where creditoid = 7 and clienteid = 1
--drop table clientetemp2

--delete lancamento where creditoid = 7 and datahora = '20110719 19:09' and clienteid in 
--(select clienteid from clientetemp)
select * from credito
select creditoid,sum(totalpontos) from lancamento where clienteid = 53330 group by creditoid






--drop table clientetemp
--select * from clientetemp

select clienteid,SUM(totalPontos) as totalPontos
--into ClienteTemp
from Lancamento where creditoId in ( 2,7)
group by clienteId
having SUM(totalpontos) > 100000

--create clustered index id01 on ClienteTemp (clienteid)

--select * from ClienteTemp  where clienteid = 1

declare @min int,@max int,  @totalpontos int, @novosaldoEscudo int, @novosaldoFidelidade int
select @min = MIN(clienteid), @max = MAX(clienteid) from ClienteTemp where clienteid <> 1

while @min <= @max
begin
select @totalpontos = totalpontos from ClienteTemp where clienteId = @min
select @totalpontos = 100000-@totalpontos --negativo

exec pr_Lancamento_ups 0,'20110721 21:21',null,7,@min,@totalPontos,@totalPontos,1

select @novosaldoEscudo = sum(totalPontos) 
from lancamento where clienteid = @min and creditoid is not null

select @novosaldoFidelidade = @novosaldoEscudo - sum(totalPontos) 
from lancamento where clienteid = @min and itemid is not null

update ClienteDb..Cliente 
set saldoEscudo = @novosaldoEscudo + @totalpontos , saldoFidelidade = @novosaldoFidelidade + @totalpontos
where id = @min


select @min = MIN(clienteid) from ClienteTemp where clienteId > @min
end --while



--select clienteid,SUM(totalPontos) as totalPontos
--from Lancamento where creditoId in (2,7)
--group by clienteId
--having SUM(totalpontos) > 100000


--select * from ClienteDb..Cliente where id in (select clienteid from ClienteTemp)
--select top 100 * from Lancamento where creditoId = 7 order by 1 desc