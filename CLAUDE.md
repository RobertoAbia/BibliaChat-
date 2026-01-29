# CLAUDE.md - Memoria del Proyecto Biblia Chat

## Descripción del Proyecto
**Biblia Chat** - App cristiana móvil (iOS + Android) diseñada para hispanohablantes en EE.UU. Combina IA denominacional, devocionales personalizados y planes de estudio temáticos.

**Propuesta de valor:** "La app cristiana hecha para ti. Que entiende tu fe, tu idioma, tu cultura."

## Stack Tecnológico
- **Frontend:** Flutter (iOS 14.5+ / Android 6.0+)
- **Backend/DB/Auth:** Supabase (PostgreSQL + Auth + RLS + Edge Functions)
- **IA:** OpenAI GPT-5.2 (usa `role: "developer"` y `max_completion_tokens`)
- **Pagos:** RevenueCat + In-App Purchases
- **Notificaciones:** Firebase Cloud Messaging
- **Analytics:** Firebase Analytics (integrado - 18 eventos personalizados)

## Arquitectura
- **Supabase-First:** Sin backend dedicado en MVP
- **Clean Architecture** aplicada
- **RLS (Row Level Security)** para seguridad a nivel de BD
- **Edge Functions** para operaciones sensibles (IA, billing)

## Estructura del Repositorio
```
BibliaChat/
├── app_flutter/          # Aplicación Flutter
├── supabase/
│   ├── migrations/       # Migraciones SQL
│   └── functions/        # Edge Functions (Deno/TypeScript)
│       └── fetch-daily-gospel/  # Evangelio del día (desplegada como clever-worker)
├── scripts/
│   ├── import_bible_verses.js       # Script para generar SQL de importación de Biblia
│   ├── import_liturgical_readings.js # Script para importar calendario litúrgico
│   ├── import_missing_books.js      # Script para importar libros faltantes de la Biblia
│   └── split_bible_sql.js           # Script para dividir SQL de Biblia en chunks
├── .github/
│   └── workflows/
│       └── daily-gospel.yml  # Cron diario para fetch-daily-gospel
├── docs/                 # Documentación del proyecto
│   ├── 01.Product Requeriments Document (PRD).md
│   ├── 02.Historias de usuario. Backlog.md
│   ├── 03.Casos de Uso, Arquitectura y C4.md
│   ├── 04.BBDD.md
│   ├── 05.Tickets de Trabajo.md
│   └── back-button-intentos.md  # Historial de intentos para arreglar botón atrás Android
├── .env.example
├── .gitignore
├── privacy-policy.html  # HTML para web (Hostinger)
├── terms-conditions.html  # HTML para web (Hostinger)
└── README.md
```

## 3 Pilares de la App
1. **HOY** - Retención diaria (racha, versículo, devoción, oración)
2. **CHAT** - IA denominacional con 10 temas hispanos
3. **ESTUDIAR** - 7 planes de estudio + gamificación

## Modelo de Negocio
- **Paid-first con trial 3 días**
- Mensual: $14.99/mes
- Anual: $39.99/año

## Tablas Principales de la BD
- `user_profiles` (incluye `ai_memory`, `rc_app_user_id`, `gender`, `country_code`)
- `chats` + `chat_messages` (hilos por tema)
- `saved_messages`
- `plans` + `plan_days` + `user_plans` + `user_plan_days`
- `daily_verses` + `daily_verse_texts` (incluye `verse_summary`, `key_concept`, `practical_exercise`)
- `bible_verses` (Reina Valera 1909 completa - 20,353 versículos)
- `devotions` + `devotion_variants` + `user_devotions`
- `daily_activity` (rachas + `messages_sent` para límite diario)
- `user_points` + `badges` + `user_badges`
- `user_devices` (FCM tokens)
- `user_entitlements` (premium status)
- `deleted_user_archives` (archivado pseudonimizado para GDPR, 3 años retención)
- `liturgical_readings` (calendario litúrgico católico - 365 días/año)

## Migraciones SQL (25 total)
- 00001-00009: Tablas core, ENUMs, RLS, índices
- 00010: `rc_app_user_id` para restaurar compras
- 00011: `gender` + enum `gender_type`
- 00012: `verse_summary` para resumen IA
- 00013: `key_concept` + `practical_exercise` para Stories
- 00014: `last_summary_message_count` para tracking de resúmenes IA
- 00015: Sistema chat híbrido (topics Stories + quitar UNIQUE constraint)
- 00016: `messages_sent` en `daily_activity` para límite de mensajes diarios
- 00017: `practical_exercise` en `plan_days` para ejercicios prácticos
- 00018: Seed data de los 7 planes de pecados capitales (49 días de contenido)
- 00019: `chat_id` en `user_plans` para vincular plan con chat
- 00020: DELETE policy en `user_plan_days` para permitir reiniciar planes
- 00021: Topic keys de planes en `chat_topics` para foreign key de chats
- 00022: `deleted_user_archives` para archivado pseudonimizado (GDPR) al borrar cuenta
- 00023: `bible_verses` tabla para almacenar Biblia localmente (reemplaza API.Bible)
- 00024: `liturgical_readings` tabla para calendario litúrgico (reemplaza dependencia de API externa)
- 00025: `country_code` en `user_profiles` para país específico (ISO 3166-1 alpha-2)

## EPICs del Proyecto (12 total)
- **EPIC 0-1:** Foundation + Base de datos + RLS
- **EPIC 2:** Flutter App Foundation
- **EPIC 3:** Auth + Onboarding + Perfil
- **EPIC 4:** Monetización (RevenueCat)
- **EPIC 5:** Chat IA (Core)
- **EPIC 6:** Memoria global (ai_memory)
- **EPIC 7:** HOY (Retención)
- **EPIC 8:** Contenido (Devotions/Versículos)
- **EPIC 9:** Estudiar (Planes)
- **EPIC 10:** Notificaciones (FCM)
- **EPIC 11:** Analytics
- **EPIC 12:** QA y Release

## Progreso Actual

### Completado
- [x] T-0001: Repositorio + estructura mono-repo
  - Git inicializado
  - Conectado a GitHub: https://github.com/RobertoAbia/BibliaChat-
  - Estructura de carpetas creada
  - Archivos base (.gitignore, README, .env.example)

- [x] T-0002: Configurar proyecto Supabase (dev)
  - Proyecto: `biblia-chat-dev`
  - URL: `https://popqvhrgsokuviwtscid.supabase.co`
  - Auth anónimo habilitado
  - Credenciales en `.env` (root)

- [x] T-0101: Crear tablas core en BD
  - 13 migraciones SQL creadas y ejecutadas:
    - ENUMs (denomination, origin_group, age_group, gender_type, etc.)
    - Tablas de catálogo (bible_versions, chat_topics, badges)
    - Tablas de usuario (user_profiles, user_devices, user_entitlements, etc.)
    - Tablas de chat (chats, chat_messages, saved_messages)
    - Tablas de contenido (daily_verses, devotions, etc.)
    - Tablas de planes (plans, plan_days, user_plans, etc.)
    - Políticas RLS completas
    - Índices de rendimiento
    - Trigger para creación automática de perfil
    - **00010:** Columna `rc_app_user_id` para restaurar compras sin registro
    - **00011:** Columna `gender` + enum `gender_type`
    - **00012:** Columna `verse_summary` en daily_verse_texts
    - **00013:** Columnas `key_concept` y `practical_exercise` para Stories

- [x] T-0201: Setup Flutter project
  - Proyecto Flutter creado (`app_flutter`)
  - Clean Architecture implementada
  - Dependencias instaladas (supabase_flutter, riverpod, go_router, etc.)
  - Navegación con GoRouter + ShellRoute (bottom navigation)
  - Tema Material 3 (light/dark)
  - Pantallas creadas:
    - SplashScreen (auth anónimo automático)
    - OnboardingScreen (11 páginas: Welcome → Edad → Género → País → Denominación → Motivo → Recordatorio → Persistencia → Corazón → Análisis → Ready)
    - HomeScreen (racha, versículo, devoción, oración)
    - ChatListScreen (10 temas)
    - ChatScreen (interfaz de chat)
    - StudyScreen (7 planes de estudio)
    - SettingsScreen (perfil, preferencias, logout)

- [x] Documentación BBDD actualizada (`docs/04.BBDD.md`)
  - Diagrama ERD en Mermaid válido
  - SQL de todas las tablas implementadas
  - Datos seed (versiones Biblia, temas chat, badges, planes)
  - Políticas RLS documentadas
  - Índices de performance
  - Triggers de auth
  - Notas funcionales (timezone, constraints, orden prompt IA)

