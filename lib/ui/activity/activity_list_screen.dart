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
import 'package:metrify/ui/activity/create_activity_screen.dart';

class ActivityListScreen extends StatefulWidget {
  @override
  _ActivityListScreenState createState() => _ActivityListScreenState();
}

class _ActivityListScreenState extends State<ActivityListScreen> {
  Box<Activity> box;

  @override
  void initState() {
    super.initState();
    box = Hive.box<Activity>(activityBox);
  }

  Future _delete(Activity activity) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete'),
          content: Text('Do you really want to delete activity ${activity.name}? This cannot be undone.'),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text(
                'Delete',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                activity
                  ..entries.forEach((e) {
                    if (e.isInBox) {
                      e.delete();
                    }
                  })
                  ..entries.clear()
                  ..delete();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return CreateActivityScreen();
              },
              fullscreenDialog: true,
            ),
          );
        },
      ),
      body: ValueListenableBuilder<Box<Activity>>(
        valueListenable: box.listenable(),
        builder: (BuildContext context, Box<Activity> value, Widget _) {
          return CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(title: Text('Activities')),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final activity = value.getAt(index);

                    return Slidable(
                      actionPane: SlidableScrollActionPane(),
                      actionExtentRatio: 0.2,
                      actions: <Widget>[
                        IconSlideAction(
                          color: Colors.red,
                          icon: FeatherIcons.trash2,
                          onTap: () => _delete(activity),
                        ),
                      ],
                      child: ListTile(
                        title: Text(activity.name),
                        subtitle: Text(activity.type.name),
                        trailing: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            color: activity.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: value.length,
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
