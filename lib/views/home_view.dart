import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_scanner_ultimate/controllers/edit_pdf_controller.dart';
import 'package:pdf_scanner_ultimate/views/edit_view.dart';
import 'package:pdf_scanner_ultimate/views/image_viewer.dart';
import 'dart:io';
import '../controllers/pdf_controller.dart';

class HomeView extends GetView<PdfController> {
  final EditPdfController editPdfController = Get.put(EditPdfController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image to PDF Converter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Stack(
            children: [
             Obx(() {
               return Container(

                 child:  (editPdfController.showIndicator.value==true)?  CircularProgressIndicator(

                 ): Container(),
               );
             }),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  customTile(
                      icon: Icons.picture_as_pdf,
                      title: "Scan PDF",
                      subTitle: "Create a New PDF",
                      onTap:handleSelectImages),
                  customTile(
                      icon: Icons.edit,
                      title: "Edit PDF",
                      subTitle: "Edit an Existing PDF",
                      onTap: handleEditPdf
                      ),

                  SizedBox(height: 20),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => controller.generatePdf(),
                    child: Text('Generate PDF'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customTile({String? title, String? subTitle, IconData? icon, onTap}) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title!),
        subtitle: Text(subTitle!),
        trailing: Icon(Icons.arrow_forward_ios_outlined),
        onTap: onTap,
      ),
    );
  }

  void handleSelectImages() async {
    await controller.pickImages();
    Get.to(const ImageViewer());
  }

  handleEditPdf() async {
    await controller.clearSelectedImages();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if(result !=null && result.files!=null && result.files.first.path!=null){
      await editPdfController.convertPdfToImages(result.files.first.path!,result.files.first.size!);
    }
    Get.to(() => ImageViewer());
  }
}
