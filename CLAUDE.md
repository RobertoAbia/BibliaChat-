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
- `user_profiles` (incluye `ai_memory`, `rc_app_user_id`, `gender`, `country_code`, `motive_detail`, `consent_terms_at`, `consent_data_at`)
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

## Migraciones SQL (34 total)
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
- 00026: Fix `daily_activity.completed` sobrescrito por `message_limit_service` + arreglar datos corruptos
- 00027: Columna `motive` (enum) → `features` (text) para multi-select de apoyo
- 00028: Columna `first_message` → `motive` para key de motivación de fe
- 00029: Columna `motive_detail` para detalle de motivación (follow-up de Fe, solo analytics)
- 00030: Columnas `consent_terms_at` y `consent_data_at` para tracking de consentimiento GDPR
- 00031: Seed 12 planes de motivo (84 días de contenido), columna `title` en `plan_days`, 4 topic keys nuevos
- 00032: Columnas demografía + consentimiento GDPR en `deleted_user_archives` (gender, country_code, motive, motive_detail, features, consent_terms_at, consent_data_at)
- 00033: `email_hash` en `deleted_user_archives` para búsqueda por email en juicios (SHA256)
- 00034: Función SQL `register_device_token()` con SECURITY DEFINER para evitar RLS violation al reusar dispositivo

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
    - OnboardingScreen (16 páginas: Welcome → Consentimiento → Intro → Nombre → Edad → Género → País → Denominación → Fe → Detalle → Apoyo → Compromiso → Recordatorio → Analizando → Resumen → Plan Preview)
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
    - Entity: `UserProfile` con enums (Denomination, OriginGroup, AgeGroup, GenderType)
    - Repository interface + implementación
    - Model con serialización JSON para Supabase
    - Datasource remoto con operaciones CRUD
  - **Riverpod providers:**
    - `userProfileRepositoryProvider` - Repositorio inyectado
    - `currentUserProfileProvider` - Perfil actual (FutureProvider)
    - `userProfileStreamProvider` - Cambios en tiempo real
    - `hasCompletedOnboardingProvider` - Verificación onboarding
    - `onboardingProvider` - StateNotifier para formulario onboarding
  - **Pantallas de onboarding (16 páginas):**
    - 0: Welcome (CTA + login link)
    - 1: Consentimiento — 2 checkboxes obligatorios (Términos+Privacidad, datos religiosos GDPR Art. 9) + "Aceptar todo"
    - 2: Intro — "Vamos a personalizar tu experiencia" (informativa, sin datos)
    - 3: Nombre (¿Cómo te llamas? — requerido)
    - 4: Edad (age_group) — personalizado con nombre si disponible
    - 5: Género (gender) - Hombre/Mujer
    - 6: País - Dropdown 21 países hispanohablantes → guarda `origin` (origin_group) + `country_code` (ISO)
    - 7: Denominación
    - 8: Fe - "¿Por qué es importante para ti trabajar en tu Fe ahora?" (4 opciones single-select, labels adaptados a género) → guarda key en `motive`
    - 9: Detalle de motivación - Follow-up dinámico con 3 opciones según page 8 → guarda key en `motive_detail`
    - 10: Apoyo - "¿Cómo quieres que te ayudemos?" (3 opciones multi-select, hint visible) → guarda keys separadas por coma en `features`
    - 11: Compromiso - "¿Qué nivel de compromiso tienes?" (2 opciones, labels adaptados a género) → guarda en `persistence_self_report`
    - 12: Recordatorio (reminder_enabled, reminder_time) - Toggle + Time picker
    - 13: Analizando (animación)
    - 14: Resumen motivacional - Situación + plan + prueba social (dinámico según respuestas)
    - 15: Plan Preview (plan personalizado 7 días + auto-assign al completar)
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
    - `VerifyEmailScreen` - "Revisa tu correo" con countdown para reenvío + botón "Ya verifiqué" + auto-detección al volver a la app (WidgetsBindingObserver)
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
  - **"Valorar la app":**
    - **Pre-publicación:** SnackBar "Disponible próximamente" (import `in_app_review` eliminado)
    - **Post-publicación (TODO):** Restaurar `in_app_review` con dialog nativo + fallback a App Store (ID: `6740001949`)
  - **"Compartir con un amigo":**
    - Usa `share_plus` para compartir nativo
    - **Pre-publicación:** Texto descriptivo sin links a stores
    - **Post-publicación (TODO):** Añadir enlaces a iOS/Android stores
  - **Dependencia `in_app_review`:** Sigue en pubspec.yaml pero sin importar (se restaurará post-publicación)
  - **Archivos modificados:**
    - `lib/features/settings/presentation/screens/settings_screen.dart` - Eliminada sección Privacidad, implementados onTap handlers

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

- [x] Feature: Botón atrás Android funciona correctamente en Stories
  - **Problema:** Al presionar back dentro de GospelStoriesScreen, la app se cerraba en lugar de volver a Home
  - **Causa raíz:** La ruta `/stories` estaba FUERA del ShellRoute, por lo que `MainShell.build()` no se ejecutaba y `currentLocationProvider` nunca se actualizaba (seguía siendo `/home`)
  - **Intentos fallidos:**
    1. Poner ruta FUERA del ShellRoute - No funciona porque `currentLocationProvider` no se actualiza
    2. `PopScope` + `fullscreenRouteOpenProvider` - No funciona porque `return false` en `BackButtonInterceptor` NO pasa el evento a Flutter Navigator
  - **Solución implementada (igual que `/study/day` que sí funciona):**
    - Mover ruta `/stories` DENTRO del ShellRoute como ruta anidada de `/home` → `/home/stories`
    - Ocultar bottom nav condicionalmente cuando `location == '/home/stories'`
    - Navegación con `context.push('/home/stories', extra: {...})`
  - **Por qué funciona:**
    - `MainShell.build()` se ejecuta con `location = '/home/stories'`
    - `currentLocationProvider` se actualiza a `/home/stories`
    - `isMainRoute('/home/stories')` retorna `false`
    - `BackButtonInterceptor` hace `router.pop()` → vuelve a `/home`
  - **Comportamiento final:**
    - Stories → Home (con bottom nav oculto durante Stories)
  - **Archivos modificados:**
    - `lib/core/constants/route_constants.dart` - Ruta actualizada a `/home/stories`
    - `lib/core/router/app_router.dart` - Ruta movida dentro del ShellRoute + condición para ocultar bottom nav
    - `lib/features/home/presentation/screens/home_screen.dart` - Ruta actualizada
  - **Documentación:** `docs/back-button-intentos.md` - Añadido Problema Adicional 5

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

- [x] EPIC 10: Notificaciones Push (FCM)
  - **Arquitectura:**
    - Flutter: `NotificationService` pide permiso y guarda token FCM
    - Edge Functions: `send-notification` + `send-daily-reminders`
    - GitHub Actions: Cron cada hora para cubrir timezones
  - **5 notificaciones automáticas:**
    | Trigger | Hora local | Mensaje | Destino |
    |---------|------------|---------|---------|
    | Stories no vistas | 20:00 | "🔥 No pierdas tu racha de X días" | stories |
    | Recordatorio diario | reminder_time | "🙏 Es tu momento de paz" | home |
    | Plan abandonado 3+ días | 18:00 | "📚 {Plan} te espera" | study |
    | Racha perdida ayer | 09:00 | "💪 Tu racha se rompió, ¡pero hoy puedes empezar de nuevo!" | home |
    | Primera semana | Inmediato | "🎉 ¡Una semana seguida!" | home |
  - **Deep links configurables:**
    - `{ "screen": "home" | "stories" | "study" | "chat" }`
    - Se pueden añadir nuevas notificaciones sin re-subir la app
  - **Archivos creados:**
    - `lib/core/services/notification_service.dart` - Servicio Flutter
    - `supabase/functions/send-notification/index.ts` - Envío individual
    - `supabase/functions/send-daily-reminders/index.ts` - Lógica de las 5 notificaciones
    - `.github/workflows/send-notifications.yml` - Cron horario
  - **Archivos modificados:**
    - `lib/features/auth/presentation/screens/splash_screen.dart` - Init servicio
    - `android/app/src/main/AndroidManifest.xml` - Permiso POST_NOTIFICATIONS + channel
    - `ios/Runner/Info.plist` - UIBackgroundModes
    - `lib/features/home/presentation/providers/daily_progress_provider.dart` - Notificación primera semana
    - `lib/core/services/analytics_service.dart` - Eventos de notificaciones
    - `pubspec.yaml` - Dependencia flutter_local_notifications
  - **Secret requerido en Supabase:**
    - `FIREBASE_SERVICE_ACCOUNT` - JSON del Service Account de Firebase
    - Obtener: Firebase Console → Project Settings → Service Accounts → Generate new private key

- [x] Feature: Acceso a Paywall desde Settings
  - **Problema:** El paywall solo se mostraba después del onboarding o al alcanzar límite de mensajes
  - **Solución:** Añadir item "Pásate a Premium" en sección Cuenta de SettingsScreen
  - **Visible solo si:** Usuario NO es premium (`!isPremium`)
  - **Estilo:** Destacado con color dorado (`isHighlighted: true`)
  - **Icono:** `Icons.workspace_premium`
  - **Navegación mejorada:** PaywallScreen ahora usa `context.pop()` en lugar de `context.go(home)`
    - Si viene de Settings → vuelve a Settings
    - Si viene de Chat (límite mensajes) → vuelve al Chat
    - Si viene de Onboarding → continúa flujo normal
  - **Archivos modificados:**
    - `lib/features/settings/presentation/screens/settings_screen.dart` - Nuevo item + import subscription_provider
    - `lib/features/subscription/presentation/screens/paywall_screen.dart` - `pop()` en lugar de `go(home)`

- [x] Feature: Simplificar navegación atrás Android + Cerrar diálogos
  - **Simplificación del BackButtonInterceptor:**
    - Antes: Lógica compleja con `_isMainRoute()`, `_getParentRoute()`, `_getTabIndex()`
    - Después: Solo usa `router.canPop()` para decidir
    - Nueva lógica simple:
      1. Si hay diálogo abierto → cerrarlo
      2. Si `canPop()` → `pop()` (usa historial)
      3. En Home sin historial → minimizar app (moveTaskToBack, como WhatsApp/Instagram)
      4. En otro tab sin historial → ir a Home
  - **Botón atrás en Home minimiza en vez de cerrar:**
    - Antes: `SystemNavigator.pop()` cerraba la activity (cold restart al volver)
    - Después: MethodChannel `moveTaskToBack(true)` minimiza sin destruir (resume instantáneo)
    - `MainActivity.kt`: MethodChannel `ee.bikain.bibliachat/app` con método `moveToBack`
    - `app.dart`: `MethodChannel('ee.bikain.bibliachat/app').invokeMethod('moveToBack')` en Home sin historial
  - **Cierre de diálogos con botón atrás:**
    - **Problema:** `BackButtonInterceptor` intercepta el back button ANTES de que llegue a los diálogos
    - **Intentos fallidos:** Retornar `false` no funciona - el evento no llega al diálogo
    - **Solución:** Cerrar el diálogo manualmente usando `dialogContextProvider`
    - **Patrón implementado:**
      ```dart
      // En app.dart
      final dialogContextProvider = StateProvider<BuildContext?>((ref) => null);

      // En _handleBackButton
      if (dialogContext != null) {
        Navigator.of(dialogContext).pop();
        ref.read(dialogContextProvider.notifier).state = null;
        return true;
      }

      // En cada showDialog
      showDialog(
        builder: (dialogContext) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(dialogContextProvider.notifier).state = dialogContext;
          });
          return AlertDialog(...);
        },
      ).then((_) {
        ref.read(dialogContextProvider.notifier).state = null;
      });
      ```
  - **Archivos modificados:**
    - `lib/app.dart` - Simplificado BackButtonInterceptor + dialogContextProvider
    - `lib/features/settings/presentation/screens/settings_screen.dart` - Diálogos guardan contexto

