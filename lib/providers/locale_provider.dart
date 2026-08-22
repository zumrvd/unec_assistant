// lib/providers/locale_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unec_assistant/l10n/translations.dart';

const _kLocaleKey = 'app_locale';

class LocaleNotifier extends Notifier<AppLocale> {
  @override
  AppLocale build() {
    _loadSaved();
    return AppLocale.en;
  }

  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_kLocaleKey);
    if (saved != null) {
      final locale = AppLocale.values.firstWhere(
        (l) => l.name == saved,
        orElse: () => AppLocale.en,
      );
      state = locale;
    }
  }

  Future<void> setLocale(AppLocale locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLocaleKey, locale.name);
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, AppLocale>(LocaleNotifier.new);

/// Convenience provider — gives you a pre-built AppStrings for the active locale.
final strProvider = Provider<AppStrings>((ref) {
  return AppStrings(ref.watch(localeProvider));
});

/// Maps AppLocale → Flutter Locale for MaterialApp.
final flutterLocaleProvider = Provider<Locale>((ref) {
  switch (ref.watch(localeProvider)) {
    case AppLocale.en:
      return const Locale('en', 'US');
    case AppLocale.az:
      return const Locale('az', 'AZ');
    case AppLocale.ru:
      return const Locale('ru', 'RU');
  }
});
