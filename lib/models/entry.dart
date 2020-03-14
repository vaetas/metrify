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
import 'package:metrify/models/group.dart';
import 'package:metrify/models/type.dart';

part 'entry.g.dart';

const String entryBox = 'entries';

int _dateTimeToJson(DateTime dateTime) => dateTime.millisecondsSinceEpoch;

DateTime _dateTimeFromJson(int unixTime) => DateTime.fromMillisecondsSinceEpoch(unixTime);

@JsonSerializable()
@HiveType(typeId: 12)
class Entry extends HiveObject {
  @JsonKey(toJson: _dateTimeToJson, fromJson: _dateTimeFromJson)
  @HiveField(0)
  DateTime timestamp;

  @HiveField(1)
  double value;

  Entry(this.timestamp, this.value);

  factory Entry.fromJson(Map<String, dynamic> json) => _$EntryFromJson(json);

  Map<String, dynamic> toJson() => _$EntryToJson(this);

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

class GroupedEntry {
  final DateTime timestamp;

  final EntryGrouping type;

  final List<Entry> entries;

  GroupedEntry({this.timestamp, this.type, this.entries});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupedEntry &&
          runtimeType == other.runtimeType &&
          timestamp == other.timestamp &&
          type == other.type &&
          entries == other.entries;

  @override
  int get hashCode => timestamp.hashCode ^ type.hashCode ^ entries.hashCode;

  @override
  String toString() => 'GroupedEntry{timestamp: $timestamp, type: $type, entries: $entries}';
}
