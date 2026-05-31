-- ============================================================================
-- Description:  Shows all databases with their respective owner.
-- Created:      Universal script
-- ============================================================================

SELECT
    name AS [Database],
    SUSER_SNAME(owner_sid) AS [Owner]
FROM sys.databases
ORDER BY name;