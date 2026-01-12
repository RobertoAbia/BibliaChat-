-- Migration: Add chat_id to user_plans
-- Purpose: Link each user plan to a single chat conversation for continuity across all days

-- Add chat_id column to user_plans (nullable, references chats)
ALTER TABLE user_plans
ADD COLUMN chat_id UUID REFERENCES chats(id) ON DELETE SET NULL;

-- Add index for faster lookups
CREATE INDEX idx_user_plans_chat_id ON user_plans(chat_id);

-- Add comment
COMMENT ON COLUMN user_plans.chat_id IS 'Optional link to a chat conversation for this plan. All days of the plan share the same chat.';
