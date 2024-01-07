// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pdf_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PdfDataAdapter extends TypeAdapter<PdfData> {
  @override
  final int typeId = 0;

  @override
  PdfData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PdfData(
      name: fields[0] as String,
      path: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PdfData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.path);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PdfDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
