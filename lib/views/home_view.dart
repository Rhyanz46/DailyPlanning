import 'package:daily_activity/app/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home View'),
      ),
      drawer: AppRoutes.buildDrawer(), // Gunakan drawer di sini
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Selamat Datang di Home View',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.toNamed('/detail'); // Navigasi ke halaman detail
              },
              child: const Text('Pergi ke Detail View'),
            ),
          ],
        ),
      ),
    );
  }
}
