// Edge Function: fetch-daily-gospel
// Se ejecuta diariamente via cron para obtener el Evangelio del día
// 1. Consulta Catholic Readings API → referencia del día
// 2. Consulta API.Bible → texto en español
// 3. Genera resumen coloquial con OpenAI
// 4. Guarda en daily_verses + daily_verse_texts

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

// Mapeo de libros en inglés a español y formato API.Bible
const bookMapping: Record<string, { spanish: string; apiId: string }> = {
  "Genesis": { spanish: "Génesis", apiId: "GEN" },
  "Exodus": { spanish: "Éxodo", apiId: "EXO" },
  "Leviticus": { spanish: "Levítico", apiId: "LEV" },
  "Numbers": { spanish: "Números", apiId: "NUM" },
  "Deuteronomy": { spanish: "Deuteronomio", apiId: "DEU" },
  "Joshua": { spanish: "Josué", apiId: "JOS" },
  "Judges": { spanish: "Jueces", apiId: "JDG" },
  "Ruth": { spanish: "Rut", apiId: "RUT" },
  "1 Samuel": { spanish: "1 Samuel", apiId: "1SA" },
  "2 Samuel": { spanish: "2 Samuel", apiId: "2SA" },
  "1 Kings": { spanish: "1 Reyes", apiId: "1KI" },
  "2 Kings": { spanish: "2 Reyes", apiId: "2KI" },
  "1 Chronicles": { spanish: "1 Crónicas", apiId: "1CH" },
  "2 Chronicles": { spanish: "2 Crónicas", apiId: "2CH" },
  "Ezra": { spanish: "Esdras", apiId: "EZR" },
  "Nehemiah": { spanish: "Nehemías", apiId: "NEH" },
  "Esther": { spanish: "Ester", apiId: "EST" },
  "Job": { spanish: "Job", apiId: "JOB" },
  "Psalm": { spanish: "Salmos", apiId: "PSA" },
  "Psalms": { spanish: "Salmos", apiId: "PSA" },
  "Proverbs": { spanish: "Proverbios", apiId: "PRO" },
  "Ecclesiastes": { spanish: "Eclesiastés", apiId: "ECC" },
  "Song of Solomon": { spanish: "Cantares", apiId: "SNG" },
  "Isaiah": { spanish: "Isaías", apiId: "ISA" },
  "Jeremiah": { spanish: "Jeremías", apiId: "JER" },
  "Lamentations": { spanish: "Lamentaciones", apiId: "LAM" },
  "Ezekiel": { spanish: "Ezequiel", apiId: "EZK" },
  "Daniel": { spanish: "Daniel", apiId: "DAN" },
  "Hosea": { spanish: "Oseas", apiId: "HOS" },
  "Joel": { spanish: "Joel", apiId: "JOL" },
  "Amos": { spanish: "Amós", apiId: "AMO" },
  "Obadiah": { spanish: "Abdías", apiId: "OBA" },
  "Jonah": { spanish: "Jonás", apiId: "JON" },
  "Micah": { spanish: "Miqueas", apiId: "MIC" },
  "Nahum": { spanish: "Nahúm", apiId: "NAM" },
  "Habakkuk": { spanish: "Habacuc", apiId: "HAB" },
  "Zephaniah": { spanish: "Sofonías", apiId: "ZEP" },
  "Haggai": { spanish: "Hageo", apiId: "HAG" },
  "Zechariah": { spanish: "Zacarías", apiId: "ZEC" },
  "Malachi": { spanish: "Malaquías", apiId: "MAL" },
  "Matthew": { spanish: "Mateo", apiId: "MAT" },
  "Mark": { spanish: "Marcos", apiId: "MRK" },
  "Luke": { spanish: "Lucas", apiId: "LUK" },
  "John": { spanish: "Juan", apiId: "JHN" },
  "Acts": { spanish: "Hechos", apiId: "ACT" },
  "Romans": { spanish: "Romanos", apiId: "ROM" },
  "1 Corinthians": { spanish: "1 Corintios", apiId: "1CO" },
  "2 Corinthians": { spanish: "2 Corintios", apiId: "2CO" },
  "Galatians": { spanish: "Gálatas", apiId: "GAL" },
  "Ephesians": { spanish: "Efesios", apiId: "EPH" },
  "Philippians": { spanish: "Filipenses", apiId: "PHP" },
  "Colossians": { spanish: "Colosenses", apiId: "COL" },
  "1 Thessalonians": { spanish: "1 Tesalonicenses", apiId: "1TH" },
  "2 Thessalonians": { spanish: "2 Tesalonicenses", apiId: "2TH" },
  "1 Timothy": { spanish: "1 Timoteo", apiId: "1TI" },
  "2 Timothy": { spanish: "2 Timoteo", apiId: "2TI" },
  "Titus": { spanish: "Tito", apiId: "TIT" },
  "Philemon": { spanish: "Filemón", apiId: "PHM" },
  "Hebrews": { spanish: "Hebreos", apiId: "HEB" },
  "James": { spanish: "Santiago", apiId: "JAS" },
  "1 Peter": { spanish: "1 Pedro", apiId: "1PE" },
  "2 Peter": { spanish: "2 Pedro", apiId: "2PE" },
  "1 John": { spanish: "1 Juan", apiId: "1JN" },
  "2 John": { spanish: "2 Juan", apiId: "2JN" },
  "3 John": { spanish: "3 Juan", apiId: "3JN" },
  "Jude": { spanish: "Judas", apiId: "JUD" },
  "Revelation": { spanish: "Apocalipsis", apiId: "REV" },
};

