/*
select * from sys.sysprocesses where blocked <> 0
exec sp_who2 active
exec sp_helpdb
exec xp_fixeddrives
exec sp_dba_job


*/

drop table Estatistica360
go

create table Estatistica360 (
id int identity(1,1) primary key,
data date not null,
qtdPcsProtegidos int not null,
qtdAmeacasEliminadas bigint not null)
go
create index Estatistica360_ID01 on Estatistica360 (data) include (qtdPcsProtegidos,qtdAmeacasEliminadas)
go
create index Estatistica360_ID02 on Estatistica360 (qtdPcsProtegidos) include (qtdAmeacasEliminadas)
go
insert Estatistica360 select GETDATE(),320000000,4000000000
go
insert Estatistica360 select dateadd(dd,-1,GETDATE()),320000000-200000,4000000000-1200000
go


create proc sp_dba_carga_Estatistica360
as
begin
set nocount on
declare @pc int, @ameaca bigint, @data date = getdate()

select @pc = MAX(qtdPcsProtegidos),@ameaca = MAX(qtdAmeacasEliminadas)
from Estatistica360 (nolock)

-- Valores Diarios
select @pc = @pc+200000, @ameaca = @ameaca + 1200000

delete Estatistica360 where data = @data

insert Estatistica360 select @data,@pc,@ameaca
end