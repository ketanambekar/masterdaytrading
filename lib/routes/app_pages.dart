import 'package:get/get.dart';
import 'package:masterdaytrading/modules/home/home_binding.dart';
import 'package:masterdaytrading/modules/home/home_view.dart';

abstract class Routes {
  static const home = '/';
}


class AppPages {
  static final pages = [
    GetPage(
      name: Routes.home,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
  ];
}
