import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:masterdaytrading/constants/app_constants.dart';

class ThemeService extends GetxController {
  static const _key = AppConstants.isDarkMode;
  final _box = GetStorage();

  // Reactive theme mode
  Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  @override
  void onInit() {
    super.onInit();
    final stored = _box.read<bool>(_key);
    if (stored != null) {
      themeMode.value = stored ? ThemeMode.dark : ThemeMode.light;
      Get.changeThemeMode(themeMode.value);
    }
  }

  void toggleTheme() {
    if (themeMode.value == ThemeMode.dark) {
      themeMode.value = ThemeMode.light;
      _box.write(_key, false);
    } else {
      themeMode.value = ThemeMode.dark;
      _box.write(_key, true);
    }
    Get.changeThemeMode(themeMode.value);
  }

  bool get isDarkMode => themeMode.value == ThemeMode.dark;
}
