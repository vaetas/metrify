import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:metrify/models/entry.dart';
import 'package:metrify/models/group.dart';
import 'package:metrify/utils/grouping.dart';

Units _unitFromGrouping(EntryGrouping grouping) {
  switch (grouping) {
    case EntryGrouping.hour:
      return Units.HOUR;
    case EntryGrouping.day:
      return Units.DAY;
    case EntryGrouping.week:
      return Units.WEEK;
    case EntryGrouping.month:
      return Units.MONTH;
    case EntryGrouping.year:
      return Units.YEAR;
    case EntryGrouping.none:
    default:
      return Units.MILLISECOND;
  }
}

const Map<int, String> _weekdays = {
  1: 'Mon',
  2: 'Tue',
  3: 'Wed',
  4: 'Thu',
  5: 'Fri',
  6: 'Sat',
  7: 'Sun',
};

class TimeSpot {
  final FlSpot value;
  final String label;

  TimeSpot(this.value, this.label);
}

class TimeSeriesChart extends StatelessWidget {
  final List<Entry> entries;
  final EntryGrouping grouping;
  final int page;

  TimeSeriesChart({
    Key key,
    this.entries,
    this.grouping = EntryGrouping.day,
    this.page = 0,
  }) : super(key: key);

  List<FlSpot> get data => [];

  @override
  Widget build(BuildContext context) {
    final numDisplay = 7;

    final now = DateTime.now().getWithResolution(grouping);

    final startDate = now.subtract(Duration(days: 6));

//    final startDate = now.subtract(days: numDisplay);

    final groups = groupEntries(entries, grouping);

    print(groups);

//    print(now);
//    print(startDate);
//
//    print(Jiffy(DateTime.now().subtract(Duration(days: 7))).startOf(Units.DAY));

    final d = <int, TimeSpot>{};

    for (int x = 1; x <= numDisplay; x++) {
      final date = startDate.add(Duration(days: x));
      final g = groups[date];

      d[x] = TimeSpot(
        g != null ? FlSpot(x.toDouble(), g.average) : null,
        _weekdays[date.weekday],
      );
    }

    print(startDate.weekday);

    return Container(
      child: LineChart(
        LineChartData(
          minX: 1,
          maxX: numDisplay.toDouble() - 1,
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(
              showTitles: true,
              reservedSize: 20,
              textStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              getTitles: (x) {
                print(x);
                return d[x]?.label;
              },
            ),
            leftTitles: SideTitles(
              showTitles: false,
              getTitles: (y) {
                if (y % 10 == 0) {
                  return y.toString();
                }

                return '';
              },
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: d.values
                  .where((v) => v.value != null)
                  .map((v) => v.value)
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
