/*
select * from sys.sysprocesses where blocked <> 0
exec sp_who2 active
exec sp_helpdb
exec xp_fixeddrives
exec sp_dba_job


*/
select COUNT(*) from AcessoLog where dataHora >= '20110603'


select versaoid,count(*) as Qtd
from Instalacao where upgrade = 0
group by versaoid

select versaoid,count(*) as Qtd
from Desinstalacao
group by versaoid
order by 1

select * from VersaoAplic

select versaoid,count(*) as Qtd
from Instalacao where upgrade = 1
group by versaoid

select top 100 * from Instalacao where versaoId is null order by 1 desc

select COUNT(*) from Instalacao where upgrade = 0 and versaoId is null and dataHora >=  '20110602 18:00'
select COUNT(*) from Instalacao where upgrade = 0 and versaoId is not null and dataHora >=  '20110602 18:00'

exec pr_Relat_Instalacoes