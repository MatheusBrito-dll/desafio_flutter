import 'package:get/get.dart';
import '../screens/home_page.dart';
import '../screens/unit_detail_page.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomePage(),
    ),
    GetPage(
      name: AppRoutes.UNIT_DETAIL,
      page: () => UnitDetailPage(),
    ),
  ];
}
