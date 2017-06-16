create database NotaDb
go
use notaDb
go

create table FormaPagamento (
id tinyint identity(1,1) primary key,
nome tdsmalldesc not null)
go
insert FormaPagamento select 'Cartão'
insert FormaPagamento select 'Boleto'
go



create table SituacaoLoteRps (
id tinyint identity(1,1) primary key,
nome tdsmalldesc not null)
go

create proc pr_SituacaoLoteRps_sel_nome
@nome tdsmalldesc
WITH EXECUTE AS OWNERASSET NOCOUNT ON
select * from SituacaoLoteRps (nolock)  where nome = @nome
go

create table LoteRps (
id int identity(1,1) primary key,
protocolo varchar(50)  null,
dataHora smalldatetime not null)
go
create index LoteRps_ID01 on LoteRps (protocolo) include (id)
go
create index LoteRps_ID02 on LoteRps (dataHora) include (id)
go
alter table loterps add dataHoraProcessado smalldatetime null
go
create index LoteRps_ID03 on LoteRps (dataHoraProcessado) include (id) where dataHoraProcessado is null
go

create proc pr_LoteRps_sel_SemSituacao_ComProtocolo
WITH EXECUTE AS OWNERASSET NOCOUNT ON
select * from loteRps l (nolock)  where protocolo is not null and not exists
(select 1 from HistSituacaoLoteRps h2 where l.id = h2.loteRpsId )
go



create proc pr_LoteRps_sel_SemProtocolo
WITH EXECUTE AS OWNERASSET NOCOUNT ON
select * from loteRps l (nolock)  where protocolo is null
go




create table HistSituacaoLoteRps (
id int identity(1,1) primary key,
situacaoLoteRpsId tinyint not null references SituacaoLoteRps,
loteRpsId int not null references LoteRps,
dataHora smalldatetime not null)
go
create index HistSituacaoLoteRps_ID01 on HistSituacaoLoteRps (situacaoLoteRpsId) include (id) 
go
create index HistSituacaoLoteRps_ID02 on HistSituacaoLoteRps (loteRpsId) include (id) 
go
create index HistSituacaoLoteRps_ID03 on HistSituacaoLoteRps (dataHora) include (id) 
go

create proc pr_LoteRps_sel_situacaoLoteRpsId
@situacaoLoteRpsId tinyint
WITH EXECUTE AS OWNERASSET NOCOUNT ON
select * 
from LoteRps l (nolock)  
join HistSituacaoLoteRps h2 on l.id = h2.loteRpsId and h2.situacaoLoteRpsId = @situacaoLoteRpsId 
where dataHoraProcessado is null  
and h2.datahora = (select max(dataHora) from HistSituacaoLoteRps h3 where h3.loteRpsId = h2.loteRpsId)
go





create proc pr_HistSituacaoLoteRps_sel_loteRpsId_Max
@loteRpsId int
WITH EXECUTE AS OWNERASSET NOCOUNT ON
select * from LoteRps (nolock)  where loteRpsId = @loteRpsId and
dataHora = (select max(dataHora) from HistSituacaoLoteRps where loteRpsId = @loteRpsId )
go


create proc pr_HistSituacaoLoteRps_sel_loteRpsId
@loteRpsId int
WITH EXECUTE AS OWNERASSET NOCOUNT ON
select * from HistSituacaoLoteRps (nolock)  where loteRpsId = @loteRpsId 
go




create table MensagemRetornoLoteRps (
id int identity (1,1) primary key,
loteRpsId int not null references loterps,
dataHora smalldatetime not null,
codigo tdsmalldesc not null,
mensagem tddesc not null,
correcao tddesc not null)
go
create index MensagemRetornoLoteRps_ID01 on MensagemRetornoLoteRps (loteRpsId) include (id)
go
create index MensagemRetornoLoteRps_ID02 on MensagemRetornoLoteRps (dataHora) include (id)
go
create index MensagemRetornoLoteRps_ID03 on MensagemRetornoLoteRps (codigo) include (id)
go

create proc pr_MensagemRetornoLoteRps_sel_loteRpsId
@loteRpsId int
WITH EXECUTE AS OWNERASSET NOCOUNT ON
select * from MensagemRetornoLoteRps (nolock)  where loteRpsId = @loteRpsId 
go

create table Compra (
id int identity(1,1) primary key,
clienteId int not null,
dataHora smalldatetime not null,
dataConfPagamento smalldatetime null)
go

create proc pr_Compra_sel_Pendente_formaPagamentoId
@formaPagamentoId tinyint
WITH EXECUTE AS OWNERASSET NOCOUNT ON

select * 
from compra (nolock)
where
formaPagamentoId = @formaPagamentoId and
dataHoraCancelamento is null and
dataConfPagamento is null
go

create proc pr_Compra_sel_Pendente_formaPagamentoId_clienteId
@formaPagamentoId tinyint, @clienteId int
WITH EXECUTE AS OWNERASSET NOCOUNT ON

select * 
from compra (nolock)
where clienteId = @clienteId and
formaPagamentoId = @formaPagamentoId and
dataHoraCancelamento is null and
dataConfPagamento is null
go


