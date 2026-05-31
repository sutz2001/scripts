-- ============================================================================
-- Description:  Template for retrieving data from a linked server
--               and storing it in local tables.
--               Replace the placeholders with your values.
-- Created:      Universal script
-- ============================================================================

DECLARE @LinkedServerName NVARCHAR(128) = 'YOUR_LINKED_SERVER';
DECLARE @RemoteDatabase   NVARCHAR(128) = 'YOUR_REMOTE_DATABASE';
DECLARE @RemoteTable      NVARCHAR(128) = 'YOUR_REMOTE_TABLE';
DECLARE @LocalTargetTable NVARCHAR(128) = 'dbo.YOUR_TARGET_TABLE';

DECLARE @SQL NVARCHAR(MAX);

-- Check if the target table already exists
IF OBJECT_ID(@LocalTargetTable) IS NOT NULL
BEGIN
    SET @SQL = N'DROP TABLE ' + QUOTENAME(PARSENAME(@LocalTargetTable, 2)) + N'.' + QUOTENAME(PARSENAME(@LocalTargetTable, 1));
    EXEC(@SQL);
END

-- Retrieve data from remote server and store in local table
SET @SQL = N'SELECT * INTO ' + @LocalTargetTable + N'
             FROM ' + QUOTENAME(@LinkedServerName) + N'.' + QUOTENAME(@RemoteDatabase) + N'.dbo.' + QUOTENAME(@RemoteTable);

EXEC(@SQL);

PRINT 'Data successfully imported from [' + @LinkedServerName + '] into ' + @LocalTargetTable + '.';