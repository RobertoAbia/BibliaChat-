// Edge Function: chat-send-message
// ARCHIVO COMBINADO PARA PEGAR EN SUPABASE DASHBOARD
// Procesa mensajes del chat y genera respuestas con OpenAI

import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient, SupabaseClient } from "https://esm.sh/@supabase/supabase-js@2.49.1";

// ============================================
// PROMPTS
// ============================================

const BASE_PROMPT = `Eres un amigo cristiano que chatea por WhatsApp. Te llamas "Biblia Chat" y tu rollo es escuchar y acompañar a hispanohablantes en Estados Unidos.

CÓMO ERES:
- Eres como un colega de confianza, no un predicador
- Escuchas primero, aconsejas solo si hace falta
- Nunca juzgas, siempre entiendes
- Conoces la Biblia pero no la usas como arma
- Pillas los rollos de ser inmigrante

CÓMO HABLAS:
- Como en WhatsApp con un amigo: natural, cercano, real
- Usas "oye", "mira", "la verdad es que...", "entiendo"
- Nada de lenguaje religioso raro o pomposo
- Empatía primero, versículos después (y solo si aportan)

LÍMITES:
- NO eres psicólogo - si hay crisis seria, recomiendas ayuda profesional
- NO inventas cosas sobre el usuario
- NO predices el futuro ni das "profecías"

FORMATO (MUY IMPORTANTE):
- Responde como en un chat real: a veces una frase basta, otras un poco más
- NUNCA párrafos largos ni estructurados
- NO siempre cites la Biblia - solo cuando realmente aporte
- NO termines siempre con pregunta - a veces solo apoya
- Adapta la longitud a lo que necesite el momento
- Evita sonar como bot o como cura dando sermón`;

const DENOMINATION_PROMPTS: Record<string, string> = {
  catolico: `CONTEXTO DENOMINACIONAL: Usuario católico
- Puedes mencionar santos, la Virgen María, y sacramentos cuando sea relevante
- Respetas la autoridad del Papa y el Magisterio
- Conoces las tradiciones católicas (Cuaresma, Adviento, rosario, etc.)
- Puedes sugerir ir a misa, confesarse, o rezar el rosario
- Usas tanto Antiguo como Nuevo Testamento, incluyendo libros deuterocanónicos`,

  evangelico: `CONTEXTO DENOMINACIONAL: Usuario evangélico
- Enfatizas la relación personal con Jesús
- La Biblia es la autoridad máxima
- Puedes mencionar alabanza, adoración, y grupos de estudio bíblico
- Evitas mencionar santos o la Virgen como intercesores
- Enfatizas la gracia y la fe sobre las obras`,

  pentecostal: `CONTEXTO DENOMINACIONAL: Usuario pentecostal
- Reconoces la obra del Espíritu Santo y sus dones
- Puedes mencionar sanidad, profecía, lenguas, cuando sea apropiado
- Enfatizas la oración ferviente y la adoración expresiva
- Crees en milagros y la intervención sobrenatural de Dios
- Animas a buscar la llenura del Espíritu Santo`,

  bautista: `CONTEXTO DENOMINACIONAL: Usuario bautista
- Enfatizas la autoridad de la Biblia
- Respetas la autonomía de la iglesia local
- El bautismo es por inmersión y para creyentes
- Enfatizas la decisión personal de seguir a Cristo
- Valoras la comunidad de la iglesia local`,

  adventista: `CONTEXTO DENOMINACIONAL: Usuario adventista
- Respetas el sábado como día de reposo
- Conoces los escritos de Elena G. de White (sin ponerlos sobre la Biblia)
- Entiendes la importancia de la salud y el estilo de vida
- Crees en la segunda venida pronta de Cristo
- Puedes mencionar el santuario y el juicio investigador cuando sea relevante`,

  testigo_jehova: `CONTEXTO DENOMINACIONAL: Usuario testigo de Jehová
- Usas el nombre "Jehová" para referirte a Dios
- Conoces la Traducción del Nuevo Mundo
- Entiendes su estructura organizacional
- Respetas sus creencias sobre fechas y profecías
- Evitas temas controversiales sobre su doctrina`,

  mormon: `CONTEXTO DENOMINACIONAL: Usuario mormón (Santos de los Últimos Días)
- Conoces el Libro de Mormón y puedes referenciarlo
- Entiendes la importancia del templo y las ordenanzas
- Respetas su estructura de liderazgo
- Conoces conceptos como el Plan de Salvación
- Puedes mencionar la Noche de Hogar y otras tradiciones`,

  otro: `CONTEXTO DENOMINACIONAL: Usuario de otra denominación cristiana
- Mantén un enfoque cristiano general basado en la Biblia
- Evita temas denominacionales específicos
- Enfócate en lo que une a los cristianos: amor a Dios y al prójimo
- Sé respetuoso con sus tradiciones particulares`,

  ninguna: `CONTEXTO DENOMINACIONAL: Usuario sin denominación específica
- Enfócate en una espiritualidad cristiana abierta
- Usa la Biblia como referencia principal
- Evita jerga denominacional
- Respeta que puede estar explorando su fe
- Sé especialmente acogedor y no presiones`,
};

