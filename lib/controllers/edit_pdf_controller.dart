


import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf_scanner_ultimate/controllers/pdf_controller.dart';
// import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart' as pw;
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'dart:io';

class EditPdfController extends GetxController{

  List<Uint8List> pdfPages =  <Uint8List>[].obs;
  PdfController pdfController = Get.find();
  RxBool showIndicator =false.obs;
  var currentPage = 0;
  var progress=0.obs;
  Map<String, double> quality = {
    'low': 75,
    'good': 100,
    'better': 150,
    'best':200,
    'excellent':300

  };


   convertPdfToImages(String pdfFilePath, int size) async {
     pdfPages.clear();
     showIndicator.value=true;

    final file = File(pdfFilePath);
    final data = await file.readAsBytes();

    await for (var page in pw.Printing.raster( data,dpi: quality['excellent']!)) {
    final image =await page.toPng();

    pdfPages.add(image);
    currentPage++;
     progress.value = (currentPage / size * 100).toInt();


    }

    pdfController.updateSelectedImages(pdfPages);
     showIndicator.value=false;

  }


}