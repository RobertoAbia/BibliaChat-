# Biblia Chat

**La app cristiana hecha para ti. Que entiende tu fe, tu idioma, tu cultura.**

App móvil (iOS + Android) para práctica diaria de fe cristiana, personalizada según denominación, origen cultural y problemas personales del usuario hispanohablante en EE.UU.

## Stack Tecnológico

| Componente | Tecnología |
|------------|------------|
| Frontend | Flutter 3.35+ (iOS 14.5+ / Android 6.0+) |
| Backend/DB/Auth | Supabase (PostgreSQL + Auth + RLS + Edge Functions) |
| IA | OpenAI GPT-4o (chat) + GPT-4o-mini (memorias) + GPT-5.2 (Stories) |
| Pagos | RevenueCat + In-App Purchases |
| Notificaciones | Firebase Cloud Messaging (FCM HTTP v1 API) |
| Analytics | Firebase Analytics (integrado y verificado) |

## Modelo de Negocio

- **Freemium con trial 3 días** (toggle opcional en plan mensual)
- **Free**: 5 mensajes/día de chat
- **Premium**: Chat ilimitado + todas las features
- Mensual: $14.99/mes
- Anual: $39.99/año (ahorra 78%)

## 3 Pilares de la App

1. **HOY** - Retención diaria (racha, evangelio del día con Stories, devoción, oración)
2. **CHAT** - IA denominacional con 12 temas hispanos (sistema híbrido: chats libres + guiados)
3. **ESTUDIAR** - 7 planes de estudio temáticos (pecados capitales → virtudes)

## Features Principales

### Evangelio del Día + Stories
- Experiencia Instagram Stories con 3 slides:
  - **Resumen coloquial** del evangelio
  - **Concepto clave** (frase impactante)
  - **Ejercicio práctico** (acción física/material)
- Contenido generado con GPT-5.2 (español de España, tú)
- **Datos 100% locales** (sin dependencias de APIs externas para datos):
  - `liturgical_readings`: Calendario litúrgico católico (2026 completo)
  - `bible_verses`: Biblia Reina Valera 1909 (20,353 versículos)
- **Ejecución automática:** GitHub Actions cron diario (6:00 AM UTC)
- **Bottom bar estilo Instagram:**
  - Campo de texto para enviar mensaje
  - Botón compartir (share_plus)
  - Al enviar: abre chat con contexto de la story
- Navegación fullscreen (oculta bottom nav)

### Sistema de Progreso y Racha 🔥
- **Barra de progreso diario** (0%, 33%, 66%, 100%) según slides vistos
- **Racha de días consecutivos** calculada desde Supabase (`daily_activity`)
- **Optimistic UI**: La racha se actualiza instantáneamente sin esperar al servidor
  - Usa `await ref.read(provider.future)` para sincronizar (NO `Future.delayed`)
- **Celebración**: SnackBar dorado "¡Felicidades! 🔥 X días seguidos" al completar
- **Almacenamiento local**: Slides vistos en SharedPreferences por usuario y fecha
- **Mutex para concurrencia**: Evita race conditions en escrituras rápidas
- **Aislamiento por usuario**: Cada usuario tiene su propio progreso de Stories

### Chat IA Denominacional (Sistema Híbrido)
- **Estilo ChatGPT**: Conversaciones libres + temas guiados
- **19 topics** (12 generales + 7 de planes de estudio):
  - `familia_separada`, `desempleo`, `solteria`, `ansiedad_miedo`
  - `identidad_bicultural`, `reconciliacion`, `sacramentos`, `oracion`
  - `preguntas_biblia`, `evangelio_del_dia`, `lectura_del_dia`, `otro`
- **Personalización por**:
  - Denominación (católico, evangélico, pentecostal, bautista, adventista, etc.)
  - Origen cultural (México/Centroamérica, Caribe, Sudamérica, España)
  - Grupo de edad (teen, young_adult, adult, senior)
- **Sistema de memorias**:
  - `ai_memory`: Hechos del usuario (largo plazo global)
  - `context_summary`: Resumen de conversación (largo plazo por chat)
  - Últimos 10 mensajes (corto plazo)