// IDs de Biblias en español de API.Bible (plan gratuito)
// Endpoint: https://rest.api.bible
const BIBLE_VERSIONS: Record<string, string> = {
  "RVR1909": "592420522e16049f-01",  // Reina Valera 1909 (única versión completa gratuita)
  "RVR1960": "592420522e16049f-01",  // Fallback a RVR1909 (no hay RVR1960 gratis)
  "BES": "b32b9d1b64b4ef29-01",      // La Biblia en Español Sencillo
  "VBL": "482ddd53705278cc-02",      // Versión Biblia Libre
};

interface CatholicReadingsResponse {
  date: string;
  season?: string;
  readings: {
    firstReading?: string;
    psalm?: string;
    secondReading?: string;
    gospel: string;
  };
}

interface ApiBiblePassage {
  id: string;
  reference: string;
  content: string;
}

// Parsea referencia como "Luke 1:57-66" a formato estructurado
function parseReference(reference: string): { book: string; chapter: number; verses: string } | null {
  // Patrones comunes: "Luke 1:57-66", "Matthew 2:1-12", "John 3:16"
  const match = reference.match(/^(\d?\s?[A-Za-z]+)\s+(\d+):(.+)$/);
  if (!match) return null;

  return {
    book: match[1].trim(),
    chapter: parseInt(match[2]),
    verses: match[3],
  };
}

// Convierte referencia a formato API.Bible (ej: "LUK.1.57-LUK.1.66")
function toApiBibleFormat(reference: string): string | null {
  const parsed = parseReference(reference);
  if (!parsed) return null;

  const bookInfo = bookMapping[parsed.book];
  if (!bookInfo) return null;

  // Manejar rangos de versículos: "57-66" -> "LUK.1.57-LUK.1.66"
  const verseRange = parsed.verses;
  if (verseRange.includes("-")) {
    const [startVerse, endVerse] = verseRange.split("-");
    return `${bookInfo.apiId}.${parsed.chapter}.${startVerse}-${bookInfo.apiId}.${parsed.chapter}.${endVerse}`;
  }

  // Versículo único: "LUK.1.57"
  return `${bookInfo.apiId}.${parsed.chapter}.${verseRange}`;
}

