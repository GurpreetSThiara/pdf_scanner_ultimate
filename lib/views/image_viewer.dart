
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
       title: Text("View Pdf"),
        actions: [
          ElevatedButton(
            onPressed: () => controller.generatePdf(),
            child: Text('Generate PDF'),
          ),
        ],
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
                child:Image.memory(controller.currentImage) ,
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

                      child: Row(
                        children: [
                          Icon(Icons.arrow_back_ios,color: controller.canGoToPrevious?Colors.deepPurple:Colors.grey),
                          Text('Prev',style: TextStyle(color:controller.canGoToPrevious
                              ? Colors.deepPurple
                              : Colors.grey),),
                        ],
                      ),
                    ),

                    TextButton(
                      onPressed:  () {
                        Get.to(const EditView());
                      },


                      child: Row(
                        children: [
                          Text('Edit',style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.w500),),

                        ],
                      ),
                    ),


                    TextButton(
                      onPressed: controller.canGoToNext
                          ? () => controller.goToNextImage()
                          : null,

                      child: Row(
                        children: [
                          Text('Next',style: TextStyle(color: controller.canGoToNext?Colors.deepPurple:Colors.grey)),
                          Icon(Icons.arrow_forward_ios,color: controller.canGoToNext?Colors.deepPurple:Colors.grey,)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ):Text("empty");
      })
    );
  }
}
