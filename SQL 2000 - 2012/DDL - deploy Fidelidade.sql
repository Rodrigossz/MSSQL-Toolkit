use FidelidadeDb
go
create table TipoRecompensa (
id tinyint identity(1,1) primary key,
nome tddesc not null)
go
insert TipoRecompensa select 'Premio'
insert TipoRecompensa select 'Cupon'
go

alter table Recompensa add tipoRecompensaId tinyint null
go
update Recompensa set tipoRecompensaId = 1
go
alter table Recompensa alter column tipoRecompensaId tinyint not null
go
alter table Recompensa add url tddesc null
go

alter table Recompensa add ordenacao smallint default 0  not null 
go

update Recompensa set ordenacao = 4 where tipoRecompensaId = 1
--update Recompensa set ordenacao = 1 where id = 2159
--update Recompensa set ordenacao = 3 where id = 2197
--update Recompensa set ordenacao = 2 where id = 2198

select * from Recompensa

--drop index Recompensa.Recompensa_ID01
--drop index Recompensa.Recompensa_ID02

create index Recompensa_ID01 on Recompensa (tipoRecompensaId) include (ordenacao,nome) where ativo = 1
create index Recompensa_ID02 on Recompensa (nome) include (ordenacao,tipoRecompensaId) where ativo = 1
go
create table Item (
id int identity(1,1) primary key,
codigo tdsmalldesc not null,
ativo bit not null,
dataHoraUtilizacao smalldatetime null,
recompensaId smallint not null references recompensa)
go
create index Item_ID01 on item (codigo) 
go
create index Item_ID02 on item (dataHoraUtilizacao) 
go
create index Item_ID03 on item (recompensaId)  include (dataHoraUtilizacao)
go
alter table Lancamento drop constraint FK__Lancament__recom__440B1D61
go
alter table Lancamento drop constraint Lancamento_CK01
go
drop index Lancamento.Lancamento_ID01
go
EXEC sys.sp_cdc_enable_db
exec sys.sp_cdc_disable_table @source_schema = 'dbo', @source_name = 'lancamento', @capture_instance = 'all'
exec sp_rename 'Lancamento.recompensaId',itemId
EXECUTE sys.sp_cdc_enable_table @source_schema = 'dbo', @source_name = 'Lancamento' , @role_name = null; 
alter table lancamento alter column itemId int null

create index Lancamento_ID01 on Lancamento (itemId)
go

set identity_insert.item on
insert item (id,codigo,ativo,dataHoraUtilizacao,recompensaId)
select distinct itemid, convert(varchar(100),itemid),1,min(datahora),itemid
from Lancamento where itemid is not null
group by itemid, convert(varchar(100),itemid),itemid
set identity_insert.item off

alter table Lancamento add constraint FK__Lancament__recom__440B1D61
foreign key (itemId) references Item
go

alter table Lancamento add constraint Lancamento_CK01
check (itemId IS NOT NULL OR creditoId IS NOT NULL)
go

------------------------------------------------------------------------

declare @qtd int, @min int, @max int
select @min = MIN(id) ,@max = MAX(id) from Recompensa

while @min <= @max
begin
select @qtd = qtdEstoque from Recompensa where id = @min

while @qtd > 0
begin
insert Item (codigo,ativo,dataHoraUtilizacao,recompensaId) select CONVERT(varchar(100),@min),1,null,@min
select @qtd = @qtd -1
end

select @min = @min+1
end

go


CREATE PROC [dbo].[pr_Item_sel_recompensaId]	@recompensaId intWITH EXECUTE AS OWNERASSET NOCOUNT ONSELECT * FROM Item (nolock) WHERE recompensaid = @recompensaIdSET NOCOUNT OFF
GO
USE [FidelidadeDb]
GO

/****** Object:  Trigger [dbo].[Lancamento_TG01]    Script Date: 07/12/2011 18:22:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER trigger [dbo].[Lancamento_TG01] on [dbo].[Lancamento]
for insert,update
as
begin
-- Se tem recompensaId, eh resgate.
if exists (select 1 from inserted where itemid is not null)

--So atualiza
update Recompensa
set qtdEstoque = qtdEstoque - qtd
from inserted i
join item i1 on i1.id = i.itemid
join  recompensa r on r.id = i1.recompensaId
end


GO




alter PROC [dbo].[pr_Item_ups_recompensaId_ProxDisp]	@recompensaId intWITH EXECUTE AS OWNERASSET NOCOUNT ONupdate top (1) itemset dataHoraUtilizacao = getdate()output inserted.*where recompensaid = @recompensaId and dataHoraUtilizacao is null SET NOCOUNT OFF
GO

create index LancamentoResgate_ID01 on LancamentoResgate (lancamentoId, resgateId) include (id)
create index LancamentoResgate_ID02 on LancamentoResgate (resgateId,lancamentoId) include (id)
go



ALTER view [dbo].[vwResgate] as
select lr.resgateId,l.clienteId,c.primeiroNome,c.nomeMeio,c.sobrenome,r.id as recompensaID,rec.nome as NomeRecompensa,r.enderecoId,
e.logradouro,e.complemento,e.cidade,e.pais,uf.sigla,e.cep, e.numero, e.destinatario, e.bairro, e.residencial, e.nome,
l.dataHora as dataHoraResgate, l.qtd, r.dataHoraPacote,r.dataHoraPostagem,r.codRastreio,c.email
from Resgate (nolock) r 
join LancamentoResgate (nolock) lr on r.id = lr.resgateId
join Lancamento (nolock) l on lr.lancamentoId = l.id 
join Clientedb.dbo.Cliente (nolock) c on l.clienteId = c.id
join ClienteDb.dbo.Endereco (nolock) e on r.enderecoId = e.id
join Item i (nolock) on l.itemId = i.id
join Recompensa rec (nolock) on i.recompensaId = rec.id
join clientedb.dbo.Uf (nolock) uf on e.ufid = uf.id
where
l.itemId is not null  -- Lancamento com id da recompensa é resgate 
GO

create view [dbo].[vwLancamento] as
select lr.resgateId,l.clienteId,c.primeiroNome,c.nomeMeio,c.sobrenome,rec.id as recompensaID,rec.nome as NomeRecompensa,r.enderecoId,
e.logradouro,e.complemento,e.cidade,e.pais,uf.sigla,e.cep, e.numero, e.destinatario, e.bairro, e.residencial, e.nome,
l.dataHora as dataHoraResgate, l.qtd,l.totalPontos, r.dataHoraPacote,r.dataHoraPostagem,r.codRastreio,c.email,
rec.url,i.id as ItemId,i.codigo,rec.tiporecompensaId
from Lancamento (nolock) l 
left outer join LancamentoResgate (nolock) lr on lr.lancamentoId = l.id  
left outer join Resgate (nolock) r on r.id = lr.resgateId
left outer join Clientedb.dbo.Cliente (nolock) c on l.clienteId = c.id
left outer join ClienteDb.dbo.Endereco (nolock) e on r.enderecoId = e.id
left outer join item (nolock) i on l.itemid = i.id
left outer join Recompensa rec (nolock) on i.recompensaId = rec.id
left outer join clientedb.dbo.Uf (nolock) uf on e.ufid = uf.id
where
l.itemId is not null  -- Lancamento com id da recompensa é resgate 
go



CREATE proc [dbo].[pr_vwLancamento_sel_ClienteId]
@clienteId int
--with execute as owner
ASSET NOCOUNT ONSELECT * FROM vwLancamentoWHERE clienteId = @clienteIdSET NOCOUNT OFF

GO




CREATE PROC [dbo].[pr_Recompensa_sel_tipoRecompensaId]
	@tipoRecompensaId tinyint
WITH EXECUTE AS OWNER

AS
SET NOCOUNT ON

SELECT * 
FROM Recompensa (nolock) 
WHERE tipoRecompensaId = @tipoRecompensaId


SET NOCOUNT OFF
go



-----------------------------------------------------------------------
-- Do we want to generate the SP definitions for every user defined
-- table in the database or just a single specified table?
-- Assign a blank string - '' for all tables or the table name for
-- a single table.
DECLARE @GenerateProcsFor varchar(100)
--SET @GenerateProcsFor = 'optout'
SET @GenerateProcsFor = ''

--ALTER PROC ?
DECLARE @Alter varchar(1)
SET @alter = 's'

-- which database do we want to create the procs for?
-- Change both the USE and SET lines below to set the datbase name
-- to the required database.

DECLARE @DatabaseName varchar(100)
SELECT @DatabaseName = DB_NAME()

-- do we want the script to print out the CREATE PROC statements
-- or do we want to execute them to actually create the procs?
-- Assign a value of either 'Print' or 'Execute'
DECLARE @PrintOrExecute varchar(10)
SET @PrintOrExecute = 'execute'


-- Is there a table name prefix i.e. 'tbl_' which we don't want
-- to include in our stored proc names?
DECLARE @TablePrefix varchar(10)
SET @TablePrefix = ''

-- For our '_lst' and '_sel' procedures do we want to 
-- do SELECT * or SELECT ColumnName,...
-- Assign a value of either 1 or 0
DECLARE @UseSelectWildCard bit
SET @UseSelectWildCard = 1

-- ##########################################################
/* END SETTING OF CONFIG VARIABLE 
-- do not edit below this line */
-- ##########################################################


-- DECLARE CURSOR containing all columns from user defined tables
-- in the database
DECLARE TableCol Cursor FOR 
SELECT c.TABLE_SCHEMA, c.TABLE_NAME, c.COLUMN_NAME, c.DATA_TYPE, c.CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.Columns c INNER JOIN
	INFORMATION_SCHEMA.Tables t ON c.TABLE_NAME = t.TABLE_NAME
WHERE t.Table_Catalog = @DatabaseName
	AND t.TABLE_TYPE = 'BASE TABLE' and c.TABLE_SCHEMA = 'dbo' and c.TABLE_NAME not like 'sys%'
	and c.TABLE_NAME not like 'dba%'
	and c.TABLE_NAME not like 'MSRepli%'
	and c.TABLE_NAME not like 'spt_%'
	and c.TABLE_NAME <> '%teste%' --teste