- [x] Feature: Header fijo en Home y Estudiar
  - **Problema:** En Chat y Perfil el header se quedaba fijo al hacer scroll, pero en Home y Estudiar el header se iba con el contenido
  - **Patrón aplicado (igual que Chat):** `Column > [header, Expanded > SingleChildScrollView > content]`
  - **HomeScreen:** `_buildHeader()` extraído fuera del `SingleChildScrollView`, calendario/progreso/cards siguen scrolleando
  - **StudyScreen:** Header (icono + "Estudiar") extraído fuera del `SingleChildScrollView`, `RefreshIndicator` se mantiene dentro del `Expanded`
  - **Consistencia:** Los 4 tabs ahora tienen header fijo
  - **Archivos modificados:**
    - `lib/features/home/presentation/screens/home_screen.dart` - Column + Expanded pattern
    - `lib/features/study/presentation/screens/study_screen.dart` - Column + Expanded pattern

- [x] Feature: Ocultar bottom nav en rutas anidadas de Estudiar y Perfil
  - **Problema:** Al entrar en detalle de plan o sub-pantallas de perfil, el bottom nav seguía visible ocupando espacio innecesario
  - **Solución:** Ampliar condición `shouldHideBottomNav` en `app_router.dart`
  - **Rutas que ahora ocultan bottom nav:**
    - `/chat/*` (ya existía)
    - `/home/stories` (ya existía)
    - `/study/plan/:planId` — detalle del plan
    - `/study/day/:userPlanId` — día del plan activo
    - `/settings/edit` — editar perfil
    - `/settings/saved-messages` — mis reflexiones
    - `/settings/privacy-policy` — política de privacidad
    - `/settings/terms-conditions` — términos de uso
  - **Archivo modificado:**
    - `lib/core/router/app_router.dart` — condición `shouldHideBottomNav`

- [x] Feature: Configuración App Icon y Nombre de la App
  - **App Store Name:** `Biblia Chat: oracion diaria` (27 chars)
  - **Nombre bajo el icono:** `Biblia Chat` (ambas plataformas)
  - **App Icon:**
    - Archivo fuente: `assets/icon/app_icon.png` (1024x1024)
    - Diseño: Cruz de madera con brillo dorado + burbuja dorada, fondo azul oscuro navy
    - Sin esquinas redondeadas (las tiendas las añaden)
    - Generado con Ideogram AI
  - **flutter_launcher_icons configurado:**
    - Dev dependency: `flutter_launcher_icons: ^0.14.3`
    - Configuración en `pubspec.yaml`
    - Genera todos los tamaños para Android (5) e iOS (13+)
    - Comando: `dart run flutter_launcher_icons`
  - **Archivos generados:**
    - Android: `android/app/src/main/res/mipmap-*/ic_launcher.png`
    - iOS: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
  - **Archivos modificados:**
    - `pubspec.yaml` - Dependencia + configuración flutter_launcher_icons
    - `android/app/src/main/AndroidManifest.xml` - `android:label="Biblia Chat"`
    - `ios/Runner/Info.plist` - `CFBundleName` y `CFBundleDisplayName` = "Biblia Chat"

- [x] Feature: Splash Screen rediseñada + Home Screen UI polish
  - **Splash Screen:**
    - Color de fondo cambiado a `#141A2E` (azul noche oscuro, igual que el fondo de la app)
    - Transición invisible entre splash nativo y Flutter splash
    - `splash_screen.dart` backgroundColor: `Color(0xFF141A2E)`
  - **Imágenes de splash (3 archivos separados por uso):**
    - `splash_logo.png` - Logo completo full quality (cruz+burbuja con fondo redondeado). Uso: HomeScreen header, OnboardingWelcomePage
    - `splash_logo_small.png` - Mismo logo reducido a 500px contenido en canvas 1024x1024. Uso: splash pre-Android 12
    - `splash_icon.png` - Cruz+burbuja SIN fondo (transparente), 500px contenido en 1024x1024. Uso: splash Android 12+ (evita cuadrado visible)
  - **Configuración splash en `pubspec.yaml`:**
    ```yaml
    flutter_native_splash:
      color: "#141A2E"
      image: assets/images/splash_logo_small.png
      android_12:
        color: "#141A2E"
        image: assets/images/splash_icon.png
      ios: true
    ```
  - **HomeScreen header actualizado:**
    - Logo: `splash_logo.png` a 64x64 con `ClipRRect(borderRadius: 14)` y sombra dorada
    - Reemplaza el antiguo círculo dorado con letra "B"
    - Icono de calendario (arriba derecha) ELIMINADO (no hacía nada)
  - **OnboardingWelcomePage:**
    - Usa `splash_logo.png` en lugar de animación Lottie
  - **Fix auth:** Corregido bug de navegación a VerifyEmailScreen con email vacío
  - **Archivos modificados:**
    - `pubspec.yaml` - Configuración splash + assets
    - `lib/features/auth/presentation/screens/splash_screen.dart` - Color fondo #141A2E
    - `lib/features/home/presentation/screens/home_screen.dart` - Logo + eliminar calendario
    - `lib/features/onboarding/presentation/widgets/onboarding_welcome_page.dart` - Logo en vez de Lottie
    - `assets/images/splash_icon.png` - NUEVO (transparente, para Android 12)
    - `assets/images/splash_logo_small.png` - NUEVO (reducido, para splash pre-12)
    - `assets/images/splash_logo.png` - Restaurado a full quality
    - `assets/icon/app_icon.png` - Nuevo diseño oscuro
  - **Comando para regenerar splash:** `dart run flutter_native_splash:create`
  - **IMPORTANTE:** Hay que desinstalar la app para ver cambios en splash (Android cachea a nivel de OS)

- [x] Feature: Calendario semanal interactivo con candados
  - **Objetivo:** El calendario semanal en HomeScreen actúa como selector de día (estilo Bible Chat)
  - **Comportamiento por defecto:** Hoy seleccionado → content cards muestran contenido de hoy
  - **Al tocar otro día:** Las content cards cambian al contenido de ese día
  - **Sistema visual con dos ejes independientes:**
    - **Letra** = indica día SELECCIONADO (dorada si seleccionado, gris si no). Por defecto hoy.
    - **Círculo** = indica COMPLETACIÓN (dorado = completado, transparente = no completado, gris+candado = pasado no completado)
  - **Estados visuales:**
    | Situación | Letra | Círculo | Número | Candado |
    |-----------|-------|---------|--------|---------|
    | Hoy completado | Dorado (si seleccionado) | Gold gradient bright + sombra | Blanco bold | No |
    | Hoy no completado | Dorado (si seleccionado) | Transparente + borde sutil | textSecondary | No |
    | Pasado completado | Gris (dorado si seleccionado) | Gold gradient dimmer (opacity 0.7) | Blanco bold | No |
    | Pasado no completado | Gris (dorado si seleccionado) | Gris sutil | textSecondary | Sí (superpuesto abajo) |
    | Futuro | Gris | Transparente + borde sutil | textTertiary | No |
  - **`_dimGoldGradient`**: Constante estática con colores `0xB3E8C967` / `0xB3D4AF37` (gold al 70% opacity) para días pasados completados
  - **Candado estilo Bible Chat:** Número dentro del círculo + candadito superpuesto en la parte inferior del círculo (usando `Stack` + `Positioned(bottom: 0)`)
  - **Sin check icons:** El color dorado del círculo es el indicador de completación
  - **`_DayState` enum:** `today`, `pastCompleted`, `pastLocked`, `future` (controla tap behavior, no visual)
  - **Content cards adaptativas:**
    - `_isViewingToday` → usa `dailyGospelProvider`, `viewedSlidesProvider` (comportamiento actual)
    - Día pasado → usa `gospelForDateProvider(_selectedDate)` para cargar contenido de ese día
    - Si día completado: slides = {0,1,2} (todo visto)
    - Si día con candado: slides = {} (nada visto)
  - **Progreso adaptativo:**
    - Hoy → `todayProgressProvider` (actual)
    - Día pasado completado → 100%
    - Día pasado con candado → 0%
    - Label cambia: "Progreso de hoy" / "Progreso del día"
  - **Stories de días pasados:**
    - `_openStoriesAtIndex()` acepta `DateTime? forDate`
    - Si `forDate != null`: carga gospel con `gospelForDateProvider(forDate)`
    - Al ver 3 slides de día pasado: `markPastDateAsCompleted(ref, forDate)`
    - SnackBar: "¡Día recuperado! 🔥 X días seguidos"
    - Solo usuarios premium pueden ver Stories de días pasados (free → paywall)
  - **Providers nuevos:**
    - `weekCompletionRefreshProvider` (StateProvider<int>) - trigger de refresco manual
    - `weekCompletionProvider` (FutureProvider<Set<String>>) - fechas completadas de la semana (Lun-Dom)
    - `markPastDateAsCompleted(ref, date)` - marca fecha pasada + invalida streak/weekCompletion
  - **Datasource nuevos métodos:**
    - `getCompletedDatesInRange(start, end)` - query `daily_activity` para rango de fechas
    - `markDateCompleted(date, source)` - upsert para fecha específica (source: `stories_past`)
  - **Archivos modificados:**
    - `lib/features/home/data/datasources/daily_activity_remote_datasource.dart` - 2 métodos nuevos
    - `lib/features/home/presentation/providers/daily_progress_provider.dart` - providers + función
    - `lib/features/home/presentation/screens/home_screen.dart` - calendario interactivo completo
  - **Imports nuevos en home_screen.dart:**
    - `route_constants.dart` (para `RouteConstants.paywall`)
    - `subscription_provider.dart` (para `isPremiumProvider`)

