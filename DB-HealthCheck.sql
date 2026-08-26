/*
    SQL Server Basic Health Check
    Purpose: Quick DBA server and database health assessment
*/

-- 1. Server information
SELECT
    @@SERVERNAME AS ServerName,
    @@VERSION AS SQLServerVersion,
    GETDATE() AS CheckTime;

-- 2. Database status
SELECT
    name AS DatabaseName,
    state_desc AS DatabaseState,
    recovery_model_desc AS RecoveryModel,
    user_access_desc AS UserAccess
FROM sys.databases
ORDER BY name;

-- 3. Database sizes
SELECT
    DB_NAME(database_id) AS DatabaseName,
    CAST(SUM(size) * 8.0 / 1024 AS DECIMAL(18,2)) AS SizeMB
FROM sys.master_files
GROUP BY database_id
ORDER BY SizeMB DESC;

-- 4. Current user connections
SELECT
    DB_NAME(database_id) AS DatabaseName,
    COUNT(*) AS ConnectionCount
FROM sys.dm_exec_sessions
WHERE database_id > 0
GROUP BY database_id
ORDER BY ConnectionCount DESC;

-- 5. Top SQL Server waits
SELECT TOP (10)
    wait_type,
    waiting_tasks_count,
    wait_time_ms,
    signal_wait_time_ms
FROM sys.dm_os_wait_stats
WHERE wait_type NOT LIKE 'SLEEP%'
ORDER BY wait_time_ms DESC;