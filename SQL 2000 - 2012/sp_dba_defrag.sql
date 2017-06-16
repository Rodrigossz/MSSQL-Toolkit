alter proc sp_dba_defrag @limiteLinhas int
as
begin
set nocount on
select 'Tem certeza que quer reorganizar tabelas com esse tamanho nesse horario?',@limiteLinhas
waitfor delay '00:00:15'

create table #temp (id int , indexname varchar(100), tablename varchar(100), frag dec (10,5),rows int)
insert #temp
exec sp_dba_fragmentation

delete #temp where rows >= @limiteLinhas
select 'ANTES' 
select top 10 * from #temp order by frag desc

declare @min int, @max int, @cmd varchar(500)
select @min = MIN (id) , @max=MAX(id) from #temp

while @min <= @max
begin
select @cmd = 'alter index '+indexname+' on '+tablename+' rebuild' from #temp where id = @min
exec sp_executesql @cmd
select @min = @min+1
end --while

select 'DEPOIS' 
select top 10 * from #temp order by frag desc
exec sp_dba_fragmentation
drop table #temp

end -- proc
go
exec sp_dba_defrag 10000
