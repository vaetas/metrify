// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TypeKindAdapter extends TypeAdapter<TypeKind> {
  @override
  final typeId = 23;

  @override
  TypeKind read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TypeKind.numeric;
      case 1:
        return TypeKind.enumeration;
      case 2:
        return TypeKind.range;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, TypeKind obj) {
    switch (obj) {
      case TypeKind.numeric:
        writer.writeByte(0);
        break;
      case TypeKind.enumeration:
        writer.writeByte(1);
        break;
      case TypeKind.range:
        writer.writeByte(2);
        break;
    }
  }
}

class ActivityTypeAdapter extends TypeAdapter<ActivityType> {
  @override
  final typeId = 24;

  @override
  ActivityType read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActivityType(
      fields[0] as String,
      fields[1] as TypeKind,
      numericType: fields[2] as NumericType,
      enumType: fields[3] as EnumType,
      rangeType: fields[4] as RangeType,
    );
  }

  @override
  void write(BinaryWriter writer, ActivityType obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.kind)
      ..writeByte(2)
      ..write(obj.numericType)
      ..writeByte(3)
      ..write(obj.enumType)
      ..writeByte(4)
      ..write(obj.rangeType);
  }
}

class NumericTypeAdapter extends TypeAdapter<NumericType> {
  @override
  final typeId = 25;

  @override
  NumericType read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NumericType(
      fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, NumericType obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.unit);
  }
}

class EnumTypeAdapter extends TypeAdapter<EnumType> {
  @override
  final typeId = 26;

  @override
  EnumType read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EnumType(
      (fields[0] as List)?.cast<EnumTypeValue>(),
    );
  }

  @override
  void write(BinaryWriter writer, EnumType obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.values);
  }
}

class EnumTypeValueAdapter extends TypeAdapter<EnumTypeValue> {
  @override
  final typeId = 27;

  @override
  EnumTypeValue read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EnumTypeValue(
      fields[0] as int,
      fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, EnumTypeValue obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.weight)
      ..writeByte(1)
      ..write(obj.name);
  }
}

class RangeTypeAdapter extends TypeAdapter<RangeType> {
  @override
  final typeId = 28;

  @override
  RangeType read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RangeType(
      fields[0] as double,
      fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, RangeType obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.min)
      ..writeByte(1)
      ..write(obj.max);
  }
}
