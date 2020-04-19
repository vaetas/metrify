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

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:metrify/models/activity.dart';
import 'package:metrify/models/entry.dart';
import 'package:metrify/models/group.dart';
import 'package:metrify/resources/theme.dart';
import 'package:metrify/ui/entry/add_entry_screen.dart';
import 'package:metrify/utils/grouping.dart';
import 'package:supercharged/supercharged.dart';

enum ActivityMenuItem {
  group,
}

Map<ActivityMenuItem, String> _activityMenuItems = {
  ActivityMenuItem.group: 'Group',
};

Future _deleteEntry(Entry entry, Activity activity) async {
  activity.entries.remove(entry);
  activity.save();

  if (entry.isInBox) {
    entry.delete();
  }
}

class ActivityScreen extends StatefulWidget {
  final Activity activity;

  ActivityScreen({Key key, this.activity}) : super(key: key);

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  EntryGrouping _grouping;

  final _activityBox = Hive.box<Activity>(activityBox);

  @override
  void initState() {
    super.initState();
    _grouping = widget.activity.grouping ?? EntryGrouping.none;
  }

  void _showGroupingModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: ListView(
            shrinkWrap: true,
            children: EntryGrouping.values.map((g) {
              return ListTile(
                title: Text(entryGroupingName[g]),
                onTap: () {
                  setState(() {
                    _grouping = g;
                  });
                  widget.activity.grouping = g;
                  Navigator.pop(context);
                },
                selected: g == _grouping,
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildList(
    EntryGrouping grouping,
    Activity activity,
  ) {
    final sortedEntries = activity.entries
        .sortedBy((a, b) => a.timestamp.compareTo(b.timestamp))
        .reversed
        .toList();

    if (grouping == EntryGrouping.none) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return _EntryItem(
              onDelete: () => _deleteEntry(sortedEntries[index], activity),
              entry: sortedEntries[index],
              activity: activity,
            );
          },
          childCount: sortedEntries.length,
        ),
      );
    }

    final entryGroups = groupEntries(sortedEntries, grouping);

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final date = activity.entries.last.timestamp
              .getWithResolution(grouping)
              .getPreviousGroup(grouping, n: index);
          return _EntryGroupItem(
            activity: activity,
            groupedEntry: entryGroups[date] ??
                GroupedEntry(
                  timestamp: date,
                  entries: [],
                  type: grouping,
                ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Activity>>(
      valueListenable: _activityBox.listenable(keys: [widget.activity.key]),
      builder: (context, value, child) {
        final activity = value.get(widget.activity.key);

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            heroTag: 'AddEntryFab',
            backgroundColor: AppTheme.black,
            foregroundColor: Theme.of(context).scaffoldBackgroundColor,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AddEntryScreen(
                  activity: widget.activity,
                );
              }));
            },
          ),
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                title: Text(activity.name),
                pinned: true,
                actions: <Widget>[
                  PopupMenuButton(
                    color: Theme.of(context).dialogBackgroundColor,
                    itemBuilder: (context) => ActivityMenuItem.values.map((a) {
                      return PopupMenuItem(
                        value: a,
                        child: Text(_activityMenuItems[a]),
                      );
                    }).toList(),
                    onSelected: (ActivityMenuItem item) {
                      switch (item) {
                        case ActivityMenuItem.group:
                          _showGroupingModal();
                          break;
                      }
                    },
                  )
                ],
              ),
              activity.entries.isNotEmpty
                  ? _buildList(_grouping, activity)
                  : SliverFillRemaining(child: Center(child: Text('No data'))),
            ],
          ),
        );
      },
    );
  }
}

class _EntryItem extends StatelessWidget {
  final Entry entry;
  final Activity activity;
  final VoidCallback onDelete;

  _EntryItem({Key key, this.entry, this.activity, this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableScrollActionPane(),
      actionExtentRatio: 0.15,
      actions: <Widget>[
        IconSlideAction(
          onTap: onDelete,
          iconWidget: Icon(
            FeatherIcons.trash2,
            color: Colors.red,
          ),
        ),
      ],
      child: Container(
        child: ListTile(
          title: Text(entry.format(activity.type)),
          subtitle: Text(
            entry.timestamp.toIso8601String(),
            style: Theme.of(context).textTheme.caption,
          ),
        ),
      ),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  final GroupedEntry groupedEntry;

  _GroupHeader({Key key, this.groupedEntry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      width: double.infinity,
      child: Text(
        formatGroupDate(groupedEntry.timestamp, groupedEntry.type),
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).textTheme.body1.color.withOpacity(0.3),
        ),
      ),
    );
  }
}

class _EntryGroupItem extends StatelessWidget {
  final GroupedEntry groupedEntry;
  final Activity activity;

  _EntryGroupItem({
    Key key,
    this.groupedEntry,
    this.activity,
  }) : super(key: key);

  bool get empty => groupedEntry == null;

  bool get notEmpty => !empty;

  @override
  Widget build(BuildContext context) {
    final children = groupedEntry.entries.map((entry) {
      return _EntryItem(
        activity: activity,
        entry: entry,
        onDelete: () => _deleteEntry(entry, activity),
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _GroupHeader(groupedEntry: groupedEntry),
        if (notEmpty) Column(children: children)
      ],
    );
  }
}
