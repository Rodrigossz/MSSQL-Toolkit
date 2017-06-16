CREATE proc pr_dba_OpenCloseCreditCardKey @cmd char(10)
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



CREATE proc pr_dba_OpenClosePasswordKey @cmd char(10)
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
