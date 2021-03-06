if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_dba_ErrorLog_email]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_dba_ErrorLog_email]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_dba_analise_tabela]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_dba_analise_tabela]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_dba_errorlog]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_dba_errorlog]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_dba_fixedDrives]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_dba_fixedDrives]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_dba_grant]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_dba_grant]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_dba_jobGrade_sel]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_dba_jobGrade_sel]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_dba_job_erro]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_dba_job_erro]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_dba_job_erro_email]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_dba_job_erro_email]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_dba_job_erro_email_especifico]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_dba_job_erro_email_especifico]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_dba_job_sel]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_dba_job_sel]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_dba_jobs]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_dba_jobs]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_dba_manda_email]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_dba_manda_email]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_dba_manda_email_sincrono]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_dba_manda_email_sincrono]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_dba_mata_login_corporativo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_dba_mata_login_corporativo]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_dba_restore]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_dba_restore]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE proc sp_dba_ErrorLog_email (
  @dataReferencia smalldatetime = NULL,
  @enviaEmail     td_in_sim_nao = 'S',
  @enviaInfoJobs  td_in_sim_nao = 'S' ) as
/************************************************************************
 Autor: Rodrigo Moraes
 Data de criação: 14/10/2004
 Data de Atualização: 27/10/2009
 Funcionalidade: Chama a sp_dba_errorlog que lê o log do SQL e envia por email.
*************************************************************************/
begin
  set nocount on

  declare
    @assunto       varchar(150),
    -- Variáveis de email
    @varReturn     varchar(8000),
    @varReturnTemp varchar(8000),
    @sqlFiltro     varchar(2000),
    @coluna        varchar(500),
    @rowCount      int,
    @rowCountTotal int,
    @minData       datetime,
    @dataAtual     datetime,
    @grafico       varchar(200),
    @css           varchar(100)

  select @rowCountTotal = 0
  select @rowCount      = 0
  select @varReturn     = ''
  select @dataAtual     = getdate()
  --Com DIV não funcionou no email, só no browser.
  --select @grafico = '''<div style="background:#808080; text-align:right; width:''+convert(varchar(10),(count(*)*10))+''px">''+convert(varchar(10), count(*))+''</div>'' [graf]'
  select @grafico = '''<table><tr><td class=graf width=''+convert(varchar(10),convert(int,(count(*)/pMaxMe)*100))+''>''+convert(varchar(10), count(*))+''</td><td></td></tr></table>'' [graf]'
  select @css     = '<style type="text/css">.graf {color:white; background-color:navy; text-align:right;}</style>'

  exec BA_DBA.dbo.sp_dba_errorlog @dataReferencia, @temOutput = 'N', @minData = @minData OUTPUT

  select @varReturn = '<b><font size="1" face="Verdana, arial">' + @@servername + ' executando a: ' + ba_dba.dbo.fn_dba_datediff(@minData, @dataAtual, 'N', 'S') + '<br><br>'

  exec BA_DBA.dbo.sp_dba_gera_html_dinamico
--    @sqlClause        = 'top 10',
    @coluna01         = 'data',
    @coluna02         = 'spid',
    @coluna03         = 'texto',
    @sqlFiltro        = 'from ##ErroLogEmail',
    @htmlNomeTable    = 'Error Log',
    @htmlNomeTableCfg = '<b><font size="1" face="Verdana, arial">',
    @hmltNoWrapText   = 0,
    @debug            = 0,
    @varReturn        = @varReturnTemp OUTPUT,
    @rowCount         = @rowCount OUTPUT
  if (@rowCount > 0)
  begin
    select @varReturn = @varReturn + @varReturnTemp + '<br>'
    select @rowCountTotal = @rowCountTotal + @rowCount
  end

  if (@enviaInfoJobs = 'S')
  begin
    select @sqlFiltro = '
  from
    msdb.dbo.sysjobhistory a, 
    msdb.dbo.sysjobs b
  where a.job_id = b.job_id
    and a.step_name = ''(Job outcome)''
    and a.run_date =  convert(char(8), getdate(), 112)
    and convert(char(8), a.run_time, 108) >= convert(char(8), dateadd(hh, -3, getdate()), 108)
    and a.run_status = 0
  order by a.run_date, a.run_time'

    exec BA_DBA.dbo.sp_dba_gera_html_dinamico
      @coluna01         = 'convert(varchar(80), b.name) [JOB]',
      @coluna02         = 'a.run_date',
      @coluna03         = 'ba_dba.dbo.fn_dba_acertahora(a.run_time) [run_time]',
      @sqlFiltro        = @sqlFiltro,
      @htmlNomeTable    = 'Jobs com erro nas últimas 3 horas',
      @htmlNomeTableCfg = '<b><font size="1" face="Verdana, arial">',
      @hmltNoWrapText   = 0,
      @debug            = 0,
      @varReturn        = @varReturnTemp OUTPUT,
      @rowCount         = @rowCount OUTPUT

    if (@rowCount > 0)
    begin
      select @varReturn = @varReturn + @varReturnTemp + '<br>'
      select @rowCountTotal = @rowCountTotal + @rowCount
    end

  -- Qtd de jobs por hora
    select @sqlFiltro = '
  from msdb.dbo.sysjobschedules js
  where enabled = 1
  group by 
    substring(ba_dba.dbo.fn_dba_acertaHora(next_run_time), 1, 2)
  order by 1'

    exec BA_DBA.dbo.sp_dba_gera_html_dinamico
      @coluna01         = 'substring(ba_dba.dbo.fn_dba_acertaHora(next_run_time), 1, 2) [Hora]',
      @coluna02         = @grafico,
      @coluna15         = 'count(*) [pMaxMe]',
      @sqlFiltro        = @sqlFiltro,
      @htmlNomeTable    = 'Qtd de jobs por hora',
      @htmlNomeTableCfg = '<b><font size="1" face="Verdana, arial">',
      @css              = @css,
      @hmltNoWrapText   = 0,
      @debug            = 0,
      @trataCaracter    = 0,
      @varReturn        = @varReturnTemp OUTPUT,
      @rowCount         = @rowCount OUTPUT

    if (@rowCount > 0)
    begin
      select @varReturn = @varReturn + @varReturnTemp + '<br>'
      select @rowCountTotal = @rowCountTotal + @rowCount
    end

  -- Os 5 jobs mais demorados dos últimos 2 dias
  select @coluna = '
  case run_status
    when 0 then ''Erro''
    when 1 then ''OK''
    when 2 then ''Retry''
    when 3 then ''Cancelado''
    when 1 then ''Executando''
  end [Status]'

    select @sqlFiltro = '
  from msdb.dbo.sysjobhistory jh, msdb.dbo.sysjobs j
  where jh.job_id = j.job_id
    and jh.run_date   >= convert(int,convert(char(8),dateadd(dd,-1,getdate()),112))
    and j.enabled     = 1 
    and jh.run_time = (select max(run_time) from msdb..sysjobhistory jh2 where jh.job_id = jh2.job_id and jh.run_date = jh2.run_date)
    and jh.run_duration = (select max(run_duration) from msdb..sysjobhistory jh2 where jh.job_id = jh2.job_id and jh.run_date = jh2.run_date and jh.run_time=jh2.run_time)
  order by 5 desc'

    exec BA_DBA.dbo.sp_dba_gera_html_dinamico
      @sqlClause        = 'distinct top 5',
      @coluna01         = 'convert(varchar(60), j.name) [Nome]',
      @coluna02         = 'run_date [Data]',
      @coluna03         = 'ba_dba.dbo.fn_dba_acertaHora(jh.run_time) [Hora]',
      @coluna04         = @coluna,
      @coluna05         = 'ba_dba.dbo.fn_dba_acertaHora(jh.run_duration) [Duração]',
      @sqlFiltro        = @sqlFiltro,
      @htmlNomeTable    = 'Os 5 jobs mais demorados dos últimos 2 dias',
      @htmlNomeTableCfg = '<b><font size="1" face="Verdana, arial">',
      @hmltNoWrapText   = 0,
      @debug            = 0,
      @varReturn        = @varReturnTemp OUTPUT,
      @rowCount         = @rowCount OUTPUT

    if (@rowCount > 0)
    begin
      select @varReturn = @varReturn + @varReturnTemp + '<br>'
      select @rowCountTotal = @rowCountTotal + @rowCount
    end
  end --if (@enviaInfoJobs = 'S')

  if ( @rowCountTotal > 1 ) and ( @enviaEmail = 'S' )
  begin
    select @assunto = @@servername + ' Error Log e JOBs - (' + convert(char(10), isNull(@dataReferencia, getdate()), 103) + ')'
    exec sp_dba_manda_email
      @assunto = @assunto,
      @mensagem = @varReturn,
      @de   = 'alertadb@lemon.com',
      @para = 'alertadb@lemon.com', --'alertadb@lemon.com' / 'rodrigom@lemon.com'
      @tipo = 'text/html'
  end
  else
  begin
    select @rowCountTotal [rowCountTotal]
    select @assunto = @@servername + ' Error Log e JOBs - (' + convert(char(10), isNull(@dataReferencia, getdate()), 103) + ')'
    select @assunto [@assunto]
    select len(@varReturn) [len(@varReturn)]
    print @varReturn
  end

end --procedure

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

