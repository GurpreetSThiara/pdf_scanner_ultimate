
import 'package:get/get.dart';

class PdfController extends GetxController{
  RxBool withBytesInPdfViewer = true.obs;
  RxBool withPathInPdfViewer = false.obs;

  setBool(bool withBytes, bool withPath){
    withBytesInPdfViewer.value = withBytes;
    withPathInPdfViewer.value=withPath;

  }
}