-- Migration: Add gender column to user_profiles
-- Stores user gender for personalization

-- Create enum for gender
CREATE TYPE gender_type AS ENUM ('male', 'female');

-- Add column to user_profiles
ALTER TABLE user_profiles
ADD COLUMN gender gender_type;

-- Comment explaining the column
COMMENT ON COLUMN user_profiles.gender IS
'User gender for content personalization and AI responses';
