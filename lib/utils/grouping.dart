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

import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:metrify/models/entry.dart';
import 'package:metrify/models/group.dart';

extension DateUtil on DateTime {
  // TODO: For some locales sunday is start of the week.

  DateTime getWeekStart() {
    return DateTime(this.year, this.month, this.day).subtract(
      Duration(days: (DateTime.monday - this.weekday).abs()),
    );
  }

  DateTime getWeekEnd() => this.getWeekStart().add(Duration(days: 6));

  DateTime getWithResolution(EntryGrouping grouping) {
    switch (grouping) {
      case EntryGrouping.hour:
        return DateTime(
          this.year,
          this.month,
          this.day,
          this.hour,
        );
      case EntryGrouping.day:
        return DateTime(
          this.year,
          this.month,
          this.day,
        );
      case EntryGrouping.week:
        return this.getWeekStart();
      case EntryGrouping.month:
        return DateTime(
          this.year,
          this.month,
        );
      case EntryGrouping.year:
        return DateTime(this.year);
      default:
        return this;
    }
  }

  DateTime getPreviousGroup(EntryGrouping grouping, {int n = 1}) {
    final _this = Jiffy(this);

    switch (grouping) {
      case EntryGrouping.hour:
        return _this.subtract(hours: n);
      case EntryGrouping.day:
        return _this.subtract(days: n);
      case EntryGrouping.week:
        return _this.subtract(weeks: n);
      case EntryGrouping.month:
        return _this.subtract(months: n);
      case EntryGrouping.year:
        return _this.subtract(years: n);
      default:
        return this;
    }
  }
}

Map<DateTime, GroupedEntry> groupEntries(
  List<Entry> entries,
  EntryGrouping type,
) {
  Map<DateTime, GroupedEntry> groups = {};

  for (Entry entry in entries) {
    DateTime timestamp = entry.timestamp;
    DateTime groupDate = timestamp.getWithResolution(type);

    groups.putIfAbsent(
      groupDate,
      () => GroupedEntry(timestamp: groupDate, type: type, entries: []),
    );
    groups[groupDate].entries.add(entry);
  }

  return groups;
}

String formatGroupDate(DateTime timestamp, EntryGrouping type) {
  switch (type) {
    case EntryGrouping.hour:
      return DateFormat('HH:00, MMMM d').format(timestamp);
    case EntryGrouping.day:
      return DateFormat('MMMM d').format(timestamp);
    case EntryGrouping.week:
      final start = DateFormat('MMM d').format(timestamp.getWeekStart());
      final end = DateFormat('MMM d').format(timestamp.getWeekEnd());
      return '$start — $end';
    case EntryGrouping.month:
      return DateFormat('MMMM').format(timestamp);
    case EntryGrouping.year:
      return DateFormat('y').format(timestamp);
    case EntryGrouping.none:
    default:
      return timestamp.toIso8601String();
  }
}
