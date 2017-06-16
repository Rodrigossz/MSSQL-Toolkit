/*
select * from sys.sysprocesses where blocked <> 0
exec sp_who2 active
exec sp_helpdb
exec xp_fixeddrives
exec sp_dba_job


*/
select * 
from CategoriaArquivo ca (nolock)
join Extensao e (nolock) on ca.id = e.categoriaArquivoId
join EspacoPc ep (nolock) on e.id = ep.extensaoId
