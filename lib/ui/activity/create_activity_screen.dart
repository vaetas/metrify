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
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:metrify/models/activity.dart';
import 'package:metrify/models/category.dart';
import 'package:metrify/models/entry.dart';
import 'package:metrify/models/type.dart';
import 'package:metrify/ui/widgets/appbar_submit_button.dart';
import 'package:metrify/ui/widgets/color_picker.dart';
import 'package:metrify/ui/widgets/dropdown_button.dart';

class CreateActivityScreen extends StatefulWidget {
  @override
  _CreateActivityScreenState createState() => _CreateActivityScreenState();
}

class _CreateActivityScreenState extends State<CreateActivityScreen> {
  ActivityType _selectedType;
  String _name;
  Color _color;

  Box<Activity> _activityBox;
  Box<ActivityType> _typeBox;
  Box<Category> _categoryBox;
  Box<Entry> _entryBox;

  final _nameController = TextEditingController();
  final _categoryList = List<Category>();

  @override
  void initState() {
    super.initState();

    _activityBox = Hive.box<Activity>(activityBox);
    _typeBox = Hive.box<ActivityType>(typeBox);
    _categoryBox = Hive.box<Category>(categoryBox);
    _entryBox = Hive.box<Entry>(entryBox);

    _nameController.addListener(() {
      setState(() {
        _name = _nameController.text;
      });
    });
  }

  Future _submit() async {
    final activity = Activity(
      _name.trim(),
      HiveList(_categoryBox),
      _selectedType,
      HiveList(_entryBox),
      color: _color,
    );

    if (_categoryList.length > 0) {
      activity.categories.addAll(_categoryList);
    }

    _activityBox.add(activity);
    Navigator.pop(context);
  }

  bool _canSubmit() => _selectedType != null && _name != null && _name.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create activity'),
        actions: <Widget>[
          AppBarSubmitButton(onPressed: _canSubmit() ? _submit : null),
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
              autocorrect: true,
              textCapitalization: TextCapitalization.words,
            ),
            ValueListenableBuilder<Box<ActivityType>>(
              valueListenable: _typeBox.listenable(),
              builder: (BuildContext context, Box<ActivityType> value, Widget child) {
                return Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: AppDropdownButton<ActivityType>(
                    items: value.values.toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value;
                      });
                    },
                    value: _selectedType,
                    hint: Text('Select type'),
                    itemNameFn: (activity) => activity.name,
                  ),
                );
              },
            ),
            ColorPicker(
              selected: _color,
              onSelect: (color) {
                if (color == _color) {
                  setState(() {
                    _color = null;
                  });
                } else {
                  setState(() {
                    _color = color;
                  });
                }
              },
            ),
            ValueListenableBuilder<Box<Category>>(
              valueListenable: _categoryBox.listenable(),
              builder: (context, value, _) {
                return Wrap(
                  spacing: 5,
                  children: value.values.map((c) {
                    return FilterChip(
                      selected: _categoryList.contains(c),
                      onSelected: (bool v) {
                        if (v) {
                          setState(() {
                            _categoryList.add(c);
                          });
                        } else {
                          setState(() {
                            _categoryList.remove(c);
                          });
                        }
                      },
                      label: Text(c.name),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