- **Tono**: "Amigo cristiano de WhatsApp" - casual, cercano, sin sermones
- **Modelos IA**: GPT-4o (chat) + GPT-4o-mini (memorias)
- **Refresco automático de lista**: Al enviar un mensaje, la lista de chats se actualiza automáticamente (comunicación cross-provider con `Ref`)

### Planes de Estudio (7 Pecados Capitales)
- **7 planes de 7 días** cada uno:
  - Soberbia → Humildad
  - Avaricia → Generosidad
  - Lujuria → Pureza
  - Ira → Paciencia
  - Gula → Templanza
  - Envidia → Gratitud
  - Pereza → Diligencia
- **Estructura por día**: Versículo + Reflexión + Ejercicio práctico + Pregunta para chat
- **Chat integrado por plan** (un chat compartido entre los 7 días con contexto IA)
- **Indicadores visuales de progreso**:
  - Badge "✓ Completado" en planes terminados
  - Banner verde en detalle del plan completado
  - Modo lectura para revisar contenido sin modificar progreso
  - Navegación entre días (Día anterior / Día siguiente)
- **Status del plan**: `in_progress`, `completed`, `abandoned`

### Suscripción y Paywall
- **RevenueCat** integrado (iOS configurado, Android pendiente)
- **Paywall estilo Bible Chat**:
  - Botón X discreto (gris, pequeño) para cerrar
  - Toggle para activar/desactivar trial de 3 días (solo mensual)
  - Plan anual sin trial (pago directo con descuento)
- **Límite de mensajes para usuarios free**:
  - 5 mensajes/día almacenados en BD (`daily_activity.messages_sent`)
  - Badge con contador de mensajes restantes
  - Diálogo al agotar con opción "Ver planes"
  - Reset automático a medianoche
- **Mock data en web** para preview (RevenueCat no funciona en web)

### Editar Perfil
- **Pantalla completa de edición** desde Settings
- **Secciones editables:**
  - Datos Personales (nombre, género)
  - Fe y Creencias (denominación)
  - Origen (país con banderas, grupo de edad)
  - Recordatorio (toggle + hora)
- **Dropdown de países** idéntico al onboarding (21 países hispanohablantes con banderas)
- **Guarda país en dos campos:** `origin` (origin_group para IA) + `country_code` (ISO 3166-1)
- **Detección de cambios** con diálogo de confirmación al salir sin guardar

### Eliminar Mensaje Individual
- **Long press** en cualquier mensaje del chat
- **Bottom sheet** con opción "Eliminar mensaje"
- Elimina el mensaje específico de la BD
- **SnackBar** de confirmación

### Guardar Mensajes ❤️ + Mis Reflexiones
- **Botón ❤️** en cada mensaje de la IA:
  - Tap para guardar/desguardar
  - Icono cambia de vacío a relleno cuando está guardado
  - Color dorado cuando está activo
- **Pantalla "Mis Reflexiones"** (Settings → Preferencias):
  - Lista de mensajes guardados con glassmorphism
  - Muestra contenido, chat de origen y fecha
  - Botón trash para eliminar de favoritos
  - Empty state con instrucciones
  - Pull-to-refresh

### Compartir Reflexión como Imagen
- **Editor fullscreen estilo Instagram** al tocar compartir en Stories
- **Selector de fondos expandido por defecto** (usuario entiende que puede editar)
- **Controles compactos** con iconos: paleta (fondos), "Aa" (fuentes), "aA" (tamaño)
- **5 fondos predefinidos** (gradientes: Noche, Dorado, Púrpura, Esperanza, Atardecer)
- **Selector de foto de galería** con `image_picker`
- **4 fuentes Google Fonts**: Lora, Playfair Display, Nunito, Merriweather
- **Pellizcar para zoom** + arrastrar para mover texto
- **Bottom sheet con opciones**: Compartir o Guardar en galería
- **Captura optimizada**: resolución 1x, sin parpadeo de UI

### Borrar Cuenta (GDPR-compliant)
- **Cumplimiento GDPR/Protección de Datos**:
  - Archiva datos pseudonimizados antes de borrar (3 años retención para defensa legal)
  - Usa SHA256 hash del user_id (permite búsqueda si usuario se identifica)
  - PII eliminada: nombre, email, device tokens
  - Datos archivados: mensajes, demografía, progreso de planes
