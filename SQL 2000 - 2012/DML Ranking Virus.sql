declare @tab table (virus varchar(50))

insert @tab
select logExecXml.value('(//AmeacaList/Ameaca/Nome)[1]', 'nvarchar(50)')
from acessolog (nolock) where dataHora >= '20110515' and qtdvirus > 0

insert @tab
select logExecXml.value('(//AmeacaList/Ameaca/Nome)[2]', 'nvarchar(50)')
from acessolog (nolock) where dataHora >= '20110515' and qtdvirus > 0

insert @tab
select logExecXml.value('(//AmeacaList/Ameaca/Nome)[3]', 'nvarchar(50)')
from acessolog (nolock) where dataHora >= '20110515' and qtdvirus > 0

delete @tab where virus is null

select virus,COUNT(*) as total from @tab group by virus order by 2 desc

select top 100 * from AcessoLog order by 1 desc


sp_dba_proc2
