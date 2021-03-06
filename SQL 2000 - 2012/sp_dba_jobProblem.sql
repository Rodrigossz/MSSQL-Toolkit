USE [msdb]
GO
/****** Object:  StoredProcedure [dbo].[sp_dba_get_composite_job_info]    Script Date: 09/02/2011 10:48:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create proc  [dbo].[sp_dba_get_composite_job_infoProblem]  
  @job_id             UNIQUEIDENTIFIER = NULL,  
  @job_type           VARCHAR(12)      = NULL,  -- LOCAL or MULTI-SERVER  
  @owner_login_name   sysname          = NULL,  
  @subsystem          NVARCHAR(40)     = NULL,  
  @category_id        INT              = NULL,  
  @enabled            TINYINT          = NULL,  
  @execution_status   INT              = NULL,  -- 0 = Not idle or suspended, 1 = Executing, 2 = Waiting For Thread, 3 = Between Retries, 4 = Idle, 5 = Suspended, [6 = WaitingForStepToFinish], 7 = PerformingCompletionActions  
  @date_comparator    CHAR(1)          = NULL,  -- >, < or =  
  @date_created       DATETIME         = NULL,  
  @date_last_modified DATETIME         = NULL,  
  @description        NVARCHAR(512)    = NULL,  -- We do a LIKE on this so it can include wildcards  
  @schedule_id        INT              = NULL   -- if supplied only return the jobs that use this schedule  
  WITH EXECUTE AS OWNER
AS  
BEGIN  
  DECLARE @can_see_all_running_jobs INT  
  DECLARE @job_owner   sysname  
  
  SET NOCOUNT ON  
  
  -- By 'composite' we mean a combination of sysjobs and xp_sqlagent_enum_jobs data.  
  -- This proc should only ever be called by sp_help_job, so we don't verify the  
  -- parameters (sp_help_job has already done this).  
  
  -- Step 1: Create intermediate work tables  
  DECLARE @job_execution_state TABLE (job_id                  UNIQUEIDENTIFIER NOT NULL,  
                                     date_started            INT              NOT NULL,  
                                     time_started            INT              NOT NULL,  
                                     execution_job_status    INT              NOT NULL,  
                                     execution_step_id       INT              NULL,  
                                     execution_step_name     sysname          COLLATE database_default NULL,  
                                     execution_retry_attempt INT              NOT NULL,  
                                     next_run_date           INT              NOT NULL,  
                                     next_run_time           INT              NOT NULL,  
                                     next_run_schedule_id    INT              NOT NULL)  
  DECLARE @filtered_jobs TABLE (job_id                   UNIQUEIDENTIFIER NOT NULL,  
                               date_created             DATETIME         NOT NULL,  
                               date_last_modified       DATETIME         NOT NULL,  
                               current_execution_status INT              NULL,  
                               current_execution_step   sysname          COLLATE database_default NULL,  
                               current_retry_attempt    INT              NULL,  
                               last_run_date            INT              NOT NULL,  
                               last_run_time            INT              NOT NULL,  
                               last_run_outcome         INT              NOT NULL,  
                               next_run_date            INT              NULL,  
                               next_run_time            INT              NULL,  
                               next_run_schedule_id     INT              NULL,  
                               type                     INT              NOT NULL)  
  DECLARE @xp_results TABLE (job_id                UNIQUEIDENTIFIER NOT NULL,  
                            last_run_date         INT              NOT NULL,  
                            last_run_time         INT              NOT NULL,  
                            next_run_date         INT              NOT NULL,  
                            next_run_time         INT              NOT NULL,  
                            next_run_schedule_id  INT              NOT NULL,  
                            requested_to_run      INT              NOT NULL, -- BOOL  
                            request_source        INT              NOT NULL,  
                            request_source_id     sysname          COLLATE database_default NULL,  
                            running               INT              NOT NULL, -- BOOL  
                            current_step          INT              NOT NULL,  
                            current_retry_attempt INT              NOT NULL,  
                            job_state             INT              NOT NULL)  
  
  -- Step 2: Capture job execution information (for local jobs only since that's all SQLServerAgent caches)  
  SELECT @can_see_all_running_jobs = ISNULL(IS_SRVROLEMEMBER(N'sysadmin'), 0)  
  IF (@can_see_all_running_jobs = 0)  
  BEGIN  
    SELECT @can_see_all_running_jobs = ISNULL(IS_MEMBER(N'SQLAgentReaderRole'), 0)  
  END  
  SELECT @job_owner = SUSER_SNAME()  
  
  IF ((@@microsoftversion / 0x01000000) >= 8) -- SQL Server 8.0 or greater  
    INSERT INTO @xp_results  
    EXECUTE master.dbo.xp_sqlagent_enum_jobs @can_see_all_running_jobs, @job_owner, @job_id  
  ELSE  
    INSERT INTO @xp_results  
    EXECUTE master.dbo.xp_sqlagent_enum_jobs @can_see_all_running_jobs, @job_owner  
  
  INSERT INTO @job_execution_state  
  SELECT xpr.job_id,  
         xpr.last_run_date,  
         xpr.last_run_time,  
         xpr.job_state,  
         sjs.step_id,  
         sjs.step_name,  
         xpr.current_retry_attempt,  
         xpr.next_run_date,  
         xpr.next_run_time,  
         xpr.next_run_schedule_id  
  FROM @xp_results                          xpr  
       LEFT OUTER JOIN msdb.dbo.sysjobsteps sjs ON ((xpr.job_id = sjs.job_id) AND (xpr.current_step = sjs.step_id)),  
       msdb.dbo.sysjobs_view                sjv  
  WHERE (sjv.job_id = xpr.job_id)  
  
  -- Step 3: Filter on everything but dates and job_type  
  IF ((@subsystem        IS NULL) AND  
      (@owner_login_name IS NULL) AND  
      (@enabled          IS NULL) AND  
      (@category_id      IS NULL) AND  
      (@execution_status IS NULL) AND  
      (@description      IS NULL) AND  
      (@job_id           IS NULL))  
  BEGIN  
    -- Optimize for the frequently used case...  
    INSERT INTO @filtered_jobs  
    SELECT sjv.job_id,  
           sjv.date_created,  
           sjv.date_modified,  
           ISNULL(jes.execution_job_status, 4), -- Will be NULL if the job is non-local or is not in @job_execution_state (NOTE: 4 = STATE_IDLE)  
           CASE ISNULL(jes.execution_step_id, 0)  
             WHEN 0 THEN NULL                   -- Will be NULL if the job is non-local or is not in @job_execution_state  
             ELSE CONVERT(NVARCHAR, jes.execution_step_id) + N' (' + jes.execution_step_name + N')'  
           END,  
           jes.execution_retry_attempt,         -- Will be NULL if the job is non-local or is not in @job_execution_state  
           0,  -- last_run_date placeholder    (we'll fix it up in step 3.3)  
           0,  -- last_run_time placeholder    (we'll fix it up in step 3.3)  
           5,  -- last_run_outcome placeholder (we'll fix it up in step 3.3 - NOTE: We use 5 just in case there are no jobservers for the job)  
           jes.next_run_date,                   -- Will be NULL if the job is non-local or is not in @job_execution_state  
           jes.next_run_time,                   -- Will be NULL if the job is non-local or is not in @job_execution_state  
           jes.next_run_schedule_id,            -- Will be NULL if the job is non-local or is not in @job_execution_state  
           0   -- type placeholder             (we'll fix it up in step 3.4)  
    FROM msdb.dbo.sysjobs_view                sjv  
         LEFT OUTER JOIN @job_execution_state jes ON (sjv.job_id = jes.job_id)  
    WHERE ((@schedule_id IS NULL)  
      OR   (EXISTS(SELECT *   
                 FROM sysjobschedules as js  
                 WHERE (sjv.job_id = js.job_id)  
                   AND (js.schedule_id = @schedule_id))))  
  END  
  ELSE  
  BEGIN  
    INSERT INTO @filtered_jobs  
    SELECT DISTINCT  
           sjv.job_id,  
           sjv.date_created,  
           sjv.date_modified,  
           ISNULL(jes.execution_job_status, 4), -- Will be NULL if the job is non-local or is not in @job_execution_state (NOTE: 4 = STATE_IDLE)  
           CASE ISNULL(jes.execution_step_id, 0)  
             WHEN 0 THEN NULL                   -- Will be NULL if the job is non-local or is not in @job_execution_state  
             ELSE CONVERT(NVARCHAR, jes.execution_step_id) + N' (' + jes.execution_step_name + N')'  
           END,  
           jes.execution_retry_attempt,         -- Will be NULL if the job is non-local or is not in @job_execution_state  
           0,  -- last_run_date placeholder    (we'll fix it up in step 3.3)  
           0,  -- last_run_time placeholder    (we'll fix it up in step 3.3)  
           5,  -- last_run_outcome placeholder (we'll fix it up in step 3.3 - NOTE: We use 5 just in case there are no jobservers for the job)  
           jes.next_run_date,                   -- Will be NULL if the job is non-local or is not in @job_execution_state  
           jes.next_run_time,                   -- Will be NULL if the job is non-local or is not in @job_execution_state  
           jes.next_run_schedule_id,            -- Will be NULL if the job is non-local or is not in @job_execution_state  
           0   -- type placeholder             (we'll fix it up in step 3.4)  
    FROM msdb.dbo.sysjobs_view                sjv  
         LEFT OUTER JOIN @job_execution_state jes ON (sjv.job_id = jes.job_id)  
         LEFT OUTER JOIN msdb.dbo.sysjobsteps sjs ON (sjv.job_id = sjs.job_id)  
    WHERE ((@subsystem        IS NULL) OR (sjs.subsystem            = @subsystem))  
      AND ((@owner_login_name IS NULL)   
          OR (sjv.owner_sid            = dbo.SQLAGENT_SUSER_SID(@owner_login_name)))--force case insensitive comparation for NT users  
      AND ((@enabled          IS NULL) OR (sjv.enabled              = @enabled))  
      AND ((@category_id      IS NULL) OR (sjv.category_id          = @category_id))  
      AND ((@execution_status IS NULL) OR ((@execution_status > 0) AND (jes.execution_job_status = @execution_status))  
                                       OR ((@execution_status = 0) AND (jes.execution_job_status <> 4) AND (jes.execution_job_status <> 5)))  
      AND ((@description      IS NULL) OR (sjv.description       LIKE @description))  
      AND ((@job_id           IS NULL) OR (sjv.job_id               = @job_id))  
      AND ((@schedule_id IS NULL)  
        OR (EXISTS(SELECT *   
                 FROM sysjobschedules as js  
                 WHERE (sjv.job_id = js.job_id)  
                   AND (js.schedule_id = @schedule_id))))  
  END  
  
  -- Step 3.1: Change the execution status of non-local jobs from 'Idle' to 'Unknown'  
  UPDATE @filtered_jobs  
  SET current_execution_status = NULL  
  WHERE (current_execution_status = 4)  
    AND (job_id IN (SELECT job_id  
                    FROM msdb.dbo.sysjobservers  
                    WHERE (server_id <> 0)))  
  
  -- Step 3.2: Check that if the user asked to see idle jobs that we still have some.  
  --           If we don't have any then the query should return no rows.  
  IF (@execution_status = 4) AND  
     (NOT EXISTS (SELECT *  
                  FROM @filtered_jobs  
                  WHERE (current_execution_status = 4)))  
  BEGIN  
    DELETE FROM @filtered_jobs  
  END  
  
  -- Step 3.3: Populate the last run date/time/outcome [this is a little tricky since for  
  --           multi-server jobs there are multiple last run details in sysjobservers, so  
  --           we simply choose the most recent].  
  IF (EXISTS (SELECT *  
              FROM msdb.dbo.systargetservers))  
  BEGIN  
    UPDATE @filtered_jobs  
    SET last_run_date = sjs.last_run_date,  
        last_run_time = sjs.last_run_time,  
        last_run_outcome = sjs.last_run_outcome  
    FROM @filtered_jobs         fj,  
         msdb.dbo.sysjobservers sjs  
    WHERE (CONVERT(FLOAT, sjs.last_run_date) * 1000000) + sjs.last_run_time =  
           (SELECT MAX((CONVERT(FLOAT, last_run_date) * 1000000) + last_run_time)  
            FROM msdb.dbo.sysjobservers  
            WHERE (job_id = sjs.job_id))  
      AND (fj.job_id = sjs.job_id)  
  END  
  ELSE  
  BEGIN  
    UPDATE @filtered_jobs  
    SET last_run_date = sjs.last_run_date,  
        last_run_time = sjs.last_run_time,  
        last_run_outcome = sjs.last_run_outcome  
    FROM @filtered_jobs         fj,  
         msdb.dbo.sysjobservers sjs  
    WHERE (fj.job_id = sjs.job_id)  
  END  
  
  -- Step 3.4 : Set the type of the job to local (1) or multi-server (2)  
  --            NOTE: If the job has no jobservers then it wil have a type of 0 meaning  
  --                  unknown.  This is marginally inconsistent with the behaviour of  
  --                  defaulting the category of a new job to [Uncategorized (Local)], but  
  --                  prevents incompletely defined jobs from erroneously showing up as valid  
  --                  local jobs.  
  UPDATE @filtered_jobs  
  SET type = 1 -- LOCAL  
  FROM @filtered_jobs         fj,  
       msdb.dbo.sysjobservers sjs  
  WHERE (fj.job_id = sjs.job_id)  
    AND (server_id = 0)  
  UPDATE @filtered_jobs  
  SET type = 2 -- MULTI-SERVER  
  FROM @filtered_jobs         fj,  
       msdb.dbo.sysjobservers sjs  
  WHERE (fj.job_id = sjs.job_id)  
    AND (server_id <> 0)  
  
  -- Step 4: Filter on job_type  
  IF (@job_type IS NOT NULL)  
  BEGIN  
    IF (UPPER(@job_type collate SQL_Latin1_General_CP1_CS_AS) = 'LOCAL')  
      DELETE FROM @filtered_jobs  
      WHERE (type <> 1) -- IE. Delete all the non-local jobs  
    IF (UPPER(@job_type collate SQL_Latin1_General_CP1_CS_AS) = 'MULTI-SERVER')  
      DELETE FROM @filtered_jobs  
      WHERE (type <> 2) -- IE. Delete all the non-multi-server jobs  
  END  
  
  -- Step 5: Filter on dates  
  IF (@date_comparator IS NOT NULL)  
  BEGIN  
    IF (@date_created IS NOT NULL)  
    BEGIN  
      IF (@date_comparator = '=')  
        DELETE FROM @filtered_jobs WHERE (date_created <> @date_created)  
      IF (@date_comparator = '>')  
        DELETE FROM @filtered_jobs WHERE (date_created <= @date_created)  
      IF (@date_comparator = '<')  
        DELETE FROM @filtered_jobs WHERE (date_created >= @date_created)  
    END  
    IF (@date_last_modified IS NOT NULL)  
    BEGIN  
      IF (@date_comparator = '=')  
        DELETE FROM @filtered_jobs WHERE (date_last_modified <> @date_last_modified)  
      IF (@date_comparator = '>')  
        DELETE FROM @filtered_jobs WHERE (date_last_modified <= @date_last_modified)  
      IF (@date_comparator = '<')  
        DELETE FROM @filtered_jobs WHERE (date_last_modified >= @date_last_modified)  
    END  
  END  
  
  SELECT sjv.name,  
         sjv.enabled,  
         last_run_status= case  
         when fj.last_run_outcome = 0 THEN 'Failed'  
         when fj.last_run_outcome = 1 THEN 'Succeeded'  
         when fj.last_run_outcome = 3 THEN 'Canceled/Running'  
         when fj.last_run_outcome = 5 THEN 'Unknown' end,  
         STATUS=   
CASE  
WHEN ja.start_execution_date IS NOT NULL AND  
ja.stop_execution_date IS NULL THEN 'Running'  
ELSE  
'Idle'  
END,     
duration_Min=isnull(datediff(MI,ja.start_execution_date,ja.stop_execution_date), 0),  
last_execution_date=ja.stop_execution_date,  
        ja.next_scheduled_run_date  
         FROM @filtered_jobs                         fj  
       LEFT OUTER JOIN msdb.dbo.sysjobs_view  sjv ON (fj.job_id = sjv.job_id)  
       LEFT OUTER JOIN msdb.dbo.sysjobactivity  ja ON (fj.job_id = ja.job_id)  
       LEFT OUTER JOIN msdb.dbo.sysoperators  so1 ON (sjv.notify_email_operator_id = so1.id)  
       LEFT OUTER JOIN msdb.dbo.sysoperators  so2 ON (sjv.notify_netsend_operator_id = so2.id)  
       LEFT OUTER JOIN msdb.dbo.sysoperators  so3 ON (sjv.notify_page_operator_id = so3.id)  
       LEFT OUTER JOIN msdb.dbo.syscategories sc  ON (sjv.category_id = sc.category_id)   
       where  
       ja.start_execution_date = (select MAX(start_execution_date) from msdb.dbo.sysjobactivity  ja2 where  
       ja.job_id = ja2.job_id)  
       and (
       (last_run_outcome <> 1 ) or
(isnull(datediff(MI,ja.start_execution_date,ja.stop_execution_date), 0) > 5) or
(start_execution_date IS NOT NULL AND  ja.stop_execution_date is null))
        
  ORDER BY sjv.name  
  
END
go
create proc  [dbo].[sp_dba_jobProblem]
  -- Individual job parameters
  @job_id                     UNIQUEIDENTIFIER = NULL,  -- If provided should NOT also provide job_name
  @job_name                   sysname          = NULL,  -- If provided should NOT also provide job_id
  @job_aspect                 VARCHAR(9)       = NULL,  -- JOB, STEPS, SCHEDULES, TARGETS or ALL
  -- Job set parameters
  @job_type                   VARCHAR(12)      = NULL,  -- LOCAL or MULTI-SERVER
  @owner_login_name           sysname          = NULL,
  @subsystem                  NVARCHAR(40)     = NULL,
  @category_name              sysname          = NULL,
  @enabled                    TINYINT          = NULL,
  @execution_status           INT              = NULL,  -- 1 = Executing, 2 = Waiting For Thread, 3 = Between Retries, 4 = Idle, 5 = Suspended, 6 = [obsolete], 7 = PerformingCompletionActions
  @date_comparator            CHAR(1)          = NULL,  -- >, < or =
  @date_created               DATETIME         = NULL,
  @date_last_modified         DATETIME         = NULL,
  @description                NVARCHAR(512)    = NULL   -- We do a LIKE on this so it can include wildcards
WITH EXECUTE AS OWNER

AS
BEGIN
  DECLARE @retval          INT
  DECLARE @category_id     INT
  DECLARE @job_id_as_char  VARCHAR(36)
  DECLARE @res_valid_range NVARCHAR(200)

  SET NOCOUNT ON

  -- Remove any leading/trailing spaces from parameters (except @owner_login_name)
  SELECT @job_name         = LTRIM(RTRIM(@job_name))
  SELECT @job_aspect       = LTRIM(RTRIM(@job_aspect))
  SELECT @job_type         = LTRIM(RTRIM(@job_type))
  SELECT @subsystem        = LTRIM(RTRIM(@subsystem))
  SELECT @category_name    = LTRIM(RTRIM(@category_name))
  SELECT @description      = LTRIM(RTRIM(@description))

  -- Turn [nullable] empty string parameters into NULLs
  IF (@job_name         = N'') SELECT @job_name = NULL
  IF (@job_aspect       = '')  SELECT @job_aspect = NULL
  IF (@job_type         = '')  SELECT @job_type = NULL
  IF (@owner_login_name = N'') SELECT @owner_login_name = NULL
  IF (@subsystem        = N'') SELECT @subsystem = NULL
  IF (@category_name    = N'') SELECT @category_name = NULL
  IF (@description      = N'') SELECT @description = NULL

  IF ((@job_id IS NOT NULL) OR (@job_name IS NOT NULL))
  BEGIN
    EXECUTE @retval = sp_verify_job_identifiers '@job_name',
                                                '@job_id',
                                                 @job_name OUTPUT,
                                                 @job_id   OUTPUT
    IF (@retval <> 0)
      RETURN(1) -- Failure
  END

  SELECT @job_id_as_char = CONVERT(VARCHAR(36), @job_id)

  -- If the user provided a job name or id but no aspect, default to ALL
  IF ((@job_name IS NOT NULL) OR (@job_id IS NOT NULL)) AND (@job_aspect IS NULL)
    SELECT @job_aspect = 'ALL'

  -- The caller must supply EITHER job name (or job id) and aspect OR one-or-more of the set
  -- parameters OR no parameters at all
  IF (((@job_name IS NOT NULL) OR (@job_id IS NOT NULL))
      AND ((@job_aspect          IS NULL)     OR
           (@job_type            IS NOT NULL) OR
           (@owner_login_name    IS NOT NULL) OR
           (@subsystem           IS NOT NULL) OR
           (@category_name       IS NOT NULL) OR
           (@enabled             IS NOT NULL) OR
           (@date_comparator     IS NOT NULL) OR
           (@date_created        IS NOT NULL) OR
           (@date_last_modified  IS NOT NULL)))
     OR
     ((@job_name IS NULL) AND (@job_id IS NULL) AND (@job_aspect IS NOT NULL))
  BEGIN
    RAISERROR(14280, -1, -1)
    RETURN(1) -- Failure
  END

  IF (@job_id IS NOT NULL)
  BEGIN
    -- Individual job...

    -- Check job aspect
    SELECT @job_aspect = UPPER(@job_aspect collate SQL_Latin1_General_CP1_CS_AS)
    IF (@job_aspect NOT IN ('JOB', 'STEPS', 'SCHEDULES', 'TARGETS', 'ALL'))
    BEGIN
      RAISERROR(14266, -1, -1, '@job_aspect', 'JOB, STEPS, SCHEDULES, TARGETS, ALL')
      RETURN(1) -- Failure
    END

    -- Generate results set...

    IF (@job_aspect IN ('JOB', 'ALL'))
    BEGIN
      IF (@job_aspect = 'ALL')
      BEGIN
        RAISERROR(14213, 0, 1)
        PRINT REPLICATE('=', DATALENGTH(FORMATMESSAGE(14213)) / 2)
      END
      EXECUTE sp_dba_get_composite_job_infoProblem @job_id,
                                        @job_type,
                                        @owner_login_name,
                                        @subsystem,
                                        @category_id,
                                        @enabled,
                                        @execution_status,
                                        @date_comparator,
                                        @date_created,
                                        @date_last_modified,
                                        @description
    END

    IF (@job_aspect IN ('STEPS', 'ALL'))
    BEGIN
      IF (@job_aspect = 'ALL')
      BEGIN
        PRINT ''
        RAISERROR(14214, 0, 1)
        PRINT REPLICATE('=', DATALENGTH(FORMATMESSAGE(14214)) / 2)
      END
      EXECUTE ('EXECUTE sp_help_jobstep @job_id = ''' + @job_id_as_char + ''', @suffix = 1')
    END

    IF (@job_aspect IN ('SCHEDULES', 'ALL'))
    BEGIN
      IF (@job_aspect = 'ALL')
      BEGIN
        PRINT ''
        RAISERROR(14215, 0, 1)
        PRINT REPLICATE('=', DATALENGTH(FORMATMESSAGE(14215)) / 2)
      END
      EXECUTE ('EXECUTE sp_help_jobschedule @job_id = ''' + @job_id_as_char + '''')
    END

    IF (@job_aspect IN ('TARGETS', 'ALL'))
    BEGIN
      IF (@job_aspect = 'ALL')
      BEGIN
        PRINT ''
        RAISERROR(14216, 0, 1)
        PRINT REPLICATE('=', DATALENGTH(FORMATMESSAGE(14216)) / 2)
      END
      EXECUTE ('EXECUTE sp_help_jobserver @job_id = ''' + @job_id_as_char + ''', @show_last_run_details = 1')
    END
  END
  ELSE
  BEGIN
    -- Set of jobs...

    -- Check job type
    IF (@job_type IS NOT NULL)
    BEGIN
      SELECT @job_type = UPPER(@job_type collate SQL_Latin1_General_CP1_CS_AS)
      IF (@job_type NOT IN ('LOCAL', 'MULTI-SERVER'))
      BEGIN
        RAISERROR(14266, -1, -1, '@job_type', 'LOCAL, MULTI-SERVER')
        RETURN(1) -- Failure
      END
    END

    -- Check owner
    IF (@owner_login_name IS NOT NULL)
    BEGIN
      IF (SUSER_SID(@owner_login_name, 0) IS NULL)--force case insensitive comparation for NT users
      BEGIN
        RAISERROR(14262, -1, -1, '@owner_login_name', @owner_login_name)
        RETURN(1) -- Failure
      END
    END

    -- Check subsystem
    IF (@subsystem IS NOT NULL)
    BEGIN
      EXECUTE @retval = sp_verify_subsystem @subsystem
      IF (@retval <> 0)
        RETURN(1) -- Failure
    END

    -- Check job category
    IF (@category_name IS NOT NULL)
    BEGIN
      SELECT @category_id = category_id
      FROM msdb.dbo.syscategories
      WHERE (category_class = 1) -- Job
        AND (name = @category_name)
      IF (@category_id IS NULL)
      BEGIN
        RAISERROR(14262, -1, -1, '@category_name', @category_name)
        RETURN(1) -- Failure
      END
    END

    -- Check enabled state
    IF (@enabled IS NOT NULL) AND (@enabled NOT IN (0, 1))
    BEGIN
      RAISERROR(14266, -1, -1, '@enabled', '0, 1')
      RETURN(1) -- Failure
    END

    -- Check current execution status
    IF (@execution_status IS NOT NULL)
    BEGIN
      IF (@execution_status NOT IN (0, 1, 2, 3, 4, 5, 7))
      BEGIN
        SELECT @res_valid_range = FORMATMESSAGE(14204)
        RAISERROR(14266, -1, -1, '@execution_status', @res_valid_range)
        RETURN(1) -- Failure
      END
    END

    -- If a date comparator is supplied, we must have either a date-created or date-last-modified
    IF ((@date_comparator IS NOT NULL) AND (@date_created IS NOT NULL) AND (@date_last_modified IS NOT NULL)) OR
       ((@date_comparator IS NULL)     AND ((@date_created IS NOT NULL) OR (@date_last_modified IS NOT NULL)))
    BEGIN
      RAISERROR(14282, -1, -1)
      RETURN(1) -- Failure
    END

    -- Check dates / comparator
    IF (@date_comparator IS NOT NULL) AND (@date_comparator NOT IN ('=', '<', '>'))
    BEGIN
      RAISERROR(14266, -1, -1, '@date_comparator', '=, >, <')
      RETURN(1) -- Failure
    END
    IF (@date_created IS NOT NULL) AND
       ((@date_created < '19900101') OR (@date_created > '99991231 23:59'))
    BEGIN
      RAISERROR(14266, -1, -1, '@date_created', '1990-01-01 12:00am .. 9999-12-31 11:59pm')
      RETURN(1) -- Failure
    END
    IF (@date_last_modified IS NOT NULL) AND
       ((@date_last_modified < '19900101') OR (@date_last_modified > '99991231 23:59'))
    BEGIN
      RAISERROR(14266, -1, -1, '@date_last_modified', '1990-01-01 12:00am .. 9999-12-31 11:59pm')
      RETURN(1) -- Failure
    END

    -- Generate results set...
    EXECUTE sp_dba_get_composite_job_infoProblem @job_id,
                                      @job_type,
                                      @owner_login_name,
                                      @subsystem,
                                      @category_id,
                                      @enabled,
                                      @execution_status,
                                      @date_comparator,
                                      @date_created,
                                      @date_last_modified,
                                      @description
  END

  RETURN(0) -- Success
END
go


exec [sp_dba_jobProblem]
go
