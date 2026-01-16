#!/usr/bin/env node
/**
 * Splits the large bible_verses SQL file into smaller chunks by book
 * Each chunk can be run separately in Supabase SQL Editor
 */

const fs = require('fs');
const path = require('path');

const inputFile = path.join(__dirname, '../supabase/migrations/00024_seed_bible_verses.sql');
const outputDir = path.join(__dirname, '../supabase/migrations/bible_chunks');

// Read the full SQL file
const content = fs.readFileSync(inputFile, 'utf8');
const lines = content.split('\n');

let currentBook = null;
let currentLines = [];
let bookIndex = 0;

// Group books into chunks (roughly 5-7 books per chunk to stay under size limits)
const bookGroups = [
  // Old Testament - Part 1 (Genesis to Deuteronomy) - Pentateuch
  ['GEN', 'EXO', 'LEV', 'NUM', 'DEU'],
  // Old Testament - Part 2 (Joshua to 2 Samuel) - Historical
  ['JOS', 'JDG', 'RUT', '1SA', '2SA'],
  // Old Testament - Part 3 (1 Kings to Esther) - Historical
  ['1KI', '2KI', '1CH', '2CH', 'EZR', 'NEH', 'EST'],
  // Old Testament - Part 4 (Job to Song of Solomon) - Wisdom
  ['JOB', 'PSA', 'PRO', 'ECC', 'SNG'],
  // Old Testament - Part 5 (Isaiah to Daniel) - Major Prophets
  ['ISA', 'JER', 'LAM', 'EZK', 'DAN'],
  // Old Testament - Part 6 (Hosea to Malachi) - Minor Prophets
  ['HOS', 'JOL', 'AMO', 'OBA', 'JON', 'MIC', 'NAM', 'HAB', 'ZEP', 'HAG', 'ZEC', 'MAL'],
  // New Testament - Part 1 (Gospels)
  ['MAT', 'MRK', 'LUK', 'JHN'],
  // New Testament - Part 2 (Acts and Paul's letters part 1)
  ['ACT', 'ROM', '1CO', '2CO', 'GAL', 'EPH'],
  // New Testament - Part 3 (Paul's letters part 2 and General letters)
  ['PHP', 'COL', '1TH', '2TH', '1TI', '2TI', 'TIT', 'PHM', 'HEB'],
  // New Testament - Part 4 (General letters and Revelation)
  ['JAS', '1PE', '2PE', '1JN', '2JN', '3JN', 'JUD', 'REV'],
];

// Create a map from book code to group index
const bookToGroup = {};
bookGroups.forEach((group, groupIndex) => {
  group.forEach(book => {
    bookToGroup[book] = groupIndex;
  });
});

// Initialize arrays for each group
const groupLines = bookGroups.map(() => []);
let currentGroupIndex = -1;

// Process each line
for (const line of lines) {
  // Check if this is a book header comment like "-- Génesis (GEN)"
  const bookMatch = line.match(/^-- .+ \(([A-Z0-9]+)\)$/);

  if (bookMatch) {
    const bookCode = bookMatch[1];
    currentGroupIndex = bookToGroup[bookCode];
    if (currentGroupIndex !== undefined) {
      groupLines[currentGroupIndex].push(line);
    }
  } else if (line.startsWith('INSERT INTO bible_verses') && currentGroupIndex !== -1) {
    groupLines[currentGroupIndex].push(line);
  }
  // Skip BEGIN, COMMIT, and comment lines at the start/end
}

// Write each group to a file
const groupNames = [
  '01_pentateuco_genesis_deuteronomio',
  '02_historicos_josue_2samuel',
  '03_historicos_1reyes_ester',
  '04_sapienciales_job_cantares',
  '05_profetas_mayores_isaias_daniel',
  '06_profetas_menores_oseas_malaquias',
  '07_evangelios_mateo_juan',
  '08_hechos_efesios',
  '09_filipenses_hebreos',
  '10_santiago_apocalipsis',
];

groupLines.forEach((lines, index) => {
  if (lines.length === 0) return;

  const fileName = `${groupNames[index]}.sql`;
  const filePath = path.join(outputDir, fileName);

  // Count verses (INSERT statements)
  const verseCount = lines.filter(l => l.startsWith('INSERT')).length;

  const content = `-- Biblia Reina Valera 1909 - Parte ${index + 1} de ${groupNames.length}
-- ${verseCount} versículos
-- Ejecutar en Supabase SQL Editor

${lines.join('\n')}
`;

  fs.writeFileSync(filePath, content);
  console.log(`Created ${fileName} (${verseCount} verses, ${Math.round(content.length / 1024)} KB)`);
});

console.log('\nDone! Files created in supabase/migrations/bible_chunks/');
console.log('Run them in order (01, 02, 03...) in Supabase SQL Editor');
