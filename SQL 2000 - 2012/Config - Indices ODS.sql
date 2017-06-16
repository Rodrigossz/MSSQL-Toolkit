use PsafeDb;

set ANSI_PADDING on;

CREATE NONCLUSTERED INDEX [Assinatura_ID01]
    ON [dbo].[Assinatura]([planoId] ASC)
    INCLUDE([dataInicio]) WHERE ([dataCancelamento] IS NULL) WITH (FILLFACTOR = 90, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [INDEX];

CREATE NONCLUSTERED INDEX [Assinatura_ID02]
    ON [dbo].[Assinatura]([dataInicio] ASC)
    INCLUDE([planoId]) WHERE ([statusAssinaturaId] IS NULL) WITH (FILLFACTOR = 90, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [INDEX];

CREATE NONCLUSTERED INDEX [Assinatura_ID03]
    ON [dbo].[Assinatura]([dataCancelamento] ASC)
    INCLUDE([planoId]) WHERE ([dataCancelamento] IS NOT NULL) WITH (FILLFACTOR = 90, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [INDEX];

CREATE NONCLUSTERED INDEX [Indicacao_ID01]
    ON [dbo].[Indicacao]([data] ASC)
    INCLUDE([clienteId]) WITH (FILLFACTOR = 90, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [INDEX];

create index Indicacao_ID02 on indicacao (clienteId) include (emailindicado) on [index];

CREATE NONCLUSTERED INDEX [Indicacao_ID03]
    ON [dbo].[Indicacao]([assinaturaIndicadoId] ASC) WHERE ([assinaturaIndicadoId] IS NOT NULL) WITH (FILLFACTOR = 90, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [INDEX];

CREATE NONCLUSTERED INDEX [Indicacao_ID05]
    ON [dbo].[Indicacao]([emailIndicado] ASC)
    INCLUDE([clienteId]) WITH (FILLFACTOR = 90, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [INDEX];

create index Instalacao_ID01 on instalacao (guId) on [index];

create index Instalacao_ID02 on instalacao (dataHora) include (sucesso) on [index];

create index Instalacao_ID03 on instalacao (dataSucesso) on [index];

create index Instalacao_ID04 on instalacao (pcId) include (dataSucesso) on [index];




create index pc_ID01 on Pc (hwId) where hwId is not null on [index];

CREATE NONCLUSTERED INDEX [Plano_ID01]
    ON [dbo].[Plano]([periodicidadeId] ASC)
    INCLUDE([produtoId], [precoId]) WITH (FILLFACTOR = 95, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [INDEX];

CREATE NONCLUSTERED INDEX [Plano_ID02]
    ON [dbo].[Plano]([precoId] ASC)
    INCLUDE([produtoId], [periodicidadeId]) WITH (FILLFACTOR = 95, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [INDEX];

CREATE NONCLUSTERED INDEX [Plano_ID03]
    ON [dbo].[Plano]([produtoId] ASC)
    INCLUDE([periodicidadeId], [precoId]) WITH (FILLFACTOR = 95, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [INDEX];

CREATE UNIQUE NONCLUSTERED INDEX [ProdutoServico_ID01]
    ON [dbo].[ProdutoServico]([produtoId] ASC, [servicoId] ASC) WHERE ([ativo]=(1)) WITH (FILLFACTOR = 90, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [INDEX];

CREATE NONCLUSTERED INDEX [ProdutoServico_ID02]
    ON [dbo].[ProdutoServico]([servicoId] ASC)
    INCLUDE([produtoId]) WHERE ([ativo]=(1)) WITH (FILLFACTOR = 90, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [INDEX];

create index Acesso_ID01 on acesso(pcId) include (assinaturaId) on [index];
create index Acesso_ID02 on acesso(assinaturaId) include (pcId) on [index];
