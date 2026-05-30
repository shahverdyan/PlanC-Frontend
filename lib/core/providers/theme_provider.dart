import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(() {
  return ThemeNotifier();
});

class ThemeNotifier extends Notifier<ThemeMode> {
  final _storage = const FlutterSecureStorage();
  static const _key = 'app_theme_mode';

  @override
  ThemeMode build() {
    _loadSavedTheme();
    return ThemeMode.light;
  }

  Future<void> _loadSavedTheme() async {
    try {
      final saved = await _storage.read(key: _key);
      if (saved == 'dark') state = ThemeMode.dark;
    } catch (_) {}
  }

  Future<void> toggle() async {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    state = next;
    try {
      await _storage.write(key: _key, value: next == ThemeMode.dark ? 'dark' : 'light');
    } catch (_) {}
  }
}
