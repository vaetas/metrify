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
import 'package:metrify/models/type.dart';
import 'package:metrify/ui/widgets/appbar_submit_button.dart';
import 'package:toast/toast.dart';

class CreateEnumTypeScreen extends StatefulWidget {
  @override
  _CreateEnumTypeScreenState createState() => _CreateEnumTypeScreenState();
}

class _CreateEnumTypeScreenState extends State<CreateEnumTypeScreen> {
  Box<ActivityType> box;

  String _name;
  final _enumValues = List<String>();

  @override
  void initState() {
    super.initState();
    box = Hive.box<ActivityType>(typeBox);

    _typeNameController.addListener(() {
      setState(() {
        _name = _typeNameController.text;
      });
    });
  }

  final _typeNameController = TextEditingController();
  final _addValueController = TextEditingController();

  void _swap(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex--;
    }

    String tmp = _enumValues[newIndex];

    setState(() {
      _enumValues[newIndex] = _enumValues[oldIndex];
      _enumValues[oldIndex] = tmp;
    });
  }

  void _submit() async {
    final name = _name;

    final type = ActivityType(
      name,
      TypeKind.enumeration,
      enumType: EnumType(
        List.generate(_enumValues.length, (index) => EnumTypeValue(index, _enumValues[index])),
      ),
    );
    box.add(type);

    Navigator.pop(context);
  }

  bool _canSubmit() =>
      _enumValues.isNotEmpty && _typeNameController.text != null && _typeNameController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enumeration Type'),
        actions: <Widget>[
          AppBarSubmitButton(
            onPressed: _canSubmit() ? _submit : null,
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 15,
                top: 5,
              ),
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                controller: _typeNameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
            ),
            Expanded(
              child: Container(
                child: ReorderableListView(
                  children: List.generate(
                    _enumValues.length,
                    (index) => EnumItem(
                      index: index,
                      key: ValueKey(index),
                      name: _enumValues[index],
                      onDelete: () {
                        setState(() {
                          _enumValues.removeAt(index);
                        });
                      },
                    ),
                  ),
                  onReorder: _swap,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: _addValueController,
                      onSubmitted: (value) {
                        setState(() {
                          _enumValues.add(value);
                          _addValueController.text = '';
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Value',
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                      ),
                      autofocus: _typeNameController.text.trim().isNotEmpty,
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.only(left: 15, right: 5),
                    icon: Icon(Icons.add_circle),
                    onPressed: () {
                      if (_addValueController.text.isEmpty) {
                        Toast.show(
                          'Value name cannot be empty',
                          context,
                          duration: Toast.LENGTH_LONG,
                        );
                      } else {
                        setState(() {
                          _enumValues.add(_addValueController.text);
                        });
                        _addValueController.text = '';
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _typeNameController.dispose();
    _addValueController.dispose();
    super.dispose();
  }
}

class EnumItem extends StatelessWidget {
  final String name;
  final int index;
  final VoidCallback onDelete;

  EnumItem({Key key, this.name, this.index, this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).highlightColor,
      ),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Text(index.toString()),
          ),
          Flexible(
            flex: 6,
            child: Container(
              child: Text(
                name,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              alignment: Alignment.centerLeft,
            ),
          ),
          Flexible(
            flex: 1,
            child: IconButton(
              icon: Icon(Icons.remove_circle),
              onPressed: onDelete,
            ),
          )
        ],
      ),
      width: double.infinity,
      key: key,
    );
  }
}
