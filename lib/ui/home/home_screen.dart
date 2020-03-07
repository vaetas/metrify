import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:metrify/models/activity.dart';
import 'package:metrify/resources/routes.dart';
import 'package:metrify/ui/activity/activity_screen.dart';
import 'package:metrify/ui/entry/add_entry_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AddEntryScreen();
              },
              fullscreenDialog: true,
            ),
          );
        },
        label: Text('New entry'),
        icon: Icon(Icons.add),
        heroTag: 'AddEntryFab',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: ValueListenableBuilder<Box<Activity>>(
        valueListenable: Hive.box<Activity>(activityBox).listenable(),
        builder: (BuildContext context, Box<Activity> value, Widget _) {
          final activities = value.values.toList();

          return CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                title: Text('Metrify'),
                pinned: true,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(FeatherIcons.settings),
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.settings);
                    },
                  )
                ],
              ),
              activities.length > 0
                  ? SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final activity = activities[index];

                          return ActivityCard(
                            activity: activity,
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return ActivityScreen(activity: activity);
                                },
                              ));
                            },
                          );
                        },
                        childCount: activities.length,
                      ),
                    )
                  : SliverFillRemaining(
                      child: Center(
                        child: FlatButton.icon(
                          icon: Icon(
                            Icons.add,
                            size: 18,
                          ),
                          label: Text('Create first activity'),
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.activityCreate);
                          },
                        ),
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final Activity activity;
  final VoidCallback onPressed;

  ActivityCard({Key key, this.activity, this.onPressed}) : super(key: key);

  final _borderRadius = BorderRadius.circular(5);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: _borderRadius,
        child: InkWell(
          splashColor: activity.color,
          borderRadius: _borderRadius,
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.all(20),
            height: 125,
            child: Stack(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Text(
                        activity.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Text(
                      '${activity.entries.length} entries',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.body1.color.withOpacity(0.5),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
