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
