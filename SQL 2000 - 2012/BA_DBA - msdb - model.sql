-- master..xp_fixeddrives
-- master..xp_cmdshell 'dir D:\dba\dados\'
-- master..xp_cmdshell 'dir D:\dba\backup\'
-- master..xp_cmdshell 'dir D:\dba\restore\'
-- master..xp_cmdshell 'del D:\dba\dados\BA_DBA_*'
-- master..xp_cmdshell 'copy D:\dba\backup\model* D:\dba\restore\'
-- master..xp_cmdshell 'C:\Gzip\gzip124.exe D:\dba\restore\BA_DBA.BAK.gz -df'

-- DROP DATABASE BA_DBA
CREATE DATABASE BA_DBA
ON PRIMARY
( NAME = BA_DBA_data,
   FILENAME = 'D:\DBA\Dados\BA_DBA_Data.MDF',
   SIZE = 5,
   FILEGROWTH = 10% )
LOG ON
( NAME = BA_DBA_log,
   FILENAME = 'D:\DBA\Log\BA_DBA_Log.LDF',
   SIZE = 5,
   FILEGROWTH = 10% )
-- COLLATE Latin1_General_CI_AI
GO

-- master..xp_cmdshell 'dir D:\DBA\Restore\'
-- master..xp_cmdshell 'C:\Gzip\gzip124.exe "D:\DBA\Restore\BA_DBA.bak.gz" -df'

-- use BA_DBA
select * from ba_dba.dbo.ConfiguracaoDBA
select * from ba_dba.dbo.dba_AgendaManutencao

use master
go
RESTORE DATABASE BA_DBA
   FROM DISK = 'D:\DBA\Restore\BA_DBA.bak'
   WITH
     MOVE 'BA_DBA_Data' TO 'D:\DBA\Dados\BA_DBA_Data.MDF',
     MOVE 'BA_DBA_Log'  TO 'D:\DBA\Log\BA_DBA_Log.LDF', 
     replace, stats = 1
GO

exec sp_dba_autofix BA_DBA
exec sp_defaultdb 'sa', 'BA_DBA'

-- exec BA_DBA.dbo.sp_dba_restore BA_DBA
-- drop database BA_DBA

use BA_DBA
go
select * from BA_DBA..ConfiguracaoDBA
-- delete BA_DBA..ConfiguracaoDBA where chaveId in ('connect', 'cpu', 'espera', 'io', 'memoria', 'networkErrors', 'networksErrors', 'qtdMaxDestinario', 'setDbaQueries', 'tempoLock', 'minutosUltimaExec')
-- delete BA_DBA..ConfiguracaoDBA where chaveId in ('pathBatFtpBI', 'pathBCP', 'pathCopyBackup', 'pathFTPCorporativo')
update BA_DBA..ConfiguracaoDBA set valor = 'd:\dba\backup\' where chaveId = 'pathBackupDiario'
update BA_DBA..ConfiguracaoDBA set valor = '' where chaveId = 'pathBackupMensal'
update BA_DBA..ConfiguracaoDBA set valor = '' where chaveId = 'pathBackupSemanal'
update BA_DBA..ConfiguracaoDBA set valor = 'd:\dba\BCP\' where chaveId = 'pathBCP'
update BA_DBA..ConfiguracaoDBA set valor = 'c:\gzip\gzip124.exe' where chaveId = 'pathGzip'
update BA_DBA..ConfiguracaoDBA set valor = 'd:\dba\restore\' where chaveId = 'pathRestore'
update BA_DBA..ConfiguracaoDBA set valor = 'D:\DBA\Perfmon\' where chaveId = 'pathPerfMon'



exec BA_DBA.dbo.sp_dba_restore model -- select name from model..sysobjects where name like 'sp_dba%'
alter database model set recovery simple

-- PARA MIGRAR TODOS OS DATABASES DE UM SERVIDOR PARA O OUTRO -------------
-- PARA MIGRAR TODOS OS DATABASES DE UM SERVIDOR PARA O OUTRO -------------
-- PARA MIGRAR TODOS OS DATABASES DE UM SERVIDOR PARA O OUTRO -------------
select 'exec sp_dba_CriaDatabase @nomeBa = ''' + a.name + ''', @qtdDatafiles = ' + convert(varchar(2), count(1)) + ', @formataNomeBa = ''N'', @fazShrink = ''N'''
from master.dbo.sysdatabases a join BA_DBA.dbo.vw_dba_sysfiles b on a.name = b.ba
where name not in ('BA_DBA', 'master', 'model', 'msdb', 'tempdb')
group by a.name
order by 1

select @@servername
exec BA_DBA.dbo.sp_dba_restore msdb  -- select name, originating_server from msdb..sysjobs
select * from msdb.dbo.sysjobs
update msdb.dbo.sysjobs set originating_server = @@servername


EXEC sp_detach_db 'msdb', 'true'
EXEC sp_attach_db @dbname = 'msdb', 
   @filename1 = 'C:\Program Files\Microsoft SQL Server\MSSQL\data\msdbdata.mdf',
   @filename2 = 'C:\Program Files\Microsoft SQL Server\MSSQL\data\msdblog.ldf'


-- Não restaurar o master NUNCA
-- Não restaurar o master NUNCA
-- Não restaurar o master NUNCA, pois os databases já criados no servidor 
-- antigo não conseguem ser inicializados pelo SQL Server e o serviço nao sobe mais.
