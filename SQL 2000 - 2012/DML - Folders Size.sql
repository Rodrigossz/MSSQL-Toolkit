--select top 10 * from pc order by 1 desc
--select configuracao.value('(//AmeacaList/Ameaca/Limpou/node())[1]', 'nvarchar(30)') from Pc

declare @cont int = 15000
set rowcount @cont
drop table #folders
create table #folders (folder varchar(50), size varchar(50))

insert #folders
select 'Meus Documentos TOTAL',
configuracao.value('(//sizeofmydoc/node())[1]', 'nvarchar(30)')
from Pc (nolock)

insert #folders
select 'Minhas músicas',
configuracao.value('(//subfoldersinmydoc/subfolder/size/node())[1]', 'nvarchar(30)')
from Pc (nolock)
where configuracao.value('(//subfoldersinmydoc/subfolder/name/node())[1]', 'nvarchar(30)') = 'Minhas músicas' or 
configuracao.value('(//subfoldersinmydoc/subfolder/name/node())[1]', 'nvarchar(30)') = 'My Music' 

insert #folders
select 'Minhas fotos',
configuracao.value('(//subfoldersinmydoc/subfolder/size/node())[1]', 'nvarchar(30)')
from Pc (nolock)
where configuracao.value('(//subfoldersinmydoc/subfolder/name/node())[1]', 'nvarchar(30)') = 'Minhas Imagens' or 
configuracao.value('(//subfoldersinmydoc/subfolder/name/node())[1]', 'nvarchar(30)') = 'My Photos' 

insert #folders
select 'Meus vídeos',
configuracao.value('(//subfoldersinmydoc/subfolder/size/node())[1]', 'nvarchar(30)')
from Pc (nolock)
where configuracao.value('(//subfoldersinmydoc/subfolder/name/node())[1]', 'nvarchar(30)') = 'Meus vídeos' or 
configuracao.value('(//subfoldersinmydoc/subfolder/name/node())[1]', 'nvarchar(30)') = 'My videos' 



--select substring(size,1,CHARINDEX(' Gb',size,1)-1) from #folders where size is not null and size not like '%0.00%'

select folder as Pasta,avg(CONVERT(dec(10,4),substring(size,1,CHARINDEX(' Gb',size,1)-1)) ) as TamanhoMedio_GB
from #folders where size is not null and size not like '%0.00%'
group by folder
order by 1


declare @dataprod smalldatetime = getdate()
exec pr_versaoaplic_ups @id = 0,@nome = '0.1.3.56',@dataproducao=@dataprod, @ativo=1,@hasharquivo = '361BFEF81C05E9F20DC5169B6B25BFC0' ,@nomeExecutavel = 'PSafeSetup.exe'



delete Instalacao where versaoId = 15
delete Desinstalacao where versaoId = 15
delete VersaoAplic where id = 15

select * from VersaoAplic 