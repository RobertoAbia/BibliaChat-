# Biblia Chat - App Flutter

App cristiana para hispanohablantes en EE.UU. que combina IA denominacional, devocionales personalizados y planes de estudio.

## Stack

- **Framework:** Flutter 3.35.3 (iOS 14.5+ / Android 6.0+)
- **Backend:** Supabase (PostgreSQL + Auth + RLS + Edge Functions)
- **IA:** OpenAI GPT-5.2
- **Pagos:** RevenueCat
- **Notificaciones:** Firebase Cloud Messaging
- **Analytics:** Firebase Analytics

## Arquitectura

Clean Architecture con Riverpod para estado y GoRouter para navegación.

```
lib/
├── core/               # Theme, router, services, constants
├── features/
│   ├── auth/           # Auth (anónimo, email, reset password)
│   ├── onboarding/     # Onboarding (11 páginas)
│   ├── home/           # Home (calendario, progreso, racha)
│   ├── chat/           # Chat IA (híbrido: libre + temas)
│   ├── study/          # Planes de estudio (7 pecados capitales)
│   ├── daily_gospel/   # Evangelio del día + Stories
│   ├── profile/        # Perfil de usuario
│   ├── settings/       # Configuración
│   ├── subscription/   # Paywall + RevenueCat
│   ├── saved_messages/  # Mensajes guardados
│   └── legal/          # Privacidad + Términos
└── app.dart            # MaterialApp + BackButtonInterceptor
```

## Setup

```bash
flutter pub get
flutter run -d ios
flutter run -d android
```

## Configuracion requerida

- `.env` en la raiz del proyecto con credenciales de Supabase
- `google-services.json` en `android/app/`
- `GoogleService-Info.plist` en `ios/Runner/`

## Documentacion

La documentacion completa del proyecto esta en `CLAUDE.md` en la raiz del repositorio.
