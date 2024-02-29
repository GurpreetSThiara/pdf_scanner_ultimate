import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:pdf_scanner_ultimate/controllers/signature_controller.dart';
import 'package:permission_handler/permission_handler.dart';





class SignaturePage extends StatefulWidget {
  @override
  State<SignaturePage> createState() => _SignaturePageState();
}

class _SignaturePageState extends State<SignaturePage> {
  final SignatureController controller = Get.put(SignatureController());

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Signatures'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: (){
                controller.clearPoints();
              }, child: Text('clear')),
              Slider(max: 8, min:1,value: controller.strokeWidth.value, onChanged: (value){
                controller.setStrokeWidth(value);
              }),

          
              Container(
                margin: EdgeInsets.all(8),
                height:300,
                width: 300,
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: GetBuilder<SignatureController>(
                  builder: (controller) => SignaturePainter(key: controller.signatureKey),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                 await controller.signatureKey.currentState!.exportSignature(300,300);
                  // Save the image here
                  // You can implement saving functionality using any preferred method (e.g., image_gallery_saver)
                  // For simplicity, let's just print the bytes

                },
                child: Text('Save Signature'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignaturePainter extends StatefulWidget {
  SignaturePainter({Key? key}) : super(key: key);

  @override
  SignaturePainterState createState() => SignaturePainterState();
}

class SignaturePainterState extends State<SignaturePainter> {
  final SignatureController controller = Get.put(SignatureController());


  late ui.Image _backgroundImage;

  @override
  void initState() {
    super.initState();
    _loadBackgroundImage();
  }

  Future<void> _loadBackgroundImage() async {
    // Load your background image here
    // For simplicity, I'll just use a blank white image
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromPoints(Offset.zero, Offset(300, 300)));
    canvas.drawColor(Colors.white, BlendMode.dstOver); // Blank white background
    final picture = recorder.endRecording();
    _backgroundImage = await picture.toImage(300, 300);
  }



  Future<Uint8List> exportSignature(int height, int width) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromPoints(Offset.zero, Offset(width.toDouble(), height.toDouble())));

    if (_backgroundImage != null) {
      canvas.drawImage(_backgroundImage, Offset.zero, Paint());
    }

    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = controller.strokeWidth.value;

    for (int i = 0; i < controller.points.length - 1; i++) {
      if (controller.points[i] != null && controller.points[i + 1] != null) {
        canvas.drawLine(controller.points[i], controller.points[i + 1], paint);
      }
    }

    final picture = recorder.endRecording();
    final img = await picture.toImage(width, height);
    final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List bytes = Uint8List.view(pngBytes!.buffer);

    var status = await Permission.storage.request();

    if (status != PermissionStatus.granted) {
      Get.snackbar('Permission Denied', 'Storage permission is required',
          snackPosition: SnackPosition.BOTTOM);
      return Uint8List(0);
    }

    Directory? downloadsDirectory = await DownloadsPath.downloadsDirectory();
    final directoryPath = downloadsDirectory!.path;
    File file = File('$directoryPath/signature${DateTime.now()}.png');
    await file.writeAsBytes(bytes);

    return bytes;
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          RenderBox renderBox = context.findRenderObject() as RenderBox;
          controller.points.add(renderBox.globalToLocal(details.globalPosition));
        });
      },
      onPanEnd: (details) {
        controller.points.add(Offset.infinite);
      },
      child: CustomPaint(
        painter: SignaturePainterCustom(points: controller.points),
        size: Size(300, 300),
      ),
    );
  }
}

class SignaturePainterCustom extends CustomPainter {
  final SignatureController controller = Get.put(SignatureController());

  final List<Offset> points;

  SignaturePainterCustom({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = controller.strokeWidth.value;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.infinite && points[i + 1] != Offset.infinite) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
