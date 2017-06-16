select * from TipoOperacao
select * from Cliente

alter table tipooperacao add serveridor tdsmalldesc null,baseDados tdsmalldesc null,tabela tdsmalldesc null
sp_rename 'tipooperacao.serveridor',servidor

update TipoOperacao set servidor = 'ODS' where tipo like 'psafedb%'
update TipoOperacao set baseDados = 'PsafeDb' where tipo like 'psafedb%'
update TipoOperacao set tabela = 'TipoOperacao' where tipo like 'psafedb%TipoOperacao'
update TipoOperacao set tabela = 'TipoLog' where tipo like 'psafedb%tipoLog'
update TipoOperacao set tabela = 'Indicacao' where tipo like 'psafedb%Indicacao'
update TipoOperacao set tabela = 'Assinatura' where tipo like 'psafedb%Assinatura'
update TipoOperacao set tabela = 'Instalacao' where tipo like 'psafedb%Instalacao'
update TipoOperacao set tabela = 'Acesso' where tipo like 'psafedb%Acesso'
update TipoOperacao set servidor = 'GXC' where servidor is null
update TipoOperacao set baseDados = 'FidelidadeDb' where tipo like 'Fidelidade%'
update TipoOperacao set baseDados = 'ClienteDb' where tipo like 'clientedb%'
update TipoOperacao set tabela = 'TipoOperacaoCliente' where servidor = 'gxc' and tabela is null and tipo like '%TipoOperacaoCliente'
update TipoOperacao set tabela = 'cliente' where servidor = 'gxc' and tabela is null and tipo like '%.Cliente'
update TipoOperacao set tabela = 'Credito' where servidor = 'gxc' and tabela is null and tipo like '%.credito'
update TipoOperacao set tabela = 'Recompensa' where servidor = 'gxc' and tabela is null and tipo like '%.recompensa'

update TipoOperacao set tipo = 'Tipo de Operacao do Cliente no PsafeDb (Desativado)' where tipo = 'psafedb.dbo.TipoOperacao'
update TipoOperacao set tipo = 'Logs do Acesso do Cliente (tabela AcessoLog)' where tipo = 'psafedb.dbo.tipoLog'
update TipoOperacao set tipo = 'Lançamentos de Crédito do Cliente no Fidelidade' where tipo = 'Fidelidadedb.dbo.Credito'

update TipoOperacao set tipo = 'Indicações do Cliente' where tipo = 'PsafeDb.dbo.Indicacao'
update TipoOperacao set tipo = 'Instalações do Cliente' where tipo = 'PsafeDb.dbo.Instalacao'
update TipoOperacao set tipo = 'Acessos do Cliente (Assinatura x Pc)' where tipo = 'PsafeDb.dbo.Acesso'
update TipoOperacao set tipo = 'Assinaturas' where tipo = 'PsafeDb.dbo.Assinatura'
update TipoOperacao set tipo = 'Cancelamentos do Cliente' where tipo = 'clientedb.dbo.cliente'

update TipoOperacao set nome = 'Acessou' where nome = 'Acessou'


select * from CommonDb..TipoErro
select * from CommonDb..Erro
select * from CommonDb..Sistema

insert TipoOperacao select id,nome,'Erros do sistema no log corporativo',GETDATE(),'GXC','CommonDb','TipoErro'
from CommonDb..TipoErro

dbcc checkdb (ticketdb)

