-- ============================================================================
-- Description:  Shows the current physical hostname of a SQL Server cluster
--               node (useful for AlwaysOn/Failover clusters).
-- Created:      Universal script
-- ============================================================================

SELECT
    SERVERPROPERTY('ComputerNamePhysicalNetBIOS') AS [PhysicalHostname],
    SERVERPROPERTY('ServerName') AS [ServerName],
    SERVERPROPERTY('InstanceName') AS [InstanceName];