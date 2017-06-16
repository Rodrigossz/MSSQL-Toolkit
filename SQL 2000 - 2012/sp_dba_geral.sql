use master
go
if exists (select 1 from sysobjects where name = 'sp_dba_su')
drop proc sp_dba_su
go
CREATE proc sp_dba_su
as
set nocount on

declare @login varchar(40)
select @login = convert(varchar(40),user_name())

select 'Vc está no database: ',convert(char(40),db_name())
select 'Vc está como: ',@login

if @login <> 'dbo'
begin
setuser
select 'setuser para: sa'
return
end

ELSE 
begin
select top 1  @login = substring (user_name(uid),1,30) from sysobjects where type = 'P' group by substring (user_name(uid),1,30) order by count(*) desc
if @login is not null 
begin
setuser @login
select 'setuser para: ',@login
return
end
end

if @login is null -- Desistência
begin
select 'login não achado'
exec sp_helpuser
return
end
go

grant exec on sp_dba_su to public
go

/*
-- select distinct ''''+type+''',' from ba_corporativo..sysobjects
declare @parm1 varchar(100) , @ini int, @fim int
select @parm1 = 'RetornoCobrancaDetalhe,DataMovimento'
select substring(@parm1,1,charindex(',',@parm1,1)-1)

--select substring(@parm1,charindex(',',@parm1,1)+1,charindex(',',@parm1,charindex(',',@parm1,1)+1)-charindex(',',@parm1,1)-1)
--select substring(@parm1,charindex(',',@parm1,charindex(',',@parm1,1)+1)+1,3)
*/
use master
go
if exists (select 1 from sysobjects where type = 'P' and name = 'sp_dba_geral')
drop proc sp_dba_geral
go

create proc sp_dba_geral @parm1 varchar(100) =null, @parm2 varchar(100) =null, @parm3 varchar(2) =null
with ENCRYPTION 
as
begin
set nocount on

select Servidor= substring(@@servername,1,15), Data_Hora =convert(char(20),getdate())+' ', BA=substring(db_name(),1,40), Login=substring(user_name(),1,20)

-- Sem parâmetro é pra rodar setuser...
if @parm1 is null --and @parm2 is null and @parm3 is null
begin
exec sp_dba_su
return
end

if @parm1 = 'proc'
begin
exec sp_dba_proc
return
end

if @parm1 = 'proc2'
begin
exec sp_dba_proc2
return
end

if @parm1 = 'proc3'
begin
exec sp_dba_proc3
return
end

if @parm1 = 'dep'
begin
exec sp_MSdependencies @parm2
return
end

if @parm1 = 'kill'
begin
exec sp_dba_kill @parm2
return
end


if (@parm1 like '%,%,%' )  -- O FDP do managemento Studio não entendeu que são 3 parâmetros 
begin
select @parm2=substring(@parm1,charindex(',',@parm1,1)+1,charindex(',',@parm1,charindex(',',@parm1,1)+1)-charindex(',',@parm1,1)-1)
select @parm3=substring(@parm1,charindex(',',@parm1,charindex(',',@parm1,1)+1)+1,3) --Arbitrei 3, basta qq coisa pq o teste é null ou não.
select @parm1=substring(@parm1,1,charindex(',',@parm1,1)-1)
end
if (@parm1 like '%,%' )  -- O FDP do managemento Studio não entendeu que são 2 parâmetros 
begin
select @parm2=substring(@parm1,charindex(',',@parm1,1)+1,100)
select @parm1=substring(@parm1,1,charindex(',',@parm1,1)-1)
end


-- Pesquisa na sysobjects
if @parm1 in ('S','V','P','D','FN','K','R','C','F','TF') 
begin
select Nome=substring(name,1,50), Tipo=type, Dono=substring(user_name(uid),1,20), Data=crdate from sysobjects 
where type = @parm1 and name not like 'dt_%' order by 1
return
end
if @parm1 ='U'
begin
select Nome=substring(o.name,1,50), Tipo=o.type, Dono=substring(user_name(o.uid),1,20), Linhas=rows, Data=o.crdate from sysobjects o, sysindexes i
where o.type = @parm1 and o.id = i.id and i.indid in (0,1) order by 1
return
end


