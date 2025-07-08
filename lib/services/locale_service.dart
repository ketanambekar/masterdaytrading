import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:masterdaytrading/constants/app_constants.dart';

class LocaleService {
  static const String _storageKey = AppConstants.langCode;
  final GetStorage _box = GetStorage();

  /// Fallback locale
  final Locale fallbackLocale = const Locale('en', 'US');

  /// All supported locales
  final supportedLocales = const [
    Locale('en', 'US'),
    Locale('hi', 'IN'),
    Locale('gu', 'IN'),
  ];

  /// Get stored or fallback locale
  Locale getStoredLocale() {
    final code = _box.read<String>(_storageKey);
    if (code == null) return fallbackLocale;
    return _getLocaleFromCode(code) ?? fallbackLocale;
  }

  /// Save and apply new locale
  void changeLocale(String languageCode) {
    final locale = _getLocaleFromCode(languageCode);
    if (locale != null) {
      _box.write(_storageKey, languageCode);
      Get.updateLocale(locale);
    }
  }

  /// Internal: Map language code to supported Locale
  Locale? _getLocaleFromCode(String code) {
    return supportedLocales.firstWhereOrNull((loc) => loc.languageCode == code);
  }
}
