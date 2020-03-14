/*
 * Metrify: Track Your Metrics
 * Copyright (C) 2020  Vojtech Pavlovsky
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

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

Map<String, dynamic> _numericTypeToJson(NumericType type) => type?.toJson();

Map<String, dynamic> _enumTypeToJson(EnumType type) => type?.toJson();

Map<String, dynamic> _rangeTypeToJson(RangeType type) => type?.toJson();

NumericType _numericTypeFromJson(Map<String, dynamic> json) => NumericType.fromJson(json);

EnumType _enumTypeFromJson(Map<String, dynamic> json) => EnumType.fromJson(json);

RangeType _rangeTypeFromJson(Map<String, dynamic> json) => RangeType.fromJson(json);

@JsonSerializable()
@HiveType(typeId: 24)
class ActivityType extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  TypeKind kind;

  @JsonKey(toJson: _numericTypeToJson, fromJson: _numericTypeFromJson)
  @HiveField(2)
  NumericType numericType;

  @JsonKey(toJson: _enumTypeToJson, fromJson: _enumTypeFromJson)
  @HiveField(3)
  EnumType enumType;

  @JsonKey(toJson: _rangeTypeToJson, fromJson: _rangeTypeFromJson)
  @HiveField(4)
  RangeType rangeType;

  ActivityType(
    this.name,
    this.kind, {
    this.numericType,
    this.enumType,
    this.rangeType,
  });

  factory ActivityType.fromJson(Map<String, dynamic> json) => _$ActivityTypeFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityTypeToJson(this);

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

@JsonSerializable()
@HiveType(typeId: 25)
class NumericType extends HiveObject {
  @HiveField(0)
  String unit;

  NumericType(this.unit);

  factory NumericType.fromJson(Map<String, dynamic> json) => _$NumericTypeFromJson(json);

  Map<String, dynamic> toJson() => _$NumericTypeToJson(this);

  @override
  String toString() => 'NumericType{unit: $unit}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is NumericType && runtimeType == other.runtimeType && unit == other.unit;

  @override
  int get hashCode => unit.hashCode;
}

@JsonSerializable()
@HiveType(typeId: 26)
class EnumType extends HiveObject {
  @HiveField(0)
  List<EnumTypeValue> values;

  EnumType(this.values);

  factory EnumType.fromJson(Map<String, dynamic> json) => _$EnumTypeFromJson(json);

  Map<String, dynamic> toJson() => _$EnumTypeToJson(this);

  @override
  String toString() => 'EnumType{values: $values}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is EnumType && runtimeType == other.runtimeType && values == other.values;

  @override
  int get hashCode => values.hashCode;
}

@JsonSerializable()
@HiveType(typeId: 27)
class EnumTypeValue extends HiveObject {
  @HiveField(0)
  int weight;

  @HiveField(1)
  String name;

  EnumTypeValue(this.weight, this.name);

  factory EnumTypeValue.fromJson(Map<String, dynamic> json) => _$EnumTypeValueFromJson(json);

  Map<String, dynamic> toJson() => _$EnumTypeValueToJson(this);

  @override
  String toString() => 'EnumTypeValue{weight: $weight, name: $name}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnumTypeValue && runtimeType == other.runtimeType && weight == other.weight && name == other.name;

  @override
  int get hashCode => weight.hashCode ^ name.hashCode;
}

@JsonSerializable()
@HiveType(typeId: 28)
class RangeType extends HiveObject {
  @HiveField(0)
  double min;

  @HiveField(1)
  double max;

  RangeType(this.min, this.max);

  factory RangeType.fromJson(Map<String, dynamic> json) => _$RangeTypeFromJson(json);

  Map<String, dynamic> toJson() => _$RangeTypeToJson(this);

  @override
  String toString() => 'RangeType{start: $min, end: $max}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RangeType && runtimeType == other.runtimeType && min == other.min && max == other.max;

  @override
  int get hashCode => min.hashCode ^ max.hashCode;
}
