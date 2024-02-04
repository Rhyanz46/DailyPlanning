import 'package:get/get.dart';
import 'package:daily_activity/controllers/detail_controller.dart';

class DetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailController>(() => DetailController());
  }
}
