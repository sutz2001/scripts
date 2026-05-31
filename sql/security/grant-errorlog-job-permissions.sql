 -- ============================================================================
-- Description:  Grants a user permission to read the SQL Server error log
--               and manage SQL Server Agent jobs.
--               Replace [YOUR_USER_NAME] with the desired login.
-- Created:      Universal script
-- ============================================================================

-- Read error log
USE master;
GO
GRANT EXECUTE ON [dbo].[xp_readerrorlog] TO [YOUR_USER_NAME];
GO

-- SQL Server Agent job management
USE msdb;
GO
GRANT EXECUTE ON [dbo].[sp_help_job]           TO [YOUR_USER_NAME];
GRANT EXECUTE ON [dbo].[sp_start_job]          TO [YOUR_USER_NAME];
GRANT EXECUTE ON [dbo].[sp_stop_job]           TO [YOUR_USER_NAME];
GRANT EXECUTE ON [dbo].[sp_update_job]         TO [YOUR_USER_NAME];
GRANT EXECUTE ON [dbo].[sp_add_job]            TO [YOUR_USER_NAME];
GRANT EXECUTE ON [dbo].[sp_delete_job]         TO [YOUR_USER_NAME];
GRANT EXECUTE ON [dbo].[sp_add_jobstep]        TO [YOUR_USER_NAME];
GRANT EXECUTE ON [dbo].[sp_add_jobschedule]    TO [YOUR_USER_NAME];
GRANT EXECUTE ON [dbo].[sp_add_jobserver]      TO [YOUR_USER_NAME];
GO