create proc sp_dba_analise_tabela (
  @ba     varchar(50),
  @tabela varchar(100)
) as
/************************************************************************
 Autor: Rodrigo Moraes
 Data de criação: 19/10/2004
 Data de Atualização: 27/10/2009
 Funcionalidade: Verifica informações da tabela como espaço ocupado por cada colun.
*************************************************************************/
begin
  set nocount on
  declare @countTabela int, @i tinyint, @campo varchar(50), @varExec varchar(1000)
  select @i = 1

  -- Pegando os dados dos campos da tabela --
  if exists (select 1 from tempdb.dbo.sysobjects (nolock) where name like '%#campos%')
    drop table #campos
  create table #campos (rowId tinyint identity, nome varchar(50), tipo varchar(20), length smallint, prec smallint, avgLen smallint, maxLen smallint)

  select @varExec = 'select c.name, t.name, c.length, c.prec, 0, 0
  from '+@ba+'.dbo.syscolumns c (nolock), '+@ba+'.dbo.systypes t (nolock), '+@ba+'.dbo.sysobjects so (nolock)
  where c.xtype = t.xtype
    and c.xusertype = t.xusertype
    and so.id = c.id
    and t.name in (''varchar'', ''char'')
    and so.name = ''' + @tabela + ''''

  insert #campos (nome, tipo, length, prec, avgLen, maxLen)
  exec (@varExec)
  -- Pegando os dados dos campos da tabela --

  -- Pegando o count da @tabela. --
  if exists (select 1 from tempdb.dbo.sysobjects (nolock) where name like '%#retorno%')
    drop table #retorno
  create table #retorno (avgLen smallint, maxLen smallint, countTabela int)

  select @varExec = 'select count(1) from '+@ba+'.dbo.'+@tabela+' (nolock) OPTION (maxdop 1)'
  insert into #retorno(countTabela)
  exec (@varExec)
  select @countTabela = countTabela from #retorno

  delete #retorno
  -- Pegando o count da @tabela. --

  while (@i <= (select count(1) from #campos)) begin
    select @campo = nome from #campos where rowId = @i
    insert #retorno (avgLen, maxLen) exec ('select avg(len('+@campo+')) [avgLen], max(len('+@campo+')) [maxLen] from '+@ba+'.dbo.'+@tabela+' (nolock) OPTION (maxdop 1)')
    update #campos set avgLen = (select avgLen from #retorno), maxLen = (select maxLen from #retorno) where rowId = @i

    delete #retorno
    select @i = @i + 1
  end 
  select nome, tipo, length, avgLen, maxLen from #campos

  if exists (select 1 from tempdb.dbo.sysobjects (nolock) where name like '%#retorno%')
    drop table #retorno

  select
    convert(varchar(30), tmp.nome) [nomeColuna],
    convert(varchar(13), tmp.tipo) [tipo],
    tmp.length,
    tmp.prec,
    CASE tmp.tipo
      when 'int'           then convert(varchar(10), ((4*@countTabela)/1024)/1024) + ' Mb'
      when 'smallint'      then convert(varchar(10), ((2*@countTabela)/1024)/1024) + ' Mb'
      when 'tinyint'       then convert(varchar(10), ((1*@countTabela)/1024)/1024) + ' Mb'
      when 'datetime'      then convert(varchar(10), ((8*@countTabela)/1024)/1024) + ' Mb' --2 grupos de 4 bytes, 1 pra data e outro pra hora
      when 'smalldatetime' then convert(varchar(10), ((4*@countTabela)/1024)/1024) + ' Mb'
      when 'char'          then convert(varchar(10), ((tmp.length*@countTabela)/1024)/1024) + ' Mb'
      when 'varchar'       then convert(varchar(10), ((tmp.avgLen*@countTabela)/1024)/1024) + ' Mb'
      when 'float'         then convert(varchar(10), ((tmp.prec*@countTabela)/1024)/1024) + ' Mb'
      when 'money'         then convert(varchar(10), ((1*@countTabela)/1024)/1024) + ' Mb'
      when 'smallmoney'    then convert(varchar(10), ((1*@countTabela)/1024)/1024) + ' Mb'
      else 'N/D'
    END [tamanho]
  from #campos tmp

  -- exec sp_spaceused 'TransacoesGateway'
  select @varExec = 'exec '+@ba+'.dbo.sp_dba_tamanho_tabela '+@tabela
  exec (@varExec)
end --proc

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE proc sp_dba_ErrorLog (
  @dataReferencia smalldatetime = NULL,
  @temOutput      td_in_sim_nao = 'S',
  @minData        smalldatetime = NULL OUTPUT
) as
/************************************************************************
 Autor: Rodrigo Moraes (Lemon Bank)
 Data de criação: 14/10/2004
 Data de Atualização: 21/08/2008
 Funcionalidade: Mostra o log atual do sql.
*************************************************************************/
begin
  set nocount on

  if exists (select 1 from tempdb.dbo.sysobjects where name like '%#ErroLogTemp%')
    drop table #ErroLogTemp
  create table #ErroLogTemp (
    rowId       int identity,
    texto       varchar(500) null,
    continuacao int          null
  )

  -- CARGA INICIAL
  insert #ErroLogTemp
  EXEC master.dbo.xp_readerrorlog
  -- CARGA INICIAL

  -- PEGANDO A DATA INICIAL DO LOG PRA MOSTRAR NO EMAIL DO ERROR LOG A QUANTO TEMPO O SERVIDOR ESTA DE PÉ
  select top 1 @minData = substring(texto, 1, 22)
  from #ErroLogTemp
  order by rowId

  -- DELETA O QUE NÃO PRECISA
  delete #ErroLogTemp where rowId > 1 and rowId < 12
  delete #ErroLogTemp where continuacao > 0
  delete #ErroLogTemp where texto like '%Using%'
  delete #ErroLogTemp where texto like '%DBCC CHECKDB%'
  delete #ErroLogTemp where texto like '%Database backed up%'
  delete #ErroLogTemp where texto like '%Log backed up%'
  delete #ErroLogTemp where texto like '%Starting up database%'
  delete #ErroLogTemp where isDate(substring(texto, 1, 10)) = 0 --Deletando todos os registros que não forem data.

  -- select * from #ErroLogTemp where convert(smalldatetime, substring(texto, 1, 10)) < dateadd(dd, -1, convert(char(8), getdate(), 112))
  -- select * from #ErroLogTemp where convert(smalldatetime, substring(texto, 1, 10)) = '20070806'
  if (@dataReferencia is null)
    delete #ErroLogTemp where convert(smalldatetime, substring(texto, 1, 10)) < dateadd(dd, -1, convert(char(8), getdate(), 112))
  else
    delete #ErroLogTemp where convert(smalldatetime, substring(texto, 1, 10)) <> @dataReferencia

  -- PEGANDO TODOS OS ITENS DO TIPO  transactions rolled forward/back
  declare @temp table (
    rowId      int          NULL,
    data       varchar(22)  NULL,
    spid       varchar(9)   NULL,
    texto      varchar(500) NULL,
    qtdTransacoes int       NULL
  )

  insert into @temp
  select
    top 5
    (convert(int, master.dbo.fn_dba_cataString(substring(texto, 34, 30), ' tran', '>'))*-1) [rowId],
    substring(texto, 01, 22) [data],
    rtrim(substring(texto, 24, 09)) [spid],
    substring(texto, 34, len(texto)) [texto],
    convert(int, master.dbo.fn_dba_cataString(substring(texto, 34, 30), ' tran', '>')) [qtdTransacoes]
  from #ErroLogTemp
  where texto like '%transactions rolled forward%'
  UNION
  select
    top 5
    (convert(int, master.dbo.fn_dba_cataString(substring(texto, 34, 30), ' tran', '>'))*-1) [rowId],
    substring(texto, 01, 22) [data],
    rtrim(substring(texto, 24, 09)) [spid],
    substring(texto, 34, len(texto)) [texto],
    convert(int, master.dbo.fn_dba_cataString(substring(texto, 34, 30), ' tran', '>')) [qtdTransacoes]
  from #ErroLogTemp
  where texto like '%transactions rolled back%'
  order by qtdTransacoes desc
  -- PEGANDO TODOS OS ITENS DO TIPO  transactions rolled forward/back

  -- Controle de status do SQL AGENT --------------------------------------
  -- drop table #agent
  declare @out int
  if exists (select 1 from tempdb.dbo.sysobjects where name like '%#agent%')
    drop table #agent
  create table #agent (status varchar(100))
  insert #agent
  Exec @out = master.dbo.xp_servicecontrol 'QueryState', 'SQLServerAgent'
  declare @datahoraAgent char(22)
  select @datahoraAgent  = substring(replace(convert(char(10), getdate(), 102)+' '+ convert(char(12), getdate(), 114), '.', '-'), 1, 22)
  if (@out = 0)
    update #agent set status = @datahoraAgent + ' server    Status do SQL AGENT: ' + status
  else
    insert #agent select @datahoraAgent + ' server    Status do SQL AGENT: NOT running.'

  insert into #ErroLogTemp (texto, continuacao)
  select status, 0 from #agent
  drop table #agent
  -- select * from #ErroLogTemp
  -- Controle de status do SQL AGENT --------------------------------------

  if exists (select 1 from tempdb.dbo.sysobjects where name like '%##ErroLogEmail%')
    drop table ##ErroLogEmail
  create table ##ErroLogEmail (
    rowId      int          NULL,
    data       varchar(22)  NULL,
    spid       varchar(9)   NULL,
    texto      varchar(500) NULL
  )

  -- SELECT FINAL
  insert into ##ErroLogEmail
  select
    rowId,
    substring(texto, 01, 22) [data],
    rtrim(substring(texto, 24, 09)) [spid],
    substring(texto, 34, len(texto)) [texto]
  from #ErroLogTemp
--   where texto like '%error%'
--     or  texto like '%kill%'
--     or  texto like '%pending%'
--     or  texto like '%cannot%'
--     or  texto like '%fail%'
--     or  texto like '%autogrow%'
--     or  texto like '%warning%'
--     or  texto like '%SQL AGENT%'
  UNION
  select
    rowId,
    data,
    spid,
    texto
  from @temp
  order by rowId

  if (@temOutput = 'S')
    select *
    from ##ErroLogEmail
    order by rowId desc

end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE proc sp_dba_fixedDrives (
  @enviaEmail td_in_sim_nao,
  @dataInicio smalldatetime = NULL,
  @dataFim    smalldatetime = NULL,
  @debug      bit = 0
) as
/************************************************************************
 Autor: Rodrigo Moraes
 Data de criação: 19/05/2005
 Data de Atualização: 18/05/2009
 Funcionalidade: Mostra ou manda por email o espaço disponível nos servers.
*************************************************************************/
BEGIN
  set nocount on

  if (@dataInicio is null)
  begin
    select @dataInicio = convert(char(8), getdate()-2, 112)
    select @dataFim = convert(char(8), getdate(), 112)
  end

  if (datediff(dd, @dataInicio, @dataFim) <> 2)
  begin
    RAISERROR('O range de pesquisa deve ser de 3 dias.', 16, 1) with nowait
    RETURN
  end

  declare
    @varEmail varchar(8000),
    @server   varchar(20),
    @drive    varchar(5),
    @mbLivre  varchar(30),
    @datafile varchar(60),
    @tamanho  varchar(4),
    @maxRowId tinyint,
    @assunto  varchar(50),
    @serverAux varchar(10),
    @tamanhoAnterior varchar(10),
    @serverAnterior  varchar(20),
    @corAtual        varchar(10),
    @trocaCor        bit,
    @para            varchar(100),

    -- sp_dba_gera_html_dinamico
    @varReturnTemp  varchar(8000),
    @sqlFiltro      varchar(2000),
--    @htmlNomeTable  varchar(150),
    @coluna03       varchar(500),
    @coluna04       varchar(500),
    @coluna05       varchar(500),
    @coluna06       varchar(500),
    @coluna07       varchar(500),
    @rowCount       int
    -- sp_dba_gera_html_dinamico

  select @corAtual = 'White'
  select @trocaCor = 1

  -- CARGA FIXEDDRIVES SERVIDORES ---------------------
  exec BDPROD.BA_DBA.dbo.sp_dba_fixedDrives_remoto
  exec BDPROD05.BA_DBA.dbo.sp_dba_fixedDrives_remoto
  exec BDPROD09.BA_DBA.dbo.sp_dba_fixedDrives_remoto

  if (@@servername like '%PROD%')
  begin
    exec BDPROD06.BA_DBA.dbo.sp_dba_fixedDrives_remoto
    exec BD_EXP01.BA_DBA.dbo.sp_dba_fixedDrives_remoto
