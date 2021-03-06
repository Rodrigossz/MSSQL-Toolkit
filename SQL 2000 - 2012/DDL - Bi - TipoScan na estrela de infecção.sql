select * 
into TipoScan
from PSafeDb..TipoScan

set identity_insert.tiposcan on
insert TipoScan (id,nome,ativo) select 0,'Scan com Vírus - Legado',0
set identity_insert.tiposcan off

alter table tipoScan add constraint tipoScan_PK primary key (id)

alter table infeccao add tipoScanId tinyint null references TipoScan

select * from TipoScan

update Infeccao
set tiposcanid = 0
from Infeccao i
join Virus v on i.virusId = v.id and v.md5 is null

declare @dataId int
select @dataId = MIN(dataid) from Infeccao i join Virus v on i.virusId = v.id and v.md5 is not null
select * from Data where id = @dataId


exec sp_dba_carga_Infeccao '20110602'
exec sp_dba_carga_Infeccao '20110603'
exec sp_dba_carga_Infeccao '20110604'
exec sp_dba_carga_Infeccao '20110605'
exec sp_dba_carga_Infeccao '20110606'

declare @dataId int
select @dataId = Max(dataid) from Infeccao i join Virus v on i.virusId = v.id and v.md5 is  null
select * from Data where id = @dataId

select top 10 * from PSafeDb..AcessoLog order by 1 desc