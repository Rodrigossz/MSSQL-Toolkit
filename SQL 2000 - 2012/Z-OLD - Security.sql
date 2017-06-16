-- Se precisar...
--DROP MASTER KEY;
--ALTER SERVICE MASTER KEY REGENERATE;

/*
-- To allow advanced options to be changed.
EXEC sp_configure 'show advanced options', 1
GO
-- To update the currently configured value for advanced options.
RECONFIGURE
GO
-- To enable the feature.
EXEC sp_configure 'xp_cmdshell', 1
GO
-- To update the currently configured value for this feature.
RECONFIGURE
GO
exec sp_change_users_login  'Auto_Fix','pSafe' 
exec sp_changedbowner 'sa'

*/


BACKUP SERVICE MASTER KEY TO FILE ='c:\dba\Backup\service_master_key' ENCRYPTION BY PASSWORD ='GX@ng02010'

--use PsafeDB;
create role PsafeDbRole
go
create role PsafeDbRolePDev
go
exec sp_addrolemember 'PsafeDbRole','Psafe'
exec sp_addrolemember 'PsafeDbRolePDev','Psafe'
go
grant execute to PsafeDbRole
go
grant select to PsafeDbRolePDev
grant execute to PsafeDbRolePDev
grant VIEW DEFINITION  to PsafeDbRolePDev
go
--grant insert,update,delete to PsafeDbRolePDev -- SO SE PRECISAR
go

drop MASTER KEY 

create MASTER KEY ENCRYPTION BY PASSWORD = 'Fl@m3ng01981';

BACKUP MASTER KEY TO FILE = 'c:\dba\backup\gxclientedb_master_key_new'  ENCRYPTION BY PASSWORD ='GX@ng02010';


drop SYMMETRIC KEY CartaoCredito_SK01 
go
drop SYMMETRIC KEY Senha_SK01
go
drop CERTIFICATE CertificadoCartaoCredito
GO
drop CERTIFICATE CertificadoSenha
go

create CERTIFICATE CertificadoCartaoCredito
   ENCRYPTION BY PASSWORD = '1t@l1@1982'
   WITH SUBJECT = 'Compras com cartao de Credito'
GO

create CERTIFICATE CertificadoSenha
   ENCRYPTION BY PASSWORD = 'Br@s1l1970'
   WITH SUBJECT = 'Senhas'
GO


create SYMMETRIC KEY CartaoCredito_SK01 WITH ALGORITHM = AES_256
    ENCRYPTION BY CERTIFICATE CertificadoCartaoCredito;
GO

create SYMMETRIC KEY Senha_SK01 WITH ALGORITHM = AES_256
    ENCRYPTION BY CERTIFICATE CertificadoSenha;
GO

GRANT VIEW DEFINITION ON SYMMETRIC KEY::CartaoCredito_SK01 TO PsafeDbRole
GRANT VIEW DEFINITION ON SYMMETRIC KEY::Senha_SK01 TO PsafeDbRole
go

alter proc pr_dba_OpenCloseCreditCardKey @cmd char(10)
WITH EXECUTE AS OWNER, ENCRYPTION 
AS
begin
if @cmd = 'open'
begin
OPEN symmetric KEY CartaoCredito_SK01 DECRYPTION BY certificate CertificadoCartaoCredito
WITH PASSWORD = '1t@l1@1982'
return
end

if @cmd = 'close'
begin
CLOSE SYMMETRIC KEY CartaoCredito_SK01
return
end
else
select 'Erro na proc pr_dba_OpenCloseCreditCardKey: parâmetro inválido'
end -- proc
go



alter proc pr_dba_OpenClosePasswordKey @cmd char(10)
WITH EXECUTE AS OWNER, ENCRYPTION 
AS
begin
if @cmd = 'open'
begin
OPEN symmetric KEY Senha_SK01 DECRYPTION BY certificate CertificadoSenha
WITH PASSWORD = 'Br@s1l1970'
return
end

if @cmd = 'close'
begin
CLOSE SYMMETRIC KEY Senha_SK01
return
end
else
select 'Erro na proc pr_dba_OpenClosePasswordKey: parâmetro inválido'
end -- proc
go



create table teste (
t1 varchar(10) primary key,
encrypt varbinary (128) null)

insert teste select 1,null
insert teste select 2,null
insert teste select 3,null
insert teste select 4,null
insert teste select 5,null
insert teste select 6,null


OPEN symmetric KEY CartaoCredito_SK01 DECRYPTION BY certificate CertificadoCartaoCredito
WITH PASSWORD = '1t@l1@1982'

exec pr_dba_OpenCloseCreditCardKey 'open'

SELECT *,
     CONVERT(nvarchar, DecryptByKey(encrypt)) 
     FROM teste


update teste 
set encrypt = EncryptByKey(Key_GUID('CartaoCredito_SK01'), t1);


SELECT *,
     CONVERT(nvarchar, DecryptByKey(encrypt)) 
     FROM teste


--------------------------------------
-- TABELA CLIENTE
alter table Cliente add senhaCrypt varbinary (128) null

exec pr_dba_OpenClosePasswordKey 'open'

drop trigger Cliente_TG01

update cliente 
set senhaCrypt = EncryptByKey(Key_GUID('senha_SK01'), senha);

SELECT * from Cliente

select senha,
CONVERT(varchar, DecryptByKey(senhaCrypt)) 
FROM Cliente

exec pr_dba_OpenClosePasswordKey 'close'

-- Funcionou, agora cerol
alter table Cliente drop column senha
go
exec sp_rename 'cliente.senhacrypt',senha
