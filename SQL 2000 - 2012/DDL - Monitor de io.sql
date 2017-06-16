use DbaDb
go
-- create a table for snapshot sequence generation
CREATE TABLE io_snapshots
    (snap_id INT IDENTITY NOT NULL,
    snapshot_creation_date DATETIME NOT NULL )
GO
ALTER TABLE io_snapshots ADD CONSTRAINT PK_io_snapshots PRIMARY KEY (snap_id)
GO

-- create a table for the  io statistics
CREATE TABLE io_snapshots_statistics
    (snap_id INT NOT NULL,
    [db_id] smallint NOT NULL,
    [file_id] smallint NOT NULL,
    database_name SYSNAME,
    physical_file_name SYSNAME,
    Diff_Number_of_reads bigint,
    Diff_Bytes_Read bigint,
    Diff_Read_stall_time_ms bigint,
    Diff_Number_of_writes bigint,
    Diff_Bytes_written bigint,
    Diff_Write_stall_time_ms bigint,
    Diff_Read_Write_stall_ms bigint,
    size_on_disk_MB bigint)
GO
ALTER TABLE io_snapshots_statistics ADD CONSTRAINT PK_io_snapshots_statistics
    PRIMARY KEY (snap_id,[db_id], [file_id])
GO
ALTER TABLE io_snapshots_statistics ADD CONSTRAINT FK_io_snapshots_statistics_io_snapshots
    FOREIGN KEY (snap_id) REFERENCES io_snapshots (snap_id)
go
create PROC [dbo].[sp_dba_carga_io_snapshots]
AS
BEGIN
   SET NOCOUNT ON
   INSERT INTO io_snapshots ( snapshot_creation_date) SELECT GETDATE()
  
   INSERT INTO io_snapshots_statistics 
       (snap_id,
       [db_id],
       [file_id],
       database_name ,
       physical_file_name,
       Diff_Number_of_reads,
       Diff_Bytes_Read,
       Diff_Read_stall_time_ms,
       Diff_Number_of_writes,
       Diff_Bytes_written,
       Diff_Write_stall_time_ms,
       Diff_Read_Write_stall_ms,
       size_on_disk_MB)
   SELECT
       (SELECT MAX(snap_id) FROM io_snapshots),
       db_files.database_id,
       db_files.FILE_ID,
       DB_NAME(db_files.database_id) AS Database_Name,
       db_files.physical_name        AS File_actual_name,
       num_of_reads                  AS Number_of_reads,
       num_of_bytes_read             AS Bytes_Read,
       io_stall_read_ms              AS Read_time_stall_ms,
       num_of_writes                 AS Number_of_writes,
       num_of_bytes_written          AS Bytes_written,
       io_stall_write_ms             AS Write_time_stall_ms,
       io_stall                      AS Read_Write_stall_ms,
       size_on_disk_bytes / POWER(1024,2) AS size_on_disk_MB
   FROM 
       sys.dm_io_virtual_file_stats(NULL,NULL) dm_io_vf_stats ,
       sys.master_files db_files
   WHERE 
       db_files.database_id = dm_io_vf_stats.database_id
       AND db_files.[file_id] = dm_io_vf_stats.[file_id];

  SET NOCOUNT OFF

END
GO 
create proc sp_dba_lista_io_snapshots
as
begin
select top 20 * from io_snapshots order by snapshot_creation_date desc
end
go

create PROC [dbo].[sp_dba_compare_io_snapshots] 
      (@start_snap_ID INT = NULL,
       @end_snap_ID INT = NULL)
AS
DECLARE @end_snp INT
DECLARE @start_snp INT
BEGIN
   SET NOCOUNT ON
   
   IF (@end_snap_ID IS NULL) 
      SELECT @end_snp = MAX(snap_id) FROM io_snapshots
      ELSE SET @end_snp = @end_snap_ID

   IF (@start_snap_ID IS NULL) 
      SELECT @start_snp = @end_snp -1  
      ELSE SET @start_snp = @start_snap_ID

   
   SELECT 
       CONVERT(VARCHAR(12),S.snapshot_creation_date,101) AS snapshot_creation_date,
       A.database_name,
       A.physical_file_name,
       A.size_on_disk_MB,
       A.Diff_Number_of_reads - B.Diff_Number_of_reads   AS Diff_Number_of_reads,
       A.Diff_Bytes_read - B.Diff_Bytes_read             AS Diff_Bytes_read,
       A.Diff_Read_stall_time_ms -  B.Diff_Read_stall_time_ms AS Diff_Read_stall_time_ms,
       A.Diff_Number_of_writes - B.Diff_Number_of_writes AS Diff_Number_of_writes,
       A.Diff_Bytes_written - B.Diff_Bytes_written       AS Diff_Bytes_written,
       A.Diff_Write_stall_time_ms - B.Diff_Write_stall_time_ms AS Diff_Write_stall_time_ms,
       A.Diff_Read_Write_stall_ms - B.Diff_Read_Write_stall_ms AS Diff_Read_Write_stall_ms ,
       DATEDIFF (hh,S1.snapshot_creation_date, S.snapshot_creation_date) AS Diff_time_hours     
   FROM 
       io_snapshots S ,  
       io_snapshots S1,
       io_snapshots_statistics A ,  
       io_snapshots_statistics B                     
   WHERE 
       S.snap_id = @end_snp AND 
       S.snap_id = A.snap_id AND 
       B.snap_id = @start_snp AND 
       A.[db_id] = B.[db_id] AND 
       A.[file_id] = B.[file_id] AND
       S1.snap_id = @start_snp AND
       S1.snap_id = B.snap_id  
   ORDER BY 
       A.database_name,
       A.physical_file_name       

  SET NOCOUNT OFF
END
GO 