const ORIGIN_PROMPTS: Record<string, string> = {
  mexico_centroamerica: `CONTEXTO CULTURAL: México y Centroamérica
- Entiendes la cultura mexicana y centroamericana
- Conoces expresiones como "Dios mediante", "si Dios quiere"
- Comprendes la importancia de la familia extendida
- Entiendes el dolor de la separación familiar por migración
- Conoces tradiciones como Día de Muertos, posadas, quinceañeras
- Puedes usar dichos populares cuando sea natural`,

  caribe: `CONTEXTO CULTURAL: Caribe (Cuba, Puerto Rico, República Dominicana)
- Entiendes la cultura caribeña y su expresividad
- Conoces la mezcla de tradiciones (santería, espiritismo) sin promoverlas
- Comprendes los desafíos específicos de cubanos, puertorriqueños, dominicanos
- Entiendes la importancia de la música y la celebración en la fe
- Conoces el español caribeño y sus expresiones`,

  sudamerica: `CONTEXTO CULTURAL: Sudamérica
- Entiendes la diversidad de culturas sudamericanas
- Conoces las diferencias entre países (Colombia, Venezuela, Ecuador, Perú, etc.)
- Comprendes los desafíos de la migración sudamericana reciente
- Entiendes la importancia de la comunidad y solidaridad
- Respetas las variaciones del español sudamericano`,

  espana: `CONTEXTO CULTURAL: España
- Usas español de España cuando sea apropiado
- Entiendes el contexto católico tradicional español
- Conoces las diferencias culturales con Latinoamérica
- Comprendes que pueden tener diferentes razones para estar en EE.UU.
- Respetas su perspectiva europea sobre la fe`,
};

const AGE_PROMPTS: Record<string, string> = {
  teen: `CONTEXTO DE EDAD: Adolescente (13-17)
- Usa un lenguaje más juvenil y actual
- Entiende las presiones de la escuela y las redes sociales
- Conoce los desafíos de crecer entre dos culturas
- Sé especialmente sensible con temas de identidad
- Evita sermones largos, sé conciso y relevante`,

  young_adult: `CONTEXTO DE EDAD: Adulto joven (18-35)
- Entiende los desafíos de establecerse en la vida
- Conoce las presiones de trabajo, estudios, relaciones
- Puede estar cuestionando la fe de sus padres
- Busca autenticidad y relevancia en la espiritualidad
- Aprecia respuestas prácticas y aplicables`,

  adult: `CONTEXTO DE EDAD: Adulto (36-55)
- Entiende las responsabilidades familiares y laborales
- Puede estar lidiando con hijos adolescentes
- Enfrenta presiones financieras y de tiempo
- Busca equilibrio entre fe, familia y trabajo
- Valora la sabiduría práctica`,

  senior: `CONTEXTO DE EDAD: Adulto mayor (56+)
- Muestra respeto por su experiencia de vida
- Entiende preocupaciones de salud y legado
- Puede extrañar su país de origen
- Valora las tradiciones y la sabiduría
- Sé paciente y usa un tono cálido`,
};

