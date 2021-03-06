USE [master]
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_startup]    Script Date: 05/02/2011 17:26:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER proc [dbo].[sp_dba_startup]
as
--dbcc traceon (8033)
--dbcc traceon (830)

dbcc traceon (1204,-1)

declare @assunto varchar(100)
select @assunto = rtrim(substring(@@servername,1,30))+': Servidor Reiniciando em: '+convert(varchar(19),getdate())

EXEC msdb.dbo.sp_send_dbmail
    @profile_name = 'Psafenotifier',
	@execute_query_database = 'master',
	@recipients = 'rodrigo@grupoxango.com',-- ; daniel@grupoxango.com', 
    @subject = @assunto,
    @query = 'select name,state_Desc,is_cdc_enabled,is_encrypted from sys.databases',
    @query_result_header = 1,
    @importance = 'high',
--@attach_query_result_as_file = 1,@query_attachment_filename= 'startup.xls',
@query_result_width = 3000,@query_no_truncate=1,
    @body_format = 'HTML'
go

exec sp_procoption 'sp_dba_startup' 
    , 'STARTUP' ,'ON'
    

EXEC sp_ms_marksystemobject 'SP_GETOBJECTS'  
    