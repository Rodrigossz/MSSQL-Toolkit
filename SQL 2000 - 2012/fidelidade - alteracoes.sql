alter table Lancamento alter column totalPontos int not null;
alter table Lancamento add processado bit default 0 not null;
alter table Lancamento add qtd int  not null;

create index LancamentoNaoProcessado_ID04 on Lancamento (data,clienteId) include (qtd,totalPontos) where processado = 0;
create index Lancamento_ID05 on Lancamento (data) ;

create proc pr_Lancamento_sel_NaoProc @clienteId int
WITH EXECUTE AS OWNERASSET NOCOUNT ONSELECT * FROM LancamentoWHERE clienteId = @clienteIdSET NOCOUNT OFFgo