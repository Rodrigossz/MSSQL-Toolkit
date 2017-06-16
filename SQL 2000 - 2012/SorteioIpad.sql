drop table SorteioIpad;
create table SorteioIpad (
id int identity(1,1) primary key,
clienteid int not null,
dataHoraPremiado smalldatetime null,
dataHoraPontosCadastroCompleto smalldatetime null,
email tdemail null,
nome tddesc null)
go

create unique index SorteioIpad_ID01 on SorteioIpad (clienteId)
go
create index SorteioIpad_ID02 on SorteioIpad (dataHoraPontosCadastroCompleto) include (dataHorapremiado,clienteid)
go


alter proc sp_dba_Carga_SorteioIpad
as
begin
set nocount on

insert SorteioIpad
select clienteId,null,null,null,null
from Indicacao i (nolock)
where statusEmailId = 4 --OK
and not exists (select 1 from SorteioIpad s  (nolock) where i.clienteid = s.clienteid)
group by clienteId
having COUNT(*) >= 200

update SorteioIpad
set 
dataHoraPontosCadastroCompleto = c.dataHoraPontosCadastroCompleto,
email = c.email,
nome = primeiroNome+' '+nomeMeio+ ' ' +sobrenome
from gxc.clientedb.dbo.cliente c 
join SorteioIpad s on c.id = s.clienteid
end
go

--select * from SorteioIpad

alter proc sp_dba_SorteioIpad
as
begin
set nocount on

set rowcount 1
declare @premiado int
select @premiado =  clienteid
from SorteioIpad
where dataHoraPremiado is null and dataHoraPontosCadastroCompleto is not null
order by NEWID()
set rowcount 0


declare @qrydadosVencedor nvarchar(1000)
select @qrydadosVencedor = 'select convert(varchar(10),clienteid) as ClienteId,convert(varchar(50),email) as Email,convert(varchar(50),nome) as Nome from Psafedb.dbo.sorteioipad where clienteid = '+convert(nvarchar(100),@premiado)

update SorteioIpad set dataHoraPremiado = GETDATE() where clienteid = @premiado

exec msdb.dbo.sp_send_dbmail  @profile_name = 'bd_Notifier',
@recipients = 'allusers@grupoxango.com',
@query = @qrydadosVencedor,
@body = 'Vencedor do Mês - Sorteio iPad',
@query_attachment_filename = 'VencedorIpad.txt',
@query_result_separator = ';',
@attach_query_result_as_file = 1,
@subject=  'Psafe - SORTEIO IPAD',
@body_format= 'HTML'
end --proc
go
