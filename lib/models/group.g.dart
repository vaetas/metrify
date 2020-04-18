// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EntryGroupingAdapter extends TypeAdapter<EntryGrouping> {
  @override
  final typeId = 30;

  @override
  EntryGrouping read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 1:
        return EntryGrouping.hour;
      case 2:
        return EntryGrouping.day;
      case 3:
        return EntryGrouping.week;
      case 4:
        return EntryGrouping.month;
      case 5:
        return EntryGrouping.year;
      case 6:
        return EntryGrouping.none;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, EntryGrouping obj) {
    switch (obj) {
      case EntryGrouping.hour:
        writer.writeByte(1);
        break;
      case EntryGrouping.day:
        writer.writeByte(2);
        break;
      case EntryGrouping.week:
        writer.writeByte(3);
        break;
      case EntryGrouping.month:
        writer.writeByte(4);
        break;
      case EntryGrouping.year:
        writer.writeByte(5);
        break;
      case EntryGrouping.none:
        writer.writeByte(6);
        break;
    }
  }
}
