USE [master]
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_rebuildIndexes]    Script Date: 02/11/2012 12:46:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[sp_dba_rebuildIndexes]
as
begin
set	nocount on 
declare	@x int
declare @c varchar(500)
declare @dow varchar(80)
declare @tables table (id int identity(1,1), obj_id varchar(255), table_name varchar(255))
declare @indexes table (id int identity(1,1), table_id int, index_name varchar(255))
declare @worker table (id int identity(1,1), table_name varchar(255), index_name varchar(255), start_time datetime, end_time datetime)

----set day of week (@dow) to do full online=off reindexing
select  @dow = 'Sunday'
----get all tables that aren't just heaps
insert	@tables (obj_id, table_name)
select	distinct 
	a.object_id, '[' + schema_name(a.schema_id) + '].[' + object_name(a.object_id) + ']'
from	sys.tables a
join	sys.indexes b 
on	a.object_id = b.object_id
and	b.name is not null

----get all indexes that aren't heaps
insert	@indexes (table_id, index_name)
select	a.id,
	b.name
from	@tables a
join	sys.indexes b
on	a.obj_id = b.object_id
where	b.name is not null
or	b.type_desc <> 'HEAP'

if	(select datename(dw, getdate())) <> @dow
begin
	delete	z
	from	sys.tables a
	join	sys.columns b
	on	a.object_id = b.object_id 
	join	sys.indexes c
	on	a.object_id = c.object_id
	join	sys.types d
	on	b.system_type_id = d.system_type_id
	and	b.user_type_id = d.user_type_id 
	join	@tables y
	on	a.object_id = y.obj_id
	join	@indexes z 
	on	y.id = z.table_id 
	and	c.name = z.index_name
	where	(c.type_desc = 'CLUSTERED')
	and	((b.system_type_id = 34 and b.user_type_id = 34)
	or	(b.system_type_id = 35 and b.user_type_id = 35)
	or	(b.system_type_id = 99 and b.user_type_id = 99)
	or	(b.system_type_id = 241 and b.user_type_id = 241)
	or	(b.system_type_id = 231 and b.user_type_id = 231 and b.max_length = -1)
	or	(b.system_type_id = 167 and b.user_type_id = 167 and b.max_length = -1)
	or	(b.system_type_id = 165 and b.user_type_id = 165 and b.max_length = -1))

	delete	z
	from	sys.tables a 
	join	sys.columns b 
	on	a.object_id = b.object_id  
	join	sys.indexes c 
	on	a.object_id = c.object_id 
	join	sys.index_columns d 
	on	a.object_id = d.object_id
	and	b.column_id = d.column_id
	and	c.index_id = d.index_id
	join	@tables y
	on	a.object_id = y.obj_id
	join	@indexes z 
	on	y.id = z.table_id 
	and	c.name = z.index_name
	where	c.name is not null 
	and	c.type_desc <> 'CLUSTERED'
	and	((b.system_type_id = 34 and b.user_type_id = 34)
	or	(b.system_type_id = 35 and b.user_type_id = 35)
	or	(b.system_type_id = 99 and b.user_type_id = 99)
	or	(b.system_type_id = 241 and b.user_type_id = 241)
	or	(b.system_type_id = 231 and b.user_type_id = 231 and b.max_length = -1)
	or	(b.system_type_id = 167 and b.user_type_id = 167 and b.max_length = -1)
	or	(b.system_type_id = 165 and b.user_type_id = 165 and b.max_length = -1))	

	delete	@tables 
	where	id not in 
		(select table_id from @indexes)

	insert	@worker (table_name, index_name)
	select	a.table_name, b.index_name
	from	@tables a 
	join	@indexes b
	on	a.id = b.table_id 

	select	@x = max(id) from @worker
	while	@x > 0 
	begin
			update	@worker
			set	start_time = getdate()
			where	id = @x

			select	@c = 'alter index ' + a.index_name + ' on ' + a.table_name + ' rebuild with (online=on)' 
			from	@worker a 
			where	a.id = @x

			exec	(@c)

			update	@worker
			set	end_time = getdate()
			where	id = @x

	select	@x = @x - 1
	end
end
else
begin
	delete	@tables 
	where	id not in 
		(select table_id from @indexes)

	insert	@worker (table_name, index_name)
	select	a.table_name, b.index_name
	from	@tables a 
	join	@indexes b
	on	a.id = b.table_id 

	select	@x = max(id) from @worker
	while	@x > 0 
	begin
			update	@worker
			set	start_time = getdate()
			where	id = @x

			select	@c = 'alter index ' + a.index_name + ' on ' + a.table_name + ' rebuild' 
			from	@worker a 
			where	a.id = @x

			exec	(@c)

			update	@worker
			set	end_time = getdate()
			where	id = @x

	select	@x = @x - 1
	end
end

select * from @worker 
end-- proc
