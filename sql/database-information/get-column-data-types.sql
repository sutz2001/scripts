-- ============================================================================
-- Description:  Shows all columns, data types, and properties of a specific
--               table. Replace @TableName with the desired table name.
-- Created:      Universal script
-- ============================================================================

DECLARE @TableName NVARCHAR(128) = 'YOUR_TABLE_NAME';  -- Enter table name here

SELECT
    c.name AS [ColumnName],
    t.name AS [DataType],
    c.max_length AS [MaxLength],
    c.precision AS [Precision],
    c.scale AS [Scale],
    c.is_nullable AS [AllowNull],
    c.is_identity AS [Identity]
FROM sys.columns AS c
JOIN sys.types AS t ON c.user_type_id = t.user_type_id
WHERE OBJECT_NAME(c.OBJECT_ID) = @TableName
ORDER BY c.column_id;