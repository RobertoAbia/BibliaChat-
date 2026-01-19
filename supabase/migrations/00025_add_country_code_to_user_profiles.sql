-- Add country_code column to user_profiles
-- Stores the ISO 3166-1 alpha-2 country code (e.g., MX, ES, CO)
-- This is in addition to origin_group which is used for AI prompt customization

ALTER TABLE user_profiles
ADD COLUMN IF NOT EXISTS country_code VARCHAR(2);

-- Add index for potential analytics queries by country
CREATE INDEX IF NOT EXISTS idx_user_profiles_country_code ON user_profiles(country_code);

COMMENT ON COLUMN user_profiles.country_code IS 'ISO 3166-1 alpha-2 country code (e.g., MX for Mexico, ES for Spain)';