create index Compra_ID01 on compra (clienteId) include (id)
go
create index Compra_ID02 on compra (dataHora) include (id)
go
create index Compra_ID03 on compra (dataConfPagamento) include (id) where dataConfPagamento is not null 
go
alter table compra add planoId smallint not null
go
create index Compra_ID04 on compra (planoId) include (id) 
go
alter table compra add valor money null
go
alter table compra add dataHoraAutorizacao smalldatetime null
go
alter table compra add transacaoCieloId varchar(50) null
go
alter table compra add formaPagamentoId tinyint default 1 not null foreign key references formapagamento
go
alter table compra add dataHoraCancelamento smalldatetime null
go

create table HtmlBoleto (
id int identity(1,1) primary key,
compraId int not null references Compra,
html varchar(max) not null)
go 
create index HtmlBoleto_ID01 on HtmlBoleto (compraId)
go




alter proc pr_Compra_sem_Rps_Sel
WITH EXECUTE AS OWNERASSET NOCOUNT ON

select * from compra c (nolock)
where DataConfPagamento is not null and 
not exists (select 1 from rps r (nolock) where c.id = r.compraId)
go

create proc pr_Compra_Sel_notaId
@notaId int
WITH EXECUTE AS OWNERASSET NOCOUNT ON

select c.* 
from compra c (nolock)
join rps r (nolock) on c.id = r.compraid
join nota n (nolock) on r.id = n.rpsId
where n.id = @notaId

go



create table Rps (
id int identity(1,1) primary key,
loteRpsId int not null references loterps,
compraId int not null references compra,
dataEmissao smalldatetime not null,
serie varchar(10) not null,
dataCancelamento smalldatetime null,
valorServico money)
go
create index Rps_ID01 on Rps (loteRpsId) include (id)
go
create index Rps_ID02 on Rps (compraid) include (id)
go
create index Rps_ID03 on Rps (dataemissao) include (id)
go
create index Rps_ID04 on Rps (serie) include (id)
go
create index Rps_ID05 on Rps (dataCancelamento) include (id) where dataCancelamento is not null
go



create proc pr_Rps_sel_loteRpsId
@loteRpsId int
WITH EXECUTE AS OWNERASSET NOCOUNT ON
select * from Rps (nolock)  where loteRpsId = @loteRpsId 
go


CREATE TYPE [dbo].[tdTabLote] AS TABLE(
	[id] int primary key)

GO

create proc pr_Rps_sel_loteRpsId_Table
@loteRps tdTabLote readonly
WITH EXECUTE AS OWNERASSET NOCOUNT ON
select * from Rps (nolock) r1
join @loteRps r2 on r1.loteRpsId = r2.id
go




create table Nota (
id int identity(1,1) primary key,
dataEmissao smalldatetime not null,
competencia smalldatetime not null,
numero varchar(15) not null,
valorServico money not null,
obs tddesc null,
substituida bit not null,
notaSubstitutaId int null references nota ,
dataCancelamento smalldatetime null)
go
create index Nota_ID01 on nota (dataEmissao) include (id)
go
create index Nota_ID02 on nota (numero) include (id)
go
create index Nota_ID03 on nota (notaSubstitutaId) include (id) where notaSubstitutaId is not null
go
create index Nota_ID04 on nota (dataCancelamento) include (id) where dataCancelamento is not null
go

alter table Nota add rpsID int not null
go
create index Nota_ID05 on nota (rpsId) include (id) 
go
alter table Nota add verificacao varchar(50) not null
go

create table BoletoPagoCompraCancelada (
id int identity(1,1) primary key,
compraId int not null foreign key references compra,
dataHora smalldatetime null)
go

create index BoletoPagoCompraCancelada_ID01 on BoletoPagoCompraCancelada (compraId)
go


create proc pr_BoletoPagoCompraCancelada_sel_compraId
@compraId int
WITH EXECUTE AS OWNERASSET NOCOUNT ON

select * 
from BoletoPagoCompraCancelada (nolock)
where compraID = @compraId 
go





alter table Nota add aliquota dec (5,2) null;
alter table Nota add baseCalculo money null;
alter table Nota add descontoCondicionado dec (5,2) null;
alter table Nota add descontoIncondicionado dec (5,2) null;
alter table Nota add issRetido dec (5,2) null;
alter table Nota add outrasRetencoes  money null;
alter table Nota add valorCofins money null;
alter table Nota add valorCsll money null;
alter table Nota add valorDeducoes money null;
alter table Nota add valorIr  money null;;
alter table Nota add valorIss money null;;
alter table Nota add valorIssRetido money null;;
alter table Nota add valorLiquidoNfse money null;;
alter table Nota add valorPis money null;;


create proc pr_Nota_Sel_compraId
@compraId int
WITH EXECUTE AS OWNERASSET NOCOUNT ON

select n.* 
from compra c (nolock)
join rps r (nolock) on c.id = r.compraid
join nota n (nolock) on r.id = n.rpsId
where c.id = @compraId

go



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