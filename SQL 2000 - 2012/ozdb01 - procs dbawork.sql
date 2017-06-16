USE [dbawork]
GO

/****** Object:  StoredProcedure [dbo].[sp_dba_autokill]    Script Date: 05/19/2010 17:47:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[sp_dba_autokill]
@tempo int = 7
as
begin
declare @procs table (spid int primary key)
insert @procs
select distinct spid from master..sysprocesses a where 
exists (select 1 from  master..sysprocesses b where a.spid = b.blocked) and
a.loginame = 'ozonion' and
a.status = 'sleeping' and spid > 50 and
a.cmd = 'AWAITING COMMAND' and
a.lastwaittype <> 'WRITELOG' and
DATEDIFF(ss  , a.last_batch,GETDATE()) >= @tempo
union
select distinct spid from master..sysprocesses a where 
a.loginame = 'ozonion' and
a.status = 'sleeping' and spid > 50 and
a.cmd = 'AWAITING COMMAND' and
a.lastwaittype <> 'WRITELOG' and
DATEDIFF(ss  , a.last_batch,GETDATE()) >= 60 -- mais de 59 segundos parado eh kill

if @@ROWCOUNT = 0
return

declare @min int, @max int, @parm nvarchar(40)

select @min = MIN(spid), @max =max(spid) from @procs

while @min <= @max
begin
select 'Matando: ',@min
insert dbawork..logautokill 
select GETDATE(),@min,
r.wait_time ,text
FROM sys.dm_exec_requests r  
CROSS APPLY sys.dm_exec_sql_text(r.plan_handle) st  
WHERE session_Id = @min
if @@ROWCOUNT = 0
insert dbawork..logautokill 
select GETDATE(),@min,null,null
select @parm = N'Kill '+ convert(nvarchar(6),@min)
exec sp_executesql @parm    
select @min = MIN(spid)  from @procs where spid > @min
end
end



GO

/****** Object:  StoredProcedure [dbo].[sp_dba_autokill2]    Script Date: 05/19/2010 17:47:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[sp_dba_autokill2]
@tempo int = 7
as
begin
declare @procs table (spid int primary key, wait_time int)
insert @procs
SELECT  t2.blocking_session_id,MAX(wait_duration_ms)
FROM sys.dm_tran_locks as t1
INNER JOIN sys.dm_os_waiting_tasks as t2     ON t1.lock_owner_address = t2.resource_address
where
t2.wait_duration_ms/1000 > @tempo and not exists (select 1 FROM sys.dm_exec_requests r where r.session_id = t2.blocking_session_id)
group by  t2.blocking_session_id

if @@ROWCOUNT = 0
return

declare @min int, @max int, @parm nvarchar(60), @EventInfo varchar(2000), @wait_time int
select @min = MIN(spid), @max =max(spid) from @procs

         
if exists (select 1 from tempdb..sysobjects where type = 'U' and name like 'buffer%')            
drop table #buffer            
create table #buffer  (eventType varchar(30), parameters int, EventInfo varchar(2000))           
 

while @min <= @max
begin
select 'Matando: ',@min

select @parm = 'dbcc inputbuffer ('+ltrim(rtrim(convert(char(5),@min)))+')'            
insert #buffer  (EventType, Parameters, EventInfo)             
exec (@parm)            
select @EventInfo = EventInfo from #buffer            
delete #buffer            

select @wait_time = wait_time from @procs where spid = @min
insert dbawork..logautokill 
select GETDATE(),@min,@wait_time,@EventInfo
select @parm = N'Kill '+ convert(nvarchar(6),@min)
exec sp_executesql @parm    
select @min = MIN(spid)  from @procs where spid > @min
end --while
end --proc

GO

/****** Object:  StoredProcedure [dbo].[sp_dba_autokillConsulta]    Script Date: 05/19/2010 17:47:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[sp_dba_autokillConsulta]
as
select * from logautokill where data >= DATEADD (dd,-1,getdate()) 
GO

/****** Object:  StoredProcedure [dbo].[sp_dba_controleExpurgo]    Script Date: 05/19/2010 17:47:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE proc [dbo].[sp_dba_controleExpurgo] 
as
select 
c1.data,c1.tabela,c1.db, c1.antesdepois,c1.qtd,c2.antesdepois,c2.qtd, c2.qtd-c1.qtd as Diff
from controleExpurgo c1
join controleExpurgo c2 on c1.tabela = c2.tabela and c1.db = c2.db 
and convert(char(8),c1.data,112) = convert(char(8),c2.data,112)
where c1.data >= dateadd(dd,-1,getdate())
and c1.antesdepois = 'A' and c2.antesdepois = 'D' and c1.db = 'ozdb_hist' and c2.qtd-c1.qtd  <> 0
union 
select 
c1.data,c1.tabela,c1.db, c1.antesdepois,c1.qtd,c2.antesdepois,c2.qtd, c1.qtd-c2.qtd as Diff
from controleExpurgo c1
join controleExpurgo c2 on c1.tabela = c2.tabela and c1.db = c2.db 
and convert(char(8),c1.data,112) = convert(char(8),c2.data,112)
where c1.data >= dateadd(dd,-1,getdate())
and c1.antesdepois = 'A' and c2.antesdepois = 'D' and c1.db = 'ozdb' and c2.qtd-c1.qtd  <> 0
order by 1,2,3


GO

/****** Object:  StoredProcedure [dbo].[sp_dba_counters]    Script Date: 05/19/2010 17:47:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[sp_dba_counters]
as

set nocount on
declare @transec int
select @transec = cntr_value  FROM sys.dm_os_performance_counters  
WHERE counter_name = 'Transactions/sec' and instance_name = '_Total'
waitfor delay '00:00:01'

select @transec = cntr_value - @transec FROM sys.dm_os_performance_counters  
WHERE counter_name = 'Transactions/sec' and instance_name = '_Total'

SELECT 'Buffer cache hit ratio' as Counter, 
convert(numeric(7,2),ROUND(CAST(A.cntr_value1 AS NUMERIC(7,2)) / CAST(B.cntr_value2 AS NUMERIC(7,2)),3))*100 AS Value,
'Target = 100%' as 'Best Situation'
FROM (SELECT cntr_value AS cntr_value1
FROM sys.dm_os_performance_counters
WHERE object_name = 'SQLServer:Buffer Manager'
AND counter_name = 'Buffer cache hit ratio') AS A,
(SELECT cntr_value AS cntr_value2
FROM sys.dm_os_performance_counters
WHERE object_name = 'SQLServer:Buffer Manager'
AND counter_name = 'Buffer cache hit ratio base') AS B
union
SELECT counter_name,convert(numeric (10,2),cntr_value),'Target = above 300' 
FROM sys.dm_os_performance_counters  
WHERE counter_name = 'Page life expectancy'
AND OBJECT_NAME = 'SQLServer:Buffer Manager'
union
SELECT 'Transactions/sec',@transec,'Target = Between 30 and 300'
union 
SELECT counter_name,convert(numeric (10,2),cntr_value),'Target = Around 400' 
FROM sys.dm_os_performance_counters  
WHERE counter_name like 'User%Connections%'
union 
SELECT counter_name,convert(numeric (10,2),cntr_value),'Target = Minimum' 
FROM sys.dm_os_performance_counters  
WHERE counter_name like 'Processes%Blocked%'
union 
SELECT counter_name+' (historical)',sum(convert(numeric (10,2),cntr_value)),'Target = Minimum' 
FROM sys.dm_os_performance_counters  
WHERE counter_name like 'Number%deadlock%'
group by counter_name
union
SELECT 'Average Wait Time - seconds', convert(numeric(7,2),ROUND(CAST(A.cntr_value1 AS NUMERIC) / CAST(B.cntr_value2 AS NUMERIC),3))/1000 AS Value,
'Target = above 5' 
FROM (SELECT sum(cntr_value) AS cntr_value1
FROM sys.dm_os_performance_counters
WHERE object_name = 'SQLServer:Locks'
AND counter_name = 'Average Wait Time (ms)') AS A,
(SELECT sum(cntr_value) AS cntr_value2
FROM sys.dm_os_performance_counters
WHERE object_name = 'SQLServer:Locks'
AND counter_name = 'Average Wait Time Base') AS B
union
SELECT ltrim(rtrim(counter_name))+' - '+Ltrim(rtrim(instance_name)), cntr_value/1024 , 'Megabytes' 
FROM sys.dm_os_performance_counters
WHERE object_name = 'SQLServer:Databases'
AND counter_name like '%size%' and instance_name like 'ozdb%'
union
select 'KILLs on '+CONVERT(char(8),data,112),COUNT(*) ,'Target = Minimum'
from dbawork..logautokill (nolock) where data  >= DATEADD (dd,-2,convert(char(8),getdate(),112)) group by CONVERT(char(8),data,112)
union 
select 'General LPM Conversions on '+ CONVERT(char(8),requesttime,112),COUNT(*) ,'Target = Maximum'
from ozdb..LPM_TRANSACTION (nolock) where requesttime  >= DATEADD (dd,-2,convert(char(8),getdate(),112)) 
and TRANSACTION_STATE_TYPE_ID = 4
group by CONVERT(char(8),requesttime,112)
order by 3 desc, 1 asc


GO

/****** Object:  StoredProcedure [dbo].[sp_dba_expurgo]    Script Date: 05/19/2010 17:47:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[sp_dba_expurgo]  
@dias smallint
as  
begin  
set xact_abort on  
exec sp_dba_kill 'ozdb_hist'
exec sp_dboption 'ozdb_hist','read only',false


insert dbawork..controleExpurgo
select getdate(),'ozdb_hist',o.name,'A',rows 
from ozdb_hist..sysobjects o join ozdb_hist..sysindexes i on o.id = i.id and
o.type = 'U' and indid in (0,1) union
select getdate(),'ozdb',o.name,'A',rows 
from ozdb..sysobjects o join ozdb..sysindexes i on o.id = i.id and
o.type = 'U' and indid in (0,1) and o.name in (select name from ozdb_hist..sysobjects where type = 'U')




-- todo dia
exec sp_dba_expurgoStatus1 @dias
--select @dias = @dias*2 -- tem folga para reprocessos do consolidado, dont worry
exec sp_dba_expurgoIntegrator @dias -- tem folga para reprocessos do consolidado, dont worry

-- Sabados
if (select DATEPART(dw,getdate())) = 7
begin
--exec sp_dba_expurgoStatusOutros @dias -- Por enquanto nao
declare @path varchar (200)
select @path = 'e:\ozdb_hist_'+ convert(char(8),getdate(),112)+'.bak'
backup database ozdb_hist to disk = @path with init
end
exec sp_dba_kill 'ozdb_hist'
exec sp_dboption 'ozdb_hist','read only',true


insert dbawork..controleExpurgo
select getdate(),'ozdb_hist',o.name,'D',rows 
from ozdb_hist..sysobjects o join ozdb_hist..sysindexes i on o.id = i.id and
o.type = 'U' and indid in (0,1) union
select getdate(),'ozdb',o.name,'D',rows 
from ozdb..sysobjects o join ozdb..sysindexes i on o.id = i.id and
o.type = 'U' and indid in (0,1) and o.name in (select name from ozdb_hist..sysobjects where type = 'U')


end --proc



GO

/****** Object:  StoredProcedure [dbo].[sp_dba_expurgoIntegrator]    Script Date: 05/19/2010 17:47:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE proc [dbo].[sp_dba_expurgoIntegrator]
@dias smallint
as  
begin  
set xact_abort on  
set nocount on
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
declare  @min int, @max int , @data datetime , @datamin datetime, @entrou char(1)

-- ESSA proc vai mover os dados nao uteis pro consolidado  

declare @code table (id int primary key, tipo char(1),METHOD_ID int )

insert @code
select distinct code.id,'N',code.METHOD_ID
from
ozdb..INTEGRATOR_METHOD_RESPONSE_CODE code
join ozdb..INTEGRATOR_METHOD m on code.METHOD_ID = m.id 
join ozdb..INTEGRATOR_FLOW f on m.flow_id = f.id
where 
code.METHOD_ID IN (7, 2, 12, 17, 22, 46, 64, 66, 70,81,84)-- NORMAL
union
select distinct code.id,'L',code.METHOD_ID
from
ozdb..INTEGRATOR_METHOD_RESPONSE_CODE code
join ozdb..INTEGRATOR_METHOD m on code.METHOD_ID = m.id 
join ozdb..INTEGRATOR_FLOW f on m.flow_id = f.id
where 
code.METHOD_ID IN (73, 53, 38 )-- LR 

select @data = dateadd(dd,@dias*-1,getdate())

select 'Movendo dados para ozdb_hist dados mais velhos que : ' , @data  
  
select @datamin=MIN(CREATED_DATE_TIME) from ozdb..INTEGRATOR_MESSAGE_REQUEST r (nolock)
where CREATED_DATE_TIME <= @data and not exists
(select 1 from @code c where r.METHOD_ID = c.METHOD_ID) 

while @datamin <= @data and DATEPART(hh,getdate()) < 7 -- Pra nao rodar manha a dentro
begin
select agora=getdate(), movendo = @datamin

select @min = min(id), @max = max(id) from ozdb..INTEGRATOR_MESSAGE_REQUEST r (nolock) where 
CREATED_DATE_TIME < dateadd(hh,3,@datamin)  and CREATED_DATE_TIME >= @datamin 
and not exists
(select 1 from @code c where r.METHOD_ID = c.METHOD_ID)


begin tran  
insert ozdb_hist..INTEGRATOR_MESSAGE_RESPONSE select * 
from ozdb..INTEGRATOR_MESSAGE_RESPONSE r
where r.MESSAGE_REQUEST_ID >= @min and r.MESSAGE_REQUEST_ID <= @max   
and not exists (select 1 from @code c where c.id = r.METHOD_RESPONSE_CODE_ID)
delete ozdb..INTEGRATOR_MESSAGE_RESPONSE 
from ozdb..INTEGRATOR_MESSAGE_RESPONSE r
where r.MESSAGE_REQUEST_ID >= @min and r.MESSAGE_REQUEST_ID <= @max   
and not exists (select 1 from @code c where c.id = r.METHOD_RESPONSE_CODE_ID)
commit  


begin tran  
insert ozdb_hist..INTEGRATOR_MESSAGE_REQUEST select * from ozdb..INTEGRATOR_MESSAGE_REQUEST r
where r.id >= @min and r.id <= @max  and 
r.CREATED_DATE_TIME <= dateadd(hh,3,@datamin)  and r.CREATED_DATE_TIME >= @datamin and not exists
(select 1 from @code c where r.METHOD_ID = c.METHOD_ID)

delete ozdb..INTEGRATOR_MESSAGE_REQUEST 
from ozdb..INTEGRATOR_MESSAGE_REQUEST r
where r.id >= @min and r.id <= @max  and 
r.CREATED_DATE_TIME <= dateadd(hh,3,@datamin)  and r.CREATED_DATE_TIME >= @datamin and not exists
(select 1 from @code c where r.METHOD_ID = c.METHOD_ID)

commit

  
select @datamin = dateadd(hh,3,@datamin) 
end  -- while do que nao conta


-- Agora o q conta, mais tempo por enquanto

select @data = convert(char(8),dateadd(dd,@dias*-1*2,getdate()),112) -- 5 vezes mais dias

select 'Movendo dados QUE CONTAM para ozdb_hist dados mais velhos que : ' , @data  
  
select @datamin=MIN(CREATED_DATE_TIME) from ozdb..INTEGRATOR_MESSAGE_REQUEST r (nolock)
where CREATED_DATE_TIME <= @data and  exists
(select 1 from @code c where r.METHOD_ID = c.METHOD_ID) 


while @datamin <= @data and DATEPART(hh,getdate()) < 7 -- Pra nao rodar manha a dentro
begin
select agora=getdate(), movendo = @datamin

select @min = min(id), @max = max(id) from ozdb..INTEGRATOR_MESSAGE_REQUEST r (nolock) where 
CREATED_DATE_TIME < dateadd(hh,3,@datamin)  and CREATED_DATE_TIME >= @datamin 
and  exists
(select 1 from @code c where r.METHOD_ID = c.METHOD_ID)


begin tran  
insert ozdb_hist..INTEGRATOR_MESSAGE_RESPONSE select * 
from ozdb..INTEGRATOR_MESSAGE_RESPONSE r
where r.MESSAGE_REQUEST_ID >= @min and r.MESSAGE_REQUEST_ID <= @max   
and  exists (select 1 from @code c where c.id = r.METHOD_RESPONSE_CODE_ID)
delete ozdb..INTEGRATOR_MESSAGE_RESPONSE 
from ozdb..INTEGRATOR_MESSAGE_RESPONSE r
where r.MESSAGE_REQUEST_ID >= @min and r.MESSAGE_REQUEST_ID <= @max   
and  exists (select 1 from @code c where c.id = r.METHOD_RESPONSE_CODE_ID)
select INTEGRATOR_MESSAGE_RESPONSE=@@rowcount
commit  

begin tran  
insert ozdb_hist..INTEGRATOR_MESSAGE_REQUEST select * from ozdb..INTEGRATOR_MESSAGE_REQUEST r
where r.id >= @min and r.id <= @max  and 
r.CREATED_DATE_TIME <= dateadd(hh,3,@datamin)  and r.CREATED_DATE_TIME >= @datamin and  exists
(select 1 from @code c where r.METHOD_ID = c.METHOD_ID)

delete ozdb..INTEGRATOR_MESSAGE_REQUEST 
from ozdb..INTEGRATOR_MESSAGE_REQUEST r
where r.id >= @min and r.id <= @max  and 
r.CREATED_DATE_TIME <= dateadd(hh,3,@datamin)  and r.CREATED_DATE_TIME >= @datamin and  exists
(select 1 from @code c where r.METHOD_ID = c.METHOD_ID)
select INTEGRATOR_MESSAGE_REQUEST=@@rowcount 
commit

  
select @datamin = dateadd(hh,3,@datamin) 
end  -- while do que  conta

end --proc



GO

/****** Object:  StoredProcedure [dbo].[sp_dba_expurgoStatus1]    Script Date: 05/19/2010 17:47:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE proc [dbo].[sp_dba_expurgoStatus1]  
@dias smallint
as  
begin  
set xact_abort on  
declare  @min int, @max int , @data datetime , @datamin datetime, @entrou char(1), @aux int,
@contAntes int, @contDepois int


select @data = convert(char(8),dateadd(dd,@dias*-1,getdate()),112) 

select 'Movendo trans status 1 para ozdb_hist. Dados mais velhos que : ' , @data  
  
select @datamin=MIN(requesttime) from ozdb..LPM_TRANSACTION where requesttime <= @data and
TRANSACTION_STATE_TYPE_ID = 1

while @datamin <= @data and DATEPART(hh,getdate()) < 7 -- Pra nao rodar manha a dentro
begin
select @min = min(id), @max = max(id) from ozdb..LPM_TRANSACTION where requesttime <= DATEADD(hh,10,@datamin)  
and requestTime >= @datamin  and TRANSACTION_STATE_TYPE_ID = 1

select @aux = @min
while  @aux <= @max
begin
begin tran  
insert ozdb_hist..LPM_PASSWORD_REQUEST_BY_MSISDN_AND_SESSION
select p.* 
from ozdb..LPM_TRANSACTION t (nolock) join ozdb..LPM_PASSWORD_REQUEST_BY_MSISDN_AND_SESSION p (nolock)
on t.id = p.TRANSACTION_ID 
where t.id >= @min and t.id <= @aux+30000  and TRANSACTION_STATE_TYPE_ID = 1  
select @contAntes = @@rowcount


delete ozdb..LPM_PASSWORD_REQUEST_BY_MSISDN_AND_SESSION
from ozdb..LPM_TRANSACTION t (nolock) join ozdb..LPM_PASSWORD_REQUEST_BY_MSISDN_AND_SESSION p (nolock)
 on t.id = p.TRANSACTION_ID 
where t.id >= @min and t.id <= @aux+30000  and TRANSACTION_STATE_TYPE_ID = 1  
select @contDepois = @@rowcount


if @contAntes = @contDepois
commit 
Else
begin
select 'Diferenca na contagem do @@rowcount - LPM_PASSWORD_REQUEST_BY_MSISDN_AND_SESSION' , @contAntes,@contDepois
raiserror  55555 'Diferenca na contagem do @@rowcount - LPM_PASSWORD_REQUEST_BY_MSISDN_AND_SESSION'
rollback
return
end
 
select @aux = @aux+30000
end -- while pequeno 1

select @aux = @min
while  @aux <= @max
begin

begin tran  
insert ozdb_hist..LPM_TRANSACTION select * from ozdb..LPM_TRANSACTION where id >= @min and id <= @aux+30000
and TRANSACTION_STATE_TYPE_ID = 1  
select @contAntes = @@rowcount

delete ozdb..LPM_TRANSACTION where id >= @min and id <= @aux+30000   and
TRANSACTION_STATE_TYPE_ID = 1 
select @contDepois = @@rowcount


if @contAntes = @contDepois
commit 
Else
begin
select 'Diferenca na contagem do @@rowcount - LPM_TRANSACTION' , @contAntes,@contDepois
raiserror  55555 'Diferenca na contagem do @@rowcount - LPM_TRANSACTION'
rollback
return
end  
select @aux = @aux+30000
end -- while pequeno 2
  
select @datamin = dateadd(hh,10,@datamin)
end  -- while
end -- proc


GO

/****** Object:  StoredProcedure [dbo].[sp_dba_expurgoStusOutros]    Script Date: 05/19/2010 17:47:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE proc [dbo].[sp_dba_expurgoStusOutros] 
@dias smallint
as  
begin  
set xact_abort on  
declare  @min int, @max int , @data datetime , @datamin datetime, @entrou char(1),
@contAntes int, @contDepois int

select @data = convert(char(8),dateadd(dd,@dias*-1,getdate()),112) 

select 'Movendo dados para ozdb_hist dados mais velhos que : ' , @data  
  
select @datamin=MIN(requesttime) from ozdb..LPM_TRANSACTION where requesttime <= @data  

while @datamin <= @data
begin

select @min = min(id), @max = max(id) from ozdb..LPM_TRANSACTION 
where requesttime <= @data  and requestTime >= @datamin
--and TRANSACTION_STATE_TYPE_ID <> 1 -- Nem precisa testar pq 
-- o expurgo move de status 1 eh diario e com menor prazo. E roda antes.

begin tran  
insert ozdb_hist..LPM_PASSWORD_REQUEST_BY_MSISDN_AND_SESSION
select * 
from ozdb..LPM_PASSWORD_REQUEST_BY_MSISDN_AND_SESSION  (nolock)
where TRANSACTION_ID >= @min and TRANSACTION_ID <= @max 
select @contAntes = @@rowcount

delete ozdb..LPM_PASSWORD_REQUEST_BY_MSISDN_AND_SESSION
where TRANSACTION_ID >= @min and TRANSACTION_ID <= @max 
select @contDepois = @@rowcount

if @contAntes = @contDepois
commit 
Else
begin
select 'Diferenca na contagem do @@rowcount - LPM_PASSWORD_REQUEST_BY_MSISDN_AND_SESSION' , @contAntes,@contDepois
raiserror  55555 'Diferenca na contagem do @@rowcount - LPM_PASSWORD_REQUEST_BY_MSISDN_AND_SESSION'
rollback
return
end

begin tran  
insert ozdb_hist..LPM_TRANSACTION_COMBO_DETAIL select * from ozdb..LPM_TRANSACTION_COMBO_DETAIL  
where TRANSACTION_ID >= @min and TRANSACTION_ID <= @max 
select @contAntes = @@rowcount

delete ozdb..LPM_TRANSACTION_COMBO_DETAIL where TRANSACTION_ID >= @min and TRANSACTION_ID <= @max
select @contDepois = @@rowcount
   

if @contAntes = @contDepois
commit 
Else
begin
select 'Diferenca na contagem do @@rowcount - LPM_TRANSACTION_COMBO_DETAIL' , @contAntes,@contDepois
raiserror  55555 'Diferenca na contagem do @@rowcount - LPM_TRANSACTION_COMBO_DETAIL'
rollback
return
end  
  
begin tran  
insert ozdb_hist..LPM_TRANSACTION select * from ozdb..LPM_TRANSACTION where id >= @min and id <= @max  
select @contAntes = @@rowcount
 
delete ozdb..LPM_TRANSACTION where id >= @min and id <= @max   
select @contDepois = @@rowcount


if @contAntes = @contDepois
commit 
Else
begin
select 'Diferenca na contagem do @@rowcount - LPM_TRANSACTION' , @contAntes,@contDepois
raiserror  55555 'Diferenca na contagem do @@rowcount - LPM_TRANSACTION'
rollback
return
end  
  
select @datamin = dateadd(dd,1,@datamin)
end --while
end --proc



GO

/****** Object:  StoredProcedure [dbo].[sp_dba_Limpa_LastConversion]    Script Date: 05/19/2010 17:47:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create proc [dbo].[sp_dba_Limpa_LastConversion]
as
begin
/*
11 8354-9259	Eduardo Paredes
11 8354-9294	Vitor Bittencourt
11 8371-4655	Guilherme Mamede
11 8371-4858	Fabio La Manna
11 8371-4862	Sergio Bazilio
11 8677-3380	Rafael Carvalho
11 8677-3424	Wilerson Oliveira
11 8677-3456 juliano
11 6427-0312 Rodrigo
11 6427-0306 leo

select id,msisdn from ozdb..lpm_user
where msisdn in ('+551183549259','+551183549294','+551183714655','+551183714858','+551183714862','+551186773380',
'+551186773424','+551186773456','+551164270312','+551164270306')
*/
select 'Limpando users da Ozonion da LPM_LAST_CONVERSION'
delete ozdb..LPM_LAST_CONVERSION
from ozdb..LPM_LAST_CONVERSION l, dbawork..OZONION_USERS u
where l.user_id = u.user_id
end

