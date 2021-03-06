USE [PsafeDb]
GO
/****** Object:  StoredProcedure [dbo].[pr_Indicacao_sel_clienteId_Total]    Script Date: 04/29/2011 17:14:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

alter table indicacao  add statusEmailId tinyint default 1 not null references statusemail  ;
update indicacao set statusemailid = 5;
create index Indicacao_ID06 on Indicacao (statusEmailId);
go

ALTER PROCEDURE [dbo].[pr_Indicacao_sel_clienteId_Total]
 @clienteId int  , @statusemailId tinyint
 with execute as owner
AS
BEGIN
SET NOCOUNT ON;
   
select COUNT(1) from Indicacao (nolock)
where clienteId = @clienteId and statusEmailId = @statusEmailId
END
go
USE [PsafeDb]
GO
/****** Object:  StoredProcedure [dbo].[pr_Indicacao_sel_statusEmailId]    Script Date: 04/29/2011 17:15:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[pr_Indicacao_sel_statusEmailId]
	@statusEmailId tinyint
WITH EXECUTE AS OWNER

AS
SET NOCOUNT ON

SELECT top 5000 * 
FROM Indicacao (nolock) i
left outer join MensagemIndicacao m (nolock) on i.mensagemIndicacaoId = m.id
WHERE statusEmailId = @statusEmailId
order by i.id 

SET NOCOUNT OFF
go

create  trigger Indicacao_TG01 on indicacao after insert
as
begin
update Indicacao 
set statusEmailId = 3
from inserted i1
join Indicacao i2 on i1.id = i2.id
join OptOut o on o.email = i1.emailIndicado
where i1.statusEmailId <> 3 and i1.statusEmailId  <> 2
end
--select * from StatusEmail