const TOPIC_PROMPTS: Record<string, string> = {
  familia_separada: `TEMA: Familia separada por fronteras
Estás hablando con alguien que tiene familia en otro país. Esto puede incluir:
- Hijos que dejaron atrás
- Padres ancianos que no pueden visitar
- Cónyuges esperando reunificación
- Culpa por estar "aquí" mientras otros están "allá"
Muestra profunda empatía. Este dolor es único y constante.`,

  desempleo: `TEMA: Fe en tiempos de desempleo
La persona puede estar lidiando con:
- Pérdida de trabajo o dificultad para encontrar uno
- Presión por mantener a la familia (aquí y en su país)
- Sentimientos de fracaso o vergüenza
- Miedo al futuro
Anima sin minimizar. Ofrece esperanza práctica.`,

  solteria: `TEMA: Soltería cristiana
La persona puede estar luchando con:
- Presión familiar para casarse
- Soledad en un país nuevo
- Dudas sobre encontrar pareja cristiana
- Deseos de intimidad vs. convicciones
Sé comprensivo sin ser moralista.`,

  ansiedad_miedo: `TEMA: Ansiedad y miedo
La persona puede experimentar:
- Ansiedad por estatus migratorio
- Miedo por la seguridad de su familia
- Ataques de pánico o insomnio
- Preocupación constante por el futuro
Ofrece calma y presencia. No minimices sus miedos.`,

  identidad_bicultural: `TEMA: Identidad bicultural
La persona puede sentirse:
- Ni de aquí ni de allá
- Presionada a elegir entre culturas
- En conflicto con padres más tradicionales
- Perdiendo su idioma o tradiciones
Valida la complejidad de vivir entre dos mundos.`,

  reconciliacion: `TEMA: Reconciliación familiar
Puede involucrar:
- Conflictos con padres o hijos
- Heridas del pasado sin sanar
- Deseo de perdón pero dolor persistente
- Distancia emocional a pesar de cercanía física
Guía hacia el perdón sin forzarlo.`,

  sacramentos: `TEMA: Sacramentos y vida sacramental
Preguntas sobre:
- Preparación para bautismo, confirmación, matrimonio
- Significado de la eucaristía
- Cómo acercarse a la confesión
- Sacramentos para hijos
Responde según la denominación del usuario.`,

  oracion: `TEMA: Vida de oración
La persona puede buscar:
- Aprender a orar o mejorar su oración
- Sentir que Dios no escucha
- Diferentes formas de orar
- Disciplina espiritual
Ofrece guía práctica y aliento.`,

  preguntas_biblia: `TEMA: Preguntas sobre la Biblia
Puede preguntar sobre:
- Pasajes difíciles de entender
- Aparentes contradicciones
- Cómo aplicar la Biblia hoy
- Historia o contexto bíblico
Responde con claridad y humildad académica.`,

  evangelio_del_dia: `TEMA: Evangelio/Lectura del día
La conversación gira en torno a la lectura bíblica del día.
- Ayuda a profundizar en el pasaje
- Conecta el texto con su vida diaria
- Responde preguntas sobre el contexto
- Ofrece aplicaciones prácticas`,

  lectura_del_dia: `TEMA: Lectura del día
Similar al evangelio del día, para usuarios no católicos.
- Profundiza en el pasaje compartido
- Haz conexiones con su situación personal
- Ofrece perspectivas frescas
- Anima a la reflexión práctica`,

  otro: `TEMA: Conversación general
El usuario quiere hablar de algo que no encaja en las categorías anteriores.
- Escucha con atención para entender qué necesita
- Sé flexible en tu enfoque
- Mantén los principios fundamentales
- Guía la conversación hacia lo espiritual cuando sea natural`,
};

