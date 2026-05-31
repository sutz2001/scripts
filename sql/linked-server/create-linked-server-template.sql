-- ============================================================================
-- Description:  Template for creating a linked server with login.
--               Replace the placeholders with your values.
-- Created:      Universal script
-- ============================================================================

DECLARE @LinkedServerName NVARCHAR(128) = 'YOUR_LINKED_SERVER';
DECLARE @RemoteIPPort     NVARCHAR(128) = '192.168.1.100,1433';
DECLARE @UserName         NVARCHAR(128) = 'YOUR_USER_NAME';
DECLARE @UserPassword     NVARCHAR(128) = 'YOUR_PASSWORD';

-- Create linked server
EXEC master.dbo.sp_addlinkedserver
    @server = @LinkedServerName,
    @srvproduct = N'',
    @provider = N'SQLNCLI',
    @datasrc = @RemoteIPPort;

-- Create login mapping
EXEC master.dbo.sp_addlinkedsrvlogin
    @rmtsrvname = @LinkedServerName,
    @locallogin = NULL,
    @useself = N'False',
    @rmtuser = @UserName,
    @rmtpassword = @UserPassword;

PRINT 'Linked Server [' + @LinkedServerName + '] created.';