// Convierte referencia en inglés a español
function toSpanishReference(reference: string): string {
  const parsed = parseReference(reference);
  if (!parsed) return reference;

  const bookInfo = bookMapping[parsed.book];
  if (!bookInfo) return reference;

  return `${bookInfo.spanish} ${parsed.chapter}:${parsed.verses}`;
}

// Obtiene la fecha en formato MM-DD
function getDateString(date: Date): string {
  const month = String(date.getMonth() + 1).padStart(2, "0");
  const day = String(date.getDate()).padStart(2, "0");
  return `${month}-${day}`;
}

// Obtiene las lecturas del Catholic Readings API
async function fetchCatholicReadings(date: Date): Promise<CatholicReadingsResponse | null> {
  const year = date.getFullYear();
  const dateStr = getDateString(date);
  const url = `https://cpbjr.github.io/catholic-readings-api/readings/${year}/${dateStr}.json`;

  try {
    const response = await fetch(url);
    if (!response.ok) {
      console.error(`Catholic Readings API error: ${response.status}`);
      return null;
    }
    return await response.json();
  } catch (error) {
    console.error("Error fetching Catholic readings:", error);
    return null;
  }
}

// Obtiene el texto de un pasaje de API.Bible usando el endpoint de verses
async function fetchBiblePassage(
  passageId: string,
  bibleId: string,
  apiKey: string
): Promise<ApiBiblePassage | null> {
  // Usar endpoint de verses con content-type=text para obtener texto limpio
  const url = `https://rest.api.bible/v1/bibles/${bibleId}/verses/${passageId}?content-type=text`;

  try {
    const response = await fetch(url, {
      headers: {
        "api-key": apiKey,
      },
    });

    if (!response.ok) {
      console.error(`API.Bible error: ${response.status}`);
      return null;
    }

    const data = await response.json();
    return data.data;
  } catch (error) {
    console.error("Error fetching Bible passage:", error);
    return null;
  }
}

// Limpia el contenido de API.Bible (remueve números de versículos y normaliza espacios)
function cleanContent(content: string): string {
  return content
    .replace(/<[^>]*>/g, "")        // Remove HTML tags (por si acaso)
    .replace(/\[\d+\]\s*/g, "")     // Remove verse numbers like [57]
    .replace(/\s+/g, " ")           // Normalize whitespace
    .trim();
}

// Genera un resumen coloquial del evangelio usando OpenAI
async function generateSummary(
  gospelText: string,
  reference: string,
  openaiKey: string
): Promise<string | null> {
  const prompt = `Eres un comunicador cristiano moderno que hace accesible la Biblia a jóvenes hispanohablantes.

Resume el siguiente pasaje del evangelio en 2-3 frases usando lenguaje coloquial, cercano y fácil de entender.
- Usa un tono como si se lo explicaras a un amigo
- Evita lenguaje religioso formal o anticuado
- Mantén el mensaje espiritual pero hazlo relatable
- No uses emojis
- Máximo 280 caracteres (como un tweet)

Pasaje (${reference}):
"${gospelText}"

Resumen coloquial:`;

  try {
    const response = await fetch("https://api.openai.com/v1/chat/completions", {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${openaiKey}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model: "gpt-3.5-turbo",
        messages: [
          {
            role: "user",
            content: prompt,
          },
        ],
        max_tokens: 150,
        temperature: 0.7,
      }),
    });

    if (!response.ok) {
      console.error(`OpenAI API error: ${response.status}`);
      return null;
    }

    const data = await response.json();
    const summary = data.choices?.[0]?.message?.content?.trim();
    return summary || null;
  } catch (error) {
    console.error("Error generating summary:", error);
    return null;
  }
}

