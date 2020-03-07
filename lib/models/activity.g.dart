// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivityAdapter extends TypeAdapter<Activity> {
  @override
  final typeId = 10;

  @override
  Activity read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Activity(
      fields[0] as String,
      (fields[1] as List)?.cast<Category>(),
      fields[3] as ActivityType,
      (fields[2] as List)?.cast<Entry>(),
    ).._color = fields[4] as int;
  }

  @override
  void write(BinaryWriter writer, Activity obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.categories)
      ..writeByte(2)
      ..write(obj.entries)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj._color);
  }
}