--    exec BDPROD12.BA_DBA.dbo.sp_dba_fixedDrives_remoto
  end
  -- CARGA FIXEDDRIVES SERVIDORES ---------------------

  --Setando variáveis de acordo com o ambiente
  if (@@servername like '%DESV%') begin
    select @assunto = 'DESV'
    select @para = 'rodrigom@muitofaciltec.com.br'
  end
  else
  if (@@servername like '%HMLG%') begin
    select @assunto = 'HMLG'
    select @para = 'rodrigom@muitofaciltec.com.br'
  end
  else
  if (@@servername like '%PROD%') begin
    select @assunto = 'PROD'
    select @serverAux = 'BD_EXP01'
    if (datepart(dw, getdate()) = 2) --Se for segunda-feira manda pra sistemas também.
      select @para = 'sistemas@lemon.com; alertadb@lemon.com'
    else
      select @para = 'alertadb@lemon.com'
  end

  -- Espaço livre ----------------
  set language 'brazilian'
  select
    @sqlFiltro = '  from BA_DBA.dbo.DbaFixedDrivesGeral
  where drive is not null
    and data >= ''' + convert(char(8), @dataInicio, 112) + '''
    and data <= ''' + convert(char(8), @dataFim, 112) + '''
    and server like ''%' + @assunto + '%''
    '+isNull('and server like ''%' + @serverAux + '%''', '')+'
  group by server, drive
  order by server',
    @coluna03 = 'SUM(CASE WHEN data = ''' + convert(char(8), @dataInicio  , 112) + ''' THEN mbLivre ELSE 0 END) [' + ba_dba.dbo.fn_dba_dataDW(@dataInicio  , 'yyyymmdd') + ']',
    @coluna04 = 'SUM(CASE WHEN data = ''' + convert(char(8), @dataInicio+1, 112) + ''' THEN mbLivre ELSE 0 END) [' + ba_dba.dbo.fn_dba_dataDW(@dataInicio+1, 'yyyymmdd') + ']',
    @coluna05 = 'SUM(CASE WHEN data = ''' + convert(char(8), @dataInicio+2, 112) + ''' THEN mbLivre ELSE 0 END) [' + ba_dba.dbo.fn_dba_dataDW(@dataInicio+2, 'yyyymmdd') + ']',
    @coluna06 = '
  case
    when (SUM(CASE WHEN data = ''' + convert(char(8), @dataInicio+1, 112) + ''' THEN mbLivre ELSE 0 END) - SUM(CASE WHEN data = ''' + convert(char(8), @dataInicio+2, 112) + ''' THEN mbLivre ELSE 0 END))*-1 < 0
      then ''<font color=red>'' + convert(varchar(10), (SUM(CASE WHEN data = ''' + convert(char(8), @dataInicio+1, 112) + ''' THEN mbLivre ELSE 0 END) - SUM(CASE WHEN data = ''' + convert(char(8), @dataInicio+2, 112) + ''' THEN mbLivre ELSE 0 END))*-1)
    else convert(varchar(10), (SUM(CASE WHEN data = ''' + convert(char(8), @dataInicio+1, 112) + ''' THEN mbLivre ELSE 0 END) - SUM(CASE WHEN data = ''' + convert(char(8), @dataInicio+2, 112) + ''' THEN mbLivre ELSE 0 END))*-1)
  end [diferenca]'
  set language 'english'

  exec BA_DBA.dbo.sp_dba_gera_html_dinamico
    @coluna01         = 'server',
    @coluna02         = 'drive',
    @coluna03         = @coluna03,
    @coluna04         = @coluna04,
    @coluna05         = @coluna05,
    @coluna06         = @coluna06,
    @sqlFiltro        = @sqlFiltro,
    @sqlMaxDop        = '1',
    @htmlNomeTable    = 'Espaço Livre',
    @htmlNomeTableCfg = '<b><font size="1" face="Verdana, arial">',
    @hmltNoWrapText   = 0,
    @htmlCabecalhoCor = 'black',
    @htmlCabecalhoCfg = '<b><font color=white>',
    @trataCaracter    = 0,
    @debug            = @debug,
    @varReturn        = @varReturnTemp OUTPUT,
    @rowCount         = @rowCount OUTPUT

  if (@rowCount > 0)
    select @varEmail = isnull(@varReturnTemp + '<br>', '')
  -- Espaço livre ----------------

  -- Maiores datafiles -----------
  set language 'brazilian'
  select
    @sqlFiltro = '  from BA_DBA.dbo.DbaFixedDrivesGeral
  where datafile is not null
    and data >= ''' + convert(char(8), @dataInicio, 112) + '''
    and data <= ''' + convert(char(8), @dataFim, 112) + '''
    and isNumeric(tamanho) > 0
  group by server, datafile, ba
  order by server',
    @coluna04 = 'SUM(CASE WHEN data = ''' + convert(char(8), @dataInicio  , 112) + ''' THEN tamanho ELSE 0 END) [' + ba_dba.dbo.fn_dba_dataDW(@dataInicio  , 'yyyymmdd') + ']',
    @coluna05 = 'SUM(CASE WHEN data = ''' + convert(char(8), @dataInicio+1, 112) + ''' THEN tamanho ELSE 0 END) [' + ba_dba.dbo.fn_dba_dataDW(@dataInicio+1, 'yyyymmdd') + ']',
    @coluna06 = 'SUM(CASE WHEN data = ''' + convert(char(8), @dataInicio+2, 112) + ''' THEN tamanho ELSE 0 END) [' + ba_dba.dbo.fn_dba_dataDW(@dataInicio+2, 'yyyymmdd') + ']',
    @coluna07 = '
  case
    when (SUM(CASE WHEN data = ''' + convert(char(8), @dataInicio+1, 112) + ''' THEN tamanho ELSE 0 END) - SUM(CASE WHEN data = ''' + convert(char(8), @dataInicio+2, 112) + ''' THEN tamanho ELSE 0 END))*-1 > 0
      then ''<font color=red>'' + convert(varchar(10), (SUM(CASE WHEN data = ''' + convert(char(8), @dataInicio+1, 112) + ''' THEN tamanho ELSE 0 END) - SUM(CASE WHEN data = ''' + convert(char(8), @dataInicio+2, 112) + ''' THEN tamanho ELSE 0 END))*-1)
    else convert(varchar(10), (SUM(CASE WHEN data = ''' + convert(char(8), @dataInicio+1, 112) + ''' THEN tamanho ELSE 0 END) - SUM(CASE WHEN data = ''' + convert(char(8), @dataInicio+2, 112) + ''' THEN tamanho ELSE 0 END))*-1)
  end [diferenca]'
  set language 'english'

  exec BA_DBA.dbo.sp_dba_gera_html_dinamico
    @coluna01         = 'server',
    @coluna02         = 'ba',
    @coluna03         = 'datafile',
    @coluna04         = @coluna04,
    @coluna05         = @coluna05,
    @coluna06         = @coluna06,
    @coluna07         = @coluna07,
    @sqlFiltro        = @sqlFiltro,
    @sqlMaxDop        = '1',
    @htmlNomeTable    = 'Datafiles',
    @htmlNomeTableCfg = '<b><font size="1" face="Verdana, arial">',
    @hmltNoWrapText   = 0,
    @htmlCabecalhoCor = 'black',
    @htmlCabecalhoCfg = '<b><font color=white>',
    @trataCaracter    = 0,
    @debug            = @debug,
    @varReturn        = @varReturnTemp OUTPUT,
    @rowCount         = @rowCount OUTPUT

  if (@rowCount > 0)
    select @varEmail = @varEmail + isnull(@varReturnTemp, '') + '<br>'
  -- Maiores datafiles -----------

  -- Colorindo algumas linhas para diferenciar ----------------
  select @varEmail = replace(@varEmail, '<tr><td>BD_DESV02', '<tr bgColor=silver><td>BD_DESV02')
  select @varEmail = replace(@varEmail, '<tr><td>BD_HMLG02', '<tr bgColor=silver><td>BD_HMLG02')
  select @varEmail = replace(@varEmail, '<tr><td>BDPROD05D', '<tr bgColor=silver><td>BDPROD05D')
  select @varEmail = replace(@varEmail, '<tr><td>BDPROD09D', '<tr bgColor=silver><td>BDPROD09D')
  -- Colorindo algumas linhas para diferenciar ----------------

  -- Versões dos servidores -----------------------------------
  exec BA_DBA.dbo.sp_dba_gera_html_dinamico
    @sqlClause        = 'distinct',
    @coluna01         = 'server',
    @coluna02         = 'productversion',
    @coluna03         = 'productlevel',
    @coluna04         = 'edition',
    @sqlFiltro        = 'from DbaFixedDrivesGeral where data >= convert(char(8), getdate(), 112)',
    @sqlMaxDop        = '1',
    @htmlNomeTable    = 'Versões dos servidores',
    @htmlNomeTableCfg = '<b><font size="1" face="Verdana, arial">',
    @hmltNoWrapText   = 0,
    @htmlCabecalhoCor = 'black',
    @htmlCabecalhoCfg = '<b><font color=white>',
    @trataCaracter    = 0,
    @debug            = @debug,
    @varReturn        = @varReturnTemp OUTPUT,
    @rowCount         = @rowCount OUTPUT

  if (@rowCount > 0)
    select @varEmail = @varEmail + isnull(@varReturnTemp, '')
  -- Versões dos servidores -----------------------------------

  if ( @enviaEmail = 'S' )
  begin
    select @assunto = 'BDs ' + @assunto + ': Espaço Livre e versões'

    exec sp_dba_manda_email
      @assunto  = @assunto,
      @mensagem = @varEmail,
      @de   = 'alertadb@lemon.com',
      @para = @para,
      @tipo = 'text/html'
  end
  else
  begin
    select len(@varEmail)
    print @varEmail
  end

END -- proc

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE proc sp_dba_grant (
  @tipoPermissao varchar(20),
  @ba            varchar(40),
  @objeto        varchar(80),
  @usuario       varchar(50)
) as
/************************************************************************
 Autor: Rodrigo Moraes
 Data de criação: 21/09/2006
 Data de Atualização: --/--/----
 Funcionalidade: Executa o comando de GRANT para um BA/Objeto/Usuario.
 Criada para executar através da tela DBA Queries.
*************************************************************************/
BEGIN
  set nocount on

  exec ('use ' + @ba + ' ' +
        'grant ' + @tipoPermissao + ' on ' + @objeto + ' to ' + @usuario)

END --proc

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE proc sp_dba_jobGrade_sel (
  @nomeJob   varchar(100) = '%',
  @dataGrade smalldatetime = null
) as
/************************************************************************
 Autor: Rodrigo Moraes
 Data de criação: 30/10/2009
 Data de Atualização: 30/10/2009
 Funcionalidade: Mostra a grade dos jobs do servidor.
*************************************************************************/
BEGIN
  set nocount on

  --@multiplicador é o fator para normalizar a largura da tabela pela quantidade de minutos no dia / 2.
  declare @divisor tinyint, @multiplicador float
  select @divisor = 2, @multiplicador = 1.111

  if (@dataGrade is null)
    select @dataGrade = getdate()

  declare @sysjobhistory table (
    job_id       uniqueidentifier Primary Key,
    name         varchar(100),
    run_time     int,
    run_duration int  
  )
  insert @sysjobhistory (job_id, name) select job_id, name from msdb.dbo.sysjobs (nolock) where enabled = 1 and name like @nomeJob

  update tmp
  set
    run_time = sjh.run_time,
    run_duration = sjh.run_duration
  from @sysjobhistory tmp, msdb.dbo.sysjobhistory sjh (nolock)
  where tmp.job_id = sjh.job_id


--<div align="right" title="'+convert(varchar(60), j.name) +' [hr:'+substring(ba_dba.dbo.fn_dba_acertaHora(jh.run_time), 1, 5)+'] [dur:'+ convert(varchar(10),ba_dba.dbo.fn_dba_acertaHora(jh.run_duration)) +']" class=divJob>'+convert(varchar(60), j.name)+'</div>
--<font size=1>'+case when j.run_time >= 120000 then convert(varchar(60), j.name) else '' end +'</font>
--<font size=1>'+case when j.run_time < 120000 then convert(varchar(60), j.name) else '&nbsp;' end +'</font>
select '' [job],'<table cellspacing=0 cellsppading=0 height=20 width=100% background="images\backgroundheader.png"><tr><td></td></tr></table>' [grade], '0' [run_time]
UNION ALL
select distinct
convert(varchar(60), j.name),
'<table cellspacing=0 cellsppading=0 width=100% background="images\backgrounditem.png"><tr>

<!--OFFSET-->
<td height=15 align=right
width='+
case
  when convert(varchar(10),convert(int, (datediff(mi, '00:00:00', ba_dba.dbo.fn_dba_acertaHora(jh.run_time))/@divisor)*@multiplicador)) <> '0'
    then convert(varchar(10),convert(int, (datediff(mi, '00:00:00', ba_dba.dbo.fn_dba_acertaHora(jh.run_time))/@divisor)*@multiplicador))
  else '1'
end +'px/>

<!--BARRA-->
<td height=15 valign=top class='+
case
  when jh.run_duration <  100                                then 'pentei'
  when jh.run_duration >  100   and jh.run_duration <= 1500  then 'tranks'
  when jh.run_duration >= 1500  and jh.run_duration <  10000 then 'vixi'
  when jh.run_duration >  10000                              then 'chamaOdba'
end
+' 
width='+
case
  when convert(varchar(10),convert(int, (datediff(mi, '00:00:00', ba_dba.dbo.fn_dba_acertaHora(jh.run_duration))/@divisor)*@multiplicador)) <> '0'
    then convert(varchar(10),convert(int, (datediff(mi, '00:00:00', ba_dba.dbo.fn_dba_acertaHora(jh.run_duration))/@divisor)*@multiplicador))
  else '1'
end +'px 
<div align="right" title="'+convert(varchar(60), j.name) +' 
[hr:'+substring(ba_dba.dbo.fn_dba_acertaHora(jh.run_time), 1, 5)+'] 
[dur:'+ convert(varchar(10),ba_dba.dbo.fn_dba_acertaHora(jh.run_duration)) +']" class=divJob>'+convert(varchar(60), j.name)+'</div>
</td>

<!--FINAL-->
<td height=15 align=left>&nbsp;</td>

</tr></table>',
jh.run_time --Só para poder dar o distinct, já que cada vez que o SQL loga uma execução, todos os schedules são armazenados na sysjobhistory.
from msdb.dbo.sysjobschedules js (nolock), msdb.dbo.sysjobhistory jh (nolock), /*msdb.dbo.sysjobs j (nolock)*/@sysjobhistory j
where js.job_id = jh.job_id
  and j.job_id  = jh.job_id
  and jh.run_date = convert(char(8), @dataGrade, 112)
  and js.enabled = 1
  --Esses caras mostram somente a última execução de cada JOB.
--  and jh.run_time = j.run_time
--  and jh.run_duration = j.run_duration
  and jh.step_id = 0 --Pegando somente o step_id = 0 que é o cabeçalho do job.
order by jh.run_time

end --proc

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE proc sp_dba_job_erro as
/************************************************************************
 Autor: Rodrigo Moraes
 Data de criação: 08/07/2004
 Data de Atualização: 30/12/2004
 Funcionalidade: Checa se um JOB e seus STEPS falharam no dia atual, se 
 for segunda-feira, checa os JOBs com erro do final de semana.
*************************************************************************/
BEGIN
  SET NOCOUNT ON

  declare @hoje char(08), @anteOntem char(08)
  select  @hoje = convert(char(08), getdate(), 112), 
          @anteOntem = convert (char(8), dateadd(dd, -2, getdate()), 112)
  
  --select @hoje, @anteontem
  
  if DATEPART(weekday, GETDATE()) = 2
  BEGIN 
    print char(10)+'Segunda-feira: Procura jobs que tenham falhado no final de semana também!!'
    print ''
    select distinct
      convert(char(40), j.name) [Nome],
      convert(char(40), js.step_name) [Nome do Step],
      run_date [Data]
    from msdb.dbo.sysjobhistory jh, msdb.dbo.sysjobs j, msdb.dbo.sysjobsteps js
  	where jh.job_id = j.job_id
      AND j.job_id  = js.job_id
      AND jh.run_status = 0
      AND jh.run_date   >= @anteOntem
      AND j.enabled     = 1
      AND (jh.run_date between @anteOntem AND @hoje)
		order by 3 desc, 1, 2
  END
  else
    BEGIN
      print 'Dia normal: Procura jobs que tenham falhado hoje!'
      print ''
      select distinct
        convert(char(40), j.name) [Nome],
        convert(char(40), js.step_name) [Nome do Step],
        run_date [Data]
      from msdb.dbo.sysjobhistory jh, msdb.dbo.sysjobs j, msdb.dbo.sysjobsteps js
  		where 
          jh.job_id = j.job_id
      AND j.job_id  = js.job_id
      AND jh.run_status = 0
      AND jh.run_date   = @hoje
      AND j.enabled     = 1
  		order by 3 desc, 1, 2
    END
END --procedure

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE proc sp_dba_job_erro_email (
  @intervaloMinutos int = 31,
  @jobName          varchar(100) = NULL,
  @ccopia           varchar(500) = NULL,
  @debug            bit = 0
) as
/************************************************************************
 Autor: Rodrigo Moraes
 Data de criação: 22/07/2004
 Data de Atualização: 19/02/2008
 Funcionalidade: Dispara um email para alertadb@lemon.com ou qualquer outro
 grupo de email avisando se um JOB falhou.
*************************************************************************/
BEGIN
  SET NOCOUNT ON

  declare @assunto   varchar(150),  @para varchar(500), @siglaJob char(3),-- @intervalo tinyint,
          @varReturn varchar(8000), @rowCount int,      @lenVarReturn int, @sqlFiltro varchar(8000)          
  select  @para = 'alertadb@lemon.com;'

  select @sqlFiltro = '
  from
    msdb.dbo.sysjobs         j   (nolock) join 
    msdb.dbo.sysjobsteps     js  (nolock) on j.job_id = js.job_id join
    msdb.dbo.sysjobschedules jsc (nolock) on j.job_id = jsc.job_id join 
    msdb.dbo.sysjobhistory   jh  (nolock) on j.job_id = jh.job_id and js.step_id = jh.step_id
  where jh.run_status = 0
    AND j.enabled     = 1
    AND jsc.enabled   = 1
    AND j.name        like isNull(''' + isNull(@jobName, '%') + ''', '''')
    AND jh.run_date   = convert(char(8), getdate(), 112)
    AND ba_dba.dbo.fn_dba_acertaHora(jh.run_time) >= convert(char(8), dateadd( mi, -' + convert(varchar(10), @intervaloMinutos) + ', getdate() ), 114)
  order by 3 desc, 4 desc, 1 asc'

  exec BA_DBA.dbo.sp_dba_gera_html_dinamico
    @sqlClause        = 'distinct',
    @coluna01         = 'convert(varchar(60), j.name) [job]',
    @coluna02         = 'convert(varchar(40), js.step_name) [step]',
    @coluna03         = 'jh.run_date [data]',
    @coluna04         = 'ba_dba.dbo.fn_dba_acertaHora(jh.run_time) [hora]',
    @coluna05         = 'ba_dba.dbo.fn_dba_acertaHora(jh.run_duration) [duração]',
    @coluna06         = 'jh.message [erro]',
    @sqlFiltro        = @sqlFiltro,
    @htmlNomeTable    = 'JOBs com erro',
