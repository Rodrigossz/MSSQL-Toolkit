use master
go
create proc sp_dba_tran
as
set nocount on
SELECT 
	tat.transaction_id [TransactionID],
	tat.transaction_begin_time [TranBeginTime],
	CASE tat.transaction_type
		WHEN 1 THEN 'Read/Write transaction'
		WHEN 2 THEN 'Read-only transaction'
		WHEN 3 THEN 'System transaction'
		WHEN 4 THEN 'Distributed transaction'
	END [TranType],
	CASE tat.transaction_state
		WHEN 0 THEN 'Not completely initialized'
		WHEN 1 THEN 'Initialized but not started'
		WHEN 2 THEN 'Active'
		WHEN 3 THEN 'Ended(read-only transaction)'
		WHEN 4 THEN 'Commit initiated for distributed transaction'
		WHEN 5 THEN 'Transaction prepared and waiting for resolution'
		WHEN 6 THEN 'Committed'
		WHEN 7 THEN 'Transaction is being rolled back'
		WHEN 8 THEN 'Rolled back'
	END [TranStatus],
	tst.session_id [SPID],
	tst.is_user_transaction [IsUserTransaction],
	s.[text] [MostRecentSQLRun]
FROM 
	sys.dm_tran_active_transactions [tat] 
	
	JOIN sys.dm_tran_session_transactions [tst]
		ON tat.transaction_id = tat.transaction_id
		
	JOIN sys.dm_exec_connections [dec]
		ON [dec].session_id = tst.session_id
	
	CROSS APPLY sys.dm_exec_sql_text([dec].most_recent_sql_handle) s

ORDER BY
	[TranBeginTime]
	