ORDER BY c.TABLE_NAME, c.ORDINAL_POSITION

-- Declare variables which will hold values from cursor rows
DECLARE @TableSchema varchar(100), @TableName varchar(100)
DECLARE @ColumnName varchar(100), @DataType varchar(30)
DECLARE @CharLength int

DECLARE @ColumnNameCleaned varchar(100)

-- Declare variables which will track what table we are
-- creating Stored Procs for
DECLARE @CurrentTable varchar(100)
DECLARE @FirstTable bit
DECLARE @FirstColumnName varchar(100)
DECLARE @FirstColumnDataType varchar(30)
DECLARE @ObjectName varchar(100) -- this is the tablename with the 
				-- specified tableprefix lopped off.
DECLARE @TablePrefixLength int

-- init vars
SET @CurrentTable = ''
SET @FirstTable = 1
SET @TablePrefixLength = Len(@TablePrefix)

-- Declare variables which will hold the queries we are building use unicode
-- data types so that can execute using sp_ExecuteSQL
DECLARE @LIST nvarchar(4000), @UPSERT nvarchar(4000)
DECLARE @SELECT nvarchar(4000), @INSERT nvarchar(4000), @INSERTVALUES varchar(4000)
DECLARE @UPDATE nvarchar(4000), @DELETE nvarchar(4000)


-- open the cursor
OPEN TableCol

-- get the first row of cursor into variables
FETCH NEXT FROM TableCol INTO @TableSchema, @TableName, @ColumnName, @DataType, @CharLength

-- loop through the rows of the cursor
WHILE @@FETCH_STATUS = 0 BEGIN

	SET @ColumnNameCleaned = Replace(@ColumnName, ' ', '') 

	-- is this a new table?
	IF @TableName <> @CurrentTable BEGIN
		
		-- if is the end of the last table
		IF @CurrentTable <> '' BEGIN
			IF @GenerateProcsFor = '' OR @GenerateProcsFor = @CurrentTable BEGIN

				-- first add any syntax to end the statement
				
				-- _lst
				SET @LIST = @List + Char(13) + 'FROM ' + @CurrentTable + ' (nolock) ' + Char(13)
				SET @LIST = @LIST + Char(13) + Char(13) + 'SET NOCOUNT OFF' + Char(13) 
				SET @LIST = @LIST + 'SET rowcount 0' + Char(13) + Char(13)				
				SET @LIST = @LIST + Char(13)
				
				-- _sel
				SET @SELECT = @SELECT + Char(13) + 'FROM ' + @CurrentTable + ' (nolock) ' + Char(13)
				SET @SELECT = @SELECT + 'WHERE ' + @FirstColumnName + ' = @' + Replace(@FirstColumnName, ' ', '') + Char(13)
				SET @SELECT = @SELECT + Char(13) + Char(13) + 'SET NOCOUNT OFF' + Char(13) + Char(13)
				SET @SELECT = @SELECT + Char(13)
	
	
				-- UPDATE (remove trailing comma and append the WHERE clause)
				SET @UPDATE = SUBSTRING(@UPDATE, 0, LEN(@UPDATE)- 1) + Char(13) + Char(9) + 'WHERE ' + @FirstColumnName + ' = @' + Replace(@FirstColumnName, ' ', '') + Char(13)
				
				-- INSERT
				SET @INSERT = SUBSTRING(@INSERT, 0, LEN(@INSERT) - 1) + Char(13) + Char(9) + ')' + Char(13)
				SET @INSERTVALUES = SUBSTRING(@INSERTVALUES, 0, LEN(@INSERTVALUES) -1) + Char(13) + Char(9) + ')'
				SET @INSERT = @INSERT + @INSERTVALUES
				
				-- _ups
				SET @UPSERT = @UPSERT + ' = null'
				SET @UPSERT = @UPSERT + Char(13) + 'WITH EXECUTE AS OWNER' + Char(13)
				SET @UPSERT = @UPSERT + Char(13) + 'AS' + Char(13)
				SET @UPSERT = @UPSERT + 'SET NOCOUNT ON' + Char(13)
				
				IF @FirstColumnDataType IN ('int', 'bigint', 'smallint', 'tinyint', 'float', 'decimal')
				BEGIN
					SET @UPSERT = @UPSERT + 'IF @' + Replace(@FirstColumnName, ' ', '') + ' = 0 BEGIN' + Char(13)
				END ELSE BEGIN
					SET @UPSERT = @UPSERT + 'IF @' + Replace(@FirstColumnName, ' ', '') + ' = '''' BEGIN' + Char(13)	
				END
				SET @UPSERT = @UPSERT + ISNULL(@INSERT, '') + Char(13)
				SET @UPSERT = @UPSERT + Char(9) + 'SELECT SCOPE_IDENTITY() As InsertedID' + Char(13)
				SET @UPSERT = @UPSERT + 'END' + Char(13)
				SET @UPSERT = @UPSERT + 'ELSE BEGIN' + Char(13)
				SET @UPSERT = @UPSERT + ISNULL(@UPDATE, '') + Char(13)
				SET @UPSERT = @UPSERT + 'END' + Char(13) + Char(13)
				SET @UPSERT = @UPSERT + 'SET NOCOUNT OFF' + Char(13) + Char(13)
				SET @UPSERT = @UPSERT + Char(13)
	
				-- _del
				-- delete proc completed already
	
				-- --------------------------------------------------
				-- now either print the SP definitions or 
				-- execute the statements to create the procs
				-- --------------------------------------------------
				IF @PrintOrExecute <> 'Execute' BEGIN
					PRINT @LIST
					PRINT @SELECT
					PRINT @UPSERT
					PRINT @DELETE
				END ELSE BEGIN
					EXEC sp_Executesql @LIST
					EXEC sp_Executesql @SELECT
					EXEC sp_Executesql @UPSERT
					EXEC sp_Executesql @DELETE
				END
			END -- end @GenerateProcsFor = '' OR @GenerateProcsFor = @CurrentTable
		END
		
		-- update the value held in @CurrentTable
		SET @CurrentTable = @TableName
		SET @FirstColumnName = @ColumnName
		SET @FirstColumnDataType = @DataType
		
		IF @TablePrefixLength > 0 BEGIN
			IF SUBSTRING(@CurrentTable, 1, @TablePrefixLength) = @TablePrefix BEGIN
				--PRINT Char(13) + 'DEBUG: OBJ NAME: ' + RIGHT(@CurrentTable, LEN(@CurrentTable) - @TablePrefixLength)
				SET @ObjectName = RIGHT(@CurrentTable, LEN(@CurrentTable) - @TablePrefixLength)
			END ELSE BEGIN
				SET @ObjectName = @CurrentTable
			END
		END ELSE BEGIN
			SET @ObjectName = @CurrentTable
		END
		
		IF @GenerateProcsFor = '' OR @GenerateProcsFor = @CurrentTable BEGIN
		
			-- ----------------------------------------------------
			-- now start building the procedures for the next table
			-- ----------------------------------------------------
			
			-- _lst
			if @Alter = 'S'
			SET @LIST = 'ALTER PROC dbo.pr_' + @ObjectName + '_lst' + Char(13)			
			else
			SET @LIST = 'CREATE PROC dbo.pr_' + @ObjectName + '_lst' + Char(13)
			SET @LIST = @LIST + 'WITH EXECUTE AS OWNER' + Char(13)			
			SET @LIST = @LIST + 'AS' + Char(13)
			SET @LIST = @LIST + 'SET NOCOUNT ON' + Char(13)
			SET @LIST = @LIST + 'SET rowcount 1000' + Char(13)
			IF @UseSelectWildcard = 1 BEGIN
				SET @LIST = @LIST + Char(13) + 'SELECT * '
			END 
			ELSE BEGIN
				SET @LIST = @LIST + Char(13) + 'SELECT ' + @ColumnName + ''
			END
	
			-- _sel
			if @Alter = 'S'
			SET @SELECT = 'ALTER PROC dbo.pr_' + @ObjectName + '_sel' + Char(13)
			else
			SET @SELECT = 'CREATE PROC dbo.pr_' + @ObjectName + '_sel' + Char(13)
			SET @SELECT = @SELECT + Char(9) + '@' + @ColumnNameCleaned + ' ' + @DataType
			IF @DataType IN ('varchar', 'nvarchar', 'char', 'nchar') BEGIN
				SET @SELECT = @SELECT + '(' + isnull(CAST(@CharLength As varchar(10)),'MAX') + ')'
			END
			SET @SELECT = @SELECT + Char(13) + 'WITH EXECUTE AS OWNER' + Char(13)
			SET @SELECT = @SELECT + Char(13) + 'AS' + Char(13)
			SET @SELECT = @SELECT + 'SET NOCOUNT ON' + Char(13)
			IF @UseSelectWildcard = 1 BEGIN
				SET @SELECT = @SELECT + Char(13) + 'SELECT * '
			END 
			ELSE BEGIN
				SET @SELECT = @SELECT + Char(13) + 'SELECT ' + @ColumnName + ''
			END
	
			-- _ups
			if @Alter = 'S'
			SET @UPSERT = 'ALTER PROC dbo.pr_' + @ObjectName + '_ups' + Char(13)			
			else
			SET @UPSERT = 'CREATE PROC dbo.pr_' + @ObjectName + '_ups' + Char(13)
					SET @UPSERT = @UPSERT + Char(13) + Char(9) + '@' + @ColumnNameCleaned + ' ' + @DataType
			IF @DataType IN ('varchar', 'nvarchar', 'char', 'nchar') BEGIN
				SET @UPSERT = @UPSERT + '(' + isnull(CAST(@CharLength As Varchar(10)),'MAX') + ')'
				if @UPSERT like '%-1%' set @UPSERT = REPLACE(@UPSERT,'-1','MAX')
			END
	

			-- UPDATE
			SET @UPDATE = Char(9) + 'UPDATE ' + @TableName + ' SET ' + Char(13)
			
			-- INSERT -- don't add first column to insert if it is an
			--	     integer (assume autonumber)
			SET @INSERT = Char(9) + 'INSERT INTO ' + @TableName + ' (' + Char(13)
			SET @INSERTVALUES = Char(9) + 'VALUES (' + Char(13)
			
			IF @FirstColumnDataType NOT IN ('int', 'bigint', 'smallint', 'tinyint')
			BEGIN
				SET @INSERT = @INSERT + Char(9) + Char(9) + '' + @ColumnName + ',' + Char(13)
				SET @INSERTVALUES = @INSERTVALUES + Char(9) + Char(9) + '@' + @ColumnNameCleaned + ',' + Char(13)
			END
	
			-- _del
			if @Alter = 'S'
			SET @DELETE = 'ALTER PROC dbo.pr_' + @ObjectName + '_del' + Char(13)
			else
			SET @DELETE = 'CREATE PROC dbo.pr_' + @ObjectName + '_del' + Char(13)
			SET @DELETE = @DELETE + Char(9) + '@' + @ColumnNameCleaned + ' ' + @DataType
			IF @DataType IN ('varchar', 'nvarchar', 'char', 'nchar') BEGIN
				SET @DELETE = @DELETE + '(' + CAST(@CharLength As Varchar(10)) + ')'
			END
			SET @DELETE = @DELETE +  Char(13) + 'WITH EXECUTE AS OWNER' + Char(13)						
			SET @DELETE = @DELETE + Char(13) + 'AS' + Char(13)
			SET @DELETE = @DELETE + 'SET NOCOUNT ON' + Char(13) + Char(13)
			SET @DELETE = @DELETE + 'DELETE FROM ' + @TableName + Char(13)
			SET @DELETE = @DELETE + 'WHERE ' + @ColumnName + ' = @' + @ColumnNameCleaned + Char(13)
			SET @DELETE = @DELETE + Char(13) + 'SET NOCOUNT OFF' + Char(13)
			SET @DELETE = @DELETE + Char(13) 

		END	-- end @GenerateProcsFor = '' OR @GenerateProcsFor = @CurrentTable
	END
	ELSE BEGIN
		IF @GenerateProcsFor = '' OR @GenerateProcsFor = @CurrentTable BEGIN
		
			-- is the same table as the last row of the cursor
			-- just append the column
			
			-- _lst
			IF @UseSelectWildCard = 0 BEGIN
				SET @LIST = @LIST + ', ' + Char(13) + Char(9) + '' + @ColumnName + ''
			END
	
			-- _sel
			IF @UseSelectWildCard = 0 BEGIN
				SET @SELECT = @SELECT + ', ' + Char(13) + Char(9) + '' + @ColumnName + ''
			END
	
			-- _ups
			SET @UPSERT = @UPSERT + ' = null,' + Char(13) + Char(9) + '@' + @ColumnNameCleaned + ' ' + @DataType
			IF @DataType IN ('varchar', 'nvarchar', 'char', 'nchar') BEGIN
				SET @UPSERT = @UPSERT + '(' + CAST(@CharLength As varchar(10)) + ')'
			END

			-- UPDATE
			SET @UPDATE = @UPDATE + Char(9) + Char(9) + '' + @ColumnName + ' = isnull(@' + @ColumnNameCleaned + ','+@ColumnNameCleaned+'),' + Char(13)
			if @UPSERT like '%-1%' set @UPSERT = REPLACE(@UPSERT,'-1','MAX')
	
			-- INSERT
			SET @INSERT = @INSERT + Char(9) + Char(9) + '' + @ColumnName + ',' + Char(13)
			SET @INSERTVALUES = @INSERTVALUES + Char(9) + Char(9) + '@' + @ColumnNameCleaned + ',' + Char(13)
	
			-- _del
			-- delete proc completed already
		END -- end @GenerateProcsFor = '' OR @GenerateProcsFor = @CurrentTable'
	END

	-- fetch next row of cursor into variables
	FETCH NEXT FROM TableCol INTO @TableSchema, @TableName, @ColumnName, @DataType, @CharLength
END

-- ----------------
-- clean up cursor
-- ----------------
CLOSE TableCol
DEALLOCATE TableCol

-- ------------------------------------------------
-- repeat the block of code from within the cursor
-- So that the last table has its procs completed
-- and printed / executed
-- ------------------------------------------------

-- if is the end of the last table
IF @CurrentTable <> '' BEGIN
	IF @GenerateProcsFor = '' OR @GenerateProcsFor = @CurrentTable BEGIN

		-- first add any syntax to end the statement
		
		-- _lst
		SET @LIST = @List + Char(13) + 'FROM ' + @CurrentTable  + ' (nolock) ' + Char(13)
		SET @LIST = @LIST + Char(13) + Char(13) + 'SET NOCOUNT OFF' + Char(13)
		SET @LIST = @LIST + Char(13) + Char(13) + 'SET rowcount 0' + Char(13)
		SET @LIST = @LIST + Char(13)
		
		-- _sel
		SET @SELECT = @SELECT + Char(13) + 'FROM ' + @CurrentTable  + ' (nolock) ' + Char(13)
		SET @SELECT = @SELECT + 'WHERE ' + @FirstColumnName + ' = @' + Replace(@FirstColumnName, ' ', '') + Char(13)
		SET @SELECT = @SELECT + Char(13) + Char(13) + 'SET NOCOUNT OFF' + Char(13)
		SET @SELECT = @SELECT + Char(13)


		-- UPDATE (remove trailing comma and append the WHERE clause)
		SET @UPDATE = SUBSTRING(@UPDATE, 0, LEN(@UPDATE)- 1) + Char(13) + Char(9) + 'WHERE ' + @FirstColumnName + ' = @' + Replace(@FirstColumnName, ' ', '') + Char(13)
		
		-- INSERT
		SET @INSERT = SUBSTRING(@INSERT, 0, LEN(@INSERT) - 1) + Char(13) + Char(9) + ')' + Char(13)
		SET @INSERTVALUES = SUBSTRING(@INSERTVALUES, 0, LEN(@INSERTVALUES) -1) + Char(13) + Char(9) + ')'
		SET @INSERT = @INSERT + @INSERTVALUES
		
		-- _ups
		SET @UPSERT = @UPSERT + Char(13) + 'WITH EXECUTE AS OWNER' + Char(13)								
		SET @UPSERT = @UPSERT + Char(13) + 'AS' + Char(13)
		SET @UPSERT = @UPSERT + Char(13) + 'SET NOCOUNT ON' + Char(13)
		IF @FirstColumnDataType IN ('int', 'bigint', 'smallint', 'tinyint', 'float', 'decimal')
		BEGIN
			SET @UPSERT = @UPSERT + 'IF @' + Replace(@FirstColumnName, ' ', '') + ' = 0 BEGIN' + Char(13)
		END ELSE BEGIN
			SET @UPSERT = @UPSERT + 'IF @' + Replace(@FirstColumnName, ' ', '') + ' = '''' BEGIN' + Char(13)	
		END
		SET @UPSERT = @UPSERT + ISNULL(@INSERT, '') + Char(13)
		SET @UPSERT = @UPSERT + Char(9) + 'SELECT SCOPE_IDENTITY() As InsertedID' + Char(13)
		SET @UPSERT = @UPSERT + 'END' + Char(13)
		SET @UPSERT = @UPSERT + 'ELSE BEGIN' + Char(13)
		SET @UPSERT = @UPSERT + ISNULL(@UPDATE, '') + Char(13)
		SET @UPSERT = @UPSERT + 'END' + Char(13) + Char(13)
		SET @UPSERT = @UPSERT + 'SET NOCOUNT OFF' + Char(13)
		SET @UPSERT = @UPSERT + Char(13)

		-- _del
		-- delete proc completed already

		-- --------------------------------------------------
		-- now either print the SP definitions or 
		-- execute the statements to create the procs
		-- --------------------------------------------------
		IF @PrintOrExecute <> 'Execute' BEGIN
			PRINT @LIST
			PRINT @SELECT
			PRINT @UPSERT
			PRINT @DELETE
		END ELSE BEGIN
			EXEC sp_Executesql @LIST
			EXEC sp_Executesql @SELECT
			EXEC sp_Executesql @UPSERT
			EXEC sp_Executesql @DELETE
		END
	END -- end @GenerateProcsFor = '' OR @GenerateProcsFor = @CurrentTable
