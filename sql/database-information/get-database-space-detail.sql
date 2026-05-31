-- ============================================================================
-- Description:  Shows the space usage of all databases at instance level,
--               including data and log files with usage and free space.
--               Uses sp_msforeachdb for all accessible databases.
-- Created:      Universal script
-- ============================================================================

SET NOCOUNT ON;

DECLARE @TempFiles TABLE (
    [Name]              NVARCHAR(128) NULL,
    [DatabaseID]        INT NULL,
    [FileType]          NVARCHAR(60) NULL,
    [Status]            NVARCHAR(60) NULL,
    [SizeMB]            FLOAT NULL,
    [UsedMB]            FLOAT NULL,
    [MaxSizeMB]         FLOAT NULL,
    [Growth]            FLOAT NULL,
    [PercentGrowth]     BIT NULL,
    [ReadOnly]          BIT NULL,
    [FileSystemPath]    NVARCHAR(260) NULL
);

INSERT INTO @TempFiles
EXEC sp_msforeachdb '
    USE [?];
    SELECT
        [name],
        DB_ID() AS [DatabaseID],
        [type_desc] AS [FileType],
        [state_desc] AS [Status],
        [size] / 128.00 AS [SizeMB],
        fileproperty([name], ''SpaceUsed'') / 128.00 AS [UsedMB],
        CASE WHEN [max_size] = -1 THEN [max_size] ELSE [max_size] / 128.00 END AS [MaxSizeMB],
        CASE WHEN [is_percent_growth] = 1 THEN [growth] ELSE [growth] / 128.00 END AS [Growth],
        [is_percent_growth] AS [PercentGrowth],
        CASE WHEN [is_media_read_only] = 1 OR [is_read_only] = 1 THEN 1 ELSE 0 END AS [ReadOnly],
        [physical_name] AS [FileSystemPath]
    FROM sys.database_files
';

SELECT
    DB_NAME(DatabaseID) AS [Database],
    [Name] AS [FileName],
    [FileType],
    [Status],
    ROUND([SizeMB], 2) AS [Size (MB)],
    ROUND([UsedMB], 2) AS [Used (MB)],
    ROUND([SizeMB] - [UsedMB], 2) AS [Free (MB)],
    CASE WHEN [SizeMB] > 0 THEN ROUND(([UsedMB] / [SizeMB]) * 100, 1) ELSE 0 END AS [Used (%)],
    CASE WHEN [MaxSizeMB] = -1 THEN 'Unlimited' ELSE CAST(ROUND([MaxSizeMB], 0) AS NVARCHAR(20)) END AS [MaxSize],
    [Growth],
    CASE WHEN [PercentGrowth] = 1 THEN '%' ELSE 'MB' END AS [GrowthType],
    [ReadOnly],
    [FileSystemPath]
FROM @TempFiles
ORDER BY DB_NAME(DatabaseID), [FileType];