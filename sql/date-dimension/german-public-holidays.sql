-- ============================================================================
-- Description:  Calculates German public holidays for a given date.
--               Based on the Gauss formula for calculating Easter date.
--               Returns the holiday name or 'Working day'.
-- Created:      Universal script
-- ============================================================================

CREATE OR ALTER FUNCTION [dbo].[fn_GermanHoliday] (@InputDate DATETIME)
RETURNS VARCHAR(100)
AS
BEGIN
    DECLARE @Year INT, @M INT, @N INT, @A INT, @B INT, @C INT, @D INT, @E INT;
    DECLARE @Day INT, @Month INT, @Date DATETIME;
    DECLARE @EasterSunday DATETIME, @RepentanceDay DATETIME;

    SET @Year = YEAR(@InputDate);
    IF @Year NOT BETWEEN 1700 AND 2199 RETURN NULL;

    SET @M = CASE WHEN @Year BETWEEN 1900 AND 2199 THEN 24 ELSE 23 END;
    SET @N = 5;
    SET @A = @Year % 19; SET @B = @Year % 4; SET @C = @Year % 7;
    SET @D = ((@A * 19) + @M) % 30;
    SET @E = ((@B * 2) + (@C * 4) + (@D * 6) + @N) % 7;

    SET @Day = CASE WHEN @D + @E + 22 > 31 THEN @D + @E - 9 ELSE @D + @E + 22 END;
    SET @Month = CASE WHEN @D + @E + 22 > 31 THEN 4 ELSE 3 END;
    SET @Day = CASE WHEN @Day = 25 AND @Month = 4 AND @D = 28 AND @A > 10 THEN 18
                    WHEN @Day = 26 AND @Month = 4 THEN 19 ELSE @Day END;

    SET @Date = CONVERT(DATETIME, CONVERT(VARCHAR(4), @Year) + '-' +
        RIGHT('0' + CONVERT(VARCHAR, @Month), 2) + '-' + RIGHT('0' + CONVERT(VARCHAR, @Day), 2));
    SET @EasterSunday = @Date;
    SET @RepentanceDay = DATEADD(DD, -DATEPART(DW, CONVERT(VARCHAR, @Year) + '-12-25') - 38 + 7, CONVERT(VARCHAR, @Year) + '-12-25');

    RETURN CASE
        WHEN DATEDIFF(DAY, @EasterSunday, @InputDate) = -2 THEN 'Good Friday'
        WHEN DATEDIFF(DAY, @EasterSunday, @InputDate) = 0 THEN 'Easter Sunday'
        WHEN DATEDIFF(DAY, @EasterSunday, @InputDate) = 1 THEN 'Easter Monday'
        WHEN DATEDIFF(DAY, @EasterSunday, @InputDate) = 39 THEN 'Ascension Day'
        WHEN DATEDIFF(DAY, @EasterSunday, @InputDate) = 50 THEN 'Whit Monday'
        WHEN @InputDate = @RepentanceDay THEN 'Repentance Day'
        WHEN MONTH(@InputDate) = 1 AND DAY(@InputDate) = 1 THEN 'New Year'
        WHEN MONTH(@InputDate) = 1 AND DAY(@InputDate) = 6 THEN 'Epiphany'
        WHEN MONTH(@InputDate) = 5 AND DAY(@InputDate) = 1 THEN 'Labour Day'
        WHEN MONTH(@InputDate) = 10 AND DAY(@InputDate) = 3 THEN 'German Unity Day'
        WHEN MONTH(@InputDate) = 10 AND DAY(@InputDate) = 31 THEN 'Reformation Day'
        WHEN MONTH(@InputDate) = 11 AND DAY(@InputDate) = 1 THEN 'All Saints Day'
        WHEN MONTH(@InputDate) = 12 AND DAY(@InputDate) = 25 THEN 'Christmas Day'
        WHEN MONTH(@InputDate) = 12 AND DAY(@InputDate) = 26 THEN 'Boxing Day'
        ELSE 'Working day'
    END;
END
GO

-- Example: SELECT dbo.fn_GermanHoliday(GETDATE()) AS [Today];