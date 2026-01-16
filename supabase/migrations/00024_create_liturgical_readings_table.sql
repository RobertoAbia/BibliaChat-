-- Migration: Create liturgical_readings table
-- Stores Catholic liturgical calendar data locally (replaces dependency on external API)

CREATE TABLE IF NOT EXISTS liturgical_readings (
  id SERIAL PRIMARY KEY,
  reading_date DATE NOT NULL UNIQUE,
  season TEXT,                          -- "Ordinary Time", "Lent", "Advent", "Christmas", "Easter"
  first_reading TEXT,                   -- "1 Samuel 4:1-11"
  psalm TEXT,                           -- "Psalm 89"
  second_reading TEXT,                  -- NULL if not applicable (weekdays)
  gospel TEXT NOT NULL,                 -- "Mark 1:40-45"
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Index for fast date lookups
CREATE INDEX idx_liturgical_readings_date ON liturgical_readings(reading_date);

-- Comment on table
COMMENT ON TABLE liturgical_readings IS 'Catholic liturgical calendar with daily readings. Data imported from cpbjr/catholic-readings-api.';