-- NumerocorrespBanc ou localid
if (isnumeric (@parm1) = 1) 
begin
if (select count(*) from ba_corporativo..local l (nolock) where numerocorrespbancario = @parm1) = 1
begin
select 'É numeroCorrespBanc'
select * from ba_corporativo..local l (nolock) where numerocorrespbancario = @parm1
return
end
if (select count(*) from ba_corporativo..local l (nolock) where localid = @parm1) = 1
begin
select 'É localid'
select * from ba_corporativo..local l (nolock) where numerocorrespbancario = @parm1
return
end
Else
begin
select 'Não é localid nem numeroCorrespBanc'
return
end
end

-- É um objeto?
if (@parm1 is not null) and (@parm2 is null)
begin
if (@parm1 in (select name from master..sysdatabases where name = @parm1)) --É um BA
exec sp_helpdb @parm1

if (select count(*) from sysobjects where name = @parm1) = 0
begin
select 'Objeto não encontrado nesse BA:', db_name()
return
end

if (select count(*) from sysobjects where name = @parm1) > 1
begin
select 'ATENCAO!!!!!!!!! Mais de um objeto com esse nome encontrado no BA:', db_name()
select 'ATENCAO!!!!!!!!! Vou mostar o objeto do login:', user_name()

if exists (select 1 from sysobjects where name = @parm1 and type = 'U') --É tabela 
exec sp_help @parm1 
else
exec sp_helptext  @parm1 
end
else
if exists (select 1 from sysobjects where name = @parm1 and type = 'U') --É tabela 
exec sp_help @parm1 
else
begin
exec sp_dba_su
exec sp_helptext @parm1
exec sp_dba_su
end

end

-- Para ajudar
declare @cmd varchar(1000), @linhas varchar(20)

-- Max e Min
if (@parm1 is not null) and (@parm2 is not null) and (@parm3 is null)
begin
if ((select type from sysobjects where name = @parm1) not in ('U','V')) and
(@parm1 not like 'sys%')
begin 
select 'Não é tabela ou view'
return --Não tem como pegar max/min/count
end
select @linhas=convert(varchar(20),rows) from sysindexes where object_name(id)=@parm1 and indid in (0,1)
select 'Max_Min da tabela: '+ substring(@parm1,1,40)+' - '+@linhas+' linhas', 'Campo: '+substring(@parm2,1,50)
select @cmd='select Min=min('+@parm2+'),''           '', Max=max('+@parm2+') from '+@parm1+' (nolock)'
execute (@cmd)
end

-- Group
if (@parm1 is not null) and (@parm2 is not null) and (@parm3 is not null)
begin
if ((select type from sysobjects where name = @parm1) not in ('U','V')) and
(@parm1 not like 'sys%')
begin 
select 'Não é tabela ou view'
return --Não tem como pegar max/min/count
end
select @linhas=convert(varchar(20),rows) from sysindexes where object_name(id)=@parm1 and indid in (0,1)
select 'Group da tabela: '+ substring(@parm1,1,40)+' - '+@linhas+' linhas', 'Campo: '+substring(@parm2,1,50)
select @cmd='select '+@parm2+',Qtd=count(*) from '+@parm1+' (nolock) group by '+@parm2+' order by 1'
execute (@cmd)
end

end
go

grant exec on sp_dba_geral to public
go

/*
exec sp_dba_geral 'sysobjects','crdate'
exec sp_dba_geral 'sysobjects','type','a'

exec sp_dba_geral 'cadastro','cadid'
select min(cadid), max(cadid) from cadastro
declare @cmd varchar(1000)
select @cmd='select min(cadid), max(cadid) from cadastro'
execute (@cmd)

use ba_corporativo
go
exec sp_dba_geral 'p'
exec sp_dba_geral 'ba_corporativo'
exec sp_dba_geral 'cadastro','cadid'
exec sp_dba_geral 'pr_Acesso_sel2'
go
use master
go
*/