GO

/****** Object:  StoredProcedure [dbo].[sp_dba_sqlprod]    Script Date: 05/19/2010 17:47:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[sp_dba_sqlprod]
as
begin
declare @cmd nvarchar(2000), @id int, @min int, @max int, @erro int , @resultado varchar (4000)
declare @aux table (id int primary key, cmd nvarchar(2000))

insert @aux select id,cmd from ozdb03.dbawork.dbo.sqlprod where dataexec is null order by 1
select @min = MIN(id), @max=MAX(id) from @aux

while @min <= @max
begin
select @cmd=cmd, @id = id from @aux where id = @min
exec sp_executesql @cmd

select @erro = @@ERROR
if @erro <> 0
select @resultado = convert(varchar(4000),text) from sys.messages where message_id = @erro  and language_id = 1033
else
select @resultado = 'OK.'
update ozdb03.dbawork.dbo.sqlprod 
set dataexec = GETDATE(), erroId = @erro, resultado = @resultado
where id = @min

select @min = @min +1
end -- while
return 0
end -- proc


GO

/****** Object:  StoredProcedure [dbo].[sp_dba_tbUse]    Script Date: 05/19/2010 17:47:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create proc [dbo].[sp_dba_tbUse] as
set nocount on
declare @use varchar(30)
select @use = 'USE ' + db_name()
exec(@use)

SELECT 
 DB_NAME(ius.database_id) AS DBName,
 OBJECT_NAME(ius.object_id) AS TableName,
 SUM(ius.user_scans) AS Scans ,
 SUM(ius.user_lookups) AS Lookups ,
 SUM(ius.user_seeks) AS Seeks,
 SUM(ius.user_updates) AS Updates 
FROM sys.indexes i
INNER JOIN sys.dm_db_index_usage_stats ius
 ON ius.object_id = i.object_id
 AND ius.index_id = i.index_id 
 where database_id = DB_ID()
 GROUP BY DB_NAME(ius.database_id), OBJECT_NAME(ius.object_id)
ORDER BY 3 DESC

GO

