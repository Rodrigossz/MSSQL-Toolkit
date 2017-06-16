select * from SorteioIpad s1 where dataHoraPremiado is not null
and dataHoraPremiado = (select MAX(datahorapremiado) from SorteioIpad s2 
where 
DATEPART(mm,s2.dataHoraPremiado) = DATEPART(mm,s1.dataHoraPremiado) and
DATEPART(yyyy,s2.dataHoraPremiado) = DATEPART(yyyy,s1.dataHoraPremiado) )

order by 3