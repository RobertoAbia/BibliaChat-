#!/usr/bin/env node
/**
 * Script to import ONLY the missing Bible books into Supabase
 */

const https = require('https');

const BIBLE_URL = 'https://raw.githubusercontent.com/thiagobodruk/bible/master/json/es_rvr.json';

// Books that ARE in the database (from the query)
const EXISTING_BOOKS = new Set([
  '1CO', '1JN', '1PE', '1SA', '1TH', '1TI', '2CO', '2JN', '2PE', '2SA', '2TH', '2TI', '3JN',
  'AMO', 'COL', 'DAN', 'DEU', 'ECC', 'EST', 'EXO', 'EZK', 'GAL', 'GEN', 'HEB', 'ISA',
  'JDG', 'JER', 'JHN', 'JOB', 'JOL', 'JON', 'JOS', 'JUD', 'LAM', 'LEV', 'MAL', 'MAT',
  'NAM', 'NEH', 'NUM', 'OBA', 'REV', 'ROM', 'RUT', 'TIT', 'ZEC'
]);

// Full mapping from source abbreviations to standard codes
// Abbreviations verified from: https://raw.githubusercontent.com/thiagobodruk/bible/master/json/es_rvr.json
const BOOK_MAPPING = {
  'gn': { id: 'GEN', name: 'Génesis' },
  'ex': { id: 'EXO', name: 'Éxodo' },
  'lv': { id: 'LEV', name: 'Levítico' },
  'nm': { id: 'NUM', name: 'Números' },
  'dt': { id: 'DEU', name: 'Deuteronomio' },
  'js': { id: 'JOS', name: 'Josué' },
  'jud': { id: 'JDG', name: 'Jueces' },
  'rt': { id: 'RUT', name: 'Rut' },
  '1sm': { id: '1SA', name: '1 Samuel' },
  '2sm': { id: '2SA', name: '2 Samuel' },
  '1kgs': { id: '1KI', name: '1 Reyes' },
  '2kgs': { id: '2KI', name: '2 Reyes' },
  '1ch': { id: '1CH', name: '1 Crónicas' },
  '2ch': { id: '2CH', name: '2 Crónicas' },
  'ezr': { id: 'EZR', name: 'Esdras' },
  'ne': { id: 'NEH', name: 'Nehemías' },
  'et': { id: 'EST', name: 'Ester' },
  'job': { id: 'JOB', name: 'Job' },
  'ps': { id: 'PSA', name: 'Salmos' },
  'prv': { id: 'PRO', name: 'Proverbios' },
  'ec': { id: 'ECC', name: 'Eclesiastés' },
  'so': { id: 'SNG', name: 'Cantares' },
  'is': { id: 'ISA', name: 'Isaías' },
  'jr': { id: 'JER', name: 'Jeremías' },
  'lm': { id: 'LAM', name: 'Lamentaciones' },
  'ez': { id: 'EZK', name: 'Ezequiel' },
  'dn': { id: 'DAN', name: 'Daniel' },
  'ho': { id: 'HOS', name: 'Oseas' },
  'jl': { id: 'JOL', name: 'Joel' },
  'am': { id: 'AMO', name: 'Amós' },
  'ob': { id: 'OBA', name: 'Abdías' },
  'jn': { id: 'JON', name: 'Jonás' },
  'mi': { id: 'MIC', name: 'Miqueas' },
  'na': { id: 'NAM', name: 'Nahúm' },
  'hk': { id: 'HAB', name: 'Habacuc' },
  'zp': { id: 'ZEP', name: 'Sofonías' },
  'hg': { id: 'HAG', name: 'Hageo' },
  'zc': { id: 'ZEC', name: 'Zacarías' },
  'ml': { id: 'MAL', name: 'Malaquías' },
  'mt': { id: 'MAT', name: 'Mateo' },
  'mk': { id: 'MRK', name: 'Marcos' },
  'lk': { id: 'LUK', name: 'Lucas' },
  'jo': { id: 'JHN', name: 'Juan' },
  'act': { id: 'ACT', name: 'Hechos' },
  'rm': { id: 'ROM', name: 'Romanos' },
  '1co': { id: '1CO', name: '1 Corintios' },
  '2co': { id: '2CO', name: '2 Corintios' },
  'gl': { id: 'GAL', name: 'Gálatas' },
  'eph': { id: 'EPH', name: 'Efesios' },
  'ph': { id: 'PHP', name: 'Filipenses' },
  'cl': { id: 'COL', name: 'Colosenses' },
  '1ts': { id: '1TH', name: '1 Tesalonicenses' },
  '2ts': { id: '2TH', name: '2 Tesalonicenses' },
  '1tm': { id: '1TI', name: '1 Timoteo' },
  '2tm': { id: '2TI', name: '2 Timoteo' },
  'tt': { id: 'TIT', name: 'Tito' },
  'phm': { id: 'PHM', name: 'Filemón' },
  'hb': { id: 'HEB', name: 'Hebreos' },
  'jm': { id: 'JAS', name: 'Santiago' },
  '1pe': { id: '1PE', name: '1 Pedro' },
  '2pe': { id: '2PE', name: '2 Pedro' },
  '1jo': { id: '1JN', name: '1 Juan' },
  '2jo': { id: '2JN', name: '2 Juan' },
  '3jo': { id: '3JN', name: '3 Juan' },
  'jd': { id: 'JUD', name: 'Judas' },
  're': { id: 'REV', name: 'Apocalipsis' }
};

