-- ============================================================================
-- Description:  Shows the last read/write access per database,
--               based on the DMV sys.dm_db_index_usage_stats.
--               Note: Data is reset on server restart.
-- Created:      Universal script
-- ============================================================================

;WITH AccessCTE AS (
    SELECT
        DB_NAME(database_id) AS [Database],
        last_user_seek,
        last_user_scan,
        last_user_lookup,
        last_user_update
    FROM sys.dm_db_index_usage_stats
)
SELECT
    (SELECT CREATE_DATE FROM sys.databases WHERE name = 'tempdb') AS [ServerRestart],
    x.[Database],
    MAX(x.last_read) AS [LastRead],
    MAX(x.last_write) AS [LastWrite]
FROM (
    SELECT [Database], last_user_seek AS last_read, NULL AS last_write FROM AccessCTE
    UNION ALL
    SELECT [Database], last_user_scan, NULL FROM AccessCTE
    UNION ALL
    SELECT [Database], last_user_lookup, NULL FROM AccessCTE
    UNION ALL
    SELECT [Database], NULL, last_user_update FROM AccessCTE
) AS x
GROUP BY x.[Database]
ORDER BY x.[Database];