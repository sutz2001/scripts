-- ============================================================================
-- Description:  Shows all server role memberships at instance level,
--               including login name and assigned server role.
-- Created:      Universal script
-- ============================================================================

SELECT
    p.name AS [Login],
    p.type_desc AS [LoginType],
    pp.name AS [ServerRole],
    pp.type_desc AS [RoleType]
FROM sys.server_role_members roles
    JOIN sys.server_principals p ON roles.member_principal_id = p.principal_id
    JOIN sys.server_principals pp ON roles.role_principal_id = pp.principal_id
WHERE pp.type_desc <> 'CERTIFICATE_MAPPED_LOGIN'
  AND pp.type_desc <> 'CERTIFICATE_MAPPED_USER'
ORDER BY pp.name, p.name;