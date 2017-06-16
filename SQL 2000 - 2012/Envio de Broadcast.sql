use psafedb
go
declare @dataSorteio date,  @faltam varchar(2),@msg varchar(300)
select @dataSorteio = CONVERT(char(6),getdate(),112)+'25'
select @faltam = DATEDIFF (dd, getdate(),@dataSorteio)
select @msg = 'Parabéns Sr. Marcos Antonio Barto, de Mato Grosso, vencedor do segundo iPad sorteado pelo PSafe Heróis da Rede em 25/07/2011!!'
--select @msg

declare @cli table (id int primary key)
insert @cli select id from gxc.clientedb.dbo.cliente

declare @min int, @max int
select @min = MIN(id) , @max = MAX(ID) from @cli

declare @notificacaoId int
declare @url varchar(1000) , @datahora smalldatetime
select @datahora = getdate()


while @min <= @max
begin

exec pr_Notificacao_ups      
      @id =0 ,
      @tipoNotificacaoId = 7 ,
      @clienteId = @min ,
      @criticidade = 1  ,
@mensagem = @msg,     
@url = '' ,
      @enviada = 0,
      @lida =0,
      @dataHora = @datahora
      
select @notificacaoId = @@IDENTITY
select @url ='code=tab2|tela_explicativa|tab1|primeira_pag_scan&notificacao='+convert(varchar(10),@notificacaoId) 

--select @url
exec pr_Notificacao_ups      
    @id =@notificacaoId ,
     @url = @url
      
select @min = MIN(id)  from @cli where id > @min
end
