import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:daily_activity/app/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Nama Proyek',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: AppRoutes.home,
      getPages: AppRoutes.routes,
    );
  }
}
