--EXEC master..xp_cmdshell 'bcp "exec Clientedb.dbo.pr_Relat_ClientesAtivosBcp" queryout "b:\ClientesAtivos.txt" -SPSDB001\DBPRODGXC001 -T -URodrigo -c -t;'
EXEC master..xp_cmdshell 'bcp "exec Clientedb.dbo.pr_Relat_OrigemCadastroBcp" queryout "b:\ClientesConsOrigem.txt" -SPSDB001\DBPRODGXC001 -T -URodrigo -c -t;'

declare @result table (data varchar(10), qtd int)
insert @result
select convert(varchar(10),CONVERT(date,dataCadastro)), COUNT(*) 
from ClienteDb.dbo.Cliente
where dataCadastro >= convert(date,DATEADD(dd,-5,getdate()))
group by CONVERT(date,dataCadastro)

insert @result
select 'Total', COUNT(*) from ClienteDb.dbo.Cliente

declare @subj nvarchar(255), @body nvarchar(max) --= 'Past 5 days registrations report.'
select @subj = 'PSafe Hourly Registration Report: '+CONVERT(char(20),getdate())

select @body =
N'<H1>Past 5 days registrations report</H1>'+
N'<table border="1">' +
N'<th>Date</th><th>Total</th></th>'+
CAST((
select td=Data,'', td = qtd
from @result order by 1 
FOR XML PATH('tr'), ELEMENTS 
) AS NVARCHAR(MAX) ) +
N'</table>' ;


select @body

exec msdb.dbo.sp_send_dbmail  @profile_name = 'bdNotifier',
--@recipients = 'andressa@grupoxango.com; bruna.dias@grupoxango.com; Marco@grupoxango.com;ben@grupoxango.com;ram@grupoxango.com;lott@grupoxango.com',
@recipients = 'rodrigo@psafe.com',
@body = @body,
@subject=  @subj,
@body_format= 'HTML',
@file_attachments = 'b:\ClientesConsOrigem.txt'
