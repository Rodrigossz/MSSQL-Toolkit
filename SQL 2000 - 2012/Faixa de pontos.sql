/*
select * from sys.sysprocesses where blocked <> 0
exec sp_who2 active
exec sp_helpdb
exec xp_fixeddrives
exec sp_dba_job


*/


select case
when saldoEscudo IS null then '0'
when saldoEscudo <= 10000 then '1 - 10K'
when saldoEscudo > 10000 and saldoEscudo <= 20000 then '10 - 20K'
when saldoEscudo > 20000 and saldoEscudo <= 30000 then '20 - 30K'
when saldoEscudo > 30000 and saldoEscudo <= 40000 then '30 - 40K'
when saldoEscudo > 40000 and saldoEscudo <= 50000 then '40 - 50K'
when saldoEscudo > 50000 and saldoEscudo <= 60000 then '50 - 60K'
when saldoEscudo > 60000 and saldoEscudo <= 70000 then '60 - 70K'
when saldoEscudo > 70000 and saldoEscudo <= 80000 then '70 - 80K'
when saldoEscudo > 80000 and saldoEscudo <= 90000 then '80 - 90K'
when saldoEscudo > 90000 and saldoEscudo <= 100000 then '90 - 100K'
when saldoEscudo > 100000 and saldoEscudo <= 110000 then '100 - 110K'
when saldoEscudo > 110000 and saldoEscudo <= 120000 then '110 - 120K'
when saldoEscudo > 120000 and saldoEscudo <= 130000 then '120 - 130K'
when saldoEscudo > 130000 and saldoEscudo <= 140000 then '130 - 140K'
when saldoEscudo > 140000 and saldoEscudo <= 150000 then '140 - 150K'
when saldoEscudo > 150000 then '> 150K'
END AS FaixaPontos, COUNT(*) as TotalCustomers
from ClienteDb..Cliente --where saldoEscudo IS not null
group by  case
when saldoEscudo IS null then '0'
when saldoEscudo <= 10000 then '1 - 10K'
when saldoEscudo > 10000 and saldoEscudo <= 20000 then '10 - 20K'
when saldoEscudo > 20000 and saldoEscudo <= 30000 then '20 - 30K'
when saldoEscudo > 30000 and saldoEscudo <= 40000 then '30 - 40K'
when saldoEscudo > 40000 and saldoEscudo <= 50000 then '40 - 50K'
when saldoEscudo > 50000 and saldoEscudo <= 60000 then '50 - 60K'
when saldoEscudo > 60000 and saldoEscudo <= 70000 then '60 - 70K'
when saldoEscudo > 70000 and saldoEscudo <= 80000 then '70 - 80K'
when saldoEscudo > 80000 and saldoEscudo <= 90000 then '80 - 90K'
when saldoEscudo > 90000 and saldoEscudo <= 100000 then '90 - 100K'
when saldoEscudo > 100000 and saldoEscudo <= 110000 then '100 - 110K'
when saldoEscudo > 110000 and saldoEscudo <= 120000 then '110 - 120K'
when saldoEscudo > 120000 and saldoEscudo <= 130000 then '120 - 130K'
when saldoEscudo > 130000 and saldoEscudo <= 140000 then '130 - 140K'
when saldoEscudo > 140000 and saldoEscudo <= 150000 then '140 - 150K'
when saldoEscudo > 150000 then '> 150K'
END 
order by 2 desc