END

GO
--------------------------------------------


declare @dataInclusao smalldatetime
select @dataInclusao = getdate()

exec pr_recompensa_ups     @id = 0 , 
                                        @nome = 'Peixe Urbano',
                                        @descricao = 'Cupom de R$ 5,00 de desconto para qualquer compra realizada no Peixe Urbano.',
                                        @pontos = 20000 , 
                                        @dataInclusao = @dataInclusao,
                                        @qtdEstoque = 1000,
                                        @tipoRecompensaId = 2,
                                        @url = 'http://www.peixeurbano.com.br/home/faq#cupom' , 
                                        @nomeImagem = 'pu_logo.png',
                                        @ativo = 1, @ordenacao = 1

exec pr_recompensa_ups     @id = 0 , 
                                        @nome = 'Vostu',
                                        @descricao = 'Cupom de R$ 5,00 de crédito para utilizar em qualquer jogo Vostu tais como: MiniFazenda, MegaCity, Mega Poker, Café Mania.',
                                        @pontos = 20000 , 
                                        @dataInclusao = @dataInclusao,
                                        @qtdEstoque = 1000,
                                        @tipoRecompensaId = 2,
                                        @url = 'http://www.tutudo.com/home/support' , 
                                        @nomeImagem = 'vostu_logo.png',
                                        @ativo = 1  , @ordenacao = 3                            
                                                      

exec pr_recompensa_ups     @id = 0 , 
                                        @nome = 'Mentez',
                                        @descricao = 'Cupom de R$ 5,00 de crédito para utilizar em qualquer jogo Mentez tais como: Cidade Maravilhosa, Milmo, Sociedade Pôquer, Vila Mágica.',
                                        @pontos = 20000 , 
                                        @dataInclusao = @dataInclusao,
                                        @qtdEstoque = 1000,
                                        @tipoRecompensaId = 2,
                                        @url = 'https://secure.paymentez.com/how-to-pin' , 
                                        @nomeImagem = 'mentez_logo.png',
                                        @ativo = 1, @ordenacao = 2


