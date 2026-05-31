-- ============================================================================
-- Description:  Stored procedure to enable/disable SQL Server Agent jobs.
--               Replace the job names in the body with your own jobs.
--               Call: EXEC dbo.sp_jobs_enable_disable 0  (disable)
--                     EXEC dbo.sp_jobs_enable_disable 1  (enable)
-- Created:      Universal script
-- ============================================================================

CREATE OR ALTER PROCEDURE [dbo].[sp_jobs_enable_disable]
    @enableFlag INT  -- 0 = Disable jobs, 1 = Enable jobs
AS
BEGIN
    SET NOCOUNT ON;

    -- ====================================================
    -- Enter desired job names here
    -- ====================================================

    IF @enableFlag = 0 -- Disable jobs
    BEGIN
        -- EXEC msdb.dbo.sp_update_job @job_name = N'YOUR_JOB_NAME_1', @enabled = 0;
        -- EXEC msdb.dbo.sp_update_job @job_name = N'YOUR_JOB_NAME_2', @enabled = 0;
        PRINT 'Jobs have been disabled.';
    END

    IF @enableFlag = 1 -- Enable jobs
    BEGIN
        -- EXEC msdb.dbo.sp_update_job @job_name = N'YOUR_JOB_NAME_1', @enabled = 1;
        -- EXEC msdb.dbo.sp_update_job @job_name = N'YOUR_JOB_NAME_2', @enabled = 1;
        PRINT 'Jobs have been enabled.';
    END
END
GO