- [x] Fix: Eliminar flicker de carga en HomeScreen + Optimizar splash
  - **Problema:** Al abrir Home, los cards parpadeaban y aparecían de forma fea. Después del fix inicial, el gospel card seguía parpadeando (se cargaba dos veces con el mismo contenido).
  - **Gospel card placeholder (fix inicial):**
    - `_GospelCardPlaceholder`: glass container sutil que reserva el espacio (misma altura que card real)
    - `AnimatedSwitcher` (600ms) para crossfade de placeholder → card real sin layout shift
    - Calendario: animación única de 400ms para toda la Row (en vez de 7 individuales)
    - Guard NUEVO badge: asumir todo visto mientras `isLoading` para evitar flash
  - **Splash screen optimizada (v2 - background services):**
    - RevenueCat + preload diferidos a `_initializeBackgroundServices()` (fire-and-forget DESPUÉS de navegar)
    - Permiso de notificaciones movido a HomeScreen `initState` (no bloquea splash)
    - `_initializeServices()` solo hace FCM init (rápido)
    - Servicios + onboarding check en paralelo
  - **Home sin "impulsos":**
    - Eliminado `TweenAnimationBuilder` individual de `_GospelCardCompact`, `_ContentCard` y `_ActivePlanCard`
    - Cada card tenía su propia animación fade+slide que se disparaba a tiempos diferentes → efecto "a impulsos"
    - Se mantiene: AnimatedSwitcher en gospel card, scale-on-tap, calendar animation 400ms
  - **Fix parpadeo gospel card (causa raíz):**
    - `dailyGospelProvider` usaba `ref.watch(currentUserProfileProvider)` → cuando perfil pasaba de `AsyncLoading` a `AsyncData`, el gospel se re-evaluaba, iba a loading, y recargaba los mismos datos
    - Solución inicial: `await ref.read(currentUserProfileProvider.future)` → espera perfil sin crear dependencia reactiva
    - Mismo patrón aplicado a `gospelForDateProvider`
    - La versión de biblia no cambia durante una sesión, no necesita ser reactivo
  - **Guard en HomeScreen.build() — renderizar todo de golpe:**
    - Problema residual: aunque datos se precargan en splash, Riverpod tiene gap `AsyncLoading → AsyncData` (1-2 frames) y cada provider entrega datos en momentos distintos → UI se construye por partes
    - Guard verifica `hasValue || hasError` de `dailyGospelProvider`, `weekCompletionProvider`, `activePlanDataProvider`
    - Si alguno no tiene datos → muestra solo gradiente de fondo (idéntico a splash → invisible)
    - Safety net `_forceReady` (150ms timer): si providers no resuelven a tiempo, fuerza renderización
    - Cuando todos listos → UI completa de golpe (calendario, gospel, plan activo — todo simultáneo)
  - **Gospel provider: lectura síncrona del perfil (elimina 200ms de delay):**
    - `dailyGospelProvider` tenía dependencia secuencial: `await profile.future` (~200ms) → gospel query (~200ms) = ~400ms
    - Los otros providers empezaban inmediatamente → gospel siempre llegaba último
    - Solución: cambiar `await ref.read(currentUserProfileProvider.future)` → `ref.read(currentUserProfileProvider).valueOrNull`
    - Lectura síncrona: si perfil está cacheado (precargado en splash), usa el valor; si no, default 'RVR1960'
    - Ahora TODOS los providers ejecutan sus queries en paralelo (~200ms cada uno) → resuelven al mismo tiempo
  - **Optimizaciones adicionales:**
    - `analytics_service.dart`: Observer como `late final` (lazy init, evita recrear)
    - `app_router.dart`: Guard `_previousLocation` para evitar state updates redundantes
    - `study_provider.dart`: 3 queries secuenciales → `Future.wait` paralelo
    - `subscription_provider.dart`: Eliminado `_checkPremiumStatus()` redundante post-compra
    - `app.dart`: Eliminados `debugPrint` del back button handler
  - **Archivos modificados (9):**
    - `lib/features/auth/presentation/screens/splash_screen.dart` - Background services, simplificar init
    - `lib/features/home/presentation/screens/home_screen.dart` - Placeholder, eliminar TweenAnimationBuilder, notification permission
    - `lib/features/daily_gospel/presentation/providers/daily_gospel_provider.dart` - ref.read en vez de ref.watch
    - `lib/core/services/notification_service.dart` - Separar init de requestPermission
    - `lib/core/services/analytics_service.dart` - late final observer
    - `lib/core/router/app_router.dart` - Guard _previousLocation
    - `lib/features/study/presentation/providers/study_provider.dart` - Future.wait paralelo
    - `lib/features/subscription/presentation/providers/subscription_provider.dart` - Eliminar check redundante
    - `lib/app.dart` - Eliminar debugPrints

- [x] Fix: Optimizar carga de tabs Chat, Study y Settings
  - **Chat tab (`chat_list_screen.dart`):**
    - Eliminado `TweenAnimationBuilder` staggered (300ms + 50ms/tile) de los chat tiles
    - Los tiles ahora aparecen instantáneamente sin animación "a impulsos"
  - **Study tab (`study_screen.dart`):**
    - Eliminado `TweenAnimationBuilder` staggered (400ms + 60ms/tile) de los plan tiles
    - Header ya no flashea "7 planes" → "6 planes" (siempre muestra total sin filtrar plan activo)
    - Active plan card ahora usa `AnimatedSwitcher` con `ValueKey` para crossfade suave (shimmer → card real)
    - Añadido `super.key` a `_NoActivePlanCard`, `_ActivePlanCard`, `_ActivePlanCardLoading` para AnimatedSwitcher
  - **Settings tab (`settings_screen.dart`):**
    - Stats "Planes Completados" muestra '-' durante loading en vez de '0' (evita flash 0 → valor real)
    - Usa `.when(data:, loading:, error:)` en vez de `.valueOrNull ?? '0'`
  - **Archivos modificados:**
    - `lib/features/chat/presentation/screens/chat_list_screen.dart` - Eliminar TweenAnimationBuilder
    - `lib/features/study/presentation/screens/study_screen.dart` - Eliminar TweenAnimationBuilder + header fix + AnimatedSwitcher
    - `lib/features/settings/presentation/screens/settings_screen.dart` - Stats loading display

- [x] Fix: Teclado no se cierra al tocar fuera en pantallas de auth
  - **Problema:** En LoginScreen, LinkEmailScreen y ResetPasswordScreen, al tocar fuera de los campos de texto el teclado permanecía abierto
  - **Solución:** Envolver `SingleChildScrollView` con `GestureDetector(onTap: () => FocusScope.of(context).unfocus(), behavior: HitTestBehavior.opaque)`
  - `HitTestBehavior.opaque` asegura que el gesto se detecte incluso en espacio vacío
  - **Archivos modificados:**
    - `lib/features/auth/presentation/screens/login_screen.dart`
    - `lib/features/auth/presentation/screens/link_email_screen.dart`
    - `lib/features/auth/presentation/screens/reset_password_screen.dart`

- [x] Feature: Verificación de permisos de notificaciones en Recordatorio
  - **Problema:** El toggle de "Recordatorio diario" en Editar Perfil no verificaba permisos de notificaciones
  - **3 escenarios cubiertos:**
    1. **Toggle OFF → intenta activar sin permiso:** Llama `NotificationService().requestPermission()`, si deniega muestra dialog
    2. **Toggle ON pero permisos revocados desde ajustes del dispositivo:** Al abrir Editar Perfil, `_checkNotificationPermission()` detecta la inconsistencia, desactiva el toggle y muestra dialog
    3. **Toggle ON con permisos OK:** No pasa nada (correcto)
  - **Dialog "Notificaciones desactivadas":**
    - Icono campana apagada en círculo naranja (estilo glassmorphism de la app)
    - Texto explicativo
    - Botón "Ahora no" (gris) + botón "Abrir Ajustes" (dorado)
    - "Abrir Ajustes" abre directamente la configuración de notificaciones del dispositivo
  - **Paquete añadido:** `app_settings: ^7.0.0` - Para abrir ajustes de notificaciones del dispositivo (iOS + Android)
  - **Métodos nuevos:**
    - `_checkNotificationPermission()` - Verifica permisos al cargar perfil usando `FirebaseMessaging.instance.getNotificationSettings()` (solo lectura, no muestra diálogo del sistema)
    - `_showNotificationPermissionDialog()` - Dialog reutilizable para ambos escenarios
  - **Archivos modificados:**
    - `lib/features/profile/presentation/screens/profile_edit_screen.dart` - Toggle con check + dialog + auto-detección
    - `pubspec.yaml` - Dependencia `app_settings`

- [x] Fix: hasChanges incorrecto al auto-desactivar reminder por permisos revocados
  - **Problema:** Cuando `_checkNotificationPermission()` auto-desactivaba el toggle, `hasChanges` se ponía a `true` sin que el usuario hubiera tocado nada. Si luego el usuario activaba permisos y ponía el toggle ON, `hasChanges` volvía a `false` y no podía guardar.
  - **Causa raíz:** `updateReminderEnabled(false)` cambiaba el estado pero no actualizaba `_originalProfile`, la referencia que usa `hasChanges` para comparar.
  - **Solución:** Nuevo método `updateOriginalReminderEnabled()` en `ProfileEditNotifier` que sincroniza la baseline. Se llama junto a `updateReminderEnabled(false)` en `_checkNotificationPermission()`.
  - **Archivos modificados:**
    - `lib/features/profile/presentation/providers/profile_edit_provider.dart` - Nuevo método `updateOriginalReminderEnabled()`
    - `lib/features/profile/presentation/screens/profile_edit_screen.dart` - Llamada al nuevo método

- [x] Docs: Actualización completa de documentación del proyecto
  - **5 documentos actualizados:** PRD, Backlog, Arquitectura, BBDD, Tickets
  - **Cambios principales:**
    - PRD: F-016 (Evangelio+Stories), F-017/F-019 descartados, tabs actualizados
    - Backlog: JS-008, JS-014-JS-025 con estado de implementación
    - Arquitectura: C4 con Firebase/FCM, bounded contexts actualizados, UNIQUE constraint eliminado
    - BBDD: Edge Functions `send-notification` y `send-daily-reminders` documentadas, `max_completion_tokens` corregido
    - Tickets: Sprint 8 con 9 items nuevos, header actualizado

- [x] Feature: Rediseño completo del onboarding (10→11 páginas)
  - **Páginas eliminadas:** Persistencia (Sí/No), Corazón (texto libre)
  - **Páginas nuevas:** Fe (motivación), Apoyo (multi-select), Compromiso
  - **Página Fe (page 5) — single select:**
    - "¿Por qué es importante para ti trabajar en tu Fe ahora?"
    - 4 opciones: `difficult_moment`, `spiritual_growth`, `feeling_distant`, `understand_bible`
    - Guarda key en columna `motive` (antes `first_message`)
  - **Página Apoyo (page 6) — multi-select:**
    - "¿Cómo quieres que te ayudemos en Biblia Chat?"
    - 3 opciones: `talk_faith`, `daily_reflection`, `guided_plans`
    - Guarda keys separadas por coma en columna `features` (antes `motive` enum)
    - `OnboardingSelectionPage` ahora soporta `selectedKeys: Set<String>` para multi-select
  - **Página Compromiso (page 7) — single select:**
    - "¿Qué nivel de compromiso tienes con cumplir tus objetivos?"
    - 2 opciones: `high` (Estoy totalmente comprometido/a), `low` (No estoy muy comprometido/a)
    - Guarda como boolean en `persistence_self_report` (`high` → true, `low` → false)
  - **Total páginas:** 16 (Welcome → Consentimiento → Intro → Nombre → Edad → Género → País → Denominación → Fe → Detalle → Apoyo → Compromiso → Recordatorio → Analizando → Resumen → Plan Preview)
  - **Renames de columnas BD:**
    - `motive` (enum `motive_type`) → `features` (text) — migración 00027
    - `first_message` → `motive` — migración 00028
    - Eliminado enum `MotiveType` de Flutter (ahora `String?`)
  - **OnboardingState actualizado:**
    - `supportTypes: Set<String>` (multi-select) con `toggleSupportType()`
    - `commitmentLevel: String?` con `setCommitmentLevel()`
    - `motive: String?` (antes `heartMessage`) con `setMotive()`
    - Getter `features` devuelve `supportTypes.join(',')`
  - **Fix PaywallScreen:** `context.canPop() ? pop() : go(home)` para evitar crash después de onboarding
  - **Archivos modificados:**
    - `lib/features/onboarding/presentation/screens/onboarding_screen.dart`
    - `lib/features/onboarding/presentation/widgets/onboarding_selection_page.dart` - Multi-select
    - `lib/features/profile/presentation/providers/user_profile_provider.dart`
    - `lib/features/profile/domain/entities/user_profile.dart` - Eliminado `MotiveType` enum
    - `lib/features/profile/data/models/user_profile_model.dart`
    - `lib/features/profile/domain/repositories/user_profile_repository.dart`
    - `lib/features/profile/data/repositories/user_profile_repository_impl.dart`
    - `lib/features/subscription/presentation/screens/paywall_screen.dart` - Fix pop
    - `supabase/migrations/00027_change_motive_to_text.sql`
    - `supabase/migrations/00028_rename_first_message_to_motive.sql`

