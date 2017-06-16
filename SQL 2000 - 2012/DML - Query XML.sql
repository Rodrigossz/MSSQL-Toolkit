select * from PSafeDb..Instalacao
--select * from PSafeDb..Notificacao
exec pr_Relat_Instalacoes '20110403','20110406','d'
exec pr_Relat_Scans '20110403','20110406','d'
select * from TipoLog
select * from AcessoLog

sp_who

computername>CARLOS-PC</computername>

SELECT 
configuracao.value('(//computername/node())[1]', 'nvarchar(max)') as ComputerName
FROM Instalacao 
order by 1

where configuracao like '%llondor%'



update Instalacao
set dataSucesso = dateadd(ss,15,dataHora)
where dataSucesso is null and pcId is not null


/*sp_helptext instalacao_tg01


drop trigger Instalacao_TG01
on instalacao
for update
as

update Instalacao
set dataSucesso = GETDATE()
from Instalacao install 
join inserted i on i.id = install.id 
join deleted d on i.id = d.id
where 
d.dataSucesso is null and d.pcId is null and i.pcId is not null and i.dataSucesso is null

*/