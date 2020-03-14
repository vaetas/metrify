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
import 'package:metrify/models/entry.dart';
import 'package:metrify/models/group.dart';

List<GroupedEntry> groupEntries(List<Entry> entries, EntryGrouping type) {
  Map<DateTime, GroupedEntry> groups = {};

  for (Entry entry in entries) {
    DateTime groupDate;
    DateTime timestamp = entry.timestamp;

    switch (type) {
      case EntryGrouping.hour:
        groupDate = DateTime(
          timestamp.year,
          timestamp.month,
          timestamp.day,
          timestamp.hour,
        );
        break;
      case EntryGrouping.day:
        groupDate = DateTime(
          timestamp.year,
          timestamp.month,
          timestamp.day,
        );
        break;
      case EntryGrouping.week:
        groupDate = _getLastMonday(timestamp);
        break;
      case EntryGrouping.month:
        groupDate = DateTime(timestamp.year, timestamp.month);
        break;
      case EntryGrouping.year:
        groupDate = DateTime(timestamp.year);
        break;
      case EntryGrouping.minute:
        groupDate = DateTime(
          timestamp.year,
          timestamp.month,
          timestamp.day,
          timestamp.hour,
          timestamp.minute,
        );
        break;
    }

    groups.putIfAbsent(groupDate, () => GroupedEntry(timestamp: groupDate, type: type, entries: []));
    groups[groupDate].entries.add(entry);
  }

  return groups.values.toList();
}

String formatGroupDate(DateTime timestamp, EntryGrouping type) {
  switch (type) {
    case EntryGrouping.hour:
      return DateFormat('HH:00, MMMM d').format(timestamp);
    case EntryGrouping.day:
      return DateFormat('MMMM d').format(timestamp);
    case EntryGrouping.week:
      final lastMonday = _getLastMonday(timestamp);
      final start = DateFormat('MMM d').format(lastMonday);
      final end = DateFormat('MMM d').format(lastMonday.add(Duration(days: 6)));
      return '$start — $end';
    case EntryGrouping.month:
      return DateFormat('MMMM').format(timestamp);
    case EntryGrouping.year:
      return DateFormat('y').format(timestamp);
    case EntryGrouping.minute:
      return DateFormat('HH:mm, MMMM d').format(timestamp);
  }
}

DateTime _getLastMonday(DateTime timestamp) {
  DateTime date = DateTime(timestamp.year, timestamp.month, timestamp.day).subtract(
    Duration(days: (DateTime.monday - timestamp.weekday).abs()),
  );

  return date;
}
