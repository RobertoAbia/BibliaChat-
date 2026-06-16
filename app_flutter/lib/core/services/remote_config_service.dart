import 'dart:async';
import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

/// Servicio singleton para Firebase Remote Config.
///
/// Permite cambiar comportamiento sin pasar por revisión de tiendas.
/// Uso actual: ocultar pasos del onboarding mediante la clave
/// `onboarding_hidden_steps` (lista de step_names separados por coma).
class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();
  factory RemoteConfigService() => _instance;
  RemoteConfigService._internal();

  /// Clave en Remote Config: step_names a ocultar. Acepta dos formatos:
  ///  - Texto plano separado por coma: `age,gender,reminder`
  ///  - JSON array: `["age","gender","reminder"]`
  /// Vacío = no se oculta nada (default).
  static const String hiddenStepsKey = 'onboarding_hidden_steps';

  FirebaseRemoteConfig? _rc;

  /// Inicializa Remote Config. Aplica valores ya cacheados al instante
  /// (`activate`) y lanza el fetch en background para la próxima apertura.
  /// No bloquea con red: en la 1ª instalación se usan los defaults.
  Future<void> init() async {
    if (kIsWeb) return;
    try {
      final rc = FirebaseRemoteConfig.instance;
      await rc.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ));
      await rc.setDefaults(const {
        hiddenStepsKey: '',
      });
      // Aplica los últimos valores fetchados (cacheados en disco) sin red.
      await rc.activate();
      _rc = rc;
      // Fetch en background para que la próxima apertura tenga lo último.
      unawaited(rc.fetchAndActivate());
    } catch (_) {
      // No-crítico: si falla, se aplican los defaults (nada oculto).
    }
  }

  /// Conjunto de step_names del onboarding que deben ocultarse.
  /// Tolera tanto JSON array (`["a","b"]`) como lista plana (`a,b`).
  Set<String> get hiddenOnboardingSteps {
    final raw = (_rc?.getString(hiddenStepsKey) ?? '').trim();
    if (raw.isEmpty) return {};

    // Formato JSON array: ["a","b"]
    if (raw.startsWith('[')) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          return decoded
              .map((e) => e.toString().trim())
              .where((s) => s.isNotEmpty)
              .toSet();
        }
      } catch (_) {
        // JSON malformado → cae al parseo por comas.
      }
    }

    // Formato lista plana: a,b,c
    return raw
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toSet();
  }
}
