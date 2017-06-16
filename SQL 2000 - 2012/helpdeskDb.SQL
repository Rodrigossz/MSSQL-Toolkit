create database TicketDeskDb --Model database completamente configurado
-- por isso q o create database é simples assim.
go
use TicketDeskDb
go
-- Nao tem em PROD!!!
create user [GRUPOXANGO\GP_DEV] from login [GRUPOXANGO\gp_DEV];
grant select to GxcDbRoleDev; 
grant execute to GxcDbRoleDev; 
grant VIEW DEFINITION  to GxcDbRoleDev;
exec sp_addrolemember 'GxcDbRoleDev','GRUPOXANGO\GP_DEV'; 

--Diferente em PROD
create user [GRUPOXANGO\IIS_DEV] from login [GRUPOXANGO\IIS_DEV];
grant execute to GxcDbRole;
exec sp_addrolemember 'GxcDbRole','GRUPOXANGO\IIS_DEV'; 
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[status]') AND type in (N'U'))
    DROP TABLE [dbo].[Status]
GO
CREATE TABLE [dbo].[Status] (
[id] smallint identity (1,1)  NOT NULL  
, [nome] tddesc  NOT NULL  
)
GO

ALTER TABLE [dbo].[status] ADD CONSTRAINT [status_PK] PRIMARY KEY CLUSTERED (
[id]
)
GO
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ticket]') AND type in (N'U'))
    DROP TABLE [dbo].[ticket]
GO
CREATE TABLE [dbo].[Ticket] (
[id] int identity (1,1)  NOT NULL  
, [clienteId] int  NOT NULL  
, [statusId] smallint  NOT NULL  
, [categoriaId] int  NOT NULL  
, [produtoId] int   NULL  
, [assunto] tddesc  NOT NULL  
, [dataHoraAbertura] smalldatetime  NOT NULL  
, [dataHoraConclusao] smalldatetime  NULL  
, [vip] bit  NOT NULL  
, [pendenteInteracaoUsuario] bit  NOT NULL  
, [concluidoPeloCliente] bit  NOT NULL  
, [usuarioResponsavelId] int  NULL  
, [usuarioAdministradorId] int  NULL  
)
GO
create index Ticket_ID01 on ticket (clienteId)
go
create index Ticket_ID02 on ticket (statusId)
go
create index Ticket_ID03 on ticket (categoriaId)
go
create index Ticket_ID04 on ticket (produtoId)
go
create index Ticket_ID05 on ticket (dataHoraAbertura)
go


ALTER TABLE [dbo].[ticket] ADD CONSTRAINT [ticket_PK] PRIMARY KEY CLUSTERED (
[id]
)
GO
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[anexo]') AND type in (N'U'))
    DROP TABLE [dbo].[anexo]
GO
CREATE TABLE [dbo].[Anexo] (
[id] int identity (1,1)  NOT NULL  
, [interacaoId] int  NOT NULL  
, [nomeArquivo] tddesc  NOT NULL  
, [caminhoArquivo] tddesc  NOT NULL  
, [hash] tddesc  NOT NULL  
)
GO

ALTER TABLE [dbo].[anexo] ADD CONSTRAINT [anexo_PK] PRIMARY KEY CLUSTERED (
[id]
)
GO
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[respostaPadrao]') AND type in (N'U'))
    DROP TABLE [dbo].[respostaPadrao]
GO
CREATE TABLE [dbo].[RespostaPadrao] (
[id] int identity (1,1)  NOT NULL  
, [produtoId] int  NOT NULL  
, [texto] tdobs  NOT NULL  
)
GO

ALTER TABLE [dbo].[respostaPadrao] ADD CONSTRAINT [respostaPadrao_PK] PRIMARY KEY CLUSTERED (
[id]
)
GO
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[interacao]') AND type in (N'U'))
    DROP TABLE [dbo].[interacao]
GO
CREATE TABLE [dbo].[Interacao] (
[id] int identity (1,1)  NOT NULL  
, [usuarioId] int  NULL  
, [ticketId] int  NOT NULL  
, [Mensagem] tdobs  NOT NULL  
, [dataHora] smalldatetime  NOT NULL  
, [respostaPorEmail] bit  NOT NULL  
)
GO

ALTER TABLE [dbo].[interacao] ADD CONSTRAINT [interacao_PK] PRIMARY KEY CLUSTERED (
[id]
)
GO
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Etiqueta]') AND type in (N'U'))
    DROP TABLE [dbo].[Etiqueta]
GO
CREATE TABLE [dbo].[Etiqueta] (
[id] smallint identity (1,1) NOT NULL  
, [nome] tddesc  NOT NULL  
)
GO

ALTER TABLE [dbo].[Etiqueta] ADD CONSTRAINT [Etiqueta_PK] PRIMARY KEY CLUSTERED (
[id]
)
GO
CREATE UNIQUE  INDEX [Etiqueta_UC1] ON [dbo].[Etiqueta] (
[nome]
)
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EtiquetasTiquet]') AND type in (N'U'))
    DROP TABLE [dbo].[EtiquetaTiket]
