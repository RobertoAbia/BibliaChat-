-- Migration: Create bible_verses table for local Bible storage
-- Replaces dependency on API.Bible which changed its pricing model

CREATE TABLE bible_verses (
  id SERIAL PRIMARY KEY,
  book_id VARCHAR(3) NOT NULL,      -- GEN, EXO, LEV, MRK, LUK, JHN, etc.
  book_name VARCHAR(50) NOT NULL,   -- Génesis, Éxodo, Marcos, Lucas, Juan
  chapter INT NOT NULL,
  verse INT NOT NULL,
  text TEXT NOT NULL,
  UNIQUE(book_id, chapter, verse)
);

-- Index for fast lookups by book/chapter/verse
CREATE INDEX idx_bible_verses_lookup ON bible_verses(book_id, chapter, verse);

-- Index for range queries (fetching multiple verses)
CREATE INDEX idx_bible_verses_range ON bible_verses(book_id, chapter);

COMMENT ON TABLE bible_verses IS 'Reina Valera 1909 Bible verses (public domain)';
COMMENT ON COLUMN bible_verses.book_id IS 'Standard 3-letter book abbreviation (GEN, EXO, MRK, etc.)';
COMMENT ON COLUMN bible_verses.book_name IS 'Spanish book name (Génesis, Marcos, etc.)';