- **Edge Function `delete-account`**:
  1. Verifica usuario con JWT
  2. Archiva en `deleted_user_archives`
  3. Borra de `auth.users` (CASCADE elimina todo)
- **UX**: Botón en Settings → Diálogo de confirmación → Redirección a Splash

### Valorar la App + Compartir
- **Valorar la app**: Dialog nativo de review (Google Play / App Store)
  - Usa `in_app_review` para mostrar review nativo
  - Fallback: abre store directamente si no está disponible
- **Compartir con un amigo**: Sheet nativo de compartir
  - Texto predefinido con enlaces a ambas stores
  - Usa `share_plus` (nativo iOS/Android)

### Navegación Android (Back Button + Swipe)
- **Swipe entre tabs**: PageView con `PageScrollPhysics` para deslizar entre Home, Chat, Estudiar y Perfil
  - La pantalla sigue el dedo y encaja naturalmente al soltar
  - Animación de NavigationBar: 300ms con `easeOutCubic`
- **Bottom nav oculto**: Se oculta condicionalmente para experiencia fullscreen:
  - En chat: `location.startsWith('/chat/')`
  - En Stories: `location == '/home/stories'`
- **Botón atrás Android** con comportamiento correcto:
  - **Con diálogo abierto** → Cierra el diálogo (no navega)
  - Si hay historial (`canPop()`) → Vuelve a la ruta anterior
  - En Home sin historial → Cierra la app
  - En otro tab sin historial → Va a Home
- **Cierre de diálogos con back button**:
  - Usa `dialogContextProvider` para guardar el contexto del diálogo abierto
  - `BackButtonInterceptor` cierra el diálogo manualmente con `Navigator.of(dialogContext).pop()`
  - Diálogos afectados: Cerrar sesión, Borrar cuenta, y cualquier otro que use el patrón
- **Preservación de scroll**: PageView usa `Offstage` para mantenerse siempre montado
  - Al navegar a rutas anidadas (ej: `/study/plan/xxx`), las pantallas principales no se desmontan
  - El scroll se preserva al volver de cualquier ruta anidada
- **Implementación**: `BackButtonInterceptor` + GoRouter con `context.push()`
- **Rutas fullscreen DENTRO del ShellRoute**: Para que el back button funcione, las rutas fullscreen deben estar DENTRO del ShellRoute (para que `currentLocationProvider` se actualice)
- **Importante**: NUNCA usar `Navigator.push()` para rutas en GoRouter (bypasea el router y el back button no funciona)
- **Documentación técnica**: `docs/back-button-intentos.md` (historial completo de intentos + solución final)

### Pantalla de Perfil
- **Stats en tiempo real:**
  - Racha de días consecutivos
  - Planes de estudio completados
- **Secciones de configuración:**
  - Cuenta (editar perfil, vincular email)
  - Preferencias (Mis Reflexiones)
  - Información (valorar app, compartir, términos, privacidad)
  - Zona de peligro (cerrar sesión, borrar cuenta)
- **PageStorageKey**: Preserva posición de scroll al volver de subpantallas
- **Rutas anidadas bajo `/settings`**: Back button vuelve correctamente al tab de Perfil

### Widget Versículo en Lock Screen (📋 PLANIFICADO)
> **Estado:** Planificado para después de T-0403 (Purchase flow)
> **Justificación:** Feature validada por competencia (Bible Chat centra toda su publicidad en esto)

- **iOS Lock Screen** (iOS 16+):
  - Widget `accessoryRectangular` con versículo del día
  - Tecnología: WidgetKit + SwiftUI
- **iOS Home Screen**:
  - Widget `systemSmall` con versículo del día
- **Android Home Screen**:
  - Widget con Jetpack Glance (Kotlin)
  - **Nota:** Android NO soporta widgets en lock screen (deprecado en Android 5.0)
- **Sincronización**:
  - Package `home_widget` v0.9.0 para sincronizar datos Flutter ↔ Widget nativo
  - Contenido desde `daily_verse_texts` (ya existente)
  - Actualización diaria automática
- **Tiempo estimado**: 4-5 días total

