
alter proc pr_Cliente_del_cascade
@id int
as
begin
select 'TEM CERTEZA Q QUER DELETAR? APERTE STOP EM ATÉ 10 SEGUNDOS'
select * from Cliente where id = @id
waitfor delay '00:00:10'
delete endereco where clienteId = @id
delete OrigemContatoInfo where clienteId = @id
delete ClienteEmailAdicional where clienteId = @id
delete EnderecoFinanceiro where clienteId = @id
delete operacaoCliente where clienteId = @id
delete Cliente where id = @id
end
grant exec on pr_Cliente_del_cascade to GxcDbRoleDev
