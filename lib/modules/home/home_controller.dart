import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:masterdaytrading/services/locale_service.dart';

class HomeController extends GetxController {
  final LocaleService _localeService = LocaleService();
  final ScrollController scrollController = ScrollController();
  final RxBool showAppBar = true.obs;
  ScrollDirection _lastDirection = ScrollDirection.idle;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      final currentDirection = scrollController.position.userScrollDirection;

      if (currentDirection != _lastDirection) {
        _lastDirection = currentDirection;

        if (currentDirection == ScrollDirection.reverse) {
          showAppBar.value = false;
        } else if (currentDirection == ScrollDirection.forward) {
          showAppBar.value = true;
        }
      }
    });
  }

  void changeLanguage(String languageCode) {
    _localeService.changeLocale(languageCode);
  }

  String get currentLanguageCode => Get.locale?.languageCode ?? 'en';

  final supported = ['en', 'hi', 'gu'];

  void cycleLanguage() {
    final current = Get.locale?.languageCode ?? 'en';
    final index = supported.indexOf(current);
    final nextLang = supported[(index + 1) % supported.length];
    _localeService.changeLocale(nextLang);
  }
}
