

import 'package:get/get.dart';
import 'package:painter_app/controller/BackgroundController.dart';
import 'package:painter_app/controller/DrawingController2.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(DrawingController2());
    Get.put(BackGroudController());
  }
}