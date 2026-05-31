-- ============================================================================
-- Description:  Changes the owner of a database.
--               Replace @DatabaseName and @NewOwner with the desired values.
-- Created:      Universal script
-- ============================================================================

DECLARE @DatabaseName NVARCHAR(128) = 'YOUR_DATABASE_NAME';   -- Enter database name here
DECLARE @NewOwner NVARCHAR(128) = 'YOUR_USER_NAME';           -- Enter new owner here

DECLARE @SQL NVARCHAR(500);

-- Check if the database exists
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = @DatabaseName)
BEGIN
    SET @SQL = N'USE [' + @DatabaseName + N']; EXEC sp_changedbowner N''' + @NewOwner + N''';';
    PRINT 'Changing owner of database [' + @DatabaseName + '] to ''' + @NewOwner + '''...';
    EXEC(@SQL);
    PRINT 'Successfully changed.';
END
ELSE
BEGIN
    PRINT 'Database [' + @DatabaseName + '] not found.';
END