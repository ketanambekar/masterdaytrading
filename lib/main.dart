import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:masterdaytrading/services/theme_service.dart';
import 'package:masterdaytrading/widgets/bottom_bar/offer_timer_controller.dart';
import 'theme/app_theme.dart';
import 'services/locale_service.dart';
import 'translations/app_translations.dart';
import 'routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  final localeService = LocaleService();
  Get.put(OfferTimerController());
  runApp(MyApp(localeService: localeService));
}

class MyApp extends StatelessWidget {
  final LocaleService localeService;

  const MyApp({super.key, required this.localeService});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.put(ThemeService());
    return
      // Obx(()=>

        GetMaterialApp(
        title: 'Trading App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,//themeService.themeMode.value,
        translations: AppTranslations(),
        locale: localeService.getStoredLocale(),
        fallbackLocale: localeService.fallbackLocale,
        getPages: AppPages.pages,
        initialRoute: Routes.home,
      // ),
    );
  }
}
