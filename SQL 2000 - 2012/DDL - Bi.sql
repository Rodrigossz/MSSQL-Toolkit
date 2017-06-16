create table TipoEstatistica (
id tinyint identity(1,1) primary key,
nome tddesc not null,
ativo bit default 1);

insert TipoEstatistica select 'Virus Eliminados',1
insert TipoEstatistica select 'Clientes',1
insert TipoEstatistica select 'Pcs Protegidos',1

create table Data (
id int identity(1,1) primary key,
data date not null,
diaSemana varchar(10) not null,
dia tinyint not null,
mes tinyint not null,
ano smallint not null)
go
create index Data_ID01 on data (data);
create index Data_ID02 on data (dia) include (mes,ano);
go

--drop table hora

create table Hora (
id tinyint identity(0,1) primary key,
hora tinyint not null)
go
create index Hora_ID01 on Hora (hora);
go

insert Hora select 0
insert Hora select 1
insert Hora select 2
insert Hora select 3
insert Hora select 4
insert Hora select 5
insert Hora select 6
insert Hora select 7
insert Hora select 8
insert Hora select 9
insert Hora select 10
insert Hora select 11
insert Hora select 12
insert Hora select 13
insert Hora select 14
insert Hora select 15
insert Hora select 16
insert Hora select 17
insert Hora select 18
insert Hora select 19
insert Hora select 20
insert Hora select 21
insert Hora select 22
insert Hora select 23
insert Hora select 24
insert Hora select 99
go


alter proc sp_dba_carga_Data
@data date , @id int output
as
begin
if not exists (select 1 from data where data = @data)
begin
insert data
select @data,case
when DATEPART(dw,@data) = 1 then 'Domingo'
when DATEPART(dw,@data) = 2 then 'Segunda'
when DATEPART(dw,@data) = 3 then 'Terça'
when DATEPART(dw,@data) = 4 then 'Quarta'
when DATEPART(dw,@data) = 5 then 'Quinta'
when DATEPART(dw,@data) = 6 then 'Sexta'
when DATEPART(dw,@data) = 7 then 'Sábado'
end,
DATEPART(dd,@data),DATEPART(mm,@data),DATEPART(yyyy,@data)
select @id = @@identity
end
else
select 'Data já existente'
end
go

create table Estatistica (
id int identity(1,1) primary key,
dataId int not null references data,
horaId tinyint not null references hora,
tipoEstatisticaId tinyint not null references tipoEstatistica,
qtd int)
go
create index Estatistica_ID01 on Estatistica (dataId) include (tipoEstatisticaId,qtd);
create index Estatistica_ID02 on Estatistica (tipoEstatisticaId) include (dataid,qtd);
create index Estatistica_ID03 on Estatistica (horaId) include (dataid,qtd);
go



alter proc sp_dba_cargaEstatistica
@data date
as
begin
declare @dataId int, @tipoEstatisticaId tinyint, @qtd int

select @dataId = id from data where data = @data
if @@ROWCOUNT = 0 
exec sp_dba_carga_Data @data, @dataId output



--Virus Eliminados
select @tipoEstatisticaId = ID from TipoEstatistica where nome = 'Virus Eliminados'

delete Estatistica where dataId = @dataId and TipoEstatisticaid = @tipoEstatisticaId 

insert Estatistica 
select @dataId,DATEPART(hh,dataHora),@tipoEstatisticaId,SUM(qtdvirus)
from psafedb.dbo.AcessoLog 
where dataHora between @data and DATEADD(dd,1,@data)
group by DATEPART(hh,dataHora)

--Clientes 
select @tipoEstatisticaId = ID from TipoEstatistica where nome = 'Clientes'

delete Estatistica where dataId = @dataId and TipoEstatisticaid = @tipoEstatisticaId 

insert Estatistica 
select @dataId,DATEPART(hh,dataCadastro),@tipoEstatisticaId,count(*)
from GXC.clientedb.dbo.Cliente
where dataCadastro between @data and DATEADD(dd,1,@data)
group by DATEPART(hh,dataCadastro)

