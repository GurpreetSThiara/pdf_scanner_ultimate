import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_scanner_ultimate/controllers/pdf_controller.dart';
import 'package:pdf_scanner_ultimate/views/edit_view.dart';
import 'package:pdf_scanner_ultimate/views/preview_pdf.dart';
import 'package:pdf_scanner_ultimate/views/rearrange.dart';

class ImageViewer extends GetView<PdfController> {
  const ImageViewer({Key? key}) : super(key: key);

  handleViewPdf()async{

    await controller.generatePdf();
    Get.to(PreviewPdf());
  }

  @override
  Widget build(BuildContext context) {
    double imageHeight = MediaQuery.of(context).size.height / 2;

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
        child: Obx(
              () {
            return controller.selectedImages.isNotEmpty
                ? _buildImageViewerBody(imageHeight)
                : const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildImageViewerBody(double imageHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text('page ''${controller.currentIndex.value+1}'' of' ' ${controller.selectedImages.length}'),
        ),
        Expanded(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors:  [
                  Colors.grey, // Start color
                  Colors.deepPurple, // End color
                ],
              ),

            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.memory(controller.currentImage,fit: BoxFit.contain,),
            ),
          ),

        ),
        SizedBox(height: 16),
        _buildButtonRow(),
        SizedBox(height: 16),
        _buildNavigationRow(),
        SizedBox(height: 32),
      ],
    );
  }

  Widget _buildButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () {Get.to(Rearrange());},
          child: Text('Rearrange'),
        ),
        ElevatedButton(
          onPressed: () => controller.generatePdf(),
          child: Text('Generate PDF'),
        ),
      ],
    );
  }

  Widget _buildNavigationRow() {
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
            Get.to(const EditView());
          },
          icon: Icons.edit,
        ),
        _buildNavigationButton(
          onPressed: controller.canGoToNext
              ? () => controller.goToNextImage()
              : null,
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
}
