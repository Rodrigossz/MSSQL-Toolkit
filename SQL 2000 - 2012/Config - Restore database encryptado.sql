use master
drop MASTER KEY ;
create MASTER KEY ENCRYPTION BY PASSWORD = 'M@rc0B3nRam@p0l05@ul0R0dr160C@rl0sD@n13l';

drop CERTIFICATE GxcTDECertificate;
create CERTIFICATE GxcTDECertificate
 FROM FILE = 'b:\dba\GxcTDECertificate.cer'
 WITH PRIVATE KEY (FILE = 'b:\dba\MinhaChavePrivadaServidorTDE.pvk',
 DECRYPTION BY PASSWORD = 'GxcC3rt1f1cat3GX@ng0@br2011');

 

exec xp_cmdshell 'dir b:\dba\backup\DBPRODGXC001\'




use ClienteDb;
--create user [GRUPOXANGO\IIS_DEV] from login [GRUPOXANGO\IIS_DEV];
create user [GRUPOXANGO\GP_DEV] from login [GRUPOXANGO\GP_DEV];
exec sp_addrolemember 'GxcDbRole','GRUPOXANGO\GP_DEV';
create role GxcDbRoleDev;
grant select to GxcDbRoleDev;
grant execute to GxcDbRoleDev;
grant VIEW DEFINITION  to GxcDbRoleDev;
exec sp_addrolemember 'GxcDbRoleDev','GRUPOXANGO\GP_DEV';

-- FIDELIDADE!!!
use FidelidadeDb;
--create user [GRUPOXANGO\IIS_DEV] from login [GRUPOXANGO\IIS_DEV];
create user [GRUPOXANGO\GP_DEV] from login [GRUPOXANGO\GP_DEV];
exec sp_addrolemember 'GxcDbRole','GRUPOXANGO\GP_DEV';
create role GxcDbRoleDev;
grant select to GxcDbRoleDev;
grant execute to GxcDbRoleDev;
grant VIEW DEFINITION  to GxcDbRoleDev;
exec sp_addrolemember 'GxcDbRoleDev','GRUPOXANGO\GP_DEV';

use CommonDb;
--create user [GRUPOXANGO\IIS_DEV] from login [GRUPOXANGO\IIS_DEV];
create user [GRUPOXANGO\GP_DEV] from login [GRUPOXANGO\GP_DEV];
exec sp_addrolemember 'GxcDbRole','GRUPOXANGO\GP_DEV';
create role GxcDbRoleDev;
grant select to GxcDbRoleDev;
grant execute to GxcDbRoleDev;
grant VIEW DEFINITION  to GxcDbRoleDev;
exec sp_addrolemember 'GxcDbRoleDev','GRUPOXANGO\GP_DEV';

use PsafeDb;
--create user [GRUPOXANGO\II_DEV] from login [GRUPOXANGO\IIS_DEV];
create user [GRUPOXANGO\GP_DEV] from login [GRUPOXANGO\GP_DEV];
exec sp_addrolemember 'OdsDbRole','GRUPOXANGO\GP_DEV';
create role OdsDbRoleDev;
grant select to OdsDbRoleDev;
grant execute to odsDbRoleDev;
grant VIEW DEFINITION  to odsDbRoleDev;
exec sp_addrolemember 'odsDbRoleDev','GRUPOXANGO\GP_DEV';
