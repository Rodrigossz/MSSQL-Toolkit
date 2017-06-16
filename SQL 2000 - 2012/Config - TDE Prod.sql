USE master;

--drop MASTER KEY;

create MASTER KEY ENCRYPTION BY PASSWORD = 'M@rc0B3nRam@p0l05@ul0R0dr160C@rl0sD@n13l';
-- Explicando + ou - a senha: Marco Ben Ram Apolo Saulo Rodrigo Carlos Daniel

BACKUP MASTER KEY TO FILE = 'b:\dba\backup\master_key_DBPRODGXC001.bak'  ENCRYPTION BY PASSWORD ='GX@n60PS@f3@br2011';
-- Explicando + ou - a senha: GXango PSafe Abril 2011

create CERTIFICATE GxcTDECertificate WITH SUBJECT = 'TDE Certificate';

BACKUP CERTIFICATE GxcTDECertificate TO FILE = 'b:\dba\backup\GxcTDECertificate.cer'
WITH PRIVATE KEY ( FILE = 'b:\dba\backup\MinhaChavePrivadaServidorTDE.pvk',
ENCRYPTION  BY PASSWORD = 'GxcC3rt1f1cat3GX@ng0@br2011');
-- Explicando + ou - a senha: Gxc Certificate GXango Abril 2011


USE ClienteDb;

create DATABASE ENCRYPTION KEY
WITH ALGORITHM = AES_256
ENCRYPTION BY SERVER CERTIFICATE GxcTDECertificate;



ALTER DATABASE ClienteDb SET ENCRYPTION ON;
go

-- MONITORAMENTO

create proc sp_dba_monitorEncrypt
as
SELECT DB_NAME(e.database_id) AS DatabaseName, 
            e.database_id, 
            e.encryption_state, 
    CASE e.encryption_state 
                WHEN 0 THEN 'No database encryption key present, no encryption' 
                WHEN 1 THEN 'Unencrypted' 
                WHEN 2 THEN 'Encryption in progress' 
                WHEN 3 THEN 'Encrypted' 
                WHEN 4 THEN 'Key change in progress' 
                WHEN 5 THEN 'Decryption in progress' 
    END AS encryption_state_desc, 
            c.name, 
            e.percent_complete 
    FROM sys.dm_database_encryption_keys AS e 
    LEFT JOIN master.sys.certificates AS c 
    ON e.encryptor_thumbprint = c.thumbprint 