-- Add motive_detail column to user_profiles
-- Stores the follow-up detail for the user's faith motivation (motive)
-- Used for Firebase Analytics segmentation only

ALTER TABLE user_profiles
ADD COLUMN IF NOT EXISTS motive_detail TEXT;

COMMENT ON COLUMN user_profiles.motive_detail IS 'Follow-up detail for motive: family_issues, health_issues, financial_issues, prayer_life, bible_knowledge, daily_faith, stopped_practicing, faith_doubts, painful_experience, apply_teachings, historical_context, denomination_differences';
