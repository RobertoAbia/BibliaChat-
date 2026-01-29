# Back Button Android - Historial de Intentos

## Problema

El botón de retroceso de Android cierra la app en lugar de navegar a Home cuando se presiona desde las tabs de Chat, Study o Settings.

---

## Intento 1: BackButtonListener (Widget)

**Archivo:** `app_router.dart` - MainShell

```dart
BackButtonListener(
  onBackButtonPressed: () async {
    // lógica de navegación
    return true;
  },
  child: Scaffold(...),
)
```

**Por qué falló:**
- El callback pierde su registro durante los rebuilds del widget
- Cuando se usa `context.go()` para navegar, el árbol de widgets se reconstruye
- El nuevo widget no tiene el listener registrado correctamente
- **Resultado:** El callback nunca se ejecuta

---

## Intento 2: WidgetsBindingObserver

**Archivo:** `app_router.dart` - MainShell como mixin

```dart
class _MainShellState extends ConsumerState<MainShell>
    with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Future<bool> didPopRoute() async {
    // lógica de navegación
    return true;
  }
}
```

**Por qué falló:**
- GoRouter tiene su propio observer que intercepta el evento ANTES
- El orden de observers favorece a GoRouter
- Nuestro `didPopRoute()` nunca se llama
- **Resultado:** GoRouter consume el evento primero

---

## Intento 3: PopScope Widget

**Archivo:** `app_router.dart` - MainShell

```dart
PopScope(
  canPop: false,
  onPopInvokedWithResult: (didPop, result) {
    debugPrint('PopScope callback ejecutado');
    // lógica de navegación
  },
  child: Scaffold(...),
)
```

**Por qué falló:**
- Con `routerConfig` en MaterialApp.router, GoRouter maneja el back button internamente
- El evento nunca llega al PopScope
- Los logs confirmaron: `KEYCODE_BACK` detectado pero `PopScope callback` NUNCA apareció
- **Resultado:** GoRouter consume el evento antes de que PopScope lo vea

---

## Intento 4: CustomBackButtonDispatcher

**Archivo:** `app.dart`

```dart
// En lugar de routerConfig, usar componentes individuales
MaterialApp.router(
  routeInformationProvider: router.routeInformationProvider,
  routeInformationParser: router.routeInformationParser,
  routerDelegate: router.routerDelegate,
  backButtonDispatcher: CustomBackButtonDispatcher(router: router, ref: ref),
)

class CustomBackButtonDispatcher extends RootBackButtonDispatcher {
  @override
  Future<bool> didPopRoute() async {
    debugPrint('CustomBackButtonDispatcher ejecutado');
    // lógica de navegación
    return true;
  }
}
```

**Por qué falló:**
- GoRouter 14.x tiene comportamiento interno que bypasea dispatchers externos
- A pesar de usar componentes individuales, el dispatcher no se invoca
- Los logs confirmaron: `KEYCODE_BACK` detectado pero `CustomBackButtonDispatcher` NUNCA apareció
- **Resultado:** GoRouter sigue consumiendo el evento internamente

---

## Intento 5: back_button_interceptor (paquete)

**Archivo:** `app.dart`

```dart
class _BibliaChatAppState extends ConsumerState<BibliaChatApp> {
  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(_handleBackButton, name: 'main');
  }

  bool _handleBackButton(bool stopDefaultButtonEvent, RouteInfo info) {
    debugPrint('BackButtonInterceptor ejecutado');
    // lógica de navegación
    return true;
  }
}
```

**Por qué falló:**
- El paquete funciona a nivel nativo de Android via MethodChannel
- PERO: `android:enableOnBackInvokedCallback="true"` en AndroidManifest.xml
- Este atributo habilita "predictive back gesture" de Android 13+
- El sistema operativo consume el evento ANTES de que llegue a Flutter
- Los logs confirmaron: `KEYCODE_BACK` detectado pero `BackButtonInterceptor` NUNCA apareció
- **Resultado:** Android 13+ predictive back bypasea completamente Flutter

