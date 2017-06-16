/*
select * from sys.sysprocesses where blocked <> 0
exec sp_who2 active
exec sp_helpdb
exec xp_fixeddrives
exec sp_dba_job


*/
select statusEmailId,COUNT(*)
from IndicacaoLegado
group by statusEmailId


select statusEmailId,COUNT(*)
from Indicacao
where dataHoraProcesso >= '20110531'
group by statusEmailId




select     REPLACE(url,'tab1|main', 'tab1|primeira_pag_scan') as url , id as id
from  Notificacao (nolock)
where url like '%tab1|main%'
and         lida = 0
and tipoNotificacaoId > 1
and tipoNotificacaoId < 5


update Notificacao
set url = REPLACE(url,'tab1|main', 'tab1|primeira_pag_scan') 
from  Notificacao (nolock)
where url like '%tab1|main%'
and         lida = 0
and tipoNotificacaoId > 1
and tipoNotificacaoId < 5



select tipoNotificacaoId,lida ,COUNT(*)
from Notificacao (nolock)
group by tipoNotificacaoId,lida


select * from TipoNotificacao
go

alter proc sp_dba_LimpaNotificacao
@dias int = 14
as
begin
set nocount on

set @dias = @dias * -1

--LIMPEZA DE LEMBRETES

set rowcount 5000 --Tranquilidade
delete Notificacao where tipoNotificacaoId = 5 and dataHora <= DATEADD(dd,@dias,getdate())
while @@ROWCOUNT = 500
delete Notificacao where tipoNotificacaoId = 5 and dataHora <= DATEADD(dd,@dias,getdate())

set rowcount 0
update statistics notificacao
end
go

sp_dba_proc2




set rowcount 5000 --Tranquilidade
delete Notificacao where tipoNotificacaoId = 5 and dataHora <= DATEADD(dd,7,getdate())
while @@ROWCOUNT = 
delete Notificacao where tipoNotificacaoId = 5 and dataHora <= DATEADD(dd,7,getdate())
