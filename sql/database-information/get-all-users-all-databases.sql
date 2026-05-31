-- ============================================================================
-- Description:  Shows all database users with roles and default schemas
--               for all databases on the instance.
-- Created:      Universal script
-- ============================================================================

EXECUTE sp_msforeachdb '
    SELECT
        ''[?]'' AS [Database],
        u.name AS [User],
        CASE WHEN (r.principal_id IS NULL) THEN ''public'' ELSE r.name END AS [Role],
        l.default_database_name AS [DefaultDB],
        u.default_schema_name AS [DefaultSchema],
        u.principal_id
    FROM [?].sys.database_principals u
        LEFT JOIN ([?].sys.database_role_members m
            JOIN [?].sys.database_principals r ON m.role_principal_id = r.principal_id)
            ON m.member_principal_id = u.principal_id
        LEFT JOIN [?].sys.server_principals l ON u.sid = l.sid
    WHERE u.type <> ''R''
';