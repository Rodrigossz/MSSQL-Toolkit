/*
select * from sys.sysprocesses where blocked <> 0
exec sp_who2 active
exec sp_helpdb
exec xp_fixeddrives
exec sp_dba_job


*/
select * from PSafeDb..sorteioipad
select * from PSafeDb..StatusEmail
select count(*) from IndicacaoLegado where emailIndicado like '%yahoo%'

select statusEmailId , count(*) from IndicacaoLegado where emailIndicado like '%yahoo%' group by statusEmailId 

update IndicacaoLegado
set statusEmailId = 99
where emailIndicado like '%yahoo%' and statusEmailId = 5

select statusEmailId , count(*) from IndicacaoLegado  group by statusEmailId 
select statusEmailId , count(*) from psafedb..Indicacao  group by statusEmailId 

select statusEmailId , count(*) from IndicacaoLegado where dataHoraProcesso >= '20110609'  group by statusEmailId 

select statusEmailId , count(*) from Indicacao  group by statusEmailId 

select statusEmailId , count(*) from Indicacao where emailIndicado like '%yahoo%' group by statusEmailId 

/*insert StatusEmail select 'Yahoo

update Indicacao
set statusEmailId = 
where emailIndicado like '%yahoo%' and statusEmailId = 1

*/

begin tran
update psafedb..Indicacao
set statusEmailId = l.statusEmailId 
from IndicacaoLegado l
join psafedb..Indicacao l2 on l.id = l2.id 
where l.statusEmailId in (4,2) and l2.statusEmailId = 5


commit

select * from 

select MAX(dataHoraProcesso)
from PSafeDb..Indicacao
where emailIndicado like '%yahoo%' and statusEmailId in (2,4)