- [x] Feature: Personalizar onboarding — nombre, género adaptado, links legales (11→12 páginas)
  - **Nueva página Nombre (page 2, originalmente page 1):**
    - Página dedicada con TextField glassmorphism + icono persona
    - Pregunta: "¿Cómo te llamas?" — nombre requerido para continuar
    - Versículo: «Antes de formarte, ya te conocía.» — Jeremías 1:5
    - `TextCapitalization.words` + `textInputAction: TextInputAction.done`
    - `GestureDetector` con `HitTestBehavior.opaque` para cerrar teclado al tocar fuera
  - **Personalización con nombre en subtítulos:**
    - Page 3 (Edad): `"${name}, ¿cuál es tu grupo de edad?"` (si hay nombre)
    - Page 7 (Fe): `"${name}, ¿por qué es importante..."` (si hay nombre)
    - Resto de páginas sin nombre (evitar repetición excesiva)
  - **Género adaptado en labels (después de page 4):**
    - `final isFemale = state.gender == 'female';`
    - Page 7 (Fe): "alejada de Dios" (F) / "alejado de Dios" (M)
    - Page 10 (Compromiso): "comprometida" (F) / "comprometido" (M)
    - Options dejan de ser `const` en estas páginas (se construyen dinámicamente)
  - **Welcome page — links legales clickeables:**
    - Footer con `Text.rich()` + `TextSpan` + `TapGestureRecognizer`
    - "Términos de Servicio" y "Política de Privacidad" como links dorados con underline
    - Callbacks `onPrivacyPolicy` y `onTermsConditions` navegan a pantallas in-app
  - **Welcome page — layout restructurado:**
    - `Column > [Expanded > SingleChildScrollView, Terms pinned at bottom]`
    - Terms siempre visibles sin scroll, pegados al fondo de la pantalla
    - Spacers reducidos: top 10%→6%, gaps 40→24, 32→24, 6%→4%
    - "¿Ya tienes cuenta?" movido debajo del botón (8px gap)
  - **Multi-select hint:**
    - `OnboardingSelectionPage` acepta parámetro `hint` opcional
    - Page 9 (Apoyo) muestra "Puedes seleccionar más de una opción"
  - **Fix animación selección:**
    - `_SelectionTile.didUpdateWidget` ya no reproduce forward→reverse (600ms)
    - Solo hace `_controller.reset()` si se deselecciona durante animación
  - **Provider:**
    - `setName()` añadido a `OnboardingNotifier`
    - `name: state.name` pasado a `completeOnboarding()` (cadena completa ya existía)
  - **Archivos creados:**
    - `lib/features/onboarding/presentation/widgets/onboarding_name_page.dart` - Página dedicada nombre
  - **Archivos modificados:**
    - `lib/features/onboarding/presentation/screens/onboarding_screen.dart` - 15 páginas, nombre, género, links, intro, resumen
    - `lib/features/onboarding/presentation/widgets/onboarding_welcome_page.dart` - Links + layout pinned
    - `lib/features/onboarding/presentation/widgets/onboarding_selection_page.dart` - Hint + fix animación
    - `lib/features/profile/presentation/providers/user_profile_provider.dart` - setName() + name en completeOnboarding

- [x] Feature: Detalle de motivación — follow-up dinámico en onboarding (12→13 páginas)
  - **Nueva página 8 — Detalle de motivación:**
    - Follow-up a la pregunta de Fe (page 7) con 3 sub-opciones dinámicas
    - Contenido cambia según la opción elegida en page 7:
      - `difficult_moment` → "¿Qué tipo de situación estás viviendo?" (familia, salud, económico)
      - `spiritual_growth` → "¿En qué área quieres crecer?" (oración, Biblia, día a día)
      - `feeling_distant` → "¿Qué te ha llevado a sentirte así?" (dejé de practicar, dudas, experiencia)
      - `understand_bible` → "¿Qué te gustaría entender mejor?" (aplicar, contexto, denominaciones)
    - Cada variante tiene versículo bíblico propio
    - **Solo para Firebase Analytics** (segmentación), NO para prompts de IA
  - **Migración 00029:** `motive_detail` (text, nullable) en `user_profiles`
  - **Clean Architecture:** Entity, Model, Repository interface/impl actualizados
  - **OnboardingState:** Campo `motiveDetail` con flag `clearMotiveDetail` en `copyWith`
  - **Edge case:** Al cambiar `motive` (volver a page 6), `motiveDetail` se limpia automáticamente
  - **Analytics:** `motive` y `motive_detail` como user properties en Firebase
  - **Helper `_getMotiveDetailConfig()`:** Devuelve pregunta + opciones + versículo según cada motive
  - **Archivos creados:**
    - `supabase/migrations/00029_add_motive_detail_column.sql`
  - **Archivos modificados:**
    - `lib/features/profile/domain/entities/user_profile.dart` - motiveDetail field
    - `lib/features/profile/data/models/user_profile_model.dart` - Serialización motive_detail
    - `lib/features/profile/domain/repositories/user_profile_repository.dart` - Param motiveDetail
    - `lib/features/profile/data/repositories/user_profile_repository_impl.dart` - Pass motiveDetail
    - `lib/features/profile/presentation/providers/user_profile_provider.dart` - State + notifier + clearMotiveDetail
    - `lib/features/onboarding/presentation/screens/onboarding_screen.dart` - 15 páginas + helper + analytics
    - `lib/core/services/analytics_service.dart` - motive + motive_detail user properties

- [x] Feature: Página introductoria de onboarding (13→14→15 páginas)
  - **Nueva página 1 — Intro:**
    - Página informativa entre Welcome y Nombre
    - Contenido: ✨ emoji en círculo, "Vamos a personalizar tu experiencia", subtítulo breve, botón "Continuar"
    - Sin versículo bíblico (es una transición, no una pregunta)
    - Sin datos que guardar (puramente informativa)
    - Solo recibe `VoidCallback onNext`
  - **Barra de progreso:** Oculta en pages 0 (Welcome) Y 1 (Intro): `_currentPage > 1`
  - **Archivos creados:**
    - `lib/features/onboarding/presentation/widgets/onboarding_intro_page.dart`
  - **Archivos modificados:**
    - `lib/features/onboarding/presentation/screens/onboarding_screen.dart` - 15 páginas, intro page insertada, _canProceed shifted

- [x] Feature: Página motivacional de resumen en onboarding (14→15 páginas)
  - **Nueva página 13 — Resumen motivacional:**
    - Se muestra después de Analizando y antes de ¡Todo listo!
    - Página persuasiva, NO un resumen frío de datos
    - Contenido dinámico basado en respuestas del usuario
  - **Secciones:**
    - Header: "{Name}, tu plan está listo"
    - Card "Tu situación": mapea `motive` + `motiveDetail` a texto legible con barra dorada lateral
    - Card "Lo que haremos juntos": lista `supportTypes` con checks dorados
    - Prueba social: 2 stats dinámicos según `motive` y `supportTypes` (números, no testimonios)
    - Botón "Continuar"
  - **No incluye:** datos fríos (país, edad, denominación)
  - **Archivos creados:**
    - `lib/features/onboarding/presentation/widgets/onboarding_summary_page.dart`
  - **Archivos modificados:**
    - `lib/features/onboarding/presentation/screens/onboarding_screen.dart` - 15 páginas, summary page insertada

- [x] Feature: Pantalla de consentimiento de privacidad GDPR (15→16 páginas)
  - **Nueva página 1 — Consentimiento de privacidad:**
    - Se muestra después de Welcome y antes de Intro
    - GDPR Artículo 9: consentimiento explícito para datos religiosos (denominación)
    - Empresa en Estonia (UE) → GDPR directamente aplicable
  - **Contenido de la página:**
    - Icono escudo dorado + título "Tu privacidad es lo primero"
    - Checkbox 1: "Acepto los Términos de Servicio y la Política de Privacidad" (links clickeables)
    - Checkbox 2: "Consiento el tratamiento de mis datos de creencias religiosas"
    - Botón "Aceptar todo" (marca ambos de golpe)
    - Botón "Continuar" deshabilitado hasta que ambos estén marcados
  - **Consentimiento registrado en BD:**
    - `consent_terms_at` (TIMESTAMPTZ) — cuándo aceptó términos + privacidad
    - `consent_data_at` (TIMESTAMPTZ) — cuándo consintió tratamiento datos religiosos
    - Se guardan al completar onboarding en `user_profile_repository_impl.dart`
  - **Welcome page simplificada:**
    - Eliminado footer "Al continuar, aceptas nuestros Términos..." (redundante con consent page)
    - Eliminados parámetros `onPrivacyPolicy` y `onTermsConditions`
    - Eliminados imports `flutter/gestures.dart`, `lottie`, `lottie_helper` (ya no usados)
  - **Migración 00030:** `consent_terms_at` y `consent_data_at` en `user_profiles`
  - **Archivos creados:**
    - `lib/features/onboarding/presentation/widgets/onboarding_consent_page.dart`
    - `supabase/migrations/00030_add_consent_columns.sql`
  - **Archivos modificados:**
    - `lib/features/onboarding/presentation/screens/onboarding_screen.dart` - 16 páginas, consent page insertada, cases +1
    - `lib/features/onboarding/presentation/widgets/onboarding_welcome_page.dart` - Eliminado footer legal
    - `lib/features/profile/data/repositories/user_profile_repository_impl.dart` - Consent timestamps

