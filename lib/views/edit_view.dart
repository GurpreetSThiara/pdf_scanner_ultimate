import 'dart:typed_data';
import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_editor/image_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_scanner_ultimate/controllers/create_pdf_controller.dart';
import 'dart:io';

class EditView extends GetView<CreatePdfController> {
  const EditView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final GlobalKey<ExtendedImageEditorState> imageKey =GlobalKey<ExtendedImageEditorState>();


    double imageHeight= MediaQuery.of(context).size.height/1.6;
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit pdf"),
        actions: [
          ElevatedButton(onPressed: (){
            final ExtendedImageEditorState? state = imageKey.currentState;
            handleImageSave(state);
          }, child: Text("Save"))
        ],
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
                child:ExtendedImage.memory(
                  controller.currentImage,



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
                color: Colors.deepPurple.shade400,
              ),
              SizedBox(height: 4.0),
              Text(
                iconName,
                style: TextStyle(
                  color: Colors.deepPurple.shade400,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> handleImageSave(ExtendedImageEditorState? state) async {
    Uint8List? bytes=  await  cropImageDataWithNativeLibrary(state: state!);
    // Directory tempDir = await getTemporaryDirectory();
    // String tempPath = tempDir.path;
    //
    // // Create a temporary file
    // File tempFile = File('$tempPath/temp_edited_file.jpg');

    // // Write the Uint8List to the file
    // await tempFile.writeAsBytes(x);
    //
    // // Create an XFile from the temporary file
    // XFile xFile = XFile.fromData(bytes!);

    controller.updateImage(image: bytes);
    Get.back();

  }
  Future<Uint8List?> cropImageDataWithNativeLibrary(
      {required ExtendedImageEditorState state}) async {

    Rect cropRect = state.getCropRect()!;
    if (state.widget.extendedImageState.imageProvider is ExtendedResizeImage) {
      final ImmutableBuffer buffer =
      await ImmutableBuffer.fromUint8List(state.rawImageData);
      final ImageDescriptor descriptor = await ImageDescriptor.encoded(buffer);

      final double widthRatio = descriptor.width / state.image!.width;
      final double heightRatio = descriptor.height / state.image!.height;
      cropRect = Rect.fromLTRB(
        cropRect.left * widthRatio,
        cropRect.top * heightRatio,
        cropRect.right * widthRatio,
        cropRect.bottom * heightRatio,
      );
    }

    final EditActionDetails action = state.editAction!;


    final int rotateAngle = action.rotateAngle.toInt();
    final bool flipHorizontal = action.flipY;
    final bool flipVertical = action.flipX;
    final Uint8List img = state.rawImageData;

    final ImageEditorOption option = ImageEditorOption();

    if (action.needCrop) {
      option.addOption(ClipOption.fromRect(cropRect));

    }

    if (action.needFlip) {
      option.addOption(
          FlipOption(horizontal: flipHorizontal, vertical: flipVertical));
    }

    if (action.hasRotateAngle) {
      option.addOption(RotateOption(rotateAngle));
    }


    final DateTime start = DateTime.now();
    final Uint8List? result = await ImageEditor.editImage(
      image: img,
      imageEditorOption: option,
    );

    print('${DateTime.now().difference(start)} ：total time');
    return result;
  }


}
