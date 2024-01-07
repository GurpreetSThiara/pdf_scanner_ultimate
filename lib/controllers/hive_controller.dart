

import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../models/pdf_data.dart';

class HiveController extends GetxController{
  Box<PdfData>? _pdfBox;
  var pdfList = <PdfData>[].obs;

  @override
  void onInit() async {
    await _initHive();
    super.onInit();
  }

  Future<void> _initHive() async {

    _pdfBox = await Hive.openBox<PdfData>('pdfBox');
    if(_pdfBox!=null){
      pdfList.assignAll(_pdfBox!.values.toList());
    }
  }

  Future<void> addPdf(String name, String path) async {
    final pdfData = PdfData(name: name, path: path);
    await _pdfBox?.add(pdfData);
    pdfList.add(pdfData);
  }


}