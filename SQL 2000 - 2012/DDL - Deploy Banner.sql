USE [CampanhaDb]
GO

create table Parceiro (
id smallint identity(1,1) primary key,
nome tddesc not null,
ativo bit not null)
go

alter table Parceiro add percentualExibicao dec(4,2) not null
go

insert Parceiro select 'Hi Midia',1,10
insert Parceiro select 'Google',1,30
insert Parceiro select 'Boo Box',1,60

select * from Parceiro

create table Campanha (
id int identity(1,1) primary key,
nome tddesc not null,
parceiroId smallint not null references Parceiro,
ativo bit not null)
go
create index Campanha_ID01 on Campanha (parceiroId) include (id)
go

insert Campanha select 'Click On',1,1
insert Campanha select 'Google Ad Sense',2,1
insert Campanha select 'Boo Box',3,1


create table Banner (
id int identity(1,1) primary key,
ativo bit not null,
campanhaId int not null references campanha,
url tddesc not null)
go

create index Banner_ID01 on Banner (campanhaId) include (id)
go


insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js_fla.php?banid=14559&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js.php?banid=14560&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js.php?banid=14561&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js.php?banid=14562&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js.php?banid=14563&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js.php?banid=14564&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js.php?banid=14565&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js.php?banid=14566&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js.php?banid=14567&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js.php?banid=14568&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js.php?banid=14569&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js.php?banid=14570&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js.php?banid=14571&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js.php?banid=15352&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js.php?banid=15353&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js.php?banid=15354&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js.php?banid=15376&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js.php?banid=15377&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js.php?banid=15378&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js.php?banid=15379&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js.php?banid=15380&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js.php?banid=15381&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js.php?banid=15399&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js.php?banid=15400&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js.php?banid=15401&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js_fla.php?banid=11195&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js_fla.php?banid=11200&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js_fla.php?banid=11205&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js_fla.php?banid=11210&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js.php?banid=11215&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js.php?banid=11215&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js.php?banid=11225&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js.php?banid=11230&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js.php?banid=11235&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js.php?banid=11240&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js.php?banid=11245&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js.php?banid=11250&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js.php?banid=11255&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js.php?banid=11260&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js_fla.php?banid=14548&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js_fla.php?banid=14549&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js_fla.php?banid=14550&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js_fla.php?banid=14551&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js_fla.php?banid=14552&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js_fla.php?banid=14553&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js_fla.php?banid=14554&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js_fla.php?banid=14555&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js_fla.php?banid=14556&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js_fla.php?banid=14557&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js_fla.php?banid=14558&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js_fla.php?banid=11166&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js_fla.php?banid=11171&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js_fla.php?banid=11175&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js_fla.php?banid=11180&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js_fla.php?banid=11185&campid=16370;368&siteid=19229"></SCRIPT>'
insert Banner select 1,1,'<SCRIPT SRC="http://v2.afilio.com.br/tracker_js_fla.php?banid=11190&campid=16370;368&siteid=19229"></SCRIPT>'


insert Banner select 1,2,'<script type="text/javascript"><!--
google_ad_client = "ca-pub-7277339997277860";
/* Base Panel Ad Unit */
google_ad_slot = "6727904702";
google_ad_width = 468;
google_ad_height = 60;
//-->
</script>
<script type="text/javascript"
src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
</script>'

insert Banner select 1,3,'<script type="text/javascript">
 bb_bid = "1615558";
 bb_lang = "pt-BR";
 bb_keywords = "";
 bb_name = "custom";
 bb_limit = "7";
 bb_format = "bbc";
</script>
<script type="text/javascript" src="http://static.boo-box.com/javascripts/embed.js"></script>'



create table BannerClick (
id int identity(1,1) not null primary key,
data date not null,
hora tinyint not null,
bannerId int not null references banner,
qtd int not null)
go
create index BannerClick_ID01 on BannerClick (bannerId) include (id)
go
create index BannerClick_ID02 on BannerClick (data) include (bannerId)
go


create table BannerExibicao (
id int identity(1,1) not null primary key,
data date not null,
hora tinyint not null,
bannerId int not null references banner,
qtd int not null)
go
create index BannerExibicao_ID01 on BannerExibicao (bannerId) include (id)
go
create index BannerExibicao_ID02 on BannerExibicao (data) include (bannerId)
go


create PROC [dbo].[pr_Banner_lst_ativo]WITH EXECUTE AS OWNERASSET NOCOUNT ONSET rowcount 1000SELECT * FROM Banner (nolock) where ativo = 1SET NOCOUNT OFFSET rowcount 0
go

create PROC [dbo].[pr_Campanha_lst_ativo]WITH EXECUTE AS OWNERASSET NOCOUNT ONSET rowcount 1000SELECT * FROM Campanha (nolock) where ativo = 1SET NOCOUNT OFFSET rowcount 0
go


CREATE PROC [dbo].[pr_Parceiro_lst_ativo]WITH EXECUTE AS OWNERASSET NOCOUNT ONSET rowcount 1000SELECT * FROM Parceiro (nolock) where ativo = 1SET NOCOUNT OFFSET rowcount 0
GO





-- =============================================
-- Script Template
-- =============================================
--select 'drop proc '+name+';' from sys.procedures where name like 'pr_%' and name not like '%dba%' and name not like '%email%'
--and name not like '%enderecofinanceiro%'


-- #########################################################
-- Author:	www.sqlbook.com
-- Copyright:	(c) www.sqlbook.com. You are free to use and redistribute
--		this script as long as this comments section with the 
--		author and copyright details are not altered.
-- Purpose:	For a specified user defined table (or all user defined
--		tables) in the database this script generates 4 Stored 
--		Procedure definitions with different Procedure name 
--		suffixes:
--		1) List all records in the table (suffix of  _lst)
--		2) Get a specific record from the table (suffix of _sel)
--		3) UPDATE or INSERT (UPSERT) - (suffix of _ups)
--		4) DELETE a specified row - (suffix of _del)
--		e.g. For a table called location the script will create
--		procedure definitions for the following procedures:
--		dbo.pr_Location_lst
--		dbo.pr_Location_sel
--		dbo.pr_Location_ups
--		dbo.pr_Location_del
-- Notes: 	The stored procedure definitions can either be printed
--		to the screen or executed using EXEC sp_ExecuteSQL.
--		The stored proc names are prefixed with pr_ to avoid 
--		conflicts with system stored procs.
-- Assumptions:	- This script assumes that the primary key is the first
--		column in the table and that if the primary key is
--		an integer then it is an IDENTITY (autonumber) field.
--		- This script is not suitable for the link tables
--		in the middle of a many to many relationship.
--		- After the script has run you will need to add
--		an ORDER BY clause into the '_lst' procedures
--		according to your needs / required sort order.
--		- Assumes you have set valid values for the 
--		config variables in the section immediately below
-- #########################################################

-- ##########################################################
/* SET CONFIG VARIABLES THAT ARE USED IN SCRIPT */
-- ##########################################################

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