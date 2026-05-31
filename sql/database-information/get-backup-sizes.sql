-- ============================================================================
-- Description:  Shows backup sizes (including compressed backups) for all
--               backups from a specified date onwards.
--               Adjustment: Set @CutoffDate to the desired start date.
-- Created:      Universal script
-- ============================================================================

DECLARE @CutoffDate DATETIME = '2020-01-01';  -- Enter desired start date here

-- Overview: Compressed vs. uncompressed backup sizes
SELECT
    database_name AS [Database],
    type AS [BackupType],
    CASE type
        WHEN 'D' THEN 'Full'
        WHEN 'I' THEN 'Differential'
        WHEN 'L' THEN 'Log'
        WHEN 'F' THEN 'Filegroup'
        WHEN 'G' THEN 'Filegroup Differential'
        WHEN 'P' THEN 'Partial'
        WHEN 'Q' THEN 'Partial Differential'
        ELSE 'Unknown'
    END AS [BackupTypeDescription],
    COUNT(*) AS [BackupCount],
    CAST(SUM(backup_size) / 1024.0 / 1024.0 / 1024.0 AS DECIMAL(10,2)) AS [TotalSize (GB)],
    CAST(SUM(compressed_backup_size) / 1024.0 / 1024.0 / 1024.0 AS DECIMAL(10,2)) AS [Compressed (GB)],
    CASE
        WHEN SUM(backup_size) > 0
        THEN CAST((1.0 - SUM(compressed_backup_size) * 1.0 / SUM(backup_size)) * 100 AS DECIMAL(5,1))
        ELSE 0
    END AS [Compression (%)],
    MIN(backup_finish_date) AS [FirstBackup],
    MAX(backup_finish_date) AS [LastBackup]
FROM msdb.dbo.backupset
WHERE backup_finish_date >= @CutoffDate
GROUP BY database_name, type
ORDER BY database_name, type;