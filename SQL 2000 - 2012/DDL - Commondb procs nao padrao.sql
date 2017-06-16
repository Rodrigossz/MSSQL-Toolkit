USE [CommonDb]
GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_Erros]    Script Date: 04/27/2011 12:26:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Relat_Erros]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Relat_Erros]
GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_ErrosCons]    Script Date: 04/27/2011 12:26:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_Relat_ErrosCons]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_Relat_ErrosCons]
GO

/****** Object:  StoredProcedure [dbo].[pr_RelatErrosCons]    Script Date: 04/27/2011 12:26:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pr_RelatErrosCons]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pr_RelatErrosCons]
GO

USE [CommonDb]
GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_Erros]    Script Date: 04/27/2011 12:26:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE proc [dbo].[pr_Relat_Erros]
@dtIni smalldatetime = null, @dtFim smalldatetime = null, @tipo char(1) = 'd'
WITH EXECUTE AS OWNER
as
begin
set nocount on

-- Vou ignorar o ultimo parametro por enquanto.


-- Ao contratio do resto das procs, vou mostrar a ultima hora caso o 1o parametro seja null
if @dtIni is null 
select @dtIni = DATEADD(dd,-1,GETDATE()),@dtFim = GETDATE()

select 
e.id ,
dataErro,
--tipoErroId,
--t.nome as tipoErro,
--sistemaId,
s.nome as sistema,
erroTxt
--substring (erroTxt,1,1500) as Erro
from Erro e (nolock)
left outer join TipoErro t  (nolock) on e.tipoErroId = t.id
join Sistema s (nolock) on   e.sistemaId = s.id
where dataErro >= @dtIni and dataErro <= @dtFim
end -- proc


GO

/****** Object:  StoredProcedure [dbo].[pr_Relat_ErrosCons]    Script Date: 04/27/2011 12:26:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create proc [dbo].[pr_Relat_ErrosCons]
@dtIni smalldatetime = null, @dtFim smalldatetime = null, @tipo char(1) = 'd'
WITH EXECUTE AS OWNER
as
begin
set nocount on

-- Vou ignorar o ultimo parametro por enquanto.


-- Ao contratio do resto das procs, vou mostrar as ultimas 24 horas caso o 1o parametro seja null
if @dtIni is null 
select @dtIni = DATEADD(dd,-1,GETDATE()),@dtFim = GETDATE()

declare @tab table (id smallint identity(1,1) primary key,erroTxt varchar(400),total int, dataErro smalldatetime)
insert @tab
select 
case 
when erroTxt like '%Failure sending mail%' then 'Failure sending mail'
when erroTxt like '%Erro na postagem do facebook%' then 'Erro na postagem do facebook'
when erroTxt like '%error occurred while establishing a connection to SQL Server%' then 'Error establishing a connection to SQL Server'
when erroTxt like '%conflicted with the FOREIGN KEY%' then 'Conflict with the FOREIGN KEY'
when erroTxt like '%The timeout period elapsed prior to obtaining a connection from the pool%' then 'Timeout to obtaining a connection from the pool'
when erroTxt like '%System.Xml.XmlException%' then 'Xml Exception'
when erroTxt like '%Error validating access token%' then 'Error validating access token'
when erroTxt like '%Invalid OAuth access token%' then 'Invalid OAuth access token'
when erroTxt like '%Nenhum contato encontrado%' then 'ApplicationException: Nenhum contato encontrado'
when erroTxt like '%The specified string is not in the form required for an e-mail address%' then 'The specified string is not in the form required for an e-mail address'
when erroTxt like '%An invalid character was found in the mail header%' then 'An invalid character was found in the mail header'
when erroTxt like '%SqlException (0x80131904): Login failed. The login is from an untrusted domain and cannot be used with Windows authentication.%' then 'SqlException: Login failed. Untrusted domain and cannot be used with Windows authentication'
when erroTxt like '%The SELECT permission was denied on the object%' then 'SqlException: The SELECT permission was denied on the object'
when erroTxt like '%Não foi possível processar sua requisição. Tente novamente mais tarde%' then 'Não foi possível processar sua requisição. Tente novamente mais tarde'
when erroTxt like '%This service not available on your plan%' then 'This service not available on your plan'
when erroTxt like '%Invalid username & password", "email" : "Invalid username & password%' then 'Invalid username & password", "email" : "Invalid username & password'
when erroTxt like '%EndpointNotFoundException: There was no endpoint listening at https://mid.psafe.com%' then 'EndpointNotFoundException: There was no endpoint listening at https://mid.psafe.com'
when erroTxt like '%WebException: The operation has timed out%' then 'WebException: The operation has timed out'
when erroTxt like '%InvalidOperationException: Cannot convert null to a value type%' then 'InvalidOperationException: Cannot convert null to a value type'
when erroTxt like '%ArgumentException: Invalid object passed in,%expected. (4530)%' then 'ArgumentException: Invalid object passed in : or } expected'
when erroTxt like '%GDataRequestException: Execution of request failed: http://www.google.com/m8/feeds/contacts/default/full%' then 'GDataRequestException: Execution of request failed.'
when erroTxt like '%.ArgumentNullException%' then 'Parâmetro não pode ser null'
when erroTxt like '%.ArgumentException%Contatos%' then 'ArgumentException: Não há indicações no parâmetro contatos'
when erroTxt like '%.ArgumentException%clienteId%' then 'ArgumentException: Valor inválido para o clienteId'
when erroTxt like '%IndexOutOfRangeException%' then 'Index was outside the bounds of the array'
when erroTxt like '%ActionNotSupportedException%tempuri.org%' then 'The message with Action http://tempuri.org/IUserProfileService/ObterTokenIndicacao cannot be processed'
when erroTxt like '%Feed action request limit reached%' then 'Feed action request limit reached'
when erroTxt like '%ProtocolException: The content type text/html; charset=utf-8 of the response message does not match the content%' then 'ProtocolException: The content type text/html; charset=utf-8 of the response message does not match the content'
when erroTxt like '%ProtocolException: The remote server returned an unexpected response: (400) Bad Request%' then 'ProtocolException: The remote server returned an unexpected response: (400) Bad Request'
when erroTxt like '%algo errado aconteceu%' then 'Ops, algo errado aconteceu. Caso o prolema persista, entre em contato com o suporte.'
when erroTxt like '%autenticação automática%' then 'Não foi possível proceder com a autenticação automática.'
when erroTxt like '%pr_Cliente_ups%' then 'Procedure or function pr_Cliente_ups has too many arguments specified.'
when erroTxt like '%pr_Instalacao_ups%' then 'Procedure or function pr_Instalacao_ups has too many arguments specified.'
else 'Texto Original '+substring(erroTxt,1,280) 
end as erroTxt, COUNT(*) as Total, MAX(dataErro) as dataErro
from Erro (nolock)
where dataErro between @dtIni and @dtFim
group by 
case 
when erroTxt like '%Failure sending mail%' then 'Failure sending mail'
when erroTxt like '%Erro na postagem do facebook%' then 'Erro na postagem do facebook'
when erroTxt like '%error occurred while establishing a connection to SQL Server%' then 'Error establishing a connection to SQL Server'
when erroTxt like '%conflicted with the FOREIGN KEY%' then 'Conflict with the FOREIGN KEY'
when erroTxt like '%The timeout period elapsed prior to obtaining a connection from the pool%' then 'Timeout to obtaining a connection from the pool'
when erroTxt like '%System.Xml.XmlException%' then 'Xml Exception'
when erroTxt like '%Error validating access token%' then 'Error validating access token'
when erroTxt like '%Invalid OAuth access token%' then 'Invalid OAuth access token'
when erroTxt like '%Nenhum contato encontrado%' then 'ApplicationException: Nenhum contato encontrado'
when erroTxt like '%The specified string is not in the form required for an e-mail address%' then 'The specified string is not in the form required for an e-mail address'
when erroTxt like '%An invalid character was found in the mail header%' then 'An invalid character was found in the mail header'
when erroTxt like '%SqlException (0x80131904): Login failed. The login is from an untrusted domain and cannot be used with Windows authentication.%' then 'SqlException: Login failed. Untrusted domain and cannot be used with Windows authentication'
when erroTxt like '%The SELECT permission was denied on the object%' then 'SqlException: The SELECT permission was denied on the object'
when erroTxt like '%Não foi possível processar sua requisição. Tente novamente mais tarde%' then 'Não foi possível processar sua requisição. Tente novamente mais tarde'
when erroTxt like '%This service not available on your plan%' then 'This service not available on your plan'
when erroTxt like '%Invalid username & password", "email" : "Invalid username & password%' then 'Invalid username & password", "email" : "Invalid username & password'
when erroTxt like '%EndpointNotFoundException: There was no endpoint listening at https://mid.psafe.com%' then 'EndpointNotFoundException: There was no endpoint listening at https://mid.psafe.com'
when erroTxt like '%WebException: The operation has timed out%' then 'WebException: The operation has timed out'
when erroTxt like '%InvalidOperationException: Cannot convert null to a value type%' then 'InvalidOperationException: Cannot convert null to a value type'
when erroTxt like '%ArgumentException: Invalid object passed in,%expected. (4530)%' then 'ArgumentException: Invalid object passed in : or } expected'
when erroTxt like '%GDataRequestException: Execution of request failed: http://www.google.com/m8/feeds/contacts/default/full%' then 'GDataRequestException: Execution of request failed.'
when erroTxt like '%.ArgumentNullException%' then 'Parâmetro não pode ser null'
when erroTxt like '%.ArgumentException%Contatos%' then 'ArgumentException: Não há indicações no parâmetro contatos'
when erroTxt like '%.ArgumentException%clienteId%' then 'ArgumentException: Valor inválido para o clienteId'
when erroTxt like '%IndexOutOfRangeException%' then 'Index was outside the bounds of the array'
when erroTxt like '%ActionNotSupportedException%tempuri.org%' then 'The message with Action http://tempuri.org/IUserProfileService/ObterTokenIndicacao cannot be processed'
when erroTxt like '%Feed action request limit reached%' then 'Feed action request limit reached'
when erroTxt like '%ProtocolException: The content type text/html; charset=utf-8 of the response message does not match the content%' then 'ProtocolException: The content type text/html; charset=utf-8 of the response message does not match the content'
when erroTxt like '%ProtocolException: The remote server returned an unexpected response: (400) Bad Request%' then 'ProtocolException: The remote server returned an unexpected response: (400) Bad Request'
when erroTxt like '%algo errado aconteceu%' then 'Ops, algo errado aconteceu. Caso o prolema persista, entre em contato com o suporte.'
when erroTxt like '%autenticação automática%' then 'Não foi possível proceder com a autenticação automática.'
when erroTxt like '%pr_Cliente_ups%' then 'Procedure or function pr_Cliente_ups has too many arguments specified.'
when erroTxt like '%pr_Instalacao_ups%' then 'Procedure or function pr_Instalacao_ups has too many arguments specified.'
else 'Texto Original '+substring(erroTxt,1,280) end 
select * from @tab order by 3 desc
end -- proc

GO

/****** Object:  StoredProcedure [dbo].[pr_RelatErrosCons]    Script Date: 04/27/2011 12:26:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[pr_RelatErrosCons]
@dtIni smalldatetime = null, @dtFim smalldatetime = null, @tipo char(1) = 'd'
WITH EXECUTE AS OWNER
as
execute pr_RelatErrosCons @dtIni,@dtFim,@tipo

GO

