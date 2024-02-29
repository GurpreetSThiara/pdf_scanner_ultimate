import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../views/signature.dart';

class SignatureController extends GetxController {
   final GlobalKey<SignaturePainterState> signatureKey = GlobalKey();
   Rx<double> strokeWidth = 4.0.obs;
   RxList<Offset> points = <Offset>[].obs;



   setStrokeWidth(double width){
     strokeWidth.value =width;
   }

   addPoints(Offset o){
     points.add(o);
   }

   clearPoints(){
     points.clear();
   }

}
