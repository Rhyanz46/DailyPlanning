import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:daily_activity/views/home_view.dart';
import 'package:daily_activity/views/detail_view.dart';
import 'package:daily_activity/bindings/home_binding.dart';
import 'package:daily_activity/bindings/detail_binding.dart';

class AppRoutes {
  static const String home = '/';
  static const String detail = '/detail';

  static final List<GetPage> routes = [
    GetPage(
      name: home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: detail,
      page: () => const DetailView(),
      binding: DetailBinding(),
    ),
  ];

  static Widget buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              Get.toNamed(home);
            },
          ),
          ListTile(
            title: const Text('Detail'),
            onTap: () {
              Get.toNamed(detail);
            },
          ),
          // Tambahkan menu lain sesuai kebutuhan
        ],
      ),
    );
  }
}
