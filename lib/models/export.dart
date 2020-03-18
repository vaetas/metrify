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

import 'package:json_annotation/json_annotation.dart';
import 'package:metrify/models/activity.dart';

part 'export.g.dart';

@JsonSerializable()
class ExportData {
  @JsonKey(toJson: _timestampTimeToJson, fromJson: _timestampTimeFromJson)
  DateTime timestamp;

  @JsonKey()
  String appVersion;

  @JsonKey(toJson: _activitiesToMap, fromJson: _activitiesFromJson)
  List<Activity> activities;

  ExportData(this.timestamp, this.appVersion, {this.activities});

  factory ExportData.fromJson(Map<String, dynamic> json) => _$ExportDataFromJson(json);

  Map<String, dynamic> toJson() => _$ExportDataToJson(this);

  static int _timestampTimeToJson(DateTime dateTime) => dateTime.millisecondsSinceEpoch;

  static DateTime _timestampTimeFromJson(int unixTime) => DateTime.fromMillisecondsSinceEpoch(unixTime);

  static List<Map<String, dynamic>> _activitiesToMap(List<Activity> activities) =>
      activities.map((a) => a.toJson()).toList();

  static List<Activity> _activitiesFromJson(List<Map<String, dynamic>> activities) =>
      activities.map((a) => Activity.fromJson(a)).toList();

  @override
  String toString() {
    return 'ExportData{timestamp: $timestamp, appVersion: $appVersion, activities: $activities}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExportData &&
          runtimeType == other.runtimeType &&
          timestamp == other.timestamp &&
          appVersion == other.appVersion &&
          activities == other.activities;

  @override
  int get hashCode => timestamp.hashCode ^ appVersion.hashCode ^ activities.hashCode;
}
