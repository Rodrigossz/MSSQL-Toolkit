USE [PsafeDb]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Agendamen__acess__1CDC41A7]') AND parent_object_id = OBJECT_ID(N'[dbo].[Agendamento]'))
ALTER TABLE [dbo].[Agendamento] DROP CONSTRAINT [FK__Agendamen__acess__1CDC41A7]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Agendamen__perio__1DD065E0]') AND parent_object_id = OBJECT_ID(N'[dbo].[Agendamento]'))
ALTER TABLE [dbo].[Agendamento] DROP CONSTRAINT [FK__Agendamen__perio__1DD065E0]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Scan__acessoId__1EC48A19]') AND parent_object_id = OBJECT_ID(N'[dbo].[Scan]'))
ALTER TABLE [dbo].[Scan] DROP CONSTRAINT [FK__Scan__acessoId__1EC48A19]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Scan__tipoScanId__1FB8AE52]') AND parent_object_id = OBJECT_ID(N'[dbo].[Scan]'))
ALTER TABLE [dbo].[Scan] DROP CONSTRAINT [FK__Scan__tipoScanId__1FB8AE52]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Scan__tipoScanId__23893F36]') AND parent_object_id = OBJECT_ID(N'[dbo].[Scan]'))
ALTER TABLE [dbo].[Scan] DROP CONSTRAINT [FK__Scan__tipoScanId__23893F36]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Scan__qtdVirus__20ACD28B]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Scan] DROP CONSTRAINT [DF__Scan__qtdVirus__20ACD28B]
END

GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__ScanArqui__scanI__21A0F6C4]') AND parent_object_id = OBJECT_ID(N'[dbo].[ScanArquivos]'))
ALTER TABLE [dbo].[ScanArquivos] DROP CONSTRAINT [FK__ScanArqui__scanI__21A0F6C4]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__ScanArqui__scanI__22951AFD]') AND parent_object_id = OBJECT_ID(N'[dbo].[ScanArquivos]'))
ALTER TABLE [dbo].[ScanArquivos] DROP CONSTRAINT [FK__ScanArqui__scanI__22951AFD]
GO

USE [PsafeDb]
GO

