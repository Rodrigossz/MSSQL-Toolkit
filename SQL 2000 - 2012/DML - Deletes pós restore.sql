--OBS!!! Checkindent em prod!!!!


use PsafeDb

if @@servername not like '%PROD%'
begin
truncate table AcessoLog
delete  Acesso
truncate table Dependente
truncate table Indicacao
delete  Assinatura
truncate table Instalacao
truncate table Notificacao
truncate table Operacao
truncate table Pagamento
delete Pc
end

use ClienteDb

if @@servername not like '%PROD%'
begin

truncate table OrigemContatoInfo
truncate table operacaocliente
truncate table enderecofinanceiro
truncate table endereco
truncate table ClienteEmailAdicional
delete Cliente
end

use FidelidadeDb

if @@servername not like '%PROD%'
begin

truncate table ClienteEscudo
truncate table LancamentoResgate
delete Lancamento
delete resgate
end



sp_dba_tb