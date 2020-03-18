// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExportData _$ExportDataFromJson(Map<String, dynamic> json) {
  return ExportData(
    ExportData._timestampTimeFromJson(json['timestamp'] as int),
    json['appVersion'] as String,
    activities: ExportData._activitiesFromJson(
        json['activities'] as List<Map<String, dynamic>>),
  );
}

Map<String, dynamic> _$ExportDataToJson(ExportData instance) =>
    <String, dynamic>{
      'timestamp': ExportData._timestampTimeToJson(instance.timestamp),
      'appVersion': instance.appVersion,
      'activities': ExportData._activitiesToMap(instance.activities),
    };
