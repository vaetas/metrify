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

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:metrify/models/category.dart';
import 'package:metrify/models/entry.dart';
import 'package:metrify/models/group.dart';
import 'package:metrify/models/type.dart';

part 'activity.g.dart';

const String activityBox = 'activities';

List<Map<String, dynamic>> _entriesToJson(List<Entry> entries) => entries.map((e) => e.toJson()).toList();

List<Entry> _entriesFromJson(List<Map<String, dynamic>> json) => json.map((e) => Entry.fromJson(e)).toList();

Map<String, dynamic> _typeToJson(ActivityType type) => type.toJson();

ActivityType _typeFromJson(Map<String, dynamic> json) => ActivityType.fromJson(json);

@JsonSerializable()
@HiveType(typeId: 10)
class Activity extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<Category> categories;

  @JsonKey(toJson: _entriesToJson, fromJson: _entriesFromJson)
  @HiveField(2)
  List<Entry> entries;

  @JsonKey(toJson: _typeToJson, fromJson: _typeFromJson)
  @HiveField(3)
  ActivityType type;

  @JsonKey(name: 'color')
  @HiveField(4)
  int _color;

  @HiveField(5)
  EntryGrouping grouping;

  @JsonKey(ignore: true)
  Color get color => _color != null ? Color(_color) : null;

  set color(Color color) => _color = color?.value;

  Activity(
    this.name,
    this.categories,
    this.type,
    this.entries, {
    Color color,
    this.grouping = EntryGrouping.minute,
  }) {
    _color = color?.value;
  }

  factory Activity.fromJson(Map<String, dynamic> json) => _$ActivityFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityToJson(this);

  @override
  String toString() {
    return 'Activity{name: $name, categories: $categories, entries: $entries, type: $type, _color: $_color}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Activity &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          categories == other.categories &&
          entries == other.entries &&
          type == other.type &&
          _color == other._color;

  @override
  int get hashCode => name.hashCode ^ categories.hashCode ^ entries.hashCode ^ type.hashCode ^ _color.hashCode;
}