---

## Causa Raíz

**`android:enableOnBackInvokedCallback="true"`** en AndroidManifest.xml

Este atributo habilita el "predictive back gesture" de Android 13+ que **bypasea completamente** todos los interceptores de Flutter. El evento de back button va directo al sistema operativo sin pasar por ningún handler de Flutter.

```
CON enableOnBackInvokedCallback="true":
[Android 13+ Predictive Back] → [Sistema Android] → App cierra
                                 (Flutter NUNCA ve el evento)

SIN enableOnBackInvokedCallback:
[Android Native] → [back_button_interceptor] → [Nuestro handler] → Navega a Home
```

---

## Solución Final

1. **Quitar** `android:enableOnBackInvokedCallback="true"` de AndroidManifest.xml
2. El `BackButtonInterceptor` ya instalado en `app.dart` funcionará correctamente

---

## Problema Adicional: PageView no se sincroniza

**Síntoma:** Después de aplicar la solución anterior, el back button funcionaba parcialmente:
- ✅ El menú inferior se actualizaba correctamente (mostraba "Hoy" seleccionado)
- ❌ La pantalla NO cambiaba (seguía mostrando Perfil/Chat/Estudiar)

**Causa:**
El `BackButtonInterceptor` hacía:
```dart
ref.read(currentTabIndexProvider.notifier).state = 0;
router.go(RouteConstants.home);
```

Esto actualizaba el NavigationBar (que usa `selectedIndex` de la ruta), pero el `PageView` en `MainShell` tiene su propio `PageController` que NO se sincronizaba automáticamente con la ruta.

**Solución en `app_router.dart` - MainShell:**

Añadir lógica para sincronizar el PageController cuando la ruta cambia externamente:

```dart
// En el método build() de _MainShellState
if (isMainRoute) {
  if (_pageController == null || wasOnNestedRoute) {
    _pageController?.dispose();
    _pageController = PageController(initialPage: selectedIndex);
  } else {
    // NUEVO: Sincronizar PageController si la ruta cambió (ej: back button)
    final currentPage = _pageController!.hasClients
        ? _pageController!.page?.round() ?? 0
        : 0;
    if (currentPage != selectedIndex) {
      // Usar addPostFrameCallback para animar después del build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_pageController!.hasClients) {
          _pageController!.animateToPage(
            selectedIndex,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }
}
```

**Por qué funciona:**
- Cuando `router.go('/home')` se ejecuta, el widget se reconstruye
- En el `build()`, detectamos que `currentPage` (3 = Perfil) ≠ `selectedIndex` (0 = Home)
- Usamos `addPostFrameCallback` para animar DESPUÉS del build (evita errores de setState durante build)
- El PageView se anima suavemente a la página correcta

---

## Problema Adicional 2: Cascada de navegaciones durante animación

**Síntoma:** Después de aplicar la solución anterior, al presionar back:
- La pantalla se mueve a Home
- PERO aparecen muchas navegaciones en los logs:
```
BackButtonInterceptor: Going to Home from tab 3
GoRouter: going to /home     ← Correcto
GoRouter: going to /study    ← ¡Incorrecto!
GoRouter: going to /home
GoRouter: going to /chat     ← ¡Incorrecto!
GoRouter: going to /settings
```
- A veces terminaba en una pantalla diferente a Home

**Causa:**
Cuando `animateToPage()` anima el PageView de la página 3 a la página 0, el PageView pasa por las páginas intermedias (2, 1) y dispara `onPageChanged` para CADA una:

```dart
void _onPageChanged(int index) {
  ref.read(currentTabIndexProvider.notifier).state = index;
  context.go(_mainRoutes[index]); // ¡Se llama para cada página intermedia!
}
```

**Solución en `app_router.dart` - MainShell:**

Añadir un flag `_isSyncing` que bloquea `context.go()` durante la animación de sincronización:

