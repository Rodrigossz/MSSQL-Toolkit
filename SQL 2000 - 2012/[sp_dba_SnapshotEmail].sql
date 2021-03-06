USE [DbaDb]
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_SnapshotEmail]    Script Date: 09/05/2011 18:25:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[sp_dba_SnapshotEmail]
as
begin
EXEC master..xp_cmdshell 'bcp "exec dbadb.dbo.sp_dba_compare_IoSnapshot" queryout "b:\io_snapshot.csv" -SPSDB001\DBPRODGXC001 -T -URodrigo -c -t;'
EXEC master..xp_cmdshell 'bcp "exec dbadb.dbo.sp_dba_compare_ProcSnapshot" queryout "b:\proc_snapshot.csv" -SPSDB001\DBPRODGXC001 -T -URodrigo -c -t;'
EXEC master..xp_cmdshell 'bcp "exec dbadb.dbo.sp_dba_compare_RowCountSnapshot" queryout "b:\rowcount_snapshot.csv" -SPSDB001\DBPRODGXC001 -T -URodrigo -c -t;'
EXEC master..xp_cmdshell 'bcp "exec dbadb.dbo.sp_dba_compare_SpaceSnapshot" queryout "b:\space_snapshot.csv" -SPSDB001\DBPRODGXC001 -T -URodrigo -c -t;'
EXEC master..xp_cmdshell 'bcp "exec dbadb.dbo.sp_dba_SnapshotReport" queryout "b:\Report.csv" -SPSDB001\DBPRODGXC001 -T -URodrigo -c -t;'
EXEC master..xp_cmdshell 'bcp "exec msdb..sp_dba_get_composite_job_infoProblem" queryout "b:\Job.csv" -SPSDB001\DBPRODGXC001 -T -URodrigo -c -t;'
EXEC master..xp_cmdshell 'bcp "exec dbadb.dbo.sp_dba_compare_ProcSnapshot_Alertas" queryout "b:\alerta.csv" -SPSDB001\DBPRODGXC001 -T -URodrigo -c -t;'

declare @subj nchar(255), @msg varchar(max)
select @subj = @@servername+' Dba Alerts: '+CONVERT(char(20),getdate())
select @msg = 'All Alerts
[io]
Data Db File Last_Size_MB Diff_Size_MB Diff_Number_of_reads	Diff_Bytes_read	
Diff_Read_stall_time_ms	Diff_Number_of_writes	Diff_Bytes_written	
Diff_Write_stall_time_ms	Diff_Read_Write_stall_ms	Diff_time_hours' + char(10)+char(13)+'

[proc]
id	snapshotId	spid command	login_name	host_name	blk	percent_complete cpu_time
duration_secs	status	logical_reads	reads	writes	db	wait_time	last_Query'+char(10)+char(13)+'

[Rowcount]
db	tabela	datahora	Linhas_Antes	dataHora	Linhas_Depois	Diferenca'+char(10)+char(13)+'

[Space]
medida	datahora	TamanhoMB_Antes	dataHora	TamanhoMB_Depois	DiferencaMB'


exec msdb.dbo.sp_send_dbmail  @profile_name = 'bdNotifier',
@recipients = 'rodrigo@grupoxango.com',
@body = @msg,
@subject=  @subj,
@body_format= 'text',
@file_attachments = 'b:\io_snapshot.csv;b:\proc_snapshot.csv;b:\rowcount_snapshot.csv;b:\space_snapshot.csv;b:\Report.csv;b:\job.csv;b:\alerta.csv'

end
