import 'package:hive/hive.dart';

part 'pdf_data.g.dart';

@HiveType(typeId: 0)
class PdfData {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late String path;

  PdfData({required this.name, required this.path});
}
