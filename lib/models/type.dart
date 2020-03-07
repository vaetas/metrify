import 'package:hive/hive.dart';

part 'type.g.dart';

const String typeBox = 'types';

@HiveType(typeId: 23)
enum TypeKind {
  @HiveField(0)
  numeric,

  @HiveField(1)
  enumeration,

  @HiveField(2)
  range,
}

Map<TypeKind, String> typeKindName = {
  TypeKind.numeric: 'Numeric',
  TypeKind.enumeration: 'Enumeration',
  TypeKind.range: 'Range',
};

@HiveType(typeId: 24)
class ActivityType extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  TypeKind kind;

  @HiveField(2)
  NumericType numericType;

  @HiveField(3)
  EnumType enumType;

  @HiveField(4)
  RangeType rangeType;

  ActivityType(
    this.name,
    this.kind, {
    this.numericType,
    this.enumType,
    this.rangeType,
  });

  @override
  String toString() {
    return 'ActivityType{name: $name, kind: $kind, ${numericType ?? (enumType ?? rangeType)}}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityType &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          kind == other.kind &&
          numericType == other.numericType &&
          enumType == other.enumType &&
          rangeType == other.rangeType;

  @override
  int get hashCode => name.hashCode ^ kind.hashCode ^ numericType.hashCode ^ enumType.hashCode ^ rangeType.hashCode;
}

@HiveType(typeId: 25)
class NumericType extends HiveObject {
  @HiveField(0)
  String unit;

  NumericType(this.unit);

  @override
  String toString() => 'NumericType{unit: $unit}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is NumericType && runtimeType == other.runtimeType && unit == other.unit;

  @override
  int get hashCode => unit.hashCode;
}

@HiveType(typeId: 26)
class EnumType extends HiveObject {
  @HiveField(0)
  List<EnumTypeValue> values;

  EnumType(this.values);

  @override
  String toString() => 'EnumType{values: $values}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is EnumType && runtimeType == other.runtimeType && values == other.values;

  @override
  int get hashCode => values.hashCode;
}

@HiveType(typeId: 27)
class EnumTypeValue extends HiveObject {
  @HiveField(0)
  int weight;

  @HiveField(1)
  String name;

  EnumTypeValue(this.weight, this.name);

  @override
  String toString() => 'EnumTypeValue{weight: $weight, name: $name}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnumTypeValue && runtimeType == other.runtimeType && weight == other.weight && name == other.name;

  @override
  int get hashCode => weight.hashCode ^ name.hashCode;
}

@HiveType(typeId: 28)
class RangeType extends HiveObject {
  @HiveField(0)
  double min;

  @HiveField(1)
  double max;

  RangeType(this.min, this.max);

  @override
  String toString() => 'RangeType{start: $min, end: $max}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RangeType && runtimeType == other.runtimeType && min == other.min && max == other.max;

  @override
  int get hashCode => min.hashCode ^ max.hashCode;
}