SELECT * FROM Recompensa WHERE TipoRecompensaid = 2
go



--TUTUDO

insert item select '4e145f4ba6ebe210',1,null,2159 ;
insert item select '4e145f4b9f988987',1,null,2159 ;
insert item select '4e145f4bae3dc207',1,null,2159 ;
insert item select '4e145f4babcde254',1,null,2159 ;
insert item select '4e145f4bb3216961',1,null,2159 ;
insert item select '4e145f4b98465931',1,null,2159 ;
insert item select '4e145f4b9ab84119',1,null,2159 ;
insert item select '4e145f4b9d2bf166',1,null,2159 ;
insert item select '4e145f4ba209f113',1,null,2159 ;
insert item select '4e145f4ba479d120',1,null,2159 ;
insert item select '4e145f4ba95bd164',1,null,2159 ;
insert item select '4e145f4bb0afe205',1,null,2159 ;
insert item select '4e145f4bb591e117',1,null,2159 ;
insert item select '4e145f4bb801d110',1,null,2159 ;
insert item select '4e145f4bba73d160',1,null,2159 ;
insert item select '4e145f4bbce3c207',1,null,2159 ;
insert item select '4e145f4bbf55d165',1,null,2159 ;
insert item select '4e145f4bc1c5d159',1,null,2159 ;
insert item select '4e145f4bc4380965',1,null,2159 ;
insert item select '4e145f4bc6a84117',1,null,2159 ;
insert item select '4e145f4bc91a8117',1,null,2159 ;
insert item select '4e145f4bcb8af211',1,null,2159 ;
insert item select '4e145f4bcdfd3211',1,null,2159 ;
insert item select '4e145f4bd06d8117',1,null,2159 ;
insert item select '4e145f4bd2e0d158',1,null,2159 ;
insert item select '4e145f4bd5559975',1,null,2159 ;
insert item select '4e145f4bd7c34116',1,null,2159 ;
insert item select '4e145f4bda308111',1,null,2159 ;
insert item select '4e145f4bdca20153',1,null,2159 ;
insert item select '4e145f4bdf126114',1,null,2159 ;
insert item select '4e145f4be1840965',1,null,2159 ;
insert item select '4e145f4be3f4a162',1,null,2159 ;
insert item select '4e145f4be6664974',1,null,2159 ;
insert item select '4e145f4be8d6a167',1,null,2159 ;
insert item select '4e145f4beb480114',1,null,2159 ;
insert item select '4e145f4bedb93166',1,null,2159 ;
insert item select '4e145f4bf02a4108',1,null,2159 ;
insert item select '4e145f4bf29a3116',1,null,2159 ;
insert item select '4e145f4c00e80961',1,null,2159 ;
insert item select '4e145f4c03593920',1,null,2159 ;
insert item select '4e145f4c05ca4109',1,null,2159 ;
insert item select '4e145f4c083b7968',1,null,2159 ;
insert item select '4e145f4c0aac8157',1,null,2159 ;
insert item select '4e145f4c0d1c1105',1,null,2159 ;
insert item select '4e145f4c0f8e0115',1,null,2159 ;
insert item select '4e145f4c11fe0109',1,null,2159 ;
insert item select '4e145f4c146ff119',1,null,2159 ;
insert item select '4e145f4c16e00960',1,null,2159 ;
insert item select '4e145f4c1952f971',1,null,2159 ;
insert item select '4e145f4c1bc27111',1,null,2159 ;
insert item select '4e145f4c1e33f114',1,null,2159 ;
insert item select '4e145f4c20a5d108',1,null,2159 ;
insert item select '4e145f4c231a4959',1,null,2159 ;
insert item select '4e145f4c25878930',1,null,2159 ;
insert item select '4e145f4c27f83974',1,null,2159 ;
insert item select '4e145f4c2a681966',1,null,2159 ;
insert item select '4e145f4c2cda0154',1,null,2159 ;
insert item select '4e145f4c2f49e122',1,null,2159 ;
insert item select '4e145f4c31bbf158',1,null,2159 ;
insert item select '4e145f4c342be112',1,null,2159 ;
insert item select '4e145f4c369df124',1,null,2159 ;
insert item select '4e145f4c390de117',1,null,2159 ;
insert item select '4e145f4c3b7ff168',1,null,2159 ;
insert item select '4e145f4c3deff216',1,null,2159 ;
insert item select '4e145f4c4061f965',1,null,2159 ;
insert item select '4e145f4c42d1e112',1,null,2159 ;
insert item select '4e145f4c45440917',1,null,2159 ;
insert item select '4e145f4c47b4e118',1,null,2159 ;
insert item select '4e145f4c4a260961',1,null,2159 ;
insert item select '4e145f4c4c962972',1,null,2159 ;
insert item select '4e145f4c4f07f119',1,null,2159 ;
insert item select '4e145f4c51783924',1,null,2159 ;
insert item select '4e145f4c53ea5115',1,null,2159 ;
insert item select '4e145f4c5659f979',1,null,2159 ;
insert item select '4e145f4c58cbf168',1,null,2159 ;
insert item select '4e145f4c5b3be161',1,null,2159 ;
insert item select '4e145f4c5dadf212',1,null,2159 ;
insert item select '4e145f4c601de112',1,null,2159 ;
insert item select '4e145f4c628ff124',1,null,2159 ;
insert item select '4e145f4c64ffe171',1,null,2159 ;
insert item select '4e145f4c6771f975',1,null,2159 ;
insert item select '4e145f4c69e2e123',1,null,2159 ;
insert item select '4e145f4c6c540966',1,null,2159 ;
insert item select '4e145f4c6ec3e166',1,null,2159 ;
insert item select '4e145f4c7135f970',1,null,2159 ;
insert item select '4e145f4c73a71967',1,null,2159 ;
insert item select '4e145f4c76181923',1,null,2159 ;
insert item select '4e145f4c7887e983',1,null,2159 ;
insert item select '4e145f4c7af9f173',1,null,2159 ;
insert item select '4e145f4c7d6a3117',1,null,2159 ;
insert item select '4e145f4c7fdc1165',1,null,2159 ;
insert item select '4e145f4c824c3968',1,null,2159 ;
insert item select '4e145f4c84bdf168',1,null,2159 ;
insert item select '4e145f4c872de122',1,null,2159 ;
insert item select '4e145f4c899ff134',1,null,2159 ;
insert item select '4e145f4c8c10e113',1,null,2159 ;
insert item select '4e145f4c8e820971',1,null,2159 ;
insert item select '4e145f4c90f1e117',1,null,2159 ;
insert item select '4e145f4c9363f975',1,null,2159 ;
insert item select '4e145f4c95d3e122',1,null,2159 ;




--PEIXE URBANO

