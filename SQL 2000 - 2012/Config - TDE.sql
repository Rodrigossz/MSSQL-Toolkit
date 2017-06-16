TOP SECRET

USE master;

BACKUP SERVICE MASTER KEY TO FILE ='b:\Dba\Backup\DBPRODGXC001\service_master_key' ENCRYPTION BY PASSWORD ='GX@ng02010Psaf32011';

use ClienteDb;

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

