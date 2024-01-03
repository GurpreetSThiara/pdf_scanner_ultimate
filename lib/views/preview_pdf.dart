import 'dart:async';
import 'dart:io';
import 'package:alh_pdf_view/controller/alh_pdf_view_controller.dart';
import 'package:alh_pdf_view/view/alh_pdf_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:pdf_scanner_ultimate/controllers/pdf_controller.dart';

class PreviewPdf extends GetView<PdfController> {

  PreviewPdf({Key? key}) : super(key: key);
  AlhPdfViewController? alhPdfViewController;






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Preview pdf"),
        actions: [
          ElevatedButton(
            onPressed: () {
              _showSaveDialog(context);
            },
            child: const Text('Save'),
          )
        ],
      ),
      body: AlhPdfView(
        onViewCreated: (controller) {
          alhPdfViewController = controller;
        },
        bytes: controller.bytes.value,
        showScrollbar: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showPageDialog(context);
        },
        child: Icon(Icons.pageview),
      ),
    );
  }


  Future<void> _showSaveDialog(BuildContext context) async {

    TextEditingController _textFieldController = TextEditingController();


    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter PDF Name'),
          content: SizedBox(
            height: MediaQuery.of(context).size.height/2,
            child: Column(
              children: [
                TextField(
                  controller: _textFieldController,
                  decoration: InputDecoration(hintText: 'Enter name'),
                ),
                ListTile(
                  leading: Icon(Icons.folder),
                  title: Text("Storage Directory"),
                  subtitle:Text('${controller.downloadsDirectory}') ,
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Get.back();
                // Call the saveAndOpenPdf function with the entered PDF name
                if(_textFieldController.text=="" || _textFieldController.text.isEmpty){
                  controller.saveAndOpenPdf(DateTime.now().toString());
                }
                else{
                  controller.saveAndOpenPdf(_textFieldController.text);
                }
              },
              child: Text('Save'),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
  Future<void> _showPageDialog(BuildContext context) async {
    TextEditingController _pageController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Go to Page'),
          content: SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            child: Column(
              children: [
                TextField(
                  controller: _pageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: 'Enter page number'),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Get.back();
                // Navigate to the specified page
                int pageNumber = int.tryParse(_pageController.text) ?? 1;
                alhPdfViewController?.setPage(page: pageNumber);
              },
              child: Text('Go'),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