- [x] Feature: Plan preview personalizado en onboarding (reemplaza "¡Todo listo!")
  - **Objetivo:** Reemplazar la genérica página "¡Todo listo!" con un plan de 7 días personalizado según motive+motiveDetail
  - **OnboardingPlanPreviewPage (NUEVA):**
    - Timeline visual con 7 day cards + conectores curvos punteados (CustomPainter)
    - Cards alternan posición de icono (izquierda/derecha)
    - Info bar: "7 Sesiones | < 5 min/día"
    - Contenido hardcodeado para las 12 combinaciones motive+detail
    - CTA "Comenzar mi viaje →" (full-width, pinned abajo)
  - **12 planes de estudio personalizados en BD:**
    - 3 para `difficult_moment` (family_issues, health_issues, financial_issues)
    - 3 para `spiritual_growth` (prayer_life, bible_knowledge, daily_faith)
    - 3 para `feeling_distant` (stopped_practicing, doubts, painful_experience)
    - 3 para `understand_bible` (apply_life, historical_context, denomination_differences)
    - Cada plan: 7 días con versículos, reflexión, ejercicio práctico, pregunta
    - UUIDs: `b1000000-0000-0000-0000-000000000001` hasta `...000000000012`
  - **Auto-assign plan al completar onboarding:**
    - `_getRecommendedPlanId(motive, motiveDetail)` mapea 12 combinaciones → plan UUID
    - Llama `startPlan(userId, planId)` después de `completeOnboarding()` exitoso
    - Error silenciado (non-critical)
  - **4 nuevos TOPIC_PROMPTS en Edge Function:**
    - `plan_momento_dificil`, `plan_crecimiento`, `plan_reconexion`, `plan_entender_biblia`
    - Agrupan 3 planes de detalle bajo cada motivo para contexto IA
  - **4 nuevos topic keys en chat_topics:**
    - Migración 00031 los inserta para foreign key de chats
  - **Topic key mapping actualizado en StudyRemoteDatasource:**
    - 12 nuevas entradas en `getPlanTopicKey()` (b1..001 → plan_momento_dificil, etc.)
  - **Migración 00031:** `title` column en plan_days + 4 chat_topics + 12 plans + 84 plan_days
  - **OnboardingReadyPage ELIMINADA** (reemplazada por OnboardingPlanPreviewPage)
  - **Archivos creados:**
    - `lib/features/onboarding/presentation/widgets/onboarding_plan_preview_page.dart`
    - `supabase/migrations/00031_seed_motive_plans.sql`
  - **Archivos modificados:**
    - `lib/features/onboarding/presentation/screens/onboarding_screen.dart` - Plan preview + auto-assign + UUID mapping
    - `lib/features/study/data/datasources/study_remote_datasource.dart` - 12 topic key mappings
    - `supabase/functions/chat-send-message/combined.ts` - 4 TOPIC_PROMPTS
  - **Archivos eliminados:**
    - `lib/features/onboarding/presentation/widgets/onboarding_ready_page.dart`

- [x] Feature: Pulido UX del onboarding — animaciones, hint, conectores, teclado, países
  - **Animación suave de selection tiles:**
    - Fondo del tile: reemplazado `LinearGradient` vs `null` (no interpolable) por colores planos (`primaryColor.withOpacity(0.15)` ↔ `surfaceDark.withOpacity(0.4)`)
    - Borde: ancho fijo a `1` (antes 1→1.5, causaba salto)
    - Icon container: `color: primaryColor` ↔ `surfaceLight` (flat, interpolable)
    - boxShadow: siempre presente con `Colors.transparent` como "off" (antes `null` vs lista)
    - Text label: envuelto en `AnimatedDefaultTextStyle` para transición suave de color/peso
    - Check icon: envuelto en `AnimatedOpacity` (250ms) en vez de ternario widget/null
    - BackdropFilter sigma fijo a 10 (no interpolable, antes cambiaba 8↔12)
    - Todas las duraciones: 350ms con `Curves.easeOutCubic`
  - **Hint multi-select más visible:**
    - Antes: texto gris (`textTertiary`) que pasaba desapercibido
    - Después: pill dorada con fondo `primaryColor.withOpacity(0.1)`, borde dorado, icono `touch_app_outlined` y texto dorado `fontWeight: w500`
  - **Conectores del plan preview en blanco:**
    - Líneas punteadas: `Colors.white.withOpacity(0.25)` (antes `textTertiary.withOpacity(0.35)`)
    - Puntos extremos: `Colors.white.withOpacity(0.4)` (antes `textTertiary.withOpacity(0.5)`)
    - Mucho más visibles sobre el fondo azul noche
  - **Teclado se cierra al navegar:**
    - `FocusScope.of(context).unfocus()` añadido a `_nextPage()` y `_previousPage()`
    - Resuelve: teclado quedaba abierto al pulsar Continuar o flecha atrás desde página de nombre
  - **Países reordenados por población hispana en EE.UU.:**
    - Orden descendente: México (~37M), Puerto Rico (~5.9M), EE.UU. (~4.5M), El Salvador (~2.5M), Cuba (~2.5M), Rep. Dominicana (~2.4M), Guatemala (~1.8M), Colombia (~1.4M), Honduras (~1.1M), Ecuador (~800K), Perú (~700K), Venezuela (~640K), Nicaragua (~460K), Argentina (~300K), Panamá (~210K), España (~170K), Costa Rica (~160K), Chile (~150K), Bolivia (~120K), Uruguay (~65K), Paraguay (~25K)
    - Fuente: Pew Research Center / U.S. Census Bureau (2023)
  - **Logo de la app en pantallas clave del onboarding:**
    - Analizando (page 13): `splash_logo.png` 100x100 con sombra dorada (reemplaza emoji genérico)
    - Plan Preview (page 15): `splash_logo.png` 80x80 con sombra dorada (reemplaza emoji)
    - Intro (page 2): se mantiene emoji ✨ (comunica mejor "personalización")
  - **Resumen motivacional personalizado (page 14):**
    - Título cambiado de "Lo que haremos juntos" a "Tu plan personalizado"
    - Items personalizados con `_getPlanItems()`: incluyen nombre del plan de 7 días, texto de conversación adaptado al motivo
    - `_getPlanName()`: 12 mappings motive:detail → nombre del plan
    - `_getTalkText()`: texto de acompañamiento específico por motivo
    - Cada item tiene icono propio (auto_stories, chat_bubble, wb_sunny, favorite)
    - Stat "19%" cambiado a "69% de lectores habituales reportan mayor paz interior"
  - **Archivos modificados:**
    - `lib/features/onboarding/presentation/widgets/onboarding_selection_page.dart` - Animación suave + hint pill dorada
    - `lib/features/onboarding/presentation/widgets/onboarding_plan_preview_page.dart` - Conectores blancos + logo app
    - `lib/features/onboarding/presentation/widgets/onboarding_analyzing_page.dart` - Logo app
    - `lib/features/onboarding/presentation/widgets/onboarding_summary_page.dart` - Plan personalizado + stats
    - `lib/features/onboarding/presentation/widgets/onboarding_country_page.dart` - Países reordenados
    - `lib/features/onboarding/presentation/screens/onboarding_screen.dart` - Keyboard unfocus en navegación

- [x] Fix: Archivar datos completos al borrar cuenta (delete-account)
  - **Problema:** La Edge Function `delete-account` solo archivaba denomination, origin_group y age_group
  - **Campos nuevos no archivados:** gender, country_code, motive, motive_detail, features, consent_terms_at, consent_data_at
  - **Solución:**
    - Migración 00032: Añade 7 columnas a `deleted_user_archives`
    - Edge Function actualizada para leer y archivar todos los campos del perfil
  - **Importancia GDPR:** Los timestamps de consentimiento (`consent_terms_at`, `consent_data_at`) permiten demostrar cuándo el usuario dio consentimiento incluso después de borrar su cuenta
  - **Archivos creados:**
    - `supabase/migrations/00032_add_archive_columns.sql`
  - **Archivos modificados:**
    - `supabase/functions/delete-account/index.ts` - Select y archive de 7 campos adicionales

- [x] Feature: email_hash para búsqueda legal por email en deleted_user_archives
  - **Problema:** Solo existía `user_id_hash` como clave de búsqueda, pero en un juicio el usuario se identifica por email, no por UUID
  - **Solución:** Añadir `email_hash` (SHA256 del email) como segundo identificador pseudonimizado
  - **Migración 00033:** Columna `email_hash TEXT` en `deleted_user_archives`
  - **Edge Function:** Calcula `SHA256(user.email)` antes de borrar y lo guarda en `email_hash`
  - **Función `hashUserId` renombrada a `sha256`** (genérica, reutilizada para user_id y email)
  - **Búsqueda en juicios:**
    ```sql
    SELECT * FROM deleted_user_archives
    WHERE email_hash = encode(digest('pepe@gmail.com', 'sha256'), 'hex');
    ```
  - **Archivos creados:**
    - `supabase/migrations/00033_add_email_hash_to_archives.sql`
  - **Archivos modificados:**
    - `supabase/functions/delete-account/index.ts` - SHA256 del email + función genérica `sha256()`

- [x] Fix: Auto-detectar verificación de email al volver a la app
  - **Problema:** Después de verificar el email en el navegador, el usuario volvía manualmente a la app y seguía viendo VerifyEmailScreen sin navegación automática a Home
  - **Causa raíz:** La detección dependía del deep link (`com.bibliachats://login-callback`) que dispara `AuthChangeEvent.userUpdated`. Cuando el deep link no se procesa (el usuario vuelve manualmente), ningún evento se dispara
  - **Solución:** Añadir `WidgetsBindingObserver` a `VerifyEmailScreen` para detectar cuando la app vuelve al primer plano (`AppLifecycleState.resumed`). Al detectarlo, llama `refreshSession()` y verifica si `emailConfirmedAt != null`. Si lo está, navega a Home automáticamente
  - **Fallback robusto:** Si el deep link funciona, la navegación ocurre por el listener existente. Si no funciona, el observer detecta el resume y navega
  - **Archivo modificado:**
    - `lib/features/auth/presentation/screens/verify_email_screen.dart` - WidgetsBindingObserver + didChangeAppLifecycleState + _checkEmailVerifiedOnResume

- [x] Feature: Mejorar flujo de vinculación de email (3 estados en Settings)
  - **Problema:** Después de vincular email y volver a Settings sin verificar, la app seguía mostrando "Guardar mi cuenta" como si no hubiera pasado nada. Al intentar vincular de nuevo con la misma contraseña → error en inglés "New password should be different from the old password"
  - **Causa raíz:** Supabase guarda el email en `user.newEmail` (no en `user.email`) hasta que se verifica. Los getters `isAnonymous`, `currentEmail` y `authStatus` solo miraban `user.email`
  - **Solución (3 partes):**
  - **`auth_repository_impl.dart` — Detectar `user.newEmail`:**
    - `isAnonymous`: Ahora comprueba tanto `user.email` como `user.newEmail`
    - `currentEmail`: Devuelve `user.email` si existe, sino `user.newEmail`
    - `authStatus`: Detecta `emailUnverified` si hay `newEmail` pendiente
    - Nuevo caso en `_handleAuthException`: "New password should be different" → mensaje en español + código `same_password`
  - **`settings_screen.dart` — 3 estados de cuenta:**
    - `anonymous` → "Guardar mi cuenta" (dorado) → push a LinkEmailScreen
    - `emailUnverified` → "Verificar tu email" + email (naranja/warning) → push a VerifyEmailScreen
    - `emailVerified` → "Cuenta vinculada" + email
    - Badge en header: "Sin guardar" (anónimo) o "Pendiente" (email sin verificar)
    - Nuevo campo `isWarning` en `SettingsItem` con estilo naranja (fondo + borde)
    - Usa `authStatusProvider` + `AuthStatus` enum en vez de solo `isAnonymousProvider`
  - **`link_email_screen.dart` — Redirect en error `same_password`:**
    - Si el error es `same_password`, redirige automáticamente a VerifyEmailScreen
  - **Flujo de `user.email` vs `user.newEmail` en Supabase:**
    ```
    Anónimo:     email=null,            newEmail=null             → anonymous
    Vinculado:   email=null,            newEmail="pepe@gmail.com" → emailUnverified
    Verificado:  email="pepe@gmail.com", newEmail=null            → emailVerified
    ```
  - **Archivos modificados:**
    - `lib/features/auth/data/repositories/auth_repository_impl.dart` - isAnonymous, currentEmail, authStatus usan newEmail + error same_password
    - `lib/features/settings/presentation/screens/settings_screen.dart` - 3 estados + isWarning + badge Pendiente
    - `lib/features/auth/presentation/screens/link_email_screen.dart` - redirect a VerifyEmailScreen en same_password

