if exists (select * from dbo.systypes where name = N'td_in_sim_nao')
exec sp_droptype N'td_in_sim_nao'
GO

setuser
GO

EXEC sp_addtype N'td_in_sim_nao', N'char (1)', N'null'
GO

setuser
GO

setuser
GO

EXEC sp_bindrule N'[dbo].[rl_in_sim_nao]', N'[td_in_sim_nao]'
GO

setuser
GO

