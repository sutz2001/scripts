-- ============================================================================
-- Description:  Enables SQL Server Agent XPs (required for certain agent
--               functions via T-SQL).
-- Created:      Universal script
-- ============================================================================

-- Show advanced options
sp_configure 'show advanced options', 1;
RECONFIGURE;
GO

-- Enable Agent XPs
sp_configure 'Agent XPs', 1;
RECONFIGURE;
GO