# CLAUDE.md - Memoria del Proyecto Biblia Chat

## Descripción del Proyecto
**Biblia Chat** - App cristiana móvil (iOS + Android) diseñada para hispanohablantes en EE.UU. Combina IA denominacional, devocionales personalizados y planes de estudio temáticos.

**Propuesta de valor:** "La app cristiana hecha para ti. Que entiende tu fe, tu idioma, tu cultura."

## Stack Tecnológico
- **Frontend:** Flutter (iOS 14.5+ / Android 6.0+)
- **Backend/DB/Auth:** Supabase (PostgreSQL + Auth + RLS + Edge Functions)
- **IA:** OpenAI API (GPT-3.5-turbo o GPT-4)
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
- `user_profiles` (incluye `ai_memory` para personalización IA)
- `chats` + `chat_messages` (hilos por tema)
- `saved_messages`
- `plans` + `plan_days` + `user_plans` + `user_plan_days`
- `daily_verses` + `daily_verse_texts`
- `devotions` + `devotion_variants` + `user_devotions`
- `daily_activity` (rachas)
- `user_points` + `badges` + `user_badges`
- `user_devices` (FCM tokens)
- `user_entitlements` (premium status)

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
  - 11 migraciones SQL creadas y ejecutadas:
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

- [x] T-0201: Setup Flutter project
  - Proyecto Flutter creado (`app_flutter`)
  - Clean Architecture implementada
  - Dependencias instaladas (supabase_flutter, riverpod, go_router, etc.)
  - Navegación con GoRouter + ShellRoute (bottom navigation)
  - Tema Material 3 (light/dark)
  - Pantallas creadas:
    - SplashScreen (auth anónimo automático)
    - OnboardingScreen (10 páginas: Welcome → Edad → Género → País → Denominación → Biblia → Motivo → Corazón → Análisis → Ready)
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
  - **Pantallas de onboarding (10 páginas):**
    - Welcome (nombre)
    - Edad (age_group)
    - Género (gender) - Hombre/Mujer
    - País (origin) - Dropdown 21 países hispanohablantes → mapea a origin_group
    - Denominación
    - Versión Biblia
    - Motivo (tipo de apoyo)
    - Corazón (primer mensaje libre)
    - Análisis (animación)
    - Ready (confirmación)
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
- RLS se prueba desde el día 1
- `openai_conversation_id` existe pero NO se usa en runtime MVP
- Prompt ordenado: base → dinámico → ai_memory → context_summary → últimos 12 mensajes
- La IA no debe inventar datos que no estén en ai_memory o historial

## Notas Técnicas Flutter
- **Flutter version:** 3.35.3 (stable)
- **Dart version:** 3.5.4
- **IMPORTANTE CardTheme:** En ThemeData usar `CardThemeData()` (NO `CardTheme`)
  - El analizador de WSL puede mostrar error falso, ignorar
  - El compilador de Windows requiere `CardThemeData`
- BackdropFilter puede ser pesado en Android antiguos - usar con moderación
- Los widgets glass usan `ImageFilter.blur(sigmaX: 8-12, sigmaY: 8-12)`
- Paquetes UI instalados: `shimmer`, `lottie`, `flutter_animate`
