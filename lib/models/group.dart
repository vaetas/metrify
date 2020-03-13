import 'package:hive/hive.dart';

part 'group.g.dart';

@HiveType(typeId: 30)
enum EntryGrouping {
  @HiveField(0)
  minute,

  @HiveField(1)
  hour,

  @HiveField(2)
  day,

  @HiveField(3)
  week,

  @HiveField(4)
  month,

  @HiveField(5)
  year,
}

const Map<EntryGrouping, String> entryGroupingName = {
  EntryGrouping.minute: 'Minute',
  EntryGrouping.hour: 'Hour',
  EntryGrouping.day: 'Day',
  EntryGrouping.week: 'Week',
  EntryGrouping.month: 'Month',
  EntryGrouping.year: 'Year',
};
