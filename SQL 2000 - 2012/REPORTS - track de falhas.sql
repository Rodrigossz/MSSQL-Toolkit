select top 100 * from Instalacao order by 1 desc


select  * 
from Desinstalacao d
join Instalacao i on d.guId = i.guId
--where d.dataHora >= '20110426'
order by 1 desc


select  d.guId,COUNT(*)
from Desinstalacao d
join Instalacao i on d.guId = i.guId
--where d.dataHora >= '20110426'
group by d.guId
having COUNT (*) > 1
order by 2 desc


declare @guid tdhwguid = 'F2A0F30E-94A4-4F3C-B0FA-26FBBB323447'
select * from Instalacao where guId = @guid
select * from Desinstalacao where guId = @guid
select * 
from Instalacao i (nolock)
join Pc p (nolock) on i.pcid = p.id
join Acesso a (nolock) on p.id = a.pcId
join AcessoLog al (nolock) on a.id = al.acessoId
join Assinatura a2 (nolock) on a.assinaturaId = a2.id
where guId = @guid


select * from GXC.clientedb.dbo.cliente where id = 686