```dart
class _MainShellState extends ConsumerState<MainShell> {
  PageController? _pageController;
  String? _lastLocation;
  bool _isSyncing = false; // NUEVO: Flag para evitar cascada

  void _onPageChanged(int index) {
    ref.read(currentTabIndexProvider.notifier).state = index;

    // NUEVO: NO navegar si estamos sincronizando
    if (_isSyncing) return;

    context.go(_mainRoutes[index]);
  }

  // En build(), al sincronizar:
  if (currentPage != selectedIndex) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController!.hasClients) {
        _isSyncing = true; // NUEVO: Activar flag antes de animar
        _pageController!.animateToPage(
          selectedIndex,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
        ).then((_) {
          _isSyncing = false; // NUEVO: Desactivar después de animar
        });
      }
    });
  }
}
```

**Por qué funciona:**
- `_isSyncing = true` ANTES de `animateToPage()`
- Durante la animación, `onPageChanged` se llama pero hace `return` inmediatamente
- Solo se actualiza `currentTabIndexProvider` (para el menú inferior)
- NO se llama a `context.go()` para las páginas intermedias
- `_isSyncing = false` DESPUÉS de completar la animación (en `.then()`)
- El swipe normal del usuario sigue funcionando porque `_isSyncing` es `false`

---

## Problema Adicional 3: GoRouter reporta ruta del ShellRoute, no la ruta real

**Síntoma:** Al entrar a un chat existente (`/chat/id/xxx`) y presionar back:
```
BackButtonInterceptor: location=/chat, isMainRoute=true, tabIndex=1, canPop=true
BackButtonInterceptor: Going to Home from tab 1
```

El botón back va a Home en lugar de quedarse en la lista de chats, porque `location` es `/chat` cuando debería ser `/chat/id/xxx`.

**Causa:**
Tanto `router.routerDelegate.currentConfiguration.uri.path` como `router.routeInformationProvider.value.uri.path` devuelven la ruta del **ShellRoute padre** (`/chat`) en lugar de la ruta real anidada (`/chat/id/xxx`).

Esto es un comportamiento de GoRouter con ShellRoute: cuando navegas a una ruta anidada como `/chat/id/xxx`, GoRouter internamente mantiene dos "capas":
1. El ShellRoute que muestra la UI con bottom navigation (reporta `/chat`)
2. La ruta hija real (`/chat/id/xxx`)

El BackButtonInterceptor está en `app.dart` que está FUERA del contexto del router, por lo que solo ve la ruta del ShellRoute.

**Intentos fallidos:**
1. `router.routerDelegate.currentConfiguration.uri.path` → Devuelve `/chat`
2. `router.routeInformationProvider.value.uri.path` → Devuelve `/chat`
3. `GoRouterState.of(context)` → No tenemos context en `app.dart`

**Solución: Usar Provider global para trackear la ruta real**

Crear un `StateProvider<String>` que se actualice desde dentro del árbol de widgets (donde SÍ tenemos acceso a `GoRouterState.of(context)`):

```dart
// En app.dart
final currentLocationProvider = StateProvider<String>((ref) => '/');

// En app_router.dart - MainShell.build()
@override
Widget build(BuildContext context) {
  final location = GoRouterState.of(context).uri.path;
  // Actualizar el provider global con la ruta REAL
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ref.read(currentLocationProvider.notifier).state = location;
  });
  // ... resto del build
}

// En app.dart - _handleBackButton
bool _handleBackButton(bool stopDefaultButtonEvent, RouteInfo info) {
  final router = ref.read(appRouterProvider);
  // Leer la ruta REAL desde el provider (no desde el router)
  final location = ref.read(currentLocationProvider);
  final isMainRoute = _isMainRoute(location);
  // ... resto de la lógica
}
```

**Por qué funciona:**
- `MainShell` está DENTRO del contexto del router
- `GoRouterState.of(context)` en MainShell devuelve la ruta REAL (`/chat/id/xxx`)
- Guardamos esa ruta en un provider global
- `BackButtonInterceptor` en `app.dart` lee del provider
- Ahora `isMainRoute` detecta correctamente que `/chat/id/xxx` NO es ruta principal
- Navega a `/chat` (la lista) en lugar de a Home

