-- ============================================================================
-- Description:  Grants default permissions for a user or group on SQL Server
--               endpoints and server view.
--               Replace [YOUR_USER_OR_GROUP] with the desired name.
-- Created:      Universal script
-- ============================================================================

-- Grant default endpoints for TDS connections
GRANT CONNECT ON ENDPOINT::[TSQL Default TCP] TO [YOUR_USER_OR_GROUP];
GRANT CONNECT ON ENDPOINT::[TSQL Local Machine] TO [YOUR_USER_OR_GROUP];

-- Grant view of all databases
GRANT VIEW ANY DATABASE TO [YOUR_USER_OR_GROUP];