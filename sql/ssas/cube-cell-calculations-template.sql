-- ============================================================================
-- Description:  Template for SSAS Cube Cell Calculations.
--               Contains example calculations for percentages and
--               cumulative values. Replace the dimension and measure
--               names with your own.
-- Created:      Universal script
-- ============================================================================

CALCULATE;

-- Example 1: Percentage of one dimension relative to another
CREATE CELL CALCULATION CURRENTCUBE.[PercentOfTotal]
FOR '({[YOUR_DIMENSION].&[VALUE1]})'
AS '
    IIF(
        ABS([YOUR_DIMENSION].&[COMPARE]) < 0.00001,
        NULL,
        [YOUR_DIMENSION].&[VALUE1] / [YOUR_DIMENSION].&[COMPARE] * 100
    )
'
DESCRIPTION = 'Calculates the percentage of VALUE1 relative to COMPARE';

-- Example 2: Disable aggregation for a specific dimension
/*
CREATE CELL CALCULATION CURRENTCUBE.[DisableAggregation]
FOR '({[YOUR_DIMENSION].&[LOCAL]})'
AS 'NULL'
DESCRIPTION = 'Disables aggregation for local values';
*/

-- Example 3: Cumulative value
/*
CREATE CELL CALCULATION CURRENTCUBE.[CumulativeValue]
FOR '({[TIME_DIMENSION].&[CUM]})'
AS '
    IIF(
        ISEMPTY(([TIME_DIMENSION].PREVMEMBER, [TIME_DIMENSION].&[CUM])),
        [TIME_DIMENSION].&[CUM],
        [TIME_DIMENSION].&[CUM] - ([TIME_DIMENSION].PREVMEMBER, [TIME_DIMENSION].&[CUM])
    )
'
DESCRIPTION = 'Calculates cumulative values by difference';
*/

-- Set default member for dimensions (example)
/*
ALTER CUBE [YOUR_CUBE]
UPDATE DIMENSION [YOUR_DIMENSION], DEFAULT_MEMBER = '[DIMENSION].&[DEFAULT_VALUE]';
*/