- [x] Feature: Nombre real y pill badges en pantalla de Perfil
  - **Nombre del usuario:**
    - Header muestra `profileName` de `currentUserProfileProvider` en vez de "Usuario" hardcodeado
    - Fallback a "Usuario" si no hay nombre (ej: perfil incompleto)
    - Inicial del avatar usa nombre (fallback a email)
  - **Stats como pill badges:**
    - Antes: números grandes con labels debajo (estilo dashboard)
    - Después: pills horizontales compactas con emoji + número + label
    - `🔥 0 Racha` y `📚 0 Planes completados`
    - Estilo glass: fondo `surfaceLight`, borde dorado sutil, `borderRadius: 20`, padding horizontal 8px
    - Responsive: `Flexible` en cada pill + `TextOverflow.ellipsis` en label
    - Padding exterior reducido a 16px para dar más espacio a los pills
  - **Archivo modificado:**
    - `lib/features/settings/presentation/screens/settings_screen.dart` - profileName, avatar initial, pill badges

- [x] Fix: Editar Perfil — pop al guardar + cerrar teclado al tocar fuera
  - **Pop al guardar:** Al guardar cambios, vuelve automáticamente al tab de Perfil (`context.pop()`) en vez de quedarse en la pantalla de edición. Patrón estándar (Instagram, Twitter, Spotify)
  - **Cerrar teclado:** `GestureDetector` con `HitTestBehavior.opaque` + `FocusScope.unfocus()` envolviendo el `SingleChildScrollView`
  - **Archivo modificado:**
    - `lib/features/profile/presentation/screens/profile_edit_screen.dart` - pop on save + dismiss keyboard

- [x] Fix: Notificaciones push no llegaban (token FCM no se guardaba)
  - **Problema raíz:** Los usuarios reales (con onboarding completado y reminder activado) NO tenían token FCM en `user_devices`. Los únicos tokens eran de cuentas anónimas de prueba. Cero overlap entre usuarios con `reminder_enabled = true` y usuarios con token.
  - **Causa:** `NotificationService.init()` solo guardaba el token si el permiso de notificaciones ya estaba concedido. En Android 13+, el permiso no se concede hasta que el usuario lo acepta explícitamente, pero `getToken()` funciona sin permiso.
  - **Diagnóstico realizado:**
    - GitHub Actions workflow: ejecutándose correctamente cada hora (4 jobs verdes)
    - Edge Function `send-daily-reminders`: respondía `total_users: 0` (correcto, nadie tenía token)
    - `FIREBASE_SERVICE_ACCOUNT` secret: configurado correctamente
    - Query `user_devices`: 8 tokens de cuentas anónimas, 0 de usuarios reales
    - Query `user_profiles WHERE reminder_enabled = true`: 8 usuarios, ninguno con token
  - **Fix `notification_service.dart`:**
    - `init()` ahora SIEMPRE intenta guardar el token (`_saveToken()`) sin esperar permiso
    - `requestPermissionIfNeeded()` ahora también guarda el token como safety net (incluso si ya tiene permiso)
    - `onTokenRefresh` se registra una sola vez en `init()` (antes se duplicaba en `_setupAfterPermission()`)
    - Nuevo método `_saveToken()` centralizado con error handling
  - **Fix `send-notifications.yml` (GitHub Actions):**
    - Añadido error handling: `if [ "$http_code" -ge 400 ]; then exit 1; fi`
    - Ahora el workflow muestra rojo si la Edge Function devuelve error (antes siempre verde)
    - NOTA: El PAT de GitHub no tiene scope `workflow`, los cambios al .yml se hacen manualmente en GitHub
  - **Archivos modificados:**
    - `lib/core/services/notification_service.dart` - Guardar token siempre + safety net + centralizar
    - `.github/workflows/send-notifications.yml` - Error handling (actualizado manualmente en GitHub)

- [x] Fix: RLS violation al guardar token FCM (device reuse)
  - **Problema:** Al reusar un dispositivo con otra cuenta, el upsert de token FCM fallaba con RLS violation porque la fila existente en `user_devices` pertenecía al usuario anterior
  - **Causa:** RLS bloquea UPDATE de filas de otros usuarios, y el upsert con `onConflict` intenta hacer UPDATE sobre la fila existente
  - **Solución:** Función SQL `register_device_token()` con `SECURITY DEFINER` que bypasea RLS
    - Borra el token viejo (de cualquier usuario) e inserta uno nuevo para el usuario actual
    - Flutter usa `supabase.rpc('register_device_token')` en vez de upsert directo
  - **Migración:** `00034_register_device_token_function.sql`
  - **Archivos creados:**
    - `supabase/migrations/00034_register_device_token_function.sql`
  - **Archivos modificados:**
    - `lib/core/services/notification_service.dart` - Usa `rpc('register_device_token')` en vez de upsert

- [x] Feature: Icono personalizado en notificaciones Android
  - **Objetivo:** Mostrar el icono de la app (cruz+burbuja) en las notificaciones push en vez del icono genérico de Android
  - **Requisitos Android:** El small icon debe ser monocromo (silueta blanca sobre fondo transparente). Android aplica tinting automáticamente según el tema del dispositivo
  - **5 densidades generadas:**
    - `drawable-mdpi/ic_notification.png` (24x24px)
    - `drawable-hdpi/ic_notification.png` (36x36px)
    - `drawable-xhdpi/ic_notification.png` (48x48px)
    - `drawable-xxhdpi/ic_notification.png` (72x72px)
    - `drawable-xxxhdpi/ic_notification.png` (96x96px)
  - **Configuración:** `com.google.firebase.messaging.default_notification_icon` en AndroidManifest.xml
  - **Archivos creados:**
    - `app_flutter/android/app/src/main/res/drawable-mdpi/ic_notification.png`
    - `app_flutter/android/app/src/main/res/drawable-hdpi/ic_notification.png`
    - `app_flutter/android/app/src/main/res/drawable-xhdpi/ic_notification.png`
    - `app_flutter/android/app/src/main/res/drawable-xxhdpi/ic_notification.png`
    - `app_flutter/android/app/src/main/res/drawable-xxxhdpi/ic_notification.png`
  - **Archivos modificados:**
    - `android/app/src/main/AndroidManifest.xml` - `default_notification_icon` meta-data

- [x] Fix: Paywall muestra mock data cuando RevenueCat no disponible
  - **Problema:** En Android (sin RevenueCat configurado), el paywall mostraba error "No se pudieron cargar los planes" en vez de mostrar precios
  - **Antes:** Solo mostraba mock data en web (`kIsWeb`)
  - **Después:** Muestra mock data ($14.99 mensual / $39.99 anual) en cualquier plataforma cuando RevenueCat no devuelve offerings
  - **Comportamiento:** Cuando RevenueCat esté configurado con productos reales, automáticamente usará datos reales en vez de mock
  - **Eliminado:** Banner "Vista previa (Web)" que solo aparecía en web
  - **Archivo modificado:**
    - `lib/features/subscription/presentation/screens/paywall_screen.dart` - Mock data universal + eliminar banner web

- [x] Feature: Rediseño completo Paywall estilo Bible Chat
  - **Objetivo:** Paywall visualmente idéntica al competidor Bible Chat, adaptada a nuestra paleta de colores
  - **Layout (de arriba a abajo):**
    - Spinner countdown 3s → crossfade a botón X (TweenAnimationBuilder con CircularProgressIndicator determinado)
    - Logo app centrado (splash_logo.png 80x80, sin opacity)
    - Título: "No pierdas ni un solo momento de fe"
    - 3 features con checks dorados: Chat ilimitado, Planes de estudio, Reflexiones diarios
    - Toggle trial (siempre visible): "Quiero probar la aplicacion gratis"
    - Card mensual: "Prueba gratuita de 3 dias" (siempre muestra trial)
    - Card anual: "Acceso Anualmente" + badge rojo "AHORRA 78%"
    - Texto legal fijo: "Cancela en cualquier momento, sin compromiso."
    - CTA dorado (goldGradient): "Pruebalo gratis" (toggle ON) / "Continuar" (toggle OFF)
    - Footer: "Terminos y condiciones · Politica de privacidad · Restaurar"
  - **Toggle behavior:**
    - `_trialEnabled = true` → mensual con trial seleccionado
    - `_trialEnabled = false` → anual seleccionado
    - Tap en card también cambia selección
  - **Spinner countdown:** `_canClose = false` durante 3s, TweenAnimationBuilder llena círculo de 0→1, AnimatedSwitcher crossfade a X
  - **Bordes:** Seleccionado = dorado (0.9 opacity, 2.5px) / No seleccionado = blanco sutil (0.12 opacity, 1px)
  - **Switch:** Bolita blanca, track dorado (ON) / track gris (OFF)
  - **Fix crash navegación legal:** `Navigator.of(context).push(MaterialPageRoute(...))` en vez de `context.push()` (paywall fuera del ShellRoute → duplicate page keys con GoRouter)
  - **Archivo modificado:**
    - `lib/features/subscription/presentation/screens/paywall_screen.dart` - Reescritura completa

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

### Feature Planificada: Widget Versículo en Lock Screen
**Estado:** PLANIFICADO (después de T-0403 Purchase flow)
**Prioridad:** Alta - Feature validada por competencia (Bible Chat centra toda su publicidad en esto)

**Justificación:**
- Bible Chat (competidor directo) usa esta feature como principal gancho publicitario
- Retención pasiva: usuario ve el versículo 50-100 veces/día al mirar el móvil
- Market validated: si gastan en ads solo para esto, han medido que convierte

**Scope técnico:**

| Plataforma | Widget | Tecnología | Complejidad |
|------------|--------|------------|-------------|
| iOS Lock Screen | accessoryRectangular | WidgetKit + SwiftUI | Media |
| iOS Home Screen | systemSmall/Medium | WidgetKit + SwiftUI | Media |
| Android Home Screen | Glance widget | Jetpack Glance (Kotlin) | Media |
| Android Lock Screen | ❌ No disponible | Deprecado en Android 5.0 | N/A |

