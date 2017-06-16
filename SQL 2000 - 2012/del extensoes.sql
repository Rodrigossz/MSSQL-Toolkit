drop table #temp
go
select extensaoid, COUNT(*) qtd 
into #temp
from EspacoPc
group by extensaoid
having count(*) = 1


create clustered index ID01 on #temp (extensaoid)

select MAX(tamanhoMB), MIN(tamanhoMB), AVG(tamanhoMB)
from EspacoPc e join #temp t on e.extensaoId = t.extensaoId





select *
from EspacoPc e 
join #temp t on e.extensaoId = t.extensaoId
join Extensao ex on e.extensaoId = ex.id
order by tamanhoMB desc

select  COUNT(*)
from EspacoPc e 
join #temp t on e.extensaoId = t.extensaoId
join Extensao ex on e.extensaoId = ex.id
where tamanhoMB = 0


select ex.nome, COUNT(*)
from EspacoPc e 
join Extensao ex on e.extensaoId = ex.id
group by ex.nome
having COUNT(*) > 2
order by 2 desc

select COUNT(*) from Extensao

select pcid,SUM(tamanhomb) as tamanhoMb
into #temp2
from EspacoPc
group by pcId

--select 1024 * 100

select 
case 
when tamanhoMB <= 2048 then 'tamanho total até 2 GB' 
when tamanhoMB > 2048 and tamanhoMB <= 5120 then 'tamanho > 2 GB e <= 5 GB' 
when tamanhoMB > 5120 and tamanhoMB <= 25600 then 'tamanho > 5 GB e <= 25 GB' 
when tamanhoMB > 25600 and tamanhoMB <= 51200 then 'tamanho > 25 GB e <= 50 GB' 
when tamanhoMB > 51200 and tamanhoMB <= 102400 then 'tamanho > 50 GB e <= 100 GB' 
when tamanhoMB > 102400 then 'tamanho > 100 GB' end as FaixaTamanho
, COUNT(*) as QtdPcs
from #temp2
group by case 
when tamanhoMB <= 2048 then 'tamanho total até 2 GB' 
when tamanhoMB > 2048 and tamanhoMB <= 5120 then 'tamanho > 2 GB e <= 5 GB' 
when tamanhoMB > 5120 and tamanhoMB <= 25600 then 'tamanho > 5 GB e <= 25 GB' 
when tamanhoMB > 25600 and tamanhoMB <= 51200 then 'tamanho > 25 GB e <= 50 GB' 
when tamanhoMB > 51200 and tamanhoMB <= 102400 then 'tamanho > 50 GB e <= 100 GB' 
when tamanhoMB > 102400 then 'tamanho > 100 GB' end
order by 1




--delete EspacoPc
--from EspacoPc e join #temp t on e.extensaoId = t.extensaoId 
--where tamanhoMB = 0


--delete Extensao
--from extensao e join #temp t on e.id = t.extensaoId
--where Not exists (select 1 from EspacoPc ep where ep.extensaoId = e.id)



