/**
 * Script para importar el calendario litúrgico católico desde GitHub
 * Fuente: https://github.com/cpbjr/catholic-readings-api
 *
 * Uso: node scripts/import_liturgical_readings.js [año]
 * Ejemplo: node scripts/import_liturgical_readings.js 2026
 *
 * Genera: supabase/migrations/liturgical_data/liturgical_readings_YYYY.sql
 */

const fs = require('fs');
const path = require('path');

const GITHUB_API_BASE = 'https://api.github.com/repos/cpbjr/catholic-readings-api/contents/readings';
const GITHUB_RAW_BASE = 'https://raw.githubusercontent.com/cpbjr/catholic-readings-api/main/readings';

async function fetchWithRetry(url, retries = 3) {
  for (let i = 0; i < retries; i++) {
    try {
      const response = await fetch(url);
      if (!response.ok) {
        throw new Error(`HTTP ${response.status}: ${response.statusText}`);
      }
      return await response.json();
    } catch (error) {
      console.error(`  Intento ${i + 1}/${retries} fallido: ${error.message}`);
      if (i === retries - 1) throw error;
      await new Promise(r => setTimeout(r, 1000 * (i + 1))); // Backoff
    }
  }
}

async function getFileList(year) {
  console.log(`\nObteniendo lista de archivos para ${year}...`);
  const url = `${GITHUB_API_BASE}/${year}`;
  const files = await fetchWithRetry(url);

  // Filtrar solo archivos JSON
  const jsonFiles = files
    .filter(f => f.name.endsWith('.json'))
    .map(f => f.name);

  console.log(`  Encontrados ${jsonFiles.length} archivos JSON`);
  return jsonFiles;
}

async function downloadReading(year, filename) {
  const url = `${GITHUB_RAW_BASE}/${year}/${filename}`;
  return await fetchWithRetry(url);
}

function escapeSQL(str) {
  if (!str) return 'NULL';
  return `'${str.replace(/'/g, "''")}'`;
}

function generateInsertSQL(reading) {
  const date = reading.date;
  const season = escapeSQL(reading.season);
  const firstReading = escapeSQL(reading.readings?.firstReading);
  const psalm = escapeSQL(reading.readings?.psalm);
  const secondReading = escapeSQL(reading.readings?.secondReading);
  const gospel = escapeSQL(reading.readings?.gospel);

  return `INSERT INTO liturgical_readings (reading_date, season, first_reading, psalm, second_reading, gospel)
VALUES ('${date}', ${season}, ${firstReading}, ${psalm}, ${secondReading}, ${gospel})
ON CONFLICT (reading_date) DO UPDATE SET
  season = EXCLUDED.season,
  first_reading = EXCLUDED.first_reading,
  psalm = EXCLUDED.psalm,
  second_reading = EXCLUDED.second_reading,
  gospel = EXCLUDED.gospel;`;
}

async function importYear(year) {
  console.log(`\n${'='.repeat(60)}`);
  console.log(`Importando calendario litúrgico para ${year}`);
  console.log(`${'='.repeat(60)}`);

  // Obtener lista de archivos
  const files = await getFileList(year);

  if (files.length === 0) {
    console.error(`No se encontraron archivos para ${year}`);
    return;
  }

  // Descargar cada archivo y generar SQL
  const sqlStatements = [];
  let successCount = 0;
  let errorCount = 0;

  for (let i = 0; i < files.length; i++) {
    const filename = files[i];
    process.stdout.write(`\r  Descargando ${i + 1}/${files.length}: ${filename}...`);

    try {
      const reading = await downloadReading(year, filename);

      if (reading.readings?.gospel) {
        sqlStatements.push(generateInsertSQL(reading));
        successCount++;
      } else {
        console.warn(`\n  ⚠️ ${filename}: No tiene evangelio`);
        errorCount++;
      }

      // Rate limiting para no saturar GitHub
      if (i % 10 === 0) {
        await new Promise(r => setTimeout(r, 100));
      }
    } catch (error) {
      console.error(`\n  ❌ Error en ${filename}: ${error.message}`);
      errorCount++;
    }
  }

  console.log(`\n\nResumen: ${successCount} lecturas importadas, ${errorCount} errores`);

  // Crear directorio si no existe
  const outputDir = path.join(__dirname, '..', 'supabase', 'migrations', 'liturgical_data');
  if (!fs.existsSync(outputDir)) {
    fs.mkdirSync(outputDir, { recursive: true });
  }

  // Escribir archivo SQL
  const outputFile = path.join(outputDir, `liturgical_readings_${year}.sql`);
  const sqlContent = `-- Calendario litúrgico católico ${year}
-- Fuente: https://github.com/cpbjr/catholic-readings-api
-- Generado: ${new Date().toISOString()}
-- Total: ${successCount} lecturas

${sqlStatements.join('\n\n')}
`;

  fs.writeFileSync(outputFile, sqlContent);
  console.log(`\n✅ SQL guardado en: ${outputFile}`);
  console.log(`   Tamaño: ${(fs.statSync(outputFile).size / 1024).toFixed(1)} KB`);

  return { success: successCount, errors: errorCount };
}

async function main() {
  const args = process.argv.slice(2);
  const year = args[0] || new Date().getFullYear().toString();

  console.log('='.repeat(60));
  console.log('Importador de Calendario Litúrgico Católico');
  console.log('Fuente: cpbjr/catholic-readings-api');
  console.log('='.repeat(60));

  try {
    const result = await importYear(year);

    if (result) {
      console.log('\n' + '='.repeat(60));
      console.log('SIGUIENTE PASO:');
      console.log(`  1. Ejecutar la migración 00024 primero (crear tabla)`);
      console.log(`  2. Luego ejecutar el SQL generado en Supabase SQL Editor:`);
      console.log(`     supabase/migrations/liturgical_data/liturgical_readings_${year}.sql`);
      console.log('='.repeat(60));
    }
  } catch (error) {
    console.error('\n❌ Error fatal:', error.message);
    process.exit(1);
  }
}

main();
