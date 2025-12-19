# Biblia Chat

**La app cristiana hecha para ti. Que entiende tu fe, tu idioma, tu cultura.**

App móvil (iOS + Android) para práctica diaria de fe cristiana, personalizada según denominación, origen cultural y problemas personales del usuario hispanohablante.

## Stack Tecnológico

| Componente | Tecnología |
|------------|------------|
| Frontend | Flutter (iOS 14.5+ / Android 6.0+) |
| Backend/DB/Auth | Supabase (PostgreSQL + Auth + RLS) |
| IA | OpenAI API |
| Pagos | RevenueCat + In-App Purchases |
| Notificaciones | Firebase Cloud Messaging |
| Analytics | Firebase Analytics + Mixpanel |

## Estructura del Proyecto

```
BibliaChat/
├── app_flutter/          # Aplicación Flutter
├── supabase/
│   ├── migrations/       # Migraciones SQL
│   └── functions/        # Edge Functions
├── docs/                 # Documentación del proyecto
├── .env.example          # Variables de entorno (template)
└── README.md
```

## Requisitos

- Flutter SDK >= 3.0
- Dart >= 3.0
- Cuenta de Supabase
- Cuenta de OpenAI
- Cuenta de RevenueCat
- Cuenta de Firebase

## Configuración Local

### 1. Clonar el repositorio

```bash
git clone https://github.com/TU_USUARIO/BibliaChat.git
cd BibliaChat
```

### 2. Configurar variables de entorno

```bash
cp .env.example .env
# Editar .env con tus credenciales
```

### 3. Configurar Flutter

```bash
cd app_flutter
flutter pub get
```

### 4. Ejecutar la app

```bash
# iOS
flutter run -d ios

# Android
flutter run -d android
```

## Arquitectura

- **Supabase-First**: Sin backend dedicado en MVP
- **Clean Architecture**: Separación de capas
- **RLS (Row Level Security)**: Seguridad a nivel de base de datos

## 3 Pilares de la App

1. **HOY** - Retención diaria (racha, versículo, devoción, oración)
2. **CHAT** - IA denominacional con 10 temas hispanos
3. **ESTUDIAR** - Planes de estudio + gamificación

## Documentación

Ver carpeta `/docs` para documentación detallada:

- `01.Product Requeriments Document (PRD).md`
- `02.Historias de usuario. Backlog.md`
- `03.Casos de Uso, Arquitectura y C4.md`
- `04.BBDD.md`
- `05.Tickets de Trabajo.md`

## Licencia

Privado - Todos los derechos reservados
