use master 
go
create proc sp_dba_tb5
as
SELECT object_name(idx.object_id),idx.name,
p.partition_number AS [PartitionNumber],
prv.value AS [RightBoundaryValue],
CAST(p.rows AS float) AS [RowCount],
fg.name AS [FileGroupName],
CAST(pf.boundary_value_on_right AS int) AS [RangeType],
p.data_compression AS [DataCompression], idx.fill_factor,idx.type_desc,user_name(tbl.schema_id) as owner
FROM
sys.tables AS tbl
INNER JOIN sys.indexes AS idx ON idx.object_id = tbl.object_id 
INNER JOIN sys.partitions AS p ON p.object_id=CAST(tbl.object_id AS int) AND p.index_id=idx.index_id
INNER JOIN sys.indexes AS indx ON p.object_id = indx.object_id and p.index_id = indx.index_id
LEFT OUTER JOIN sys.destination_data_spaces AS dds ON dds.partition_scheme_id = indx.data_space_id and dds.destination_id = p.partition_number
LEFT OUTER JOIN sys.partition_schemes AS ps ON ps.data_space_id = indx.data_space_id
LEFT OUTER JOIN sys.partition_range_values AS prv ON prv.boundary_id = p.partition_number and prv.function_id = ps.function_id
LEFT OUTER JOIN sys.filegroups AS fg ON fg.data_space_id = dds.data_space_id or fg.data_space_id = indx.data_space_id
LEFT OUTER JOIN sys.partition_functions AS pf ON pf.function_id = prv.function_id
--WHERE tbl.NAME LIKE 'foo%'
order by CAST(p.rows AS float) desc
go
EXEC sp_ms_marksystemobject 'sp_dba_tb5'  
go
--select * from sys.indexes

