import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:metrify/models/activity.dart';
import 'package:metrify/ui/entry/add_entry_screen.dart';

class ActivityScreen extends StatefulWidget {
  final Activity activity;

  ActivityScreen({Key key, this.activity}) : super(key: key);

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  Box<Activity> _box;

  final dateFormat = DateFormat('yyyy-MM-dd HH:mm');

  @override
  void initState() {
    super.initState();
    _box = Hive.box<Activity>(activityBox);
  }

  @override
  Widget build(BuildContext context) {
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
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final entry = activity.entries[index];

                    return Slidable(
                      actionPane: SlidableBehindActionPane(),
                      actionExtentRatio: 0.15,
                      actions: <Widget>[
                        IconSlideAction(
                          icon: FeatherIcons.trash2,
                          color: Colors.red,
                          onTap: () async {
                            // Behavior here is kind of sketchy. Might need to refactor this later.

                            activity.entries.removeAt(index);
                            if (entry.isInBox) {
                              await entry.delete();
                            }

                            await activity.save();
                          },
                        ),
                      ],
                      child: Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: ListTile(
                          title: Text(entry.format(activity.type)),
                          trailing: Text(
                            dateFormat.format(entry.timestamp),
                            style: TextStyle(
                              color: Theme.of(context).textTheme.body1.color.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: activity.entries.length,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
