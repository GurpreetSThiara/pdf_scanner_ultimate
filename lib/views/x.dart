import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:image_picker/image_picker.dart';



class ImageFilterPage extends StatefulWidget {
  @override
  _ImageFilterPageState createState() => _ImageFilterPageState();
}

class _ImageFilterPageState extends State<ImageFilterPage> {
  Image? _originalImage;
  Uint8List? _filteredImageBytes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Scanner App'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _originalImage != null ? _originalImage! : CircularProgressIndicator(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loadImage,
                child: Text('Capture Image'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _applyFilter(FilterType.original),
                child: Text('Original'),
              ),
              ElevatedButton(
                onPressed: () => _applyFilter(FilterType.blackAndWhite),
                child: Text('Black & White'),
              ),
              ElevatedButton(
                onPressed: () => _applyFilter(FilterType.grayscale),
                child: Text('Grayscale'),
              ),
              ElevatedButton(
                onPressed: () => _applyFilter(FilterType.colorFilter),
                child: Text('Color Filter'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed:(){},
                child: Text('Create PDF'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();

      final img.Image? image = await img.decodeImage(bytes);

      setState(() {
        _originalImage = Image.memory(bytes);
        _filteredImageBytes = Uint8List.fromList(img.encodeJpg(image!));
      });
    }
  }

  void _applyFilter(FilterType filterType) {
    if (_originalImage != null) {
      final img.Image? image = img.decodeImage(_filteredImageBytes!);

      switch (filterType) {
        case FilterType.original:
          break; // No filter for original image
        case FilterType.blackAndWhite:
          img.grayscale(image!);
          break;
        case FilterType.grayscale:
          img.grayscale(image!,amount: 90);
          break;
        case FilterType.colorFilter:
        // Implement your custom color filter logic here
          break;
      }

      setState(() {
        print("Start");

        _filteredImageBytes = Uint8List.fromList(img.encodeJpg(image!));
        print("end");
      });
    }
  }


}

enum FilterType {
  original,
  blackAndWhite,
  grayscale,
  colorFilter,
}
