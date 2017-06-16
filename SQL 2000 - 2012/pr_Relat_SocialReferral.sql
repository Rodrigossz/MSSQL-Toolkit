USE [Clientedb]
GO



/****** Object:  StoredProcedure [dbo].[pr_Relat_Instalacoes]    Script Date: 04/07/2011 18:46:19 ******/
--indicacao
create proc [dbo].[pr_Relat_SocialReferralBcp]
@dtIni date = null, @dtFim date = null,@tipoCons char(1) = null
--with execute as owner
as
begin
set nocount on

-- Estou ignorando o @tipoCons

-- Se NULL, ultimos 3 dias
if @dtIni is null 
select @dtIni = DATEADD(dd,-5,GETDATE()),@dtFim = dateadd(dd,1,GETDATE())

declare @cli table (id int primary key, data date)
insert @cli select ID,convert(date,datacadastro) from Cliente where dataCadastro between @dtIni and @dtFim

declare @tab table (Data date,tipo varchar(30),qtd int default 0)

insert @tab
select Data ,'Registrants',isnull( count(*),0)  
from @cli c  
group by Data

insert @tab
select CONVERT(date,dataHora) ,'InvitedFriends',isnull( count(distinct c.clienteid),0)  
from ODS.Psafedb.dbo.Indicacao c (nolock) 
join @cli a on a.id = c.clienteid
where dataHora between @dtIni and @dtFim 
group by CONVERT(date,dataHora)

insert @tab
select CONVERT(date,dataHora) ,'TotalInvites',isnull( count(*),0)  
from ODS.Psafedb.dbo.Indicacao c (nolock) 
join @cli a on a.id = c.clienteid
where dataHora between @dtIni and @dtFim 
group by CONVERT(date,dataHora)

insert @tab
select CONVERT(date,dataHora) ,'TotalConversions',isnull( count(*),0)  
from ODS.Psafedb.dbo.Indicacao c (nolock) 
join @cli a on a.id = c.clienteid
where dataHora between @dtIni and @dtFim and assinaturaIndicadoId is not null
group by CONVERT(date,dataHora)

--select * from OrigemContato
insert @tab
select Data ,'Facebook',isnull( count(*),0)  
from OrigemContatoInfo c (nolock) 
join @cli a on a.id = c.clienteid
where origemContatoId = 5 --facebook
group by Data
/*
insert @tab
select Data ,'Orkut',isnull( count(*),0)  
from OrigemContatoInfo c (nolock) 
join @cli a on a.id = c.clienteid
where origemContatoId = 3 --orkut
group by Data

insert @tab
select Data ,'Twitter',isnull( count(*),0)  
from OrigemContatoInfo c (nolock) 
join @cli a on a.id = c.clienteid
where origemContatoId = 4 --Twitter
group by Data
*/

declare @result table ([Date] char(15),Registrants int,InvitedFriends int,TotalInvites int,
TotalConversions int,Facebook int)--,Orkut int,Twitter int)

insert @result
select Data, 
isnull([Registrants], 0) ,
isnull([InvitedFriends],0) ,
isnull([TotalInvites],0) ,
isnull([TotalConversions],0) ,
isnull([Facebook],0) -- ,isnull([Orkut],0) ,isnull([Twitter],0) 
from
(select data,tipo,qtd from @tab) tab
pivot (sum(qtd) for tipo in ([Registrants],[InvitedFriends],[TotalInvites],[TotalConversions],
[Facebook]))  tabpivot
--,[Orkut],[Twitter]))  tabpivot
order by 1


select 
CONVERT(char(15),'Date') as 'Date',
CONVERT(char(15),'Registrants') as 'Registrants',
CONVERT(char(15),'InvitedFriends') as 'InvitedFriends',
CONVERT(char(15),'TotalInvites') as 'TotalInvites',
CONVERT(char(15),'TotalConversions') as 'TotalConversions',
CONVERT(char(15),'Facebook') as 'Facebook' union all
select
CONVERT(char(15),[Date]) ,
CONVERT(char(15),Registrants) ,
CONVERT(char(15),InvitedFriends) ,
CONVERT(char(15),TotalInvites) ,
CONVERT(char(15),TotalConversions),
CONVERT(char(15),Facebook) 
from @result

end --proc

go
exec pr_Relat_SocialReferralBcp '20110507','20110510','d'


--select * from OrigemContato
--select * from OrigemContatoInfo where origemContatoId = 1


