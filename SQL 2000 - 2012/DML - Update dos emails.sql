use EmailsTemp
go


update IndicacaoLegado 
set statusemailid = i2.statusEmailId
from IndicacaoLegado i1
join psafedb..Indicacao i2 on i1.emailIndicado = i2.emailIndicado
where  i1.statusemailid = 5 and i2.statusEmailId <> 5


update IndicacaoLegado 
set statusemailid = 2
from IndicacaoLegado i1
where  i1.statusemailid = 5 and exists (select 1 from psafedb..Indicacao i2 where i1.emailIndicado = i2.emailIndicado and i2.statusEmailId = 2)


update IndicacaoLegado 
set statusemailid = 2
from IndicacaoLegado i1
where  i1.statusemailid = 5 and exists (select 1 from IndicacaoLegado i2 where i1.emailIndicado = i2.emailIndicado and i2.statusEmailId = 2)


update IndicacaoLegado 
set statusemailid = 4
from IndicacaoLegado i1
where  i1.statusemailid = 5 and exists (select 1 from psafedb..Indicacao i2 where i1.emailIndicado = i2.emailIndicado and i2.statusEmailId = 4)


update IndicacaoLegado 
set statusemailid = 4
from IndicacaoLegado i1
where  i1.statusemailid = 5 and exists (select 1 from IndicacaoLegado i2 where i1.emailIndicado = i2.emailIndicado and i2.statusEmailId = 4)


update IndicacaoLegado 
set statusemailid = 3
from IndicacaoLegado i1
where  i1.statusemailid = 5 and exists (select 1 from psafedb..Indicacao i2 where i1.emailIndicado = i2.emailIndicado and i2.statusEmailId = 3)


update IndicacaoLegado 
set statusemailid = 3
from IndicacaoLegado i1
where  i1.statusemailid = 5 and exists (select 1 from IndicacaoLegado i2 where i1.emailIndicado = i2.emailIndicado and i2.statusEmailId = 3)


update PSafeDb..Indicacao 
set statusemailid = i2.statusEmailId
from PSafeDb..Indicacao  i1
join EmailsTemp..IndicacaoLegado i2 on i1.emailIndicado = i2.emailIndicado
where  i1.statusemailid = 5 and i2.statusEmailId <> 5


select s.nome, count(*) as BaseQuente
from psafedb..indicacao i
join PSafeDb..StatusEmail s on i.statusEmailId = s.id
group by s.nome
order by 1

select s.nome, count(*) as Legado
from EmailsTemp..IndicacaoLegado i
join PSafeDb..StatusEmail s on i.statusEmailId = s.id
group by s.nome
order by 1


select s.nome, count(*) as BaseQuente
from psafedb..indicacao i
join PSafeDb..StatusEmail s on i.statusEmailId = s.id
where dataHoraProcesso >= DATEADD(hh,-24,GETDATE())
group by s.nome
order by 1

select s.nome, count(*) as Legado
from EmailsTemp..IndicacaoLegado i
join PSafeDb..StatusEmail s on i.statusEmailId = s.id
where dataHoraProcesso >= DATEADD(hh,-24,GETDATE())
group by s.nome
order by 1


select COUNT(*) 
from PSafeDb..Indicacao where
statusEmailId not in (1,5) and
dataHoraProcesso is null and dataHora >= DATEADD(dd,-20,getdate())



