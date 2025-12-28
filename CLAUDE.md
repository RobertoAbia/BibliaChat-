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
- **Analytics:** Firebase Analytics + Mixpanel

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
├── .github/
│   └── workflows/
│       └── daily-gospel.yml  # Cron diario para fetch-daily-gospel
├── docs/                 # Documentación del proyecto
│   ├── 01.Product Requeriments Document (PRD).md
│   ├── 02.Historias de usuario. Backlog.md
│   ├── 03.Casos de Uso, Arquitectura y C4.md
│   ├── 04.BBDD.md
│   └── 05.Tickets de Trabajo.md
├── .env.example
├── .gitignore
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
- `user_profiles` (incluye `ai_memory`, `rc_app_user_id`, `gender`)
- `chats` + `chat_messages` (hilos por tema)
- `saved_messages`
- `plans` + `plan_days` + `user_plans` + `user_plan_days`
- `daily_verses` + `daily_verse_texts` (incluye `verse_summary`, `key_concept`, `practical_exercise`)
- `devotions` + `devotion_variants` + `user_devotions`
- `daily_activity` (rachas)
- `user_points` + `badges` + `user_badges`
- `user_devices` (FCM tokens)
- `user_entitlements` (premium status)

## Migraciones SQL (13 total)
- 00001-00009: Tablas core, ENUMs, RLS, índices
- 00010: `rc_app_user_id` para restaurar compras
- 00011: `gender` + enum `gender_type`
- 00012: `verse_summary` para resumen IA
- 00013: `key_concept` + `practical_exercise` para Stories

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
    - OnboardingScreen (12 páginas: Welcome → Edad → Género → País → Denominación → Biblia → Motivo → Recordatorio → Persistencia → Corazón → Análisis → Ready)
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
  - **Pantallas de onboarding (12 páginas):**
    - 0: Welcome (nombre)
    - 1: Edad (age_group)
    - 2: Género (gender) - Hombre/Mujer
    - 3: País (origin) - Dropdown 21 países hispanohablantes → mapea a origin_group
    - 4: Denominación
    - 5: Versión Biblia
    - 6: Motivo (tipo de apoyo)
    - 7: Recordatorio (reminder_enabled, reminder_time) - Toggle + Time picker
    - 8: Persistencia (persistence_self_report) - Sí/No para recomendar planes
    - 9: Corazón (primer mensaje libre)
    - 10: Análisis (animación)
    - 11: Ready (confirmación + auto-detección timezone)
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
    - Obtiene texto en español de API.Bible (Reina Valera 1960)
    - Genera contenido con **OpenAI GPT-5.2**:
      - Resumen coloquial (300-500 caracteres)
      - Concepto clave (frase impactante 60-100 chars)
      - Ejercicio práctico (acción física/material 100-180 chars)
    - Guarda en `daily_verses` + `daily_verse_texts`
    - **00012:** Nueva columna `verse_summary` para resumen IA
    - **00013:** Nuevas columnas `key_concept` y `practical_exercise`
  - **APIs utilizadas:**
    - Catholic Readings API (pública, sin key) - calendario litúrgico
    - API.Bible (key requerida) - texto bíblico en español
    - OpenAI GPT-5.2 API (key requerida) - generación de contenido Stories
  - **Secrets en Supabase:**
    - `API_BIBLE_KEY` - Clave de API.Bible
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

### Próximos Pasos
- [ ] T-0003: Configurar proyecto Supabase (prod)
- [ ] T-0301: Auth flow completo (email upgrade)
- [ ] T-0401: Integrar RevenueCat
- [ ] T-0501: Edge Function para chat IA
- [ ] T-0701: Conectar pantallas con Supabase (datos reales)

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

## Edge Functions (Supabase)

### `fetch-daily-gospel` (desplegada como `clever-worker`)
- **Ubicación:** `supabase/functions/fetch-daily-gospel/index.ts`
- **Nombre en Supabase:** `clever-worker`
- **Propósito:** Obtener y procesar el evangelio del día
- **Ejecución automática:** GitHub Actions cron diario a las 6:00 AM UTC
- **APIs externas:**
  - Catholic Readings API (calendario litúrgico)
  - API.Bible (texto bíblico RVR1960)
  - OpenAI GPT-5.2 (generación de contenido)
- **Contenido generado:**
  - `verse_summary`: Resumen coloquial (300-500 chars)
  - `key_concept`: Frase impactante (60-100 chars)
  - `practical_exercise`: Acción física/material (100-180 chars)
- **Características técnicas:**
  - Maneja versículos no contiguos (ej: "13-15, 19-23") con múltiples llamadas a API.Bible
  - Prompt optimizado para español de España, segunda persona singular (tú)
- **Secrets requeridos:**
  - `OPENAI_API_KEY`
  - `API_BIBLE_KEY`

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
- **TextField sin contenedores anidados:**
  - Usar Container con borde + TextField con `fillColor: Colors.transparent`, `filled: false`
  - Evitar GlassContainer.input() que crea efecto de caja dentro de caja
- **Capturar tap antes de perder focus:**
  - Usar `Listener` con `onPointerDown` en lugar de `GestureDetector` con `onTap`
  - El `onPointerDown` se dispara antes de que el sistema de focus procese el evento
