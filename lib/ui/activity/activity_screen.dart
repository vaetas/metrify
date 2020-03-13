import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:metrify/models/activity.dart';
import 'package:metrify/models/entry.dart';
import 'package:metrify/models/group.dart';
import 'package:metrify/ui/entry/add_entry_screen.dart';
import 'package:metrify/utils/grouping.dart';
import 'package:supercharged/supercharged.dart';

enum ActivityMenuItem {
  group,
}

Map<ActivityMenuItem, String> _activityMenuItems = {
  ActivityMenuItem.group: 'Group',
};

class ActivityScreen extends StatefulWidget {
  final Activity activity;

  ActivityScreen({Key key, this.activity}) : super(key: key);

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  EntryGrouping _grouping;

  final Box<Activity> _box = Hive.box<Activity>(activityBox);

  @override
  void initState() {
    super.initState();
    _grouping = widget.activity.grouping;
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

  @override
  Widget build(BuildContext context) {
    groupEntries(widget.activity.entries, _grouping);

    return ValueListenableBuilder<Box<Activity>>(
      valueListenable: _box.listenable(keys: [widget.activity.key]),
      builder: (context, value, child) {
        final activity = value.get(widget.activity.key);

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            heroTag: 'AddEntryFab',
            backgroundColor: widget.activity.color,
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
                    color: Theme.of(context).scaffoldBackgroundColor,
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
              ...groupEntries(activity.entries, _grouping)
                  .sortedBy((a, b) => a.timestamp.compareTo(b.timestamp))
                  .reversed
                  .map((group) {
                return SliverStickyHeader(
                  header: _GroupHeader(title: formatGroupDate(group.timestamp, group.type)),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final entry = group.entries
                            .sortedBy((a, b) => a.timestamp.compareTo(b.timestamp))
                            .reversed
                            .elementAt(index);
                        return _EntryItem(
                          entry: entry,
                          activity: activity,
                          onDelete: () async {
                            activity.entries.removeAt(index);
                            if (entry.isInBox) {
                              await entry.delete();
                            }

                            await activity.save();
                          },
                        );
                      },
                      childCount: group.entries.length,
                    ),
                  ),
                );
              }).toList(),
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

  _EntryItem({Key key, this.entry, this.activity, this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableScrollActionPane(),
      actionExtentRatio: 0.15,
      actions: <Widget>[
        IconSlideAction(
          icon: FeatherIcons.trash2,
          color: Colors.red,
          onTap: onDelete,
        ),
      ],
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListTile(
          title: Text(entry.format(activity.type)),
        ),
      ),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  final String title;

  _GroupHeader({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Theme.of(context).cardColor,
          ),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
