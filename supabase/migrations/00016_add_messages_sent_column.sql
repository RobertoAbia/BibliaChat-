-- Migration: Add messages_sent column to daily_activity
-- Purpose: Track daily message count for free users (5 messages/day limit)

ALTER TABLE daily_activity
ADD COLUMN messages_sent INTEGER NOT NULL DEFAULT 0;

-- Add comment for documentation
COMMENT ON COLUMN daily_activity.messages_sent IS 'Number of chat messages sent by the user on this date (for free tier limit)';