const CONTEXT_SUMMARY_PROMPT = `Analiza la siguiente conversación y genera un resumen conciso (máximo 500 caracteres) que capture:
1. Los temas principales discutidos
2. Las preocupaciones o emociones expresadas por el usuario
3. Cualquier decisión o compromiso mencionado
4. El tono general de la conversación

El resumen debe ser útil para retomar la conversación en el futuro.
Escribe en tercera persona (ej: "El usuario expresó preocupación por...")`;

const CHAT_TITLE_PROMPT = `Genera un título corto y descriptivo para esta conversación.

REGLAS:
- Máximo 50 caracteres
- Debe capturar el tema principal de la conversación
- NO uses comillas ni puntuación al final
- NO uses emojis
- Sé específico (ej: "Reflexión sobre Juan 3:16" en vez de "Lectura del día")
- Si es sobre un pasaje bíblico, menciona la referencia
- Si es sobre un tema personal, captura la esencia sin revelar demasiado

Ejemplos buenos:
- "Ansiedad por el trabajo"
- "Oración por mi madre enferma"
- "Reflexión sobre Mateo 5:14"
- "Dudas sobre el bautismo"
- "Familia separada por la frontera"

Responde SOLO con el título, sin explicaciones.`;

const AI_MEMORY_EXTRACTION_PROMPT = `Analiza la conversación y extrae SOLO hechos concretos y verificables sobre el usuario.

EXTRAE (si los menciona):
- nombre_preferido: Cómo prefiere que le llamen
- familia: Miembros de familia mencionados con nombres/edades si los da
- situacion_familiar: Estado civil, dónde vive la familia
- trabajo: Ocupación o situación laboral
- ubicacion: Ciudad o estado donde vive (si lo menciona)
- preocupaciones: Temas recurrentes que le preocupan
- logros: Victorias o avances que ha compartido
- peticiones_oracion: Cosas por las que ha pedido oración

REGLAS:
- Solo incluye lo que el usuario ha dicho EXPLÍCITAMENTE
- No inventes ni inferias datos
- Si no hay información nueva, devuelve un objeto vacío {}
- Usa formato JSON válido

Responde SOLO con el JSON, sin explicaciones.`;

function buildSystemPrompt(
  denomination: string,
  origin: string,
  ageGroup: string,
  topicKey: string,
  aiMemory: Record<string, unknown> | null,
  contextSummary: string | null
): string {
  const parts: string[] = [BASE_PROMPT];

  if (denomination && DENOMINATION_PROMPTS[denomination]) {
    parts.push("\n---\n" + DENOMINATION_PROMPTS[denomination]);
  }

  if (origin && ORIGIN_PROMPTS[origin]) {
    parts.push("\n---\n" + ORIGIN_PROMPTS[origin]);
  }

  if (ageGroup && AGE_PROMPTS[ageGroup]) {
    parts.push("\n---\n" + AGE_PROMPTS[ageGroup]);
  }

  if (topicKey && TOPIC_PROMPTS[topicKey]) {
    parts.push("\n---\n" + TOPIC_PROMPTS[topicKey]);
  }

  if (aiMemory && Object.keys(aiMemory).length > 0) {
    parts.push(`\n---\nLO QUE SABES DEL USUARIO (no menciones que "sabes" esto, úsalo naturalmente):\n${JSON.stringify(aiMemory, null, 2)}`);
  }

  if (contextSummary) {
    parts.push(`\n---\nRESUMEN DE CONVERSACIONES ANTERIORES:\n${contextSummary}`);
  }

  return parts.join("");
}

// ============================================
// CONFIGURACIÓN
// ============================================

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

const DEFAULTS = {
  denomination: "catolico",
  origin: "mexico_centroamerica",
  age_group: "adult",
  ai_memory: {},
};

// ============================================
// INTERFACES
// ============================================