**Package principal:** `home_widget` v0.9.0
- Sincroniza datos entre Flutter y widgets nativos
- Permite renderizar widgets Flutter como imágenes (`renderFlutterWidget`)
- Requiere código nativo para UI (SwiftUI en iOS, Kotlin/Glance en Android)

**Contenido del widget:**
- Versículo del día (sincronizado con `daily_verse_texts`)
- Actualización diaria (no horaria para simplificar)
- Diseño minimalista con referencia bíblica

**Tiempo estimado:** 4-5 días total
- iOS Lock Screen + Home Screen: 2-3 días
- Android Home Screen: 1-2 días
- Testing y polish: 1 día

**Requisitos iOS:**
- iOS 16+ para Lock Screen widgets (accessory families)
- WidgetKit Extension en Xcode
- App Groups para compartir datos entre app y widget

**Documentación de referencia:**
- Google Codelab: https://codelabs.developers.google.com/flutter-home-screen-widgets
- home_widget package: https://pub.dev/packages/home_widget
- iOS Lock Screen con Flutter: https://medium.com/@ABausG/ios-lockscreen-widgets-with-flutter-and-home-widget-0dfecc18cfa0
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
- [x] Fix: Botones con texto cortado en Estudiar - COMPLETADO
- [x] **EPIC 10**: Notificaciones Push (FCM) - COMPLETADO
- [x] Feature: Acceso a Paywall desde Settings - COMPLETADO
- [x] Feature: Simplificar navegación atrás + Cerrar diálogos - COMPLETADO
- [x] Feature: Configuración App Icon + Nombre - COMPLETADO
- [x] Regenerar app icon sin esquinas redondeadas - COMPLETADO (cruz de madera + burbuja chat)
- [x] Feature: Splash Screen rediseñada (#141A2E) + Home Screen UI polish - COMPLETADO
- [x] **Feature: Calendario semanal interactivo** - Candados en días pasados no completados → Paywall - COMPLETADO
- [x] Fix: Valorar/Compartir pre-publicación - SnackBar + texto sin links (TODO: restaurar post-publicación)
- [x] Fix: Eliminar flicker de carga en HomeScreen + Optimizar splash - COMPLETADO
- [x] Fix: Optimizar carga de tabs Chat, Study y Settings - COMPLETADO
- [x] Fix: Teclado no se cierra al tocar fuera en pantallas de auth - COMPLETADO
- [x] Feature: Verificación de permisos de notificaciones en Recordatorio - COMPLETADO
- [x] Fix: hasChanges incorrecto al auto-desactivar reminder - COMPLETADO
- [x] Docs: Actualización completa de documentación (PRD, Backlog, Arquitectura, BBDD, Tickets) - COMPLETADO
- [x] Feature: Rediseño onboarding (11 páginas) - Fe + Apoyo multi-select + Compromiso + renames BD - COMPLETADO
- [x] Feature: Personalizar onboarding — nombre, género adaptado, links legales (11→12 páginas) - COMPLETADO
- [x] Feature: Detalle de motivación — follow-up dinámico (12→13 páginas) - COMPLETADO
- [x] Feature: Página introductoria de onboarding (13→14 páginas) - COMPLETADO
- [x] Feature: Página motivacional de resumen (14→15 páginas) - COMPLETADO
- [x] Feature: Pantalla de consentimiento GDPR (15→16 páginas) - COMPLETADO
- [x] Feature: Plan preview personalizado en onboarding + 12 planes de motivo en BD - COMPLETADO
- [x] Feature: Pulido UX onboarding — animaciones suaves, hint visible, conectores blancos, teclado, países - COMPLETADO
- [x] Fix: RLS violation al guardar token FCM (device reuse) - COMPLETADO
- [x] Feature: Icono personalizado en notificaciones Android - COMPLETADO
- [x] Fix: Paywall muestra mock data cuando RevenueCat no disponible - COMPLETADO
- [x] Feature: Rediseño completo Paywall estilo Bible Chat - COMPLETADO
- [ ] T-0403: Purchase flow (requiere build iOS/Android)
- [ ] RevenueCat Android (pospuesto - requiere subir APK a Play Console primero)
- [ ] **Feature: Widget versículo en Lock Screen** (iOS) + Home Screen (Android) - PLANIFICADO

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
- **Topics soportados (23):**
  - *Generales (12):* `familia_separada`, `desempleo`, `solteria`, `ansiedad_miedo`, `identidad_bicultural`, `reconciliacion`, `sacramentos`, `oracion`, `preguntas_biblia`, `evangelio_del_dia`, `lectura_del_dia`, `otro`
  - *Planes pecados capitales (7):* `plan_soberbia`, `plan_avaricia`, `plan_lujuria`, `plan_ira`, `plan_gula`, `plan_envidia`, `plan_pereza`
  - *Planes de motivo (4):* `plan_momento_dificil`, `plan_crecimiento`, `plan_reconexion`, `plan_entender_biblia`
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
  - Usa SHA256 hash del user_id y del email (no reversibles, pero buscables)
  - Si usuario se identifica (email en juicio), se calcula SHA256 del email y se busca en `email_hash`
- **Datos archivados:**
  - `user_id_hash`: SHA256 del user_id original (búsqueda por UUID)
  - `email_hash`: SHA256 del email (búsqueda por email en juicios)
  - `chat_messages`: JSON con todos los mensajes (role, content, created_at)
  - `plans_data`: Progreso de planes (nombre, status, días completados)
  - Demografía: denomination, origin_group, age_group, gender, country_code
  - Motivación: motive, motive_detail, features
  - Consentimiento GDPR: consent_terms_at, consent_data_at
  - Métricas: total_messages, streak_max, plans_started/completed
- **Retención:** 3 años (expires_at = archived_at + 3 years)
- **PII eliminada:** nombre, email, device tokens, rc_app_user_id
- **Request:** POST con Authorization header (JWT del usuario)
- **Response:** `{ success: true/false, message/error }`
- **Secrets requeridos:** Ninguno adicional (usa SUPABASE_SERVICE_ROLE_KEY del entorno)

### `send-notification` (DESPLEGADA)
- **Ubicación:** `supabase/functions/send-notification/index.ts`
- **Propósito:** Enviar notificación push a un usuario específico via FCM HTTP v1 API
- **Request:** `{ user_id, title, body, data?: { screen } }`
  - `screen`: "home" | "stories" | "study" | "chat"
- **Response:** `{ success, sent, failed, removed_invalid }`
- **Flujo:**
  1. Obtiene tokens FCM del usuario desde `user_devices`
  2. Genera JWT firmado con Service Account de Firebase
  3. Intercambia JWT por access token de Google
  4. Envía push a todos los dispositivos del usuario
  5. Elimina tokens inválidos (UNREGISTERED) de la BD
- **Configuración por plataforma:**
  - Android: priority high, channel_id "biblia_chat_channel"
  - iOS: sound default, badge 1
- **Secrets requeridos:**
  - `FIREBASE_SERVICE_ACCOUNT` (JSON completo del Service Account)

### `send-daily-reminders` (DESPLEGADA)
- **Ubicación:** `supabase/functions/send-daily-reminders/index.ts`
- **Propósito:** Procesar las 5 notificaciones automáticas
- **Request:** `{ type: "stories_missed" | "daily_reminder" | "plan_abandoned" | "streak_lost" }`
- **Tipos de notificación:**
  | Tipo | Hora local | Título | Destino |
  |------|------------|--------|---------|
  | `stories_missed` | 20:00 | "🔥 No pierdas tu racha de X días" | stories |
  | `daily_reminder` | reminder_time del usuario | "🙏 Es tu momento de paz" | home |
  | `plan_abandoned` | 18:00 | "📚 {Plan} te espera" | study |
  | `streak_lost` | 09:00 | "💪 Tu racha se rompió, ¡pero hoy puedes empezar de nuevo!" | home |
- **Lógica de timezone:**
  - Cada tipo filtra usuarios según su hora local
  - Usa `user_profiles.timezone` (default: America/New_York)
  - El cron de GitHub Actions se ejecuta cada hora
- **Dependencia:** Llama a `send-notification` para cada usuario
- **Secrets requeridos:** Ninguno adicional (usa SERVICE_ROLE_KEY)

## GitHub Actions

### `daily-gospel.yml`
- **Ubicación:** `.github/workflows/daily-gospel.yml`
- **Propósito:** Ejecutar automáticamente la Edge Function cada día
- **Cron:** `0 6 * * *` (6:00 AM UTC = 7:00 AM España)
- **Trigger manual:** `workflow_dispatch` permite ejecución manual desde GitHub
- **Secret requerido:** `SUPABASE_SERVICE_ROLE_KEY` (configurado en GitHub → Settings → Secrets)

### `send-notifications.yml`
- **Ubicación:** `.github/workflows/send-notifications.yml`
- **Propósito:** Enviar notificaciones push automáticas
- **Cron:** `0 * * * *` (cada hora, para cubrir todos los timezones)
- **Trigger manual:** `workflow_dispatch` con selector de tipo de notificación
- **Jobs paralelos:**
  - `send-daily-reminder` - Recordatorio a la hora elegida por usuario
  - `send-stories-missed` - A las 20:00 hora local
  - `send-plan-abandoned` - A las 18:00 hora local
  - `send-streak-lost` - A las 09:00 hora local
- **Secret requerido:** `SUPABASE_SERVICE_ROLE_KEY`

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
- **Navegación fullscreen (ocultar bottom nav) con back button funcional:**
  - **CORRECTO:** Definir ruta DENTRO del ShellRoute y ocultar bottom nav condicionalmente
  - La ruta DENTRO del ShellRoute permite que `MainShell.build()` actualice `currentLocationProvider`
  - El `BackButtonInterceptor` lee la ubicación correcta y hace `router.pop()`
  - Ocultar bottom nav: `shouldHideBottomNav = location == '/home/stories' || location.startsWith('/chat/')`
  - **INCORRECTO:** Definir ruta FUERA del ShellRoute - `currentLocationProvider` no se actualiza, back button cierra la app
  - **INCORRECTO:** `Navigator.of(context, rootNavigator: true).push()` - bypasea GoRouter completamente
  - Ejemplo: `/home/stories` está dentro del ShellRoute con bottom nav oculto → fullscreen + back button funcional
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
- **Botón atrás Android — BackButtonInterceptor + MethodChannel:**
  - `BackButtonInterceptor` en `app.dart` maneja TODA la lógica de back button
  - Lógica: diálogo abierto → cerrar | canPop → pop | Home → moveTaskToBack | otro tab → ir a Home
  - `moveTaskToBack(true)` via MethodChannel `ee.bikain.bibliachat/app` → minimiza app sin destruir (como WhatsApp)
  - NO usar `SystemNavigator.pop()` → destruye activity, cold restart al volver (mala UX)
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
- **Botones en Containers de altura fija:**
  - Si envuelves un `ElevatedButton` en un `Container(height: X)` con gradiente/decoración, el texto puede cortarse
  - **Causa:** `ElevatedButton` tiene `minimumSize` (~64dp) y `padding` (~24px) por defecto
  - Estos valores internos comprimen el contenido dentro del Container fijo
  - **Solución:** Añadir ambos al style:
    ```dart
    Container(
      height: 50,
      decoration: BoxDecoration(gradient: ...),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          minimumSize: Size.zero,    // ← Quita tamaño mínimo
          padding: EdgeInsets.zero,  // ← Quita padding interno
          shape: RoundedRectangleBorder(...),
        ),
        child: Text('Botón largo'),
      ),
    )
    ```
  - Archivos afectados: `study_screen.dart`, `plan_day_screen.dart`, `plan_detail_screen.dart`
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
    final shouldHideBottomNav =
        (location.startsWith('/chat/') && location != '/chat') ||
        (location.startsWith('/study/') && location != '/study') ||
        (location.startsWith('/settings/') && location != '/settings') ||
        location == '/home/stories';
    ```
  - Patrón: `location.startsWith('/tab/') && location != '/tab'` — oculta en cualquier ruta anidada del tab
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
- **Cerrar diálogos con botón atrás Android (BackButtonInterceptor + showDialog):**
  - `BackButtonInterceptor` intercepta el back button ANTES de que llegue a los diálogos
  - Retornar `false` del interceptor NO funciona - el evento no llega al diálogo
  - **Solución:** Guardar el contexto del diálogo en un provider y cerrarlo manualmente
  - Patrón:
    ```dart
    // En app.dart
    final dialogContextProvider = StateProvider<BuildContext?>((ref) => null);

    // En _handleBackButton (PRIMERO, antes de cualquier otra lógica)
    final dialogContext = ref.read(dialogContextProvider);
    if (dialogContext != null) {
      Navigator.of(dialogContext).pop();
      ref.read(dialogContextProvider.notifier).state = null;
      return true;
    }

    // En cada showDialog
    showDialog(
      context: context,
      builder: (dialogContext) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(dialogContextProvider.notifier).state = dialogContext;
        });
        return AlertDialog(...);
      },
    ).then((_) {
      ref.read(dialogContextProvider.notifier).state = null;
    });
    ```
  - Afecta: Diálogos de cerrar sesión, borrar cuenta, y cualquier otro showDialog
- **AnimatedSwitcher para crossfade sin layout shift:**
  - Problema: `SizedBox.shrink()` → widget real causa salto de layout (empuja contenido abajo)
  - `AnimatedSize` suaviza el crecimiento pero sigue empujando contenido
  - **Solución:** Placeholder con misma altura + `AnimatedSwitcher` para crossfade
  - Cada widget hijo necesita `ValueKey` distinto para que `AnimatedSwitcher` detecte el cambio
  - Ejemplo:
    ```dart
    AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      child: isLoading
          ? const Placeholder(key: ValueKey('placeholder'))
          : RealWidget(key: ValueKey('real')),
    );
    ```
- **Paralelizar inicialización en splash screen:**
  - `Future.wait` con `.catchError` individual para que un fallo no bloquee al otro
  - Lanzar futures sin `await` y luego esperarlos permite ejecución paralela:
    ```dart
    final servicesFuture = _initializeServices(userId);
    final onboardingFuture = repository.hasCompletedOnboarding();
    await servicesFuture;
    final result = await onboardingFuture;
    ```
  - `FlutterNativeSplash.remove()` debe ir DESPUÉS de la precarga para que el splash nativo cubra la espera
- **Guard en build() para renderizar UI completa de golpe:**
  - Problema: Riverpod `AsyncLoading → AsyncData` ocurre en microtask posterior al `await .future` del splash → Home se renderiza con datos parciales por 1-2 frames
  - Solución: Guard que verifica `hasValue || hasError` de todos los providers críticos antes de renderizar
  - Si alguno no tiene datos → mostrar solo gradiente de fondo (idéntico a splash → invisible)
  - Safety net: `_forceReady` con timer de 150ms para garantizar que la UI nunca se bloquea indefinidamente
  - NO usar `!isLoading` (puede quedarse bloqueado si provider nunca resuelve) → usar `hasValue || hasError`
- **Lectura síncrona de providers cacheados (eliminar dependencias secuenciales):**
  - Problema: `await ref.read(provider.future)` dentro de otro FutureProvider crea dependencia secuencial (200ms extra)
  - Solución: `ref.read(provider).valueOrNull?.field ?? default` — lectura síncrona del cache
  - Si el provider fue precargado en splash, `.valueOrNull` devuelve el valor inmediatamente
  - Si no fue precargado, devuelve null → usar valor por defecto
  - Ejemplo: gospel provider lee versión de biblia del perfil cacheado en vez de await
- **Header fijo con contenido scrollable (patrón Column + Expanded):**
  - NO poner el header dentro del `SingleChildScrollView` (se va con el scroll)
  - Patrón correcto: `Column > [header, Expanded > SingleChildScrollView > content]`
  - El `Expanded` asegura que el `SingleChildScrollView` ocupe el espacio restante
  - Si hay `RefreshIndicator`, va dentro del `Expanded` (envolviendo el `SingleChildScrollView`)
  - Usado en las 4 pantallas principales: Home, Chat, Study, Settings
- **Cerrar teclado al tocar fuera de text fields:**
  - Envolver el `SingleChildScrollView` (o body) con `GestureDetector`:
    ```dart
    GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: SingleChildScrollView(...),
    )
    ```
  - `HitTestBehavior.opaque` es necesario para que el gesto se detecte en espacio vacío (sin widgets)
  - Aplicar en todas las pantallas con formularios (auth screens, etc.)
- **AnimatedContainer NO interpola entre gradient y null:**
  - `AnimatedContainer` puede interpolar entre dos `Color` pero NO entre un `LinearGradient` y `null` — hace snap instantáneo
  - Solución: usar `color:` plano en ambos estados (ej: `primaryColor.withOpacity(0.15)` ↔ `surfaceDark.withOpacity(0.4)`)
  - Lo mismo aplica a `boxShadow`: no interpola entre lista y null — siempre proveer un `BoxShadow` con `Colors.transparent` como "off"
  - Para widgets que aparecen/desaparecen: NO usar ternario `widget : null` — usar `AnimatedOpacity` envolviendo el widget siempre presente
  - Para texto con cambio de color/peso: envolver en `AnimatedDefaultTextStyle`
  - `BackdropFilter` sigma no se puede animar — usar valor fijo
- **Verificar permisos de notificaciones sin mostrar diálogo del sistema:**
  - `FirebaseMessaging.instance.getNotificationSettings()` es solo lectura (no solicita permiso)
  - Útil para detectar permisos revocados desde ajustes del dispositivo
  - `requestPermission()` muestra el diálogo del sistema (solo la primera vez en iOS, puede repetir en Android)
  - Paquete `app_settings` para abrir ajustes de notificaciones: `AppSettings.openAppSettings(type: AppSettingsType.notification)`
- **Detectar verificación de email al volver a la app (WidgetsBindingObserver):**
  - El deep link (`com.bibliachats://login-callback`) no siempre se procesa al verificar email
  - Fallback: `WidgetsBindingObserver` en `VerifyEmailScreen` detecta `AppLifecycleState.resumed`
  - Al volver al primer plano: `Supabase.instance.client.auth.refreshSession()` + verificar `emailConfirmedAt != null`
  - Si verificado → `context.go(RouteConstants.home)`
  - Dos capas de detección: deep link (listener `onAuthStateChange`) + resume observer (fallback)
  - IMPORTANTE: añadir `removeObserver(this)` en `dispose()` para evitar memory leaks
