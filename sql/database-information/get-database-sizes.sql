-- ============================================================================
-- Description:  Shows the sizes of all databases on a SQL Server instance,
--               including data and log file usage in MB.
--               Result: Total size, Data (used/free), Log (used/free)
-- Created:      Universal script
-- ============================================================================

SET NOCOUNT ON;

DECLARE @dbname SYSNAME;
DECLARE @string SYSNAME;
DECLARE @dbCount INT;

-- Temporary table for databases
CREATE TABLE #DBS (
    DBID   INT,
    DBNAME VARCHAR(128)
);

-- Temporary table for file statistics
CREATE TABLE #DATAFILESTATS (
    DBNAME       VARCHAR(128),
    FLAG         BIT DEFAULT 0,
    FILEID       TINYINT,
    [FILEGROUP]  TINYINT,
    TOTALEXTENTS DEC(15,1),
    USEDEXTENTS  DEC(15,1),
    [NAME]       VARCHAR(100),
    [FILENAME]   SYSNAME
);

-- Temporary table for size information
CREATE TABLE #SIZEINFO (
    DBNAME          VARCHAR(128) NOT NULL PRIMARY KEY CLUSTERED,
    TOTAL           DEC(15,1),
    DATA            DEC(15,1),
    DATA_USED       DEC(15,1),
    [DATA (%)]      DEC(15,1),
    DATA_FREE       DEC(15,1),
    [DATA_FREE (%)] DEC(15,1),
    LOG             DEC(15,1),
    LOG_USED        DEC(15,1),
    [LOG (%)]       DEC(15,1),
    LOG_FREE        DEC(15,1),
    [LOG_FREE (%)]  DEC(15,1)
);

-- Load all databases
INSERT INTO #DBS
SELECT DBID, NAME
FROM sys.sysdatabases;

SET @dbCount = (SELECT COUNT(*) FROM #DBS);

-- Loop through all databases
WHILE @dbCount > 0
BEGIN
    SELECT TOP 1 @dbname = DBNAME
    FROM #DBS
    ORDER BY DBNAME ASC;

    IF @@ROWCOUNT = 0 BREAK;

    SET @string = 'USE [' + @dbname + '] DBCC SHOWFILESTATS WITH NO_INFOMSGS';

    BEGIN TRY
        INSERT INTO #DATAFILESTATS
            (FILEID, [FILEGROUP], TOTALEXTENTS, USEDEXTENTS, [NAME], [FILENAME])
        EXEC(@string);

        UPDATE #DATAFILESTATS
        SET    DBNAME = @dbname, FLAG = 1
        WHERE  FLAG = 0;

        UPDATE #DATAFILESTATS
        SET    TOTALEXTENTS = (SELECT SUM(TOTALEXTENTS) * 8 * 8192.0 / 1048576.0
                               FROM #DATAFILESTATS WHERE DBNAME = @dbname)
        WHERE  FLAG = 1 AND FILEID = 1 AND FILEGROUP = 1 AND DBNAME = @dbname;

        UPDATE #DATAFILESTATS
        SET    USEDEXTENTS = (SELECT SUM(USEDEXTENTS) * 8 * 8192.0 / 1048576.0
                              FROM #DATAFILESTATS WHERE DBNAME = @dbname)
        WHERE  FLAG = 1 AND FILEID = 1 AND FILEGROUP = 1 AND DBNAME = @dbname;
    END TRY
    BEGIN CATCH
        -- Skip databases that cannot be accessed
    END CATCH;

    DELETE FROM #DBS WHERE DBNAME = @dbname;
    SET @dbCount = @dbCount - 1;
END;

-- Load log space information
INSERT #SIZEINFO (DBNAME, LOG, [LOG (%)])
EXEC('DBCC SQLPERF(LOGSPACE) WITH NO_INFOMSGS');

-- Update data columns
UPDATE #SIZEINFO
SET    DATA = D.TOTALEXTENTS
FROM   #DATAFILESTATS D
       JOIN #SIZEINFO S ON D.DBNAME = S.DBNAME
WHERE  D.FLAG = 1 AND D.FILEID = 1 AND D.FILEGROUP = 1;

UPDATE #SIZEINFO
SET    DATA_USED = D.USEDEXTENTS
FROM   #DATAFILESTATS D
       JOIN #SIZEINFO S ON D.DBNAME = S.DBNAME
WHERE  D.FLAG = 1 AND D.FILEID = 1 AND D.FILEGROUP = 1;

-- Perform calculations
UPDATE #SIZEINFO SET TOTAL = ISNULL(DATA, 0) + ISNULL(LOG, 0);
UPDATE #SIZEINFO SET [DATA (%)] = CASE WHEN DATA > 0 THEN (DATA_USED * 100.0 / DATA) ELSE 0 END;
UPDATE #SIZEINFO SET DATA_FREE = ISNULL(DATA, 0) - ISNULL(DATA_USED, 0);
UPDATE #SIZEINFO SET [DATA_FREE (%)] = 100 - ISNULL([DATA (%)], 0);
UPDATE #SIZEINFO SET LOG_USED = LOG * ISNULL([LOG (%)], 0) / 100.0;
UPDATE #SIZEINFO SET LOG_FREE = LOG - ISNULL(LOG_USED, 0);
UPDATE #SIZEINFO SET [LOG_FREE (%)] = CASE WHEN LOG > 0 THEN (LOG_FREE * 100.0 / LOG) ELSE 0 END;

-- Output final result
SELECT DBNAME AS [Database],
       ROUND(TOTAL, 2) AS [Total (MB)],
       ROUND(DATA, 2) AS [Data (MB)],
       ROUND(DATA_USED, 2) AS [Data Used (MB)],
       ROUND([DATA (%)], 2) AS [Data Used (%)],
       ROUND(DATA_FREE, 2) AS [Data Free (MB)],
       ROUND(LOG, 2) AS [Log (MB)],
       ROUND(LOG_USED, 2) AS [Log Used (MB)],
       ROUND([LOG (%)], 2) AS [Log Used (%)],
       ROUND(LOG_FREE, 2) AS [Log Free (MB)]
FROM   #SIZEINFO
ORDER BY DBNAME ASC;

-- Cleanup
DROP TABLE #DATAFILESTATS;
DROP TABLE #SIZEINFO;
DROP TABLE #DBS;