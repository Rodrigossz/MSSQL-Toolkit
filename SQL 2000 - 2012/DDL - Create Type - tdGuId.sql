CREATE TYPE [dbo].[tdguId] FROM [char](36) NULL
GO

drop index pc.pc_ID01;
alter table pc alter column guId tdGuId null;
create index pc_ID01 on Pc (guId) where guId is not null;


drop index instalacao.Instalacao_ID01;
alter table instalacao alter column guId tdGuId not null;
create index Instalacao_ID01 on instalacao (guId);

