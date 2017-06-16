USE [FidelidadeDb]
GO
/****** Object:  StoredProcedure [dbo].[pr_vwResgate_sel_Email_Data_Enviado]    Script Date: 05/12/2011 15:06:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER proc [dbo].[pr_vwResgate_sel_Email_Data_Enviado]
@email tdemail = null, @dtIni date, @dtFim date, @enviado bit
--with execute as owner
ASSET NOCOUNT ONif @enviado = 1SELECT * FROM vwResgateWHERE email = isnull(@email,email) andconvert(date,dataHoraResgate) between @dtIni and @dtFim andcodRastreio is not nullelseSELECT * FROM vwResgateWHERE email = isnull(@email,email) andconvert(date,dataHoraResgate) between @dtIni and @dtFim andcodRastreio is  nullSET NOCOUNT OFF
