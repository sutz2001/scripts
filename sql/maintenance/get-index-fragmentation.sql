-- ============================================================================
-- Description:  Shows index fragmentation for all databases.
--               Outputs database, table, index name and fragmentation level.
--               Warning: This script may be slow with many databases!
-- Created:      Universal script
-- ============================================================================

DECLARE @cmd NVARCHAR(MAX);

SET @cmd = N'
    USE ?;
    IF DB_NAME() NOT IN (''master'', ''msdb'', ''tempdb'', ''model'')
    SELECT
        DB_NAME() AS [Database],
        OBJECT_NAME(i.OBJECT_ID) AS [Table],
        i.name AS [Index],
        indexstats.avg_fragmentation_in_percent AS [Fragmentation (%)],
        indexstats.page_count AS [Pages],
        indexstats.record_count AS [Rows]
    FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, ''DETAILED'') indexstats
        INNER JOIN sys.indexes i
            ON i.OBJECT_ID = indexstats.OBJECT_ID
            AND i.index_id = indexstats.index_id
    WHERE indexstats.avg_fragmentation_in_percent > 10  -- Only relevant fragmentation
      AND indexstats.page_count > 1000                   -- Only larger indexes
      AND i.name IS NOT NULL
    ORDER BY avg_fragmentation_in_percent DESC;
';

EXEC sp_msforeachdb @command1 = @cmd;