insert item select '980569DC-290D-424B-933D-CD21D67587F2',1,null,2197 ;
insert item select 'F7764333-1646-4221-A554-95232546A408',1,null,2197 ;
insert item select '8462285C-8CE2-4F58-8124-C74EA8F275C5',1,null,2197 ;
insert item select 'F481A2AA-A6E7-4B7B-ACA0-0EFC75BC3C3A',1,null,2197 ;
insert item select 'A5D166A6-977B-4F1C-851D-8D8063B074BF',1,null,2197 ;
insert item select 'A1457C04-8052-48A0-BCEF-D6B26878375D',1,null,2197 ;
insert item select '2C94B937-9C61-478C-8CA5-B3CBC7F3AEBF',1,null,2197 ;
insert item select 'A5D04B6A-1707-4E58-A247-5D2BB304A1CB',1,null,2197 ;
insert item select '5D5C843A-B2C7-44CD-BC85-57A2E305ECE1',1,null,2197 ;
insert item select 'BD2C160E-26C4-4F06-A8F7-94B57973DCDF',1,null,2197 ;
insert item select 'ED08D6C7-B6B6-4C59-94B2-AE4ED7AF507E',1,null,2197 ;
insert item select '561E3751-8A72-43CD-9226-7D446F8DB3FD',1,null,2197 ;
insert item select 'B064DF7F-C76E-429C-A2C2-D2DE70E5EB4B',1,null,2197 ;
insert item select '9D1DC07E-EEBF-4C6C-947F-16C17561DE51',1,null,2197 ;
insert item select 'A375EB1B-5592-4D97-A640-77552C32D874',1,null,2197 ;
insert item select '0446A881-96DA-45DA-9186-84F969825DDB',1,null,2197 ;
insert item select 'D3782F13-9BA5-4753-B99F-2558DCDD8AC6',1,null,2197 ;
insert item select '1ABDDBF9-D1C2-41FB-BD6D-59362CB64EC8',1,null,2197 ;
insert item select '813F7F68-BD82-4990-9965-143934AE91FE',1,null,2197 ;
insert item select 'AAD3B675-88F8-499C-A52E-84569BDF3ABD',1,null,2197 ;
insert item select '88F297DD-062F-4AF5-9AAA-5F184EC6DA16',1,null,2197 ;
insert item select '82AE85C8-35CD-4631-9D97-3392163490E6',1,null,2197 ;
insert item select '1742EE60-D8CD-4711-ABDC-0037CEEBE54F',1,null,2197 ;
insert item select '0D968424-E384-4852-B48A-F02803098538',1,null,2197 ;
insert item select '62FEB7F0-9E2C-4869-8E78-CB79437F0C9A',1,null,2197 ;
insert item select '1CDE7327-270C-492C-8063-3876B097BB3F',1,null,2197 ;
insert item select 'CE008118-95FB-4A24-BAD5-3ECE3BA7245F',1,null,2197 ;
insert item select '19B010A6-AA0E-49C9-B670-1FAB24244B22',1,null,2197 ;
insert item select 'E56D539C-AD7D-4C8F-A93A-24530A6D98C9',1,null,2197 ;
insert item select '3D044097-7501-4861-851C-8909920BFB79',1,null,2197 ;
insert item select '7F0747CF-F039-46BD-B5D9-AEF71DDB84C2',1,null,2197 ;
insert item select '2DE27D89-6B0B-43AB-AAB6-6402FF1049E1',1,null,2197 ;
insert item select '4EF7CC14-4895-45DE-8C73-D341040B5798',1,null,2197 ;
insert item select '4C72793D-FD05-4470-AA73-79294D865751',1,null,2197 ;
insert item select 'EA1DF751-D045-4820-8C7A-2FE925E49145',1,null,2197 ;
insert item select '496C9B18-A14A-4737-A385-B06B4D751E07',1,null,2197 ;
insert item select '4FBC3560-BF3C-4F33-9447-E19A134864DB',1,null,2197 ;
insert item select 'BF13D48A-EBA5-427C-8587-FAD3B54D69F5',1,null,2197 ;
insert item select '15FC76B6-7866-4452-8744-76575ABDB537',1,null,2197 ;
insert item select 'A8453CE7-5411-4B4B-9C60-FAAD9E513C75',1,null,2197 ;
insert item select '8B675685-0D8F-4525-9CEE-C91B2EF23C00',1,null,2197 ;
insert item select '3713734C-B627-4AFD-9C0B-01E577B98DD8',1,null,2197 ;
insert item select '52B619D2-E634-4C3A-A28C-68B5227F5066',1,null,2197 ;
insert item select '58370B90-BB57-4D7F-9AFC-68EA358F0AD2',1,null,2197 ;
insert item select '072A1228-16C7-40E3-B45E-C49EF8527AF3',1,null,2197 ;
insert item select 'D4E09D93-E1FE-45B4-BE2F-48F3D2A6BADF',1,null,2197 ;
insert item select '893D2CC3-0970-4030-8C20-D9263DCC82F2',1,null,2197 ;
insert item select '07BD2918-1042-41CF-BC87-7388F9E7B080',1,null,2197 ;
insert item select '79D9C53E-EDDB-43EC-B417-7E3F5E2C3707',1,null,2197 ;
insert item select '258C24D4-47C9-4B85-8648-419F121D5D44',1,null,2197 ;
insert item select '9BFA688E-5911-40F8-8EFD-DB9AF4DEE341',1,null,2197 ;
insert item select 'E39941E6-DCCE-41F4-81F6-6B3FA9EDDADB',1,null,2197 ;
insert item select '15FB6476-94FE-4F4B-B39C-B1EB5DC42B28',1,null,2197 ;
insert item select 'A9723819-C9E6-40CC-810F-6482DB3BCC63',1,null,2197 ;
insert item select 'FE36BE82-3190-429F-B3A3-1B0D231FC39C',1,null,2197 ;
insert item select '48A76C06-B0AC-4B41-BC25-B9FA93763E92',1,null,2197 ;
insert item select '784BA3DF-259A-4063-BFE3-44B904D97F8E',1,null,2197 ;
insert item select '1A0C17EA-CEB9-4F0D-AF13-55108EC4AC85',1,null,2197 ;
insert item select '557F1165-8143-4ACA-80FA-CE6EF0C99277',1,null,2197 ;
insert item select '28C7DDFF-1159-49A3-946F-D1E7104BA6FA',1,null,2197 ;
insert item select 'EAFA67F9-CA64-44BB-B67A-87F7CCADD04E',1,null,2197 ;
insert item select 'E4CCEA33-726D-4C56-981D-92727A42E9CE',1,null,2197 ;
insert item select '788DE2FB-550B-457B-8E23-B5A9CFFE21D6',1,null,2197 ;
insert item select '0991E388-85FF-425C-8C0C-F8FD022C4E61',1,null,2197 ;
insert item select '9FC39647-40A4-4D6E-8501-ABDA515B8A5D',1,null,2197 ;
insert item select '3833FA1F-9ECA-4A4F-B987-FA7D0B410887',1,null,2197 ;
insert item select '76C0F86F-9DF6-4986-9444-A06409D5C1E8',1,null,2197 ;
insert item select '9CA23458-72FD-4749-8329-0D50E7CAB54C',1,null,2197 ;
insert item select '5935411F-1111-476B-AF66-01DEA6F9F638',1,null,2197 ;
insert item select 'E6B70BB2-2DD5-4531-9797-6896909C2BB4',1,null,2197 ;
insert item select 'F609BB4A-0D3A-4B6B-8113-24CFCEAB1A02',1,null,2197 ;
insert item select 'CF8DFD6A-6D21-4A23-AAD1-8D96F59054DE',1,null,2197 ;
insert item select '75E5BEB9-742B-4E3E-8479-E7622C66F3B0',1,null,2197 ;
insert item select 'B8047301-3068-4782-84B6-9ECDCA0B880D',1,null,2197 ;
insert item select '7D6144B0-32AB-4028-9818-E377C3963CF2',1,null,2197 ;
insert item select 'FFBA9A9F-510F-4318-B4D3-DE4E86318D42',1,null,2197 ;
insert item select 'D217897C-2E7A-4B35-B36A-DD7FA996BB62',1,null,2197 ;
insert item select '648D2EF5-2CE4-46E3-8739-87924D23AC22',1,null,2197 ;
insert item select 'C75AC95B-EE30-4C44-8630-99894968C764',1,null,2197 ;
insert item select 'A49801BB-1FD5-4D25-ADB7-0F36E5D6A073',1,null,2197 ;
insert item select 'E2F70025-CD20-46E3-BBD8-422968F4683D',1,null,2197 ;
insert item select 'AD1B3658-6960-4EF6-A20B-FDE100343834',1,null,2197 ;
insert item select 'CE055852-A96F-4BF0-974E-585E655C323E',1,null,2197 ;
insert item select 'A0DDFDE5-3D84-4FBA-93E3-FB7C5FB90D47',1,null,2197 ;
insert item select '874CEAAB-32D7-425B-B8E3-BB6855154647',1,null,2197 ;
insert item select '8FE2CA8E-12F7-426E-89E1-A2657E860BA7',1,null,2197 ;
insert item select '419A4D47-A8DE-4996-B65B-CFED92CA6422',1,null,2197 ;
insert item select '1F90D6D5-59A9-46CA-A700-89C865EF2B40',1,null,2197 ;
insert item select '6F562E2C-EC56-406D-836A-76729AA713DB',1,null,2197 ;
insert item select '61A5A9E9-958C-4331-8460-566F9E53A2A6',1,null,2197 ;
insert item select '8D4C1C00-EFC7-4DC3-A6D8-B0C25A30EF30',1,null,2197 ;
insert item select '85C669DA-EB7D-42D8-AFA1-A44AB146DE13',1,null,2197 ;
insert item select '119E39F4-7479-4A6F-A6D3-F48AC7471C59',1,null,2197 ;
insert item select '34D95758-C7EF-4463-8220-E52BD4ABFC68',1,null,2197 ;
insert item select 'F1F70C53-3387-4773-9377-D2A48446B112',1,null,2197 ;
insert item select 'E342A23A-1148-4A1B-865F-61D5C0D56C7E',1,null,2197 ;
insert item select 'FE691101-BE5D-43C4-8F07-8188BFB65041',1,null,2197 ;
insert item select 'CCDF9E0B-375C-4643-A8EC-05CC1FBCDAFC',1,null,2197 ;
insert item select 'CA505579-E0FD-49D6-AB05-18F2A9F90313',1,null,2197 ;
insert item select '51A6EF10-6D20-40F6-A063-B2FAC23F5BFD',1,null,2197 ;



