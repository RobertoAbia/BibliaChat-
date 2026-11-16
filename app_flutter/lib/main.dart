import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/services/remote_config_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Mantener splash nativa visible hasta que Flutter esté listo
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Firebase→RemoteConfig y dotenv→Supabase son cadenas independientes:
  // en paralelo recortan ~100-300ms de splash en frío.
  try {
    await _initCoreServices();
  } catch (e) {
    // Sin esto, una excepción antes de runApp dejaba la splash nativa
    // congelada para siempre (preserve() sin remove()).
    debugPrint('Fatal init error: $e');
    FlutterNativeSplash.remove();
    runApp(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Color(0xFF141A2E),
          body: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'No se pudo iniciar la app.\nComprueba tu conexión y vuelve a abrirla.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
    return;
  }

  // Set preferred orientations (portrait only for this app)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style (light theme)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light, // iOS: dark icons
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    const ProviderScope(
      child: BibliaChatApp(),
    ),
  );
}

Future<void> _initCoreServices() async {
  await Future.wait([
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).then((_) =>
        // Remote Config (rápido: aplica valores cacheados, fetch en
        // background). Debe estar listo antes de construir el onboarding
        // (lee qué pasos ocultar).
        RemoteConfigService().init()),
    dotenv.load(fileName: '.env').then((_) =>
        // Initialize Supabase with deep link support
        Supabase.initialize(
          url: dotenv.env['SUPABASE_URL']!,
          anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
          authOptions: const FlutterAuthClientOptions(
            authFlowType: AuthFlowType.pkce,
          ),
        )),
  ]);
}
