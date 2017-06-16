use ClienteDb;
-- =============================================
-- Script Template
-- =============================================
EXEC sys.sp_cdc_enable_db
GO -- Habilita CDC no database 

EXECUTE sys.sp_cdc_enable_table @source_schema = 'dbo', @source_name = 'Cliente' , @role_name = null; 
EXECUTE sys.sp_cdc_enable_table @source_schema = 'dbo', @source_name = 'Endereco' , @role_name = null; 
EXECUTE sys.sp_cdc_enable_table @source_schema = 'dbo', @source_name = 'EnderecoFinanceiro' , @role_name = null; 
EXECUTE sys.sp_cdc_enable_table @source_schema = 'dbo', @source_name = 'OperacaoCliente' , @role_name = null; 
EXECUTE sys.sp_cdc_enable_table @source_schema = 'dbo', @source_name = 'OrigemContatoInfo' , @role_name = null; 
EXECUTE sys.sp_cdc_enable_table @source_schema = 'dbo', @source_name = 'ClienteEmailAdicional' , @role_name = null; 


EXECUTE sys.sp_cdc_change_job @job_type = N'cleanup', @retention = 5249480; -- 10 anos


use FidelidadeDb;
exec sp_dba_tb
EXEC sys.sp_cdc_enable_db
GO -- Habilita CDC no database 

EXECUTE sys.sp_cdc_enable_table @source_schema = 'dbo', @source_name = 'Escudo' , @role_name = null; 
EXECUTE sys.sp_cdc_enable_table @source_schema = 'dbo', @source_name = 'Recompensa' , @role_name = null; 
EXECUTE sys.sp_cdc_enable_table @source_schema = 'dbo', @source_name = 'Credito' , @role_name = null; 
EXECUTE sys.sp_cdc_enable_table @source_schema = 'dbo', @source_name = 'ClienteEscudo' , @role_name = null; 
EXECUTE sys.sp_cdc_enable_table @source_schema = 'dbo', @source_name = 'Lancamento' , @role_name = null; 
EXECUTE sys.sp_cdc_enable_table @source_schema = 'dbo', @source_name = 'LancamentoResgate' , @role_name = null; 
EXECUTE sys.sp_cdc_enable_table @source_schema = 'dbo', @source_name = 'Resgate' , @role_name = null; 


EXECUTE sys.sp_cdc_change_job @job_type = N'cleanup', @retention = 5249480; -- 10 anos
