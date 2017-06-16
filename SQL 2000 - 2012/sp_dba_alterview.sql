alter proc sp_dba_AlterView @db varchar(50)
as
begin
set nocount on
create table #tab  (id int identity(1,1) primary key,name varchar(200)  not null)
declare @cmd varchar(2000), @min int, @max int, @name varchar(200)
select @cmd = 'insert #tab select name from '+@db+'..sysobjects where type = ''U'''
exec (@cmd)

-- Processando tabel por tabela
select @min=MIN(id), @max=MAX(id) from #tab
while @min <= @max
begin
select @name = name from #tab where id = @min
if exists (select 1 from sys.views v  where v.name = @name)
begin -- ALTER
select @cmd = 'alter view '+@name+' as select * from '+@db+'..'+@name
exec (@cmd)
end -- alter
else
begin -- CREATE
select @cmd = 'create view '+@name+' as select * from '+@db+'..'+@name
exec (@cmd)
end -- CREATE
select @min=@min+1
end -- while
drop table #tab
end --proc
go

exec sp_dba_alterview 'ozdb_rep'
go

exec sp_helptext commons_brand
