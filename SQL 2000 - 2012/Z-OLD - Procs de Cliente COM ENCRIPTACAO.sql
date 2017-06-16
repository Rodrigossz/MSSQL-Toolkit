USE [ClienteDb]
GO

/****** Object:  StoredProcedure [dbo].[pr_Cliente_del]    Script Date: 02/14/2011 15:40:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[pr_Cliente_del]
	@id int
WITH EXECUTE AS OWNER

AS
SET NOCOUNT ON

DELETE FROM Cliente
WHERE id = @id

SET NOCOUNT OFF


GO

/****** Object:  StoredProcedure [dbo].[pr_Cliente_lst]    Script Date: 02/14/2011 15:40:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[pr_Cliente_lst]
WITH EXECUTE AS OWNER

AS
SET NOCOUNT ON
exec pr_dba_OpenClosePasswordKey 'open'

SELECT top 1000 id,
primeiroNome,
nomeMeio,
sobrenome,
sexo,
dataNascimento,
email,
dataCadastro,
ativo, 
CONVERT(varchar (20), DecryptByKey(senha)) as senha 
,avancado,pj,clienteMasterId, saldoFidelidade,escudoId 
FROM Cliente
--WHERE id = @id

exec pr_dba_OpenClosePasswordKey 'close'
SET NOCOUNT OFF


GO

/****** Object:  StoredProcedure [dbo].[pr_Cliente_sel]    Script Date: 02/14/2011 15:40:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[pr_Cliente_sel]
	@id int
WITH EXECUTE AS OWNER

AS
SET NOCOUNT ON
exec pr_dba_OpenClosePasswordKey 'open'

SELECT id,
primeiroNome,
nomeMeio,
sobrenome,
sexo,
dataNascimento,
email,
dataCadastro,
ativo, 
CONVERT(varchar (100), DecryptByKey(senha)) as senha 
,avancado,pj,clienteMasterId,saldoFidelidade,escudoId 
FROM Cliente
WHERE id = @id

exec pr_dba_OpenClosePasswordKey 'close'
SET NOCOUNT OFF

GO

/****** Object:  StoredProcedure [dbo].[pr_Cliente_sel_email]    Script Date: 02/14/2011 15:40:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE proc [dbo].[pr_Cliente_sel_email]
@email tdEmail 
with execute as owner
AS
SET NOCOUNT ON
exec pr_dba_OpenClosePasswordKey 'open'

SELECT id,
primeiroNome,
nomeMeio,
sobrenome,
sexo,
dataNascimento,
email,
dataCadastro,
ativo, 
CONVERT(varchar (100), DecryptByKey(senha)) as senha 
,avancado,pj,clienteMasterId,saldoFidelidade,escudoId 
FROM Cliente (nolock) where email = @email


exec pr_dba_OpenClosePasswordKey 'close'
SET NOCOUNT OFF


GO

/****** Object:  StoredProcedure [dbo].[pr_Cliente_ups]    Script Date: 02/14/2011 15:40:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[pr_Cliente_ups]
	@id int = null,
	@primeiroNome varchar(1000) = null,
	@nomeMeio varchar(1000) = null,
	@sobrenome varchar(1000) = null,
	@sexo char(1) = null,
	@dataNascimento date = null,
	@email varchar(100) = null,
	@dataCadastro smalldatetime = null,
	@ativo bit = null,
	@senha varchar(100) = null, 
	@avancado bit = null,
	@pj bit = null,
	@clienteMasterId int = null,
	@saldoFidelidade int = null,
	@escudoId  tinyint = null
WITH EXECUTE AS OWNER

AS
SET NOCOUNT ON
exec pr_dba_OpenClosePasswordKey 'open'

IF @id = 0 BEGIN
	INSERT INTO Cliente (
		primeiroNome,
		nomeMeio,
		sobrenome,
		sexo,
		dataNascimento,
		email,
		dataCadastro,
		ativo,
		senha,avancado,
		pj,
		clienteMasterId,
		saldoFidelidade,escudoId )
	VALUES (
		@primeiroNome,
		@nomeMeio,
		@sobrenome,
		@sexo,
		@dataNascimento,
		@email,
		@dataCadastro,
		@ativo,
		EncryptByKey(Key_GUID('Senha_SK01'), @senha),
		@avancado,
		@pj,
		@clienteMasterId,
		@saldoFidelidade,
		@escudoId )

	SELECT SCOPE_IDENTITY() As InsertedID
END
ELSE BEGIN

if @senha is not null
	UPDATE Cliente SET 
		primeiroNome = isnull(@primeiroNome,primeiroNome),
		nomeMeio = isnull(@nomeMeio,nomeMeio),
		sobrenome = isnull(@sobrenome,sobrenome),
		sexo = isnull(@sexo,sexo),
		dataNascimento = isnull(@dataNascimento,dataNascimento),
		email = isnull(@email,email),
		dataCadastro = isnull(@dataCadastro,dataCadastro),
		ativo = isnull(@ativo,ativo),
		senha = EncryptByKey(Key_GUID('Senha_SK01'),@senha),
		avancado =isnull(@avancado,avancado),
		pj = isnull(@pj,pj),
		clienteMasterId = isnull(@clienteMasterID,clienteMasterID),
		saldoFidelidade = isnull(@saldoFidelidade,saldoFidelidade),
		escudoId = isnull(@escudoId, escudoId)
		
	WHERE id = @id

	else -- @senha is null
	UPDATE Cliente SET 
		primeiroNome = isnull(@primeiroNome,primeiroNome),
		nomeMeio = isnull(@nomeMeio,nomeMeio),
		sobrenome = isnull(@sobrenome,sobrenome),
		sexo = isnull(@sexo,sexo),
		dataNascimento = isnull(@dataNascimento,dataNascimento),
		email = isnull(@email,email),
		dataCadastro = isnull(@dataCadastro,dataCadastro),
		ativo = isnull(@ativo,ativo),
		avancado =isnull(@avancado,avancado),
		pj = isnull(@pj,pj),
		clienteMasterId = isnull(@clienteMasterID,clienteMasterID),
		saldoFidelidade = isnull(@saldoFidelidade,saldoFidelidade),
		escudoId = isnull(@escudoId, escudoId)

	WHERE id = @id
	
END
exec pr_dba_OpenClosePasswordKey 'close'
SET NOCOUNT OFF




GO

