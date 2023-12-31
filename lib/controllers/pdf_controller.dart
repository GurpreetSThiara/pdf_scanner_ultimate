import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:image_picker/image_picker.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:extended_image/extended_image.dart';

class PdfController extends GetxController {
  RxInt currentIndex = 0.obs;
  List<XFile> selectedImages = <XFile>[].obs;
  XFile get currentImage => selectedImages[currentIndex.value];

  bool get canGoToPrevious => currentIndex.value > 0;

  bool get canGoToNext => currentIndex.value < selectedImages.length - 1;

  RxDouble initialAspectRatio = 1.0.obs;

  void updateAspectRatio(double width, double height) {
    initialAspectRatio.value = width / height;
  }


  void goToPreviousImage() {
    if (canGoToPrevious) {
      currentIndex.value--;
    }
  }

  void goToNextImage() {
    if (canGoToNext) {
      currentIndex.value++;
    }
  }

  Future<void> pickImages() async {
    List<XFile>? images = await ImagePicker().pickMultiImage();
    if (images != null && images.isNotEmpty) {
      selectedImages.assignAll(images);
    }
  }

  Future<void> generatePdf() async {
    print("pppppppppppppppppppppppppppppppppppp");

    if (selectedImages.isEmpty) {
      Get.snackbar('No Images Selected', 'Please select images to generate PDF');
      return;
    }

    final pdf = pw.Document();

    for (var image in selectedImages) {
      final imageFile = File(image.path);
      final imageBytes = await imageFile.readAsBytes();

      pdf.addPage(pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(pw.MemoryImage(imageBytes)),
          );
        },
      ));
    }

    await saveAndOpenPdf(pdf, 'image_pdf');
    // Get.snackbar('PDF Generated', 'Saved at ${file.path}');
  }


  Future<void> saveAndOpenPdf(pw.Document pdf, String name) async {
    // Check for storage permission
    var status = await Permission.storage.request();

    if (status != PermissionStatus.granted) {
      Get.snackbar('Permission Denied', 'Storage permission is required',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final bytes = await pdf.save();

    // Get the downloads directory
    Directory? downloadsDirectory = await DownloadsPath.downloadsDirectory();

    // Use SAF to create a directory in the file manager
    final directoryPath = downloadsDirectory!.path;

    try {
      // Create the directory if it doesn't exist
      await Directory(directoryPath).create(recursive: true);
    } catch (e) {
      Get.snackbar('Error', 'Failed to create directory',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Create a File object with the appropriate path
    final file = await File('$directoryPath/$name.pdf').create();

    // Write the bytes to the file
    await file.writeAsBytes(bytes);

    // Display a snackbar with a message
    Get.snackbar('PDF Saved', 'Saved at $directoryPath',
        snackPosition: SnackPosition.BOTTOM);

    // Open the PDF within the app
    // OpenFile.open(file.path);
  }}
