-- Calendario litúrgico católico 2026
-- Fuente: https://github.com/cpbjr/catholic-readings-api
-- Generado: 2026-01-16T19:45:13.616Z
-- Total: 365 lecturas

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-01-01', 'Christmas', 'Numbers 6:22-27', 'Psalm 67:2-3, 5, 6, 8', 'Galatians 4:4-7', 'Luke 2:16-21')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-01-02', 'Christmas', '1 John 2:22-28', 'Psalm 98:1, 2-3ab, 3cd-4', NULL, 'John 1:19-28')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-01-03', 'Christmas', '1 John 2:29–3:6', 'Psalm 98:1, 3cd-4, 5-6', NULL, 'John 1:29-34')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-01-04', 'Christmas', 'Isaiah 60:1-6', 'Psalm 72:1-2, 7-8, 10-11, 12-13.', 'Ephesians 3:2-3a, 5-6', 'Matthew 2:1-12')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-01-05', 'Christmas', '1 John 3:22–4:6', 'Psalm 2:7bc-8, 10-12a', NULL, 'Matthew 4:12-17, 23-25')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-01-06', 'Christmas', '1 John 4:7-10', 'Psalm 72:1-2, 3-4, 7-8', NULL, 'Mark 6:34-44')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-01-07', 'Christmas', '1 John 4:11-18', 'Psalm 72:1-2, 10, 12-13', NULL, 'Mark 6:45-52')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-01-08', 'Christmas', '1 John 4:19–5:4', 'Psalm 72:1-2, 14 and 15bc, 17', NULL, 'Luke 4:14-22')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-01-09', 'Christmas', '1 John 5:5-13', 'Psalm 147:12-13, 14-15, 19-20', NULL, 'Luke 5:12-16')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-01-10', 'Christmas', '1 John 5:14-21', 'Psalm 149:1-2, 3-4, 5-6a and 9b', NULL, 'John 3:22-30')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-01-11', 'Christmas', 'Isaiah 42:1-4, 6-7', 'Psalm 29:1-2, 3-4, 3, 9-10', 'Acts 10:34-38', 'Matthew 3:13-17')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-01-12', 'Ordinary Time', '1 Samuel 1:1-8', 'Psalm 116:12-13, 14-17, 18-19', NULL, 'Mark 1:14-20')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-01-13', 'Ordinary Time', '1 Samuel 1:9-20', '1 Samuel 2:1, 4-5, 6-7, 8abcd', NULL, 'Mark 1:21-28')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-01-14', 'Ordinary Time', '1 Samuel 3:1-10, 19-20', 'Psalm 40:2 and 5, 7-8a, 8b-9, 10', NULL, 'Mark 1:29-39')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-01-15', 'Ordinary Time', '1 Samuel 4:1-11', 'Psalm 44:10-11, 14-15, 24-25', NULL, 'Mark 1:40-45')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-01-16', 'Ordinary Time', '1 Samuel 8:4-7, 10-22a', 'Psalm 89:16-17, 18-19', NULL, 'Mark 2:1-12')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-01-17', 'Ordinary Time', '1 Samuel 9:1-4, 17-19; 10:1', 'Psalm 21:2-3, 4-5, 6-7', NULL, 'Mark 2:13-17')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-01-18', 'Ordinary Time', 'Isaiah 49:3, 5-6', 'Psalm 40:2, 4, 7-8, 8-9, 10', '1 Corinthians 1:1-3', 'John 1:29-34')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-01-19', 'Ordinary Time', '1 Samuel 15:16-23', 'Psalm 50:8-9, 16bc-17, 21 and 23', NULL, 'Mark 2:18-22')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-01-20', 'Ordinary Time', '1 Samuel 16:1-13', 'Psalm 89:20, 21-22, 27-28', NULL, 'Mark 2:23-28')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-01-21', 'Ordinary Time', '1 Samuel 17:32-33, 37, 40-51', 'Psalm 144:1b, 2, 9-10', NULL, 'Mark 3:1-6')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-01-22', 'Ordinary Time', '1 Samuel 18:6-9; 19:1-7', 'Psalm 56:2-3, 9-10a, 10b-11, 12-13', NULL, 'Mark 3:7-12')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-01-23', 'Ordinary Time', '1 Samuel 24:3-21', 'Psalm 57:2, 3-4, 6 and 11', NULL, 'Mark 3:13-19')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-01-24', 'Ordinary Time', '2 Samuel 1:1-4, 11-12, 19, 23-27', 'Psalm 80:2-3, 5-7', NULL, 'Mark 3:20-21')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-01-25', 'Ordinary Time', 'Isaiah 8:23—9:3', 'Psalm 27:1, 4, 13-14', '1 Corinthians 1:10-13, 17', 'Matthew 4:12-23 or 4:12-17')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-01-26', 'Ordinary Time', '2 Timothy 1:1-8', 'Psalm 96:1-2a, 2b-3, 7-8a, 10', NULL, 'Mark 3:22-30')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-01-27', 'Ordinary Time', '2 Samuel 6:12b-15, 17-19', 'Psalm 24:7, 8, 9, 10', NULL, 'Mark 3:31-35')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-01-28', 'Ordinary Time', '2 Samuel 7:4-17', 'Psalm 89:4-5, 27-28, 29-30', NULL, 'Mark 4:1-20')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-01-29', 'Ordinary Time', '2 Samuel 7:18-19, 24-29', 'Psalm 132:1-2, 3-5, 11, 12, 13-14', NULL, 'Mark 4:21-25')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-01-30', 'Ordinary Time', '2 Samuel 11:1-4a, 5-10a, 13-17', 'Psalm 51:3-4, 5-6a, 6bcd-7, 10-11', NULL, 'Mark 4:26-34')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-01-31', 'Ordinary Time', '2 Samuel 12:1-7a, 10-17', 'Psalm 51:12-13, 14-15, 16-17', NULL, 'Mark 4:35-41')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-02-01', 'Ordinary Time', 'Zephaniah 2:3; 3:12-13', 'Psalm 146:6-7, 8-9, 9-10', '1 Corinthians 1:26-31', 'Matthew 5:1-12a')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-02-02', 'Ordinary Time', 'Malachi 3:1-4', 'Psalm 24:7, 8, 9, 10', 'Hebrews 2:14-18', 'Luke 2:22-40 or 2:22-32')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-02-03', 'Ordinary Time', '2 Samuel 18:9-10, 14b, 24-25a, 30–19:3', 'Psalm 86:1-2, 3-4, 5-6', NULL, 'Mark 5:21-43')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-02-04', 'Ordinary Time', '2 Samuel 24:2, 9-17', 'Psalm 32:1-2, 5, 6, 7', NULL, 'Mark 6:1-6')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-02-05', 'Ordinary Time', '1 Kings 2:1-4, 10-12', '1 Chronicles 29:10, 11ab, 11d-12a, 12bcd', NULL, 'Mark 6:7-13')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-02-06', 'Ordinary Time', 'Sirach 47:2-11', 'Psalm 18:31, 47 and 50, 51', NULL, 'Mark 6:14-29')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-02-07', 'Ordinary Time', '1 Kings 3:4-13', 'Psalm 119:9, 10, 11, 12, 13, 14', NULL, 'Mark 6:30-34')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-02-08', 'Ordinary Time', 'Isaiah 58:7-10', 'Psalm 112:4-5, 6-7, 8-9', '1 Corinthians 2:1-5', 'Matthew 5:13-16')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-02-09', 'Ordinary Time', '1 Kings 8:1-7, 9-13', 'Psalm 132:6-7, 8-10', NULL, 'Mark 6:53-56')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-02-10', 'Ordinary Time', '1 Kings 8:22-23, 27-30', 'Psalm 84:3, 4, 5 and 10, 11', NULL, 'Mark 7:1-13')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-02-11', 'Ordinary Time', '1 Kings 10:1-10', 'Psalm 37:5-6, 30-31, 39-40', NULL, 'Mark 7:14-23')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-02-12', 'Ordinary Time', '1 Kings 11:4-13', 'Psalm 106:3-4, 35-36, 37 and 40', NULL, 'Mark 7:24-30')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-02-13', 'Ordinary Time', '1 Kings 11:29-32; 12:19', 'Psalm 81:10-11ab, 12-13, 14-15', NULL, 'Mark 7:31-37')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-02-14', 'Ordinary Time', '1 Kings 12:26-32; 13:33-34', 'Psalm 106:6-7ab, 19-20, 21-22', NULL, 'Mark 8:1-10')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-02-15', 'Ordinary Time', 'Sirach 15:15-20', 'Psalm 119:1-2, 4-5, 17-18, 33-34', '1 Corinthians 2:6-10', 'Matthew 5:17-37')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-02-16', 'Ordinary Time', 'James 1:1-11', 'Psalm 119:67, 68, 71, 72, 75, 76', NULL, 'Mark 8:11-13')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-02-17', 'Ordinary Time', 'James 1:12-18', 'Psalm 94:12-13a, 14-15, 18-19', NULL, 'Mark 8:14-21')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-02-18', 'Lent', 'Joel 2:12-18', 'Psalm 51:3-4, 5-6ab, 12-13, 14 and 17', '2 Corinthians 5:20—6:2', 'Matthew 6:1-6, 16-18')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-02-19', 'Lent', 'Deuteronomy 30:15-20', 'Psalm 1:1-2, 3, 4 and 6', NULL, 'Luke 9:22-25')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-02-20', 'Lent', 'Isaiah 58:1-9a', 'Psalm 51:3-4, 5-6ab, 18-19', NULL, 'Matthew 9:14-15')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-02-21', 'Lent', 'Isaiah 58:9b-14', 'Psalm 86:1-2, 3-4, 5-6', NULL, 'Luke 5:27-32')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-02-22', 'Lent', 'Genesis 2:7-9; 3:1-7', 'Psalm 51:3-4, 5-6, 12-13, 17', 'Romans 5:12-19 or 5:12, 17-19', 'Matthew 4:1-11')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-02-23', 'Lent', 'Leviticus 19:1-2, 11-18', 'Psalm 19:8, 9, 10, 15', NULL, 'Matthew 25:31-46')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-02-24', 'Lent', 'Isaiah 55:10-11', 'Psalm 34:4-5, 6-7, 16-17, 18-19', NULL, 'Matthew 6:7-15')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-02-25', 'Lent', 'Jonah 3:1-10', 'Psalm 51:3-4, 12-13, 18-19', NULL, 'Luke 11:29-32')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-02-26', 'Lent', 'Esther C:12, 14-16, 23-25', 'Psalm 138:1-2ab, 2cde-3, 7c-8', NULL, 'Matthew 7:7-12')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-02-27', 'Lent', 'Ezekiel 18:21-28', 'Psalm 130:1-2, 3-4, 5-7a, 7bc-8', NULL, 'Matthew 5:20-26')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-02-28', 'Lent', 'Deuteronomy 26:16-19', 'Psalm 119:1-2, 4-5, 7-8', NULL, 'Matthew 5:43-48')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-03-01', 'Lent', 'Genesis 12:1-4a', 'Psalm 33:4-5, 18-19, 20, 22.', '2 Timothy 1:8b-10', 'Matthew 17:1-9')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-03-02', 'Lent', 'Daniel 9:4b-10', 'Psalm 79:8, 9, 11 and 13', NULL, 'Luke 6:36-38')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-03-03', 'Lent', 'Isaiah 1:10, 16-20', 'Psalm 50:8-9, 16bc-17, 21 and 23', NULL, 'Matthew 23:1-12')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-03-04', 'Lent', 'Jeremiah 18:18-20', 'Psalm 31:5-6, 14, 15-16', NULL, 'Matthew 20:17-28')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-03-05', 'Lent', 'Jeremiah 17:5-10', 'Psalm 1:1-2, 3, 4 and 6', NULL, 'Luke 16:19-31')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-03-06', 'Lent', 'Genesis 37:3-4, 12-13a, 17b-28a', 'Psalm 105:16-17, 18-19, 20-21', NULL, 'Matthew 21:33-43, 45-46')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-03-07', 'Lent', 'Micah 7:14-15, 18-20', 'Psalm 103:1-2, 3-4, 9-10, 11-12', NULL, 'Luke 15:1-3, 11-32')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-03-08', 'Lent', 'Exodus 17:3-7', 'Psalm 95:1-2, 6-7, 8-9', 'Romans 5:1-2, 5-8', 'John 4:5-42')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-03-09', 'Lent', '2 Kings 5:1-15ab', 'Psalm 42:2, 3; 43:3, 4', NULL, 'Luke 4:24-30')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-03-10', 'Lent', 'Daniel 3:25, 34-43', 'Psalm 25:4-5ab, 6 and 7bc, 8-9', NULL, 'Matthew 18:21-35')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-03-11', 'Lent', 'Deuteronomy 4:1, 5-9', 'Psalm 147:12-13, 15-16, 19-20', NULL, 'Matthew 5:17-19')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-03-12', 'Lent', 'Jeremiah 7:23-28', 'Psalm 95:1-2, 6-7, 8-9', NULL, 'Luke 11:14-23')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-03-13', 'Lent', 'Hosea 14:2-10', 'Psalm 81:6c-8a, 8bc-9, 10-11ab, 14 and 17', NULL, 'Mark 12:28-34')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-03-14', 'Lent', 'Hosea 6:1-6', 'Psalm 51:3-4, 18-19, 20-21ab', NULL, 'Luke 18:9-14')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-03-15', 'Lent', '1 Samuel 16:1b, 6-7, 10-13a', 'Psalm 23: 1-3a, 3b-4, 5, 6', 'Ephesians 5:8-14', 'John 9:1-41')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-03-16', 'Lent', 'Isaiah 65:17-21', 'Psalm 30:2 and 4, 5-6, 11-12a and 13b', NULL, 'John 4:43-54')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-03-17', 'Lent', 'Ezekiel 47:1-9, 12', 'Psalm 46:2-3, 5-6, 8-9', NULL, 'John 5:1-16')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-03-18', 'Lent', 'Isaiah 49:8-15', 'Psalm 145:8-9, 13cd-14, 17-18', NULL, 'John 5:17-30')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-03-19', 'Lent', '2 Samuel 7:4-5a, 12-14a, 16', 'Psalm 89:2-3, 4-5, 27 and 29', 'Romans 4:13, 16-18, 22', 'Matthew 1:16, 18-21, 24a')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-03-20', 'Lent', 'Wisdom 2:1a, 12-22', 'Psalm 34:17-18, 19-20, 21 and 23', NULL, 'John 7:1-2, 10, 25-30')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-03-21', 'Lent', 'Jeremiah 11:18-20', 'Psalm 7:2-3, 9bc-10, 11-12', NULL, 'John 7:40-53')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-03-22', 'Lent', 'Ezekiel 37:12-14', 'Psalm 130:1-2, 3-4, 5-6, 7-8', 'Romans 8:8-11', 'John 11:1-45')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-03-23', 'Lent', 'Daniel 13:1-9, 15-17, 19-30, 33-62 or 13:41c-62', 'Psalm 23:1-3a, 3b-4, 5, 6', NULL, 'John 8:1-11')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-03-24', 'Lent', 'Numbers 21:4-9', 'Psalm 102:2-3, 16-18, 19-21', NULL, 'John 8:21-30')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-03-25', 'Lent', 'Isaiah 7:10-14; 8:10', 'Psalm 40:7-8a, 8b-9, 10, 11', 'Hebrews 10:4-10', 'Luke 1:26-38')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-03-26', 'Lent', 'Genesis 17:3-9', 'Psalm 105:4-5, 6-7, 8-9', NULL, 'John 8:51-59')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-03-27', 'Lent', 'Jeremiah 20:10-13', 'Psalm 18:2-3a, 3bc-4, 5-6, 7', NULL, 'John 10:31-42')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-03-28', 'Lent', 'Ezekiel 37:21-28', 'Jeremiah 31:10, 11-12abcd, 13', NULL, 'John 11:45-56')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-03-29', 'Holy Week', 'Isaiah 50:4-7', 'Psalm 22:8-9, 17-18, 19-20, 23-24', 'Philippians 2:6-11', 'Matthew 26:14—27:66')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-03-30', 'Holy Week', 'Isaiah 42:1-7', 'Psalm 27:1, 2, 3, 13-14', NULL, 'John 12:1-11')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-03-31', 'Holy Week', 'Isaiah 49:1-6', 'Psalm 71:1-2, 3-4a, 5ab-6ab, 15 and 17', NULL, 'John 13:21-33, 36-38')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-04-01', 'Holy Week', 'Isaiah 50:4-9a', 'Psalm 69:8-10, 21-22, 31 and 33-34', NULL, 'Matthew 26:14-25')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-04-02', 'Holy Week', 'Exodus 12:1-8, 11-14', 'Psalm 116:12-13, 15-16bc, 17-18.', '1 Corinthians 11:23-26', 'John 13:1-15')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-04-03', 'Holy Week', 'Isaiah 52:13—53:12', 'Psalm 31:2, 6, 12-13, 15-16, 17, 25', 'Hebrews 4:14-16; 5:7-9', 'John 18:1—19:42')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-04-04', 'Holy Week', 'Isaiah 54:5-14', 'Psalm 118:1-2, 16-17, 22-23', 'Exodus 14:15—15:1', 'Matthew 28:1-10')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-04-05', 'Eastertide', 'Acts 10:34a, 37-43', 'Psalm 118:1-2, 16-17, 22-23', 'Colossians 3:1-4', 'John 20:1-9')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-04-06', 'Eastertide', 'Acts 2:14, 22-33', 'Psalm 16:1-2a and 5, 7-8, 9-10, 11', NULL, 'Matthew 28:8-15')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-04-07', 'Eastertide', 'Acts 2:36-41', 'Psalm 33:4-5, 18-19, 20 and 22', NULL, 'John 20:11-18')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-04-08', 'Eastertide', 'Acts 3:1-10', 'Psalm 105:1-2, 3-4, 6-7, 8-9', NULL, 'Luke 24:13-35')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-04-09', 'Eastertide', 'Acts 3:11-26', 'Psalm 8:2ab and 5, 6-7, 8-9', NULL, 'Luke 24:35-48')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-04-10', 'Eastertide', 'Acts 4:1-12', 'Psalm 118:1-2 and 4, 22-24, 25-27a', NULL, 'John 21:1-14')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-04-11', 'Eastertide', 'Acts 4:13-21', 'Psalm 118:1 and 14-15ab, 16-18, 19-21', NULL, 'Mark 16:9-15')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-04-12', 'Eastertide', 'Acts 2:42-47', 'Psalm 118:2-4, 13-15, 22-24', '1 Peter 1:3-9', 'John 20:19-31')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-04-13', 'Eastertide', 'Acts 4:23-31', 'Psalm 2:1-3, 4-7a, 7b-9', NULL, 'John 3:1-8')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-04-14', 'Eastertide', 'Acts 4:32-37', 'Psalm 93:1ab, 1cd-2, 5', NULL, 'John 3:7b-15')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-04-15', 'Eastertide', 'Acts 5:17-26', 'Psalm 34:2-3, 4-5, 6-7, 8-9', NULL, 'John 3:16-21')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-04-16', 'Eastertide', 'Acts 5:27-33', 'Psalm 34:2 and 9, 17-18, 19-20', NULL, 'John 3:31-36')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-04-17', 'Eastertide', 'Acts 5:34-42', 'Psalm 27:1, 4, 13-14', NULL, 'John 6:1-15')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-04-18', 'Eastertide', 'Acts 6:1-7', 'Psalm 33:1-2, 4-5, 18-19', NULL, 'John 6:16-21')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-04-19', 'Eastertide', 'Acts 2:14, 22-33', 'Psalm 16:1-2, 5, 7-8, 9-10, 11', '1 Peter 1:17-21', 'Luke 24:13-35')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-04-20', 'Eastertide', 'Acts 6:8-15', 'Psalm 119:23-24, 26-27, 29-30', NULL, 'John 6:22-29')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-04-21', 'Eastertide', 'Acts 7:51—8:1a', 'Psalm 31:3cd-4, 6 and 7b and 8a, 17 and 21ab', NULL, 'John 6:30-35')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-04-22', 'Eastertide', 'Acts 8:1b-8', 'Psalm 66:1-3a, 4-5, 6-7a', NULL, 'John 6:35-40')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-04-23', 'Eastertide', 'Acts 8:26-40', 'Psalm 66:8-9, 16-17, 20', NULL, 'John 6:44-51')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-04-24', 'Eastertide', 'Acts 9:1-20', 'Psalm 117:1bc, 2', NULL, 'John 6:52-59')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-04-25', 'Eastertide', '1 Peter 5:5b-14', 'Psalm 89:2-3, 6-7, 16-17', NULL, 'Mark 16:15-20')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-04-26', 'Eastertide', 'Acts 2:14a, 36-41', 'Psalm 23: 1-3a, 3b4, 5, 6', '1 Peter 2:20b-25', 'John 10:1-10')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-04-27', 'Eastertide', 'Acts 11:1-18', 'Psalm 42:2-3; 43:3, 4', NULL, 'John 10:11-18')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-04-28', 'Eastertide', 'Acts 11:19-26', 'Psalm 87:1b-3, 4-5, 6-7', NULL, 'John 10:22-30')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-04-29', 'Eastertide', 'Acts 12:24—13:5a', 'Psalm 67:2-3, 5, 6 and 8', NULL, 'John 12:44-50')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-04-30', 'Eastertide', 'Acts 13:13-25', 'Psalm 89:2-3, 21-22, 25 and 27', NULL, 'John 13:16-20')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-05-01', 'Eastertide', 'Acts 13:26-33', 'Psalm 2:6-7, 8-9, 10-11ab', NULL, 'John 14:1-6')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-05-02', 'Eastertide', 'Acts 13:44-52', 'Psalm 98:1, 2-3ab, 3cd-4', NULL, 'John 14:7-14')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-05-03', 'Eastertide', 'Acts 6:1-7', 'Psalm 33:1-2, 4-5, 18-19', '1 Peter 2:4-9', 'John 14:1-12')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-05-04', 'Eastertide', 'Acts 14:5-18', 'Psalm 115:1-2, 3-4, 15-16', NULL, 'John 14:21-26')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-05-05', 'Eastertide', 'Acts 14:19-28', 'Psalm 145:10-11, 12-13ab, 21', NULL, 'John 14:27-31a')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-05-06', 'Eastertide', 'Acts 15:1-6', 'Psalm 122:1-2, 3-4ab, 4cd-5', NULL, 'John 15:1-8')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-05-07', 'Eastertide', 'Acts 15:7-21', 'Psalm 96:1-2a, 2b-3, 10', NULL, 'John 15:9-11')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-05-08', 'Eastertide', 'Acts 15:22-31', 'Psalm 57:8-9, 10 and 12', NULL, 'John 15:12-17')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-05-09', 'Eastertide', 'Acts 16:1-10', 'Psalm 100:1b-2, 3, 5', NULL, 'John 15:18-21')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-05-10', 'Eastertide', 'Acts 8:5-8, 14-17', 'Psalm 66:1-3, 4-5, 6-7, 16, 20', '1 Peter 3:15-18', 'John 14:15-21')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-05-11', 'Eastertide', 'Acts 16:11-15', 'Psalm 149:1b-2, 3-4, 5-6a and 9b', NULL, 'John 15:26—16:4a')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-05-12', 'Eastertide', 'Acts 16:22-34', 'Psalm 138:1-2ab, 2cde-3, 7c-8', NULL, 'John 16:5-11')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-05-13', 'Eastertide', 'Acts 17:15, 22—18:1', 'Psalm 148:1-2, 11-12, 13, 14', NULL, 'John 16:12-15')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-05-14', 'Eastertide', 'Acts 1:1-11', 'Psalm 47:2-3, 6-7, 8-9', 'Ephesians 1:17-23', 'Matthew 28:16-20')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-05-15', 'Eastertide', 'Acts 18:9-18', 'Psalm 47:2-3, 4-5, 6-7', NULL, 'John 16:20-23')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-05-16', 'Eastertide', 'Acts 18:23-28', 'Psalm 47:2-3, 8-9, 10', NULL, 'John 16:23b-28')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-05-17', 'Eastertide', 'Acts 1:1-11', 'Psalm 47:2-3, 6-7, 8-9', 'Ephesians 1:17-23', 'Matthew 28:16-20')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-05-18', 'Eastertide', 'Acts 19:1-8', 'Psalm 68:2-3ab, 4-5acd, 6-7ab', NULL, 'John 16:29-33')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-05-19', 'Eastertide', 'Acts 20:17-27', 'Psalm 68:10-11, 20-21', NULL, 'John 17:1-11a')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-05-20', 'Eastertide', 'Acts 20:28-38', 'Psalm 68:29-30, 33-35a, 35bc-36ab', NULL, 'John 17:11b-19')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-05-21', 'Eastertide', 'Acts 22:30; 23:6-11', 'Psalm 16:1-2a and 5, 7-8, 9-10, 11', NULL, 'John 17:20-26')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-05-22', 'Eastertide', 'Acts 25:13b-21', 'Psalm 103:1-2, 11-12, 19-20ab', NULL, 'John 21:15-19')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-05-23', 'Eastertide', 'Acts 28:16-20, 30-31', 'Psalm 11:4, 5 and 7', NULL, 'John 21:20-25')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-05-24', 'Eastertide', 'Acts 2:1-11', 'Psalm 104:1, 24, 29-30, 31, 34', '1 Corinthians 12:3b-7, 12-13', 'John 20:19-23')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-05-25', 'Ordinary Time', 'Genesis 3:9-15, 20', 'Psalm 87:1-2, 3 and 5, 6-7', NULL, 'John 19:25-34')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-05-26', 'Ordinary Time', '1 Peter 1:10-16', 'Psalm 98:1, 2-3ab, 3cd-4', NULL, 'Mark 10:28-31')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-05-27', 'Ordinary Time', '1 Peter 1:18-25', 'Psalm 147:12-13, 14-15, 19-20', NULL, 'Mark 10:32-45')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-05-28', 'Ordinary Time', '1 Peter 2:2-5, 9-12', 'Psalm 100:2, 3, 4, 5', NULL, 'Mark 10:46-52')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-05-29', 'Ordinary Time', '1 Peter 4:7-13', 'Psalm 96:10, 11-12, 13', NULL, 'Mark 11:11-26')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-05-30', 'Ordinary Time', 'Jude 17, 20b-25', 'Psalm 63:2, 3-4, 5-6', NULL, 'Mark 11:27-33')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-05-31', 'Ordinary Time', 'Exodus 34:4b-6, 8-9', 'Daniel 3:52, 53, 54, 55, 56', '2 Corinthians 13:11-13', 'John 3:16-18')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-06-01', 'Ordinary Time', '2 Peter 1:2-7', 'Psalm 91:1-2, 14-15b, 15c-16', NULL, 'Mark 12:1-12')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-06-02', 'Ordinary Time', '2 Peter 3:12-15a, 17-18', NULL, NULL, 'Mark 12:13-17')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-06-03', 'Ordinary Time', '2 Timothy 1:1-3, 6-12', 'Psalm 123:1b-2ab, 2cdef', NULL, 'Mark 12:18-27')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-06-04', 'Ordinary Time', '2 Timothy 2:8-15', 'Psalm 25:4-5ab, 8-9, 10 and 14', NULL, 'Mark 12:28-34')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-06-05', 'Ordinary Time', '2 Timothy 3:10-17', 'Psalm 119:157, 160, 161, 165, 166, 168', NULL, 'Mark 12:35-37')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-06-06', 'Ordinary Time', '2 Timothy 4:1-8', 'Psalm 71:8-9, 14-15AB, 16-17, 22', NULL, 'Mark 12:38-44')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-06-07', 'Ordinary Time', 'Deuteronomy 8:2-3, 14b-16a', 'Psalm 147:12-13, 14-15, 19-20', '1 Corinthians 10:16-17', 'John 6:51-58')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-06-08', 'Ordinary Time', '1 Kings 17:1-6', 'Psalm 121:1bc-2, 3-4, 5-6, 7-8', NULL, 'Matthew 5:1-12')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-06-09', 'Ordinary Time', '1 Kings 17:7-16', 'Psalm 4:2-3, 4-5, 7b-8', NULL, 'Matthew 5:13-16')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-06-10', 'Ordinary Time', '1 Kings 18:20-39', 'Psalm 16:1b-2ab, 4, 5ab and 8, 11', NULL, 'Matthew 5:17-19')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-06-11', 'Ordinary Time', 'Acts 11:21b-26; 13:1-3', 'Psalm 98:1, 2-3ab, 3cd-4, 5-6', NULL, 'Matthew 5:20-26')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-06-12', 'Ordinary Time', 'Deuteronomy 7:6-11', 'Psalm 103:1-2, 3-4, 6-7, 8, 10', '1 John 4:7-16', 'Matthew 11:25-30')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-06-13', 'Ordinary Time', '1 Kings 19:19-21', 'Psalm 16:1b-2a and 5, 7-8, 9-10', NULL, 'Matthew 5:33-37')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-06-14', 'Ordinary Time', 'Exodus 19:2-6a', 'Psalm 100:1-2, 3, 5', 'Romans 5:6-11', 'Matthew 9:36—10:8')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-06-15', 'Ordinary Time', '1 Kings 21:1-16', 'Psalm 5:2-3ab, 4b-6a, 6b-7', NULL, 'Matthew 5:38-42')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-06-16', 'Ordinary Time', '1 Kings 21:17-29', 'Psalm 51:3-4, 5-6ab, 11 and 16', NULL, 'Matthew 5:43-48')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-06-17', 'Ordinary Time', '2 Kings 2:1, 6-14', 'Psalm 31:20, 21, 24', NULL, 'Matthew 6:1-6, 16-18')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-06-18', 'Ordinary Time', 'Sirach 48:1-14', 'Psalm 97:1-2, 3-4, 5-6, 7', NULL, 'Matthew 6:7-15')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-06-19', 'Ordinary Time', '2 Kings 11:1-4, 9-18, 20', 'Psalm 132:11, 12, 13-14, 17-18', NULL, 'Matthew 6:19-23')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-06-20', 'Ordinary Time', '2 Chronicles 24:17-25', 'Psalm 89:4-5, 29-30, 31-32, 33-34', NULL, 'Matthew 6:24-34')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-06-21', 'Ordinary Time', 'Jeremiah 20:10-13', 'Psalm 69:8-10, 14, 17, 33-35', 'Romans 5:12-15', 'Matthew 10:26-33')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-06-22', 'Ordinary Time', '2 Kings 17:5-8, 13-15a, 18', 'Psalm 60:3, 4-5, 12-13', NULL, 'Matthew 7:1-5')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-06-23', 'Ordinary Time', '2 Kings 19:9b-11, 14-21, 31-35a, 36', 'Psalm 48:2-3Ab, 3cd-4, 10-11', NULL, 'Matthew 7:6, 12-14')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-06-24', 'Ordinary Time', 'Isaiah 49:1-6', 'Psalm 139:1b-3, 13-14ab, 14c-15', 'Acts 13:22-26', 'Luke 1:57-66, 80')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-06-25', 'Ordinary Time', '2 Kings 24:8-17', 'Psalm 79:1b-2, 3-5, 8, 9', NULL, 'Matthew 7:21-29')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-06-26', 'Ordinary Time', '2 Kings 25:1-12', 'Psalm 137:1-2, 3, 4-5, 6', NULL, 'Matthew 8:1-4')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-06-27', 'Ordinary Time', 'Lamentations 2:2, 10-14, 18-19', 'Psalm 74:1b-2, 3-5, 6-7, 20-21', NULL, 'Matthew 8:5-17')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-06-28', 'Ordinary Time', NULL, 'Psalm 89:2-3, 16-17, 18-19', 'Romans 6:3-4, 8-11', 'Matthew 10:37-42')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-06-29', 'Ordinary Time', 'Acts 12:1-11', 'Psalm 34:2-3, 4-5, 6-7, 8-9', '2 Timothy 4:6-8, 17-18', 'Matthew 16:13-19')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-06-30', 'Ordinary Time', 'Amos 3:1-8; 4:11-12', 'Psalm 5:5-6, 7, 8', NULL, 'Matthew 8:23-27')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-07-01', 'Ordinary Time', 'Amos 5:14-15, 21-24', 'Psalm 50:7, 8-9, 10-11, 12-13, 16bc-17', NULL, 'Matthew 8:28-34')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-07-02', 'Ordinary Time', 'Amos 7:10-17', 'Psalm 19:8, 9, 10, 11', NULL, 'Matthew 9:1-8')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-07-03', 'Ordinary Time', 'Ephesians 2:19-22', 'Psalm 117:1bc, 2', NULL, 'John 20:24-29')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-07-04', 'Ordinary Time', 'Amos 9:11-15', 'Psalm 85:9 and 10, 11-12, 13-14', NULL, 'Matthew 9:14-17')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-07-05', 'Ordinary Time', 'Zechariah 9:9-10', 'Psalm 145:1-2, 8-9, 10-11, 13-14', 'Romans 8:9, 11-13', 'Matthew 11:25-30')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-07-06', 'Ordinary Time', 'Hosea 2:16, 17c-18, 21-22', 'Psalm 145:2-3, 4-5, 6-7, 8-9', NULL, 'Matthew 9:18-26')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-07-07', 'Ordinary Time', 'Hosea 8:4-7, 11-13', 'Psalm 115:3-4, 5-6, 7ab-8, 9-10', NULL, 'Matthew 9:32-38')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-07-08', 'Ordinary Time', 'Hosea 10:1-3, 7-8, 12', 'Psalm 105:2-3, 4-5, 6-7', NULL, 'Matthew 10:1-7')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-07-09', 'Ordinary Time', 'Hosea 11:1-4, 8e-9', 'Psalm 80:2ac, 3b, 15-16', NULL, 'Matthew 10:7-15')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-07-10', 'Ordinary Time', 'Hosea 14:2-10', 'Psalm 51:3-4, 8-9, 12-13, 14, 17', NULL, 'Matthew 10:16-23')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-07-11', 'Ordinary Time', 'Isaiah 6:1-8', 'Psalm 93:1ab, 1cd-2, 5', NULL, 'Matthew 10:24-33')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-07-12', 'Ordinary Time', 'Isaiah 55:10-11', 'Psalm 65:10, 11, 12-13, 14', 'Romans 8:18-23', 'Matthew 13:1-23')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-07-13', 'Ordinary Time', 'Isaiah 1:10-17', 'Psalm 50:8-9, 16bc-17, 21, 23', NULL, 'Matthew 10:34-11:1')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-07-14', 'Ordinary Time', 'Isaiah 7:1-9', 'Psalm 48:2-3a, 3b-4, 5-6, 7-8', NULL, 'Matthew 11:20-24')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-07-15', 'Ordinary Time', 'Isaiah 10:5-7, 13b-16', 'Psalm 94:5-6, 7-8, 9-10, 14-15', NULL, 'Matthew 11:25-27')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-07-16', 'Ordinary Time', 'Isaiah 26:7-9, 12, 16-19', 'Psalm 102:13-14ab and 15, 16-18, 19-21', NULL, 'Matthew 11:28-30')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-07-17', 'Ordinary Time', 'Isaiah 38:1-6, 21-22, 7-8', 'Isaiah 38:10, 11, 12abcd, 16', NULL, 'Matthew 12:1-8')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-07-18', 'Ordinary Time', 'Micah 2:1-5', 'Psalm 10:1-2, 3-4, 7-8, 14', NULL, 'Matthew 12:14-21')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-07-19', 'Ordinary Time', 'Wisdom 12:13, 16-19', 'Psalm 86:5-6, 9-10, 15-16', 'Romans 8:26-27', 'Matthew 13:24-43')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-07-20', 'Ordinary Time', 'Micah 6:1-4, 6-8', 'Psalm 50:5-6, 8-9, 16bc-17, 21, 23', NULL, 'Matthew 12:38-42')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-07-21', 'Ordinary Time', 'Micah 7:14-15, 18-20', 'Psalm 85:2-4, 5-6, 7-8', NULL, 'Matthew 12:46-50')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-07-22', 'Ordinary Time', 'Song of Songs 3:1-4b', 'Psalm 63:2, 3-4, 5-6, 8-9', NULL, 'John 20:1-2, 11-18')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-07-23', 'Ordinary Time', 'Jeremiah 2:1-3, 7-8, 12-13', 'Psalm 36:6-7ab, 8-9, 10-11', NULL, 'Matthew 13:10-17')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-07-24', 'Ordinary Time', 'Jeremiah 3:14-17', 'Jeremiah 31:10, 11-12abcd, 13', NULL, 'Matthew 13:18-23')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-07-25', 'Ordinary Time', '2 Corinthians 4:7-15', 'Psalm 126:1bc-2ab, 2cd-3, 4-5, 6', NULL, 'Matthew 20:20-28')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-07-26', 'Ordinary Time', '1 Kings 3:5, 7-12', 'Psalm 119:57, 72, 76-77, 127-128, 129-130', 'Romans 8:28-30', 'Matthew 13:44-52')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-07-27', 'Ordinary Time', 'Jeremiah 13:1-11', 'Deuteronomy 32:18-19, 20, 21', NULL, 'Matthew 13:31-35')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-07-28', 'Ordinary Time', 'Jeremiah 14:17-22', 'Psalm 79:8, 9, 11 and 13', NULL, 'Matthew 13:36-43')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-07-29', 'Ordinary Time', 'Jeremiah 15:10, 16-21', 'Psalm 59:2-3, 4, 10-11, 17, 18', NULL, 'John 11:19-27')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-07-30', 'Ordinary Time', 'Jeremiah 18:1-6', 'Psalm 146:1B-2, 3-4, 5-6ab', NULL, 'Matthew 13:47-53')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-07-31', 'Ordinary Time', 'Jeremiah 26:1-9', 'Psalm 69:5, 8-10, 14', NULL, 'Matthew 13:54-58')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-08-01', 'Ordinary Time', 'Jeremiah 26:11-16, 24', 'Psalm 69:15-16, 30-31, 33-34', NULL, 'Matthew 14:1-12')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-08-02', 'Ordinary Time', 'Isaiah 55:1-3', 'Psalm 145:8-9, 15-16, 17-18', 'Romans 8:35, 37-39', 'Matthew 14:13-21')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-08-03', 'Ordinary Time', 'Jeremiah 28:1-17', 'Psalm 119:29, 43, 79, 80, 95, 102', NULL, 'Matthew 14:22-36')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-08-04', 'Ordinary Time', 'Jeremiah 30:1-2, 12-15, 18-22', 'Psalm 102:16-18, 19-21, 29, 22-23', NULL, 'Matthew 14:22-36')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-08-05', 'Ordinary Time', 'Jeremiah 31:1-7', 'Jeremiah 31:10, 11-12ab, 13', NULL, 'Matthew 15:21-28')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-08-06', 'Ordinary Time', 'Daniel 7:9-10, 13-14', 'Psalm 97:1-2, 5-6, 9', '2 Peter 1:16-19', 'Matthew 17:1-9')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-08-07', 'Ordinary Time', 'Nahum 2:1, 3; 3:1-3, 6-7', 'Deuteronomy 32:35cd-36ab, 39abcd, 41', NULL, 'Matthew 16:24-28')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-08-08', 'Ordinary Time', 'Habakkuk 1:12—2:4', 'Psalm 9:8-9, 10-11, 12-13', NULL, 'Matthew 17:14-20')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-08-09', 'Ordinary Time', '1 Kings 19:9a, 11-13a', 'Psalm 85:9, 10, 11-12, 13-14', 'Romans 9:1-5', 'Matthew 14:22-33')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-08-10', 'Ordinary Time', '2 Corinthians 9:6-10', 'Psalm 112:1-2, 5-6, 7-8, 9', NULL, 'John 12:24-26')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-08-11', 'Ordinary Time', 'Ezekiel 2:8-3:4', 'Psalm 119:14, 24, 72, 103, 111, 131', NULL, 'Matthew 18:1-5, 10, 12-14')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-08-12', 'Ordinary Time', 'Ezekiel 9:1-7; 10:18-22', 'Psalm 113:1-2, 3-4, 5-6', NULL, 'Matthew 18:15-20')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-08-13', 'Ordinary Time', 'Ezekiel 12:1-12', 'Psalm 78:56-57, 58-59, 61-62', NULL, 'Matthew 18:21–19:1')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-08-14', 'Ordinary Time', 'Ezekiel 16:1-15, 60, 63', 'Isaiah 12:2-3, 4bcd, 5-6', NULL, 'Matthew 19:3-12')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-08-15', 'Ordinary Time', NULL, 'Psalm 45:10, 11, 12, 16', '1 Corinthians 15:20-27', 'Luke 1:39-56')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-08-16', 'Ordinary Time', 'Isaiah 56:1, 6-7', 'Psalm 67:2-3, 5, 6, 8', 'Romans 11:13-15, 29-32', 'Matthew 15:21-28')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-08-17', 'Ordinary Time', 'Ezekiel 24:15-23', 'Deuteronomy 32:18-19, 20, 21', NULL, 'Matthew 19:16-22')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-08-18', 'Ordinary Time', 'Ezekiel 28:1-10', 'Deuteronomy 32:26-27ab, 27cd-28, 30, 35cd-36ab', NULL, 'Matthew 19:23-30')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-08-19', 'Ordinary Time', 'Ezekiel 34:1-11', 'Psalm 23:1-3a, 3b-4, 5, 6', NULL, 'Matthew 20:1-16')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-08-20', 'Ordinary Time', 'Ezekiel 36:23-28', 'Psalm 51:12-13, 14-15, 18-19', NULL, 'Matthew 22:1-14')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-08-21', 'Ordinary Time', 'Ezekiel 37:1-14', 'Psalm 107:2-3, 4-5, 6-7, 8-9', NULL, 'Matthew 22:34-40')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-08-22', 'Ordinary Time', 'Ezekiel 43:1-7ab', 'Psalm 85:9ab, 10, 11-12, 13-14', NULL, 'Matthew 23:1-12')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-08-23', 'Ordinary Time', 'Isaiah 22:19-23', 'Psalm 138:1-2, 2-3, 6, 8', 'Romans 11:33-36', 'Matthew 16:13-20')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-08-24', 'Ordinary Time', 'Revelation 21:9b-14', 'Psalm 145:10-11, 12-13, 17-18', NULL, 'John 1:45-51')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-08-25', 'Ordinary Time', '2 Thessalonians 2:1-3a, 14-17', 'Psalm 96:10, 11-12, 13', NULL, 'Matthew 23:23-26')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-08-26', 'Ordinary Time', '2 Thessalonians 3:6-10, 16-18', 'Psalm 128:1-2, 4-5', NULL, 'Matthew 23:27-32')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-08-27', 'Ordinary Time', '1 Corinthians 1:1-9', 'Psalm 145:2-3, 4-5, 6-7', NULL, 'Matthew 24:42-51')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-08-28', 'Ordinary Time', '1 Corinthians 1:17-25', 'Psalm 33:1-2, 4-5, 10-11', NULL, 'Matthew 25:1-13')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-08-29', 'Ordinary Time', '1 Corinthians 1:26-31', 'Psalm 33:12-13, 18-19, 20-21', NULL, 'Mark 6:17-29')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-08-30', 'Ordinary Time', 'Jeremiah 20:7-9', 'Psalm 63:2, 3-4, 5-6, 8-9', 'Romans 12:1-2', 'Matthew 16:21-27')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-08-31', 'Ordinary Time', '1 Corinthians 2:1-5', 'Psalm 119:97, 98, 99, 100, 101, 102', NULL, 'Luke 4:16-30')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-09-01', 'Ordinary Time', '1 Corinthians 2:10b-16', 'Psalm 145:8-9, 10-11, 12-13ab, 13cd-14', NULL, 'Luke 4:31-37')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-09-02', 'Ordinary Time', '1 Corinthians 3:1-9', 'Psalm 33:12-13, 14-15, 20-21', NULL, 'Luke 4:38-44')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-09-03', 'Ordinary Time', '1 Corinthians 3:18-23', 'Psalm 24:1bc-2, 3-4ab, 5-6', NULL, 'Luke 5:1-11')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-09-04', 'Ordinary Time', '1 Corinthians 4:1-5', 'Psalm 37:3-4, 5-6, 27-28, 39-40', NULL, 'Luke 5:33-39')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-09-05', 'Ordinary Time', '1 Corinthians 4:6b-15', 'Psalm 145:17-18, 19-20, 21', NULL, 'Luke 6:1-5')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-09-06', 'Ordinary Time', 'Ezekiel 33:7-9', 'Psalm 95:1-2, 6-7, 8-9', 'Romans 13:8-10', 'Matthew 18:15-20')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-09-07', 'Ordinary Time', '1 Corinthians 5:1-8', 'Psalm 5:5-6, 7, 12', NULL, 'Luke 6:6-11')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-09-08', 'Ordinary Time', 'Micah 5:1-4a', 'Psalm 13:6ab, 6c', NULL, 'Matthew 1:1-16, 18-23')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-09-09', 'Ordinary Time', '1 Corinthians 7:25-31', 'Psalm 45:11-12, 14-15, 16-17', NULL, 'Luke 6:20-26')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-09-10', 'Ordinary Time', '1 Corinthians 8:1b-7, 11-13', 'Psalm 139:1b-3, 13-14ab, 23-24', NULL, 'Luke 6:27-38')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-09-11', 'Ordinary Time', '1 Corinthians 9:16-19, 22b-27', 'Psalm 84:3, 4, 5-6, 12', NULL, 'Luke 6:39-42')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-09-12', 'Ordinary Time', '1 Corinthians 10:14-22', 'Psalm 116:12-13, 17-18', NULL, 'Luke 6:43-49')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-09-13', 'Ordinary Time', 'Sirach 27:30—28:7', 'Psalm 103:1-2, 3-4, 9-10, 11-12', 'Romans 14:7-9', 'Matthew 18:21-35')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-09-14', 'Ordinary Time', 'Numbers 21:4b-9', 'Psalm 78:1bc-2, 34-35, 36-37, 38', 'Philippians 2:6-11', 'John 3:13-17')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-09-15', 'Ordinary Time', '1 Corinthians 12:12-14, 27-31a', 'Psalm 100:1b-2, 3, 4, 5', NULL, 'John 19:25-27')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-09-16', 'Ordinary Time', '1 Corinthians 12:31-13:13', 'Psalm 33:2-3, 4-5, 12 and 22', NULL, 'Luke 7:31-35')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-09-17', 'Ordinary Time', '1 Corinthians 15:1-11', 'Psalm 118:1b-2, 16ab-17, 28', NULL, 'Luke 7:36-50')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-09-18', 'Ordinary Time', '1 Corinthians 15:12-20', 'Psalm 17:1bcd, 6-7, 8b, 15', NULL, 'Luke 8:1-3')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-09-19', 'Ordinary Time', '1 Corinthians 15:35-37, 42-49', 'Psalm 56:10c-12, 13-14', NULL, 'Luke 8:4-15')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-09-20', 'Ordinary Time', 'Isaiah 55:6-9', 'Psalm 145:2-3, 8-9, 17-18', 'Philippians 1:20c-24, 27a', 'Matthew 20:1-16a')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-09-21', 'Ordinary Time', 'Ephesians 4:1-7, 11-13', 'Psalm 19:2-3, 4-5', NULL, 'Matthew 9:9-13')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-09-22', 'Ordinary Time', 'Proverbs 21:1-6, 10-13', 'Psalm 119:1, 27, 30, 34, 35, 44', NULL, 'Luke 8:19-21')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-09-23', 'Ordinary Time', 'Proverbs 30:5-9', 'Psalm 119:29, 72, 89, 101, 104, 163', NULL, 'Luke 9:1-6')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-09-24', 'Ordinary Time', 'Ecclesiastes 1:2-11', 'Psalm 90:3-4, 5-6, 12-13, 14, 17bc', NULL, 'Luke 9:7-9')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-09-25', 'Ordinary Time', 'Ecclesiastes 3:1-11', 'Psalm 144:1b and 2abc, 3-4', NULL, 'Luke 9:18-22')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-09-26', 'Ordinary Time', 'Ecclesiastes 11:9—12:8', 'Psalm 90:3-4, 5-6, 12-13, 14 and 17', NULL, 'Luke 9:43b-45')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-09-27', 'Ordinary Time', 'Ezekiel 18:25-28', 'Psalm 25:4-5, 6-7, 8-9', 'Philippians 2:1-11', 'Matthew 21:28-32')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-09-28', 'Ordinary Time', 'Job 1:6-22', 'Psalm 17:1bcd, 2-3, 6-7', NULL, 'Luke 9:46-50')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-09-29', 'Ordinary Time', 'Daniel 7:9-10, 13-14', 'Psalm 138:1-2ab, 2cde-3, 4-5', NULL, 'John 1:47-51')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-09-30', 'Ordinary Time', 'Job 9:1-12, 14-16', 'Psalm 88:10bc-11, 12-13, 14-15', NULL, 'Luke 9:57-62')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-10-01', 'Ordinary Time', 'Job 19:21-27', 'Psalm 27:7-8a, 8b-9abc, 13-14', NULL, 'Luke 10:1-12')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-10-02', 'Ordinary Time', 'Job 38:1, 12-21; 40:3-5', 'Psalm 139:1-3, 7-8, 9-10, 13-14ab', NULL, 'Matthew 18:1-5, 10')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-10-03', 'Ordinary Time', 'Job 42:1-3, 5-6, 12-17', 'Psalm 119:66, 71, 75, 91, 125, 130', NULL, 'Luke 10:17-24')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-10-04', 'Ordinary Time', 'Isaiah 5:1-7', 'Psalm 80:9, 12, 13-14, 15-16, 19-20', 'Philippians 4:6-9', 'Matthew 21:33-43')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-10-05', 'Ordinary Time', 'Galatians 1:6-12', 'Psalm 111:1b-2, 7-8, 9, 10c', NULL, 'Luke 10:25-37')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-10-06', 'Ordinary Time', 'Galatians 1:13-24', 'Psalm 139:1b-3, 13-14ab, 14c-15', NULL, 'Luke 10:38-42')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-10-07', 'Ordinary Time', 'Galatians 2:1-2, 7-14', 'Psalm 117:1bc, 2', NULL, 'Luke 11:1-4')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-10-08', 'Ordinary Time', 'Galatians 3:1-5', 'Luke 1:69-70, 71-72, 73-75', NULL, 'Luke 11:5-13')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-10-09', 'Ordinary Time', 'Galatians 3:7-14', 'Psalm 111:1b-2, 3-4, 5-6', NULL, 'Luke 11:15-26')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-10-10', 'Ordinary Time', 'Galatians 3:22-29', 'Psalm 105:2-3, 4-5, 6-7', NULL, 'Luke 11:27-28')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-10-11', 'Ordinary Time', 'Isaiah 25:6-10a', 'Psalm 23:1-3a, 3b-4, 5, 6', 'Philippians 4:12-14, 19-20', 'Matthew 22:1-14')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-10-12', 'Ordinary Time', 'Galatians 4:22-24, 26-27, 31–5:1', 'Psalm 113:1b-2, 3-4, 5a, 6-7', NULL, 'Luke 11:29-32')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-10-13', 'Ordinary Time', 'Galatians 5:1-6', 'Psalm 119:41, 43, 44, 45, 47, 48', NULL, 'Luke 11:37-41')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-10-14', 'Ordinary Time', 'Galatians 5:18-25', 'Psalm 1:1-2, 3, 4, 6', NULL, 'Luke 11:42-46')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-10-15', 'Ordinary Time', 'Ephesians 1:1-10', 'Psalm 98:1, 2-3ab, 3cd-4, 5-6', NULL, 'Luke 11:47-54')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-10-16', 'Ordinary Time', 'Ephesians 1:11-14', 'Psalm 33:1-2, 4-5, 12-13', NULL, 'Luke 12:1-7')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-10-17', 'Ordinary Time', 'Ephesians 1:15-23', 'Psalm 8:2-3ab, 4-5, 6-7', NULL, 'Luke 12:8-12')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-10-18', 'Ordinary Time', 'Isaiah 45:1, 4-6', 'Psalm 96:1, 3, 4-5, 7-8, 9-10', '1 Thessalonians 1:1-5b', 'Matthew 22:15-21')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-10-19', 'Ordinary Time', 'Ephesians 2:1-10', 'Psalm 100:1b-2, 3, 4ab, 4c-5', NULL, 'Luke 12:13-21')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-10-20', 'Ordinary Time', 'Ephesians 2:12-22', 'Psalm 85:9ab-10, 11-12, 13-14', NULL, 'Luke 12:35-38')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-10-21', 'Ordinary Time', 'Ephesians 3:2-12', 'Isaiah 12:2-3, 4bcd, 5-6', NULL, 'Luke 12:39-48')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-10-22', 'Ordinary Time', 'Ephesians 3:14-21', 'Psalm 33:1-2, 4-5, 11-12, 18-19', NULL, 'Luke 12:49-53')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-10-23', 'Ordinary Time', 'Ephesians 4:1-6', 'Psalm 24:1-2, 3-4ab, 5-6', NULL, 'Luke 12:54-59')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-10-24', 'Ordinary Time', 'Ephesians 4:7-16', 'Psalm 122:1-2, 3-4ab, 4cd-5', NULL, 'Luke 13:1-9')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-10-25', 'Ordinary Time', 'Exodus 22:20-26', 'Psalm 18:2-3, 3-4, 47, 51', '1 Thessalonians 1:5c-10', 'Matthew 22:34-40')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-10-26', 'Ordinary Time', 'Ephesians 4:32–5:8', 'Psalm 1:1-2, 3, 4, 6', NULL, 'Luke 13:10-17')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-10-27', 'Ordinary Time', 'Ephesians 5:21-33', 'Psalm 128:1-2, 3, 4-5', NULL, 'Luke 13:18-21')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-10-28', 'Ordinary Time', 'Ephesians 2:19-22', 'Psalm 19:2-3, 4-5', NULL, 'Luke 6:12-16')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-10-29', 'Ordinary Time', 'Ephesians 6:10-20', 'Psalm 144:1b, 2, 9-10', NULL, 'Luke 13:31-35')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-10-30', 'Ordinary Time', 'Philippians 1:1-11', 'Psalm 111:1-2, 3-4, 5-6', NULL, 'Luke 14:1-6')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-10-31', 'Ordinary Time', 'Philippians 1:18b-26', 'Psalm 42:2, 3, 5cdef', NULL, 'Luke 14:1, 7-11')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-11-01', 'Ordinary Time', 'Revelation 7:2-4, 9-14', 'Psalm 24:1bc-2, 3-4ab, 5-6', '1 John 3:1-3', 'Matthew 5:1-12a')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-11-02', 'Ordinary Time', 'Wisdom 3:1-9', 'Psalm 23:1-3a, 3b-4, 5, 6', 'Romans 5:5-11', 'John 6:37-40')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-11-03', 'Ordinary Time', 'Philippians 2:5-11', 'Psalm 22:26b-27, 28-30ab, 30e, 31-32', NULL, 'Luke 14:15-24')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-11-04', 'Ordinary Time', 'Phiippians 2:12-18', 'Psalm 27:1, 4, 13-14', NULL, 'Luke 14:25-33')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-11-05', 'Ordinary Time', 'Philippians 3:3-8a', 'Psalm 105:2-3, 4-5, 6-7', NULL, 'Luke 15:1-10')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-11-06', 'Ordinary Time', 'Philippians 3:17—4:1', 'Psalm 122:1-2, 3-4ab, 4cd-5', NULL, 'Luke 16:1-8')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-11-07', 'Ordinary Time', 'Philippians 4:10-19', 'Psalm 112:1b-2, 5-6, 8a, 9', NULL, 'Luke 16:9-15')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-11-08', 'Ordinary Time', 'Wisdom 6:12-16', 'Psalm 63:2, 3-4, 5-6, 7-8', '1 Thessalonians 4:13-18', 'Matthew 25:1-13')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-11-09', 'Ordinary Time', 'Ezekiel 47:1-2, 8-9, 12', 'Psalm 46:2-3, 5-6, 8-9', '1 Corinthians 3:9c-11, 16-17', 'John 2:13-22')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-11-10', 'Ordinary Time', 'Titus 2:1-8, 11-14', 'Psalm 37:3-4, 18 and 23, 27 and 29', NULL, 'Luke 17:7-10')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-11-11', 'Ordinary Time', 'Titus 3:1-7', 'Psalm 23:1b-3a, 3bc-4, 5, 6', NULL, 'Luke 17:11-19')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-11-12', 'Ordinary Time', 'Philemon 7-20', 'Psalm 146:7, 8-9a, 9bc-10', NULL, 'Luke 17:20-25')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-11-13', 'Ordinary Time', '2 John 4-9', 'Psalm 119:1, 2, 10, 11, 17, 18', NULL, 'Luke 17:26-37')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-11-14', 'Ordinary Time', '3 John 5-8', 'Psalm 112:1-2, 3-4, 5-6', NULL, 'Luke 18:1-8')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-11-15', 'Ordinary Time', 'Proverbs 31:10-13, 19-20, 30-31', 'Psalm 128:1-2, 3, 4-5', '1 Thessalonians 5:1-6', 'Matthew 25:14-30')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-11-16', 'Ordinary Time', 'Revelation 1:1-4; 2:1-5', 'Psalm 1:1-2, 3, 4, 6', NULL, 'Luke 18:35-43')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-11-17', 'Ordinary Time', 'Revelation 3:1-6, 14-22', 'Psalm 15:2-3a, 3bc-4ab, 5', NULL, 'Luke 19:1-10')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-11-18', 'Ordinary Time', 'Revelation 4:1-11', 'Psalm 150:1b-2, 3-4, 5-6', NULL, 'Luke 19:11-28')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-11-19', 'Ordinary Time', 'Revelation 5:1-10', 'Psalm 149:1b-2, 3-4, 5-6b, 9b', NULL, 'Luke 19:41-44')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-11-20', 'Ordinary Time', 'Revelation 10:8-11', 'Psalm 119:14, 24, 72, 103, 111, 131', NULL, 'Luke 19:45-48')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-11-21', 'Ordinary Time', NULL, 'Psalm 144:1, 2, 9-10', NULL, 'Luke 20:27-40')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-11-22', 'Ordinary Time', 'Ezekiel 34:11-12, 15-17', 'Psalm 23:1-2, 2-3, 5-6', '1 Corinthians 15:20-26, 28', 'Matthew 25:31-46')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-11-23', 'Ordinary Time', 'Revelation 14:1-3, 4b-5', 'Psalm 24:1bc-2, 3-4ab, 5-6', NULL, 'Luke 21:1-4')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-11-24', 'Ordinary Time', 'Revelation 14:14-19', 'Psalm 96:10, 11-12, 13', NULL, 'Luke 21:5-11')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-11-25', 'Ordinary Time', 'Revelation 15:1-4', 'Psalm 98:1, 2-3ab, 7-8, 9', NULL, 'Luke 21:12-19')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-11-26', 'Ordinary Time', 'Sirach 50:22-24', 'Psalm 145:2-3, 4-5, 6-7, 8-9, 10-11', '1 Corinthians 1:3-9', 'Luke 17:11-19')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-11-27', 'Ordinary Time', 'Revelation 20:1-4, 11—21:2', 'Psalm 84:3, 4, 5-6a, 8a', NULL, 'Luke 21:29-33')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-11-28', 'Ordinary Time', 'Revelation 22:1-7', 'Psalm 95:1-2, 3-5, 6-7ab', NULL, 'Luke 21:34-36')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-11-29', 'Advent', NULL, 'Psalm 80:2-3, 15-16, 18-19', '1 Corinthians 1:3-9', 'Mark 13:33-37')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-11-30', 'Advent', 'Romans 10:9-18', 'Psalm 19:8, 9, 10, 11', NULL, 'Matthew 4:18-22')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-12-01', 'Advent', 'Isaiah 11:1-10', 'Psalm 72:1-2, 7-8, 12-13, 17', NULL, 'Luke 10:21-24')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-12-02', 'Advent', 'Isaiah 25:6-10a', 'Psalm 23:1-3a, 3b-4, 5, 6', NULL, 'Matthew 15:29-37')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-12-03', 'Advent', 'Isaiah 26:1-6', 'Psalm 118:1 and 8-9, 19-21, 25-27a', NULL, 'Matthew 7:21, 24-27')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-12-04', 'Advent', 'Isaiah 29:17-24', 'Psalm 27:1, 4, 13-14', NULL, 'Matthew 9:27-31')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-12-05', 'Advent', 'Isaiah 30:19-21, 23-26', 'Psalm 147:1-2, 3-4, 5-6', NULL, 'Matthew 9:35–10:1, 5a, 6-8')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-12-06', 'Advent', 'Isaiah 40:1-5, 9-11', 'Psalm 85:9-10-11-12, 13-14', '2 Peter 3:8-14', 'Mark 1:1-8')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-12-07', 'Advent', 'Isaiah 35:1-10', 'Psalm 85:9ab and 10, 11-12, 13-14', NULL, 'Luke 5:17-26')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-12-08', 'Advent', 'Genesis 3:9-15, 20', 'Psalm 98:1, 2-3ab, 3cd-4', 'Ephesians 1:3-6, 11-12', 'Luke 1:26-38')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-12-09', 'Advent', 'Isaiah 40:25-31', 'Psalm 103:1-2, 3-4, 8 and 10', NULL, 'Matthew 11:28-30')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-12-10', 'Advent', 'Isaiah 41:13-20', 'Psalm 145:1 and 9, 10-11, 12-13ab', NULL, 'Matthew 11:11-15')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-12-11', 'Advent', 'Isaiah 48:17-19', 'Psalm 1:1-2, 3, 4 and 6', NULL, 'Matthew 11:16-19')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-12-12', 'Advent', 'Zechariah 2:14-17', 'Judith 13:18bcde, 19', NULL, 'Luke 1:26-38')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-12-13', 'Advent', 'Isaiah 61:1-2a, 10-11', 'Luke 1:46-48, 49-50, 53-54', '1 Thessalonians 5:16-24', 'John 1:6-8, 19-28')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-12-14', 'Advent', 'Numbers 24:2-7, 15-17a', 'Psalm 25:4-5ab, 6 and 7bc, 8-9', NULL, 'Matthew 21:23-27')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-12-15', 'Advent', 'Zephaniah 3:1-2, 9-13', 'Psalm 34:2-3, 6-7, 17-18, 19 and 23', NULL, 'Matthew 21:28-32')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-12-16', 'Advent', 'Isaiah 45:6c-8, 18, 21c-25', 'Psalm 85:9ab, 10, 11-12, 13-14', NULL, 'Luke 7:18b-23')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-12-17', 'Advent', 'Genesis 49:2, 8-10', 'Psalm 72:1-2, 3-4ab, 7-8, 17', NULL, 'Matthew 1:1-17')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-12-18', 'Advent', 'Jeremiah 23:5-8', 'Psalm 72:1-2, 12-13, 18-19', NULL, 'Matthew 1:18-25')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-12-19', 'Advent', 'Judges 13:2-7, 24-25a', 'Psalm 71:3-4a, 5-6ab, 16-17', NULL, 'Luke 1:5-25')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-12-20', 'Advent', '2 Samuel 7:1-5, 8b-12, 14a, 16', 'Psalm 89:2-3, 4-5, 27, 29', 'Romans 16:25-27', 'Luke 1:26-38')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-12-21', 'Advent', 'Song of Songs 2:8-14', 'Psalm 33:2-3, 11-12, 20-21', NULL, 'Luke 1:39-45')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-12-22', 'Advent', '1 Samuel 1:24-28', '1 Samuel 2:1, 4-5, 6-7, 8abcd', NULL, 'Luke 1:46-56')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-12-23', 'Advent', 'Malachi 3:1-4, 23-24', 'Psalm 25:4-5ab, 8-9, 10 and 14', NULL, 'Luke 1:57-66')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-12-24', 'Advent', '2 Samuel 7:1-5, 8b-12, 14a, 16', 'Psalm 89:2-3, 4-5, 27 and 29', NULL, 'Luke 1:67-79')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-12-25', 'Christmas', 'Isaiah 52:7-10', 'Psalm 98:1, 2-3, 3-4, 5-6.', 'Hebrews 1:1-6', 'John 1:1-18')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-12-26', 'Christmas', 'Acts 6:8-10; 7:54-59', 'Psalm 31:3cd-4, 6 and 8ab, 16bc and 17', NULL, 'Matthew 10:17-22')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-12-27', 'Christmas', 'Sirach 3:2-6, 12-14', 'Psalm 128:1-2, 3, 4-5.', 'Colossians 3:12-21', 'Luke 2:22-40')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-12-28', 'Christmas', '1 John 1:5—2:2', 'Psalm 124:2-3, 4-5, 7cd-8', NULL, 'Matthew 2:13-18')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-12-29', 'Christmas', '1 John 2:3-11', 'Psalm 96:1-2a, 2b-3, 5b-6', NULL, 'Luke 2:22-35')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-12-30', 'Christmas', '1 John 2:12-17', 'Psalm 96:7-8a, 8b-9, 10', NULL, 'Luke 2:36-40')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;

INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('2026-12-31', 'Christmas', '1 John 2:18-21', 'Psalm 96:1-2, 11-12, 13', NULL, 'John 1:1-18')
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;
