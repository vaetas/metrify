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
import 'package:metrify/models/category.dart';
import 'package:metrify/resources/routes.dart';

class CategoryListScreen extends StatefulWidget {
  @override
  _CategoryListScreenState createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  Box<Category> box;

  @override
  void initState() {
    super.initState();
    box = Hive.box<Category>(categoryBox);
  }

  void _delete(Category category) {
    category.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, Routes.categoryCreate);
        },
      ),
      body: ValueListenableBuilder<Box<Category>>(
        valueListenable: box.listenable(),
        builder: (BuildContext context, Box<Category> value, Widget child) {
          return CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(title: Text('Categories')),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final category = value.getAt(index);
                    return Slidable(
                      actionPane: SlidableScrollActionPane(),
                      actionExtentRatio: 0.15,
                      actions: <Widget>[
                        IconSlideAction(
                          icon: FeatherIcons.trash2,
                          color: Colors.red,
                          onTap: () => _delete(category),
                        )
                      ],
                      child: ListTile(title: Text(category.name)),
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
