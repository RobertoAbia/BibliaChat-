-- Migration: Add practical_exercise column to plan_days
-- Purpose: Store daily practical exercises for study plans

ALTER TABLE plan_days
ADD COLUMN practical_exercise text;

COMMENT ON COLUMN plan_days.practical_exercise IS 'Practical exercise for the user to do during the day (e.g., "Today, forgive someone who hurt you")';
