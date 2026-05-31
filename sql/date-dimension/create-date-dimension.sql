-- ============================================================================
-- Description:  Creates a comprehensive date dimension table (DimDate)
--               with many useful columns for reporting purposes.
--               Note: Existing table will be dropped and recreated!
-- Created:      Universal script
-- ============================================================================

BEGIN TRY
    DROP TABLE [dbo].[DimDate];
END TRY
BEGIN CATCH
    /* No action required */
END CATCH;

CREATE TABLE [dbo].[DimDate] (
    [DateKey]           INT PRIMARY KEY,
    [Date]              DATETIME,
    [FullDateUK]        CHAR(10),
    [FullDateUSA]       CHAR(10),
    [DayOfMonth]        VARCHAR(2),
    [DaySuffix]         VARCHAR(4),
    [DayName]           VARCHAR(9),
    [DayOfWeekUSA]      CHAR(1),
    [DayOfWeekUK]       CHAR(1),
    [DayOfWeekInMonth]  VARCHAR(2),
    [DayOfWeekInYear]   VARCHAR(2),
    [DayOfQuarter]      VARCHAR(3),
    [DayOfYear]         VARCHAR(3),
    [WeekOfMonth]       VARCHAR(1),
    [WeekOfQuarter]     VARCHAR(2),
    [WeekOfYear]        VARCHAR(2),
    [Month]             VARCHAR(2),
    [MonthName]         VARCHAR(9),
    [MonthOfQuarter]    VARCHAR(2),
    [Quarter]           CHAR(1),
    [QuarterName]       VARCHAR(9),
    [Year]              CHAR(4),
    [YearName]          CHAR(7),
    [MonthYear]         CHAR(10),
    [MMYYYY]            CHAR(6),
    [FirstDayOfMonth]   DATE,
    [LastDayOfMonth]    DATE,
    [FirstDayOfQuarter] DATE,
    [LastDayOfQuarter]  DATE,
    [FirstDayOfYear]    DATE,
    [LastDayOfYear]     DATE,
    [IsHolidayUK]       BIT NULL,
    [HolidayUK]         VARCHAR(50) NULL
);

-- ============================================================
-- Adjust time period here
-- ============================================================
DECLARE @StartDate DATETIME = '2020-01-01';
DECLARE @EndDate   DATETIME = '2030-12-31';

DECLARE @DayOfWeekInMonth INT, @DayOfWeekInYear INT, @DayOfQuarter INT,
        @WeekOfMonth INT, @CurrentYear INT, @CurrentMonth INT, @CurrentQuarter INT;

DECLARE @DayOfWeek TABLE (
    DOW INT, MonthCount INT, QuarterCount INT, YearCount INT
);

INSERT INTO @DayOfWeek VALUES (1,0,0,0),(2,0,0,0),(3,0,0,0),(4,0,0,0),(5,0,0,0),(6,0,0,0),(7,0,0,0);

DECLARE @CurrentDate AS DATETIME = @StartDate;
SET @CurrentMonth = DATEPART(MM, @CurrentDate);
SET @CurrentYear = DATEPART(YY, @CurrentDate);
SET @CurrentQuarter = DATEPART(QQ, @CurrentDate);

