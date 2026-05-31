-- ============================================================================
-- Description:  Example SSAS Calculated Members for Pivot Cubes.
--               Contains percentage shares for columns and rows.
--               Replace [MEASURE] and dimension names with your values.
-- Created:      Universal script
-- ============================================================================

-- Percentage of column total
CREATE MEMBER CURRENTCUBE.[MEASURES].[PercentOfColumnTotal]
AS
IIF(
    ISEMPTY([Measures].[YOUR_MEASURE]),
    0,
    IIF(
        ISEMPTY(AXIS(1).ITEM(0).ITEM(0).DIMENSION.CURRENTPARENT.PARENT),
        1,
        [Measures].[YOUR_MEASURE] / (
            AXIS(1).ITEM(0).ITEM(0).DIMENSION.CURRENTPARENT.PARENT,
            [Measures].[YOUR_MEASURE]
        )
    )
);

-- Percentage of row total
CREATE MEMBER CURRENTCUBE.[MEASURES].[PercentOfRowTotal]
AS
IIF(
    ISEMPTY([Measures].[YOUR_MEASURE]),
    0,
    IIF(
        ISEMPTY(AXIS(0).ITEM(0).ITEM(0).DIMENSION.CURRENTPARENT.PARENT),
        1,
        [Measures].[YOUR_MEASURE] / (
            AXIS(0).ITEM(0).ITEM(0).DIMENSION.CURRENTPARENT.PARENT,
            [Measures].[YOUR_MEASURE]
        )
    )
);

-- Example: Percentage of total value (Root)
/*
WITH
SET RootSet AS {ROOT()}
MEMBER [Measures].[OrderFraction] AS
    [Measures].[YOUR_MEASURE] /
    SUM(RootSet, [Measures].[YOUR_MEASURE]),
    FORMAT_STRING = 'Percent'
SELECT
    [YOUR_DIMENSION].[YOUR_HIERARCHY].MEMBERS ON 0,
    [YOUR_DIMENSION2].[YOUR_HIERARCHY2].MEMBERS ON 1
FROM [YOUR_CUBE]
WHERE [Measures].[OrderFraction]
*/