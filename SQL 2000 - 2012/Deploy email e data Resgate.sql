USE [FidelidadeDb]
GO

ALTER view [dbo].[vwResgate] as
select lr.resgateId,l.clienteId,c.primeiroNome,c.nomeMeio,c.sobrenome,l.recompensaId,rec.nome as NomeRecompensa,r.enderecoId,
e.logradouro,e.complemento,e.cidade,e.pais,uf.sigla,e.cep, e.numero, e.destinatario, e.bairro, e.residencial, e.nome,
l.dataHora as dataHoraResgate, l.qtd, r.dataHoraPacote,r.dataHoraPostagem,r.codRastreio,c.email
from Resgate (nolock) r 
join LancamentoResgate (nolock) lr on r.id = lr.resgateId
join Lancamento (nolock) l on lr.lancamentoId = l.id 
join Clientedb.dbo.Cliente (nolock) c on l.clienteId = c.id
join ClienteDb.dbo.Endereco (nolock) e on r.enderecoId = e.id
join Recompensa rec (nolock) on l.recompensaId = rec.id
join clientedb.dbo.Uf (nolock) uf on e.ufid = uf.id
where
l.recompensaId is not null  -- Lancamento com id da recompensa é resgate 
GO


create proc pr_vwResgate_sel_Email_Data_Enviado
@email tdemail, @data smalldatetime, @enviado bit
--with execute as owner
ASSET NOCOUNT ONif @enviado = 1SELECT * FROM vwResgateWHERE email = isnull(@email,email) andconvert(date,dataHoraResgate) = isnull(@data,convert(date,dataHoraResgate)) andconvert(date,dataHoraResgate) = isnull(@data,convert(date,dataHoraResgate)) andcodRastreio is not nullelseSELECT * FROM vwResgateWHERE email = isnull(@email,email) andconvert(date,dataHoraResgate) = isnull(@data,convert(date,dataHoraResgate)) andconvert(date,dataHoraResgate) = isnull(@data,convert(date,dataHoraResgate)) andcodRastreio is nullSET NOCOUNT OFF
go