### Páginas Legales (GDPR/CCPA)
- **Política de Privacidad** (13 secciones):
  - Introducción con definición legal de "Información Personal"
  - Referencias a RGPD, UK Data Act, CCPA, VCDPA
  - Datos recopilados, uso, base legal, IA, terceros
  - Seguridad, retención, derechos, menores, transferencias
- **Términos y Condiciones** (17 secciones):
  - Introducción, quiénes somos, cambios, registro
  - Suscripciones, licencia, contenido usuario, terceros
  - Uso aceptable, asunción de riesgo, indemnización
  - Exención, limitación, terminación, ley aplicable
- **Versiones:**
  - **App**: Pantallas Flutter con UI glassmorphism
  - **Web**: Archivos HTML standalone para Hostinger
- **URLs web:**
  - Privacidad: `https://releasemvps.com/biblia-chat-cristiano-privacy`
  - Términos: `https://releasemvps.com/biblia-chat-cristiano-terminos-y-condiciones`
- **Empresa**: Bikain OÜ (Estonia)
- **Contacto**: info@releasemvps.com

### Aislamiento de Datos por Usuario
- **Problema resuelto**: Al cambiar de usuario anónimo, los datos del usuario anterior ya no se muestran
- **Implementación**: Todos los providers dependientes del usuario observan `currentUserIdProvider`
- **Providers afectados**:
  - `chat_provider`: Lista de chats del usuario
  - `message_limit_provider`: Contador de mensajes diarios
  - `saved_message_provider`: Mensajes guardados (❤️)
  - `study_provider`: Planes de estudio activos/completados
  - `daily_progress_provider`: Racha y progreso diario
- **SharedPreferences**: Las claves incluyen el user ID (`story_viewed_{userId}_{date}`)

### Firebase Analytics
- **Servicio singleton**: `AnalyticsService` en `lib/core/services/analytics_service.dart`
- **Configuración**:
  - `google-services.json` (Android) en `android/app/`
  - `GoogleService-Info.plist` (iOS) en `ios/Runner/`
  - `firebase_options.dart` con configuración por plataforma
- **Inicialización**: En `main.dart` antes de Supabase
- **Screen tracking automático**: `FirebaseAnalyticsObserver` en GoRouter
- **18 eventos personalizados**:

| Evento | Cuándo se dispara |
|--------|-------------------|
| `onboarding_complete` | Usuario completa onboarding |
| `chat_message_sent` | Usuario envía mensaje en chat |
| `chat_created` | Usuario crea nueva conversación |
| `story_viewed` | Usuario ve slide de Stories |
| `story_completed` | Usuario completa las 3 Stories |
| `share_image` | Usuario comparte imagen desde Stories |
| `plan_started` | Usuario inicia plan de estudio |
| `plan_day_completed` | Usuario completa día del plan |
| `plan_completed` | Usuario completa plan de 7 días |
| `plan_abandoned` | Usuario abandona plan |
| `message_saved` | Usuario guarda mensaje ❤️ |
| `message_unsaved` | Usuario elimina mensaje guardado |
| `paywall_viewed` | Usuario ve el paywall |
| `subscription_started` | Usuario inicia suscripción |
| `purchase_restored` | Usuario restaura compras |
| `email_linked` | Usuario vincula email |
| `login` | Usuario hace login |
| `account_deleted` | Usuario borra cuenta |
| `message_limit_reached` | Usuario alcanza límite diario |

- **User properties**: denomination, origin, age_group, gender, is_premium
- **DebugView**: Habilitar con `adb shell setprop debug.firebase.analytics.app ee.bikain.bibliachat`

### Notificaciones Push (FCM)
- **Arquitectura:**
  - Flutter: `NotificationService` pide permiso y guarda token FCM en `user_devices`
  - Edge Functions: `send-notification` (envío individual) + `send-daily-reminders` (lógica de triggers)
  - GitHub Actions: Cron cada hora para cubrir todos los timezones
- **5 notificaciones automáticas:**

| Trigger | Hora local | Mensaje | Destino |
|---------|------------|---------|---------|
| Stories no vistas | 20:00 | "🔥 No pierdas tu racha de X días" | stories |
| Recordatorio diario | reminder_time | "🙏 Es tu momento de paz" | home |
| Plan abandonado 3+ días | 18:00 | "📚 {Plan} te espera" | study |
| Racha perdida ayer | 09:00 | "💪 Tu racha se rompió, ¡pero hoy puedes empezar de nuevo!" | home |
| Primera semana | Inmediato | "🎉 ¡Una semana seguida!" | home |

