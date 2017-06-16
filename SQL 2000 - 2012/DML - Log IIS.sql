alter proc sp_dba_cargaLogIIS
as
--create table LogTemp (unico varchar(8000))
truncate table LogTemp
BULK INSERT LogTemp
   FROM 'C:\W3SVC1\u_ex11030911.log'
   WITH 
      (
         FIELDTERMINATOR =' ',
         ROWTERMINATOR ='\r' --TEM Q SER /R
      )

delete LogTemp where substring (unico,2,1) <> '2' --Vai dar merda do ano 3000 em diante
update LogTemp set unico = replace(substring(unico,2,8000),' ',';')
--select * from LogTemp where unico like '2%'

EXEC xp_cmdshell 'bcp "select * from bitempDb..LogTemp" queryout "C:\DBA\bcpLogIIS.txt" -T -SPSDEVDB001\DBDEVGXC001 -c' ---t; -r\r"' 


BULK INSERT LogIIS
   FROM 'C:\DBA\bcpLogIIS.txt'
   WITH (FIELDTERMINATOR =';',ROWTERMINATOR ='\n') --TEM Q SER /n
   
select * from logiis