- [x] UI Premium Modernizada (Glassmorphism + Lottie + Shimmer)
  - **Widgets reutilizables creados:**
    - `GlassContainer` - Efecto glassmorphism con BackdropFilter
    - `ShimmerLoading` - Skeletons de carga (text, avatar, card, list)
    - `LottieHelper` - Helper para animaciones Lottie
  - **Assets Lottie añadidos** (`assets/animations/`):
    - cross_glow.json, loading_dots.json, success_check.json
    - typing_indicator.json, praying_hands.json, celebration.json
  - **Pantallas modernizadas:**
    - SplashScreen: partículas flotantes, gradiente animado, Lottie cruz
    - OnboardingWelcomePage: logo Lottie, glass cards, shimmer button
    - OnboardingSelectionPage: tiles glass con glow al seleccionar
    - OnboardingReadyPage: features con iconos, CTA con gradiente
    - HomeScreen: calendario glass, verse card premium, content cards
    - ChatListScreen: topics con gradientes únicos, glass tiles
    - ChatScreen: burbujas glass, typing Lottie, input glass
    - StudyScreen: plan activo con progress animado, glass cards
  - **Paleta de colores:**
    - Fondo: Azul Noche (#1A1A2E, #16162A)
    - Primario: Dorado (#D4AF37, #E8C967, #B8963A)
    - Superficies: #252540, #2D2D4A
  - **Efectos implementados:**
    - BackdropFilter blur (8-12px)
    - Gradientes dorados con sombras glow
    - Animaciones staggered en listas
    - Tap feedback con escala
    - Transiciones suaves entre estados

- [x] T-0302 + T-0303: Onboarding conectado con Supabase
  - **Clean Architecture para perfil de usuario:**
    - Entity: `UserProfile` con enums (Denomination, OriginGroup, AgeGroup, MotiveType, GenderType)
    - Repository interface + implementación
    - Model con serialización JSON para Supabase
    - Datasource remoto con operaciones CRUD
  - **Riverpod providers:**
    - `userProfileRepositoryProvider` - Repositorio inyectado
    - `currentUserProfileProvider` - Perfil actual (FutureProvider)
    - `userProfileStreamProvider` - Cambios en tiempo real
    - `hasCompletedOnboardingProvider` - Verificación onboarding
    - `onboardingProvider` - StateNotifier para formulario onboarding
  - **Pantallas de onboarding (11 páginas):**
    - 0: Welcome (nombre)
    - 1: Edad (age_group)
    - 2: Género (gender) - Hombre/Mujer
    - 3: País - Dropdown 21 países hispanohablantes → guarda `origin` (origin_group) + `country_code` (ISO)
    - 4: Denominación
    - 5: Motivo (tipo de apoyo)
    - 6: Recordatorio (reminder_enabled, reminder_time) - Toggle + Time picker
    - 7: Persistencia (persistence_self_report) - Sí/No para recomendar planes
    - 8: Corazón (primer mensaje libre)
    - 9: Análisis (animación)
    - 10: Ready (confirmación + auto-detección timezone)
  - **Auto-detección de timezone:**
    - Usa `flutter_timezone` para detectar zona horaria del dispositivo
    - Se guarda en `user_profiles.timezone` al completar onboarding
  - **Flujo de navegación:**
    - Usuario nuevo → Auth anónimo → Onboarding → Home
    - Usuario existente sin onboarding → Onboarding
    - Usuario con onboarding completo → Home directo
  - **Archivos creados:**
    - `lib/features/profile/domain/entities/user_profile.dart`
    - `lib/features/profile/domain/repositories/user_profile_repository.dart`
    - `lib/features/profile/data/models/user_profile_model.dart`
    - `lib/features/profile/data/datasources/user_profile_remote_datasource.dart`
    - `lib/features/profile/data/repositories/user_profile_repository_impl.dart`
    - `lib/features/profile/presentation/providers/user_profile_provider.dart`
    - `lib/features/onboarding/presentation/widgets/onboarding_country_page.dart`
    - `lib/features/onboarding/presentation/widgets/onboarding_reminder_page.dart`
    - `lib/features/onboarding/presentation/widgets/onboarding_persistence_page.dart`

- [x] Feature: Evangelio del Día (Daily Gospel) + Stories
  - **Edge Function `fetch-daily-gospel`:**
    - Obtiene referencia del calendario litúrgico católico (Catholic Readings API)
    - Obtiene texto en español de tabla local `bible_verses` (Reina Valera 1909)
    - Genera contenido con **OpenAI GPT-5.2**:
      - Resumen coloquial (300-500 caracteres)
      - Concepto clave (frase impactante 60-100 chars)
      - Ejercicio práctico (acción física/material 100-180 chars)
    - Guarda en `daily_verses` + `daily_verse_texts`
    - **00012:** Nueva columna `verse_summary` para resumen IA
    - **00013:** Nuevas columnas `key_concept` y `practical_exercise`
  - **Fuentes de datos:**
    - Catholic Readings API (pública, sin key) - calendario litúrgico
    - Tabla `bible_verses` en Supabase (local) - 20,353 versículos Reina Valera 1909
    - OpenAI GPT-5.2 API (key requerida) - generación de contenido Stories
  - **Secrets en Supabase:**
    - `OPENAI_API_KEY` - Clave de OpenAI
  - **Feature Flutter `daily_gospel`:**
    - Clean Architecture (entity, model, repository, datasource, provider)
    - `DailyGospel` entity con: date, reference, text, summary, keyConcept, practicalExercise, bibleVersion
    - `dailyGospelProvider` conecta con perfil del usuario para versión de Biblia
  - **HomeScreen actualizada:**
    - Card compacta "EVANGELIO DEL DÍA" (católicos) / "LECTURA DEL DÍA" (otros)
    - Ring de Stories cuando hay contenido disponible
    - Badge "NUEVO" + botón play para Stories
    - Botón chat para conversar sobre el evangelio
  - **GospelStoriesScreen (NUEVA):**
    - Experiencia Instagram Stories a pantalla completa
    - 3 slides con progreso automático (8 segundos cada uno):
      - Slide 1: "En resumen..." - Resumen coloquial
      - Slide 2: "Concepto clave" - Frase impactante
      - Slide 3: "Para hoy..." - Ejercicio práctico
    - Navegación: tap izq/der, long press pausa
    - UI glassmorphism con animaciones suaves
    - **Bottom bar estilo Instagram:**
      - Campo de texto "Enviar mensaje" (pill-shaped)
      - Icono compartir (share_plus)
      - Al hacer focus: campo se expande + aparece botón "Enviar"
      - Usa `Listener` con `onPointerDown` para capturar tap antes del focus
    - **Integración con Chat:**
      - "Enviar" abre ChatScreen con el contenido del slide actual
      - Usa `rootNavigator: true` para ocultar bottom nav
      - Pasa `initialUserMessage` separado del contenido de la story
  - **ChatScreen actualizada:**
    - Acepta parámetros: `initialGospelText`, `initialGospelReference`, `initialUserMessage`
    - Nuevos topics: `evangelio_del_dia`, `lectura_del_dia`
    - **Flujo de conversación desde Stories:**
      - Mensaje 1 (IA): Contenido de la story (título + frase + referencia)
      - Mensaje 2 (Usuario): El mensaje que escribió
      - Mensaje 3 (IA): Respuesta (simulada hasta integrar T-0501)
    - **Input simplificado:** Container único con borde + TextField limpio (sin GlassContainer anidado)
    - Usa `rootNavigator: true` para ocultar bottom nav cuando viene de Stories
  - **Archivos creados/modificados:**
    - `lib/features/daily_gospel/domain/entities/daily_gospel.dart` - Entity con keyConcept, practicalExercise
    - `lib/features/daily_gospel/data/models/daily_gospel_model.dart` - Model con serialización
    - `lib/features/daily_gospel/data/datasources/daily_gospel_remote_datasource.dart` - Datasource
    - `lib/features/daily_gospel/presentation/screens/gospel_stories_screen.dart` - UI Stories con bottom bar Instagram
    - `lib/features/home/presentation/screens/home_screen.dart` - Card con ring Stories + navegación rootNavigator
    - `lib/features/chat/presentation/screens/chat_screen.dart` - Acepta initialUserMessage + input simplificado
    - `supabase/functions/fetch-daily-gospel/index.ts` - Edge Function GPT-5.2
    - `supabase/migrations/00012_add_verse_summary_column.sql` - Columna summary
    - `supabase/migrations/00013_add_gospel_story_columns.sql` - Columnas Stories

- [x] Feature: Sistema de Progreso y Racha (Daily Progress + Streak)
  - **Progreso diario:**
    - Barra de progreso en HomeScreen (0%, 33%, 66%, 100%)
    - Se actualiza según slides vistos de Stories
    - Almacenamiento local en SharedPreferences por fecha del gospel
  - **Racha (Streak):**
    - Calcula días consecutivos completados desde `daily_activity` (Supabase)
    - Se incrementa al ver las 3 Stories del día
    - Muestra emoji 🔥 + número en header de HomeScreen
  - **Optimistic UI:**
    - La racha se actualiza instantáneamente en la UI sin esperar a Supabase
    - Usa `StateProvider` para estado optimista + `FutureProvider` para datos reales
    - `streakDaysDisplayProvider` combina ambos: optimista si existe, sino Supabase
  - **Celebración:**
    - SnackBar dorado "¡Felicidades! 🔥 X días seguidos" al completar
    - Aparece inmediatamente gracias a Optimistic UI
  - **Archivos creados:**
    - `lib/features/home/data/datasources/daily_activity_remote_datasource.dart` - CRUD Supabase
    - `lib/features/home/presentation/providers/daily_progress_provider.dart` - Providers Riverpod
    - `lib/core/services/story_viewed_service.dart` - Almacenamiento local de slides vistos
    - `lib/core/providers/story_viewed_provider.dart` - Providers para slides vistos
  - **Bugs corregidos:**
    - Race condition en `StoryViewedService`: múltiples escrituras concurrentes sobrescribían datos. Solución: mutex con `Completer`
    - Completación solo desde cards secundarias: faltaba check en card principal del Evangelio
    - Shimmer invisible: colores demasiado similares (`#252540` → `#2D2D4A`). Solución: más contraste (`#3A3A5A` → `#5A5A7A`)

- [x] T-0501: Chat IA Funcional (Edge Function + Flutter)
  - **Edge Function `chat-send-message`:**
    - Procesa mensajes del chat y genera respuestas con OpenAI GPT-4o
    - Sistema de memorias: ai_memory (largo plazo usuario), context_summary (largo plazo conversación), últimos 10 mensajes (corto plazo)
    - Prompts personalizados por: denominación (9), origen cultural (4), edad (4), tema (12)
    - Auto-actualiza ai_memory y context_summary cada 20 mensajes
    - Defaults para perfiles incompletos
  - **Sistema de Prompts:**
    - `BASE_PROMPT`: Identidad del consejero cristiano
    - `DENOMINATION_PROMPTS`: católico, evangélico, pentecostal, bautista, adventista, testigo_jehova, mormón, otro, ninguna
    - `ORIGIN_PROMPTS`: mexico_centroamerica, caribe, sudamerica, espana
    - `AGE_PROMPTS`: teen, young_adult, adult, senior
    - `TOPIC_PROMPTS`: 12 temas hispanos (familia_separada, desempleo, etc.)
  - **Clean Architecture Flutter:**
    - Domain: `ChatMessage`, `Chat` entities + repository interface
    - Data: Models, Datasource (Edge Function), Repository impl
    - Presentation: `ChatNotifier` StateNotifier + providers
  - **ChatScreen actualizada:**
    - Usa `ConsumerStatefulWidget` con Riverpod
    - Carga historial existente al abrir
    - Envía mensajes a Edge Function
    - Estados: loading, sending, error
  - **Archivos creados:**
    - `supabase/functions/chat-send-message/index.ts`
    - `supabase/functions/chat-send-message/prompts.ts`
    - `supabase/functions/chat-send-message/deno.json`
    - `lib/features/chat/domain/entities/chat_message.dart`
    - `lib/features/chat/domain/repositories/chat_repository.dart`
    - `lib/features/chat/data/models/chat_message_model.dart`
    - `lib/features/chat/data/datasources/chat_remote_datasource.dart`
    - `lib/features/chat/data/repositories/chat_repository_impl.dart`
    - `lib/features/chat/presentation/providers/chat_provider.dart`
  - **Archivo modificado:**
    - `lib/features/chat/presentation/screens/chat_screen.dart`

- [x] Feature: Sistema de Chat Híbrido (estilo ChatGPT)
  - **Migración 00014:** `last_summary_message_count` para tracking de regeneración de resúmenes
  - **Migración 00015:**
    - Añade topics `evangelio_del_dia` y `lectura_del_dia` para Stories
    - Quita constraint UNIQUE(user_id, topic_key) para permitir múltiples chats
    - Añade índice `idx_chats_user_id` para rendimiento
  - **Edge Function actualizada:**
    - `topic_key` ahora es opcional (null = chat libre)
    - Si no hay topic, usa prompt genérico "otro"
    - Soporta tanto chats libres como chats de topic
  - **Flutter - Nuevo sistema de identificadores:**
    - `ChatIdentifier`: Puede ser `newChat()`, `existing(id)` o `topic(key)`
    - Provider family ahora usa `ChatIdentifier` como key
    - Soporta cargar chat por ID, por topic, o crear nuevo
  - **ChatScreen rediseñada:**
    - Acepta parámetros opcionales: `chatId`, `topicKey`
    - Muestra sugerencias de inicio cuando el chat está vacío
    - 5 sugerencias predefinidas: oración, Biblia, ansiedad, familia, otro
  - **ChatListScreen rediseñada:**
    - Botón "Nueva conversación" prominente arriba
    - Lista de conversaciones recientes con preview y timestamp
    - Sección "Temas guiados" colapsada por defecto con 10 topics
  - **Nuevas rutas:**
    - `/chat/new` → Chat libre nuevo
    - `/chat/id/:chatId` → Chat existente por ID
    - `/chat/topic/:topicKey` → Chat por topic (Stories, temas guiados)
  - **Archivos creados/modificados:**
    - `supabase/migrations/00014_add_chat_summary_tracking.sql`
    - `supabase/migrations/00015_chat_hybrid_system.sql`
    - `supabase/functions/chat-send-message/combined.ts` (topic_key opcional)
    - `lib/features/chat/domain/entities/chat_message.dart` (Chat.topicKey nullable + title)
    - `lib/features/chat/data/models/chat_message_model.dart`
    - `lib/features/chat/data/datasources/chat_remote_datasource.dart` (getChatById)
    - `lib/features/chat/data/repositories/chat_repository_impl.dart`
    - `lib/features/chat/presentation/providers/chat_provider.dart` (ChatIdentifier)
    - `lib/features/chat/presentation/screens/chat_screen.dart` (sugerencias)
    - `lib/features/chat/presentation/screens/chat_list_screen.dart` (rediseño)
    - `lib/core/router/app_router.dart` (nuevas rutas)
    - `lib/core/constants/route_constants.dart`

- [x] Feature: Correcciones del Flujo Stories → Chat
  - **IMPORTANTE - Contenido de Story como mensaje 'assistant':**
    - Cuando el usuario envía un mensaje desde Stories, el contenido de la Story se guarda PRIMERO como mensaje con `role: 'assistant'` en la BD
    - Esto hace que la IA SIEMPRE tenga el contexto de la lectura bíblica (forma parte de los últimos 12 mensajes)
    - El usuario VE este mensaje en el chat (no es invisible)
    - Edge Function recibe `system_message` y lo inserta como 'assistant' antes del mensaje del usuario
  - **Problema 1: Flash de Home al navegar**
    - Causa: Stories hacía `pop()` y luego Home hacía `push()`
    - Solución: Usar `pushReplacement` desde Stories directo a Chat
    - Archivo: `gospel_stories_screen.dart` - método `_sendMessage()`
  - **Problema 2: Mensaje duplicado del usuario**
    - Causa: `addInitialMessages()` añadía el mensaje Y `sendMessage()` también
    - Solución: Solo añadir mensaje del asistente en `addInitialMessages()`, dejar que `sendMessage()` añada el del usuario
    - Archivo: `chat_screen.dart` - método `_initializeChat()`
  - **Problema 3: IA sin contexto de la Story**
    - Causa: Solo se enviaba el mensaje del usuario, no el contenido de la Story
    - Solución: Añadir parámetro `systemContext` a `sendMessage()` que incluye el texto de la Story
    - El contexto se envía a la Edge Function pero NO se muestra en el chat
    - Formato: `[Contexto de la lectura bíblica:]\n{texto}\n\n[Mensaje del usuario:]\n{mensaje}`
    - Archivos: `chat_provider.dart`, `chat_screen.dart`
  - **Problema 4: Cargaba chat viejo con mismo topic**
    - Causa: `getChatByTopic()` encontraba chat existente
    - Solución: Cuando viene de Stories (`initialGospelText != null`), usar `ChatIdentifier.newChat()` en lugar de `topic()`
    - Archivo: `chat_screen.dart` - `initState()`
  - **HomeScreen actualizada:**
    - Ahora pasa `topicKey` a `GospelStoriesScreen` para que llegue hasta `ChatScreen`

- [x] Feature: Correcciones del Sistema de Conversaciones
  - **Problema: "Nueva conversación" reutilizaba chat viejo**
    - Causa: Riverpod cacheaba el provider por `ChatIdentifier(null, null)`
    - Solución: Añadir método `resetForNewChat()` en `ChatNotifier` que limpia el estado
    - Se llama en `_initializeChat()` cuando `isNewChat && initialGospelText == null`
    - Archivo: `chat_provider.dart`
  - **Problema: Lista de chats no se actualizaba al volver**
    - Causa: No se refrescaba el provider al hacer `pop()` del chat
    - Solución: Hacer `await` en la navegación y luego incrementar `userChatsRefreshProvider`
    - Afecta: Botón "Nueva conversación", tiles de chats recientes, chips de temas guiados
    - Archivo: `chat_list_screen.dart`
  - **Comportamiento actual del sistema de chats:**
    | Acción | Comportamiento |
    |--------|----------------|
    | Nueva conversación | SIEMPRE crea chat nuevo |
    | Click chat reciente | Continúa ESE chat específico |
    | Temas guiados | Continúa chat existente del topic (o crea nuevo) |
    | Desde Stories | SIEMPRE crea chat nuevo |

- [x] Feature: Sistema de Títulos de Conversaciones
  - **Generación automática de títulos:**
    - Edge Function genera título con GPT-4o-mini después del primer mensaje
    - Condición: `messageCount == 2 AND chat.title IS NULL`
    - Título máximo 50 caracteres, descriptivo del tema
    - Se genera UNA SOLA VEZ, después solo edición manual
  - **CRUD de títulos en Flutter:**
    - `ChatState.title`: Campo para almacenar título en el estado
    - `ChatState.displayTitle`: Getter que prioriza título > topic > "Nueva conversación"
    - `ChatNotifier.updateTitle()`: Actualiza título en Supabase y estado local
    - `ChatNotifier.deleteChat()`: Elimina chat y sus mensajes
  - **Menú de opciones en ChatScreen:**
    - PopupMenuButton reemplaza IconButton vacío
    - Opciones: "Renombrar" y "Eliminar"
    - Diálogos personalizados con tema glassmorphism
    - Refresca lista de chats al eliminar
  - **Edge Function actualizada:**
    - Nueva función `generateChatTitle()` con GPT-4o-mini
    - Nuevo prompt `CHAT_TITLE_PROMPT` con reglas específicas
    - Respuesta incluye `title` (generado o existente)
    - Interface `Chat` incluye campo `title`
  - **Archivos modificados:**
    - `supabase/functions/chat-send-message/combined.ts`
    - `lib/features/chat/domain/repositories/chat_repository.dart`
    - `lib/features/chat/data/datasources/chat_remote_datasource.dart`
    - `lib/features/chat/data/repositories/chat_repository_impl.dart`
    - `lib/features/chat/presentation/providers/chat_provider.dart`
    - `lib/features/chat/presentation/screens/chat_screen.dart`

- [x] Feature: Stories guardadas como mensajes en BD + Respuestas cortas
  - **Contenido de Stories persistido:**
    - Al enviar mensaje desde Stories, el contenido se guarda como mensaje `role: 'assistant'` en BD
    - Esto permite que la IA siempre tenga contexto (forma parte de últimos 12 mensajes)
    - Se incluye en `context_summary` cuando se regenera cada 20 mensajes
    - El usuario ve el contenido de la Story en el historial del chat
  - **Flujo actual:**
    ```
    Story → mensaje 'assistant' en BD (contenido visible)
    Usuario → mensaje 'user' en BD
    IA → mensaje 'assistant' en BD
    ```
  - **Parámetro renombrado:** `systemContext` → `systemMessage` en toda la cadena
  - **Recarga de mensajes:** Cuando hay `systemMessage`, el provider recarga todos los mensajes de BD para mostrar inmediatamente
  - **Respuestas más cortas (estilo WhatsApp):**
    - BASE_PROMPT actualizado con instrucciones más agresivas de brevedad
    - Máximo 1-3 oraciones por respuesta
    - Prohibido: párrafos largos, listas, bullet points
    - Citas bíblicas máximo 1 cada 4-5 mensajes
    - `max_completion_tokens` reducido de 800 a 400
  - **Archivos modificados:**
    - `supabase/functions/chat-send-message/combined.ts` - Guarda `system_message` como 'assistant', nuevo BASE_PROMPT
    - `lib/features/chat/data/datasources/chat_remote_datasource.dart` - Param `systemMessage`
    - `lib/features/chat/data/repositories/chat_repository_impl.dart` - Param `systemMessage`
    - `lib/features/chat/domain/repositories/chat_repository.dart` - Interfaz actualizada
    - `lib/features/chat/presentation/providers/chat_provider.dart` - Param `systemMessage` + recarga de mensajes

- [x] Feature: Títulos de chat estilo ChatGPT
  - **Nuevo CHAT_TITLE_PROMPT:**
    - 2-5 palabras máximo (antes hasta 50 caracteres)
    - Estilo directo sin florituras: "Oración por mamá", "Dudas bautismo", "Hola"
    - Prohibido: "Conversación sobre...", "Reflexión de...", "Interacción amistosa..."
    - Ejemplos buenos vs malos incluidos en el prompt
  - **Archivo modificado:**
    - `supabase/functions/chat-send-message/combined.ts` - Nuevo CHAT_TITLE_PROMPT

- [x] Feature: UI "Nueva conversación" estilo ChatGPT
  - **Antes:** Mensaje largo de bienvenida + 5 tiles grandes + input pequeño abajo
  - **Después:** Icono centrado + "¿En qué te puedo ayudar?" + 3 chips pequeños
  - **Comportamiento de chips:**
    - Al tocar → rellena el input (NO envía directo)
    - Usuario completa la frase y envía
    - Ejemplo: toca "🙏 Oración para..." → input muestra "Necesito una oración para "
  - **Chips disponibles:**
    - 🙏 "Oración para..." → "Necesito una oración para "
    - 📖 "Duda sobre..." → "Tengo una duda sobre "
    - 💬 "Hablar de..." → "Me gustaría hablar de "
  - **Código eliminado:**
    - `_buildAIGreetingBubble()` - mensaje largo de bienvenida
    - `_StarterSuggestionTile` - tiles grandes
  - **Código añadido:**
    - `_buildSuggestionChips()` - chips pequeños horizontales
    - `_buildChip()` - widget individual de chip
    - `_fillInputWith()` - rellena input con texto y pone focus
    - `_messageFocusNode` - para controlar el focus del input
  - **Archivo modificado:**
    - `lib/features/chat/presentation/screens/chat_screen.dart`

- [x] T-0301: Auth Email (Upgrade de Cuenta Anónima) - COMPLETO
  - **Objetivo:** Permitir que usuarios anónimos vinculen email/password para no perder datos
  - **Clean Architecture implementada:**
    - `AuthRepository` interface + `AuthRepositoryImpl` con Supabase
    - `AuthNotifier` StateNotifier para operaciones de auth
    - Providers: `isAnonymousProvider`, `authStatusProvider`, `currentEmailProvider`, `isEmailVerifiedProvider`
  - **Pantallas nuevas:**
    - `LinkEmailScreen` - Formulario para vincular email/password
    - `VerifyEmailScreen` - "Revisa tu correo" con countdown para reenvío + botón "Ya verifiqué"
    - `LoginScreen` - Para usuarios que reinstalen la app + "¿Olvidaste tu contraseña?"
    - `ResetPasswordScreen` - Nueva contraseña después de recovery link
  - **Deep Links configurados:**
    - **Supabase Dashboard:** Site URL = `com.bibliachats://login-callback`
    - **Android:** intent-filter en AndroidManifest.xml para scheme `com.bibliachats`
    - **iOS:** CFBundleURLTypes en Info.plist para scheme `com.bibliachats`
    - **Flutter:** PKCE auth flow en `Supabase.initialize()`
    - **NOTA:** Deep links solo funcionan en móvil, no en web/desktop
  - **SplashScreen actualizada:**
    - Detecta email pendiente de verificación → navega a VerifyEmailScreen
    - Escucha `AuthChangeEvent.passwordRecovery` → navega a ResetPasswordScreen
  - **Auth providers reactivos:**
    - Todos los providers (`isAnonymousProvider`, `isEmailVerifiedProvider`, `currentEmailProvider`, `authStatusProvider`) ahora dependen de `authStateChangesProvider`
    - Se actualizan automáticamente cuando cambia el estado de auth
  - **Fix "Olvidé contraseña":**
    - `sendPasswordResetEmail()` NO establece `state.success` para evitar navegación automática a Home
    - Solo retorna `true/false` sin cambiar estado del notifier
  - **Flujo Password Recovery:**
    ```
    LoginScreen → "¿Olvidaste tu contraseña?" → Supabase envía email
    Usuario hace clic en enlace → Deep link abre app → SplashScreen detecta passwordRecovery
    → ResetPasswordScreen → Nueva contraseña → signOut() → LoginScreen (confirma con nueva contraseña)
    ```
  - **SettingsScreen actualizada:**
    - Muestra "Guardar mi cuenta" (destacado) solo si es anónimo
    - Muestra "Cuenta vinculada" + email si ya vinculó
    - Badge "Sin guardar" junto a "Cuenta anónima"
    - Dialog de advertencia al hacer logout si es anónimo
  - **Fix bug logout:** Ahora navega a Splash después de `signOut()`
  - **Email como query parameter:**
    - VerifyEmailScreen recibe `email` via URL en lugar de provider
    - Soluciona que el email no se mostraba (Supabase guarda en `new_email` hasta confirmar)
  - **Rutas añadidas:**
    - `/auth/login` - Login con email
    - `/auth/link-email` - Vincular email
    - `/auth/verify-email?email=xxx` - Verificar email (con query param)
    - `/auth/reset-password` - Nueva contraseña
  - **Archivos creados:**
    - `lib/features/auth/domain/repositories/auth_repository.dart`
    - `lib/features/auth/data/repositories/auth_repository_impl.dart`
    - `lib/features/auth/presentation/providers/auth_provider.dart`
    - `lib/features/auth/presentation/screens/link_email_screen.dart`
    - `lib/features/auth/presentation/screens/verify_email_screen.dart`
    - `lib/features/auth/presentation/screens/login_screen.dart`
    - `lib/features/auth/presentation/screens/reset_password_screen.dart`
  - **Archivos modificados:**
    - `lib/features/settings/presentation/screens/settings_screen.dart`
    - `lib/features/auth/presentation/screens/splash_screen.dart`
    - `lib/core/router/app_router.dart`
    - `lib/core/constants/route_constants.dart`
    - `lib/main.dart` - PKCE auth flow
    - `android/app/src/main/AndroidManifest.xml` - Deep link intent-filter
    - `ios/Runner/Info.plist` - CFBundleURLTypes

- [x] Feature: Login para usuarios existentes
  - **"¿Ya tienes cuenta?" en Onboarding:**
    - Enlace añadido en `OnboardingWelcomePage`
    - Callback `onLogin` navega a LoginScreen
  - **Archivo modificado:**
    - `lib/features/onboarding/presentation/widgets/onboarding_welcome_page.dart`
    - `lib/features/onboarding/presentation/screens/onboarding_screen.dart`

- [x] Feature: Botón "Atrás" en Onboarding
  - **Navegación hacia atrás:**
    - Botón `<` en la barra de progreso
    - Método `_previousPage()` en OnboardingScreen
    - Solo visible cuando `currentPage > 0`
  - **Archivo modificado:**
    - `lib/features/onboarding/presentation/screens/onboarding_screen.dart`

- [x] Feature: Estilo unificado página de país
  - **Problema:** La página de selección de país tenía estilos diferentes al resto
  - **Cambios aplicados:**
    - Badge del versículo: Ahora usa `BackdropFilter` + icono libro + borde dorado (igual que `OnboardingSelectionPage`)
    - Texto bíblico: Cambiado de `headlineSmall` bold a `titleLarge` italic con `textSecondary`
    - Pregunta: Ahora en `GlassContainer` con barra dorada lateral
    - Alineación: `crossAxisAlignment: CrossAxisAlignment.start` + botón centrado con `Center`
  - **Archivo modificado:**
    - `lib/features/onboarding/presentation/widgets/onboarding_country_page.dart`

- [x] T-0401: Integración RevenueCat SDK (Flutter)
  - **Configuración RevenueCat Dashboard:**
    - Proyecto: "Biblia Chat Cristiano"
    - App iOS añadida con P8 In-App Purchase Key
    - API Key iOS: `appl_gZbgVJRKEBpZNBeYWpdisQiQjYw`
    - Entitlement: `premium`
    - Products: `ee.bikain.bibliachat.premium.monthly` ($14.99), `ee.bikain.bibliachat.premium.annual` ($39.99)
    - Offering: `default` con packages `$rc_monthly` y `$rc_annual`
  - **App Store Connect:**
    - App creada: "Biblia Chat Cristiano"
    - Bundle ID: `ee.bikain.bibliachat`
    - Subscription Group: "Biblia Chat Premium"
    - In-App Purchases configurados (mensual y anual)
  - **Flutter - Servicio RevenueCat:**
    - `RevenueCatService` singleton con métodos: `init()`, `getOfferings()`, `purchasePackage()`, `restorePurchases()`, `checkPremiumStatus()`, `getCustomerInfo()`
    - Inicialización con `appUserID = supabaseUserId`
    - Stream de `CustomerInfo` para cambios en tiempo real
  - **Flutter - Providers:**
    - `SubscriptionState`: isPremium, isLoading, error, offerings, isPurchasing
    - `SubscriptionNotifier`: maneja compras, restauraciones, refresco
    - `isPremiumProvider`, `offeringsProvider`, `monthlyPackageProvider`, `annualPackageProvider`
  - **Flutter - PaywallScreen:**
    - UI glassmorphism con header, features list, plan cards
    - Plan anual destacado con badge "MAS POPULAR"
    - Ahorro mostrado: "3 días gratis + ahorra 50%"
    - Botón "Restaurar compras" + términos
  - **Bundle ID actualizado:**
    - iOS: `ee.bikain.bibliachat` (project.pbxproj)
    - Android: `ee.bikain.bibliachat` (build.gradle + MainActivity.kt)
  - **Inicialización en SplashScreen:**
    - RevenueCat se inicializa después de Supabase auth
    - Funciona para usuarios existentes y nuevos (anónimos)
  - **Archivos creados:**
    - `lib/core/services/revenue_cat_service.dart`
    - `lib/features/subscription/presentation/providers/subscription_provider.dart`
    - `lib/features/subscription/presentation/screens/paywall_screen.dart`
  - **Archivos modificados:**
    - `lib/core/router/app_router.dart` - Ruta `/paywall`
    - `lib/core/constants/route_constants.dart` - Constante `paywall`
    - `lib/features/auth/presentation/screens/splash_screen.dart` - Init RevenueCat
    - `app_flutter/ios/Runner.xcodeproj/project.pbxproj` - Bundle ID
    - `app_flutter/android/app/build.gradle` - Application ID
    - `app_flutter/android/app/src/main/kotlin/ee/bikain/bibliachat/MainActivity.kt` - Package name
  - **NOTA:** Android pendiente de configurar en RevenueCat (se validará iOS primero)

- [x] T-0402/T-0404: Paywall estilo Bible Chat + Límite de mensajes
  - **PaywallScreen rediseñada:**
    - Botón X discreto (color gris claro, muy pequeño)
    - Toggle para activar trial de 3 días en plan mensual
    - Plan anual sin trial (pago directo)
    - Navegación: Onboarding → Paywall → Home
    - Mock data para web preview (RevenueCat no funciona en web)
  - **Sistema de límite de mensajes:**
    - 5 mensajes/día para usuarios sin suscripción
    - Contador almacenado en BD (`daily_activity.messages_sent`)
    - Badge de mensajes restantes en ChatScreen
    - Diálogo de límite alcanzado con opción "Ver planes"
    - Premium = ilimitado
  - **Archivos creados:**
    - `lib/core/services/message_limit_service.dart` - Lógica de límite
    - `lib/features/chat/presentation/providers/message_limit_provider.dart` - Providers
    - `supabase/migrations/00016_add_messages_sent_column.sql` - Migración BD
  - **Archivos modificados:**
    - `lib/features/subscription/presentation/screens/paywall_screen.dart` - UI Bible Chat
    - `lib/features/chat/presentation/screens/chat_screen.dart` - Verificación límite
    - `lib/features/onboarding/presentation/screens/onboarding_screen.dart` - Navega a paywall

- [x] EPIC 9: Planes de Estudio (7 Pecados Capitales)
  - **7 planes temáticos:** Soberbia→Humildad, Avaricia→Generosidad, Lujuria→Pureza, Ira→Paciencia, Gula→Templanza, Envidia→Gratitud, Pereza→Diligencia
  - **Estructura por día:** Versículo + Reflexión (150-300 palabras) + Ejercicio práctico + Pregunta para chat
  - **Migraciones:**
    - `00017_add_practical_exercise_to_plan_days.sql` - Columna para ejercicios
    - `00018_seed_seven_sins_plans.sql` - 7 planes con 49 días de contenido
  - **Clean Architecture Flutter:**
    - Domain: `Plan`, `PlanDay`, `UserPlan`, `UserPlanDay` entities + `StudyRepository`
    - Data: Models con serialización JSON, `StudyRemoteDatasource` con Supabase
    - Presentation: `StudyScreen`, `PlanDetailScreen`, `PlanDayScreen` + providers Riverpod
  - **Tabla `user_plans`:** Usa `status` enum (`in_progress`, `completed`, `abandoned`) en lugar de `is_completed` boolean
  - **Tabla `user_plan_days`:** Usa `day_number` + `user_answer` + `completed_via` (no `plan_day_id` ni `is_completed`)
  - **Funcionalidades:**
    - Ver lista de planes disponibles (oculta el plan activo)
    - Iniciar un plan (solo uno activo a la vez)
    - Al iniciar plan → navega directo al día 1
    - Ver contenido del día actual
    - Completar día y avanzar al siguiente
    - Abandonar plan (menú ⋮ en PlanDayScreen)
    - Reiniciar plan abandonado/completado (upsert en vez de insert)
    - **Chat integrado por plan** (un chat por plan, compartido entre todos los días)
    - Barra de progreso animada
    - Celebración al completar plan
  - **Chat del plan:**
    - Columna `chat_id` en `user_plans` (migración 00019)
    - Al pulsar "Hablar con Biblia Chat" → crea chat con título del plan (si no existe)
    - La pregunta del día se envía como mensaje `assistant` para dar contexto
    - Todos los días del plan comparten el mismo chat (historial continuo)
    - Usa `pendingPlanContentProvider` porque GoRouter extra no funciona con ShellRoute
    - Auto-completa el día al pulsar chat (el usuario interactuó con el contenido)
  - **Contexto IA para planes:**
    - 7 `topic_key` específicos: `plan_soberbia`, `plan_avaricia`, `plan_lujuria`, `plan_ira`, `plan_gula`, `plan_envidia`, `plan_pereza`
    - 7 `TOPIC_PROMPTS` en Edge Function con contexto del pecado/virtud
    - El chat del plan guarda `topic_key` para que la IA sepa el contexto
    - Método `getPlanTopicKey(planId)` mapea plan ID → topic_key
  - **Rutas añadidas:**
    - `/study/plan/:planId` - Detalle del plan
    - `/study/day/:userPlanId` - Día actual del plan activo
  - **Archivos creados:**
    - `lib/features/study/domain/entities/` - plan.dart, plan_day.dart, user_plan.dart, user_plan_day.dart
    - `lib/features/study/domain/repositories/study_repository.dart`
    - `lib/features/study/data/models/` - Todos los models
    - `lib/features/study/data/datasources/study_remote_datasource.dart`
    - `lib/features/study/data/repositories/study_repository_impl.dart`
    - `lib/features/study/presentation/providers/study_provider.dart`
    - `lib/features/study/presentation/screens/plan_detail_screen.dart`
    - `lib/features/study/presentation/screens/plan_day_screen.dart`
  - **Archivos modificados:**
    - `lib/features/study/presentation/screens/study_screen.dart` - Conectado a Supabase
    - `lib/core/router/app_router.dart` - Nuevas rutas
    - `lib/core/widgets/shimmer_loading.dart` - Añadido `ShimmerLoading` class
    - `lib/features/subscription/presentation/screens/paywall_screen.dart` - Fix overflow

- [x] Feature: Indicadores visuales de planes completados
  - **Problema:** Al completar un plan de 7 días, no había indicador visual. Si el usuario volvía a entrar, podía "completar" días de nuevo.
  - **Solución implementada:**
  - **StudyScreen:**
    - Badge verde "✓ Completado" en los planes terminados (junto a "7 días")
    - Usa `allUserPlansProvider` para cargar todos los `user_plans` del usuario
    - Compara `userPlan.isCompleted` (getter del entity, NO string)
  - **PlanDetailScreen:**
    - Banner verde "¡Plan completado!" cuando el plan tiene `status: completed`
    - Botón cambia de "Comenzar plan" (dorado) a "Revisar contenido" (verde)
    - Navega a `/study/day/:userPlanId?readOnly=true&day=1`
  - **PlanDayScreen - Modo readOnly:**
    - Parámetros: `readOnly: bool` y `day: int?`
    - Si `readOnly == true`:
      - Oculta botón "Completar día" del bottomNavigationBar
      - Oculta menú ⋮ (abandonar plan)
      - Muestra navegación entre días: "< Día anterior | Día siguiente >"
      - "Hablar con Biblia Chat" NO envía `pendingPlanContentProvider` (evita spam)
    - Provider `readOnlyDayDataProvider` para cargar cualquier día (no solo el actual)
    - Clase `ReadOnlyDayParams` para los parámetros del provider family
  - **app_router.dart:**
    - Ruta `/study/day/:userPlanId` ahora parsea query params `readOnly` y `day`
  - **Bug corregido:**
    - `userPlan.status` es un enum `PlanStatus`, NO un string
    - Comparar con `userPlan.isCompleted` (getter del entity) en lugar de `== 'completed'`
  - **Archivos modificados:**
    - `lib/features/study/presentation/screens/study_screen.dart` - Badge + provider
    - `lib/features/study/presentation/screens/plan_detail_screen.dart` - Banner + botón
    - `lib/features/study/presentation/screens/plan_day_screen.dart` - Modo readOnly completo
    - `lib/features/study/presentation/providers/study_provider.dart` - `allUserPlansProvider`
    - `lib/core/router/app_router.dart` - Query params

- [x] Feature: Tarjeta de plan activo en HomeScreen
  - **Objetivo:** Acceso rápido al plan activo desde la pantalla principal
  - **Implementación:**
    - Nueva tarjeta `_ActivePlanCard` al final de las content cards
    - Separada visualmente con divider "TU PLAN ACTIVO"
    - Muestra: emoji, nombre del plan, "Día X de Y", barra de progreso
    - Tap → navega a `/study/day/:userPlanId`
    - Usa `activePlanDataProvider` existente
  - **Archivos modificados:**
    - `lib/features/home/presentation/screens/home_screen.dart` - Nueva tarjeta

- [x] Feature: Reinicio correcto de planes de estudio
  - **Problema:** Al reiniciar un plan, el progreso mostraba porcentaje incorrecto (días anteriores no se borraban)
  - **Causa:** Faltaba DELETE de `user_plan_days` al reiniciar + faltaba política RLS DELETE
  - **Solución:**
    - `study_remote_datasource.dart`: Al reiniciar plan, primero borra `user_plan_days` antiguos
    - Migración `00020`: Política RLS DELETE para `user_plan_days` (via JOIN a `user_plans`)
  - **Archivos modificados:**
    - `lib/features/study/data/datasources/study_remote_datasource.dart` - Delete antes de restart
    - `supabase/migrations/00020_add_user_plan_days_delete_policy.sql` - Nueva política RLS

- [x] Feature: Chat integrado en planes de estudio (fix foreign key)
  - **Problema:** "Hablar con Biblia Chat" fallaba con error de foreign key
  - **Causa:** Los `topic_key` de planes (`plan_soberbia`, etc.) no existían en `chat_topics`
  - **Solución:**
    - Migración `00021`: Inserta 7 topic keys de planes en `chat_topics`
    - Columnas: `key`, `title`, `description`, `sort_order`
  - **Topics añadidos:**
    - `plan_soberbia`, `plan_avaricia`, `plan_lujuria`, `plan_ira`
    - `plan_gula`, `plan_envidia`, `plan_pereza`
  - **Archivos creados:**
    - `supabase/migrations/00021_add_plan_topic_keys.sql`

- [x] T-0308: Borrar Cuenta y Datos (GDPR-compliant)
  - **Edge Function `delete-account`:**
    - Archiva datos pseudonimizados antes de borrar (GDPR-compliant)
    - Usa SHA256 hash del user_id para pseudonimización
    - Permite buscar conversaciones si usuario se identifica después
  - **Flujo de borrado:**
    1. Archiva en `deleted_user_archives`: demografía, mensajes, progreso planes
    2. Borra usuario de `auth.users` (CASCADE elimina todos los datos)
  - **Retención:** 3 años para defensa legal
  - **PII eliminada:** nombre, email, device tokens, rc_app_user_id
  - **Datos archivados:** mensajes (sin user_id), demografía, métricas agregadas
  - **Migración:** `00022_create_deleted_user_archives.sql`
  - **Archivos creados:**
    - `supabase/migrations/00022_create_deleted_user_archives.sql`
    - `supabase/functions/delete-account/index.ts`
  - **Archivos modificados:**
    - `lib/features/auth/domain/repositories/auth_repository.dart` - `deleteAccount()`
    - `lib/features/auth/data/repositories/auth_repository_impl.dart` - Implementación
    - `lib/features/auth/presentation/providers/auth_provider.dart` - Notifier
    - `lib/features/settings/presentation/screens/settings_screen.dart` - Botón conectado

- [x] T-0307: Editar Perfil desde Settings
  - **ProfileEditScreen:**
    - Pantalla completa de edición con todas las preferencias del usuario
    - Secciones: Datos Personales, Fe y Creencias, Origen, Recordatorio
  - **Campos editables:**
    - Nombre (TextField)
    - Género (Hombre/Mujer con iconos)
    - Denominación (10 opciones con ChoiceChips)
    - País (Dropdown con banderas, idéntico al onboarding) → guarda `origin` (origin_group) + `country_code` (ISO)
    - Grupo de edad (ChoiceChips)
    - Recordatorio (Toggle + Time picker)
  - **ProfileEditNotifier:**
    - StateNotifier con `hasChanges` para detectar cambios sin guardar
    - Diálogo de confirmación al salir con cambios pendientes
    - Guarda con `UserProfileRepository.updateProfile()`
  - **SettingsScreen actualizada:**
    - Muestra valores reales del perfil (versión Biblia, recordatorio)
    - Todos los items de Preferencias navegan a ProfileEditScreen
    - Eliminada opción "Tema" (no implementado aún)
  - **Archivos creados:**
    - `lib/features/profile/presentation/providers/profile_edit_provider.dart`
    - `lib/features/profile/presentation/screens/profile_edit_screen.dart`
  - **Archivos modificados:**
    - `lib/core/router/app_router.dart` - Ruta `/settings/edit`
    - `lib/core/constants/route_constants.dart` - Constante `profileEdit`
    - `lib/features/settings/presentation/screens/settings_screen.dart` - Valores reales + navegación

- [x] Feature: Eliminar mensaje individual
  - **Funcionalidad:** Borrar un mensaje específico del chat con long press
  - **UI:**
    - Long press en cualquier mensaje → Bottom sheet con opción "Eliminar mensaje"
    - SnackBar de confirmación "Mensaje eliminado"
  - **Implementación:**
    - `deleteMessage(messageId)` en datasource, repository y provider
    - Elimina de `chat_messages` por `id`
    - Actualiza estado local inmediatamente
  - **Archivos modificados:**
    - `lib/features/chat/data/datasources/chat_remote_datasource.dart` - `deleteMessage()`
    - `lib/features/chat/domain/repositories/chat_repository.dart` - Interfaz
    - `lib/features/chat/data/repositories/chat_repository_impl.dart` - Implementación
    - `lib/features/chat/presentation/providers/chat_provider.dart` - `ChatNotifier.deleteMessage()`
    - `lib/features/chat/presentation/screens/chat_screen.dart` - `_MessageBubble` con long press + `_deleteMessage()`

- [x] T-0511: Guardar Mensaje ❤️ + "Mis Reflexiones"
  - **Funcionalidad:** Guardar mensajes de la IA con botón ❤️ y ver en pantalla dedicada
  - **Tabla BD usada:** `saved_messages` (ya existía con RLS correcta)
  - **Clean Architecture implementada:**
    - Domain: `SavedMessage` entity + `SavedMessageRepository` interface
    - Data: Model, RemoteDatasource (Supabase con JOIN), RepositoryImpl
    - Presentation: Providers (savedMessageIdsProvider, savedMessagesProvider, SavedMessageNotifier)
  - **UI del botón ❤️:**
    - Nuevo widget `_SaveButton` en chat_screen.dart (reemplaza `_ActionButton` para el corazón)
    - Icono cambia de `favorite_border` a `favorite` cuando está guardado
    - Color dorado + borde cuando está activo
    - SnackBar de confirmación al guardar/desguardar
  - **Pantalla "Mis Reflexiones":**
    - Acceso desde Settings → Preferencias → "Mis Reflexiones"
    - Lista con glassmorphism y animaciones staggered
    - Cada item muestra: contenido, título del chat, fecha guardada
    - Botón trash para eliminar con bottom sheet de confirmación
    - Empty state con instrucciones
    - Pull-to-refresh
  - **Archivos creados:**
    - `lib/features/saved_messages/domain/entities/saved_message.dart`
    - `lib/features/saved_messages/domain/repositories/saved_message_repository.dart`
    - `lib/features/saved_messages/data/models/saved_message_model.dart`
    - `lib/features/saved_messages/data/datasources/saved_message_remote_datasource.dart`
    - `lib/features/saved_messages/data/repositories/saved_message_repository_impl.dart`
    - `lib/features/saved_messages/presentation/providers/saved_message_provider.dart`
    - `lib/features/saved_messages/presentation/screens/saved_messages_screen.dart`
  - **Archivos modificados:**
    - `lib/features/chat/presentation/screens/chat_screen.dart` - `_SaveButton` + import
    - `lib/features/settings/presentation/screens/settings_screen.dart` - Item "Mis Reflexiones"
    - `lib/core/router/app_router.dart` - Ruta `/saved-messages`
    - `lib/core/constants/route_constants.dart` - Constante `savedMessages`

- [x] T-0512: Compartir Reflexión como Imagen - COMPLETADO
  - **Funcionalidad:** Compartir contenido de Stories como imagen personalizable
  - **ShareImageScreen (editor fullscreen estilo Instagram):**
    - Preview fullscreen (lo que ves = lo que compartes)
    - Controles compactos arriba con iconos: paleta (fondos), "Aa" (fuentes), "aA" (tamaño)
    - Opciones se expanden al tocar cada icono (AnimatedSize)
    - 5 fondos predefinidos (gradientes: Noche, Dorado, Púrpura, Esperanza, Atardecer)
    - Selector de foto de galería con `image_picker`
    - 4 fuentes Google Fonts: Lora, Playfair Display, Nunito, Merriweather
    - Slider de tamaño de fuente (14-32px)
    - Pellizcar para zoom + arrastrar para mover texto
    - Botón Reset cuando hay transformaciones
    - OverflowBox permite que el texto se salga sin error
    - Captura con `screenshot` package a 3x resolución
  - **Bottom sheet con 2 opciones:**
    - Compartir (abre selector de apps del sistema)
    - Guardar en galería (usa paquete `gal`)
  - **Otros cambios:**
    - Título de slide cambiado de "En resumen..." a "Reflexión del día"
    - Al compartir solo se envía la imagen (sin texto adicional)
  - **Dependencias añadidas:**
    - `screenshot: ^3.0.0` - Capturar widget como imagen
    - `image_picker: ^1.0.7` - Seleccionar foto de galería
    - `google_fonts: ^6.1.0` - Fuentes personalizadas
    - `gal: ^2.3.0` - Guardar imagen en galería
  - **Permisos configurados:**
    - iOS: `NSPhotoLibraryUsageDescription` en Info.plist
    - Android: `READ_EXTERNAL_STORAGE` + `READ_MEDIA_IMAGES` en AndroidManifest.xml
  - **Archivos creados:**
    - `lib/features/daily_gospel/presentation/screens/share_image_screen.dart`
  - **Archivos modificados:**
    - `lib/features/daily_gospel/presentation/screens/gospel_stories_screen.dart` - Abre ShareImageScreen
    - `pubspec.yaml` - Nuevas dependencias + dependency_override para app_links
  - **Pendiente:** Verificar que el fix de overflow funciona correctamente

- [x] Feature: Simplificar Settings + Valorar/Compartir
  - **Sección Privacidad eliminada:** No era necesaria para MVP (borrar cuenta ya existe)
  - **"Valorar la app" implementado:**
    - Usa `in_app_review` para mostrar dialog nativo de review
    - Si no está disponible, abre App Store directamente
    - App Store ID: `6740001949`
  - **"Compartir con un amigo" implementado:**
    - Usa `share_plus` para compartir nativo
    - Texto predefinido con enlaces a iOS/Android stores
  - **Dependencia añadida:** `in_app_review: ^2.0.9`
  - **Archivos modificados:**
    - `lib/features/settings/presentation/screens/settings_screen.dart` - Eliminada sección Privacidad, implementados onTap handlers
    - `pubspec.yaml` - Nueva dependencia in_app_review

- [x] Feature: Mejoras UX en Stories y ShareImageScreen
  - **Icono de compartir en Stories:** Cambiado de `Icons.send_outlined` a `Icons.ios_share` (más reconocible)
  - **ShareImageScreen - Editor desplegado por defecto:**
    - Selector de fondos se muestra expandido al entrar (`_ExpandedControl.background`)
    - Usuario entiende inmediatamente que puede editar
  - **ShareImageScreen - Captura optimizada:**
    - `pixelRatio: 1.0` (resolución del dispositivo, más rápido)
    - Delay reducido a 16ms (un frame)
    - Flujo simplificado: controles se ocultan solo durante captura
    - Sin parpadeo de UI al compartir
  - **Archivos modificados:**
    - `lib/features/daily_gospel/presentation/screens/gospel_stories_screen.dart` - Icono share
    - `lib/features/daily_gospel/presentation/screens/share_image_screen.dart` - Editor expandido + captura optimizada

- [x] Feature: Stories - Long press pausa en cualquier parte
  - **Problema:** Long press en los laterales de la pantalla navegaba en vez de pausar
  - **Comportamiento anterior:**
    - Long press CENTRO → pausaba (correcto)
    - Long press IZQUIERDA → navegaba a slide anterior (incorrecto)
    - Long press DERECHA → navegaba a slide siguiente (incorrecto)
  - **Comportamiento nuevo:**
    - Long press CUALQUIER PARTE → pausa la story
    - TAP (tap rápido) izquierda/derecha → navega entre slides
  - **Solución técnica:**
    - Añadidos flags `_isLongPressing` y `_tapX` para rastrear estado
    - `_onTapDown` solo guarda posición y pausa (ya no navega)
    - `_onTapUp` navega solo si NO fue long press
    - `_onLongPressStart` marca `_isLongPressing = true`
    - `_onLongPressEnd` marca `_isLongPressing = false`
  - **Archivo modificado:**
    - `lib/features/daily_gospel/presentation/screens/gospel_stories_screen.dart`

- [x] Feature: Navegación por swipe entre pantallas principales
  - **Funcionalidad:** Deslizar el dedo para navegar entre Home, Chat, Estudiar y Perfil
  - **Implementación:**
    - `MainShell` ahora usa `PageView` en lugar de mostrar solo `widget.child`
    - `PageController` para controlar animaciones de swipe
    - Las 4 pantallas principales se mantienen en memoria (no se reconstruyen)
    - Sincronización bidireccional: swipe ↔ NavigationBar ↔ GoRouter URLs
  - **Características:**
    - `PageScrollPhysics` por defecto: la pantalla sigue el dedo y encaja al soltar
    - Animación de NavigationBar: 300ms con `Curves.easeOutCubic`
    - Deep linking preservado (URLs se actualizan al navegar)
    - Botones del NavigationBar también animan la transición
  - **Iteraciones de optimización:**
    - v1: `BouncingScrollPhysics` → demasiado recorrido de dedo
    - v2: `ClampingScrollPhysics` → mejor pero todavía mucho recorrido
    - v3: `GestureDetector` + `NeverScrollableScrollPhysics` → sensibilidad perfecta pero sin feedback visual (la pantalla no seguía el dedo)
    - v4 (final): `PageScrollPhysics` por defecto → la pantalla sigue el dedo + snap natural
  - **Archivo modificado:**
    - `lib/core/router/app_router.dart` - `MainShell` con PageView

- [x] Feature: Almacenar Biblia en Supabase (reemplaza API.Bible)
  - **Problema:** API.Bible cambió su modelo de precios y ya no permite acceso gratuito a Biblias en español
  - **Solución:** Almacenar la Reina Valera 1909 (dominio público) directamente en Supabase
  - **Migración 00023:** Crea tabla `bible_verses`
    - Columnas: `book_id` (GEN, EXO, MRK...), `book_name`, `chapter`, `verse`, `text`
    - Índices: `idx_bible_verses_lookup` (book_id, chapter, verse), `idx_bible_verses_range` (book_id, chapter)
    - Constraint UNIQUE(book_id, chapter, verse)
  - **Scripts de importación:**
    - `scripts/import_bible_verses.js` - Descarga JSON de GitHub y genera SQL
    - `scripts/split_bible_sql.js` - Divide el SQL en chunks manejables
    - `scripts/import_missing_books.js` - Importa libros que faltaban
  - **Datos importados:**
    - 20,353 versículos de la Reina Valera 1909
    - 66 libros completos (Antiguo y Nuevo Testamento)
    - Archivos SQL en `supabase/migrations/bible_chunks/` (15 archivos)
  - **Edge Function `fetch-daily-gospel` actualizada:**
    - Ya NO usa API.Bible (eliminada dependencia externa)
    - Consulta directamente la tabla `bible_verses` en Supabase
    - Función `fetchBiblePassage()` hace query local por book_id/chapter/verse
    - Maneja versículos no contiguos (ej: "13-15, 19-23") con múltiples queries
  - **Ventajas:**
    - Sin dependencia de APIs externas
    - Más rápido (consulta local vs HTTP)
    - Gratis para siempre
    - 100% fiable y sin límites de requests
  - **Secret eliminado:** `API_BIBLE_KEY` ya no es necesario
  - **Archivos creados:**
    - `supabase/migrations/00023_create_bible_verses_table.sql`
    - `scripts/import_bible_verses.js`
    - `scripts/split_bible_sql.js`
    - `scripts/import_missing_books.js`
    - `supabase/migrations/bible_chunks/*.sql` (15 archivos con datos)
  - **Archivos modificados:**
    - `supabase/functions/fetch-daily-gospel/index.ts` - Usa tabla local en vez de API.Bible

- [x] Feature: Almacenar Calendario Litúrgico en Supabase (reemplaza dependencia de API externa)
  - **Problema:** Dependíamos de una API externa (cpbjr.github.io) para saber qué versículos corresponden a cada día
  - **Riesgo:** GitHub Pages mantenido por una persona aleatoria (cpbjr), podría desaparecer (como pasó con API.Bible)
  - **Solución:** Almacenar el calendario litúrgico católico directamente en Supabase con fallback a API
  - **Migración 00024:** Crea tabla `liturgical_readings`
    - Columnas: `reading_date`, `season`, `first_reading`, `psalm`, `second_reading`, `gospel`
    - Índice: `idx_liturgical_readings_date` (reading_date)
  - **Scripts de importación:**
    - `scripts/import_liturgical_readings.js` - Descarga datos del repo cpbjr y genera SQL
    - Uso: `node scripts/import_liturgical_readings.js 2027`
    - Genera: `supabase/migrations/liturgical_data/liturgical_readings_YYYY.sql`
  - **Datos importados actualmente:**
    - **2026: Año completo (365 lecturas)** - Del 1 de enero al 31 de diciembre
    - Incluye: temporada litúrgica, primera lectura, salmo, segunda lectura, evangelio
  - **⚠️ MANTENIMIENTO ANUAL REQUERIDO:**
    - **A finales de 2026** hay que importar los datos de 2027
    - Ejecutar: `node scripts/import_liturgical_readings.js 2027`
    - Aplicar SQL generado en Supabase SQL Editor
    - El repo cpbjr suele tener el año siguiente disponible hacia octubre/noviembre
  - **Edge Function `fetch-daily-gospel` actualizada:**
    - Primero consulta tabla local `liturgical_readings`
    - Si no encuentra, hace fallback a la API externa (cpbjr.github.io)
    - Respuesta incluye `source: "local" | "api"` para debugging
  - **Flujo actual (100% sin APIs externas para datos):**
    ```
    1. Edge Function fetch-daily-gospel
    2. Consulta liturgical_readings (local) → si no existe → fallback a API externa
    3. Consulta bible_verses (local) → texto bíblico Reina Valera 1909
    4. Genera contenido con OpenAI
    5. Guarda en daily_verses + daily_verse_texts
    ```
  - **Ventajas:**
    - Sin dependencia crítica de API externa (solo fallback)
    - Más rápido (consulta local vs HTTP)
    - Fallback seguro si no tenemos la fecha
  - **Archivos creados:**
    - `supabase/migrations/00024_create_liturgical_readings_table.sql`
    - `scripts/import_liturgical_readings.js`
    - `supabase/migrations/liturgical_data/liturgical_readings_2026.sql`
  - **Archivos modificados:**
    - `supabase/functions/fetch-daily-gospel/index.ts` - Usa tabla local con fallback

- [x] Feature: Aislamiento de datos por usuario (User Data Isolation)
  - **Problema:** Al crear un nuevo usuario anónimo en el mismo móvil, "Editar Perfil" mostraba datos del usuario anterior
  - **Causa raíz:** Riverpod providers no se invalidaban al cambiar de usuario
  - **Solución implementada:**
    - Creado `currentUserIdProvider` que solo emite cuando el user ID realmente cambia
    - Actualizado `currentUserProfileProvider`, `userProfileStreamProvider`, `hasCompletedOnboardingProvider` para usar este provider
    - `onboardingProvider` ahora se resetea automáticamente al cambiar de usuario
    - Añadido `ref.invalidate(currentUserProfileProvider)` después de completar onboarding
  - **Stories progress aislado por usuario:**
    - `StoryViewedService` ahora incluye user ID en la clave de SharedPreferences
    - Formato: `story_viewed_{userId}_{date}` (antes solo `story_viewed_{date}`)
    - Cada usuario tiene su propio progreso de Stories
  - **Delete account ahora hace logout:**
    - Añadido `await _supabase.auth.signOut()` después de borrar cuenta en servidor
    - El usuario es redirigido correctamente a Splash
  - **Archivos modificados:**
    - `lib/features/profile/presentation/providers/user_profile_provider.dart` - `currentUserIdProvider` + invalidación
    - `lib/core/services/story_viewed_service.dart` - User ID en clave
    - `lib/core/providers/story_viewed_provider.dart` - Pasa user ID al servicio
    - `lib/features/home/presentation/screens/home_screen.dart` - Usa user ID para marcar slides
    - `lib/features/auth/data/repositories/auth_repository_impl.dart` - signOut después de delete
    - `lib/features/onboarding/presentation/screens/onboarding_screen.dart` - Invalidate profile después de onboarding

- [x] Feature: Botón atrás Android funciona correctamente en Chat
  - **Problema:** Al presionar back dentro de un chat, iba a Home en lugar de a la lista de chats
  - **Causa raíz:** `chat_list_screen.dart` usaba `Navigator.push()` en lugar de `context.push()`
  - **Por qué fallaba:** `Navigator.push()` bypasea GoRouter, así que el router no conocía la ruta real (`/chat/id/xxx`) y el `BackButtonInterceptor` veía `/chat` como ubicación
  - **Solución implementada:**
    - Cambiar de `Navigator.push()` a `context.push()` en 3 lugares de `chat_list_screen.dart`
    - Nueva conversación: `context.push('/chat/new')`
    - Chat existente: `context.push('/chat/id/${widget.chat.id}')`
    - Topic guiado: `context.push('/chat/topic/${widget.topic.key}')`
  - **Comportamiento final:**
    - Dentro de chat → Lista de chats
    - Lista de chats → Home
    - Home → Cierra la app
  - **Archivos modificados:**
    - `lib/features/chat/presentation/screens/chat_list_screen.dart` - Usa `context.push()` + import go_router
  - **Documentación:** `docs/back-button-intentos.md` - Historial completo de 8 intentos fallidos y solución final

- [x] Fix: Racha no se incrementa al ver 3 Stories
  - **Problema:** Después de ver las 3 stories, la racha mostraba 0 en lugar de 1
  - **Causa raíz:** Race condition en el sistema de "Optimistic UI" para la racha
    - `markDayAsCompleted()` usaba `Future.delayed(500ms)` para limpiar el estado optimista
    - Si la recarga de Supabase tardaba más de 500ms, el estado optimista se limpiaba antes de que llegaran los datos reales
    - El provider quedaba en estado "loading" y `.valueOrNull ?? 0` retornaba 0
  - **Por qué apareció ahora:** El aislamiento de datos por usuario añadió `ref.watch(currentUserIdProvider)` a `streakDaysProvider`, lo que añade unos milisegundos extra al re-evaluar la cadena de dependencias
  - **Solución:** En lugar de timeout fijo, esperar a que `streakDaysProvider.future` termine antes de limpiar el estado optimista
  - **Archivo modificado:**
    - `lib/features/home/presentation/providers/daily_progress_provider.dart` - Cambiar `Future.delayed` por `await ref.read(streakDaysProvider.future)`

- [x] Fix: Lista de chats no se actualiza al volver de un chat
  - **Problema:** Al crear una nueva conversación y volver al tab de chats, la conversación no aparecía en la lista
  - **Causa raíz:** La lista de chats no se enteraba de que había un nuevo chat porque no había comunicación entre providers
  - **Por qué los listeners de ruta no funcionaron:** Con ShellRoute, el widget `ChatListScreen` se mantiene montado durante toda la navegación, así que `didChangeDependencies` y otros lifecycle methods no se disparan
  - **Solución implementada:**
    - `ChatNotifier` ahora recibe `Ref` en el constructor
    - Añadido método `_notifyChatListRefresh()` que incrementa `userChatsRefreshProvider`
    - Después de enviar un mensaje exitosamente, se llama `_notifyChatListRefresh()`
    - `ChatListScreen` observa `refreshableUserChatsProvider` (que depende de `userChatsRefreshProvider`) y se actualiza automáticamente
  - **Patrón:** Comunicación directa entre providers en lugar de detectar navegación
  - **Archivos modificados:**
    - `lib/features/chat/presentation/providers/chat_provider.dart` - `ChatNotifier` con `Ref` + `_notifyChatListRefresh()`

- [x] Feature: Mejoras en pantalla de Perfil (Settings)
  - **Stats conectados a datos reales:**
    - Racha: Usa `streakDaysDisplayProvider` (antes hardcodeado a "0")
    - Planes Completados: Usa `allUserPlansProvider` filtrado por `.isCompleted` (antes hardcodeado)
    - Label cambiado de "Planes" a "Planes\nCompletados" con `textAlign: TextAlign.center`
  - **Eliminado "Puntos":** Sistema de puntos/gamificación no se implementará en MVP
  - **Eliminado "Centro de ayuda":** No habrá sección de FAQ
  - **Archivos modificados:**
    - `lib/features/settings/presentation/screens/settings_screen.dart` - Stats reales, eliminados Puntos y Centro de ayuda

- [x] Fix: Contador de planes completados no se actualizaba
  - **Problema:** Al completar un plan de estudio, el contador en Perfil mostraba 0
  - **Causa raíz:** `completeDay()` en `StudyActionsNotifier` solo incrementaba `activePlanRefreshProvider` pero NO `userPlansRefreshProvider`
  - **Solución:** Añadir `_ref.read(userPlansRefreshProvider.notifier).state++` en `completeDay()`
  - **Archivo modificado:**
    - `lib/features/study/presentation/providers/study_provider.dart` - Incrementa ambos refresh providers

- [x] Fix: Gradiente dorado desbordado en diálogo de celebración
  - **Problema:** El gradiente dorado del botón "Continuar" se extendía más allá de los bordes del diálogo
  - **Solución:** Añadir `clipBehavior: Clip.antiAlias` y `shape: RoundedRectangleBorder` al Dialog
  - **Archivo modificado:**
    - `lib/features/study/presentation/screens/plan_day_screen.dart` - Dialog con clip

- [x] Feature: Política de Privacidad (GDPR/CCPA compliant)
  - **Pantalla Flutter:**
    - 13 secciones: Introducción, Datos recopilados, Uso, Base legal, IA, Terceros, Seguridad, Retención, Derechos, Menores, Transferencias, Cambios, Contacto
    - UI glassmorphism con barras doradas en títulos
    - Acceso desde Settings → "Política de privacidad"
  - **Página web (HTML):**
    - Archivo `privacy-policy.html` en raíz del proyecto
    - Diseño responsive con tema oscuro (mismo estilo que la app)
    - Para subir a Hostinger: copiar contenido a public_html
  - **Empresa responsable:** Bikain OÜ (Estonia)
  - **Contacto:** info@releasemvps.com
  - **Archivos creados:**
    - `lib/features/legal/data/privacy_policy_content.dart` - Contenido estructurado
    - `lib/features/legal/presentation/screens/privacy_policy_screen.dart` - Pantalla Flutter
    - `privacy-policy.html` - Versión web standalone
  - **Archivos modificados:**
    - `lib/core/constants/route_constants.dart` - Ruta `/settings/privacy-policy`
    - `lib/core/router/app_router.dart` - GoRoute anidado bajo settings
    - `lib/features/settings/presentation/screens/settings_screen.dart` - onTap conectado

- [x] Feature: Términos y Condiciones
  - **Pantalla Flutter:**
    - 17 secciones: Introducción, Quiénes somos, Cambios, Registro, Suscripciones, Licencia, Contenido usuario, Terceros, Uso aceptable, Riesgo, Indemnización, Exención, Limitación, Terminación, Ley aplicable, Disposiciones, Contacto
    - UI glassmorphism idéntica a Política de Privacidad
    - Acceso desde Settings → "Términos de uso"
  - **Página web (HTML):**
    - Archivo `terms-conditions.html` en raíz del proyecto
    - Enlace a política de privacidad desde la introducción
  - **URLs web (Hostinger):**
    - Política: `https://releasemvps.com/biblia-chat-cristiano-privacy`
    - Términos: `https://releasemvps.com/biblia-chat-cristiano-terminos-y-condiciones`
  - **Archivos creados:**
    - `lib/features/legal/data/terms_conditions_content.dart` - Contenido estructurado
    - `lib/features/legal/presentation/screens/terms_conditions_screen.dart` - Pantalla Flutter
    - `terms-conditions.html` - Versión web standalone
  - **Archivos modificados:**
    - `lib/core/constants/route_constants.dart` - Ruta `/settings/terms-conditions`
    - `lib/core/router/app_router.dart` - GoRoute anidado bajo settings
    - `lib/features/settings/presentation/screens/settings_screen.dart` - onTap conectado

- [x] Fix: Navegación atrás desde pantallas de Settings
  - **Problema:** Al presionar back desde Términos, Privacidad o Mis Reflexiones, iba a Home en lugar de Settings
  - **Causa:** Las rutas estaban fuera del ShellRoute, GoRouter no conocía la jerarquía
  - **Solución:** Mover rutas dentro del ShellRoute como hijas de `/settings`
  - **Rutas actualizadas:**
    - `/settings/edit` (ya existía)
    - `/settings/saved-messages` (movida)
    - `/settings/privacy-policy` (movida)
    - `/settings/terms-conditions` (movida)
  - **PageStorageKey:** Añadido al `SingleChildScrollView` de Settings para preservar posición de scroll al volver
  - **Archivos modificados:**
    - `lib/core/constants/route_constants.dart` - Nuevas rutas anidadas
    - `lib/core/router/app_router.dart` - Rutas movidas dentro de settings
    - `lib/features/settings/presentation/screens/settings_screen.dart` - PageStorageKey

- [x] EPIC 11: Firebase Analytics
  - **Configuración Firebase:**
    - Proyecto: "Biblia Chat Cristiano" (ID: `biblia-chat-cristiano`)
    - Android: `google-services.json` en `android/app/`
    - iOS: `GoogleService-Info.plist` en `ios/Runner/`
    - Plugin Google Services añadido a `settings.gradle` y `app/build.gradle`
  - **Archivos creados:**
    - `lib/firebase_options.dart` - Configuración multiplataforma
    - `lib/core/services/analytics_service.dart` - Servicio singleton con métodos de tracking
  - **Inicialización:**
    - Firebase se inicializa en `main.dart` con `Firebase.initializeApp()`
    - User ID se establece en `SplashScreen` después de auth
    - Observer de navegación añadido al GoRouter para screen_view automático
  - **Eventos trackeados:**
    | Evento | Ubicación | Descripción |
    |--------|-----------|-------------|
    | `onboarding_complete` | OnboardingScreen | Usuario completa onboarding |
    | `chat_message_sent` | ChatNotifier | Mensaje enviado en chat |
    | `story_viewed` | GospelStoriesScreen | Slide de story visto |
    | `story_completed` | GospelStoriesScreen | 3 stories completadas |
    | `plan_started` | StudyActionsNotifier | Usuario inicia plan |
    | `plan_day_completed` | StudyActionsNotifier | Día completado |
    | `plan_completed` | StudyActionsNotifier | Plan de 7 días completado |
    | `plan_abandoned` | StudyActionsNotifier | Usuario abandona plan |
    | `message_saved` | SavedMessageNotifier | Mensaje guardado ❤️ |
    | `message_unsaved` | SavedMessageNotifier | Mensaje desguar dado |
    | `share_image` | ShareImageScreen | Imagen compartida |
    | `paywall_viewed` | PaywallScreen | Usuario ve paywall |
    | `subscription_started` | SubscriptionNotifier | Suscripción iniciada |
    | `purchase_restored` | SubscriptionNotifier | Compras restauradas |
    | `email_linked` | AuthNotifier | Email vinculado a cuenta |
    | `login` | AuthNotifier | Usuario hace login |
    | `account_deleted` | AuthNotifier | Cuenta borrada |
    | `message_limit_reached` | MessageLimitNotifier | Límite diario alcanzado |
  - **User Properties (segmentación):**
    - `denomination`, `origin`, `age_group`, `gender`, `is_premium`
    - Se establecen al completar onboarding
  - **Archivos modificados:**
    - `lib/main.dart` - Import Firebase + inicialización
    - `lib/core/router/app_router.dart` - Analytics observer en GoRouter
    - `lib/features/onboarding/presentation/screens/onboarding_screen.dart` - Log onboarding
    - `lib/features/chat/presentation/providers/chat_provider.dart` - Log mensajes
    - `lib/features/daily_gospel/presentation/screens/gospel_stories_screen.dart` - Log stories
    - `lib/features/study/presentation/providers/study_provider.dart` - Log planes
    - `lib/features/saved_messages/presentation/providers/saved_message_provider.dart` - Log guardados
    - `lib/features/daily_gospel/presentation/screens/share_image_screen.dart` - Log share
    - `lib/features/subscription/presentation/screens/paywall_screen.dart` - Log paywall
    - `lib/features/subscription/presentation/providers/subscription_provider.dart` - Log suscripciones
    - `lib/features/auth/presentation/providers/auth_provider.dart` - Log auth events
    - `lib/features/auth/presentation/screens/splash_screen.dart` - Set user ID
    - `lib/features/chat/presentation/providers/message_limit_provider.dart` - Log límite
    - `android/settings.gradle` - Plugin Google Services + Kotlin 2.1.0
    - `android/app/build.gradle` - Apply plugin
  - **Verificación con DebugView:**
    - Habilitar debug mode: `adb shell setprop debug.firebase.analytics.app ee.bikain.bibliachat`
    - Ver eventos en: Firebase Console → Analytics → DebugView
    - Eventos aparecen en tiempo real (~30 segundos de delay)
    - Dashboard principal tiene delay de ~24 horas

### Configuración Android Build (actualizado)
- **AGP:** 8.7.0 (Android Gradle Plugin)
- **Kotlin:** 2.1.0 (actualizado para compatibilidad con Firebase)
- **Gradle:** 8.9
- **Fix para plugins sin namespace:** `plugins.withId("com.android.library")` en build.gradle
- **Dependency override:** `app_links: ^7.0.0` para compatibilidad con AGP 8.x
- **Archivos modificados:**
  - `android/settings.gradle` - Versiones AGP y Kotlin
  - `android/gradle/wrapper/gradle-wrapper.properties` - Versión Gradle
  - `android/build.gradle` - Fix para namespace en plugins

### Tickets Descartados (bajo valor para MVP)
- ~~T-0509~~: Limpiar chat - Revertido, no tiene sentido práctico
- ~~T-0705~~: Devoción del día - Duplica Evangelio/Stories
- ~~T-0706~~: Oración guiada - Solo es un shortcut, usuario puede pedir en chat
- ~~T-0707~~: Recomendaciones de planes - Depende de EPIC 9
- ~~T-0906~~: Puntos/badges - Gamificación descartada para MVP
- ~~T-0801..T-0803~~: Seed devotions - POSPUESTO (Evangelio del Día ya cubre, posible futuro)

### Próximos Pasos
- [x] **EPIC 9**: Planes de estudio - COMPLETADO
- [x] T-0308: Borrar cuenta (obligatorio App Store) - COMPLETADO
- [x] T-0307: Editar perfil desde Settings - COMPLETADO
- [x] Feature: Eliminar mensaje individual - COMPLETADO
- [x] T-0511: Guardar Mensaje ❤️ + "Mis Reflexiones" - COMPLETADO
- [x] T-0512: Compartir reflexión como imagen - COMPLETADO
- [x] Feature: Almacenar Biblia en Supabase (reemplaza API.Bible) - COMPLETADO
- [x] Feature: Almacenar Calendario Litúrgico en Supabase - COMPLETADO
- [x] Feature: Botón atrás Android en Chat - COMPLETADO
- [x] **EPIC 11**: Firebase Analytics - COMPLETADO
- [ ] T-0403: Purchase flow (requiere build iOS/Android)
- [ ] RevenueCat Android (pospuesto - requiere subir APK a Play Console primero)

## Comandos Útiles
```bash
# Flutter
cd app_flutter && flutter pub get
flutter run -d ios
flutter run -d android

# Supabase (cuando esté configurado)
supabase db push
supabase functions serve
```

## Información del Desarrollador
- **Usuario GitHub:** RobertoAbia
- **Repositorio:** https://github.com/RobertoAbia/BibliaChat-

## Notas Importantes
- OpenAI SOLO desde Edge Functions (nunca desde Flutter)
- **GPT-5.2:** Usa `role: "developer"` (no `system`) y `max_completion_tokens` (no `max_tokens`)
- RLS se prueba desde el día 1
- `openai_conversation_id` existe pero NO se usa en runtime MVP
- Prompt ordenado: base → dinámico → ai_memory → context_summary → últimos 12 mensajes
- La IA no debe inventar datos que no estén en ai_memory o historial

## ⚠️ Mantenimiento Periódico

### Calendario Litúrgico (ANUAL - Finales de cada año)
**Última actualización:** Enero 2026 (datos de 2026 completos)
**Próxima actualización:** Octubre/Noviembre 2026 (para cargar 2027)

El calendario litúrgico católico se almacena localmente en la tabla `liturgical_readings`. Los datos deben actualizarse cada año porque el calendario litúrgico tiene fechas móviles (Pascua, Cuaresma, etc.) que cambian anualmente.

**Pasos para actualizar:**
```bash
# 1. Ejecutar el script de importación
node scripts/import_liturgical_readings.js 2027

# 2. Revisar el SQL generado
cat supabase/migrations/liturgical_data/liturgical_readings_2027.sql

# 3. Ejecutar el SQL en Supabase Dashboard → SQL Editor
# (El script usa ON CONFLICT DO UPDATE, es seguro re-ejecutar)
```

**Fuente de datos:** `https://github.com/cpbjr/catholic-readings-api`
- El repo suele tener el año siguiente disponible hacia octubre/noviembre
- Si no están disponibles los datos, la Edge Function usará el fallback a la API externa

## Edge Functions (Supabase)

### `chat-send-message` (DESPLEGADA)
- **Ubicación:** `supabase/functions/chat-send-message/combined.ts`
- **Propósito:** Procesar mensajes del chat y generar respuestas con IA
- **Sistema de Memorias:**
  - `ai_memory` (user_profiles.ai_memory): Largo plazo del USUARIO
  - `context_summary` (chats.context_summary): Largo plazo de la CONVERSACIÓN
  - Últimos 10 mensajes (chat_messages): Corto plazo
- **Orden del Prompt (6 capas):**
  1. BASE_PROMPT → Identidad "amigo cristiano de WhatsApp" (tono casual, cercano)
  2. DENOMINATION_PROMPT → Adaptación denominacional (9 opciones)
  3. ORIGIN_PROMPT → Contexto cultural (4 regiones)
  4. TOPIC_PROMPT → Contexto del tema (12 topics + "otro")
  5. ai_memory → Hechos del usuario (JSON)
  6. context_summary → Resumen conversación anterior
- **Request:** `{ topic_key?, user_message, chat_id? }`
  - `topic_key` es OPCIONAL (null = chat libre, usa prompt "otro")
- **Response:** `{ success, chat_id, message_id, assistant_message, title?, created_at }`
  - `title` se devuelve solo si se generó o ya existía
- **Generación automática de títulos:**
  - Se genera con GPT-4o-mini después del primer mensaje (`messageCount == 2 AND !chat.title`)
  - Máximo 50 caracteres, descriptivo del tema de conversación
  - Solo se genera UNA VEZ, después solo edición manual
  - Prompt: `CHAT_TITLE_PROMPT` con reglas específicas
- **Auto-actualización:** Cada 20 mensajes regenera context_summary y extrae ai_memory
- **Modelo principal:** GPT-4o (`role: "developer"`, `max_completion_tokens: 400`, `temperature: 0.8`)
- **Modelo para memorias y títulos:** GPT-4o-mini (resúmenes, ai_memory, títulos)
- **Secrets requeridos:** `OPENAI_API_KEY`
- **Topics soportados (19):**
  - *Generales (12):* `familia_separada`, `desempleo`, `solteria`, `ansiedad_miedo`, `identidad_bicultural`, `reconciliacion`, `sacramentos`, `oracion`, `preguntas_biblia`, `evangelio_del_dia`, `lectura_del_dia`, `otro`
  - *Planes de estudio (7):* `plan_soberbia`, `plan_avaricia`, `plan_lujuria`, `plan_ira`, `plan_gula`, `plan_envidia`, `plan_pereza`
- **Request actualizado:** `{ topic_key?, user_message, chat_id?, system_message? }`
  - `system_message`: Contenido de Story, se guarda como mensaje 'assistant' en BD
- **BASE_PROMPT (estilo WhatsApp corto):**
  ```
  Eres un amigo cristiano que chatea por WhatsApp. Te llamas "Biblia Chat"...
  FORMATO - ESTO ES LO MÁS IMPORTANTE:
  - Mensajes CORTOS como WhatsApp real (1-3 oraciones máximo)
  - Si puedes decirlo en una línea, hazlo
  - PROHIBIDO: párrafos largos, listas, bullet points
  - A veces basta con "Entiendo", "Qué difícil", "Ánimo"
  - NO siempre cites la Biblia - máximo 1 cada 4-5 mensajes
  - Eres un amigo que chatea, NO un consejero dando discursos
  ```

### `fetch-daily-gospel` (desplegada como `clever-worker`)
- **Ubicación:** `supabase/functions/fetch-daily-gospel/index.ts`
- **Nombre en Supabase:** `clever-worker`
- **Propósito:** Obtener y procesar el evangelio del día
- **Ejecución automática:** GitHub Actions cron diario a las 6:00 AM UTC
- **Fuentes de datos (prioridad):**
  1. `liturgical_readings` tabla en Supabase (calendario litúrgico 2026 - **local, prioridad**)
  2. Catholic Readings API (fallback si no hay datos locales - externa)
  3. `bible_verses` tabla en Supabase (texto bíblico Reina Valera 1909 - local)
  4. OpenAI GPT-5.2 (generación de contenido - externa)
- **Contenido generado:**
  - `verse_summary`: Resumen coloquial (300-500 chars)
  - `key_concept`: Frase impactante (60-100 chars)
  - `practical_exercise`: Acción física/material (100-180 chars)
- **Características técnicas:**
  - Maneja versículos no contiguos (ej: "13-15, 19-23") con múltiples queries a `bible_verses`
  - Prompt optimizado para español de España, segunda persona singular (tú)
  - **Ya NO usa API.Bible** - la Biblia está almacenada localmente en Supabase
- **Secrets requeridos:**
  - `OPENAI_API_KEY`
- **Tabla `bible_verses`:**
  - 20,353 versículos de la Reina Valera 1909 (dominio público)
  - Columnas: `book_id` (GEN, EXO, MRK...), `book_name`, `chapter`, `verse`, `text`
  - Índices optimizados para búsquedas por libro/capítulo/versículo

### `delete-account` (DESPLEGADA)
- **Ubicación:** `supabase/functions/delete-account/index.ts`
- **Propósito:** Borrar cuenta de usuario cumpliendo GDPR
- **Flujo:**
  1. Verifica usuario con token JWT
  2. Archiva datos pseudonimizados en `deleted_user_archives`
  3. Borra usuario de `auth.users` (CASCADE elimina todo lo demás)
- **Pseudonimización:**
  - Usa SHA256 hash del user_id (no reversible, pero buscable)
  - Si usuario se identifica después, puedes calcular su hash y buscar sus conversaciones
- **Datos archivados:**
  - `user_id_hash`: SHA256 del user_id original
  - `chat_messages`: JSON con todos los mensajes (role, content, created_at)
  - `plans_data`: Progreso de planes (nombre, status, días completados)
  - Demografía: denomination, origin_group, age_group
  - Métricas: total_messages, streak_max, plans_started/completed
- **Retención:** 3 años (expires_at = archived_at + 3 years)
- **PII eliminada:** nombre, email, device tokens, rc_app_user_id
- **Request:** POST con Authorization header (JWT del usuario)
- **Response:** `{ success: true/false, message/error }`
- **Secrets requeridos:** Ninguno adicional (usa SUPABASE_SERVICE_ROLE_KEY del entorno)

## GitHub Actions

### `daily-gospel.yml`
- **Ubicación:** `.github/workflows/daily-gospel.yml`
- **Propósito:** Ejecutar automáticamente la Edge Function cada día
- **Cron:** `0 6 * * *` (6:00 AM UTC = 7:00 AM España)
- **Trigger manual:** `workflow_dispatch` permite ejecución manual desde GitHub
- **Secret requerido:** `SUPABASE_SERVICE_ROLE_KEY` (configurado en GitHub → Settings → Secrets)

## Notas Técnicas Flutter
- **Flutter version:** 3.35.3 (stable)
- **Dart version:** 3.5.4
- **IMPORTANTE CardTheme:** En ThemeData usar `CardThemeData()` (NO `CardTheme`)
  - El analizador de WSL puede mostrar error falso, ignorar
  - El compilador de Windows requiere `CardThemeData`
- BackdropFilter puede ser pesado en Android antiguos - usar con moderación
- Los widgets glass usan `ImageFilter.blur(sigmaX: 8-12, sigmaY: 8-12)`
- Paquetes UI instalados: `shimmer`, `lottie`, `flutter_animate`, `share_plus`
- Paquete timezone: `flutter_timezone` - para auto-detectar zona horaria del dispositivo
- **Navegación fullscreen (ocultar bottom nav):**
  - Usar `Navigator.of(context, rootNavigator: true).push()` + `fullscreenDialog: true`
  - El `pop()` también debe usar `rootNavigator: true`
- **Swipe entre tabs + GoRouter ShellRoute:**
  - MainShell usa PageView para swipe entre tabs principales (Home, Chat, Study, Settings)
  - **Problema:** ShellRoute pasa `child` pero si usas PageView con pantallas hardcodeadas, ignoras el child y las rutas anidadas no funcionan
  - **Solución:** Detectar si estamos en ruta principal o anidada:
    ```dart
    body: isMainRoute
        ? PageView(children: _screens)  // Tabs: swipe funciona
        : widget.child,                  // Rutas anidadas: GoRouter controla
    ```
  - `_isMainRoute()` compara location exacta con `/home`, `/chat`, `/study`, `/settings`
  - Recrear PageController al volver de ruta anidada para mostrar la tab correcta
- **Botón atrás Android + GoRouter:**
  - `PopScope` con `canPop: false` NO recibe eventos en Android 13+ con GoRouter
  - **Solución:** Usar `BackButtonListener` que sí recibe el evento:
    ```dart
    BackButtonListener(
      onBackButtonPressed: () async {
        if (GoRouter.of(context).canPop()) {
          GoRouter.of(context).pop();
          return true;
        } else if (isMainRoute) {
          await SystemNavigator.pop(); // Cierra la app
          return true;
        }
        return false;
      },
      child: Scaffold(...),
    )
    ```
  - Requiere `android:enableOnBackInvokedCallback="true"` en AndroidManifest.xml
- **TextField sin contenedores anidados:**
  - Usar Container con borde + TextField con `fillColor: Colors.transparent`, `filled: false`
  - Evitar GlassContainer.input() que crea efecto de caja dentro de caja
- **Capturar tap antes de perder focus:**
  - Usar `Listener` con `onPointerDown` en lugar de `GestureDetector` con `onTap`
  - El `onPointerDown` se dispara antes de que el sistema de focus procese el evento
- **Optimistic UI en Riverpod:**
  - Patrón: `StateProvider` (optimista) + `FutureProvider` (real) + `Provider` (combinado)
  - El provider combinado devuelve el estado optimista si existe, sino el de Supabase
  - **IMPORTANTE:** NO usar `Future.delayed` para limpiar estado optimista (race condition)
  - En su lugar, esperar a que el provider real termine: `await ref.read(realProvider.future)`
- **Mutex/Lock en Dart:**
  - Usar `Completer<void>?` para serializar operaciones async concurrentes
  - Patrón: `while (_lock != null) await _lock!.future;` antes de operar
  - Liberar en `finally` para garantizar que siempre se libera
- **Shimmer en tema oscuro:**
  - Los colores base y highlight deben tener suficiente contraste
  - Recomendado: `#3A3A5A` → `#5A5A7A` (diferencia ~32 en cada canal)
- **Riverpod .family provider caching:**
  - Los providers `.family` cachean instancias por key
  - Si usas `ChatIdentifier.newChat()` (que siempre es `(null, null)`), reutiliza el mismo estado
  - Solución: Añadir método `reset()` al StateNotifier y llamarlo cuando se necesite estado fresco
  - Ejemplo: `notifier.resetForNewChat()` antes de `initialize()`
- **Refrescar lista después de navegación:**
  - Hacer `await` en `Navigator.push()` para esperar a que vuelva
  - Luego incrementar un `StateProvider<int>` que el `FutureProvider` observe
  - Ejemplo: `ref.read(userChatsRefreshProvider.notifier).state++`
- **Pasar contenido de Stories a la IA:**
  - Usar parámetro `systemMessage` en `sendMessage()`
  - Se guarda como mensaje 'assistant' en BD (visible en el chat)
  - El provider recarga todos los mensajes de BD cuando hay `systemMessage`
  - Útil para: contenido de Stories que debe persistir en el historial
- **Orden de mensajes en addInitialMessages:**
  - Los mensajes deben añadirse al FINAL del array (no al principio)
  - Correcto: `messages: [...state.messages, ...newMessages]`
  - Incorrecto: `messages: [...newMessages, ...state.messages]` (mensajes quedan ocultos arriba)
  - Esto afecta cuando se añade contenido del día del plan al chat
- **Botones responsivos (content-sized):**
  - Por defecto, `ElevatedButton` se expande en un `Column` debido a `minimumSize` (~64dp)
  - `Center` wrapper NO funciona (da loose constraints, el botón sigue expandiéndose)
  - **Solución robusta:** `Row(mainAxisSize: MainAxisSize.min)` + `minimumSize: Size.zero`
  - Si el Column tiene `crossAxisAlignment.start`, añadir `Center` envolviendo el Row
  - Ejemplo:
    ```dart
    Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size.zero,  // Elimina el mínimo por defecto
            // ... resto del estilo
          ),
          child: Text('Botón'),
        ),
      ],
    )
    ```
- **Deep Links (Supabase Auth):**
  - Custom URL schemes (`com.bibliachats://`) solo funcionan en móvil (iOS/Android)
  - En web/desktop, el navegador no sabe manejar estos schemes → página en blanco
  - Configuración requerida:
    - Supabase Dashboard: Site URL y Redirect URLs
    - Android: intent-filter en AndroidManifest.xml
    - iOS: CFBundleURLTypes en Info.plist
    - Flutter: `authOptions: FlutterAuthClientOptions(authFlowType: AuthFlowType.pkce)`
  - Para detectar eventos como `passwordRecovery`, escuchar `onAuthStateChange` en SplashScreen
- **Auth providers reactivos:**
  - Los providers de auth deben depender de `authStateChangesProvider` para actualizarse automáticamente
  - Patrón: `ref.watch(authStateChangesProvider)` al inicio del provider
  - Sin esto, los valores no se actualizan cuando el usuario verifica email o cambia estado
- **RevenueCat en Web (kIsWeb):**
  - RevenueCat SDK NO funciona en web - usar mock data para preview
  - El check `if (kIsWeb) return` en `init()` evita inicialización
  - `customerInfoStream` no existe en compilación web - usar dynamic call:
    ```dart
    Stream<CustomerInfo> get customerInfoStream {
      if (kIsWeb || !_isInitialized) return const Stream.empty();
      return (Purchases as dynamic).customerInfoStream as Stream<CustomerInfo>;
    }
    ```
  - Sin el cast dinámico, el compilador falla incluso con el check `kIsWeb`
- **Comparación de enums vs strings:**
  - Los campos parseados de JSON como `status` pueden ser enums en el modelo
  - Comparar con el valor del enum, NO con string: `status == PlanStatus.completed` (no `== 'completed'`)
  - Mejor aún: usar getters del entity como `userPlan.isCompleted` que ya hacen la comparación correcta
  - Error silencioso: `enum == 'string'` siempre es `false` sin error de compilación
- **Aislamiento de datos por usuario (User Data Isolation):**
  - Los providers que dependen del usuario deben observar `currentUserIdProvider`
  - `currentUserIdProvider` extrae solo el user ID del auth state (evita invalidaciones innecesarias)
  - Para StateNotifierProviders, usar `ref.listen()` con `ref.invalidateSelf()` cuando cambia el usuario
  - SharedPreferences con datos por usuario deben incluir user ID en la clave: `{prefix}_{userId}_{date}`
  - Después de operaciones que cambian datos del usuario (onboarding, delete), llamar `ref.invalidate()`
- **Diferenciar tap vs long press:**
  - `onTapDown` se dispara ANTES de saber si es tap o long press
  - Para lógica diferenciada: usar flag `_isLongPressing` + guardar posición en `_tapX`
  - `onLongPressStart` → `_isLongPressing = true`
  - `onLongPressEnd` → `_isLongPressing = false`
  - `onTapUp` → solo ejecutar acción si `!_isLongPressing`
- **Navegación por swipe entre tabs (PageView + NavigationBar):**
  - En `ShellRoute`, el `MainShell` puede ignorar `widget.child` y usar `PageView` con pantallas fijas
  - `PageController` para animaciones suaves entre páginas
  - `onPageChanged` actualiza `_selectedIndex` y llama `context.go()` para sincronizar URL
  - `onDestinationSelected` llama `_pageController.animateToPage()` (300ms, `easeOutCubic`) para animación consistente
  - Las pantallas se mantienen en memoria (no se reconstruyen al volver)
  - Usar `PageScrollPhysics` por defecto (NO `BouncingScrollPhysics` ni `ClampingScrollPhysics`) - la pantalla sigue el dedo y encaja naturalmente
  - NO usar `GestureDetector` + `NeverScrollableScrollPhysics` - funciona bien para sensibilidad pero la pantalla no sigue el dedo (mala UX)
- **Botón atrás Android con GoRouter + ShellRoute:**
  - NUNCA usar `Navigator.push()` para rutas que están definidas en GoRouter
  - `Navigator.push()` bypasea GoRouter → el router no conoce la ruta → back button falla
  - SIEMPRE usar `context.push('/ruta')` para navegar a rutas dentro del ShellRoute
  - Las rutas anidadas (ej: `/chat/id/xxx`) deben estar definidas dentro del ShellRoute
  - El `BackButtonInterceptor` en `app.dart` lee la ruta desde `router.routerDelegate.currentConfiguration.uri.path`
  - Si usas `Navigator.push()`, esa propiedad devuelve la ruta padre (`/chat`) en vez de la real (`/chat/id/xxx`)
  - Documentación completa en `docs/back-button-intentos.md`
- **Ocultar bottom nav en rutas específicas (sin mover rutas fuera del ShellRoute):**
  - NO mover rutas fuera del ShellRoute para ocultar bottom nav (rompe el back button)
  - Solución simple: ocultar condicionalmente en `MainShell.build()`:
    ```dart
    final shouldHideBottomNav = location.startsWith('/chat/') && location != '/chat';
    return Scaffold(
      body: ...,
      bottomNavigationBar: shouldHideBottomNav ? null : NavigationBar(...),
    );
    ```
  - Las rutas siguen dentro del ShellRoute → back button funciona correctamente
  - Solo se oculta el UI del bottom nav, la estructura de navegación no cambia
- **Refrescar listas desde otros providers (comunicación cross-provider):**
  - Con ShellRoute, los widgets de tabs se mantienen montados → los lifecycle methods no detectan navegación
  - **Patrón recomendado:** Comunicación directa entre providers usando `Ref`
  - El StateNotifier que modifica datos recibe `Ref` en el constructor
  - Después de modificar, incrementa un `StateProvider<int>` que la lista observa
  - Ejemplo:
    ```dart
    class ChatNotifier extends StateNotifier<ChatState> {
      final Ref _ref;
      ChatNotifier(this._repository, this._ref) : super(...);

      void _notifyChatListRefresh() {
        _ref.read(userChatsRefreshProvider.notifier).state++;
      }

      Future<void> sendMessage(...) async {
        // ... enviar mensaje ...
        _notifyChatListRefresh(); // Notifica a la lista
      }
    }
    ```
  - La lista usa `ref.watch(refreshableUserChatsProvider)` que depende del contador
- **Preservar posición de scroll al navegar (PageStorageKey):**
  - Por defecto, al volver a una pantalla el scroll vuelve al inicio
  - Añadir `PageStorageKey` al `ScrollView` para que Flutter recuerde la posición:
    ```dart
    SingleChildScrollView(
      key: const PageStorageKey<String>('settings_scroll'),
      child: Column(...),
    )
    ```
  - Funciona con `ListView`, `SingleChildScrollView`, `CustomScrollView`, etc.
  - La key debe ser única por pantalla
- **Preservar estado de scroll en ShellRoute con PageView (Offstage):**
  - `PageStorageKey` NO funciona bien cuando el `PageView` se desmonta al navegar a rutas anidadas
  - **Problema:** Al ir de `/study` a `/study/plan/xxx` y volver, el scroll se perdía
  - **Causa:** El código recreaba el `PageController` al volver de rutas anidadas, desmontando los widgets hijos
  - **Solución:** Usar `Stack` con `Offstage` para mantener el `PageView` siempre montado:
    ```dart
    body: Stack(
      children: [
        // PageView siempre presente (oculto pero montado)
        Offstage(
          offstage: !isMainRoute,
          child: PageView(
            controller: _pageController,
            children: _screens,
          ),
        ),
        // Child encima cuando es ruta anidada
        if (!isMainRoute) widget.child,
      ],
    ),
    ```
  - **Clave:** NUNCA recrear el `PageController` → `_pageController ??= PageController(...)`
  - Con esto, las pantallas mantienen su estado de scroll incluso después de múltiples navegaciones