- **Deep links configurables:** `{ "screen": "home" | "stories" | "study" | "chat" }`
- **Secret requerido:** `FIREBASE_SERVICE_ACCOUNT` (JSON del Service Account de Firebase)

### Correcciones UI
- **Botones con texto cortado**: Los botones "Continuar estudio", "Completar día" y "Comenzar plan" tenían texto comprimido
  - **Causa**: `ElevatedButton` dentro de `Container(height: 50-56)` sin quitar el padding/minimumSize por defecto
  - **Solución**: Añadir `minimumSize: Size.zero` y `padding: EdgeInsets.zero` al `ElevatedButton.styleFrom()`
  - **Archivos**: `study_screen.dart`, `plan_day_screen.dart`, `plan_detail_screen.dart`

## Estructura del Proyecto

```
BibliaChat/
├── app_flutter/                    # Aplicación Flutter
│   └── lib/
│       ├── core/
│       │   ├── theme/              # AppTheme, colores, estilos
│       │   ├── widgets/            # GlassContainer, ShimmerLoading, LottieHelper
│       │   ├── services/           # StoryViewedService, MessageLimitService, RevenueCatService
│       │   └── providers/          # story_viewed_provider
│       └── features/
│           ├── auth/               # SplashScreen, LoginScreen, etc.
│           ├── onboarding/         # 11 páginas de onboarding
│           ├── home/
│           │   ├── data/           # daily_activity_remote_datasource
│           │   └── presentation/   # HomeScreen, daily_progress_provider
│           ├── chat/               # ChatListScreen, ChatScreen
│           ├── study/              # StudyScreen, PlanDetailScreen, PlanDayScreen
│           ├── profile/            # Perfil de usuario, ProfileEditScreen
│           ├── settings/           # SettingsScreen
│           ├── daily_gospel/       # Feature Evangelio + Stories
│           ├── subscription/       # PaywallScreen, subscription_provider
│           ├── saved_messages/     # Mis Reflexiones (mensajes guardados)
│           └── legal/              # Política de Privacidad, Términos y Condiciones
│               ├── data/           # privacy_policy_content, terms_conditions_content
│               └── presentation/   # PrivacyPolicyScreen, TermsConditionsScreen
├── supabase/
│   ├── migrations/                 # 25 migraciones SQL
│   └── functions/
│       ├── fetch-daily-gospel/     # Edge Function evangelio (desplegada como clever-worker)
│       ├── chat-send-message/      # Edge Function chat IA (combined.ts)
│       ├── delete-account/         # Edge Function borrar cuenta (GDPR-compliant)
│       ├── send-notification/      # Edge Function envío push individual (FCM HTTP v1)
│       └── send-daily-reminders/   # Edge Function lógica de notificaciones automáticas
├── scripts/
│   ├── import_bible_verses.js      # Genera SQL de importación de Biblia
│   ├── import_liturgical_readings.js # Importa calendario litúrgico por año
│   ├── import_missing_books.js     # Importa libros faltantes de la Biblia
│   └── split_bible_sql.js          # Divide SQL de Biblia en chunks
├── .github/
│   └── workflows/
│       ├── daily-gospel.yml        # Cron diario (6:00 AM UTC) para evangelio
│       └── send-notifications.yml  # Cron horario para notificaciones push
├── docs/                           # Documentación completa
│   ├── 01.Product Requeriments Document (PRD).md
│   ├── 02.Historias de usuario. Backlog.md
│   ├── 03.Casos de Uso, Arquitectura y C4.md
│   ├── 04.BBDD.md
│   ├── 05.Tickets de Trabajo.md
│   └── back-button-intentos.md     # Historial de intentos botón atrás Android
├── .env.example
├── CLAUDE.md                       # Memoria del proyecto para Claude
├── privacy-policy.html             # Política de Privacidad (web)
├── terms-conditions.html           # Términos y Condiciones (web)
└── README.md
```

## Requisitos

