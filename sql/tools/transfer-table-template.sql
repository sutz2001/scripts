-- ============================================================================
-- Description:  Template for a stored procedure that copies tables from a
--               source to a target. Configuration via a configuration table
--               with src_table, dest_table and area.
-- Created:      Universal script
-- ============================================================================

-- ============================================================
-- Create configuration table (one-time)
-- ============================================================
/*
CREATE TABLE dbo.dwh_transfer_conf (
    srctable_name    NVARCHAR(255),
    desttable_name   NVARCHAR(255),
    dept_area_name   NVARCHAR(50)
);

-- Example entries:
INSERT INTO dbo.dwh_transfer_conf VALUES
    ('SourceTable1', 'TargetTable1', 'Area1'),
    ('SourceTable2', 'TargetTable2', 'Area1'),
    ('SourceTable3', 'TargetTable3', 'Area2');
*/

-- ============================================================
-- Stored Procedure
-- ============================================================

CREATE OR ALTER PROCEDURE dbo.usp_transfer_tables
    @area_select NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @sql          NVARCHAR(1000);
    DECLARE @src_table    NVARCHAR(255);
    DECLARE @dest_table   NVARCHAR(255);
    DECLARE @object_id    INT;

    DECLARE cur_area CURSOR FOR
        SELECT srctable_name, desttable_name
        FROM dbo.dwh_transfer_conf
        WHERE dept_area_name = @area_select;

    OPEN cur_area;
    FETCH NEXT FROM cur_area INTO @src_table, @dest_table;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @object_id = OBJECT_ID(@dest_table);

        IF @dest_table <> @src_table
        BEGIN
            -- Drop target table if it exists
            IF @object_id IS NOT NULL
            BEGIN
                SET @sql = N'DROP TABLE ' + QUOTENAME(@dest_table);
                EXEC(@sql);
            END

            -- Copy data
            SET @sql = N'SELECT *, GETDATE() AS transfer_creation_date
                         INTO ' + QUOTENAME(@dest_table) + N'
                         FROM ' + QUOTENAME(@src_table);
            EXEC(@sql);

            PRINT 'Table [' + @src_table + '] -> [' + @dest_table + '] copied successfully.';
        END
        ELSE
        BEGIN
            PRINT 'Source = Target for [' + @src_table + '], skipped.';
        END

        FETCH NEXT FROM cur_area INTO @src_table, @dest_table;
    END

    CLOSE cur_area;
    DEALLOCATE cur_area;
END
GO