--    @htmlNomeTableCfg = '<b><font size="1" face="Verdana, arial">',
    @hmltNoWrapText   = 0,
--    @debug            = @debug,
    @varReturn        = @varReturn     OUTPUT,
    @rowCount         = @rowCount      OUTPUT,
    @lenVarReturn     = @lenVarReturn  OUTPUT
  select @varReturn = @varReturn

  if (@rowCount = 0)
  begin
    print 'Intervalo pesquisa'
    print '' + convert(char(8), getdate(), 112)
    print '' + convert(char(8), dateadd( mi, -@intervaloMinutos, getdate() ), 114)
    print 'Nada a enviar.'
    RETURN
  end

  -- Tratando envio de email ----------------
  DECLARE CR_EmailsJOB CURSOR FAST_FORWARD FOR
    select distinct
      substring(j.name, 1, 3)
    from
      msdb.dbo.sysjobs         j   (nolock) join 
      msdb.dbo.sysjobsteps     js  (nolock) on j.job_id = js.job_id join
      msdb.dbo.sysjobschedules jsc (nolock) on j.job_id = jsc.job_id join 
      msdb.dbo.sysjobhistory   jh  (nolock) on j.job_id = jh.job_id and js.step_id = jh.step_id
    where jh.run_status = 0
      AND j.enabled     = 1
      AND jsc.enabled   = 1
      AND j.name        like isNull(@jobName, '%')
      AND jh.run_date = convert(char(8), getdate(), 112)
      AND ba_dba.dbo.fn_dba_acertaHora(jh.run_time) >= convert(char(8), dateadd( mi, -@intervaloMinutos, getdate() ), 114)
  FOR READ ONLY

  OPEN  CR_EmailsJOB
  FETCH CR_EmailsJOB into @siglaJob

  -- Se não tiver nada no cursor então sai.
  if ( @@fetch_status <> 0 )
  begin
    CLOSE      CR_EmailsJOB
    DEALLOCATE CR_EmailsJOB
    RETURN
  end

  while ( @@fetch_status = 0 )
  begin
    select @para = @para + emailAlerta + ';'
    from BA_DBA.dbo.dba_job_email
    where siglaJob = @siglaJob

    FETCH CR_EmailsJOB into @siglaJob
  end
  
  CLOSE      CR_EmailsJOB
  DEALLOCATE CR_EmailsJOB

  if (@para = '' or @para is null)
    select @para = 'megagateway@lemon.com;alertadb@lemon.com'
  else
    select @para = substring(@para, 1, len(@para)-1)
  -- Tratando envio de email ----------------

  if (@debug = 1)
  begin
    print 'Intervalo pesquisa'
    print '' + convert(char(8), getdate(), 112)
    print '' + convert(char(8), dateadd( mi, -@intervaloMinutos, getdate() ), 114)
    select @lenVarReturn [@lenVarReturn]
    select @para [@para]
    print  @varReturn
    RETURN
  end

  if (@rowCount > 0)
  begin
    if (@jobName is null)
      select @assunto = @@servername + ' - JOB/step com erro!'
    else
      select @assunto = @@servername + ' - JOB "' +@jobName+ '" erro!'
    exec BA_DBA.dbo.sp_dba_manda_email
      @assunto  = @assunto,
      @mensagem = @varReturn,
      @de       = 'alertadb@lemon.com',
      @para     = @para,
      @ccopia   = @ccopia,
      @tipo     = 'text/html'
  end

