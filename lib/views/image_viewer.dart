import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_scanner_ultimate/controllers/create_pdf_controller.dart';
import 'package:pdf_scanner_ultimate/views/edit_view.dart';
import 'package:pdf_scanner_ultimate/views/preview_pdf.dart';
import 'package:pdf_scanner_ultimate/views/rearrange.dart';

class ImageViewer extends GetView<CreatePdfController> {
  const ImageViewer({Key? key}) : super(key: key);

  void handleViewPdf() async {
    await controller.generatePdf();
    Get.to(PreviewPdf());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PDF Viewer"),
        actions: [
          IconButton(
            onPressed: handleViewPdf,
            icon: Icon(Icons.preview),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double imageHeight = constraints.maxHeight / 2;

            return Obx(
              () {
                return controller.selectedImages.isNotEmpty
                    ? _buildImageViewerBody(imageHeight, context)
                    : Center(child: CircularProgressIndicator());
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildImageViewerBody(double imageHeight, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Page ${controller.currentIndex.value + 1} of ${controller.selectedImages.length}',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.grey.shade300,
                  Colors.grey,
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  controller.currentImage,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        _buildButtonRow(context),
        SizedBox(height: 16),
        _buildNavigationRow(context),
        SizedBox(height: 32),
      ],
    );
  }

  Widget _buildButtonRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () {
            handleAddImage(context);
          },
          child: Text('Generate PDF'),
        ),
        ElevatedButton(
          onPressed: () {
            Get.to(Rearrange());
          },
          child: Text('Rearrange'),
        ),
        ElevatedButton(
          onPressed: () {
            handleAddImage(context);
          },
          child: Row(
            children: [
              Text('Add '),
              Icon(Icons.image),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildNavigationButton(
          onPressed: controller.canGoToPrevious
              ? () => controller.goToPreviousImage()
              : null,
          icon: Icons.arrow_back_ios,
        ),
        _buildNavigationButton(
          onPressed: () {
            handleDelete(context);
          },
          icon: Icons.delete,
        ),
        _buildNavigationButton(
          onPressed: () {
            Get.to(const EditView());
          },
          icon: Icons.edit,
        ),
        _buildNavigationButton(
          onPressed:
              controller.canGoToNext ? () => controller.goToNextImage() : null,
          icon: Icons.arrow_forward_ios,
        ),
      ],
    );
  }

  Widget _buildNavigationButton({
    required VoidCallback? onPressed,
    required IconData icon,
  }) {
    return CircleAvatar(
      backgroundColor: onPressed != null ? Colors.deepPurple : Colors.grey,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
      ),
    );
  }

  void handleAddImage(BuildContext context) async {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Choose Image From'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () async {
                  controller.addImageAtIndex(true);
                  Navigator.pop(context);
                },
                icon: Icon(Icons.camera_alt),
              ),
              IconButton(
                onPressed: () async {
                  controller.addImageAtIndex(false);
                  Navigator.pop(context);
                },
                icon: Icon(Icons.image),
              ),
            ],
          ),
        );
      },
    );
  }

  void handleDelete(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Text('Are You Sure To Delete this Image'),
            actions: [
              TextButton(onPressed: () {
                controller.deleteImage();
                Get.back();

              }, child: Text('Delete')),
              TextButton(onPressed: () {
                Get.back();
              }, child: Text('Cancel')),
            ],
          );
        });
  }
}
