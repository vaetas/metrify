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

import 'dart:math';

import 'package:hive/hive.dart';
import 'package:metrify/models/activity.dart';
import 'package:metrify/models/entry.dart';
import 'package:metrify/models/type.dart';

/// Populate [activity] with dummy entries for testing. Values will be random, based
/// on [activity] type.
void generateDummyData(Activity activity, int count, {numericMaxValue = 10}) async {
  final box = Hive.box<Entry>(entryBox);
  final random = Random();

  int maxValue;

  switch (activity.type.kind) {
    case TypeKind.numeric:
      maxValue = numericMaxValue;
      break;
    case TypeKind.enumeration:
      maxValue = activity.type.enumType.values.length - 1;
      break;
    case TypeKind.range:
      maxValue = activity.type.rangeType.max.toInt();
      break;
  }

  var date = DateTime.now();

  for (var x = 0; x < count; x++) {
    final nextValue = random.nextInt(maxValue);

    final entry = Entry(date, nextValue.toDouble());
    await box.add(entry);

    activity.entries.add(entry);
    date = date.subtract(Duration(days: 1));
  }

  activity.save();
}

Future createBasicTypes() async {
  final numericType = ActivityType(
    'Kilometers',
    TypeKind.numeric,
    numericType: NumericType('km'),
  );

  final enumerationType = ActivityType(
    'Boolean',
    TypeKind.enumeration,
    enumType: EnumType(
      [
        EnumTypeValue(0, 'False'),
        EnumTypeValue(1, 'True'),
      ],
    ),
  );

  final box = Hive.box<ActivityType>(typeBox);

  await box.add(numericType);
  await box.add(enumerationType);
}