- **Supabase `user.email` vs `user.newEmail` (vinculación de cuenta anónima):**
  - Al llamar `updateUser(email, password)` en un usuario anónimo, Supabase pone el email en `user.newEmail` (NO en `user.email`) hasta que se verifica
  - `user.email` permanece null hasta confirmar → `isAnonymous` basado solo en `user.email` dará resultado incorrecto
  - Después de verificar: `user.email` se llena y `user.newEmail` se limpia
  - Siempre comprobar ambos campos: `user.email` (confirmado) y `user.newEmail` (pendiente)
  - `currentEmail` debe priorizar `user.email ?? user.newEmail` para mostrar el email correcto en la UI
  - Propiedad `newEmail` está en `gotrue-dart` User class (campo JSON `new_email`)
- **FCM token en Android: guardar siempre, no esperar permiso:**
  - En Android, `FirebaseMessaging.instance.getToken()` funciona SIN permiso de notificaciones
  - El permiso solo controla si la notificación se MUESTRA, no si el token existe
  - En iOS, `getToken()` puede devolver null sin permiso
  - **Patrón correcto:** Guardar token en `init()` siempre + guardar de nuevo en `requestPermissionIfNeeded()` como safety net
  - **Patrón incorrecto:** Solo guardar token dentro de `_setupAfterPermission()` que se ejecuta condicionalmente
  - Si el token se guarda sin permiso, FCM puede enviar mensajes pero el dispositivo no los muestra hasta que el usuario conceda permiso
- **GitHub Actions: PAT sin scope `workflow`:**
  - El Personal Access Token de GitHub no puede pushear cambios a `.github/workflows/`
  - Error: "refusing to allow a Personal Access Token to create or update workflow without `workflow` scope"
  - **Workaround:** Editar los archivos de workflow directamente en GitHub (lápiz → Edit)
  - Al copiar YAML desde el chat, se introducen espacios invisibles → copiar siempre desde archivo local
- **Icono de notificación Android (small icon):**
  - Debe ser monocromo (blanco sobre transparente). Android aplica tinting automáticamente según tema del dispositivo
  - Se configura con `com.google.firebase.messaging.default_notification_icon` en AndroidManifest.xml
  - Generarlo en 5 densidades: mdpi (24px), hdpi (36px), xhdpi (48px), xxhdpi (72px), xxxhdpi (96px)
  - El nombre del recurso (ej: `ic_notification`) se referencia con `@drawable/ic_notification`
  - Si no se configura, Android usa el icono de la app que puede verse como un cuadrado blanco
- **RLS y device token reuse (upsert cross-user):**
  - Cuando el mismo dispositivo cambia de usuario (logout + login con otra cuenta), un upsert con `onConflict` en `user_devices` falla
  - **Causa:** RLS bloquea UPDATE de filas que pertenecen a otro usuario (la fila existente tiene el `user_id` anterior)
  - **Solución:** Función SQL con `SECURITY DEFINER` que bypasea RLS:
    1. Borra la fila existente con ese token (de cualquier usuario)
    2. Inserta nueva fila con el usuario actual
  - Flutter llama `supabase.rpc('register_device_token', params: {...})` en vez de `.upsert()`
  - Este patrón aplica a cualquier tabla donde un recurso físico (dispositivo, token) puede cambiar de dueño
- **Navegación desde rutas fuera del ShellRoute (GoRouter duplicate page keys):**
  - Rutas como `/paywall` que están fuera del ShellRoute NO pueden usar `context.push()` para navegar a rutas dentro del ShellRoute (ej: `/settings/terms-conditions`)
  - **Error:** `!keyReservation.contains(key)` — GoRouter intenta crear páginas duplicadas
  - **Solución:** Usar `Navigator.of(context).push(MaterialPageRoute(builder: (_) => Screen()))` para navegación directa sin GoRouter
  - Esto bypasea GoRouter completamente, pero es seguro para pantallas standalone (legales, etc.)
  - El botón atrás nativo funciona correctamente con `Navigator.pop()`