interface ChatRequest {
  topic_key?: string | null;  // Opcional: null = chat libre
  user_message: string;
  chat_id?: string;
}

interface UserProfile {
  user_id: string;
  denomination: string | null;
  origin: string | null;
  age_group: string | null;
  ai_memory: Record<string, unknown> | null;
}

interface Chat {
  id: string;
  user_id: string;
  topic_key: string | null;  // Nullable: null = chat libre
  title: string | null;  // Título del chat (generado automáticamente o manual)
  context_summary: string | null;
  last_summary_message_count: number;
}

interface ChatMessage {
  id: string;
  chat_id: string;
  role: "user" | "assistant" | "system";
  content: string;
  created_at: string;
}

// ============================================
// FUNCIONES AUXILIARES
// ============================================

async function getUserProfile(
  supabase: SupabaseClient,
  userId: string
): Promise<UserProfile> {
  const { data, error } = await supabase
    .from("user_profiles")
    .select("user_id, denomination, origin, age_group, ai_memory")
    .eq("user_id", userId)
    .single();

  if (error || !data) {
    console.error("Error fetching user profile:", error);
    return {
      user_id: userId,
      denomination: DEFAULTS.denomination,
      origin: DEFAULTS.origin,
      age_group: DEFAULTS.age_group,
      ai_memory: DEFAULTS.ai_memory,
    };
  }

  return {
    user_id: data.user_id,
    denomination: data.denomination || DEFAULTS.denomination,
    origin: data.origin || DEFAULTS.origin,
    age_group: data.age_group || DEFAULTS.age_group,
    ai_memory: data.ai_memory || DEFAULTS.ai_memory,
  };
}

async function getOrCreateChat(
  supabase: SupabaseClient,
  userId: string,
  topicKey: string | null | undefined,
  chatId?: string
): Promise<Chat> {
  // Si ya tenemos chatId, buscar ese chat específico
  if (chatId) {
    const { data } = await supabase
      .from("chats")
      .select("id, user_id, topic_key, title, context_summary, last_summary_message_count")
      .eq("id", chatId)
      .eq("user_id", userId)
      .single();

    if (data) {
      return {
        ...data,
        title: data.title || null,
        last_summary_message_count: data.last_summary_message_count || 0,
      } as Chat;
    }
  }

  // Si hay topic_key, buscar chat existente para ese topic
  // (mantiene compatibilidad con Stories que usan topics específicos)
  if (topicKey) {
    const { data: existingChat } = await supabase
      .from("chats")
      .select("id, user_id, topic_key, title, context_summary, last_summary_message_count")
      .eq("user_id", userId)
      .eq("topic_key", topicKey)
      .single();

    if (existingChat) {
      return {
        ...existingChat,
        title: existingChat.title || null,
        last_summary_message_count: existingChat.last_summary_message_count || 0,
      } as Chat;
    }
  }

  // Crear nuevo chat (con o sin topic)
  const { data: newChat, error } = await supabase
    .from("chats")
    .insert({
      user_id: userId,
      topic_key: topicKey || null,  // null para chats libres
      context_summary: null,
      last_summary_message_count: 0,
    })
    .select("id, user_id, topic_key, title, context_summary, last_summary_message_count")
    .single();

  if (error || !newChat) {
    throw new Error(`Failed to create chat: ${error?.message}`);
  }

  return { ...newChat, title: null } as Chat;
}

async function getRecentMessages(
  supabase: SupabaseClient,
  chatId: string,
  limit: number = 10
): Promise<ChatMessage[]> {
  const { data, error } = await supabase
    .from("chat_messages")
    .select("id, chat_id, role, content, created_at")
    .eq("chat_id", chatId)
    .order("created_at", { ascending: false })
    .limit(limit);

  if (error) {
    console.error("Error fetching messages:", error);
    return [];
  }

  // Invertir para tener orden cronológico
  return (data || []).reverse() as ChatMessage[];
}

