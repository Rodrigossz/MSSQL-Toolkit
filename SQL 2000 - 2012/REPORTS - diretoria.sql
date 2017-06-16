--exec pr_Relat_ClientesAtivos
--exec pr_Relat_ClientesConsProvedor
--exec pr_Relat_ClientesSexo

declare @qry nvarchar(400) = 'exec ClienteDb.dbo.pr_Relat_ClientesAtivos '''
select @qry = @qry+CONVERT(char(8),dateadd(dd,-2,getdate()),112)+''','''+CONVERT(char(8),dateadd(dd,1,getdate()),112)+''',null'
--select @qry


exec msdb.dbo.sp_send_dbmail  @profile_name = 'PSafeNotifier',
@recipients = 'Marco@grupoxango.com;ben@grupoxango.com;ram@grupoxango.com;rodrigo@grupoxango.com',
@body = 'Clientes - últimos 2 dias em anexo.',
@subject=  'Last Report - Custormers',
@body_format= 'HTML',
@execute_query_database = 'ClienteDb',
@query = @qry,
@attach_query_result_as_file = 1,
@query_attachment_filename = 'ClientesAtivos.txt',
@query_result_width  = 100,
@query_result_separator = ';'
