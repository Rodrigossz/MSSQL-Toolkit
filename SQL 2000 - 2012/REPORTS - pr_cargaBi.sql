/*pr_cargabi

select * from TipoOperacao

insert TipoOperacao
select id, nome,'Tipo de Notificacao Enviada ao Cliente' ,GETDATE(),'ODS','PsafeDb','TipoNotificacao'
from ODS.Psafedb.dbo.TipoNotificacao 


*/
alter proc pr_CargaBi @dtIni date = null, @dtFim date = null
as
begin
set nocount on

if @dtIni is null -- ONTEM
select @dtIni = DATEADD(dd,-1,getdate()), @dtFim = GETDATE()

-- Cliente
insert Cliente 
select c.id,primeiroNome+' '+nomeMeio+' '+sobrenome, u.sigla,GETDATE(),c.dataCadastro,c.ativo,sexo,null
from ClienteDb.dbo.cliente c (nolock) 
left outer join ClienteDb.dbo.endereco e (nolock) on c.id = e.clienteid and e.residencial = 1
left outer join ClienteDb..Uf u (nolock) on u.id = e.ufId
where not exists (select 1 from Cliente c2 where c2.id = c.id) 

update Cliente
set ativo = c2.ativo, dataHoraUpd = GETDATE()
from Cliente c join ClienteDb.dbo.Cliente c2 on c.id=c2.id and c.ativo <> c2.ativo

-- Vou precisar dentro do while
declare @tab table
(data smalldatetime,clienteId int,idOrigem int, nome tdsmalldesc)


while @dtIni < @dtFim
begin

-- DATA
if not exists (select 1 from Data where data = @dtIni)
insert Data select @dtIni,DATEPART(yyyy,@dtIni),DATEPART(mm,@dtIni),datepart(dd,@dtIni),GETDATE()


--PEGAr DADOS ODS
insert @tab --AcessoLog
select datahora,clienteId,t.id,t.nome
from ods.psafedb.dbo.AcessoLogSemXml a 
join ods.psafedb.dbo.tipoLog t on a.tipologId = t.id
join ods.psafedb.dbo.Acesso a2 on a.acessoId = a2.id
join ods.psafedb.dbo.Assinatura a3 on a2.assinaturaid = a.id 
where a.dataHora >= @dtIni and a.dataHora < DATEADD(dd,1,@dtIni)

insert @tab --Indicacao
select data,clienteId,9999999,'Indicacao'
from ods.psafedb.dbo.Indicacao a 
where a.data >= @dtIni and a.data < DATEADD(dd,1,@dtIni)

insert @tab --Instalacao COM
select dataHora,isnull(clienteId,0),9999997,'Instalacao com Sucesso'
from ods.psafedb.dbo.InstalacaoSemXml a 
left outer join ods.psafedb.dbo.PcSemXML p on a.Pcid = p.id
left outer join ods.psafedb.dbo.Acesso a2 on p.id = a2.pcid
left outer join ods.psafedb.dbo.Assinatura a3 on a2.assinaturaid = a3.id 
where a.dataHora >= @dtIni and a.dataHora < DATEADD(dd,1,@dtIni) and a.dataSucesso is not null

insert @tab --Instalacao SEM
select dataHora,0,9999994,'Instalacao sem Sucesso'
from ods.psafedb.dbo.InstalacaoSemXml a 
where a.dataHora >= @dtIni and a.dataHora < DATEADD(dd,1,@dtIni) and a.dataSucesso is null and pcId is null

insert @tab --Assinatura
select dataInicio,clienteId,9999998,'Assinatura'
from ods.psafedb.dbo.Assinatura a 
where a.dataInicio >= @dtIni and a.dataInicio < DATEADD(dd,1,@dtIni)


insert @tab --Acesso
select a2.dataHoraAcesso,clienteId,9999995,'Acessou'
from ods.psafedb.dbo.Acesso a2 
join ods.psafedb.dbo.Assinatura a3 on a2.assinaturaid = a3.id 
where a2.dataHoraAcesso >= @dtIni and a2.dataHoraAcesso < DATEADD(dd,1,@dtIni)


insert @tab -- Notificacao
select n.dataHora,clienteId,tipoNotificacaoId,t.nome
from ods.psafedb.dbo.Notificacao n 
join ods.psafedb.dbo.tipoNotificacao t on n.tipoNotificacaoId = t.id 
where n.dataHora >= @dtIni and n.dataHora < DATEADD(dd,1,@dtIni)


-- DADOS GXC
insert @tab
select o.dataHora,clienteId,t.id,t.nome
from ClienteDb.dbo.OperacaoCliente o
join ClienteDb.dbo.TipoOperacaoCliente t on o.tipoOperacaoClienteId = t.id
where o.dataHora >= @dtIni and o.dataHora < DATEADD(dd,1,@dtIni)

insert @tab
select o.dataHora,clienteId,t.id,t.nome
from FidelidadeDb.dbo.Lancamento o
join Fidelidadedb.dbo.Credito t on o.creditoId = t.id
where o.dataHora >= @dtIni and o.dataHora < DATEADD(dd,1,@dtIni)

insert @tab
select o.dataHora,clienteId,t.id,t.nome
from FidelidadeDb.dbo.Lancamento o
join Fidelidadedb.dbo.Recompensa t on o.recompensaId = t.id
where o.dataHora >= @dtIni and o.dataHora < DATEADD(dd,1,@dtIni)


-- NO HIST DO CDC do ClienteDb!!!!
--Comando DML __$operation 
--DELETE 1 
--INSERT 2 
--Antes do UPDATE 3 
--Depois do UPDATE 4 

insert @tab
select tran_begin_time,c.id,9999996,'Cancelamento'
from  clientedb.cdc.dbo_cliente_CT c  join clientedb.cdc.lsn_time_mapping m on c.__$start_lsn = m.start_lsn
where  m.tran_begin_time >= @dtIni and m.tran_begin_time < DATEADD(dd,1,@dtIni) and  
c.__$operation = 4 and c.ativo = 0 and exists 
(select 1 from clientedb.cdc.dbo_cliente_CT c2  join clientedb.cdc.lsn_time_mapping m2 on c2.__$start_lsn = m2.start_lsn
where  c2.__$operation = 3 and c2.__$start_lsn = c.__$start_lsn and c2.__$seqval = c.__$seqval and c2.ativo = 1)

--LIMPA
delete Psafe from Psafe p join Data d on p.dataId = d.id and d.data = @dtIni

--select * from @tab

--PSAFE
insert Psafe (dataId ,horaId ,clienteId ,tipoOperacaoId,qtd)
select d.id ,h.id ,clienteId ,t.id,COUNT(*)
from @tab a 
join Data d on convert(date,a.data) = d.data
join Hora h on DATEPART(hh,a.data) = h.hora
join Cliente c on a.clienteId = c.id
join TipoOperacao t on a.idOrigem = t.idOrigem and a.nome = t.nome
group by  d.id ,h.id ,clienteId ,t.id

--PROX ITERACAO
delete @tab
select @dtIni = DATEADD(dd,1,@dtIni)
end --while
end -- proc
go
exec pr_CargaBi '20110330','20110404'

select * from Psafe p join TipoOperacao t on p.tipoOperacaoId = t.id and tabela like '%Notificacao%'

