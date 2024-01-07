import 'package:get/get.dart';
import 'package:pdf_scanner_ultimate/controllers/create_pdf_controller.dart';
import 'package:flutter/material.dart';

class Rearrange extends GetView<CreatePdfController> {
  const Rearrange({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rearrange Images'),
      ),
      body: Obx(() {
        return ReorderableListView(
          onReorder: (oldIndex, newIndex) {
            // Handle the image reordering logic here
            controller.reorderImages(oldIndex, newIndex);
          },
          children: List.generate(
            controller.selectedImages.length,
                (index) => Card(
              key: Key('$index'),
              elevation: 3,
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                contentPadding: EdgeInsets.all(8),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    controller.selectedImages[index],
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text('Image $index'),
              ),
            ),
          ),
        );
      })
    );
  }
}