GO
CREATE TABLE [dbo].[EtiquetaTicket] (
id int identity(1,1) primary key,
[etiquetaId] smallint  NOT NULL  
, [ticketId] int  NOT NULL  
)
GO

ALTER TABLE [dbo].[EtiquetaTicket] ADD CONSTRAINT [EtiquetasTiquet_UK01] Unique (
[EtiquetaId]
, [ticketId]
)
GO
create index EtiquetaTicket_ID01 on EtiquetaTicket (ticketId,etiquetaId)
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[historicoStatusTicket]') AND type in (N'U'))
    DROP TABLE [dbo].[historicoStatusTicket]
GO
CREATE TABLE [dbo].[HistoricoStatusTicket] (
[id] int identity (1,1)  NOT NULL  
, [ticketId] int  NOT NULL  
, [statusId] smallint  NOT NULL  
, [usuarioId] int  NULL  
, [dataHora] smalldatetime  NOT NULL  
)
GO

ALTER TABLE [dbo].[historicoStatusTicket] ADD CONSTRAINT [historicoStatusTicket_PK] PRIMARY KEY CLUSTERED (
[id]
)
GO
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[categoria]') AND type in (N'U'))
    DROP TABLE [dbo].[categoria]
GO
CREATE TABLE [dbo].[Categoria] (
[id] int identity (1,1) NOT NULL  
, [nome] tddesc NOT NULL  
)
GO

ALTER TABLE [dbo].[categoria] ADD CONSTRAINT [categoria_PK] PRIMARY KEY CLUSTERED (
[id]
)
GO
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usuario]') AND type in (N'U'))
    DROP TABLE [dbo].[usuario]
GO
CREATE TABLE [dbo].[Usuario] (
[id] int identity (1,1) NOT NULL  
, [Login] tddesc  NOT NULL  
, [admin] bit  NOT NULL  
, [dataHoraCriacao] smalldatetime  NOT NULL  
, [Bloqueado] bit  NOT NULL  
)
GO

ALTER TABLE [dbo].[usuario] ADD CONSTRAINT [usuario_PK] PRIMARY KEY CLUSTERED (
[id]
)
GO
GO

GO

ALTER TABLE [dbo].[ticket] WITH CHECK ADD CONSTRAINT [status_Ticket_FK1] FOREIGN KEY (
[statusId]
)
REFERENCES [dbo].[status] (
[id]
)
ALTER TABLE [dbo].[ticket] WITH CHECK ADD CONSTRAINT [usuario_Ticket_FK1] FOREIGN KEY (
[usuarioAdministradorId]
)
REFERENCES [dbo].[usuario] (
[id]
)
ALTER TABLE [dbo].[ticket] WITH CHECK ADD CONSTRAINT [usuario_Ticket_FK2] FOREIGN KEY (
[usuarioResponsavelId]
)
REFERENCES [dbo].[usuario] (
[id]
)

ALTER TABLE [dbo].[ticket] WITH CHECK ADD CONSTRAINT [categoria_Ticket_FK1] FOREIGN KEY (
[categoriaId]
)
REFERENCES [dbo].[categoria] (
[id]
)
GO

ALTER TABLE [dbo].[anexo] WITH CHECK ADD CONSTRAINT [interacao_Anexo_FK1] FOREIGN KEY (
[interacaoId]
)
REFERENCES [dbo].[interacao] (
[id]
)
GO

ALTER TABLE [dbo].[interacao] WITH CHECK ADD CONSTRAINT [ticket_Interacao_FK1] FOREIGN KEY (
[ticketId]
)
REFERENCES [dbo].[ticket] (
[id]
)
ALTER TABLE [dbo].[interacao] WITH CHECK ADD CONSTRAINT [usuario_Interacao_FK1] FOREIGN KEY (
[usuarioId]
)
REFERENCES [dbo].[usuario] (
[id]
)
GO

ALTER TABLE [dbo].[EtiquetaTicket] WITH CHECK ADD CONSTRAINT [ticket_EtiquetasTiquet_FK1] FOREIGN KEY (
[ticketId]
)
REFERENCES [dbo].[ticket] (
[id]
)
ALTER TABLE [dbo].[EtiquetaTicket] WITH CHECK ADD CONSTRAINT [Etiqueta_EtiquetasTiquet_FK1] FOREIGN KEY (
[EtiquetaId]
)
REFERENCES [dbo].[Etiqueta] (
[id]
)
GO

ALTER TABLE [dbo].[historicoStatusTicket] WITH CHECK ADD CONSTRAINT [status_HistoricoStatusTicket_FK1] FOREIGN KEY (
[statusId]
)
REFERENCES [dbo].[status] (
[id]
)
ALTER TABLE [dbo].[historicoStatusTicket] WITH CHECK ADD CONSTRAINT [ticket_HistoricoStatusTicket_FK1] FOREIGN KEY (
[ticketId]
)
REFERENCES [dbo].[ticket] (
[id]
)
ALTER TABLE [dbo].[historicoStatusTicket] WITH CHECK ADD CONSTRAINT [usuario_HistoricoStatusTicket_FK1] FOREIGN KEY (
[usuarioId]
)
REFERENCES [dbo].[usuario] (
[id]
)
GO

GO

GO

