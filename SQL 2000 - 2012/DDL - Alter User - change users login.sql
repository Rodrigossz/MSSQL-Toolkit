ALTER USER [DOMAIN\original_user] WITH LOGIN = [NEW_DOMAIN\new_user]
go


SELECT * FROM sys.database_principals WHERE name = 'NEW_DOMAIN\new_user'
go
 

create procedure sp_dba_OrphanUser
as
ALTER USER [PSAFE\IIS_PROD] WITH LOGIN = [PSAFE\IIS_PROD]
go

