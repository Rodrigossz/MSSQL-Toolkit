if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[rl_in_sim_nao]') and OBJECTPROPERTY(id, N'IsRule') = 1)
drop rule [dbo].[rl_in_sim_nao]
GO


create rule [rl_in_sim_nao] as @campo in ('S','N')


GO
