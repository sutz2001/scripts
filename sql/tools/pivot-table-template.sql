-- ============================================================================
-- Description:  Dynamically creates a pivot table from a source table.
--               Replace the variables @SourceTable, @PivotColumn,
--               @ValueColumn with your desired columns.
-- Created:      Universal script
-- ============================================================================

DECLARE @SourceTable NVARCHAR(128) = 'dbo.YourSourceTable';
DECLARE @PivotColumn NVARCHAR(128) = 'YourPivotColumn';
DECLARE @ValueColumn NVARCHAR(128) = 'YourValueColumn';

DECLARE @SQL NVARCHAR(MAX);
DECLARE @PivotValues NVARCHAR(MAX);

-- Dynamically determine pivot values
SET @SQL = N'SELECT @result = STUFF((SELECT '', '' + QUOTENAME(' + QUOTENAME(@PivotColumn) + N')
              FROM (SELECT DISTINCT ' + QUOTENAME(@PivotColumn) + N' FROM ' + @SourceTable + N') AS x
              ORDER BY ' + QUOTENAME(@PivotColumn) + N'
              FOR XML PATH('''')), 1, 2, '''')';

EXEC sp_executesql @SQL, N'@result NVARCHAR(MAX) OUTPUT', @result = @PivotValues OUTPUT;

-- Output pivot table
SET @SQL = N'SELECT * FROM ' + @SourceTable + N'
PIVOT (
    SUM(' + QUOTENAME(@ValueColumn) + N')
    FOR ' + QUOTENAME(@PivotColumn) + N' IN (' + @PivotValues + N')
) AS pvt';

PRINT @SQL;
EXEC sp_executesql @SQL;