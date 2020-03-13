import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:metrify/models/category.dart';
import 'package:metrify/models/entry.dart';
import 'package:metrify/models/group.dart';
import 'package:metrify/models/type.dart';

part 'activity.g.dart';

const String activityBox = 'activities';

@HiveType(typeId: 10)
class Activity extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<Category> categories;

  @HiveField(2)
  List<Entry> entries;

  @HiveField(3)
  ActivityType type;

  @HiveField(4)
  int _color;

  @HiveField(5)
  EntryGrouping grouping;

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
