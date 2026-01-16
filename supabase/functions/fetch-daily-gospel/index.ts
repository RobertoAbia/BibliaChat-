// Edge Function: fetch-daily-gospel
// Se ejecuta diariamente via cron para obtener el Evangelio del día
// 1. Consulta tabla local liturgical_readings → referencia del día (fallback: Catholic Readings API)
// 2. Consulta Supabase bible_verses → texto en español (Reina Valera 1909)
// 3. Genera resumen coloquial con OpenAI
// 4. Guarda en daily_verses + daily_verse_texts

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient, SupabaseClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

// Mapeo de libros en inglés a español y book_id para nuestra BD
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

// Estructura para parsear rangos de versículos
interface VerseRange {
  bookId: string;
  chapter: number;
  startVerse: number;
  endVerse: number;
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

// Convierte referencia a rangos de versículos para consultar nuestra BD
// Retorna un array para manejar referencias no contiguas como "13-15, 19-23"
function parseVerseRanges(reference: string): VerseRange[] | null {
  const parsed = parseReference(reference);
  if (!parsed) return null;

  const bookInfo = bookMapping[parsed.book];
  if (!bookInfo) return null;

  // Separar por comas para manejar rangos no contiguos: "13-15, 19-23" -> ["13-15", "19-23"]
  const ranges = parsed.verses.split(",").map(v => v.trim());

  return ranges.map(range => {
    if (range.includes("-")) {
      const [startVerse, endVerse] = range.split("-");
      return {
        bookId: bookInfo.apiId,
        chapter: parsed.chapter,
        startVerse: parseInt(startVerse),
        endVerse: parseInt(endVerse),
      };
    }
    // Versículo único
    const verse = parseInt(range);
    return {
      bookId: bookInfo.apiId,
      chapter: parsed.chapter,
      startVerse: verse,
      endVerse: verse,
    };
  });
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

// Interfaz para lecturas litúrgicas locales
interface LiturgicalReading {
  reading_date: string;
  season: string | null;
  first_reading: string | null;
  psalm: string | null;
  second_reading: string | null;
  gospel: string;
}

// Obtiene las lecturas desde nuestra tabla local liturgical_readings
async function fetchLocalLiturgicalReadings(
  supabase: SupabaseClient,
  dateStr: string
): Promise<CatholicReadingsResponse | null> {
  try {
    const { data, error } = await supabase
      .from("liturgical_readings")
      .select("*")
      .eq("reading_date", dateStr)
      .single();

    if (error || !data) {
      console.log(`No local liturgical data for ${dateStr}, will try external API`);
      return null;
    }

    const reading = data as LiturgicalReading;
    console.log(`Found local liturgical reading for ${dateStr}`);

    // Convertir al formato CatholicReadingsResponse
    return {
      date: reading.reading_date,
      season: reading.season || undefined,
      readings: {
        firstReading: reading.first_reading || undefined,
        psalm: reading.psalm || undefined,
        secondReading: reading.second_reading || undefined,
        gospel: reading.gospel,
      },
    };
  } catch (error) {
    console.error("Error fetching local liturgical readings:", error);
    return null;
  }
}

// Obtiene las lecturas del Catholic Readings API (fallback externo)
async function fetchCatholicReadingsAPI(date: Date): Promise<CatholicReadingsResponse | null> {
  const year = date.getFullYear();
  const dateStr = getDateString(date);
  const url = `https://cpbjr.github.io/catholic-readings-api/readings/${year}/${dateStr}.json`;

  try {
    console.log(`Fetching from external API: ${url}`);
    const response = await fetch(url);
    if (!response.ok) {
      console.error(`Catholic Readings API error: ${response.status}`);
      return null;
    }
    return await response.json();
  } catch (error) {
    console.error("Error fetching Catholic readings from external API:", error);
    return null;
  }
}

// Obtiene las lecturas: primero local, luego fallback a API externa
async function fetchLiturgicalReadings(
  supabase: SupabaseClient,
  date: Date
): Promise<{ readings: CatholicReadingsResponse | null; source: "local" | "api" | null }> {
  const dateStr = date.toISOString().split("T")[0]; // YYYY-MM-DD

  // 1. Intentar obtener de la tabla local
  const localReadings = await fetchLocalLiturgicalReadings(supabase, dateStr);
  if (localReadings) {
    return { readings: localReadings, source: "local" };
  }

  // 2. Fallback a la API externa
  const apiReadings = await fetchCatholicReadingsAPI(date);
  if (apiReadings) {
    return { readings: apiReadings, source: "api" };
  }

  return { readings: null, source: null };
}

// Obtiene el texto de un rango de versículos desde nuestra tabla bible_verses
async function fetchBiblePassage(
  supabase: SupabaseClient,
  range: VerseRange
): Promise<string | null> {
  try {
    const { data, error } = await supabase
      .from("bible_verses")
      .select("verse, text")
      .eq("book_id", range.bookId)
      .eq("chapter", range.chapter)
      .gte("verse", range.startVerse)
      .lte("verse", range.endVerse)
      .order("verse");

    if (error) {
      console.error(`Supabase query error:`, error.message);
      return null;
    }

    if (!data || data.length === 0) {
      console.error(`No verses found for ${range.bookId} ${range.chapter}:${range.startVerse}-${range.endVerse}`);
      return null;
    }

    // Concatenar todos los versículos
    return data.map(v => v.text).join(" ");
  } catch (error) {
    console.error("Error fetching Bible passage:", error);
    return null;
  }
}

// Interfaz para el contenido generado por IA
interface GospelContent {
  summary: string;      // Resumen coloquial
  keyConcept: string;   // Concepto/frase principal
  exercise: string;     // Ejercicio práctico
}

// Genera contenido del evangelio para Stories usando OpenAI
async function generateGospelContent(
  gospelText: string,
  reference: string,
  openaiKey: string
): Promise<GospelContent | null> {
  const systemPrompt = `Eres un copywriter experto y comunicador cristiano moderno. Tu trabajo es transformar pasajes bíblicos en contenido atractivo para redes sociales.

REGLAS ESTRICTAS:
- El resumen DEBE tener mínimo 300 caracteres
- El ejercicio NUNCA puede ser orar, rezar, meditar o reflexionar
- El concepto clave debe sonar a frase de autor, no a resumen`;

  const userPrompt = `Transforma este pasaje bíblico en contenido para una app cristiana. Escribe SIEMPRE en español de España, usando la segunda persona del singular (tú, te, ti).

PASAJE (${reference}):
"${gospelText}"

---

GENERA EXACTAMENTE ESTO:

1. "summary" (MÍNIMO 300 caracteres, MÁXIMO 500):
Cuenta qué pasa en este pasaje de forma clara y cercana, como si se lo explicaras a un amigo. Nada de frases hechas religiosas ni lenguaje arcaico. Escribe de forma natural, con frases cortas y directas. Usa presente histórico para hacerlo más vivo. NO uses expresiones como "imagínate", "fíjate", "salir pitando" o jerga forzada.

2. "keyConcept" (MÁXIMO 60 caracteres):
Una frase potente estilo copywriting que capture la esencia del mensaje. Debe sonar a frase de autor, no a resumen del pasaje. Ejemplos del estilo:
- "El miedo miente, la fe actúa"
- "Tu historia no termina aquí"
- "A veces el rodeo es el camino"

3. "exercise" (entre 80-150 caracteres):
Una acción FÍSICA y CONCRETA para hacer hoy. Dirígete al usuario en segunda persona del singular (tú).

PROHIBIDO: orar, rezar, meditar, reflexionar, leer la Biblia, ir a misa.
OBLIGATORIO: que involucre a OTRA PERSONA o una ACCIÓN MATERIAL tangible.

Ejemplos válidos:
- "Escribe en un papel el nombre de alguien que te haya hecho daño y quémalo como símbolo de perdón"
- "Envía un audio de WhatsApp a alguien diciéndole por qué le aprecias"
- "Deja una nota anónima de ánimo en el escritorio de un compañero"
- "Invita a comer a alguien que veas solo o triste"

---

RESPONDE SOLO CON JSON VÁLIDO:
{"summary": "...", "keyConcept": "...", "exercise": "..."}`;

  try {
    const response = await fetch("https://api.openai.com/v1/chat/completions", {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${openaiKey}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model: "gpt-5.2",
        messages: [
          {
            role: "developer",
            content: systemPrompt,
          },
          {
            role: "user",
            content: userPrompt,
          },
        ],
        max_completion_tokens: 600,
        temperature: 0.9,
      }),
    });

    if (!response.ok) {
      const errorBody = await response.text();
      console.error(`OpenAI API error: ${response.status} - ${errorBody}`);
      return null;
    }

    const data = await response.json();
    const content = data.choices?.[0]?.message?.content?.trim();

    if (!content) return null;

    // Parsear el JSON de la respuesta
    try {
      const parsed = JSON.parse(content);
      return {
        summary: parsed.summary || "",
        keyConcept: parsed.keyConcept || "",
        exercise: parsed.exercise || "",
      };
    } catch (parseError) {
      console.error("Error parsing OpenAI response as JSON:", content);
      // Fallback: usar todo el contenido como resumen
      return {
        summary: content.substring(0, 200),
        keyConcept: "",
        exercise: "",
      };
    }
  } catch (error) {
    console.error("Error generating gospel content:", error);
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
    const openaiKey = Deno.env.get("OPENAI_API_KEY");

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

    // Fetch liturgical readings (local first, then external API fallback)
    const { readings, source } = await fetchLiturgicalReadings(supabase, targetDate);
    if (!readings || !readings.readings.gospel) {
      throw new Error(`No gospel reading found for ${dateStr}`);
    }

    console.log(`Liturgical readings source: ${source}`);

    const gospelReference = readings.readings.gospel;
    const spanishReference = toSpanishReference(gospelReference);
    const verseRanges = parseVerseRanges(gospelReference);

    console.log(`Gospel reference: ${gospelReference} -> ${spanishReference}`);
    console.log(`Verse ranges: ${JSON.stringify(verseRanges)}`);

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

    // Fetch text from our local bible_verses table (Reina Valera 1909)
    let gospelText: string | null = null;
    let gospelContent: GospelContent | null = null;

    if (verseRanges && verseRanges.length > 0) {
      // Fetch all passage parts and concatenate (handles non-contiguous verses like "13-15, 19-23")
      const textParts: string[] = [];
      for (const range of verseRanges) {
        console.log(`Fetching passage: ${range.bookId} ${range.chapter}:${range.startVerse}-${range.endVerse}`);
        const passage = await fetchBiblePassage(supabase, range);
        if (passage) {
          textParts.push(passage);
        }
      }

      if (textParts.length > 0) {
        gospelText = textParts.join(" ");

        // Generate gospel content with OpenAI
        if (openaiKey) {
          console.log("Generating gospel content with OpenAI...");
          gospelContent = await generateGospelContent(gospelText, spanishReference, openaiKey);
          if (gospelContent) {
            console.log(`Content generated - Summary: ${gospelContent.summary.substring(0, 50)}...`);
          }
        }

        // Insert into daily_verse_texts (usamos RVR1960 como código aunque el texto es RVR1909)
        const { error: textError } = await supabase
          .from("daily_verse_texts")
          .upsert({
            verse_date: dateStr,
            bible_version_code: "RVR1960",
            verse_text: gospelText,
            verse_summary: gospelContent?.summary || null,
            key_concept: gospelContent?.keyConcept || null,
            practical_exercise: gospelContent?.exercise || null,
          });

        if (textError) {
          console.error(`Error inserting text for RVR1960:`, textError.message);
        }
      }
    }

    return new Response(
      JSON.stringify({
        success: true,
        date: dateStr,
        reference: spanishReference,
        season: readings.season,
        source: source, // "local" or "api"
        hasText: !!gospelText,
        summary: gospelContent?.summary || null,
        keyConcept: gospelContent?.keyConcept || null,
        exercise: gospelContent?.exercise || null,
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
