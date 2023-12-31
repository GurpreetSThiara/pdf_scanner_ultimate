import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_scanner_ultimate/controllers/pdf_controller.dart';
import 'dart:io';

class EditView extends GetView<PdfController> {
  const EditView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ExtendedImageEditorState> imageKey =GlobalKey<ExtendedImageEditorState>();


    double imageHeight= MediaQuery.of(context).size.height/1.6;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade300,
      ),
      body: Obx(
            () => controller.selectedImages.isNotEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => Container(
                decoration: BoxDecoration(
                  color: Colors.grey
                ),
                height: imageHeight,
                child:ExtendedImage.file(


                  File(controller.currentImage.path),
                  extendedImageEditorKey: imageKey,
                  mode: ExtendedImageMode.editor,
                  fit: BoxFit.contain,
                  initEditorConfigHandler: (state) {
                    double imgWidth = state?.extendedImageInfo?.image.width.toDouble() ?? 1.0;
                    double imgHeight = state?.extendedImageInfo?.image.height.toDouble() ?? 1.0;


                    controller.updateAspectRatio(imgWidth, imgHeight);


                    return EditorConfig(
                      maxScale: 8.0,
                      cropRectPadding: EdgeInsets.all(20.0),
                      hitTestSize: 20.0,
                      initialCropAspectRatio: controller.initialAspectRatio.value


                    );
                  },
                ),

              )
              ),
              const SizedBox(height: 20),

              Container(
                padding: EdgeInsets.all(16),

                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        // card(icon: Icons.crop,iconName: "Crop", onTap: (){
                        //   setState(() {
                        //     croptapped=true;
                        //     imageKey.currentState?.getCropRect();
                        //   });
                        // }),
                        card(icon: Icons.flip,iconName: "Flip",onTap: (){
                          imageKey.currentState?.flip();


                        }),
                        card(icon: Icons.rotate_left,iconName: "Left",onTap: (){
                          imageKey.currentState?.rotate(right: false);


                        }),
                        card(icon: Icons.rotate_right,iconName: "Right",onTap: (){
                          imageKey.currentState?.rotate(right: true);
                        }
                        ),
                        card(icon: Icons.lock_reset,iconName: "Reset",onTap: (){
                          imageKey.currentState?.reset();


                        }),
                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
        )
            : const Text("Add Images"),
      ),
    );
  }
  Widget card({required IconData icon, required String iconName, required Function onTap}) {
    return InkWell(
      onTap: () => onTap(),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 30.0,
                color: Colors.grey.shade600,
              ),
              SizedBox(height: 4.0),
              Text(
                iconName,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