function fetchJSON(url) {
  return new Promise((resolve, reject) => {
    https.get(url, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        try {
          if (data.charCodeAt(0) === 0xFEFF) {
            data = data.slice(1);
          }
          resolve(JSON.parse(data));
        } catch (e) {
          reject(e);
        }
      });
    }).on('error', reject);
  });
}

function escapeSQL(str) {
  return str.replace(/'/g, "''");
}

async function main() {
  console.error('Downloading Bible JSON...');
  const books = await fetchJSON(BIBLE_URL);

  let totalVerses = 0;
  const missingBooks = [];

  console.log('-- Libros faltantes de la Biblia Reina Valera 1909');
  console.log('-- Ejecutar en Supabase SQL Editor');
  console.log('');

  for (const book of books) {
    const abbrev = book.abbrev.toLowerCase();
    const mapping = BOOK_MAPPING[abbrev];

    if (!mapping) {
      console.error(`WARNING: Unknown book abbreviation: ${abbrev}`);
      continue;
    }

    const bookId = mapping.id;
    const bookName = mapping.name;

    // Skip books that already exist
    if (EXISTING_BOOKS.has(bookId)) {
      continue;
    }

    missingBooks.push(bookName);
    console.log(`-- ${bookName} (${bookId})`);

    for (let chapterIdx = 0; chapterIdx < book.chapters.length; chapterIdx++) {
      const chapter = book.chapters[chapterIdx];
      const chapterNum = chapterIdx + 1;

      for (let verseIdx = 0; verseIdx < chapter.length; verseIdx++) {
        const verseText = chapter[verseIdx];
        const verseNum = verseIdx + 1;

        if (!verseText || verseText.trim() === '') {
          continue;
        }

        const sql = `INSERT INTO bible_verses (book_id, book_name, chapter, verse, text) VALUES ('${bookId}', '${escapeSQL(bookName)}', ${chapterNum}, ${verseNum}, '${escapeSQL(verseText.trim())}');`;
        console.log(sql);
        totalVerses++;
      }
    }
    console.log('');
  }

  console.log(`-- Total versículos faltantes: ${totalVerses}`);
  console.error(`\nLibros faltantes encontrados: ${missingBooks.join(', ')}`);
  console.error(`Total versículos: ${totalVerses}`);
}

main().catch(err => {
  console.error('Error:', err);
  process.exit(1);
});
