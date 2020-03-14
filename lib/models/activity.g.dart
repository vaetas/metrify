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
      grouping: fields[5] as EntryGrouping,
    ).._color = fields[4] as int;
  }

  @override
  void write(BinaryWriter writer, Activity obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.categories)
      ..writeByte(2)
      ..write(obj.entries)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj._color)
      ..writeByte(5)
      ..write(obj.grouping);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Activity _$ActivityFromJson(Map<String, dynamic> json) {
  return Activity(
    json['name'] as String,
    (json['categories'] as List)
        ?.map((e) =>
            e == null ? null : Category.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    _typeFromJson(json['type'] as Map<String, dynamic>),
    _entriesFromJson(json['entries'] as List<Map<String, dynamic>>),
    grouping: _$enumDecodeNullable(_$EntryGroupingEnumMap, json['grouping']),
  );
}

Map<String, dynamic> _$ActivityToJson(Activity instance) => <String, dynamic>{
      'name': instance.name,
      'categories': instance.categories,
      'entries': _entriesToJson(instance.entries),
      'type': _typeToJson(instance.type),
      'grouping': _$EntryGroupingEnumMap[instance.grouping],
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$EntryGroupingEnumMap = {
  EntryGrouping.minute: 'minute',
  EntryGrouping.hour: 'hour',
  EntryGrouping.day: 'day',
  EntryGrouping.week: 'week',
  EntryGrouping.month: 'month',
  EntryGrouping.year: 'year',
};
