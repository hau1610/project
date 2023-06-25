import 'package:aplusphoto/presentation/homepage/homepage.dart';
import 'package:aplusphoto/presentation/imageeditingpage/pages/editting_image_page.dart';
import 'package:aplusphoto/presentation/introduction/introduction.dart';
import 'package:get/get.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: '/introduction', page: () => const Introduction()),
    GetPage(name: '/homepage', page: () => const HomePage()),
    GetPage(name: '/filterpage', page: () => const FilterPage()),
  ];
}