--Pcs Protegidos 
select @tipoEstatisticaId = ID from TipoEstatistica where nome = 'Pcs Protegidos'

delete Estatistica where dataId = @dataId and TipoEstatisticaid = @tipoEstatisticaId 

insert Estatistica 
select @dataId,DATEPART(hh,dataHora),@tipoEstatisticaId,count(*)
from Psafedb.dbo.acesso
where dataHora between @data and DATEADD(dd,1,@data)
group by DATEPART(hh,dataHora)

end --proc
go



exec sp_dba_cargaEstatistica '20110401'
exec sp_dba_cargaEstatistica '20110402'
exec sp_dba_cargaEstatistica '20110403'
exec sp_dba_cargaEstatistica '20110404'
exec sp_dba_cargaEstatistica '20110405'
exec sp_dba_cargaEstatistica '20110406'
exec sp_dba_cargaEstatistica '20110407'
exec sp_dba_cargaEstatistica '20110408'
exec sp_dba_cargaEstatistica '20110409'
exec sp_dba_cargaEstatistica '20110410'
exec sp_dba_cargaEstatistica '20110411'
exec sp_dba_cargaEstatistica '20110412'
exec sp_dba_cargaEstatistica '20110413'
exec sp_dba_cargaEstatistica '20110414'
exec sp_dba_cargaEstatistica '20110415'
exec sp_dba_cargaEstatistica '20110416'
exec sp_dba_cargaEstatistica '20110417'
exec sp_dba_cargaEstatistica '20110418'
exec sp_dba_cargaEstatistica '20110419'
exec sp_dba_cargaEstatistica '20110420'
exec sp_dba_cargaEstatistica '20110421'
exec sp_dba_cargaEstatistica '20110422'
exec sp_dba_cargaEstatistica '20110423'
exec sp_dba_cargaEstatistica '20110424'
exec sp_dba_cargaEstatistica '20110425'
exec sp_dba_cargaEstatistica '20110426'
exec sp_dba_cargaEstatistica '20110427'
exec sp_dba_cargaEstatistica '20110428'
exec sp_dba_cargaEstatistica '20110429'
exec sp_dba_cargaEstatistica '20110430'



exec sp_dba_cargaEstatistica '20110501'
exec sp_dba_cargaEstatistica '20110502'
exec sp_dba_cargaEstatistica '20110503'
exec sp_dba_cargaEstatistica '20110504'
exec sp_dba_cargaEstatistica '20110505'
exec sp_dba_cargaEstatistica '20110506'
exec sp_dba_cargaEstatistica '20110507'
exec sp_dba_cargaEstatistica '20110508'
exec sp_dba_cargaEstatistica '20110509'
exec sp_dba_cargaEstatistica '20110510'
exec sp_dba_cargaEstatistica '20110511'
exec sp_dba_cargaEstatistica '20110512'
exec sp_dba_cargaEstatistica '20110513'
exec sp_dba_cargaEstatistica '20110514'
exec sp_dba_cargaEstatistica '20110515'
exec sp_dba_cargaEstatistica '20110516'
exec sp_dba_cargaEstatistica '20110517'
exec sp_dba_cargaEstatistica '20110518'
exec sp_dba_cargaEstatistica '20110519'
exec sp_dba_cargaEstatistica '20110520'
exec sp_dba_cargaEstatistica '20110521'
exec sp_dba_cargaEstatistica '20110522'
exec sp_dba_cargaEstatistica '20110523'
exec sp_dba_cargaEstatistica '20110524'
exec sp_dba_cargaEstatistica '20110525'
exec sp_dba_cargaEstatistica '20110526'



select *
from estatistica e
join tipoestatistica t on e.tipoEstatisticaId = t.id
join Data d on e.dataId = d.id
where
d.data = '20110524'