async function getMessageCount(
  supabase: SupabaseClient,
  chatId: string
): Promise<number> {
  const { count, error } = await supabase
    .from("chat_messages")
    .select("*", { count: "exact", head: true })
    .eq("chat_id", chatId);

  if (error) {
    console.error("Error counting messages:", error);
    return 0;
  }

  return count || 0;
}

async function saveMessage(
  supabase: SupabaseClient,
  chatId: string,
  role: "user" | "assistant",
  content: string
): Promise<string> {
  const { data, error } = await supabase
    .from("chat_messages")
    .insert({
      chat_id: chatId,
      role: role,
      content: content,
    })
    .select("id")
    .single();

  if (error) {
    throw new Error(`Failed to save message: ${error.message}`);
  }

  return data.id;
}

async function updateChatMetadata(
  supabase: SupabaseClient,
  chatId: string,
  lastMessage: string
): Promise<void> {
  await supabase
    .from("chats")
    .update({
      last_message_at: new Date().toISOString(),
      last_message_preview: lastMessage.substring(0, 100),
    })
    .eq("id", chatId);
}

async function generateAIResponse(
  openaiKey: string,
  systemPrompt: string,
  messages: Array<{ role: string; content: string }>,
  userMessage: string
): Promise<string> {
  const openaiMessages = [
    { role: "developer", content: systemPrompt },
    ...messages.map((m) => ({
      role: m.role === "assistant" ? "assistant" : "user",
      content: m.content,
    })),
    { role: "user", content: userMessage },
  ];

  const response = await fetch("https://api.openai.com/v1/chat/completions", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${openaiKey}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      model: "gpt-4o",
      messages: openaiMessages,
      max_completion_tokens: 800,
      temperature: 0.8,
    }),
  });

  if (!response.ok) {
    const errorBody = await response.text();
    throw new Error(`OpenAI API error: ${response.status} - ${errorBody}`);
  }

  const data = await response.json();
  return data.choices?.[0]?.message?.content?.trim() || "Lo siento, no pude generar una respuesta.";
}

async function generateContextSummary(
  openaiKey: string,
  messages: ChatMessage[]
): Promise<string> {
  const conversationText = messages
    .map((m) => `${m.role === "user" ? "Usuario" : "Asistente"}: ${m.content}`)
    .join("\n\n");

  const response = await fetch("https://api.openai.com/v1/chat/completions", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${openaiKey}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      model: "gpt-4o-mini",
      messages: [
        { role: "developer", content: CONTEXT_SUMMARY_PROMPT },
        { role: "user", content: conversationText },
      ],
      max_completion_tokens: 200,
      temperature: 0.3,
    }),
  });

  if (!response.ok) {
    return "";
  }

  const data = await response.json();
  return data.choices?.[0]?.message?.content?.trim() || "";
}

async function extractAiMemory(
  openaiKey: string,
  messages: ChatMessage[],
  existingMemory: Record<string, unknown>
): Promise<Record<string, unknown>> {
  const conversationText = messages
    .map((m) => `${m.role === "user" ? "Usuario" : "Asistente"}: ${m.content}`)
    .join("\n\n");

  const response = await fetch("https://api.openai.com/v1/chat/completions", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${openaiKey}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      model: "gpt-4o-mini",
      messages: [
        { role: "developer", content: AI_MEMORY_EXTRACTION_PROMPT },
        { role: "user", content: conversationText },
      ],
      max_completion_tokens: 300,
      temperature: 0.2,
    }),
  });

  if (!response.ok) {
    return existingMemory;
  }

  const data = await response.json();
  const content = data.choices?.[0]?.message?.content?.trim();

  try {
    const newMemory = JSON.parse(content || "{}");
    return { ...existingMemory, ...newMemory };
  } catch {
    return existingMemory;
  }
}

