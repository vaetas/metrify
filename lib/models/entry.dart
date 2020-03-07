import 'package:hive/hive.dart';
import 'package:metrify/models/type.dart';

part 'entry.g.dart';

const String entryBox = 'entries';

@HiveType(typeId: 12)
class Entry extends HiveObject {
  @HiveField(0)
  DateTime timestamp;

  @HiveField(1)
  double value;

  Entry(this.timestamp, this.value);

  @override
  String toString() => 'Entry{timestamp: $timestamp, value: $value}';

  /// Returns value of [Entry] formatted appropriately for given [type].
  String format(ActivityType type) {
    switch (type.kind) {
      case TypeKind.numeric:
        return '$value ${type.numericType.unit}';
      case TypeKind.enumeration:
        for (EnumTypeValue x in type.enumType.values) {
          if (x.weight == value.toInt()) {
            return x.name;
          }
        }
        return 'UNKNOWN';
      case TypeKind.range:
        return '${value?.toInt()?.toString() ?? 'ERROR'}';
      default:
        return value.toString();
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Entry && runtimeType == other.runtimeType && timestamp == other.timestamp && value == other.value;

  @override
  int get hashCode => timestamp.hashCode ^ value.hashCode;
}
