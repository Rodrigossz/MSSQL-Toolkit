/*
--select id,origem into ClienteTem from Cliente where origem is not null
sp_help origemcadastroinfo

EXECUTE pr_OrigemCOntato_ups @id = 0, @nome = 'Google'
EXECUTE pr_OrigemCOntato_ups @id = 0, @nome = 'Boo-box'
EXECUTE pr_OrigemCOntato_ups @id = 0, @nome = 'Highmedia'
EXECUTE pr_OrigemCOntato_ups @id = 0, @nome = 'E-mail'
EXECUTE pr_OrigemCOntato_ups @id = 0, @nome = 'Link pessoal'
EXECUTE pr_OrigemCOntato_ups @id = 0, @nome = 'Facebook Fanpage'
EXECUTE pr_OrigemCOntato_ups @id = 0, @nome = 'Escudo Facebook'

EXECUTE pr_OrigemContato_ups @id = 3, @sigla = 'orkut'
EXECUTE pr_OrigemContato_ups @id = 4, @sigla = 'twitter'
EXECUTE pr_OrigemContato_ups @id = 5, @sigla = 'facebook'
EXECUTE pr_OrigemContato_ups @id = 6, @sigla = 'google'
EXECUTE pr_OrigemContato_ups @id = 7, @sigla = 'bb'
EXECUTE pr_OrigemContato_ups @id = 8, @sigla = 'hm'
EXECUTE pr_OrigemContato_ups @id = 9, @sigla = 'email'
EXECUTE pr_OrigemContato_ups @id = 10, @sigla = 'personal'
EXECUTE pr_OrigemContato_ups @id = 11, @sigla = 'fbfanpage'
EXECUTE pr_OrigemContato_ups @id = 12, @sigla = 'fbescudo'

*/
alter PROC dbo.pr_Cliente_ups	@id int = null,	@primeiroNome varchar(1000) = null,	@nomeMeio varchar(1000) = null,	@sobrenome varchar(1000) = null,	@sexo char(1) = null,	@dataNascimento date = null,	@email varchar(256) = null,	@dataCadastro smalldatetime = null,	@ativo bit = null,	@avancado bit = null,	@pj bit = null,	@clienteMasterId int = null,	@saldoFidelidade int = null,	@senha varchar(100) = null,	@saldoEscudo int = null,	@dataHoraPontosCadastroCompleto smalldatetime = nullWITH EXECUTE AS OWNERASSET NOCOUNT ONIF @id = 0 BEGIN	INSERT INTO Cliente (		primeiroNome,		nomeMeio,		sobrenome,		sexo,		dataNascimento,		email,		dataCadastro,		ativo,		avancado,		pj,		clienteMasterId,		saldoFidelidade,		senha,		saldoEscudo,		dataHoraPontosCadastroCompleto	)	VALUES (		@primeiroNome,		@nomeMeio,		@sobrenome,		@sexo,		@dataNascimento,		@email,		@dataCadastro,		@ativo,		@avancado,		@pj,		@clienteMasterId,		@saldoFidelidade,		@senha,		@saldoEscudo,		@dataHoraPontosCadastroCompleto	)	SELECT SCOPE_IDENTITY() As InsertedIDENDELSE BEGIN	UPDATE Cliente SET 		primeiroNome = isnull(@primeiroNome,primeiroNome),		nomeMeio = isnull(@nomeMeio,nomeMeio),		sobrenome = isnull(@sobrenome,sobrenome),		sexo = isnull(@sexo,sexo),		dataNascimento = isnull(@dataNascimento,dataNascimento),		email = isnull(@email,email),		dataCadastro = isnull(@dataCadastro,dataCadastro),		ativo = isnull(@ativo,ativo),		avancado = isnull(@avancado,avancado),		pj = isnull(@pj,pj),		clienteMasterId = isnull(@clienteMasterId,clienteMasterId),		saldoFidelidade = isnull(@saldoFidelidade,saldoFidelidade),		senha = isnull(@senha,senha),		saldoEscudo = isnull(@saldoEscudo,saldoEscudo),		dataHoraPontosCadastroCompleto = isnull(@dataHoraPontosCadastroCompleto,dataHoraPontosCadastroCompleto)	WHERE id = @idENDSET NOCOUNT OFF
go

--drop table clienteTemp;
select id,origem,dataCadastro as dataHora into ClienteTemp from Cliente where origem is not null;

alter table cliente drop column origem
go