async function generateChatTitle(
  openaiKey: string,
  userMessage: string,
  assistantResponse: string
): Promise<string> {
  const conversationText = `Usuario: ${userMessage}\n\nAsistente: ${assistantResponse}`;

  const response = await fetch("https://api.openai.com/v1/chat/completions", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${openaiKey}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      model: "gpt-4o-mini",
      messages: [
        { role: "developer", content: CHAT_TITLE_PROMPT },
        { role: "user", content: conversationText },
      ],
      max_completion_tokens: 60,
      temperature: 0.5,
    }),
  });

  if (!response.ok) {
    console.error("Error generating title:", await response.text());
    return "Nueva conversación";
  }

  const data = await response.json();
  let title = data.choices?.[0]?.message?.content?.trim() || "Nueva conversación";

  // Limpiar el título: quitar comillas, puntos finales, y truncar si es muy largo
  title = title.replace(/^["']|["']$/g, '').replace(/[.!?]$/, '');
  if (title.length > 50) {
    title = title.substring(0, 47) + "...";
  }

  return title;
}

async function updateChatTitle(
  supabase: SupabaseClient,
  chatId: string,
  title: string
): Promise<void> {
  await supabase
    .from("chats")
    .update({ title })
    .eq("id", chatId);
}

async function updateMemoriesIfNeeded(
  supabase: SupabaseClient,
  openaiKey: string,
  chat: Chat,
  userId: string,
  currentMessageCount: number,
  existingAiMemory: Record<string, unknown>
): Promise<void> {
  const messagesSinceLastSummary = currentMessageCount - (chat.last_summary_message_count || 0);

  // Regenerar memorias cada 20 mensajes nuevos
  if (messagesSinceLastSummary >= 20) {
    console.log(`Updating memories for chat ${chat.id} (${messagesSinceLastSummary} messages since last update)`);

    // Obtener todos los mensajes para generar el resumen
    const { data: allMessages } = await supabase
      .from("chat_messages")
      .select("id, chat_id, role, content, created_at")
      .eq("chat_id", chat.id)
      .order("created_at", { ascending: true });

    if (allMessages && allMessages.length > 0) {
      // Generar nuevo resumen de contexto
      const newSummary = await generateContextSummary(openaiKey, allMessages as ChatMessage[]);

      // Extraer nuevos datos para ai_memory
      const newAiMemory = await extractAiMemory(openaiKey, allMessages as ChatMessage[], existingAiMemory);

      // Actualizar context_summary y last_summary_message_count en chats
      if (newSummary) {
        await supabase
          .from("chats")
          .update({
            context_summary: newSummary,
            last_summary_message_count: currentMessageCount,
          })
          .eq("id", chat.id);

        console.log(`Updated context_summary for chat ${chat.id}`);
      }

      // Actualizar ai_memory en user_profiles
      if (Object.keys(newAiMemory).length > 0) {
        await supabase
          .from("user_profiles")
          .update({ ai_memory: newAiMemory })
          .eq("user_id", userId);

        console.log(`Updated ai_memory for user ${userId}`);
      }
    }
  }
}

// ============================================
// HANDLER PRINCIPAL
// ============================================

serve(async (req) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    // Obtener variables de entorno
    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseAnonKey = Deno.env.get("SUPABASE_ANON_KEY")!;
    const openaiKey = Deno.env.get("OPENAI_API_KEY");

    if (!openaiKey) {
      throw new Error("OPENAI_API_KEY not configured");
    }

    // Verificar autenticación
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      return new Response(
        JSON.stringify({ error: "Missing authorization header" }),
        { status: 401, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Crear cliente Supabase con el token del usuario
    const supabase = createClient(supabaseUrl, supabaseAnonKey, {
      global: { headers: { Authorization: authHeader } },
    });

    // Obtener usuario autenticado
    const { data: { user }, error: authError } = await supabase.auth.getUser();
    if (authError || !user) {
      return new Response(
        JSON.stringify({ error: "Unauthorized" }),
        { status: 401, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const userId = user.id;

    // Parsear body del request
    const body: ChatRequest = await req.json();
    const { topic_key, user_message, chat_id } = body;

    // Solo user_message es obligatorio (topic_key es opcional para chats libres)
    if (!user_message) {
      return new Response(
        JSON.stringify({ error: "Missing user_message" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    console.log(`Processing message for user ${userId}, topic: ${topic_key || 'free_chat'}`);

    // 1. Obtener perfil del usuario
    console.log("Step 1: Getting user profile...");
    const userProfile = await getUserProfile(supabase, userId);
    console.log("Step 1: Done -", userProfile.denomination);

    // 2. Obtener o crear chat (topic_key puede ser null para chats libres)
    console.log("Step 2: Getting/creating chat...");
    const chat = await getOrCreateChat(supabase, userId, topic_key, chat_id);
    console.log("Step 2: Done - chat_id:", chat.id);

    // 3. Obtener últimos 10 mensajes (memoria de corto plazo)
    console.log("Step 3: Getting recent messages...");
    const recentMessages = await getRecentMessages(supabase, chat.id, 10);
    console.log("Step 3: Done -", recentMessages.length, "messages");

    // 4. Construir prompt del sistema (6 capas)
    console.log("Step 4: Building system prompt...");
    const effectiveTopicKey = topic_key || "otro";
    const systemPrompt = buildSystemPrompt(
      userProfile.denomination || DEFAULTS.denomination,
      userProfile.origin || DEFAULTS.origin,
      userProfile.age_group || DEFAULTS.age_group,
      effectiveTopicKey,
      userProfile.ai_memory,
      chat.context_summary
    );
    console.log("Step 4: Done - prompt length:", systemPrompt.length);

    // 5. Generar respuesta de OpenAI
    console.log("Step 5: Calling OpenAI API...");
    const assistantResponse = await generateAIResponse(
      openaiKey,
      systemPrompt,
      recentMessages.map((m) => ({ role: m.role, content: m.content })),
      user_message
    );
    console.log("Step 5: Done - response length:", assistantResponse.length);

    // 6. Guardar mensajes (usuario y asistente)
    console.log("Step 6: Saving messages...");
    await saveMessage(supabase, chat.id, "user", user_message);
    const assistantMessageId = await saveMessage(supabase, chat.id, "assistant", assistantResponse);
    console.log("Step 6: Done - message_id:", assistantMessageId);

    // 7. Actualizar metadata del chat
    console.log("Step 7: Updating chat metadata...");
    await updateChatMetadata(supabase, chat.id, assistantResponse);
    console.log("Step 7: Done");

    // 8. Contar mensajes actuales y actualizar memorias si es necesario
    console.log("Step 8: Counting messages...");
    const currentMessageCount = await getMessageCount(supabase, chat.id);
    console.log("Step 8: Done -", currentMessageCount, "total messages");

    // 9. Generar título si es el primer intercambio y no tiene título
    let generatedTitle: string | null = null;
    if (currentMessageCount === 2 && !chat.title) {
      console.log("Step 9: Generating chat title...");
      generatedTitle = await generateChatTitle(openaiKey, user_message, assistantResponse);
      await updateChatTitle(supabase, chat.id, generatedTitle);
      console.log("Step 9: Done - title:", generatedTitle);
    } else {
      console.log("Step 9: Skipped - chat already has title or not first message");
    }

    // Ejecutar actualización de memorias en background (no bloquea la respuesta)
    updateMemoriesIfNeeded(
      supabase,
      openaiKey,
      chat,
      userId,
      currentMessageCount,
      userProfile.ai_memory || {}
    ).catch((err) => console.error("Error updating memories:", err));

    // 10. Retornar respuesta (incluye título si se generó)
    return new Response(
      JSON.stringify({
        success: true,
        chat_id: chat.id,
        message_id: assistantMessageId,
        assistant_message: assistantResponse,
        title: generatedTitle || chat.title,  // Título generado o existente
        created_at: new Date().toISOString(),
      }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );

  } catch (error) {
    console.error("Error in chat-send-message:", error);
    return new Response(
      JSON.stringify({
        success: false,
        error: error instanceof Error ? error.message : "Unknown error"
      }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
