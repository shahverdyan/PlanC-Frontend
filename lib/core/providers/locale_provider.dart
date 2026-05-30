import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:plan_c_frontend/core/providers/dio_provider.dart';

/// Provider global per accedir a l'estat de l'idioma des de qualsevol lloc
final localeProvider = NotifierProvider<LocaleNotifier, Locale>(() {
  return LocaleNotifier();
});

class LocaleNotifier extends Notifier<Locale> {
  // Utilitzem el secure storage que ja teniu al pubspec.yaml
  final _storage = const FlutterSecureStorage();
  static const _localeKey = 'app_locale_preference';
  static const _userIdKey = 'auth_user_id';

  @override
  Locale build() {
    // 1. Definim el Català ('ca') com a idioma per defecte a l'inici.
    // 2. Disparem la càrrega asíncrona per veure si l'usuari tenia un altre idioma desat.
    _loadSavedLocale();
    return const Locale('ca');
  }

  /// Llegeix l'emmagatzematge local per recuperar l'idioma preferit
  Future<void> _loadSavedLocale() async {
    try {
      final savedLanguageCode = await _storage.read(key: _localeKey);
      if (savedLanguageCode != null && savedLanguageCode.isNotEmpty) {
        // Actualitzem l'estat només si hi ha un idioma guardat prèviament
        state = Locale(savedLanguageCode);
      }
    } catch (e) {
      debugPrint('Error carregant l\'idioma: $e');
    }
  }

  /// Canvia l'idioma de l'aplicació i el guarda al dispositiu
  Future<void> setLocale(Locale newLocale) async {
    if (state == newLocale) return; // Si és el mateix, no fem res

    // 1. Actualitzem l'estat reactiu (això repintarà tota la UI automàticament)
    state = newLocale;

    // 2. Guardem la preferència localment
    try {
      await _storage.write(key: _localeKey, value: newLocale.languageCode);
    } catch (e) {
      debugPrint('Error guardant l\'idioma: $e');
    }

    // 3. (CA5) Notifiquem al backend perquè els emails/notificacions
    //    futurs es generin en l'idioma escollit per l'usuari.
    await _syncLocaleWithBackend(newLocale.languageCode);
  }

  Future<void> _syncLocaleWithBackend(String languageCode) async {
    try {
      final userId = await _storage.read(key: _userIdKey);
      if (userId == null || userId.isEmpty) {
        // Encara no hi ha sessió: la preferència s'enviarà la pròxima vegada
        // que l'usuari estigui autenticat i canviï l'idioma.
        debugPrint('Sync idioma omès: usuari no autenticat');
        return;
      }

      final dio = ref.read(dioProvider);
      await dio.patch(
        '/usuari/perfil',
        data: {'idioma': languageCode},
        options: Options(headers: {'usuari-id': userId}),
      );
      debugPrint('Idioma sincronitzat amb el backend: $languageCode');
    } on DioException catch (e) {
      debugPrint('Error sincronitzant idioma amb el backend: ${e.message}');
    } catch (e) {
      debugPrint('Error sincronitzant idioma amb el backend: $e');
    }
  }
}