END --procedure

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE proc sp_dba_job_erro_email_especifico (
  @jobName  varchar(50),
  @para     varchar(1000) = 'alertadb@lemon.com',
  @dataErro datetime = NULL
) as
/************************************************************************
 Autor: Rodrigo Moraes
 Data de criação: 24/01/2005
 Data de Atualização: 14/02/2007
 Funcionalidade: Dispara um email para alertadb@lemon.com avisando de 
 um JOB especifico que tenha falhado.
*************************************************************************/
BEGIN
  SET NOCOUNT ON

  declare
    @Ontem char(08),
    @varEmail varchar(8000),
    @assunto varchar(150),
    @step varchar(40),
    @mensagem varchar(500),
    @data varchar(15)
    --@tamVarEmail int

  if (@dataErro is null)
    select @dataErro = convert(char(8), getdate(), 112)

  select
    @Ontem = convert (char(8), dateadd(dd, -1, getdate()), 112),
    @varEmail =
    'Step                                    Hora     Mensagem Erro' +char(10)+
    '--------------------------------------- -------- -------------' +char(10)
    --@tamVarEmail = LEN(@varEmail)

  declare crJob cursor FORWARD_ONLY for
    select
      convert(char(40), js.step_name) [step name],
      ba_dba.dbo.fn_dba_acertaHora(jh.run_time) [hora],
      jh.message
    from 
      msdb.dbo.sysjobhistory jh (nolock), 
      msdb.dbo.sysjobs       j  (nolock),  
      msdb.dbo.sysjobsteps   js (nolock)
    where 
          jh.job_id     = j.job_id
      AND j.job_id      = js.job_id
      AND jh.run_status = 0 --status do job que falhou
      AND js.last_run_outcome = 0 --status do STEP que falhou
      AND j.enabled     = 1
      AND (jh.run_date = convert(char(8), @dataErro, 112))
      AND j.name        = @jobName
      AND jh.message    not like 'The job failed.%'
      AND jh.run_time = ( -- Data máxima de hoje.
        select max(a.run_time)
        from
          msdb.dbo.sysjobhistory a,
          msdb.dbo.sysjobs b
        where a.job_id = b.job_id
          and name = @jobName
          and a.run_date = isnull( convert(char(8), @dataErro, 112), convert(char(8), getdate(), 112) ) )
    order by [hora]
  FOR READ ONLY

  OPEN  crJob
  fetch crJob into @step, @data, @mensagem

  -- Se o cursor estiver vazio então retorna.
  if ( @@fetch_status <> 0 )
  begin
    print 'Nada a processar.'
    CLOSE      crJob
    DEALLOCATE crJob
    RETURN
  end
  
  WHILE @@fetch_status = 0
  BEGIN
    select @varEmail = @varEmail + @step + @data + ' ' + convert(varchar(300), @mensagem) + char(10)
    fetch crJob into @step, @data, @mensagem
  END

  CLOSE      crJob
  DEALLOCATE crJob

  --print @varEmail

  select @assunto = @@servername + ' - JOB "' +@jobName+ '" ERRO! (' + convert(char(10), getdate(), 103) +')'
  exec master.dbo.sp_dba_manda_email @assunto = @assunto, @mensagem = @varEmail, @para = @para