**Notas:**
- Usamos `addPostFrameCallback` para evitar modificar estado durante el build
- El provider se actualiza en cada navegación porque `MainShell.build()` se llama
- Funciona para TODAS las rutas anidadas: `/chat/id/xxx`, `/chat/new`, `/study/plan/xxx`, `/settings/edit`

---

## Problema Adicional 4: La navegación al chat usa Navigator.push(), no GoRouter

**Síntoma:** El provider `currentLocationProvider` siempre tiene `/chat` en lugar de `/chat/id/xxx` porque GoRouter no conoce esa navegación.

**Causa raíz descubierta:**
En `chat_list_screen.dart`, la navegación usa `Navigator.push()` en lugar de `context.push()` de GoRouter:

```dart
// chat_list_screen.dart línea 442
await Navigator.of(context, rootNavigator: true).push(
  MaterialPageRoute(
    builder: (_) => ChatScreen(chatId: widget.chat.id),
    fullscreenDialog: true,
  ),
);
```

Esto bypasea completamente GoRouter, por lo que:
1. GoRouter no sabe que navegamos a `/chat/id/xxx`
2. `router.routerDelegate.currentConfiguration` sigue mostrando `/chat`
3. El provider nunca se actualiza con la ruta real

---

## Intento 8: Actualizar provider desde ChatScreen.initState()

**Archivos modificados:**
- `chat_screen.dart` - Añadido `_updateLocationProvider()` en initState
- `gospel_stories_screen.dart` - Convertido a ConsumerStatefulWidget, añadido provider update
- `app.dart` - Añadido `_isFullscreenRoute()` para detectar rutas virtuales

**Código:**
```dart
// En ChatScreen.initState()
WidgetsBinding.instance.addPostFrameCallback((_) {
  _initializeChat();
  _updateLocationProvider(); // Actualiza provider con ruta virtual
});

void _updateLocationProvider() {
  String route;
  if (widget.chatId != null) {
    route = '/chat/id/${widget.chatId}';
  } else if (widget.topicKey != null) {
    route = '/chat/topic/${widget.topicKey}';
  } else {
    route = '/chat/new';
  }
  ref.read(currentLocationProvider.notifier).state = route;
}

// En dispose()
void dispose() {
  ref.read(currentLocationProvider.notifier).state = '/chat'; // Restaurar
  // ...
}

// En app.dart - BackButtonInterceptor
if (_isFullscreenRoute(location)) {
  return false; // Dejar que el sistema haga pop
}
```

**Logs mostraron:**
```
BackButtonInterceptor: location=/chat/id/345eee58-..., isMainRoute=false, tabIndex=1
BackButtonInterceptor: Fullscreen route, letting system handle pop
```

**Por qué falló:**
- ✅ El provider SÍ se actualizó correctamente con `/chat/id/xxx`
- ✅ El interceptor detectó que es una ruta fullscreen
- ✅ Devolvió `false` para "dejar que el sistema haga pop"
- ❌ PERO la pantalla no cambió - **devolver `false` no hace que Navigator.pop() ocurra automáticamente**

El error de concepto fue pensar que `return false` en BackButtonInterceptor pasaría el evento al Navigator. En realidad, `return false` solo permite que OTROS interceptores manejen el evento, pero el Navigator de Flutter no recibe el evento automáticamente.

---

## Análisis: ¿Cómo funciona la navegación en Settings?

**En `settings_screen.dart` línea 106:**
```dart
onTap: () => context.push(RouteConstants.profileEdit),
```

Usa `context.push()` de GoRouter. La ruta `/settings/edit` está definida en el ShellRoute:
```dart
GoRoute(
  path: RouteConstants.settings,
  routes: [
    GoRoute(path: 'edit', name: 'profileEdit', builder: ...), // /settings/edit
  ],
),
```

