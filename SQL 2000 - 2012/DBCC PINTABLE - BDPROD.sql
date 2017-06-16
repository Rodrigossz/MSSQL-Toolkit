-- BA_Corporativo..CreditoDigital
-- use BA_Corporativo
use ba_credito_digital
go
-- DBCC PINTABLE (database_id, table_id)
declare @dbid varchar(10), @db varchar(100), @medida smallint
select @dbid=dbid, @db=name, @medida=1024 from master.dbo.sysdatabases where name = db_name()
if (@medida not in (1, 1024)) begin
  print 'Burro!'
  return
end

select 
  'DBCC PINTABLE('+@dbid+ ', /*'+@db+'*/  '+convert(char(10),o.id)+' /*'+o.name+ 
  ' ['+convert(varchar(15), i.dpages*8/@medida) + case when @medida = 1 then ' Kb]' else ' Mb]' end +'*/)'
from sysobjects o (nolock), sysindexes i (nolock)
where o.id = i.id
  and i.indid in (1,0)
  and o.name in ('configuracaoCreditoDigital', 'DDDOperadora', 'OperadoraNacional', 'CapturaCdRegra', 'PromocaoCd', 'CreditoDigital')


DBCC PINTABLE(11, /*BA_Credito_Digital*/  23671132   /*CapturaCdRegra [128 Kb]*/)
DBCC PINTABLE(11, /*BA_Credito_Digital*/  1042102753 /*ConfiguracaoCreditoDigital [16 Kb]*/)
DBCC PINTABLE(11, /*BA_Credito_Digital*/  544057024  /*DDDOperadora [8 Kb]*/)
DBCC PINTABLE(11, /*BA_Credito_Digital*/  82151388   /*OperadoraNacional [8 Kb]*/)
DBCC PINTABLE(11, /*BA_Credito_Digital*/  713105631  /*PromocaoCD [32 Kb]*/)
DBCC PINTABLE(16, /*BA_Corporativo*/  932198371  /*CreditoDigital [40 Kb]*/)


-- Conhecendo esse output!
select bucketid, cacheobjtype, objtype, objid, dbid, dbidexec, pagesused, sqlbytes, sql from syscacheobjects 


-- http://www.extremeexperts.com/sql/articles/SQLCacheObjects.aspx
-- The contents available for the stored procedure cache can be returned using this command. Interesting command to execute.
-- Return the procedure cache information
DBCC PROCCACHE
GO

USE master
go 
-- A host of information is displayed by this command. Gives the usage of memory on the local server in general.
-- Show memory usage on the database
DBCC MEMORYSTATUS
GO
