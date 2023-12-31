import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_scanner_ultimate/controllers/pdf_controller.dart';

import 'views/home_view.dart';

void main() {
  Get.put(PdfController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Image to PDF Converter',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: HomeView(),
    );
  }
}