--MENTEZ
insert item select 'C3A4B6DDBF1242',1,null,2198 ;
insert item select 'AF8218089DD64D',1,null,2198 ;
insert item select '5DB439DCFE9845',1,null,2198 ;
insert item select 'C4E9F46DC18C47',1,null,2198 ;
insert item select '40797F9B21EF43',1,null,2198 ;
insert item select 'C28E369A9B384F',1,null,2198 ;
insert item select 'B537A73F50F246',1,null,2198 ;
insert item select '4D7170BB52E344',1,null,2198 ;
insert item select '5659F4FDE29F47',1,null,2198 ;
insert item select '2F450B77A42646',1,null,2198 ;
insert item select '5CE710483E224B',1,null,2198 ;
insert item select '37E86620716F41',1,null,2198 ;
insert item select '375D55A53E3943',1,null,2198 ;
insert item select 'CFC5B1B28D9841',1,null,2198 ;
insert item select '3B877181667D46',1,null,2198 ;
insert item select '94DDBC3D275242',1,null,2198 ;
insert item select 'CD13130070AD45',1,null,2198 ;
insert item select 'FBD80CBA9AEB40',1,null,2198 ;
insert item select '98FFC2F55AAF40',1,null,2198 ;
insert item select '42ABB214902D43',1,null,2198 ;
insert item select 'D249816BEC4941',1,null,2198 ;
insert item select '0DB8D20BF39A45',1,null,2198 ;
insert item select 'AB9A1A1B9DA44E',1,null,2198 ;
insert item select 'E8359B49DDEF4A',1,null,2198 ;
insert item select '63714B3BA88041',1,null,2198 ;
insert item select 'B9CBA10420E346',1,null,2198 ;
insert item select '52B9C88EF5C747',1,null,2198 ;
insert item select 'F0E6C0BF239F4A',1,null,2198 ;
insert item select 'BB851170C6EC4C',1,null,2198 ;
insert item select 'DF988C30923044',1,null,2198 ;
insert item select 'D3F02B94CEA645',1,null,2198 ;
insert item select '8B353AF372234F',1,null,2198 ;
insert item select 'E7024FC1539C44',1,null,2198 ;
insert item select '2C67D7AABC0148',1,null,2198 ;
insert item select 'FBE18B9F264E44',1,null,2198 ;
insert item select '1EC7BE9E7EB24D',1,null,2198 ;
insert item select '81247F7537C84D',1,null,2198 ;
insert item select '664CC3CD694F4E',1,null,2198 ;
insert item select '9543B295EAFA44',1,null,2198 ;
insert item select 'F56D9058543F40',1,null,2198 ;
insert item select '92F7A63232D240',1,null,2198 ;
insert item select '2CC47EF1892942',1,null,2198 ;
insert item select '597A4A1F47BF41',1,null,2198 ;
insert item select '505DF1CDA05749',1,null,2198 ;
insert item select '5F8AC178DB9149',1,null,2198 ;
insert item select '0FF87998B3A74E',1,null,2198 ;
insert item select '050094E31CB94C',1,null,2198 ;
insert item select '069A38496F7E42',1,null,2198 ;
insert item select '1E4F9E92CD1346',1,null,2198 ;
insert item select '38401367965F4B',1,null,2198 ;
insert item select '97845574CACF42',1,null,2198 ;
insert item select 'A6A6D468D16241',1,null,2198 ;
insert item select '77FE3E025D0542',1,null,2198 ;
insert item select 'C9BA1728829245',1,null,2198 ;
insert item select '89B589DBDC3E40',1,null,2198 ;
insert item select 'DC270EF4C8F74F',1,null,2198 ;
insert item select '9DC87BEFC12747',1,null,2198 ;
insert item select '1EEE46AB28744D',1,null,2198 ;
insert item select '5AEB21EFFD664C',1,null,2198 ;
insert item select '1F9CC294269648',1,null,2198 ;
insert item select 'D02DFA9366024B',1,null,2198 ;
insert item select 'C50FB2740D5B4C',1,null,2198 ;
insert item select '25AA6D9A0FD342',1,null,2198 ;
insert item select '5877FD1DBAE649',1,null,2198 ;
insert item select 'FE12A7027C704A',1,null,2198 ;
insert item select 'A3E9586AE4E04D',1,null,2198 ;
insert item select '8A37A811B9CF40',1,null,2198 ;
insert item select '9171D7DF34CB47',1,null,2198 ;
insert item select 'E7E3EEC6D9A64E',1,null,2198 ;
insert item select '7E0CC2CD749247',1,null,2198 ;
insert item select '1E5CCCDE66F14C',1,null,2198 ;
insert item select '9AAA708E203C43',1,null,2198 ;
insert item select 'A0E988BEA7D849',1,null,2198 ;
insert item select '3634F9FC666543',1,null,2198 ;
insert item select '6789744676EE49',1,null,2198 ;
insert item select '9FEC4D79B1984D',1,null,2198 ;
insert item select '616748935EF84A',1,null,2198 ;
insert item select '43724F434AEF44',1,null,2198 ;
insert item select '8A48DEE5373348',1,null,2198 ;
insert item select '322C6FB1BEF548',1,null,2198 ;
insert item select '57E2DABC274841',1,null,2198 ;
insert item select 'D8337942B5EE4B',1,null,2198 ;
insert item select '98F587D53D894C',1,null,2198 ;
insert item select 'BBF2BF2B745341',1,null,2198 ;
insert item select '22208F61DB1E47',1,null,2198 ;
insert item select '722A388DDC384B',1,null,2198 ;
insert item select '68EE0CB5692442',1,null,2198 ;
insert item select 'DD50ABF0FE534F',1,null,2198 ;
insert item select '1FC2FE915B5E4A',1,null,2198 ;
insert item select 'BFB4EF9E9C5A45',1,null,2198 ;
insert item select 'C14D947A518B4E',1,null,2198 ;
insert item select 'C13CB649FE8A47',1,null,2198 ;
insert item select 'A03B415331104F',1,null,2198 ;
insert item select '467B45F11CB44C',1,null,2198 ;
insert item select 'D8E8178E314140',1,null,2198 ;
insert item select '809741AE40E24A',1,null,2198 ;
insert item select '5C86D36F9C0F4D',1,null,2198 ;
insert item select '1C0A77D2A3C743',1,null,2198 ;
insert item select 'C6D5D345952C44',1,null,2198 ;
insert item select 'A79C52007EF748',1,null,2198 ;
insert item select 'C9D4B545A82E43',1,null,2198 ;
insert item select 'CD44BD975C6F4C',1,null,2198 ;
insert item select 'A44B1EA0EE2B47',1,null,2198 ;
insert item select '95F302E4D28E41',1,null,2198 ;
insert item select '5961A10B942546',1,null,2198 ;
insert item select '302E543C99F748',1,null,2198 ;
insert item select '6CB6517CD92044',1,null,2198 ;
insert item select 'E3A83D238AA446',1,null,2198 ;
insert item select '98FAE19FBF3847',1,null,2198 ;
insert item select '8F9B4EFA6F5947',1,null,2198 ;
insert item select '6179F39E878B4D',1,null,2198 ;
insert item select '74DF2415A80248',1,null,2198 ;
insert item select '81134DF497F547',1,null,2198 ;
insert item select 'D6BDDA8A04E943',1,null,2198 ;
insert item select '985FCE9922F044',1,null,2198 ;
insert item select 'A1FCD7B166ED48',1,null,2198 ;
insert item select '11687A349B1540',1,null,2198 ;
insert item select '8A1085745B4E4A',1,null,2198 ;
insert item select '4515FA4BFDEB4F',1,null,2198 ;
insert item select '9D9E68AF4D6647',1,null,2198 ;
insert item select '45BAFD00769B46',1,null,2198 ;
insert item select 'DA7B5938BF2A49',1,null,2198 ;
insert item select 'A581B87D8D974F',1,null,2198 ;
insert item select 'CB013104EC6443',1,null,2198 ;
insert item select '97D20E5292FF4A',1,null,2198 ;
insert item select 'A43EC882B5574A',1,null,2198 ;
insert item select '1F8E690F9AA844',1,null,2198 ;
insert item select '5700346CE9104A',1,null,2198 ;
insert item select '0000D4D6A75340',1,null,2198 ;
insert item select 'F93B6088E0EC4A',1,null,2198 ;
insert item select 'F71046B06D4E43',1,null,2198 ;
insert item select '0891506E32D346',1,null,2198 ;
insert item select 'AA7C3024808E49',1,null,2198 ;
insert item select '741D9232DFCA4F',1,null,2198 ;
insert item select '8454E0BB4A3F4B',1,null,2198 ;
insert item select '2CA0C3144BDE40',1,null,2198 ;
insert item select '3E6B2D5A136F46',1,null,2198 ;
insert item select 'F628B8001EF140',1,null,2198 ;
insert item select '3322FD21E61345',1,null,2198 ;
insert item select 'ED19C479B2714E',1,null,2198 ;
insert item select '6C866A157A534E',1,null,2198 ;
insert item select 'DA2C707F49474E',1,null,2198 ;
insert item select '393D8F7572914F',1,null,2198 ;
insert item select 'D69AD687F12749',1,null,2198 ;
insert item select '60B378D2C8F540',1,null,2198 ;
insert item select '4679DA9718D344',1,null,2198 ;
insert item select 'C7C33E32B21A47',1,null,2198 ;
insert item select 'AA797DEBCD2D4B',1,null,2198 ;
insert item select '69299C0F772640',1,null,2198 ;
insert item select 'F3D6D29B400741',1,null,2198 ;
insert item select 'A184AB1856264A',1,null,2198 ;
insert item select 'EEF92D265FE945',1,null,2198 ;
insert item select '713220869FCB4D',1,null,2198 ;
insert item select 'F3FF86FD4A3A4C',1,null,2198 ;
insert item select '6C1A55B1D08A44',1,null,2198 ;
insert item select '51EE5ECC7B3844',1,null,2198 ;
insert item select '1D4A6005D5A04C',1,null,2198 ;
insert item select '51D4418379574A',1,null,2198 ;
insert item select 'DC507391486F45',1,null,2198 ;
insert item select '9B6D87CCFE8541',1,null,2198 ;
insert item select '696B44A6118943',1,null,2198 ;
insert item select '96858947C6714C',1,null,2198 ;
insert item select '1E4F0DE80E4A43',1,null,2198 ;
insert item select '7CA23D8FEE9344',1,null,2198 ;
insert item select '28511A6E3C4249',1,null,2198 ;
insert item select 'DBE2F481A02E4F',1,null,2198 ;
insert item select '8DB39C95E45149',1,null,2198 ;
insert item select '7EADB57860904F',1,null,2198 ;
insert item select 'FEE50B97A56C47',1,null,2198 ;
insert item select '32064EF26F2249',1,null,2198 ;
insert item select '87375A66E41F42',1,null,2198 ;
insert item select '70D58975004E47',1,null,2198 ;
insert item select 'BAC724B753F848',1,null,2198 ;
insert item select '8FC2C58FCF514C',1,null,2198 ;
insert item select '286F8BDE0E2A49',1,null,2198 ;
insert item select 'DC8491A1D80B49',1,null,2198 ;
insert item select '1F4CB9AEF50A4D',1,null,2198 ;
insert item select 'E8C7279F733645',1,null,2198 ;
insert item select '59CC134970B847',1,null,2198 ;
insert item select '4AB3457CFFCA49',1,null,2198 ;
insert item select 'D1B9815ECF964C',1,null,2198 ;
insert item select '0E7DDA53B8674C',1,null,2198 ;
insert item select '601544DB857742',1,null,2198 ;
insert item select '0E2EFD47DF1B4C',1,null,2198 ;
insert item select 'F4340B7375244D',1,null,2198 ;
insert item select 'CF8AE6E684BF4C',1,null,2198 ;
insert item select 'ABAA4CFC168743',1,null,2198 ;
insert item select '35281246ABAB46',1,null,2198 ;
insert item select '47B1966F4A6D42',1,null,2198 ;
insert item select '462578EA14A646',1,null,2198 ;
insert item select '802074D78A2D48',1,null,2198 ;
insert item select 'FA99594AF65441',1,null,2198 ;
insert item select '9A2E0F2AE2444C',1,null,2198 ;
insert item select '29083047F56845',1,null,2198 ;
insert item select '92FD3870B5724D',1,null,2198 ;
insert item select 'F93D4A66EE8344',1,null,2198 ;
insert item select '1FF7E39560C54B',1,null,2198 ;
insert item select '2E4D0E36EE9C4B',1,null,2198 ;
insert item select 'B9565ABB2D5B40',1,null,2198 ;
insert item select '0C80E923EF9842',1,null,2198 ;
insert item select '04019165128744',1,null,2198 ;
insert item select '848DCF128F9A40',1,null,2198 ;
insert item select '2E904A859F1843',1,null,2198 ;
insert item select '8EFBD81871B748',1,null,2198 ;
insert item select '7DB6B0CB1C2148',1,null,2198 ;
insert item select '55D5F7B9545D47',1,null,2198 ;
insert item select '2EC4F98AA23546',1,null,2198 ;
insert item select '9789C4D4A28A47',1,null,2198 ;
insert item select '2C49A17F7D4542',1,null,2198 ;
insert item select '2C9B2E54D3674F',1,null,2198 ;
insert item select 'C9305253E81C4C',1,null,2198 ;
insert item select '78DE9B7791AA40',1,null,2198 ;
insert item select '10408C7B99E84F',1,null,2198 ;
insert item select '4EA84E73C84841',1,null,2198 ;
insert item select '64090555287645',1,null,2198 ;
insert item select '2E21F253AF8C40',1,null,2198 ;
insert item select '505AACE2E57C49',1,null,2198 ;
insert item select 'DF534F1AA36D45',1,null,2198 ;
insert item select 'E91D32D92DC242',1,null,2198 ;
insert item select 'FFC435CEC0D946',1,null,2198 ;
insert item select '4D47A9C92A3E4A',1,null,2198 ;
insert item select '2ED669ED1EAB48',1,null,2198 ;
insert item select '6336915E858C41',1,null,2198 ;
insert item select '1EF4033CAB8845',1,null,2198 ;
insert item select 'FF758C4DD08641',1,null,2198 ;
insert item select 'A2696431BA9B4E',1,null,2198 ;
insert item select '393ACC428DCE48',1,null,2198 ;
insert item select '5AF13DE976AF48',1,null,2198 ;
insert item select '1483A0DEFF464F',1,null,2198 ;
insert item select '4B2669C3F7D44C',1,null,2198 ;
insert item select 'FAB90E45CF3A49',1,null,2198 ;
insert item select '065D67BCAC024F',1,null,2198 ;
insert item select 'A043718FED0F4B',1,null,2198 ;
insert item select '445E11C8725D4B',1,null,2198 ;
insert item select '36837F606A4A43',1,null,2198 ;
insert item select '19768B4B9BF74A',1,null,2198 ;
insert item select '9DB24195DC9540',1,null,2198 ;
insert item select '79692D99943647',1,null,2198 ;
insert item select 'DC8CD8276E2544',1,null,2198 ;
insert item select '718315063B2A40',1,null,2198 ;
insert item select '697D3BA2A68840',1,null,2198 ;
insert item select '9376D9A9183B4D',1,null,2198 ;
insert item select 'D7966DE0A6E747',1,null,2198 ;
insert item select '8D93A5657AE64E',1,null,2198 ;
insert item select '2C98B407F70841',1,null,2198 ;
insert item select '66934E3BA9954C',1,null,2198 ;
insert item select 'F7E6C79E235A4C',1,null,2198 ;
insert item select '0FFE5D9E76F24F',1,null,2198 ;
insert item select '085997D60FB04E',1,null,2198 ;
insert item select 'BABB7E0280474D',1,null,2198 ;
insert item select 'D5898CDD426D43',1,null,2198 ;
insert item select '24B0097A756941',1,null,2198 ;
insert item select '2A586C80D6DF4A',1,null,2198 ;
insert item select 'B5CE487A402A4D',1,null,2198 ;
insert item select 'DD17451CE2A84A',1,null,2198 ;
insert item select '1E97AD71450747',1,null,2198 ;
insert item select 'B2B297413D874E',1,null,2198 ;
insert item select '384625C7F75042',1,null,2198 ;
insert item select '4C257F0184BC47',1,null,2198 ;
insert item select '32F77C41955347',1,null,2198 ;
insert item select '4F3062F0FC3540',1,null,2198 ;
insert item select '9EA668375BFA4F',1,null,2198 ;
insert item select '00F4C3F6658948',1,null,2198 ;
insert item select '31D79183A4924E',1,null,2198 ;
insert item select '95E31E33FF4E4F',1,null,2198 ;
insert item select 'AFC69C9CEE0D46',1,null,2198 ;
insert item select '2B36B816489747',1,null,2198 ;
insert item select '6D7B456EB87647',1,null,2198 ;
insert item select '94B18436A7314C',1,null,2198 ;
insert item select 'CC1A30EE2C4C4D',1,null,2198 ;
insert item select 'CC4F174C14AC46',1,null,2198 ;
insert item select 'A9508BADDDC445',1,null,2198 ;
insert item select '676A8110406540',1,null,2198 ;
insert item select 'BC9C04E18A9247',1,null,2198 ;
insert item select 'C7F9408D1A5E48',1,null,2198 ;
insert item select '8FD808A68C7842',1,null,2198 ;
insert item select '18D9D8EF335C47',1,null,2198 ;
insert item select '67F32C34BDBC41',1,null,2198 ;
insert item select '74F9C209EFFB42',1,null,2198 ;
insert item select 'E8E88D6E8C7642',1,null,2198 ;
insert item select 'FE064E8641C04D',1,null,2198 ;
insert item select '102DF6AC232A45',1,null,2198 ;
insert item select '7AFA97FCF24B41',1,null,2198 ;
insert item select '9785D654C77A4B',1,null,2198 ;
insert item select 'ECACF46893C040',1,null,2198 ;
insert item select '5F53A6EACDDE42',1,null,2198 ;
insert item select '068CCAE4F27046',1,null,2198 ;
insert item select '21590EB1542D4D',1,null,2198 ;
insert item select 'F0ADA84C09BC44',1,null,2198 ;
insert item select 'B5081753F9DC48',1,null,2198 ;
insert item select '53E47DEBA2C44B',1,null,2198 ;
insert item select 'FE4B0A1A3BC744',1,null,2198 ;
insert item select 'B780FE9A9E8A4A',1,null,2198 ;
insert item select '92A610DF1FD347',1,null,2198 ;
insert item select '6C74992C5AB24D',1,null,2198 ;
insert item select '92A610DF1FD347',1,null,2198 ;
insert item select '4F45317EEE5743',1,null,2198 ;
insert item select '4587A8E220A344',1,null,2198 ;
insert item select 'B5FB1D4D570E41',1,null,2198 ;
insert item select '5C871857DDEC4D',1,null,2198 ;
insert item select 'C363640377C546',1,null,2198 ;
insert item select '13A51A9AF36044',1,null,2198 ;
insert item select '520F0C0BBCDD4C',1,null,2198 ;
insert item select 'C229D839965A45',1,null,2198 ;
insert item select '9227FB7ADD814D',1,null,2198 ;
insert item select 'B281C4500CFD41',1,null,2198 ;
insert item select '2D3B9CCABF1D4B',1,null,2198 ;
insert item select 'E8C8AC07367C43',1,null,2198 ;
insert item select '3D84B6C6F2804D',1,null,2198 ;
insert item select '385C2B096FF24B',1,null,2198 ;
insert item select '7C4E9DA3396448',1,null,2198 ;
insert item select '527F15D53D344A',1,null,2198 ;
insert item select 'E63FB900F4CF4D',1,null,2198 ;
insert item select 'E9BB9C8FA04F45',1,null,2198 ;
insert item select 'A5E76A87FA244A',1,null,2198 ;
insert item select '803189CE5A2944',1,null,2198 ;
insert item select 'BAC8998F95144C',1,null,2198 ;
insert item select 'D6688ADB1D8142',1,null,2198 ;
insert item select 'E4E60B272CB543',1,null,2198 ;
insert item select '71437147DA734C',1,null,2198 ;
insert item select 'E118C3C81FCE4B',1,null,2198 ;
insert item select 'C7E52159F27E4F',1,null,2198 ;
insert item select '70250D7A6F2247',1,null,2198 ;
insert item select '9B6EF3E516D943',1,null,2198 ;
insert item select 'F187590EBC4748',1,null,2198 ;
insert item select '1C5C7A07C9A54A',1,null,2198 ;
insert item select 'D372141E74EB4C',1,null,2198 ;
insert item select 'FE9F2B91E5AC47',1,null,2198 ;
insert item select 'B7B3317A13DA4E',1,null,2198 ;
insert item select 'A569FB68A99547',1,null,2198 ;
insert item select 'FE121474151547',1,null,2198 ;
insert item select '48DE0DDE041241',1,null,2198 ;
insert item select 'F9A6FA482B1244',1,null,2198 ;
insert item select 'D4BAB12CABD045',1,null,2198 ;
insert item select 'F3A61360E0674E',1,null,2198 ;
insert item select 'A80F478043D445',1,null,2198 ;
insert item select '01BE4EC4404C46',1,null,2198 ;
insert item select 'B45F730E6DFE40',1,null,2198 ;
insert item select 'CC62993BC04C47',1,null,2198 ;
insert item select '7E8FF1206CBE4B',1,null,2198 ;
insert item select 'E4E42CD425E641',1,null,2198 ;
insert item select '4EF186ADC77B4E',1,null,2198 ;
insert item select '829A0E5F427C42',1,null,2198 ;
insert item select '2623BF80611641',1,null,2198 ;
insert item select 'BFEE5007A09E4D',1,null,2198 ;
insert item select '6AC8D91047C646',1,null,2198 ;
insert item select 'CEFADE4F5DCC4E',1,null,2198 ;
insert item select '46B255E04EFA44',1,null,2198 ;
insert item select '823B67A43C5042',1,null,2198 ;
insert item select '2CDDEBD3005348',1,null,2198 ;
insert item select '4C49392D51F148',1,null,2198 ;
insert item select '4A7E9697518E45',1,null,2198 ;
insert item select '7007466266314E',1,null,2198 ;
insert item select 'E9E36166B81B43',1,null,2198 ;
insert item select '68EEBA0BF3EF47',1,null,2198 ;
insert item select 'E86804A528BC4B',1,null,2198 ;
insert item select 'E173A54B4B2C4C',1,null,2198 ;
insert item select 'C041964295D146',1,null,2198 ;
insert item select '2ED15DDDFBE443',1,null,2198 ;
insert item select '0CD194A1CFA84C',1,null,2198 ;
insert item select '1804E371E2C943',1,null,2198 ;
insert item select 'FDCF8D7011584C',1,null,2198 ;
insert item select '5331BBFE2B8C46',1,null,2198 ;
insert item select '7D3A7C340E9547',1,null,2198 ;
insert item select 'A8FF5EDBA9F347',1,null,2198 ;
insert item select '90E5D271811947',1,null,2198 ;
insert item select 'CC6226C6D0F24F',1,null,2198 ;
insert item select '924B095E2CC343',1,null,2198 ;
insert item select '3808E4101ADD49',1,null,2198 ;
insert item select '87697C9A060B46',1,null,2198 ;
insert item select '5E8B60731BD044',1,null,2198 ;
insert item select '1318CE3859AA4D',1,null,2198 ;
insert item select 'F5D87C1C2F7B4C',1,null,2198 ;
insert item select 'B0372F8E2BA447',1,null,2198 ;
insert item select '51AF1BFC31E34B',1,null,2198 ;
insert item select '8DFD902DB80C4B',1,null,2198 ;
insert item select '4BBAD25CEC7142',1,null,2198 ;
insert item select 'E5FE83EA5A4943',1,null,2198 ;
insert item select '17BD45D3023940',1,null,2198 ;
insert item select '0DEF422655204A',1,null,2198 ;
insert item select '5869FC5316D34D',1,null,2198 ;
insert item select '4DB742F4516D45',1,null,2198 ;
insert item select '00352ADC6F7F45',1,null,2198 ;
insert item select '41322C67E9954D',1,null,2198 ;
insert item select '04789FBF391B45',1,null,2198 ;
insert item select '1DF3E8114A5A44',1,null,2198 ;
insert item select '565701C373B844',1,null,2198 ;
insert item select '82981AE52D8841',1,null,2198 ;
insert item select 'D72A2B22A19A47',1,null,2198 ;
insert item select 'CCFF0DF26C2B4F',1,null,2198 ;
insert item select 'DC43FB0D73FA4D',1,null,2198 ;
insert item select '81A0F64C2C6F4B',1,null,2198 ;
insert item select 'DE138DA215874B',1,null,2198 ;
insert item select '1C411EA1DEB24A',1,null,2198 ;
insert item select '950ABF3CE8624B',1,null,2198 ;
insert item select 'DF54529FDE2D49',1,null,2198 ;
insert item select '83282A7992A44F',1,null,2198 ;
insert item select '03F7F917BF234E',1,null,2198 ;
insert item select '0BBE5AF496704A',1,null,2198 ;
insert item select 'BD8FA4144BF848',1,null,2198 ;
insert item select 'A24F111DE2E24E',1,null,2198 ;
insert item select '9663C1C73D9D4A',1,null,2198 ;
insert item select 'C6F378C7B7D04B',1,null,2198 ;
insert item select 'FB991D966CA64F',1,null,2198 ;
insert item select '58D01D963A2B4B',1,null,2198 ;
insert item select '7DCDCAEF42684E',1,null,2198 ;
insert item select '0B2B41AA0ECF4C',1,null,2198 ;
insert item select '38B30B23946441',1,null,2198 ;
insert item select '23D00032839547',1,null,2198 ;
insert item select '594D9EAD2B2945',1,null,2198 ;
insert item select '47022AC77E624C',1,null,2198 ;
insert item select '1FA1801A839240',1,null,2198 ;
insert item select '905718C089884A',1,null,2198 ;
insert item select '062BD672244E45',1,null,2198 ;
insert item select 'AD1FCD12B97143',1,null,2198 ;
insert item select '4A13671948C540',1,null,2198 ;
insert item select 'B437EC4947F548',1,null,2198 ;
insert item select '753D2709163A4A',1,null,2198 ;
insert item select '9746958A77D442',1,null,2198 ;
insert item select '7900DAC936A04A',1,null,2198 ;
insert item select '3400B203051C4B',1,null,2198 ;
insert item select '23FB2EB582E54D',1,null,2198 ;
insert item select 'C42A7CDA6AFA42',1,null,2198 ;
insert item select '519E3526551A45',1,null,2198 ;
insert item select '084B00DBC28049',1,null,2198 ;
insert item select 'AEAC54E9176A46',1,null,2198 ;
insert item select '1C28792FCE2745',1,null,2198 ;
insert item select 'B7998E468A2642',1,null,2198 ;
insert item select 'DB0A11D490C844',1,null,2198 ;
insert item select 'C1647EAF91CE46',1,null,2198 ;
insert item select '889BA1CADA4C4D',1,null,2198 ;
insert item select '7ED10C8620D241',1,null,2198 ;
insert item select 'E2FB98EAD3FA44',1,null,2198 ;
insert item select '1C1D14AB409646',1,null,2198 ;
insert item select '0F5A2C52C32F41',1,null,2198 ;
insert item select '9362ED069B4E44',1,null,2198 ;
insert item select '76F9D21B421449',1,null,2198 ;
insert item select '01AD65F92D1A46',1,null,2198 ;
insert item select 'BE204FA7A69942',1,null,2198 ;
insert item select '9C02D952D6DB46',1,null,2198 ;
insert item select 'AEFC6DA004DD41',1,null,2198 ;
insert item select 'EA74FB96EE644F',1,null,2198 ;
insert item select '614BCBA4FAE348',1,null,2198 ;
insert item select 'C2B88579C03D44',1,null,2198 ;
insert item select '60700A28E5D648',1,null,2198 ;
insert item select '0601BB96770E49',1,null,2198 ;
insert item select '58335DDC7F3A49',1,null,2198 ;
insert item select '63F998A94BE849',1,null,2198 ;
insert item select '96266D22412140',1,null,2198 ;
insert item select '92497D9FEFEA4F',1,null,2198 ;
insert item select '644AB7638F3649',1,null,2198 ;
insert item select '7060A1D3D6D145',1,null,2198 ;
insert item select '8F5F66BA713449',1,null,2198 ;
insert item select 'F8FDADB00A9C45',1,null,2198 ;
insert item select '331BDE9E56BC49',1,null,2198 ;
insert item select '78E61A80205D44',1,null,2198 ;
insert item select '69E6F63D51164C',1,null,2198 ;
insert item select '3B6C0047350942',1,null,2198 ;
insert item select 'FD024E99613343',1,null,2198 ;
insert item select '6976FC6A2E314F',1,null,2198 ;
insert item select 'C694333C00CE46',1,null,2198 ;
insert item select 'A1074253DC454E',1,null,2198 ;
insert item select 'C36E709B145248',1,null,2198 ;
insert item select 'F43707EB619E4E',1,null,2198 ;
insert item select '01C11E9917384C',1,null,2198 ;
insert item select '89223E47F2F449',1,null,2198 ;
insert item select 'B8E1C025CB6340',1,null,2198 ;
insert item select '7E11C9DD84404A',1,null,2198 ;
insert item select '68A25EBCA54D43',1,null,2198 ;
insert item select '2DCE8F502E0C43',1,null,2198 ;
insert item select '367FBDE2B7344D',1,null,2198 ;
insert item select '3F5F6F1F639E45',1,null,2198 ;
insert item select '1944612DABE643',1,null,2198 ;
insert item select '0BCBA25F395F4C',1,null,2198 ;
insert item select 'E0C9C38D68414F',1,null,2198 ;
insert item select '2B54673EC71F4C',1,null,2198 ;
insert item select '4D06C1265C2E47',1,null,2198 ;
insert item select '5226617035084F',1,null,2198 ;
insert item select '49A89790203444',1,null,2198 ;
insert item select '9449D758EA7045',1,null,2198 ;
insert item select '3FD7A1DC20F448',1,null,2198 ;
insert item select 'BD7C953558BB44',1,null,2198 ;
insert item select '575A63C043CD42',1,null,2198 ;
insert item select '1C4C3FA0D9A642',1,null,2198 ;
insert item select '5B2BB6A03C5D4F',1,null,2198 ;
insert item select '66A6039B0AE54B',1,null,2198 ;
insert item select '301AA059A84348',1,null,2198 ;
insert item select '7D87BB28636F4E',1,null,2198 ;
insert item select 'ADAE1EDB75FC4D',1,null,2198 ;
insert item select '9B4E526632264C',1,null,2198 ;
insert item select 'A6FC11DEE6644C',1,null,2198 ;
insert item select 'D1DDB206000B49',1,null,2198 ;
insert item select 'A7B1DDB3196A40',1,null,2198 ;
insert item select '92BFD2E383B347',1,null,2198 ;
insert item select '35B492B6C31147',1,null,2198 ;
insert item select 'CEC008CF0EAC44',1,null,2198 ;
insert item select '80104C39E20849',1,null,2198 ;
insert item select 'B75B0344D92745',1,null,2198 ;
insert item select 'E654899082D942',1,null,2198 ;
insert item select '1F7BE64C205043',1,null,2198 ;

