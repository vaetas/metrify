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

part 'group.g.dart';

@HiveType(typeId: 30)
enum EntryGrouping {
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

  @HiveField(6)
  none,
}

const Map<EntryGrouping, String> entryGroupingName = {
  EntryGrouping.none: 'None',
  EntryGrouping.hour: 'Hour',
  EntryGrouping.day: 'Day',
  EntryGrouping.week: 'Week',
  EntryGrouping.month: 'Month',
  EntryGrouping.year: 'Year',
};