WHILE @CurrentDate < @EndDate
BEGIN
    IF @CurrentMonth != DATEPART(MM, @CurrentDate)
    BEGIN UPDATE @DayOfWeek SET MonthCount = 0; SET @CurrentMonth = DATEPART(MM, @CurrentDate); END

    IF @CurrentQuarter != DATEPART(QQ, @CurrentDate)
    BEGIN UPDATE @DayOfWeek SET QuarterCount = 0; SET @CurrentQuarter = DATEPART(QQ, @CurrentDate); END

    IF @CurrentYear != DATEPART(YY, @CurrentDate)
    BEGIN UPDATE @DayOfWeek SET YearCount = 0; SET @CurrentYear = DATEPART(YY, @CurrentDate); END

    UPDATE @DayOfWeek SET MonthCount = MonthCount + 1, QuarterCount = QuarterCount + 1, YearCount = YearCount + 1
    WHERE DOW = DATEPART(DW, @CurrentDate);

    SELECT @DayOfWeekInMonth = MonthCount, @DayOfQuarter = QuarterCount, @DayOfWeekInYear = YearCount
    FROM @DayOfWeek WHERE DOW = DATEPART(DW, @CurrentDate);

    INSERT INTO [dbo].[DimDate]
    SELECT
        CONVERT(CHAR(8), @CurrentDate, 112) AS DateKey,
        @CurrentDate AS [Date],
        CONVERT(CHAR(10), @CurrentDate, 103) AS FullDateUK,
        CONVERT(CHAR(10), @CurrentDate, 101) AS FullDateUSA,
        DATEPART(DD, @CurrentDate) AS DayOfMonth,
        CASE
            WHEN DATEPART(DD, @CurrentDate) IN (11,12,13) THEN CAST(DATEPART(DD, @CurrentDate) AS VARCHAR) + 'th'
            WHEN RIGHT(DATEPART(DD, @CurrentDate), 1) = 1 THEN CAST(DATEPART(DD, @CurrentDate) AS VARCHAR) + 'st'
            WHEN RIGHT(DATEPART(DD, @CurrentDate), 1) = 2 THEN CAST(DATEPART(DD, @CurrentDate) AS VARCHAR) + 'nd'
            WHEN RIGHT(DATEPART(DD, @CurrentDate), 1) = 3 THEN CAST(DATEPART(DD, @CurrentDate) AS VARCHAR) + 'rd'
            ELSE CAST(DATEPART(DD, @CurrentDate) AS VARCHAR) + 'th'
        END AS DaySuffix,
        DATENAME(DW, @CurrentDate) AS DayName,
        DATEPART(DW, @CurrentDate) AS DayOfWeekUSA,
        CASE DATEPART(DW, @CurrentDate) WHEN 1 THEN 7 WHEN 2 THEN 1 WHEN 3 THEN 2 WHEN 4 THEN 3 WHEN 5 THEN 4 WHEN 6 THEN 5 WHEN 7 THEN 6 END AS DayOfWeekUK,
        @DayOfWeekInMonth AS DayOfWeekInMonth,
        @DayOfWeekInYear AS DayOfWeekInYear,
        @DayOfQuarter AS DayOfQuarter,
        DATEPART(DY, @CurrentDate) AS DayOfYear,
        DATEPART(WW, @CurrentDate) + 1 - DATEPART(WW, CONVERT(VARCHAR, DATEPART(MM, @CurrentDate)) + '/1/' + CONVERT(VARCHAR, DATEPART(YY, @CurrentDate))) AS WeekOfMonth,
        (DATEDIFF(DD, DATEADD(QQ, DATEDIFF(QQ, 0, @CurrentDate), 0), @CurrentDate) / 7) + 1 AS WeekOfQuarter,
        DATEPART(WW, @CurrentDate) AS WeekOfYear,
        DATEPART(MM, @CurrentDate) AS [Month],
        DATENAME(MM, @CurrentDate) AS MonthName,
        CASE WHEN DATEPART(MM, @CurrentDate) IN (1,4,7,10) THEN 1 WHEN DATEPART(MM, @CurrentDate) IN (2,5,8,11) THEN 2 WHEN DATEPART(MM, @CurrentDate) IN (3,6,9,12) THEN 3 END AS MonthOfQuarter,
        DATEPART(QQ, @CurrentDate) AS Quarter,
        CASE DATEPART(QQ, @CurrentDate) WHEN 1 THEN 'First' WHEN 2 THEN 'Second' WHEN 3 THEN 'Third' WHEN 4 THEN 'Fourth' END AS QuarterName,
        DATEPART(YEAR, @CurrentDate) AS [Year],
        'CY ' + CONVERT(VARCHAR, DATEPART(YEAR, @CurrentDate)) AS YearName,
        LEFT(DATENAME(MM, @CurrentDate), 3) + '-' + CONVERT(VARCHAR, DATEPART(YY, @CurrentDate)) AS MonthYear,
        RIGHT('0' + CONVERT(VARCHAR, DATEPART(MM, @CurrentDate)), 2) + CONVERT(VARCHAR, DATEPART(YY, @CurrentDate)) AS MMYYYY,
        CONVERT(DATETIME, CONVERT(DATE, DATEADD(DD, -(DATEPART(DD, @CurrentDate) - 1), @CurrentDate))) AS FirstDayOfMonth,
        CONVERT(DATETIME, CONVERT(DATE, DATEADD(DD, -DATEPART(DD, DATEADD(MM, 1, @CurrentDate)), DATEADD(MM, 1, @CurrentDate)))) AS LastDayOfMonth,
        DATEADD(QQ, DATEDIFF(QQ, 0, @CurrentDate), 0) AS FirstDayOfQuarter,
        DATEADD(QQ, DATEDIFF(QQ, -1, @CurrentDate), -1) AS LastDayOfQuarter,
        CONVERT(DATETIME, '01/01/' + CONVERT(VARCHAR, DATEPART(YY, @CurrentDate))) AS FirstDayOfYear,
        CONVERT(DATETIME, '12/31/' + CONVERT(VARCHAR, DATEPART(YY, @CurrentDate))) AS LastDayOfYear,
        NULL AS IsHolidayUK, NULL AS HolidayUK;

    SET @CurrentDate = DATEADD(DD, 1, @CurrentDate);
END;

PRINT 'Date dimension created successfully.';
