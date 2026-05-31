-- ============================================================================
-- Description:  Shows all SQL Server Agent job steps with their commands.
--               Optionally filter by specific command patterns.
-- Created:      Universal script
-- ============================================================================

-- Optional: Filter for commands (e.g. only DELETE commands)
DECLARE @FilterCommand NVARCHAR(100) = NULL;  -- e.g. 'DEL%' or 'BACKUP%' or NULL for all

SELECT
    SERVERPROPERTY('ComputerNamePhysicalNetBIOS') AS [Hostname],
    j.name AS [JobName],
    j.enabled AS [JobEnabled],
    s.step_id AS [StepNumber],
    s.step_name AS [StepName],
    s.subsystem AS [Subsystem],
    CASE
        WHEN s.on_success_action = 1 THEN 'Quit with success'
        WHEN s.on_success_action = 2 THEN 'Quit with failure'
        WHEN s.on_success_action = 3 THEN 'Next step'
        WHEN s.on_success_action = 4 THEN 'Go to step'
        WHEN s.on_success_action = 5 THEN 'Restart'
        ELSE 'Action ' + CAST(s.on_success_action AS VARCHAR)
    END AS [OnSuccess],
    s.command AS [Command]
FROM msdb.dbo.sysjobsteps s
    JOIN msdb.dbo.sysjobs j ON s.job_id = j.job_id
WHERE (@FilterCommand IS NULL OR s.command LIKE @FilterCommand)
ORDER BY j.name, s.step_id;