serve(async (req) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    // Get environment variables
    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const apiBibleKey = Deno.env.get("API_BIBLE_KEY");
    const openaiKey = Deno.env.get("OPENAI_API_KEY");

    if (!apiBibleKey) {
      throw new Error("API_BIBLE_KEY not configured");
    }

    if (!openaiKey) {
      console.warn("OPENAI_API_KEY not configured - summaries will not be generated");
    }

    // Create Supabase client with service role (bypass RLS)
    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    // Get today's date (or from request body for testing)
    let targetDate = new Date();

    if (req.method === "POST") {
      try {
        const body = await req.json();
        if (body.date) {
          targetDate = new Date(body.date);
        }
      } catch {
        // Use today's date if body parsing fails
      }
    }

    const dateStr = targetDate.toISOString().split("T")[0]; // YYYY-MM-DD
    console.log(`Fetching gospel for date: ${dateStr}`);

    // Check if we already have this date
    const { data: existing } = await supabase
      .from("daily_verses")
      .select("verse_date")
      .eq("verse_date", dateStr)
      .single();

    if (existing) {
      console.log(`Gospel for ${dateStr} already exists`);
      return new Response(
        JSON.stringify({ success: true, message: "Already cached", date: dateStr }),
        { headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Fetch Catholic readings
    const readings = await fetchCatholicReadings(targetDate);
    if (!readings || !readings.readings.gospel) {
      throw new Error(`No gospel reading found for ${dateStr}`);
    }

    const gospelReference = readings.readings.gospel;
    const spanishReference = toSpanishReference(gospelReference);
    const apiBiblePassageId = toApiBibleFormat(gospelReference);

    console.log(`Gospel reference: ${gospelReference} -> ${spanishReference}`);
    console.log(`API.Bible passage ID: ${apiBiblePassageId}`);

    // Insert into daily_verses
    const { error: verseError } = await supabase
      .from("daily_verses")
      .upsert({
        verse_date: dateStr,
        reference: spanishReference,
        context_notes: readings.season || null,
      });

    if (verseError) {
      throw new Error(`Error inserting daily_verse: ${verseError.message}`);
    }

    // Fetch text for each Bible version
    // Note: RVR1909 es la única versión completa gratuita, se guarda también como RVR1960 para compatibilidad
    const versionsToFetch = ["RVR1909"];
    const results: Record<string, string> = {};

    let summary: string | null = null;

    for (const versionCode of versionsToFetch) {
      const bibleId = BIBLE_VERSIONS[versionCode];
      if (!bibleId || !apiBiblePassageId) continue;

      const passage = await fetchBiblePassage(apiBiblePassageId, bibleId, apiBibleKey);
      if (passage) {
        const cleanText = cleanContent(passage.content);
        results[versionCode] = cleanText;

        // Generate summary with OpenAI (only once, for the first version)
        if (!summary && openaiKey) {
          console.log("Generating summary with OpenAI...");
          summary = await generateSummary(cleanText, spanishReference, openaiKey);
          if (summary) {
            console.log(`Summary generated: ${summary.substring(0, 50)}...`);
          }
        }

        // Insert into daily_verse_texts for this version
        const { error: textError } = await supabase
          .from("daily_verse_texts")
          .upsert({
            verse_date: dateStr,
            bible_version_code: versionCode,
            verse_text: cleanText,
            verse_summary: summary,
          });

        if (textError) {
          console.error(`Error inserting text for ${versionCode}:`, textError.message);
        }

        // Also save as RVR1960 for backwards compatibility (app default)
        if (versionCode === "RVR1909") {
          const { error: rvr1960Error } = await supabase
            .from("daily_verse_texts")
            .upsert({
              verse_date: dateStr,
              bible_version_code: "RVR1960",
              verse_text: cleanText,
              verse_summary: summary,
            });

          if (rvr1960Error) {
            console.error(`Error inserting text for RVR1960:`, rvr1960Error.message);
          }
          results["RVR1960"] = cleanText;
        }
      }
    }

    return new Response(
      JSON.stringify({
        success: true,
        date: dateStr,
        reference: spanishReference,
        season: readings.season,
        versions: Object.keys(results),
        summary: summary,
      }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );

  } catch (error) {
    console.error("Error in fetch-daily-gospel:", error);
    return new Response(
      JSON.stringify({ success: false, error: error.message }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
