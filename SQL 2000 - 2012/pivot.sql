alter proc rep_cons_CycleLogic_MT_Channel
@startMonth int, @endMonth int , @customer_id int
as
begin
-- Status 0 = ok!!!
-- Status 1 = ERROR !!!
if @startMonth > @endMonth
begin
select 'End month smaller than inicial month.'
return
end
--select distinct channel from CYCLELOGIC_MTS
--select OBJECT_NAME(id) from syscomments where text like '%pivot%'
--sp_dba_pivot
--rep_cons_CycleLogic_MT_Channel
--rep_cons_affiliate_state
--rep_cons_affiliatfeGroup_state
--rep_cons_affiliateGroup_state

declare @StartYear int, @EndYear int
select @StartYear = isnull(MAX(datepart(yyyy,date)),DATEPART(yyyy,getdate())) from CYCLELOGIC_MTS where DATEPART(mm,date) = @startMonth
select @EndYear = isnull(MAX(datepart(yyyy,date)),DATEPART(yyyy,getdate())) from CYCLELOGIC_MTS where DATEPART(mm,date) = @endMonth


select date,
isnull([Ozonion - Corinthians - Noticias e Gols],0) as Corinthians,
isnull([Ozonion - Flamengo - Noticias e Gols],0) as Flamengo,
isnull([Ozonion - Futebol - Principais Noticias],0) as Principais_Noticias,
isnull([Ozonion - Noticias Internacionais],0) Noticias_Internacionais,
isnull([Ozonion - Sao Paulo - Noticias e Gols],0) Sao_Paulo,
isnull([Ozonion - Selecao Brasileira - Noticias e Gols],0) Selecao_Brasileira,
isnull([Ozonion - Variedades Carros e Motos],0) Carros_Motos,
isnull([Ozonion - Variedades Cinema],0) Cinema,
isnull([Ozonion - Variedades Pensamentos Positivos],0) Pensamentos_Positivos
from 
(select  convert(char(8),date,112) as date,CHANNEL, value
from CYCLELOGIC_MTS mts (nolock)
where STATUS = 0 and 
DATEPART(MM,date) between @startMonth and @endMonth and 
DATEPART(YYYY,date) between @StartYear and @EndYear and 
CUSTOMER_ID = isnull(@customer_id,CUSTOMER_ID)) o
pivot
(sum(value) for channel in ([Ozonion - Corinthians - Noticias e Gols],
[Ozonion - Flamengo - Noticias e Gols],
[Ozonion - Futebol - Principais Noticias],
[Ozonion - Noticias Internacionais],
[Ozonion - Sao Paulo - Noticias e Gols],
[Ozonion - Selecao Brasileira - Noticias e Gols],
[Ozonion - Variedades Carros e Motos],
[Ozonion - Variedades Cinema],
[Ozonion - Variedades Pensamentos Positivos]))
 as pvt
order by 1

end--proc
go
grant exec on rep_cons_CycleLogic_MT_Channel to public
go
exec rep_cons_CycleLogic_MT_Channel 6,7,17
--exec rep_cons_CycleLogic_MT_Channel 7,7,18
go