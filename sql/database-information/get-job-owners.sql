-- ============================================================================
-- Description:  Shows all SQL Server Agent jobs with their respective owner.
-- Created:      Universal script
-- ============================================================================

USE msdb;
GO

SELECT
    name AS [JobName],
    SUSER_SNAME(owner_sid) AS [Owner],
    enabled AS [Enabled],
    date_created AS [CreatedDate],
    date_modified AS [ModifiedDate]
FROM dbo.sysjobs
ORDER BY name;