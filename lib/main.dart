import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pdf_scanner_ultimate/controllers/create_pdf_controller.dart';


import 'controllers/hive_controller.dart';
import 'models/pdf_data.dart';
import 'views/home_view.dart';

void main() async{
  await Hive.initFlutter();
  Hive.registerAdapter(PdfDataAdapter());
  await Hive.openBox<PdfData>('pdfBox');
  await Hive.openBox('database');
  Get.put(CreatePdfController());




  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  var box = Hive.box('database');



  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: InitialBinding(),
      title: 'Image to PDF Converter',
      theme:box.get('theme')=="dark"?ThemeData.dark(): ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: HomeView(),
    );
  }
}
class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HiveController());

  }
}