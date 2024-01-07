import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_scanner_ultimate/controllers/edit_pdf_controller.dart';
import 'package:pdf_scanner_ultimate/controllers/hive_controller.dart';
import 'package:pdf_scanner_ultimate/views/edit_view.dart';
import 'package:pdf_scanner_ultimate/views/image_viewer.dart';
import 'package:pdf_scanner_ultimate/views/preview_pdf.dart';
import 'dart:io';
import '../controllers/create_pdf_controller.dart';

class HomeView extends GetView<CreatePdfController> {
  final EditPdfController editPdfController = Get.put(EditPdfController());
  final HiveController hiveController = Get.put(HiveController());

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width/2.5;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Pdf Scanner'),
        leading: IconButton(
          icon: Image.asset('assets/hamburger.png',),
          onPressed: (){},
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Stack(
            children: [
              Obx(() {
                return Container(
                  child: (editPdfController.showIndicator.value == true)
                      ? CircularProgressIndicator()
                      : Container(),
                );
              }),
              SizedBox(
                height: height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: width+30,
                      child: GridView(

                        gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Adjust the number of columns as needed
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                          childAspectRatio: 16/6



                        ),
                        children: [
                          customTile(
                              icon:Icons.picture_as_pdf,
                              title: "Scan PDF",
                              subTitle: "create a new pdf",
                              onTap: handleSelectImages,
                          width: width),
                          customTile(
                            icon: Icons.edit,

                              title: "Edit PDF",
                              subTitle: "edit an existing pdf",
                              onTap: handleEditPdf,
                          width: width),
                          customTile(

                            icon: Icons.merge,

                              title: "Merge PDFs",
                              subTitle: "merge multiple pdf files",
                              onTap: handleMergePdfs,
                              width:width),
                          customTile(

                              icon: Icons.splitscreen,

                              title: "Split PDFs",
                              subTitle: "merge multiple pdf files",
                              onTap: handleMergePdfs,
                              width:width),


                        ],
                      ),
                    ),

                    Text("Recents",style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05, ),),
                    hiveController.pdfList.value.isNotEmpty?
                        SingleChildScrollView(
                          child: SizedBox(
                            height: 400,
                            child: ListView.builder(itemCount:hiveController.pdfList.value.length,itemBuilder:(context,index){
                              var item = hiveController.pdfList.value[index];
                              return Card(child: ListTile(title: Text('title: '+item.name),subtitle: Text(item.path),trailing: Icon(Icons.arrow_forward_ios)),);
                            }),
                          ),
                        )
                        :Text('No items'),
                    SizedBox(height: 50,)

                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget customTile({String? title, String? subTitle, IconData? icon, onTap,width}) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1,color: Colors.grey.shade300,),
          borderRadius: BorderRadius.circular(10)
        ),
        width: width,


        child: ListTile(
          leading: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade300,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: Colors.deepPurple.shade600)

            ),
            child: Icon(icon,color: Colors.white,),
          ),
          title: Text(title!,style: TextStyle(color: Colors.grey.shade800),),

          onTap: onTap,
        ),
      ),
    );
  }

  void handleSelectImages() async {
    await controller.pickImages();
    Get.to(const ImageViewer());
  }

  handleMergePdfs() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      List<String> paths = [];
      for (var i in result.files) {
        paths.add(i.path!);
      }
      await editPdfController.mergeMultiplePdfs(paths);
      Get.to(PreviewPdf());
    }
  }

  handleEditPdf() async {
    await controller.clearSelectedImages();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,


      allowedExtensions: ['pdf'],
    );
    if (result != null &&
        result.files != null &&
        result.files.first.path != null) {
      await editPdfController.convertPdfToImages(
          result.files.first.path!, result.files.first.size!);
    }
    Get.to(() => ImageViewer());
  }
}
