# iOS Widget Extension — Setup en Xcode

## Pasos (15 minutos en MacinCloud)

### 1. Abrir proyecto en Xcode
```
Abrir: ios/Runner.xcworkspace
```

### 2. Crear Widget Extension Target
- File → New → Target → Widget Extension
- Product Name: `BibleVerseWidget`
- Team: Tu equipo de desarrollo
- Organization: ee.bikain.bibliachat
- **NO** marcar "Include Configuration App Intent"
- **NO** marcar "Include Live Activity"
- Finish → "Activate" cuando pregunte

### 3. Configurar App Group
**En Runner (app principal):**
- Selecciona Runner target → Signing & Capabilities
- + Capability → App Groups
- Añadir: `group.ee.bikain.bibliachat`

**En BibleVerseWidget (extension):**
- Selecciona BibleVerseWidget target → Signing & Capabilities
- + Capability → App Groups
- Añadir: `group.ee.bikain.bibliachat` (el mismo)

### 4. Configurar Bundle ID del widget
- Selecciona BibleVerseWidget target → General
- Bundle Identifier: `ee.bikain.bibliachat.BibleVerseWidget`
- Deployment Target: iOS 16.0

### 5. Reemplazar código generado
- Borrar TODO el contenido autogenerado de `BibleVerseWidget.swift`
- Copiar el contenido del archivo `BibleVerseWidget.swift` de este directorio

### 6. Configurar home_widget en Info.plist
En `ios/Runner/Info.plist` añadir:
```xml
<key>AppGroupId</key>
<string>group.ee.bikain.bibliachat</string>
```

### 7. Build & Test
- Seleccionar el scheme "BibleVerseWidget" → Run
- O seleccionar "Runner" → Run y luego añadir widget desde la pantalla de bloqueo

### Verificación
- [ ] App Group `group.ee.bikain.bibliachat` en ambos targets
- [ ] Bundle ID del widget: `ee.bikain.bibliachat.BibleVerseWidget`
- [ ] Deployment target: iOS 16.0
- [ ] `BibleVerseWidget.swift` con el código correcto
- [ ] Build sin errores
