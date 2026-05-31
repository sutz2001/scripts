-- ============================================================================
-- Description:  Grants the VIEW SERVER STATE permission to a login,
--               enabling Activity Monitor and DMV queries.
--               Replace [YOUR_USER_NAME] with the desired login.
-- Created:      Universal script
-- ============================================================================

-- Grant
GRANT VIEW SERVER STATE TO [YOUR_USER_NAME];

-- Revoke (if needed)
-- REVOKE VIEW SERVER STATE FROM [YOUR_USER_NAME];