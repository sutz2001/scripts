-- ============================================================================
-- Description:  Shows detailed information about TempDB,
--               including version store, internal objects, user objects,
--               and total size.
-- Created:      Universal script
-- ============================================================================

-- Version Store
SELECT
    SUM(version_store_reserved_page_count) AS [VersionStorePages],
    CAST(SUM(version_store_reserved_page_count) * 1.0 / 128 AS DECIMAL(10,2)) AS [VersionStore (MB)]
FROM sys.dm_db_file_space_usage;

-- Internal Objects
SELECT
    SUM(internal_object_reserved_page_count) AS [InternalObjectPages],
    CAST(SUM(internal_object_reserved_page_count) * 1.0 / 128 AS DECIMAL(10,2)) AS [InternalObjects (MB)]
FROM sys.dm_db_file_space_usage;

-- User Objects
SELECT
    SUM(user_object_reserved_page_count) AS [UserObjectPages],
    CAST(SUM(user_object_reserved_page_count) * 1.0 / 128 AS DECIMAL(10,2)) AS [UserObjects (MB)]
FROM sys.dm_db_file_space_usage;

-- Total size of TempDB
SELECT
    name AS [FileName],
    CAST(size * 1.0 / 128 AS DECIMAL(10,2)) AS [Size (MB)],
    CASE WHEN max_size = -1 THEN 'Unlimited' ELSE CAST(max_size * 1.0 / 128 AS VARCHAR(20)) END AS [MaxSize],
    CASE WHEN is_percent_growth = 1 THEN CAST(growth AS VARCHAR(10)) + '%' ELSE CAST(growth * 1.0 / 128 AS VARCHAR(20)) + ' MB' END AS [Growth]
FROM tempdb.sys.database_files;