END --procedure

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE proc sp_dba_job_sel (
  @variosSchedules  bit = 0,
  @jobHabilitado    bit = 1,
  @schedHabilitado  bit = 1,
  @jobExecutando    bit = 0,
  @pesqUltDataExec  bit = 1,
  @nomeJob          varchar(100) = '%',
  @commandJob       varchar(100) = '%',
  @horaIni          varchar(17) = NULL,
  @horaFim          varchar(17) = NULL
) as
/************************************************************************
 Autor: Equipe Dba
 Data de criação: 02/06/2005
 Data de Atualização: 03/02/2009
 Funcionalidade: Consulta da tela inicial do sistema de JOBs Intranet.
*************************************************************************/
BEGIN
  set nocount on

  if (@horaFim is null) and (@horaIni is not null)
    select @horaFim = convert(varchar(8), @horaIni, 112) + ' 23:59:59'

  declare @Tabela table (
    job_id           UNIQUEIDENTIFIER NOT NULL,
    status           varchar(80),
    job              varchar(80),
    ultimoDiaExec    varchar(08),
    ultimaHoraExec   varchar(08),
    duracao          varchar(08),
    proxData         varchar(08),
    proxHora         varchar(08),
    tipoFrequencia   varchar(50),
    frequencia       varchar(50),
    jobHabilitado    bit,
    schedHabilitado  bit,
    indicaExecutando bit,
    hrefGrafico      varchar(100)
  )

  create table #JobsExecutando (
    job_id                UNIQUEIDENTIFIER NOT NULL,
    last_run_date         INT              NOT NULL,
    last_run_time         INT              NOT NULL,
    next_run_date         INT              NOT NULL,
    next_run_time         INT              NOT NULL,
    next_run_schedule_id  INT              NOT NULL,
    requested_to_run      bit              NOT NULL, -- BOOL
    request_source        INT              NOT NULL,
    request_source_id     sysname          NULL,
    running               bit              NOT NULL, -- BOOL
    current_step          INT              NOT NULL,
    current_retry_attempt INT              NOT NULL,
    job_state             INT              NOT NULL
  )

  create table #sysjobschedules (
    schedule_id            int                              NOT NULL ,
    job_id                 uniqueidentifier                 NOT NULL ,
    name                   sysname                          NOT NULL ,
    enabled                int                              NOT NULL ,
    freq_type              int                              NOT NULL ,
    freq_interval          int                              NOT NULL ,
    freq_subday_type       int                              NOT NULL ,
    freq_subday_interval   int                              NOT NULL ,
    freq_relative_interval int                              NOT NULL ,
    freq_recurrence_factor int                              NOT NULL ,
    active_start_date      int                              NOT NULL ,
    active_end_date        int                              NOT NULL ,
    active_start_time      int                              NOT NULL ,
    active_end_time        int                              NOT NULL ,
    next_run_date          int                              NOT NULL ,
    next_run_time          int                              NOT NULL ,
    date_created           datetime                         NOT NULL
  )

  -- select object_name(id) [tabela] from msdb..syscolumns where name = 'next_run_date'
  -- select master.dbo.fn_dba_cataString(@@version, '-', '>')
  if (master.dbo.fn_dba_cataString(@@version, '-', '>') like '%2005%')
  begin
    insert into #sysjobschedules
    exec ('select
      a.schedule_id,
      b.job_id,
      a.name,
      a.enabled,
      a.freq_type,
      a.freq_interval,
      a.freq_subday_type,
      a.freq_subday_interval,
      a.freq_relative_interval,
      a.freq_recurrence_factor,
      a.active_start_date,
      a.active_end_date,
     a.active_start_time,
      a.active_end_time,
      b.next_run_date,
      b.next_run_time,
      a.date_created
    from msdb.dbo.sysschedules a (NOLOCK) join msdb.dbo.sysjobschedules b (NOLOCK) on a.schedule_id = b.schedule_id')
  end
  else
  begin
    insert into #sysjobschedules
    exec ('select
      schedule_id,
      job_id,
      name,
      enabled,
      freq_type,
      freq_interval,
      freq_subday_type,
      freq_subday_interval,
      freq_relative_interval,
      freq_recurrence_factor,
      active_start_date,
      active_end_date,
      active_start_time,
      active_end_time,
      next_run_date,
      next_run_time,
      date_created
    from msdb.dbo.sysjobschedules (NOLOCK)')
  end


  if (@variosSchedules = 1)
  begin
    insert into @Tabela
    select distinct
      a.job_id,
      CASE b.last_run_outcome
        -- Essa tag <!--1--> ordena os registros para que os com erro e running fiquem em cima.
        WHEN 0 THEN '<!--1--><img src="images/job_erro.jpg" alt="Erro"></img>'
        WHEN 1 THEN '<!--4--><img src="images/job_ok.jpg" alt="Sucesso"></img>'
        WHEN 3 THEN '<!--2--><img src="images/job_erro.jpg" alt="Cancelado"></img>'
      END [status],

      convert(varchar(80), a.name) [JOB],
      case b.last_run_date when 0 then '19000101' else b.last_run_date end [ultimoDiaExec],
      ba_dba.dbo.fn_dba_acertaHora(b.last_run_time) [ultimaHoraExec],
      ba_dba.dbo.fn_dba_acertaHora(b.last_run_duration) [duracao],
      d.next_run_date [proxData],
      ba_dba.dbo.fn_dba_acertaHora(d.next_run_time) [proxHora],
      CASE d.freq_type
        WHEN  1 THEN 'Uma vez ('
        WHEN  4 THEN 'Diario ('
        WHEN  8 THEN 'Semanal ('
        WHEN 16 THEN 'Mensal ('
        WHEN 32 THEN 'Mensal Relativo ('
      END +
      case (d.freq_interval & 2)
        when 2 then 'seg;'
        else ''
      end +
      case (d.freq_interval & 4)
        when 4 then 'ter;'
        else ''
      end +
      case (d.freq_interval & 8)
        when 8 then 'qua;'
        else ''
      end +
      case (d.freq_interval & 16)
        when 16 then 'qui;'
        else ''
      end +
      case (d.freq_interval & 32)
        when 32 then 'sex;'
        else ''
      end +
      case (d.freq_interval & 64)
        when 64 then 'sab;'
        else ''
      end + 
      case (d.freq_interval & 1)
        when 1 then 'dom'
        else ''
      end + ')' [tipoFrequencia],

      CASE d.freq_subday_interval
        WHEN 0 THEN ''
        ELSE convert(varchar(15), d.freq_subday_interval)
      END +
      CASE d.freq_subday_type
        WHEN 1 THEN 'Hora especifica'
        WHEN 2 THEN ' Segundo(s)'
        WHEN 4 THEN ' Minuto(s)'
        WHEN 8 THEN ' Hora(s)'
      END + ' ' +
      CASE d.freq_subday_type
        WHEN 1 THEN ba_dba.dbo.fn_dba_acertaHora(d.active_start_time)
        ELSE ba_dba.dbo.fn_dba_acertaHora(d.active_start_time) + ' - ' + ba_dba.dbo.fn_dba_acertaHora(d.active_end_time)
      END + '' [frequencia],

      a.enabled [jobHabilitado],
      d.enabled [schedHabilitado],
      0 [indicaExecutando],
      '<a href="#"> <img src="images/job_graf.jpg" alt="Ver gráfico..." border=0></img> </a>' [hrefGrafico]
    from
      msdb.dbo.sysjobs a (NOLOCK)
      LEFT JOIN msdb.dbo.sysjobservers b (NOLOCK) ON a.job_id = b.job_id
      LEFT JOIN #sysjobschedules d (NOLOCK) ON a.job_id = d.job_id
  end
  else --if (@variosSchedules = 1)
  begin
    insert into @Tabela
    select distinct
      a.job_id,
      CASE b.last_run_outcome
        WHEN 0 THEN '<!--1--><img src="images/job_erro.jpg" alt="Erro"></img>'
        WHEN 1 THEN '<!--4--><img src="images/job_ok.jpg" alt="Sucesso"></img>'
        WHEN 3 THEN '<!--2--><img src="images/job_erro.jpg" alt="Cancelado"></img>'
      END [status],

      convert(varchar(80), a.name) [JOB],
      case b.last_run_date when 0 then '19000101' else b.last_run_date end [ultimoDiaExec],
      ba_dba.dbo.fn_dba_acertaHora(b.last_run_time) [ultimaHoraExec],
      ba_dba.dbo.fn_dba_acertaHora(b.last_run_duration) [duracao],
      d.next_run_date [proxData],
      ba_dba.dbo.fn_dba_acertaHora(d.next_run_time) [proxHora],

      CASE d.freq_type
        WHEN  1 THEN 'Uma vez ('
        WHEN  4 THEN 'Diario ('
        WHEN  8 THEN 'Semanal ('
        WHEN 16 THEN 'Mensal ('
        WHEN 32 THEN 'Mensal Relativo ('
      END +
      case (d.freq_interval & 1)
        when 1 then 'dom;'
        else ''
      end +
      case (d.freq_interval & 2)
        when 2 then 'seg;'
        else ''
      end +
      case (d.freq_interval & 4)
        when 4 then 'ter;'
        else ''
      end +
      case (d.freq_interval & 8)
        when 8 then 'qua;'
        else ''
      end +
      case (d.freq_interval & 16)
        when 16 then 'qui;'
        else ''
      end +
      case (d.freq_interval & 32)
        when 32 then 'sex;'
        else ''
      end +
      case (d.freq_interval & 64)
        when 64 then 'sab'
        else ''
      end + ')' [tipoFrequencia],

      CASE d.freq_subday_interval
        WHEN 0 THEN ''
        ELSE convert(varchar(15), d.freq_subday_interval)
      END +
      CASE d.freq_subday_type
        WHEN 1 THEN 'Hora especifica'
        WHEN 2 THEN ' Segundo(s)'
        WHEN 4 THEN ' Minuto(s)'
        WHEN 8 THEN ' Hora(s)'
      END + ' ' +
      CASE d.freq_subday_type
        WHEN 1 THEN ba_dba.dbo.fn_dba_acertaHora(d.active_start_time)
        ELSE ba_dba.dbo.fn_dba_acertaHora(d.active_start_time) + ' - ' + ba_dba.dbo.fn_dba_acertaHora(d.active_end_time)
      END + '' [frequencia],

      a.enabled [jobHabilitado],
      d.enabled [schedHabilitado],
      0 [indicaExecutando],
      '<a href="#"> <img src="images/job_graf.jpg" alt="Ver gráfico..." border=0></img> </a>' [hrefGrafico]
    from
      msdb.dbo.sysjobs a (NOLOCK)
      LEFT JOIN msdb.dbo.sysjobservers b (NOLOCK) ON a.job_id = b.job_id
      LEFT JOIN #sysjobschedules d (NOLOCK) ON a.job_id = d.job_id
      -- Para mostrar somente o próximo schedule, retirando assim a duplicidade quando um JOB tiver mais de 1 schedule habilitado.
    where d.next_run_time = (
        select top 1 min(b.next_run_time)
        from  #sysjobschedules b (NOLOCK)
        where a.job_id = b.job_id
          and b.enabled = 1
        group by b.next_run_date, b.next_run_time
        order by b.next_run_date, b.next_run_time )
  end --if (@variosSchedules = 1)

  -- Apaga os JOBs que não serão mostrados ------------------------
  delete @Tabela where job not like @nomeJob--'%' + @nomeJob + '%'
  -- Apaga os JOBs que não serão mostrados ------------------------

  -- Apaga os JOBs que não tenham o comando pesquisado ------------
  declare @TabelaNaoDeletar table (job_id UNIQUEIDENTIFIER NOT NULL)

  insert into @TabelaNaoDeletar
  select t.job_id from @Tabela t, msdb.dbo.sysjobsteps sjs where t.job_id = sjs.job_id and sjs.command like '%' + @commandJob + '%'

-- select job_id from @TabelaNaoDeletar
-- select job from @Tabela t where exists (select 1 from @TabelaNaoDeletar tnd where t.job_id = tnd.job_id)
-- select job from @Tabela t where not exists (select 1 from @TabelaNaoDeletar tnd where t.job_id = tnd.job_id)

  delete @Tabela from @Tabela t where not exists (select 1 from @TabelaNaoDeletar tnd where t.job_id = tnd.job_id)
  -- Apaga os JOBs que não tenham o comando pesquisado ------------

  -- Acerta visualização dos JOBs ---------------------------------
  update @Tabela
  set tipoFrequencia = 'Diario'
  where tipoFrequencia like '%Diario%'

  update @Tabela
  set tipoFrequencia = 'Uma vez'
  where tipoFrequencia like '%Uma vez%'

  update @Tabela
  set tipoFrequencia = replace(tipoFrequencia, ';)', ')')

  update @Tabela set
    tipoFrequencia = 'Mensal(dia ' + convert(varchar(2), b.freq_interval) + ')'
  from
    msdb.dbo.sysjobs  a (NOLOCK),
    #sysjobschedules  b (NOLOCK),
    @Tabela           c
  where a.job_id = b.job_id
    and a.name = c.JOB
    and b.freq_type = 16 --Se o schedule for mensal, o "freq_interval" é o dia do mes
  -- Acerta visualização dos JOBs ---------------------------------

  -- Adiciona a frequencia em minutos a próxima hora de execução para o schedule ativo -------
  update @Tabela
  set proxHora = convert(char(08), dateadd(mi, convert(int, substring(frequencia, 1, 2)), ultimaHoraExec), 114)
  where ultimoDiaExec  = proxData
    and frequencia like '%Minuto%'
    and datediff(mi, ultimaHoraExec, proxHora) <= convert(int, substring(frequencia, 1, 2))
  -- Adiciona a frequencia em minutos a próxima hora de execução para o schedule ativo -------

  -- Mostra se o JOB está executando no momento ---------------------
  insert into #JobsExecutando
  EXECUTE master.dbo.xp_sqlagent_enum_jobs 1, 'dbo'

  update @Tabela
  set
    indicaExecutando = je.running,
    status = '<!--3--><img src="images/job_running.jpg" alt="Executando"></img>'
  from @Tabela t, #JobsExecutando je
  where t.job_id = je.job_id
    and je.running = 1
  -- Mostra se o JOB está executando no momento ---------------------

  -- Carregando o link para o gráfico ----------
--   update @Tabela
--   set hrefGrafico = --'<img src="images/job_graf.jpg" alt="Ver gráfico..."></img>'
-- --    '<a href="window.open(''../GeradorGraficos/GeradorGraficos.aspx?chartType=bar&print=1&unit=Tempo&nomeProc=sp_dba_jobHistoricoGrafico_sel&nomeBa=BA_DBA&nomeParam="' + job + '"&nomeServidor="' + @@servername + '",''Grafico'',''top=10 ,left=10 ,width=820, height=420, resizable=no, menubar=no, toolbar=no, location=no, directories=no, scrollbars=no, status=no'')"> <img src="images/job_graf.jpg" alt="Ver gráfico..." border=0></img> </a>'
-- --    '<a href="#" onclick=javascript:window.open(''../GeradorGraficos/GeradorGraficos.aspx?chartType=bar&print=1&unit=Tempo&nomeProc=sp_dba_jobHistoricoGrafico_sel&nomeBa=BA_DBA&nomeParam=' + job + '&nomeServidor=' + @@servername + ',''Grafico'',''top=10 ,left=10 ,width=820, height=420, resizable=no, menubar=no, toolbar=no, location=no, directories=no, scrollbars=no, status=no'')"> <img src="images/job_graf.jpg" alt="Ver gráfico..." border=0></img> </a>'
--   '<a href="#"> <img src="images/job_graf.jpg" alt="Ver gráfico..." border=0></img> </a>'

  if (@jobExecutando = 1)
  begin
    select
      status,
      job,
      convert(char(8), ultimoDiaExec, 112) + ' ' + convert(char(8), ultimaHoraExec) [ultimoDiaExec],
      duracao,
      convert(char(8), proxData, 112) + ' ' + convert(char(8), proxHora) [proxData],
      tipoFrequencia,
      frequencia,
      jobHabilitado,
      schedHabilitado,
      hrefGrafico
    from @Tabela
    where indicaExecutando = @jobExecutando

    RETURN
  end

  if (@pesqUltDataExec = 1)
    select
      status,
      job,
      convert(char(8), ultimoDiaExec, 112) + ' ' + convert(char(8), ultimaHoraExec) [ultimoDiaExec],
      duracao,
      convert(char(8), proxData, 112) + ' ' + convert(char(8), proxHora) [proxData],
      tipoFrequencia,
      frequencia,
      jobHabilitado,
      schedHabilitado,
      hrefGrafico
    from @Tabela
    where jobHabilitado   = isNull(@jobHabilitado, jobHabilitado)
      and schedHabilitado = isNull(@schedHabilitado, schedHabilitado)
      and ultimoDiaExec + ' ' + ultimaHoraExec >= isNull(@horaIni, ultimoDiaExec + ' ' + ultimaHoraExec)
      and ultimoDiaExec + ' ' + ultimaHoraExec <= isNull(@horaFim, ultimoDiaExec + ' ' + ultimaHoraExec)
    order by status, ultimoDiaExec, ultimaHoraExec
   else
    select
      status,
      job,
      convert(char(8), ultimoDiaExec, 112) + ' ' + convert(char(8), ultimaHoraExec) [ultimoDiaExec],
      duracao,
      convert(char(8), proxData, 112) + ' ' + convert(char(8), proxHora) [proxData],
      tipoFrequencia,
      frequencia,
      jobHabilitado,
      schedHabilitado,
      hrefGrafico
    from @Tabela
    where jobHabilitado   = isNull(@jobHabilitado, jobHabilitado)
      and schedHabilitado = isNull(@schedHabilitado, schedHabilitado)
      and proxData + ' ' + proxHora >= isNull(@horaIni, proxData + ' ' + proxHora)
      and proxData + ' ' + proxHora <= isNull(@horaFim, proxData + ' ' + proxHora)
    order by status, proxData, proxHora

END --proc

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE proc sp_dba_jobs
as
select 'Jobs de hoje'

SELECT j.name JobName,h.step_name StepName, 
CONVERT(CHAR(10), CAST(STR(h.run_date,8, 0) AS dateTIME), 111) RunDate, 
STUFF(STUFF(RIGHT('000000' + CAST ( h.run_time AS VARCHAR(6 ) ) ,6),5,0,':'),3,0,':') RunTime, 
h.run_duration StepDuration,
case h.run_status when 0 then 'failed'
when 1 then 'Succeded' 
when 2 then 'Retry' 
when 3 then 'Cancelled' 
when 4 then 'In Progress' 
end as ExecutionStatus, 
h.message MessageGenerated
FROM msdb..sysjobhistory h inner join msdb..sysjobs j
ON j.job_id = h.job_id
where run_date >= convert(char(8),getdate(),112)
ORDER BY j.name, h.run_date, h.run_time

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE proc sp_dba_manda_email
        @assunto                varchar(200),
        @mensagem               varchar(8000) = null, 
        @para                   varchar(2000) = null,
        @de                     varchar(50),
        @tipo                   varchar(100)  = 'text/plain',
        @ccopia                 varchar(2000) = '',
        @attachments            varchar(4000) = '',
        @assincrono             char(1)       = 'S',
        @sistemaId              smallint      = null,
        @moduloId               int           = null,
        @campoConsolidacaoId    smallint      = null,
        @valorCampoConsolidacao int           = null,
        @indEnviarPorBcc        char(1)       = 'N'
as
/************************************************************************
Autor: Rodrigo Moraes (PVale tb!)
Data de criação: 06/01/2004
Data de Atualização: 15/05/2009
Funcionalidade: Dispara um email de forma sincrona ou assincrona.
*************************************************************************/

  set nocount on
  
  declare @dataHoraEnvio      datetime
  declare @dataHoraSolicitado datetime
  declare @sucesso            smallint
  
  select @dataHoraEnvio      = null,
         @dataHoraSolicitado = null

  if (@para is null) and
     (@sistemaId is null or @moduloId is null) begin
    RAISERROR('Passe o parametro "@para" ou os parametros "@sistemaId" e "@moduloId" juntos.', 16, 1)
    RETURN
  end

  if (@assincrono = 'N') begin
    if @sistemaid is not null and @moduloId is not null begin
      exec ba_corporativo.corporativo.pr_Gera_GrupoEmail
            @sistemaId              = @sistemaId,
            @moduloId               = @moduloId,
            @campoConsolidacaoId    = @campoConsolidacaoId,
            @valorCampoConsolidacao = @valorCampoConsolidacao,
            @listaEmails            = @para output
    end
  
  
    exec sp_dba_manda_email_sincrono
        @de              = @de,
        @para            = @para,
        @assunto         = @assunto,
        @mensagem        = @mensagem,
        @tipo            = @tipo, -- aceita ['text/plain' | 'text/html']
        @ccopia          = @ccopia,
        @attachments     = @attachments,
        @sucesso         = @sucesso output,
        @indEnviarPorBcc = @indEnviarPorBcc
  
    if @sucesso = 0 begin
      select @dataHoraEnvio      = getdate(),
             @dataHoraSolicitado = getdate()
    end
  end

  select @para = ba_dba.dbo.fn_dba_BloqueiaEmail(@para)
  select @ccopia = ba_dba.dbo.fn_dba_BloqueiaEmail(@ccopia)

  -- se houve envio sincrono acima, apenas loga na ServicoEmail com dataHoraEnvio preenchida
  -- caso contrario, vai para a fila de envio assincrono
  exec ba_dba.dbo.sp_dba_ServicoEmail_ins 
          @titulo                 = @assunto,
          @texto                  = @mensagem,
          @destinatario           = @para,
          @remetente              = @de,
          @formatoEmail           = @tipo,
          @sistemaId              = @sistemaId,
          @moduloId               = @moduloId,
          @campoConsolidacaoId    = @campoConsolidacaoId,
          @valorCampoConsolidacao = @valorCampoConsolidacao,
          @dataHoraEnvio          = @dataHoraEnvio,
          @dataHoraSolicitado     = @dataHoraSolicitado,
          @indEnviarPorBcc        = @indEnviarPorBcc


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE proc sp_dba_manda_email_sincrono
        @assunto         varchar(200),
        @mensagem        varchar(8000) = null, 
        @para            varchar(2000),
        @de              varchar(50),
        @tipo            varchar(100)  = 'text/plain',
        @ccopia          varchar(2000) = '',
        @attachments     varchar(4000) = '',
        @sucesso         smallint output,
        @indEnviarPorBcc char(1)       = 'N'
as
/************************************************************************
Autor: Rodrigo Moraes/ Paulo Vale/ Rodrigo Siqueira
Data de criação: 06/01/2004
Data de Atualização: 09/10/2006
Funcionalidade: Dispara um email.
*************************************************************************/
set nocount on

declare @ip               varchar(30)
declare @bcc              varchar(4000)
declare @paraCorrente     varchar(2000)
declare @qtdMaxDestinario tinyint
declare @qtdDestinarioAux tinyint
declare @i                smallint

select @ip = valor               from BA_DBA.dbo.ConfiguracaoDBA (NOLOCK) where chaveId = 'ipServerEmail'

select @qtdMaxDestinario = valor from BA_DBA.dbo.ConfiguracaoDBA (NOLOCK) where chaveId = 'qtdMaxDestinario'
if @@rowcount = 0 begin
  select @qtdMaxDestinario = 39
end

if ( @tipo = 'text/html' ) begin -- se o texto for HTML, não permite que se quebrem as tags...
  select @mensagem = master.dbo.fn_dba_FormataMensagemMail_Tabajara(@mensagem)
end

 -- pra garantir o ";" no final de @para
select @para = @para + ';'
select @para = Replace(@para, ';;', ';')


while @para <> '' begin
  select @qtdDestinarioAux = @qtdMaxDestinario
  select @paraCorrente     = ''
  while @qtdDestinarioAux > 0 begin
    select @i = CharIndex(';', @para)
    select @paraCorrente = @paraCorrente + SubString(@para, 1, @i)
    select @para = SubString(@para, @i + 1, 2000)
    select @qtdDestinarioAux = @qtdDestinarioAux - 1
  end

  if @indEnviarPorBcc = 'S' begin
    select @bcc          = @paraCorrente + @ccopia
    select @paraCorrente = @de
    select @ccopia       = ''
  end

-- tratamento do @de por causa do BB
select @de = 'intranet@muitofaciltec.com.br'

select @paraCorrente = replace(@paraCorrente,'@lemon.com','@muitofaciltec.com.br')
select @ccopia = replace(@ccopia,'@lemon.com','@muitofaciltec.com.br')
select @bcc = replace(@bcc,'@lemon.com','@muitofaciltec.com.br')


  execute master.dbo.xp_smtp_sendmail --enviando e-mail através do Linked Server
      @FROM        = @de,
      @TO          = @paraCorrente,
      @subject     = @assunto,
      @message     = @mensagem,
      @server      = @ip,
      @port        = 25,
      @type        = @tipo, -- aceita ['text/plain' | 'text/html']
      @CC          = @ccopia,
      @bcc         = @bcc,
      @attachments = @attachments
  if @@error <> 0 begin
    select @sucesso = -1
  end
  else begin
    select @sucesso = 0
  end

  select @ccopia       = ''
end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE proc sp_dba_mata_login_corporativo as
/************************************************************************
 Autor: Rodrigo Moraes
 Data de criação: 09/06/2004
 Data de Atualização: --/--/----
 Funcionalidade: Mata qualquer usuário que esteja logado no BA_Corporativo
 no horário que o RESTORE for executado.
*************************************************************************/
BEGIN
  set nocount on
  -- declara a tabela que vai armazenar os "spids" que estão logados no Corporativo
  declare @dbaSysprocesses table ( spid int, lastBatch datetime, loginName varchar(30), hostName  varchar(30) )
  -- declara as variáveis
  declare @spid int, @lastBatch datetime, @loginName varchar(30), @hostname varchar(30), @varEmail varchar(8000)

  insert @dbaSysprocesses 
    select spid, last_batch, loginame, hostName from master..sysprocesses
    where dbid = db_id('BA_Corporativo')

  if (select count(*) from @dbaSysprocesses) = 0
    return
  else
  begin
    -- abre cursor
    declare cr_sysprocesses cursor for
    select spid, lastBatch, loginName, hostName from @dbaSysprocesses

    open  cr_sysprocesses
    fetch cr_sysprocesses into @spid, @lastBatch, @loginName, @hostname

    select @varEmail = '' --limpa a variável
    select @varEmail = 'spid lastBatch                loginName                     hostName'  + char(10) +
    '---- ------------------------ ----------------------------- ----------------------------' + char(10)

    while @@fetch_status = 0
    begin
      select @varEmail =  @varEmail   + 
        convert(char(05), @spid)      +
        convert(char(25), @lastBatch) +
        convert(char(30), @loginName) +
        convert(char(30), @hostname)  + char(10)

        exec ('KILL '+@spid)
      fetch cr_sysprocesses into @spid, @lastBatch, @loginName, @hostname
    end --while
    
    CLOSE cr_sysprocesses
    DEALLOCATE cr_sysprocesses

    print @varEmail
--    return

    -- envia email
    exec master..sp_dba_manda_email
      @assunto  = 'BDPROD - BA_Corporativo (login prendendo LOAD)',
      @mensagem = @varEmail
  end --if (select count(*)...
END --procedure

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE proc sp_dba_restore (
  @ba              varchar(080),
  @arquivoBackup   varchar(080)  = null, --Se o arquivo de backup tiver o nome diferente do nome do BA.
  @mostraStats     td_in_sim_nao = 'N', --Mostra a percentagem do RESTORE.
  @recompactaBAK   td_in_sim_nao = 'S', --Recompacta o arquivo.
  @fazShrink       td_in_sim_nao = 'N', --Faz shrink no database restaurado.
  @severity        tinyint       = 16,
  @apagaArquivo    td_in_sim_nao = 'N',
  @debug           bit           = 0
) as
/************************************************************************
 Autor: Rodrigo Moraes
 Data de criação: 30/05/2005
 Data de Atualização: 07/07/2008
 Funcionalidade: Faz restore montando a string de Restore dinamicamente, 
 se tiver users no BA, mata. Faz o autofix também.
*************************************************************************/
BEGIN
  set nocount on

  if (@severity not in (0, 16))
  begin
    RAISERROR ('Parametro "@severity" deve receber os valores "0" ou "16".', 16, 1) WITH NOWAIT
    RETURN
  end

  -- Não deixa restaurar o BA_DBA. -------------------------------
  if ( @ba = 'BA_DBA' )
  begin
    RAISERROR ('Não pode restaurar o BA_DBA.', 16, 1) WITH NOWAIT
    RETURN
  end
  -- Não deixa restaurar o BA_DBA. -------------------------------

  declare
    @RAISERROR   varchar(300)

  -- Valida se o BA passado existe no servidor. ------------------
  declare @count tinyint

  select @count = count(*)
  from  master.dbo.sysdatabases (NOLOCK)
  where db_name(dbid) = @ba

  if ( @count = 0 )
  begin
    select @RAISERROR = 'BA ''' + @ba + ''' não existe no ' + @@servername + '.'
    RAISERROR (@RAISERROR, @severity, 1) WITH NOWAIT
    RETURN
  end
  -- Valida se o BA passado existe no servidor. ------------------

  -- Valida variável @arquivoBackup ------------------------------
  if (substring(@arquivoBackup, LEN(@arquivoBackup)-6, 7) like '%.bak%') or
     (substring(@arquivoBackup, LEN(@arquivoBackup)-6, 7) like '%.gz%')
  begin
    RAISERROR ('Não passe o "@arquivoBackup" com a extensão ".BAK.gz".', @severity, 1) WITH NOWAIT
    RETURN
  end
  -- Valida variável @arquivoBackup ------------------------------

  DECLARE
    @PATH_RESTORE varchar(40),
    @caminhoGz    varchar(150),
    @caminhoBak   varchar(150),
    @varExec      varchar(2000),
    @fileIdMax    tinyint,
    @i            tinyint,
    @nomeDataFile varchar(100),
    @filenome     varchar(100),
    @count_DbaRESTOREFILELISTONLY tinyint,
    @count_DbaDataFiles tinyint,
    @updateability varchar(15),
    @returnDir     tinyint

  --Inicialização
  select
    @varExec = '',
    @fileIdMax = 0,
    @i = 1

  -- Pega o path do diretório de RESTORE -----------------------
  select @PATH_RESTORE = valor from BA_DBA.dbo.ConfiguracaoDBA where chaveId = 'pathRestore'

  if (@PATH_RESTORE is NULL)
  begin
    RAISERROR ('Não existe caminho de RESTORE configurado na tabela "ConfiguracaoDBA". Conferir a chave: "pathRestore".', 16, 1) WITH NOWAIT
    RETURN
  end
  -- Pega o path do diretório de RESTORE -----------------------

  -- Concatena o path de restore dos arquivos com o ba passado como parametro -----
  select @caminhoGz  = @PATH_RESTORE + isnull(@arquivoBackup, @ba) + '.bak.gz'
  select @caminhoBak = @PATH_RESTORE + isnull(@arquivoBackup, @ba) + '.bak'

--   if (@debug = 1)
--   begin
--     select @caminhoGz [@caminhoGz]
--     select @caminhoBak [@caminhoBak]
--   end
  -- Concatena o path de restore dos arquivos com o ba passado como parametro -----

  -- Testa e descompacta o arquivo -----------------------------
  select @varExec = 'dir ' + @caminhoGz
  exec @returnDir = master.dbo.xp_cmdshell @varExec, no_output

  if (@returnDir = 0) --Só descompacta se estiver compactado.
    exec BA_DBA.dbo.sp_dba_gzipa @caminhoGz, 'N'
  else
  begin
    select @varExec = 'dir ' + @caminhoBak
    exec @returnDir = master.dbo.xp_cmdshell @varExec, no_output
  
    if (@returnDir <> 0) --Se o backup também não existir, aborta e sai.
    begin
      select @RAISERROR = 'ERRO: Arquivo "' + @caminhoBak + '" não existe no servidor "' + @@servername + '".'
      RAISERROR(@RAISERROR, @severity, 1) WITH NOWAIT
      print '--------------------------------------------------------' --Para pular uma linha no output do JOB de restore
      RETURN
    end
  end

  select @varExec = ''
  -- Testa e descompacta o arquivo -----------------------------

  -- Pegando os datafiles do Backup ----s-----------------------
  create table #DbaRESTOREFILELISTONLY (
    FileId        tinyint, -- Não pode ser identity pois vou atualizar com os IDs dos datafiles do BA que vai ser restaurado.
    LogicalName   varchar(150),
    PhysicalName  varchar(150),
    Type          varchar(10),
    FileGroupName varchar(40),
    Size          bigint,
    MaxSize       bigint
  )

  if (master.dbo.fn_dba_cataString(@@version, '-', '>') like '%2005%')
  begin
    alter table #DbaRESTOREFILELISTONLY add
      -- Campos novos para o SQL 2005.
      CreateLSN     numeric(25,0),
      DropLSN       numeric(25,0),
      UniqueID      uniqueidentifier,
      ReadOnlyLSN   numeric(25,0),
      ReadWriteLSN  numeric(25,0),
      BackupSizeInBytes bigint,
      SourceBlockSize   int,
      FileGroupID       int,
      LogGroupGUID      uniqueidentifier,
      DifferentialBaseLSN  numeric(25,0),
      DifferentialBaseGUID uniqueidentifier,
      IsReadOnly           bit,
      IsPresent            bit
  end

  -- select master.dbo.fn_dba_cataString(@@version, '-', '>')
  if master.dbo.fn_dba_cataString(@@version, '-', '>') like '%2000%'
  begin
    select @varExec = 'insert into #DbaRESTOREFILELISTONLY (LogicalName, PhysicalName, Type, FileGroupName, Size, MaxSize)
    exec (''RESTORE FILELISTONLY FROM disk = ''''' + @caminhoBak + ''''''')'
    exec (@varExec)
  end
  else
  begin
    select @varExec = 'insert into #DbaRESTOREFILELISTONLY (LogicalName, PhysicalName, Type, FileGroupName, Size, MaxSize, FileId, CreateLSN, DropLSN, UniqueID, ReadOnlyLSN, ReadWriteLSN, BackupSizeInBytes, SourceBlockSize, FileGroupID, LogGroupGUID, DifferentialBaseLSN, DifferentialBaseGUID, IsReadOnly, IsPresent)
    exec (''RESTORE FILELISTONLY FROM disk = ''''' + @caminhoBak + ''''''')'
    exec (@varExec)
  end

  if ( @@error <> 0 )
  begin
    RAISERROR ('ERRO: Insert da tabela #DbaRESTOREFILELISTONLY.', @severity, 1) WITH NOWAIT
    RETURN
  end
  -- Pegando os datafiles do Backup ----------------------------

  -- Pegando os datafiles do BA --------------------------------
  create table #DbaDataFiles (
    fileId   tinyint,
    nome     varchar(100),
    fileName varchar(200)
  )

  select @varExec = 'select fileid, rtrim(name), rtrim(fileName) ' + 'from ' + @ba + '.dbo.sysfiles (NOLOCK) order by fileid'
  insert into #DbaDataFiles
  exec (@varExec)
  if ( @@error <> 0 )
  begin
    print ''
    RAISERROR ('ERRO: Insert da tabela #DbaDataFiles.', @severity, 1) WITH NOWAIT
    RETURN
  end
  -- Pegando os datafiles do BA --------------------------------

  -- Validando se a quantidade de Datafiles esta diferente entre o Backup e o BA -----------
  select @count_DbaRESTOREFILELISTONLY = count(*) from #DbaRESTOREFILELISTONLY
  select @count_DbaDataFiles           = count(*) from #DbaDataFiles

  if (@count_DbaRESTOREFILELISTONLY <> @count_DbaDataFiles)
  begin
    print ''
    select @RAISERROR = 'ERRO: A quantidade de Datafiles está diferente:' + char(10) +
    @caminhoBak + ' (' + convert(varchar(2), @count_DbaRESTOREFILELISTONLY) + ')' + char(10) +
    @ba + ' (' + convert(varchar(2), @count_DbaDataFiles) + ')'
    RAISERROR (@RAISERROR, @severity, 1) WITH NOWAIT
    RETURN
  end
  -- Validando se a quantidade de Datafiles esta diferente entre o Backup e o BA -----------

  -- Acertando os IDs dos datafiles do BA que vai ser restaurado com os do Backup.
  update #DbaRESTOREFILELISTONLY
  set fileId = b.fileId
  from #DbaRESTOREFILELISTONLY a, #DbaDataFiles b
  --Comparando o final do arquivo, que indica sua numeração e seu tipo, ou então compara o nome todo, se for igual.
  where substring(a.LogicalName, len(a.LogicalName)-3, 4) = substring(b.nome, len(b.nome)-3, 4)
     or a.LogicalName = b.nome

  if (@debug = 1)
  begin
    select fileId, convert(varchar(30), nome) [nome], fileName from #DbaDataFiles order by fileId
    select fileId, convert(varchar(30), LogicalName) [LogicalName], PhysicalName from #DbaRESTOREFILELISTONLY order by fileId

    select a.fileId, b.fileId, convert(varchar(30), a.LogicalName) [logicalName], substring(a.LogicalName, len(a.LogicalName)-3, 4)[substring1], substring(b.nome, len(b.nome)-3, 4)[substring2], b.nome, a.PhysicalName, b.fileName
    from #DbaRESTOREFILELISTONLY a, #DbaDataFiles b
    where substring(a.LogicalName, len(a.LogicalName)-3, 4) = substring(b.nome, len(b.nome)-3, 4)
       or a.LogicalName = b.nome
  end
  -- Acertando os IDs dos datafiles do BA que vai ser restaurado com os do Backup.

  select @varExec = ''
  select @varExec = 
    'RESTORE DATABASE ' + @ba + char(10) +
    'FROM DISK = ''' + @caminhoBak + '''' + char(10) + 'WITH' + char(10)

  -- Pego o maior ID dos datafiles do BA corrente.
  select @fileIdMax = max(fileId) from #DbaDataFiles

  -- Aqui concateno variaveis com os campos. Enquanto tiver datafiles vai colocando o campo 4 e 5
  while ( @i <= @fileIdMax )
  begin
    -- Pego o nome e o caminho do datafile do ba atual.
    select @filenome     = fileName    from #DbaDataFiles           where fileId = @i
    select @nomeDataFile = LogicalName from #DbaRESTOREFILELISTONLY where fileId = @i

    if (@debug = 1)
    begin
      select @i [fileId]
      select @nomeDataFile [@nomeDataFile]
      select @filenome [@filenome]
    end

    -- Continuo concatenando...
    select @varExec = @varExec + 'MOVE ''' + @nomeDataFile + ''' TO ''' + @filenome + ''',' + char(10)
    select @i = @i + 1
  end

  if (@mostraStats = 'S')
    select @varExec = @varExec + 'replace, stats = 1'
  else
    select @varExec = @varExec + 'replace'

  if ((@@servername like '%BD_CONT%') and (@ba like 'Evolution%'))
  begin
    if exists (select 1 from tempdb.dbo.sysobjects (nolock) where name like '#xp_cmdshell%')
      drop table #xp_cmdshell
    create table #xp_cmdshell (rowId tinyint identity, retorno varchar(100))

    insert into #xp_cmdshell exec master.dbo.xp_cmdshell 'Net stop EVOProcessaIntegracao'
    insert into #xp_cmdshell exec master.dbo.xp_cmdshell 'Net stop EVOProtocolosSQL'
    insert into #xp_cmdshell exec master.dbo.xp_cmdshell 'Net stop EVORetornoEntidadeExternaREQRSP'
    insert into #xp_cmdshell exec master.dbo.xp_cmdshell 'Net stop EVOServicosGerais'

    select retorno [Net stop] from #xp_cmdshell where retorno like 'The %'
  end

  -->> faz o KILL do BA chamando a proc BA_DBA.dbo.sp_dba_desconectaUsuario -----------------------
  exec BA_DBA.dbo.sp_dba_desconectaUsuario @ba
  --   faz o KILL do BA chamando a proc BA_DBA.dbo.sp_dba_desconectaUsuario -----------------------

  if (@debug = 1)
  begin
    print @varExec
    print ''
  end

  select @RAISERROR = 'RESTORE do "' + @ba + '" em andamento...'
  RAISERROR (@RAISERROR, 0, 1) WITH NOWAIT
  exec (@varExec)
  if ( @@error <> 0 )
  begin
    print ''
    print 'ERRO: RESTORE com problema.'
    exec sp_dba_who @ba
    RETURN
  end

  if ((@@servername like '%BD_CONT%') and (@ba like 'Evolution%'))
  begin
    delete #xp_cmdshell

    insert into #xp_cmdshell exec master.dbo.xp_cmdshell 'Net start EVOProcessaIntegracao'
    insert into #xp_cmdshell exec master.dbo.xp_cmdshell 'Net start EVOProtocolosSQL'
    insert into #xp_cmdshell exec master.dbo.xp_cmdshell 'Net start EVORetornoEntidadeExternaREQRSP'
    insert into #xp_cmdshell exec master.dbo.xp_cmdshell 'Net start EVOServicosGerais'

    select retorno [Net start] from #xp_cmdshell where retorno like 'The %'
  end
  print ''

  -- AutoFIX ----------------------------------------------------
  exec sp_dba_autofix @ba
  print ''
  -- AutoFIX ----------------------------------------------------

  -- Compacta o arquivo -----------------------------------------
  if ( @@servername like '%BD_HMLG%' ) or ( @apagaArquivo = 'S' )
  begin
    print 'Deletando arquivo "' + @caminhoBak + '".'
    select @caminhoBak = 'del ' + @caminhoBak
    exec master.dbo.xp_cmdshell @caminhoBak, no_output
    print 'Delete feito.'
  end
  else
  if (@recompactaBAK = 'S')
    exec BA_DBA.dbo.sp_dba_gzipa @caminhoBak, 'S'
  -- Compacta o arquivo -----------------------------------------

  -- Faz Shrink no BA -------------------------------------------
  if (@fazShrink = 'S')
  begin
    select @RAISERROR = 'Shrink do "' + @ba + '" em andamento...'
    RAISERROR (@RAISERROR, 0, 1) WITH NOWAIT
    exec BA_DBA.dbo.sp_dba_trataPropriedadeBa @ba, @trataReadOnly = 'S'
    DBCC SHRINKDATABASE(@ba)
    exec BA_DBA.dbo.sp_dba_trataPropriedadeBa @ba, @trataReadOnly = 'S'
    RAISERROR ('Shrink feito.', 0, 1) WITH NOWAIT
  end
  -- Faz Shrink no BA -------------------------------------------

  if (@@servername = 'BD_EXP01D')
  begin
    exec BA_DBA.dbo.sp_dba_trataPropriedadeBa @ba, @trataReadOnly = 'S'
    exec (@ba + '.dbo.sp_createstats')
    exec (@ba + '.dbo.sp_updatestats')
    exec BA_DBA.dbo.sp_dba_trataPropriedadeBa @ba, @trataReadOnly = 'S'
  end

  print '--------------------------------------------------------' --Para pular uma linha no output do JOB de restore
  drop table #DbaDataFiles
  drop table #DbaRESTOREFILELISTONLY

END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

