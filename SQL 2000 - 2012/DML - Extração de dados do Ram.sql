select * 
into #cliente
from gxc.clientedb.dbo.cliente

create unique clustered index id01 on #cliente (email)
select COUNT(*) from #cliente
select COUNT(*) from #cliente c
where exists (select 1 from Indicacao i where c.email = i.emailIndicado and statusEmailId = 4)
select top 10 * from #cliente

select i.id,i.emailIndicado,convert(date,i.dataHora) as dataIndicacao,c.id as clienteId, c.primeironome,c.sobrenome as ClienteIndicou
from 
Indicacao (nolock) i 
join #cliente c on i.clienteId = c.id
where statusEmailId = 4 and Not exists 
(select 1 from #cliente c2 where i.emailIndicado = c2.email)
and 
(dataHora >= '20110713' or dataHoraProcesso >= '20110713')



select COUNT(*) from Indicacao where statusEmailId = 1
 
 
Depois gerei CSV, zipei e mandei por emails. Duas vezes, nome junto e separado.
