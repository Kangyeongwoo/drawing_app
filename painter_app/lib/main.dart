import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:painter_app/drawing_page.dart';

import 'binding/AppBinding.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: AppBindings(),
      home:  DrawingPage(),
    );
  }
}