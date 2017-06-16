select 'Executar no master durante a execuçao dos jobs'
go

		SELECT
			S.[host_name], 
			DB_NAME(R.database_id) as [database_name],
			(CASE WHEN S.program_name like 'SQLAgent - TSQL JobStep (Job %' THEN  j.name ELSE S.program_name END) as Name , 
			S.login_name, 
			cast(('<?query --'+b.text+'--?>') as XML) as sql_text,
			R.blocking_session_id, 
			R.session_id,
			COALESCE(R.CPU_time, S.CPU_time) AS CPU_ms,
			isnull(DATEDIFF(mi, S.last_request_start_time, getdate()), 0) [MinutesRunning],
			GETDATE()
		FROM sys.dm_exec_requests R with (nolock)
		INNER JOIN sys.dm_exec_sessions S with (nolock)
			ON R.session_id = S.session_id
		OUTER APPLY sys.dm_exec_sql_text(R.sql_handle) b
		OUTER APPLY sys.dm_exec_query_plan (R.plan_handle) AS qp
		LEFT OUTER JOIN msdb.dbo.sysjobs J with (nolock)
			ON (substring(left(j.job_id,8),7,2) +
				substring(left(j.job_id,8),5,2) +
				substring(left(j.job_id,8),3,2) +
				substring(left(j.job_id,8),1,2))  = substring(S.program_name,32,8)
		WHERE R.session_id <> @@SPID
			and S.[host_name] IS NOT NULL
		ORDER BY s.[host_name],S.login_name;
	