**En `chat_list_screen.dart` línea 442:**
```dart
await Navigator.of(context, rootNavigator: true).push(
  MaterialPageRoute(
    builder: (_) => ChatScreen(chatId: widget.chat.id),
    fullscreenDialog: true,
  ),
);
```

Usa `Navigator.push()` directo, bypasseando GoRouter.

**Las rutas de chat YA EXISTEN en GoRouter:**
```dart
GoRoute(
  path: RouteConstants.chatList,
  routes: [
    GoRoute(path: 'new', name: 'chatNew', builder: ...),           // /chat/new
    GoRoute(path: 'id/:chatId', name: 'chatById', builder: ...),   // /chat/id/xxx
    GoRoute(path: 'topic/:topicKey', name: 'chatByTopic', ...),    // /chat/topic/xxx
  ],
),
```

---

## Solución: Usar context.push() en lugar de Navigator.push()

La solución es simplemente cambiar `chat_list_screen.dart` para usar `context.push()` igual que `settings_screen.dart`. Las rutas ya están definidas en GoRouter.

**Cambios necesarios en `chat_list_screen.dart`:**

1. Nueva conversación (línea 49):
```dart
// ANTES
await Navigator.of(context, rootNavigator: true).push(
  MaterialPageRoute(builder: (_) => const ChatScreen(), fullscreenDialog: true),
);
// DESPUÉS
context.push('/chat/new');
```

2. Chat existente (línea 442):
```dart
// ANTES
await Navigator.of(context, rootNavigator: true).push(
  MaterialPageRoute(builder: (_) => ChatScreen(chatId: widget.chat.id), fullscreenDialog: true),
);
// DESPUÉS
context.push('/chat/id/${widget.chat.id}');
```

3. Topic guiado (línea 782):
```dart
// ANTES
await Navigator.of(context, rootNavigator: true).push(
  MaterialPageRoute(builder: (_) => ChatScreen(topicKey: widget.topic.key), fullscreenDialog: true),
);
// DESPUÉS
context.push('/chat/topic/${widget.topic.key}');
```

**Nota sobre fullscreenDialog:**
Con GoRouter dentro del ShellRoute, el bottom navigation seguirá visible. Si se quiere ocultar, las rutas deberían estar FUERA del ShellRoute. Pero el back button funcionará correctamente.

**También hay que revertir los cambios innecesarios:**
- Quitar `_updateLocationProvider()` de ChatScreen (ya no es necesario)
- Quitar cambios en GospelStoriesScreen
- Quitar `_isFullscreenRoute()` de app.dart

---

## ✅ SOLUCIÓN FINAL IMPLEMENTADA (26/01/2026)

Se aplicó la solución de cambiar `Navigator.push()` por `context.push()` en `chat_list_screen.dart`.

**Archivos modificados:**

1. **`chat_list_screen.dart`:**
   - Añadido import: `import 'package:go_router/go_router.dart';`
   - Eliminado import: `import 'chat_screen.dart';` (ya no se necesita)
   - Línea 49: `await context.push('/chat/new');`
   - Línea 442: `await context.push('/chat/id/${widget.chat.id}');`
   - Línea 782: `await context.push('/chat/topic/${widget.topic.key}');`

2. **Cambios revertidos:**
   - `chat_screen.dart` - Eliminado `_updateLocationProvider()` y referencias a `currentLocationProvider`
   - `gospel_stories_screen.dart` - Revertido a `StatefulWidget` (no ConsumerStatefulWidget)
   - `app.dart` - Eliminado `_isFullscreenRoute()`

**Logs que confirman el funcionamiento correcto:**

