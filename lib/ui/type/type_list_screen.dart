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
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:metrify/models/type.dart';
import 'package:metrify/ui/type/create_enum_type_screen.dart';
import 'package:metrify/ui/type/create_numeric_type_screen.dart';
import 'package:metrify/ui/type/create_range_type_screen.dart';

class TypeListScreen extends StatefulWidget {
  static const routeName = '/type/list';

  @override
  _TypeListScreenState createState() => _TypeListScreenState();
}

class _TypeListScreenState extends State<TypeListScreen> {
  Box<ActivityType> box;

  @override
  void initState() {
    super.initState();
    box = Hive.box<ActivityType>(typeBox);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        overlayColor: Theme.of(context).scaffoldBackgroundColor,
        tooltip: 'Create new type',
        children: [
          SpeedDialChild(
            child: Icon(Icons.add),
            label: 'Number',
            labelWidget: SpeedDialLabel(label: 'Number'),
            backgroundColor: Theme.of(context).primaryColor,
            onTap: () {
              Navigator.pushNamed(context, CreateNumericTypeScreen.routeName);
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.add),
            label: 'Enumeration',
            labelWidget: SpeedDialLabel(label: 'Enumeration'),
            backgroundColor: Theme.of(context).primaryColor,
            onTap: () {
              Navigator.pushNamed(context, CreateEnumTypeScreen.routeName);
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.add),
            label: 'Range',
            labelWidget: SpeedDialLabel(label: 'Range'),
            backgroundColor: Theme.of(context).primaryColor,
            onTap: () {
              Navigator.pushNamed(context, CreateRangeTypeScreen.routeName);
            },
          ),
        ],
      ),
      body: ValueListenableBuilder<Box<ActivityType>>(
        valueListenable: box.listenable(),
        builder: (BuildContext context, Box<ActivityType> value, Widget _) {
          return CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(title: Text('Types')),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Slidable(
                      actionPane: SlidableScrollActionPane(),
                      actionExtentRatio: 0.2,
                      actions: <Widget>[
                        IconSlideAction(
                          icon: FeatherIcons.trash2,
                          color: Colors.red,
                          onTap: () {
                            value.deleteAt(index);
                          },
                        ),
                      ],
                      child: Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: ListTile(
                          title: Text(value.getAt(index).name),
                          subtitle: Text(typeKindName[value.getAt(index).kind]),
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

class SpeedDialLabel extends StatelessWidget {
  final String label;

  SpeedDialLabel({Key key, this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(label),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
