/*
select * from sys.sysprocesses where blocked <> 0
exec sp_who2 active
exec sp_helpdb
exec xp_fixeddrives
exec sp_dba_job


*/

use psafedb;
-- =============================================
-- Script Template
-- =============================================
EXEC sys.sp_cdc_enable_db
GO -- Habilita CDC no database 

EXECUTE sys.sp_cdc_enable_table @source_schema = 'dbo', @source_name = 'Assinatura' , @role_name = null; 
EXECUTE sys.sp_cdc_enable_table @source_schema = 'dbo', @source_name = 'VersaoAplic' , @role_name = null; 
EXECUTE sys.sp_cdc_enable_table @source_schema = 'dbo', @source_name = 'Plano' , @role_name = null; 
EXECUTE sys.sp_cdc_enable_table @source_schema = 'dbo', @source_name = 'Pc' , @role_name = null; 
EXECUTE sys.sp_cdc_enable_table @source_schema = 'dbo', @source_name = 'Instalacao' , @role_name = null; 
EXECUTE sys.sp_cdc_enable_table @source_schema = 'dbo', @source_name = 'Indicacao' , @role_name = null; 
EXECUTE sys.sp_cdc_enable_table @source_schema = 'dbo', @source_name = 'Notificacao' , @role_name = null; 
EXECUTE sys.sp_cdc_enable_table @source_schema = 'dbo', @source_name = 'Acesso' , @role_name = null; 


EXECUTE sys.sp_cdc_change_job @job_type = N'cleanup', @retention = 5249480; -- 10 anos

Select [name], is_tracked_by_cdc from sys.tables


exec sys.sp_cdc_disable_table @source_schema = 'dbo', @source_name = 'Pc', @capture_instance = 'all'
exec sys.sp_cdc_disable_table @source_schema = 'dbo', @source_name = 'instalacao', @capture_instance = 'all'