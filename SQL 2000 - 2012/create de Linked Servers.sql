
exec sp_linkedservers
exec sp_dropserver        'BD_EXP01', 'droplogins' 
exec sp_addlinkedserver   'BD_EXP01',  'SQL SERVER'
exec sp_serveroption      'BD_EXP01', 'rpc out', 'true'
exec sp_addlinkedsrvlogin 'BD_EXP01', 'false', null, 'linkedserver', 'kiss'
select name from BD_EXP01.master.dbo.sysdatabases