go


create proc sp_dba_alertaCupom
@minimo int = 5
as
begin
set nocount on

declare @tab table (recompensaId smallint, nome tddesc,qtd int)

insert @tab
select r.id,r.nome, COUNT(*)
from Item i (nolock)
join Recompensa r (nolock) on i.recompensaId = r.id
where 
r.tipoRecompensaId = 2 --Cupom
and i.dataHoraUtilizacao is null
group by  r.id,r.nome
having COUNT(*) <= @minimo

if @@ROWCOUNT > 0 --Tem problema
begin

declare @min smallint, @max smallint, @qtd varchar(5), @corpoEmail nvarchar(1000) = 'Recompensas com poucos cupons disponiveis: '
select @min = MIN(recompensaid), @max = MAX(recompensaid) from @tab

while @min <= @max
begin
select @corpoEmail = @corpoEmail + '//'+ nome +': ' +CONVERT(nvarchar(5),qtd)+' itens '
from @tab where recompensaid = @min

select @min = MIN(recompensaid) from @tab where recompensaId > @min
end --While 

declare @subj nchar(255)
select @subj = 'PSafe Digital Codes Alert: '+CONVERT(char(20),getdate())

exec msdb.dbo.sp_send_dbmail  @profile_name = 'bdNotifier',
@recipients = 'rodrigo@grupoxango.com',
@body = @corpoEmail,
@subject=  @subj,
@body_format= 'HTML'



end --IF
end --proc
go


