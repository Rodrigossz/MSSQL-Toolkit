create table StatusEmail (
id tinyint identity(1,1) primary key,
nome tddesc not null)

insert StatusEmail select 'Adicionado';
insert StatusEmail select 'Confirmado';
insert StatusEmail select 'Primário'; 

create table ClienteEmail (
id int identity(1,1) primary key,
email tdEmail not null,
clienteId int not null references cliente,
statusEmailId tinyint default 1 not null references StatusEmail, --DEFAULT "Adicionado"
ativo bit default 1 not null, --DEFAULT ATIVO. Delete lógico.
dataAdicao smalldatetime default getdate() not null, --Data Status 1
dataPriorizacao smalldatetime  null, -- Data Status 2
dataInativacao smalldatetime  null, --Data Status 3
dataConfirmacao smalldatetime  null);  --Data em q confirmou pelo email

-- Com os campos ativo e DataInativacao, fazemos delete lógico e guardamos os dados da confirmação.

create unique index ClienteEmail_ID01 on ClienteEmail (email) include (clienteId);
-- Esse índice único impede email repetido
-- Basta a aplicacao tratar a mensagem de duplicate key

create unique index ClienteEmail_ID02 on ClienteEmail (clienteId,statusEmailId) include (email) 
where ativo = 1 and statusEmailId = 3;
-- Esse índice único impede dois emails primários ativos para um clienteID
-- Basta a aplicacao tratar a mensagem de duplicate key

create index ClienteEmail_ID03 on ClienteEmail (dataAdicao) include (clienteId) where ativo = 1;
go

create trigger ClienteEmail_TG01
on clienteEmail
after update
as
begin

-- TEM Q JA SER CONFIRMADO
if not exists (select 1 from deleted d 
join inserted i on d.clienteId = i.clienteId and d.email = i.email and d.statusEmailId = 2)
begin
rollback
raiserror ('Email precisa ser confirmado antes de se tornar primário.',16,1)
return
end -- IF

end -- TRIGGER
go

create trigger ClienteEmail_TG02
on clienteEmail
after insert
as
begin

-- NAO PODE
if  exists (select 1 from inserted i where statusEmailId = 2)
begin
rollback
raiserror ('Proibido email novo já primário.',16,1)
return
end -- IF

end -- TRIGGER
go

-- ATIVANDO HISTÓRICO AUTOMÁTICO - Change data captura - CDC
EXECUTE sys.sp_cdc_enable_table @source_schema = 'dbo', @source_name = 'ClienteEmail' , @role_name = null; 