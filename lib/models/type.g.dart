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

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityType _$ActivityTypeFromJson(Map<String, dynamic> json) {
  return ActivityType(
    json['name'] as String,
    _$enumDecodeNullable(_$TypeKindEnumMap, json['kind']),
    numericType:
        _numericTypeFromJson(json['numericType'] as Map<String, dynamic>),
    enumType: _enumTypeFromJson(json['enumType'] as Map<String, dynamic>),
    rangeType: _rangeTypeFromJson(json['rangeType'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ActivityTypeToJson(ActivityType instance) =>
    <String, dynamic>{
      'name': instance.name,
      'kind': _$TypeKindEnumMap[instance.kind],
      'numericType': _numericTypeToJson(instance.numericType),
      'enumType': _enumTypeToJson(instance.enumType),
      'rangeType': _rangeTypeToJson(instance.rangeType),
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

const _$TypeKindEnumMap = {
  TypeKind.numeric: 'numeric',
  TypeKind.enumeration: 'enumeration',
  TypeKind.range: 'range',
};

NumericType _$NumericTypeFromJson(Map<String, dynamic> json) {
  return NumericType(
    json['unit'] as String,
  );
}

Map<String, dynamic> _$NumericTypeToJson(NumericType instance) =>
    <String, dynamic>{
      'unit': instance.unit,
    };

EnumType _$EnumTypeFromJson(Map<String, dynamic> json) {
  return EnumType(
    (json['values'] as List)
        ?.map((e) => e == null
            ? null
            : EnumTypeValue.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$EnumTypeToJson(EnumType instance) => <String, dynamic>{
      'values': instance.values,
    };

EnumTypeValue _$EnumTypeValueFromJson(Map<String, dynamic> json) {
  return EnumTypeValue(
    json['weight'] as int,
    json['name'] as String,
  );
}

Map<String, dynamic> _$EnumTypeValueToJson(EnumTypeValue instance) =>
    <String, dynamic>{
      'weight': instance.weight,
      'name': instance.name,
    };

RangeType _$RangeTypeFromJson(Map<String, dynamic> json) {
  return RangeType(
    (json['min'] as num)?.toDouble(),
    (json['max'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$RangeTypeToJson(RangeType instance) => <String, dynamic>{
      'min': instance.min,
      'max': instance.max,
    };
