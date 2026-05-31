-- ============================================================================
-- Description:  Shows all server permissions (roles and explicit permissions)
--               for each login.
-- Created:      Universal script
-- ============================================================================

-- Server role memberships
SELECT
    sp.name AS [Login],
    'Role: ' + sp2.name AS [Permission]
FROM sys.server_principals sp
    JOIN sys.server_role_members srm ON sp.principal_id = srm.member_principal_id
    JOIN sys.server_principals sp2 ON srm.role_principal_id = sp2.principal_id
WHERE sp.name NOT LIKE '%MS_%'

UNION ALL

-- Explicit server permissions
SELECT
    sp.name AS [Login],
    sperm.state_desc + ' ' + sperm.permission_name AS [Permission]
FROM sys.server_principals sp
    JOIN sys.server_permissions sperm ON sp.principal_id = sperm.grantee_principal_id
WHERE NOT (sperm.type = 'COSQ' AND sperm.state = 'G')
  AND sp.name NOT LIKE '%MS_%'

ORDER BY [Login], [Permission];