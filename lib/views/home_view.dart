import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_scanner_ultimate/views/edit_view.dart';
import 'package:pdf_scanner_ultimate/views/image_viewer.dart';
import 'dart:io';
import '../controllers/pdf_controller.dart';

class HomeView extends GetView<PdfController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image to PDF Converter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                handleSelectImages();
              },
              child: Text('Select Images'),
            ),
            SizedBox(height: 20),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => controller.generatePdf(),
              child: Text('Generate PDF'),
            ),
          ],
        ),
      ),
    );
  }

  void handleSelectImages()async {
    await controller.pickImages();
    Get.to(const ImageViewer());
  }
}