- Flutter SDK >= 3.35
- Dart >= 3.5
- Cuenta de Supabase (con Edge Functions habilitadas)
- Cuenta de OpenAI (GPT-5.2)
- Cuenta de RevenueCat con:
  - App iOS configurada (Bundle ID: `ee.bikain.bibliachat`)
  - Entitlement: `premium`
  - Products: mensual ($14.99) y anual ($39.99)
- Cuenta de App Store Connect (para iOS IAP)
- Cuenta de Firebase

## Configuración Local

### 1. Clonar el repositorio

```bash
git clone https://github.com/RobertoAbia/BibliaChat-.git
cd BibliaChat
```

### 2. Configurar variables de entorno

```bash
cp .env.example .env
# Editar .env con tus credenciales:
# - SUPABASE_URL
# - SUPABASE_ANON_KEY
# - OPENAI_API_KEY
```

### 3. Configurar Supabase

```bash
# Aplicar migraciones
cd supabase
supabase db push

# Configurar secrets para Edge Functions
supabase secrets set OPENAI_API_KEY=tu_key

# Importar datos de Biblia (ya incluidos en migrations/bible_chunks/)
# Importar calendario litúrgico (ejecutar si necesitas otro año)
# node scripts/import_liturgical_readings.js 2027

# Desplegar Edge Functions (nombre en Supabase: clever-worker)
supabase functions deploy clever-worker --project-ref popqvhrgsokuviwtscid
```

### 4. Configurar Flutter

```bash
cd app_flutter
flutter pub get
```

### 5. Ejecutar la app

```bash
# iOS
flutter run -d ios

# Android
flutter run -d android
```

## Arquitectura

- **Supabase-First**: Sin backend dedicado en MVP
- **Clean Architecture**: Separación de capas (domain, data, presentation)
- **RLS (Row Level Security)**: Seguridad a nivel de base de datos
- **Edge Functions**: Para operaciones sensibles (IA, billing)

### Configuración OpenAI

```typescript
// chat-send-message: GPT-4o para respuestas del chat
{
  model: "gpt-4o",
  messages: [
    { role: "developer", content: systemPrompt },  // NO "system"
    ...historialMensajes,
    { role: "user", content: userMessage }
  ],
  max_completion_tokens: 800,
  temperature: 0.8
}

// chat-send-message: GPT-4o-mini para memorias (cada 20 mensajes)
{
  model: "gpt-4o-mini",
  max_completion_tokens: 200-300,
  temperature: 0.2-0.3
}

// fetch-daily-gospel: GPT-5.2 para contenido Stories
{
  model: "gpt-5.2",
  max_completion_tokens: 600,
  temperature: 0.9
}
```

## UI/UX

- **Tema**: Glassmorphism con paleta Azul Noche + Dorado
- **Animaciones**: Lottie + Flutter Animate
- **Efectos**: BackdropFilter blur, gradientes con glow
- **Colores**:
  - Fondo: #1A1A2E, #16162A
  - Primario (Dorado): #D4AF37, #E8C967
  - Superficies: #252540, #2D2D4A
  - Shimmer (loading): #3A3A5A → #5A5A7A (contraste visible en tema oscuro)

## Documentación

Ver carpeta `/docs` para documentación detallada del proyecto.

## ⚠️ Mantenimiento Periódico

### Calendario Litúrgico (ANUAL)

El calendario litúrgico católico tiene fechas móviles (Pascua, Cuaresma, etc.) que cambian cada año. Los datos deben actualizarse anualmente.

**Estado actual:** 2026 completo (365 lecturas)
**Próxima actualización:** Octubre/Noviembre 2026 (para cargar 2027)

```bash
# 1. Ejecutar el script de importación
node scripts/import_liturgical_readings.js 2027

# 2. Aplicar el SQL generado en Supabase Dashboard → SQL Editor
# Archivo: supabase/migrations/liturgical_data/liturgical_readings_2027.sql
```

**Fuente:** https://github.com/cpbjr/catholic-readings-api (el repo suele tener el año siguiente disponible hacia Oct/Nov)

## Desarrollador

- **GitHub**: [RobertoAbia](https://github.com/RobertoAbia)
- **Repositorio**: https://github.com/RobertoAbia/BibliaChat-

## Licencia

Privado - Todos los derechos reservados
