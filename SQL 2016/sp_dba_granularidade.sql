select T.name [TB], I.name [ID], AC.name [COL], I.type_desc, I.is_unique
FROM sys.tables T (nolock)
JOIN sys.indexes I (nolock) ON T.object_id = I.object_id
JOIN sys.index_columns IC (nolock) ON I.object_id = IC.object_id and I.index_id = IC.index_id
JOIN sys.all_columns AC (nolock) ON T.object_id = AC.object_id AND IC.column_id = AC.column_id
WHERE I.type_desc <> 'HEAP'
  --AND I.is_primary_key = 0
  --AND I.index_id > 1 /*Excluindo as PKs*/
  AND T.name = 'dba_ArrecadacaoFato2'
order by I.name
 
 
Ex:
exec BA_DBA.dbo.sp_dba_granularidade 'BA_Gateway', 'TransacoesGateway', 'transacoesGatewayId'
BA_Gateway..TransacoesGateway.transacoesGatewayId (Se a granularidade for maior que 95% então vale a pena criar um índice "não cluster".)
@distinctCampo @countCampo porcentagem
-------------- ----------- -----------
8889303        8889303     100%
 
exec BA_DBA.dbo.sp_dba_granularidade 'BA_Gateway', 'TransacoesGateway', 'tipoTransacaoId'
BA_Gateway..TransacoesGateway.tipoTransacaoId (Se a granularidade for maior que 95% então vale a pena criar um índice "não cluster".)
@distinctCampo @countCampo porcentagem
-------------- ----------- -----------
547            8889303     0%


use BA_DBA
go
alter proc sp_dba_granularidade (
  @ba     varchar(50),
  @tabela varchar(50),
  @campo  varchar(50)
) as
/************************************************************************
 Autor: Equipe DBA
 Data de criação: 25/07/2007
 Data de Atualização: 22/08/2007
 Funcionalidade: Se a granularidade for maior que 95% então vale a pena
 criar um índice "não cluster".
*************************************************************************/
BEGIN
  set nocount on
  SET ANSI_WARNINGS OFF

  declare @distinctCampo int, @countCampo int
  create table #distinct (valor int)
  create table #count    (valor int)

  insert into #distinct
  exec ('select count(distinct ' + @campo + ') from ' + @ba + '.dbo.' + @tabela + ' (NOLOCK) OPTION (MAXDOP 1)')
  insert into #count
  exec ('select count(' + @campo + ') from ' + @ba + '.dbo.' + @tabela + ' (NOLOCK) OPTION (MAXDOP 1)')

  select @distinctCampo = valor from #distinct
  select @countCampo    = valor from #count
  print @ba + '..' + @tabela + '.' + @campo + ' (' + 'Se a granularidade for maior que 95% então vale a pena criar um índice "não cluster".' + ')'
  select @distinctCampo [@distinctCampo], @countCampo [@countCampo], convert(varchar(5), (@distinctCampo*100)/@countCampo) + '%' [porcentagem]
-- select round((select @distinctCampo/@countCampo), 2, 2)

END --proc
go

exec sp_recompile 'sp_dba_granularidade'

-- exec BA_DBA.dbo.sp_dba_granularidade BA_Credito, Contrato, dataEncerramento
-- exec BA_DBA.dbo.sp_dba_granularidade BA_Credito, LogContratoCompleto, data
