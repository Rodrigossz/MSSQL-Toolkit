EXEC master..xp_cmdshell 'bcp "exec Psafedb.dbo.pr_Relat_ScansBcp" queryout "b:\scans.txt" -SPSDB001\DBPRODODS001 -T -URodrigo -c -t;'
EXEC master..xp_cmdshell 'bcp "exec Psafedb.dbo.pr_Relat_IndicacoesProvedorBcp" queryout "b:\IndicacoesProvedor.txt" -SPSDB001\DBPRODODS001 -T -URodrigo -c -t;'
EXEC master..xp_cmdshell 'bcp "exec Psafedb.dbo.pr_Relat_IndicacoesBcp" queryout "b:\Indicacoes.txt" -SPSDB001\DBPRODODS001 -T -URodrigo -c -t;'
EXEC master..xp_cmdshell 'bcp "exec Psafedb.dbo.pr_Relat_InstalacoesBcp" queryout "b:\Instalacoes.txt" -SPSDB001\DBPRODODS001 -T -URodrigo -c -t;'
EXEC master..xp_cmdshell 'bcp "exec Psafedb.dbo.pr_Relat_InstalacoesErro2Bcp" queryout "b:\InstalacoesErro.txt" -SPSDB001\DBPRODODS001 -T -URodrigo -c -t;'


exec msdb.dbo.sp_send_dbmail  @profile_name = 'PSafeNotifier',
@recipients = 'tecnologia@grupoxango.com',
@body = 'PERIODO = últimos 5 dias em anexo.',
@subject=  'Reports dos últimos 5 dias em anexo.',
@body_format= 'HTML',
@file_attachments = 'b:\scans.txt;b:\IndicacoesProvedor.txt;b:\Indicacoes.txt;b:\Instalacoes.txt;b:\InstalacoesErro.txt'
go

select CONVERT(char(15),'Data'),CONVERT(char(50),'OS'),CONVERT(char(15),'TotalFalhas'),CONVERT(char(15),'TotalSucessos') union all
select CONVERT(char(15),Data),CONVERT(char(50),OS),CONVERT(char(15),TotalFalhas),CONVERT(char(15),TotalSucessos) 
from @tab order by 1,2
