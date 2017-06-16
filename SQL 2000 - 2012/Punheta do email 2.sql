/*sp_helptrigger indicacao

sp_helptext indicacao_TG01



--select * from StatusEmail

1	Não Testado
2	Inválido
3	OptOut
4	Ok
5	
99	Yahoo


*/



select * from SorteioIpad

select statusEmailId, count(*)
from indicacao
group by statusEmailId
order by 1

select statusEmailId, count(*)
from EmailsTemp..IndicacaoLegado
group by statusEmailId
order by 1

statusEmailId	qtd
1				279018
2				161848
3				432
4				88990
5				147336
99				34942





select top 300 * from indicacao i1 where exists (
select 1 from indicacao i2 where i1.emailIndicado = i2.emailIndicado and i1.statusEmailId <> i2.statusEmailId)
order by emailIndicado

select count(*) from indicacao i1 where exists (
select 1 from indicacao i2 where i1.emailIndicado = i2.emailIndicado and i1.statusEmailId <> i2.statusEmailId)




select distinct statusemailid from indicacao where emailIndicado like '%@mail.orkut.com'

update indicacao set statusemailid = 2
where emailIndicado like '%@mail.orkut.com' and statusEmailId <> 2

select distinct statusemailid from indicacao where emailIndicado like '%?%'

update indicacao set statusemailid = 2
where emailIndicado like '%?%' and statusEmailId <> 2

update indicacao set statusemailid = 2
where emailIndicado like '%@yahoogr%'  and statusEmailId <> 2

update indicacao set statusemailid = 2
where emailIndicado like '%@googlegr%'  and statusEmailId <> 2


update indicacao set statusemailid = 99
where emailIndicado like '%@yahoo%' and statusEmailId in (1,5)



update indicacao 
set statusemailid = 2
from indicacao i1
where statusemailid <> 2 and exists (select 1 from indicacao i2 where i1.emailIndicado = i2.emailIndicado and statusEmailId = 2)


update indicacao 
set statusemailid = 3
from indicacao i1
where statusemailid <> 3 and exists (select 1 from indicacao i2 where i1.emailIndicado = i2.emailIndicado and statusEmailId = 3)

update indicacao 
set statusemailid = 4
from indicacao i1
where statusemailid in (1,5) and exists (select 1 from indicacao i2 where i1.emailIndicado = i2.emailIndicado and statusEmailId = 4)


update indicacao 
set statusemailid = 5
from indicacao i1
where statusemailid = 1 and exists (select 1 from indicacao i2 where i1.emailIndicado = i2.emailIndicado and statusEmailId = 5)


update indicacao 
set statusemailid = i2.statusEmailId
from indicacao i1 
join EmailsTemp..indicacao i2 on i1.emailIndicado = i2.emailIndicado
where 
i1.statusemailid in (1,5) and i2.statusEmailId = 2

update indicacao 
set statusemailid = i2.statusEmailId
from indicacao i1 
join EmailsTemp..indicacao i2 on i1.emailIndicado = i2.emailIndicado
where 
i1.statusemailid in (1,5) and i2.statusEmailId = 4



--DEPOIS
/*
statusEmailId	(No column name)
1	274389
2	173774
3	435
4	87316
5	142302
99	34418
*/


update indicacao set statusemailid = 2
where emailIndicado like '%@mail.orkut.com'

select distinct statusemailid from indicacao where emailIndicado like '%?%'

update indicacao set statusemailid = 2
where emailIndicado like '%?%'

update indicacao set statusemailid = 2
where emailIndicado like '%@yahoogr%'

update indicacao set statusemailid = 99
where emailIndicado like '%@yahoo%' and statusEmailId in (1,5)

update indicacao set statusemailid = 2
where emailIndicado like '%@googlegr%'


update indicacao 
set statusemailid = 2
from indicacao i1
where statusemailid <> 2 and exists (select 1 from indicacao i2 where i1.emailIndicado = i2.emailIndicado and statusEmailId = 2)


update indicacao 
set statusemailid = 3
from indicacao i1
where statusemailid <> 3 and exists (select 1 from psafedb..indicacao i2 where i1.emailIndicado = i2.emailIndicado and statusEmailId = 3)

update indicacao 
set statusemailid = 4
from indicacao i1
where statusemailid in (1,5) and exists (select 1 from indicacao i2 where i1.emailIndicado = i2.emailIndicado and statusEmailId = 4)


select statusEmailId, count(*)
from indicacao
group by statusEmailId
order by 1

go

