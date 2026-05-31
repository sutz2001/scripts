-- ============================================================================
-- Description:  Sets the recovery model for all user databases to
--               SIMPLE or FULL.
--               Note: System databases (master, msdb, tempdb, model)
--               are skipped.
-- Created:      Universal script
-- ============================================================================

-- ============================================================
-- Option 1: Set all user databases to SIMPLE recovery
-- ============================================================

DECLARE @databaseName NVARCHAR(128);
DECLARE userDatabases CURSOR FOR
    SELECT name
    FROM sys.databases
    WHERE database_id > 4
      AND recovery_model_desc <> 'SIMPLE';

OPEN userDatabases;
FETCH NEXT FROM userDatabases INTO @databaseName;

WHILE (@@FETCH_STATUS = 0)
BEGIN
    PRINT 'Setting [' + @databaseName + '] to SIMPLE recovery...';
    EXEC('ALTER DATABASE [' + @databaseName + '] SET RECOVERY SIMPLE;');
    FETCH NEXT FROM userDatabases INTO @databaseName;
END

CLOSE userDatabases;
DEALLOCATE userDatabases;

-- ============================================================
-- Option 2: Set all user databases to FULL recovery
-- ============================================================

/*
DECLARE @databaseName2 NVARCHAR(128);
DECLARE userDatabases2 CURSOR FOR
    SELECT name
    FROM sys.databases
    WHERE database_id > 4;

OPEN userDatabases2;
FETCH NEXT FROM userDatabases2 INTO @databaseName2;

WHILE (@@FETCH_STATUS = 0)
BEGIN
    PRINT 'Setting [' + @databaseName2 + '] to FULL recovery...';
    EXEC('ALTER DATABASE [' + @databaseName2 + '] SET RECOVERY FULL;');
    FETCH NEXT FROM userDatabases2 INTO @databaseName2;
END

CLOSE userDatabases2;
DEALLOCATE userDatabases2;
*/