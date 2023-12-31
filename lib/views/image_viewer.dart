
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_scanner_ultimate/controllers/pdf_controller.dart';
import 'package:pdf_scanner_ultimate/views/edit_view.dart';

class ImageViewer extends GetView<PdfController> {
  const ImageViewer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double imageHeight= MediaQuery.of(context).size.height/1.8;
    double width= MediaQuery.of(context).size.width;

    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade400,
      ),
      body: Obx(() {
        return controller.selectedImages.isNotEmpty?Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.grey),
                height: imageHeight,
                width:width ,
                child:Image.file(File(controller.currentImage.path)) ,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: controller.canGoToPrevious
                          ? () => controller.goToPreviousImage()
                          : null,
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            return controller.canGoToPrevious
                                ? Colors.deepPurple
                                : Colors.grey;
                          },
                        ),
                      ),
                      child: Text('Prev',style: TextStyle(color: Colors.deepPurple),),
                    ),

                    TextButton(
                      onPressed: controller.canGoToPrevious
                          ? () {
                        Get.to(const EditView());
                      }
                          : null,
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            return Colors.grey;
                          },
                        ),
                      ),
                      child: Text('Edit',style: TextStyle(color: Colors.deepPurple),),
                    ),


                    TextButton(
                      onPressed: controller.canGoToNext
                          ? () => controller.goToNextImage()
                          : null,
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            return controller.canGoToNext
                                ? Colors.deepPurple.shade400
                                : Colors.grey;
                          },
                        ),
                      ),
                      child: Text('Next',style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ):Text("");
      })
    );
  }
}
