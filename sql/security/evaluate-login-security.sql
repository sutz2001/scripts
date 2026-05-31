-- ============================================================================
-- Description:  Evaluates for each login its membership in server and
--               database roles and generates T-SQL for replication.
--               Note: Sysadmin rights required.
-- Created:      Universal script
-- ============================================================================

IF IS_SRVROLEMEMBER('sysadmin') != 1
BEGIN
    RAISERROR('Sysadmin rights required.', 16, 1) WITH NOWAIT;
    RETURN
END
GO

USE master;
SET NOCOUNT ON;
GO

-- Windows logins
SELECT 'IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = ' + QUOTENAME(name, '''') + ')
CREATE LOGIN ' + QUOTENAME(name) + ' FROM WINDOWS WITH DEFAULT_DATABASE = ' + QUOTENAME(default_database_name) + ', DEFAULT_LANGUAGE = ' + default_language_name + ';
GO'
FROM sys.server_principals WHERE type IN ('U', 'G');
GO

-- Server roles
SELECT 'ALTER SERVER ROLE ' + QUOTENAME(sr.name) + ' ADD MEMBER ' + QUOTENAME(sp.name) + ';
GO'
FROM sys.server_principals sp
    JOIN sys.server_role_members srm ON sp.principal_id = srm.member_principal_id
    JOIN sys.server_principals sr ON srm.role_principal_id = sr.principal_id
WHERE sp.type = 'U';
GO