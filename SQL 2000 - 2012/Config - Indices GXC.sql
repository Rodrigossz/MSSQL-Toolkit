use ClienteDb;

set QUOTED_IDENTIFIER on 
set ANSI_PADDING on

--alter table cliente drop constraint UQ__Cliente__AB6E61647DEDA633;
create unique index Cliente_ID01 on Cliente (email) include (senha) where ativo = 1 on [index];
create index Cliente_ID02 on Cliente (dataCadastro) include (dataHoraPontosCadastroCompleto) on [index];
create index Cliente_ID03 on Cliente (clienteMasterId) where clienteMasterId is not null on [index];
create index Cliente_ID04 on Cliente (saldoEscudo desc, dataCadastro) -- on [index];



CREATE NONCLUSTERED INDEX [ClienteEmailAdicional_ID01]
    ON [dbo].[ClienteEmailAdicional]([email] ASC)
    INCLUDE([clienteId]) WHERE ([ativo]=(1)) WITH (FILLFACTOR = 90, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [INDEX];

CREATE NONCLUSTERED INDEX [ClienteEmailAdicional_ID02]
    ON [dbo].[ClienteEmailAdicional]([clienteId] ASC)
    INCLUDE([email]) WHERE ([ativo]=(1)) WITH (FILLFACTOR = 90, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [INDEX];

CREATE NONCLUSTERED INDEX [Endereco_ID01]
    ON [dbo].[Endereco]([clienteId] ASC) WHERE ([ativo]=(1)) WITH (FILLFACTOR = 90, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [INDEX];

CREATE NONCLUSTERED INDEX [Endereco_ID02]
    ON [dbo].[Endereco]([cep] ASC) WHERE ([cep] IS NOT NULL AND [ativo]=(1)) WITH (FILLFACTOR = 90, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [INDEX];
    
CREATE NONCLUSTERED INDEX [OperacaoCliente_ID01]
    ON [dbo].[OperacaoCliente]([dataHora] ASC)
    INCLUDE([clienteId]) WITH (FILLFACTOR = 90, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [INDEX];

CREATE NONCLUSTERED INDEX [OperacaoCliente_ID02]
    ON [dbo].[OperacaoCliente]([tipoOperacaoClienteId] ASC)
    INCLUDE([clienteId]) WITH (FILLFACTOR = 90, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [INDEX];

CREATE NONCLUSTERED INDEX [OperacaoCliente_ID03]
    ON [dbo].[OperacaoCliente]([clienteId] ASC)
    INCLUDE([tipoOperacaoClienteId]) WITH (FILLFACTOR = 90, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [INDEX];

CREATE NONCLUSTERED INDEX [OrigemContatoInfo_ID01]
    ON [dbo].[OrigemContatoInfo]([dataContato] ASC)
    INCLUDE([clienteId]) WHERE ([ativo]=(1)) WITH (FILLFACTOR = 90, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [INDEX];

CREATE NONCLUSTERED INDEX [OrigemContatoInfo_ID02]
    ON [dbo].[OrigemContatoInfo]([clienteId] ASC)
    INCLUDE([origemContatoId]) WHERE ([ativo]=(1)) WITH (FILLFACTOR = 90, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [INDEX];

CREATE NONCLUSTERED INDEX [OrigemContatoInfo_ID03]
    ON [dbo].[OrigemContatoInfo]([origemContatoId] ASC)
    INCLUDE([clienteId]) WHERE ([ativo]=(1)) WITH (FILLFACTOR = 90, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [INDEX];

CREATE NONCLUSTERED INDEX [OrigemContatoInfo_ID04]
    ON [dbo].[OrigemContatoInfo]([login] ASC)
    INCLUDE([clienteId]) WHERE ([ativo]=(1)) WITH (FILLFACTOR = 90, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [INDEX];

use FidelidadeDb;

CREATE NONCLUSTERED INDEX [Lancamento_ID01]
    ON [dbo].[Lancamento]([recompensaId] ASC) WHERE ([recompensaId] IS NOT NULL) WITH (FILLFACTOR = 90, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [INDEX];

CREATE NONCLUSTERED INDEX [Lancamento_ID02]
    ON [dbo].[Lancamento]([creditoId] ASC) WHERE ([creditoid] IS NOT NULL) WITH (FILLFACTOR = 90, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [INDEX];

CREATE NONCLUSTERED INDEX [Lancamento_ID03]
    ON [dbo].[Lancamento]([clienteId] ASC) WITH (FILLFACTOR = 90, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [INDEX];


CREATE NONCLUSTERED INDEX [Lancamento_ID04]
    ON [dbo].[Lancamento](DataHora ASC)  include (qtd,totalPontos) where processado = 0
    ON [INDEX];


use commondb;

create index Erro_ID01 on erro (dataErro) include (sistemaId) on [index];
create index Erro_ID02 on erro (sistemaId) include (dataErro) on [index];




