exec pr_Relat_Indicacoes

select i.clienteId, i.dataHora as dataHoraIndicacao, a.dataHora as dataHoraAssinatura
 from Indicacao i 
 join Assinatura a on i.clienteId = a.clienteId
 --join Instalacao i2 on 
 where i.dataHora >= getdate()


update Indicacao
set dataHora = a.dataHora 
 from Indicacao i 
 join Assinatura a on i.clienteId = a.clienteId
 --join Instalacao i2 on 
 where i.dataHora >= getdate()