/*
select * from sys.sysprocesses where blocked <> 0
exec sp_who2 active
exec sp_helpdb
exec xp_fixeddrives
exec sp_dba_job


*/


select top 500
configuracao.value('(//subfoldersinmydoc/subfolder/size/node())[1]', 'nvarchar(30)'), *
from Pc (nolock)


select COUNT(*)
from Pc (nolock) where 
convert(float,substring(configuracao.value('(//subfoldersinmydoc/subfolder/size/node())[1]', 'nvarchar(30)'),1,3)) >= 5

select 
convert(float,substring(configuracao.value('(//subfoldersinmydoc/subfolder/size/node())[1]', 'nvarchar(30)'),1,3)),
configuracao.value('(//subfoldersinmydoc/subfolder/size/node())[1]', 'nvarchar(30)') 
from Pc (nolock) where 
convert(float,substring(configuracao.value('(//subfoldersinmydoc/subfolder/size/node())[1]', 'nvarchar(30)'),1,3)) <= 1



select COUNT(*)
from Pc (nolock) where 
configuracao.value('(//subfoldersinmydoc/subfolder/size/node())[1]', 'nvarchar(30)') like  '%(0 bytes)%'

select configuracao.value('(//subfoldersinmydoc/subfolder/size/node())[1]', 'nvarchar(30)') , *
from Pc (nolock) where 
configuracao.value('(//subfoldersinmydoc/subfolder/size/node())[1]', 'nvarchar(30)') like  '0.00%'
