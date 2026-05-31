-- ============================================================================
-- Description:  Creates a helper table (Numbers/Tally Table) with
--               sequential numbers from 1 to @MaxNumber.
--               Useful for many-to-many joins, split functions, etc.
-- Created:      Universal script
-- ============================================================================

DECLARE @MaxNumber INT = 10000;  -- Enter desired maximum number here

-- Create table (if not exists)
IF OBJECT_ID('dbo.Numbers', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Numbers (
        n INT NOT NULL PRIMARY KEY
    );
END

-- Clear and repopulate table
TRUNCATE TABLE dbo.Numbers;

DECLARE @i INT = 1;
INSERT INTO dbo.Numbers (n) VALUES (1);

WHILE @i * 2 <= @MaxNumber
BEGIN
    INSERT INTO dbo.Numbers (n)
    SELECT n + @i FROM dbo.Numbers;
    SET @i = @i * 2;
END

INSERT INTO dbo.Numbers (n)
SELECT n + @i FROM dbo.Numbers WHERE n + @i <= @MaxNumber;

-- Display result
SELECT COUNT(*) AS [NumberCount], MIN(n) AS [Minimum], MAX(n) AS [Maximum]
FROM dbo.Numbers;