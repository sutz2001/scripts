-- ============================================================================
-- Description:  Shows all data and log files of all databases,
--               including size, growth, and path.
-- Created:      Universal script
-- ============================================================================

SELECT
    DB_NAME(database_id) AS [Database],
    CASE type_desc
        WHEN 'ROWS' THEN 'Data File'
        WHEN 'LOG' THEN 'Log File'
    END AS [FileType],
    RIGHT(physical_name, CHARINDEX('\', REVERSE(physical_name)) - 1) AS [FileName],
    physical_name AS [FullPath],
    CAST((size * 8) / 1024.0 AS DECIMAL(9,2)) AS [Size (MB)],
    CASE
        WHEN growth = 0 THEN 'No growth allowed'
        WHEN is_percent_growth = 1 AND growth > 0 THEN CAST(growth AS VARCHAR(10)) + ' %'
        WHEN is_percent_growth = 0 AND growth > 0 THEN CAST(CAST((growth * 8.0) / 1024.0 AS INT) AS VARCHAR(10)) + ' MB'
        ELSE CAST(growth AS VARCHAR(10))
    END AS [Growth]
FROM sys.master_files
ORDER BY DB_NAME(database_id), type_desc;