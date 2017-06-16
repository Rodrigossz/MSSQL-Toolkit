create role ODSDbRole;
grant execute to ODSDbRole;
create role ODSDbRoleDev;
grant select to ODSDbRoleDev;
grant execute to ODSDbRoleDev;
grant VIEW DEFINITION  to ODSDbRoleDev;


create user [GRUPOXANGO\IIS_DEV] from login [GRUPOXANGO\IIS_DEV]
create user [GRUPOXANGO\GP_DEV] from login [GRUPOXANGO\GP_DEV]


exec sp_addrolemember 'ODSDbRole','GRUPOXANGO\IIS_DEV'
exec sp_addrolemember 'ODSDbRoleDev','GRUPOXANGO\GP_DEV';


select @@SERVERNAME
 EXEC sp_addlinkedserver   
   @server=N'GXC', 
   @srvproduct=N'',
   @provider=N'SQLNCLI', 
   @datasrc=N'PSDEVDB001\DBDEVGXC001';
   
EXEC sp_addlinkedsrvlogin 'GXC', 'false', null, 'dba', 'Ech<99oL'

select COUNT(*) from gxc.clientedb.dbo.cliente