/****** Object:  Table [dbo].[TipoScan]    Script Date: 05/30/2011 17:40:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TipoScan]') AND type in (N'U'))
DROP TABLE [dbo].[TipoScan]
GO

/****** Object:  Table [dbo].[Agendamento]    Script Date: 05/30/2011 17:40:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Agendamento]') AND type in (N'U'))
DROP TABLE [dbo].[Agendamento]
GO

/****** Object:  Table [dbo].[Scan]    Script Date: 05/30/2011 17:40:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Scan]') AND type in (N'U'))
DROP TABLE [dbo].[Scan]
GO

/****** Object:  Table [dbo].[ScanArquivos]    Script Date: 05/30/2011 17:40:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ScanArquivos]') AND type in (N'U'))
DROP TABLE [dbo].[ScanArquivos]
GO

USE [PsafeDb]
GO

/****** Object:  Table [dbo].[TipoScan]    Script Date: 05/30/2011 17:40:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING OFF
GO

CREATE TABLE [dbo].[TipoScan](
	[id] [tinyint] IDENTITY(1,1) NOT NULL,
	[nome] tdDesc NOT NULL,
	[ativo] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

USE [PsafeDb]
GO

/****** Object:  Table [dbo].[Agendamento]    Script Date: 05/30/2011 17:40:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Agendamento](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[acessoId] [int] NOT NULL,
	[dataHora] [smalldatetime] NOT NULL,
	[dia] [tinyint] NULL,
	[mes] [tinyint] NULL,
	[ano] [smallint] NULL,
	[recorrente] [bit] NULL,
	[periodicidadeId] [tinyint] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]

GO

create index Agendamento_ID01 on Agendamento (acessoId) include (dataHora) on [index]
go
create index Agendamento_ID02 on Agendamento (dataHora) include (acessoId) on [index]
go


USE [PsafeDb]
GO

/****** Object:  Table [dbo].[Scan]    Script Date: 05/30/2011 17:40:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Scan](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[tipoScanId] [tinyint] NOT NULL,
	[acessoId] [int] NOT NULL,
	[dataHora] [smalldatetime] NOT NULL,
	[duracaoSegs] [smallint] NOT NULL,
	[qtdVirus] [smallint] NOT NULL,
	[reboot] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]

GO
create index Scan_ID01 on Scan (acessoId) include (dataHora,tipoScanId) on [index]
go
create index Scan_ID02 on Scan (dataHora) include (acessoId,tipoScanId) on [index]
go


/****** Object:  Table [dbo].[ScanArquivos]    Script Date: 05/30/2011 17:40:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[ScanArquivos](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[scanId] [int] NOT NULL,
	[nomeArquivo] [dbo].[tdDesc] NOT NULL,
	[md5] [dbo].[tdSmallDesc]  NULL,
	[limpou] [bit] NOT NULL,
	[quarentena] [bit] NOT NULL,
	[severidade] [dbo].[tdSmallDesc] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]

GO

create index ScanArquivos_ID01 on ScanArquivos (scanId) include (quarentena,md5) on [index]
go


SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[Agendamento]  WITH CHECK ADD FOREIGN KEY([acessoId])
REFERENCES [dbo].[Acesso] ([id])
GO

ALTER TABLE [dbo].[Agendamento]  WITH CHECK ADD FOREIGN KEY([periodicidadeId])
REFERENCES [dbo].[Periodicidade] ([id])
GO

ALTER TABLE [dbo].[Scan]  WITH CHECK ADD FOREIGN KEY([acessoId])
REFERENCES [dbo].[Acesso] ([id])
GO

ALTER TABLE [dbo].[Scan]  WITH CHECK ADD FOREIGN KEY([tipoScanId])
REFERENCES [dbo].[TipoScan] ([id])
GO

ALTER TABLE [dbo].[Scan]  WITH CHECK ADD FOREIGN KEY([tipoScanId])
REFERENCES [dbo].[TipoScan] ([id])
GO

ALTER TABLE [dbo].[Scan] ADD  DEFAULT ((0)) FOR [qtdVirus]
GO

ALTER TABLE [dbo].[ScanArquivos]  WITH CHECK ADD FOREIGN KEY([scanId])
REFERENCES [dbo].[Scan] ([id])
GO

ALTER TABLE [dbo].[ScanArquivos]  WITH CHECK ADD FOREIGN KEY([scanId])
REFERENCES [dbo].[Scan] ([id])
GO

/*********************/
create PROC [dbo].[pr_Scan_sel_AcessoId_Top]
	@Acessoid int,  @top int
WITH EXECUTE AS OWNER

AS
SET NOCOUNT ON
set rowcount @top

SELECT * 
FROM scan (nolock)
WHERE acessoid = @acessoid 
order by dataHora desc

set rowcount 0
SET NOCOUNT OFF

GO

create PROC [dbo].[pr_ScanArquivos_sel_ScanId]
	@Scanid int
WITH EXECUTE AS OWNER

AS
SET NOCOUNT ON


SELECT * 
FROM scanArquivos (nolock)
WHERE scanId = @Scanid


set rowcount 0
SET NOCOUNT OFF

GO

/**************************/

alter table instalacao alter column configuracao xml null
go

-- =============================================
-- Script Template
-- =============================================

DECLARE @GenerateProcsFor varchar(100)
SET @GenerateProcsFor = 'ScanArquivos'
--SET @GenerateProcsFor = ''

--ALTER PROC ?
DECLARE @Alter varchar(1)
SET @alter = 'n'

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
go
-- =============================================
-- Script Template
-- =============================================

DECLARE @GenerateProcsFor varchar(100)
SET @GenerateProcsFor = 'Scan'
--SET @GenerateProcsFor = ''

--ALTER PROC ?
DECLARE @Alter varchar(1)
SET @alter = 'n'

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
go
-- =============================================
-- Script Template
-- =============================================

DECLARE @GenerateProcsFor varchar(100)
SET @GenerateProcsFor = 'Agendamento'
--SET @GenerateProcsFor = ''

--ALTER PROC ?
DECLARE @Alter varchar(1)
SET @alter = 'n'

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
go
-- =============================================
-- Script Template
-- =============================================

DECLARE @GenerateProcsFor varchar(100)
SET @GenerateProcsFor = 'TipoScan'
--SET @GenerateProcsFor = ''

--ALTER PROC ?
DECLARE @Alter varchar(1)
SET @alter = 'n'

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
