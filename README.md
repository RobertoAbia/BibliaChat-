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
| Notificaciones | Firebase Cloud Messaging |
| Analytics | Firebase Analytics + Mixpanel |

## Modelo de Negocio

- **Freemium con trial 3 días** (toggle opcional en plan mensual)
- **Free**: 5 mensajes/día de chat
- **Premium**: Chat ilimitado + todas las features
- Mensual: $14.99/mes
- Anual: $39.99/año (ahorra 78%)

## 3 Pilares de la App

1. **HOY** - Retención diaria (racha, evangelio del día con Stories, devoción, oración)
2. **CHAT** - IA denominacional con 12 temas hispanos (sistema híbrido: chats libres + guiados)
3. **ESTUDIAR** - 7 planes de estudio + gamificación

## Features Principales

### Evangelio del Día + Stories
- Experiencia Instagram Stories con 3 slides:
  - **Resumen coloquial** del evangelio
  - **Concepto clave** (frase impactante)
  - **Ejercicio práctico** (acción física/material)
- Contenido generado con GPT-5.2 (español de España, tú)
- Integración con calendario litúrgico católico
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
- **Celebración**: SnackBar dorado "¡Felicidades! 🔥 X días seguidos" al completar
- **Almacenamiento local**: Slides vistos en SharedPreferences por fecha
- **Mutex para concurrencia**: Evita race conditions en escrituras rápidas

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
- Gamificación con puntos y badges

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
  - Biblia (versión preferida)
  - Recordatorio (toggle + hora)
- **Dropdown de países** idéntico al onboarding (21 países hispanohablantes con banderas)
- **Detección de cambios** con diálogo de confirmación al salir sin guardar

### Eliminar Mensaje Individual
- **Long press** en cualquier mensaje del chat
- **Bottom sheet** con opción "Eliminar mensaje"
- Elimina el mensaje específico de la BD
- **SnackBar** de confirmación

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
│           ├── auth/               # SplashScreen
│           ├── onboarding/         # 12 páginas de onboarding
│           ├── home/
│           │   ├── data/           # daily_activity_remote_datasource
│           │   └── presentation/   # HomeScreen, daily_progress_provider
│           ├── chat/               # ChatListScreen, ChatScreen
│           ├── study/              # StudyScreen
│           ├── profile/            # Perfil de usuario
│           ├── daily_gospel/       # Feature Evangelio + Stories
│           └── subscription/       # PaywallScreen, subscription_provider
├── supabase/
│   ├── migrations/                 # 22 migraciones SQL
│   └── functions/
│       ├── fetch-daily-gospel/     # Edge Function evangelio (desplegada como clever-worker)
│       ├── chat-send-message/      # Edge Function chat IA (combined.ts)
│       └── delete-account/         # Edge Function borrar cuenta (GDPR-compliant)
├── .github/
│   └── workflows/
│       └── daily-gospel.yml        # Cron diario (6:00 AM UTC)
├── docs/                           # Documentación completa
│   ├── 01.Product Requeriments Document (PRD).md
│   ├── 02.Historias de usuario. Backlog.md
│   ├── 03.Casos de Uso, Arquitectura y C4.md
│   ├── 04.BBDD.md
│   └── 05.Tickets de Trabajo.md
├── .env.example
├── CLAUDE.md                       # Memoria del proyecto para Claude
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
- API.Bible key

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
# - API_BIBLE_KEY
```

### 3. Configurar Supabase

```bash
# Aplicar migraciones
cd supabase
supabase db push

# Configurar secrets para Edge Functions
supabase secrets set OPENAI_API_KEY=tu_key
supabase secrets set API_BIBLE_KEY=tu_key

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

## Desarrollador

- **GitHub**: [RobertoAbia](https://github.com/RobertoAbia)
- **Repositorio**: https://github.com/RobertoAbia/BibliaChat-

## Licencia

Privado - Todos los derechos reservados
