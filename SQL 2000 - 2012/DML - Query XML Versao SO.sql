/*
select * from sys.sysprocesses where blocked <> 0
exec sp_who2 active
exec sp_helpdb
exec xp_fixeddrives
exec sp_dba_job


*/

--select top 100 *  from Pc order by 1 desc

SELECT 
configuracao.value('(//os/node())[1]', 'nvarchar(max)') as SistemaOperacional,
configuracao.value('(//osversion/node())[1]', 'nvarchar(max)') as Versao
FROM pc 
where configuracao.value('(//os/node())[1]', 'nvarchar(max)') like '%vista%' and 
configuracao.value('(//osversion/node())[1]', 'nvarchar(max)') like '%64%'
order by 1