```
// Usuario abre un chat
GoRouter: INFO: pushing /chat/id/345eee58-3b0d-4a31-864e-88238fe5b87c

// Usuario presiona back DENTRO del chat
BackButtonInterceptor: location=/chat/id/345eee58-..., isMainRoute=false, tabIndex=1
BackButtonInterceptor: Nested GoRouter route, going to parent
GoRouter: INFO: going to /chat  ← ✅ Vuelve a lista de chats

// Usuario presiona back EN la lista de chats
BackButtonInterceptor: location=/chat, isMainRoute=true, tabIndex=1
BackButtonInterceptor: Going to Home from tab 1
GoRouter: INFO: going to /home  ← ✅ Va a Home

// Usuario presiona back EN Home
BackButtonInterceptor: location=/home, isMainRoute=true, tabIndex=0
BackButtonInterceptor: On Home, closing app  ← ✅ Cierra la app
```

**Comportamiento final:**

| Ubicación | Back Button |
|-----------|-------------|
| Dentro de un chat (`/chat/id/xxx`) | → Lista de chats (`/chat`) |
| Lista de chats (`/chat`) | → Home (`/home`) |
| Estudiar (`/study`) | → Home (`/home`) |
| Perfil (`/settings`) | → Home (`/home`) |
| Home (`/home`) | → Cierra la app |

**Lección aprendida:**
La causa raíz era usar `Navigator.push()` que bypasea GoRouter. Al usar `context.push()` de GoRouter, el router conoce la ruta real y el `BackButtonInterceptor` puede leer la ubicación correcta desde `router.routerDelegate.currentConfiguration.uri.path`.

---

## Problema Adicional 5: Stories usa Navigator.push() (29/01/2026)

**Síntoma:** Al presionar back dentro de GospelStoriesScreen, la app se cierra en lugar de volver a Home.

**Causa:** El mismo problema que con Chat - Stories usaba `Navigator.of(context, rootNavigator: true).push()` que bypasea GoRouter. El `BackButtonInterceptor` veía `/home` como ubicación y cerraba la app.

**Intento fallido: PopScope + fullscreenRouteOpenProvider**

Se intentó usar un provider para trackear cuando Stories estaba abierta y que el interceptor retornara `false` para "dejar que PopScope maneje". Esto falló por dos razones:

1. **Error de concepto documentado:** `return false` en `BackButtonInterceptor` NO pasa el evento a Flutter Navigator - solo permite que otros interceptores lo manejen
2. **Error de ref en dispose:** `ref.read()` en `dispose()` falla con "Cannot use ref after widget was disposed"

**Solución aplicada (29/01/2026):**

Igual que con Chat, convertir Stories en una ruta de GoRouter:

1. **Nueva ruta `/stories`** añadida en `app_router.dart` (FUERA del ShellRoute para ser fullscreen)
2. **Navegación cambiada** de `Navigator.push()` a `context.push('/stories', extra: {...})`
3. **GospelStoriesScreen simplificado:**
   - Revertido de `ConsumerStatefulWidget` a `StatefulWidget`
   - Eliminado código de `fullscreenRouteOpenProvider`
   - Eliminado `PopScope` wrapper
   - Cambiado `Navigator.pop()` a `context.pop()`
4. **Eliminado** `fullscreenRouteOpenProvider` de `app.dart`

**Archivos modificados:**
- `lib/core/constants/route_constants.dart` - Nueva constante `stories`
- `lib/core/router/app_router.dart` - Nueva ruta GoRoute
- `lib/features/home/presentation/screens/home_screen.dart` - `context.push()` para Stories
- `lib/features/daily_gospel/presentation/screens/gospel_stories_screen.dart` - Simplificado
- `lib/app.dart` - Eliminado provider y código

**Comportamiento final actualizado:**

| Ubicación | Back Button |
|-----------|-------------|
| Stories (`/stories`) | → Home (`/home`) |
| Dentro de un chat (`/chat/id/xxx`) | → Lista de chats (`/chat`) |
| Lista de chats (`/chat`) | → Home (`/home`) |
| Estudiar (`/study`) | → Home (`/home`) |
| Perfil (`/settings`) | → Home (`/home`) |
| Home (`/home`) | → Cierra la app |