alter table ClienteTemp add origemContatoId smallint;
create clustered index id01 on clientetemp (id);
create  index id02 on clientetemp (origemContatoId);
create  index id03 on clientetemp (origem);

alter table ClienteTemp add caminho	smallint;
alter table ClienteTemp add referencia	smallint;
alter table ClienteTemp add parceiro	smallint;
alter table ClienteTemp add tipo	tdEmail;
alter table ClienteTemp add palavraChave	tdDesc;


select * from origemcontato
select * from clientetemp where origemContatoId is null
select * from clientetemp where origem like 'google%7C%'
select * from clientetemp where tipo is not null

update clientetemp set origemContatoId = 6 where origem like '%google%'  and origemContatoId is null
update clientetemp set origemContatoId = 10 where origem like '%personal%'   and origemContatoId is null
update clientetemp set origemContatoId = 9 where origem like '%email%'   and origemContatoId is null
update clientetemp set origemContatoId = 3 where origem like '%orkut%'   and origemContatoId is null
update clientetemp set origemContatoId = 12 where origem like '%fbescudo%'   and origemContatoId is null
update clientetemp set origemContatoId = 7 where origem like '%bb%'   and origemContatoId is null

update clientetemp set caminho =  substring(origem,
charindex('path%3D',origem,0)+7 ,
charindex('%7Crf',origem,0) - (charindex('path%3D',origem,0)+7 ))
where   origem like 'google%7C%'

update clientetemp set referencia =  substring(origem,
charindex('rf%3D',origem,0)+5 ,
charindex('%7Cpartner',origem,0) - (charindex('rf%3D',origem,0)+5 ))
where   origem like 'google%7C%'

update clientetemp set parceiro =  1 where origem like 'google%7C%'

update clientetemp set tipo =  substring(origem,
charindex('type%3D',origem,0)+7 ,
charindex('%7Ckw',origem,0) - (charindex('type%3D',origem,0)+7 ))
where    origem like 'google%7C%'

update clientetemp set palavrachave =  substring(origem,
charindex('kw%3D',origem,0)+5 ,
LEN(origem)+1 - (charindex('kw%3D',origem,0)+5 ))
where origem like 'google%7C%'

update clientetemp set palavrachave =  replace(palavrachave,'%20',' ')
where origem like 'google%7C%'

update clientetemp set palavrachave =  'antivírus'
where palavrachave like 'antiv%C3%ADrus'

update clientetemp set palavrachave =  replace(palavrachave,'%C3%AD','í')
update clientetemp set palavrachave =  replace(palavrachave,'%C3%A1','á')

UPDATE Clientetemp set
Tipo = 'DISPLAY' ,parceiro = 1,referencia = 4,caminho = 10
where
id in (28707,28794,29492,19138,19166,19187,19211)

UPDATE Clientetemp set
Tipo = 'DISPLAY' ,parceiro = 1,referencia = 7,caminho = 12
where
id in (30272)

UPDATE Clientetemp set
Tipo = 'DISPLAY' ,parceiro = 1,referencia = 6,caminho = 11
where
id in (30432)

UPDATE Clientetemp set
Tipo = 'SEM' ,parceiro = 1,referencia = 1,caminho = 1,palavrachave = 'deixar computador mais rápido'
where
id in (19839)


UPDATE Clientetemp set
Tipo = 'SEM' ,parceiro = 1,referencia = 2,caminho = 11,palavrachave = 'vírus'
where
id in (20315)

UPDATE Clientetemp set
Tipo = 'SEM' ,parceiro = 1,referencia = 3,caminho = 9,palavrachave = 'melhor anti vírus grátis'
where
id in (21239)

UPDATE Clientetemp set
Tipo = 'SEM' ,parceiro = 1,referencia = 1,caminho = 2,palavrachave = 'remover trojan'
where
id in (21575)

UPDATE Clientetemp set
Tipo = 'SEM' ,parceiro = 1,referencia = 2,caminho = 11,palavrachave = 'vírus'
where
id in (21683)


select * from clientetemp where origem not like 'google%7C%' and origem not like 'Google+path%' and
origem not like 'personal' and origem not like 'orkut' and origem not like 'email' and origem not like 'fbescudo'
and origem not like 'BB+path' and origem not like 'google|path' and origem not like 'bb|path'


insert origemcadastroinfo
select id,datahora,origemContatoId,
caminho,
referencia,
parceiro,
tipo,
palavraChave
from clientetemp

select * from origemcadastroinfo
