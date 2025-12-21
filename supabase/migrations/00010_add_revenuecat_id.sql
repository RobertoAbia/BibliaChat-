-- Migration: Add RevenueCat App User ID for purchase restoration
-- This allows users to restore purchases AND recover all their data
-- without needing to create an account (email/password)

-- Add column to store RevenueCat's app_user_id
ALTER TABLE user_profiles
ADD COLUMN rc_app_user_id TEXT UNIQUE;

-- Index for fast lookup during purchase restoration
CREATE INDEX idx_user_profiles_rc_app_user_id
ON user_profiles(rc_app_user_id)
WHERE rc_app_user_id IS NOT NULL;

-- Comment explaining the column
COMMENT ON COLUMN user_profiles.rc_app_user_id IS
'RevenueCat app_user_id - allows restoring purchases AND migrating user data to new anonymous accounts';
