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
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:metrify/models/activity.dart';
import 'package:metrify/ui/activity/activity_screen.dart';
import 'package:metrify/ui/activity/create_activity_screen.dart';
import 'package:metrify/ui/entry/add_entry_screen.dart';
import 'package:metrify/ui/settings/settings_screen.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  final _activityBox = Hive.box<Activity>(activityBox);

  Widget _buildList(List<Activity> activities) {
    return SliverList(
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
    );
  }

  _buildCreateFirstActivity(BuildContext context) {
    return SliverFillRemaining(
      child: Center(
        child: FlatButton.icon(
          icon: Icon(
            Icons.add,
            size: 18,
          ),
          label: Text('Create first activity'),
          onPressed: () {
            Navigator.pushNamed(context, CreateActivityScreen.routeName);
          },
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          _activityBox.isNotEmpty ? _buildFloatingActionButton(context) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: ValueListenableBuilder<Box<Activity>>(
        valueListenable: _activityBox.listenable(),
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
                      Navigator.pushNamed(context, SettingsScreen.routeName);
                    },
                  )
                ],
              ),
              activities.isEmpty
                  ? _buildCreateFirstActivity(context)
                  : _buildList(activities)
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
        borderRadius: _borderRadius,
        color: Theme.of(context).cardColor,
        child: InkWell(
          splashColor: activity.color?.withOpacity(0.5),
          borderRadius: _borderRadius,
          onTap: onPressed,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    width: 8,
                    color: activity.color?.withOpacity(0.75) ??
                        Theme.of(context).cardColor,
                  ),
                ),
              ),
              height: 100,
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
                        '${activity.entries.length} ${activity.entries.length == 1 ? 'entry' : 'entries'}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context)
                              .textTheme
                              .body1
                              .color
                              .withOpacity(0.5),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
