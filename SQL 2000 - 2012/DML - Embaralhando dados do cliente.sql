--LIMPEZA pós restore

update Cliente set email = CONVERT(varchar(10),id)+SUBSTRING(email,CHARINDEX('@',email,1),240)

update Cliente set primeiroNome = CONVERT(varchar(10),id) where primeiroNome is not null and primeiroNome <> ' ' and primeiroNome <>''
update Cliente set nomeMeio = CONVERT(varchar(10),id) where nomeMeio is not null and nomeMeio <> ' ' and nomeMeio <>''
update Cliente set sobrenome = CONVERT(varchar(10),id) where sobrenome is not null and sobrenome <> ' ' and sobrenome <>''

select * from Endereco

