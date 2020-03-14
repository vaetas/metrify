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
import 'package:metrify/models/entry.dart';
import 'package:metrify/models/type.dart';
import 'package:metrify/ui/widgets/appbar_submit_button.dart';
import 'package:metrify/ui/widgets/dropdown_button.dart';
import 'package:metrify/utils/parsing.dart';

class AddEntryScreen extends StatefulWidget {
  final Activity activity;

  AddEntryScreen({Key key, this.activity}) : super(key: key);

  @override
  _AddEntryScreenState createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  Activity selectedActivity;
  EnumTypeValue _selectedEnum;
  final numericValueController = TextEditingController();

  Box<Activity> _activityBox;
  Box<Entry> _entryBox;

  double sliderPosition;

  @override
  void initState() {
    super.initState();
    _activityBox = Hive.box<Activity>(activityBox);
    _entryBox = Hive.box<Entry>(entryBox);

    selectedActivity = widget.activity;
  }

  bool _canSubmit() => true;

  Future _submit() async {
    if (_canSubmit()) {
      Entry entry;
      final dateNow = DateTime.now();

      switch (selectedActivity.type.kind) {
        case TypeKind.numeric:
          entry = Entry(dateNow, parseDouble(numericValueController.text));
          break;
        case TypeKind.enumeration:
          entry = Entry(dateNow, _selectedEnum.weight.toDouble());
          break;
        case TypeKind.range:
          if (sliderPosition == null) {
            print('Slider NULL');
            sliderPosition = selectedActivity.type.rangeType.min.toDouble();
          }

          entry = Entry(dateNow, sliderPosition);
          break;
      }

      _entryBox.add(entry);
      selectedActivity.entries.add(entry);
      selectedActivity.save();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entry'),
        actions: <Widget>[
          AppBarSubmitButton(onPressed: _canSubmit() ? _submit : null),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          child: Column(
            children: <Widget>[
              ValueListenableBuilder<Box<Activity>>(
                valueListenable: _activityBox.listenable(),
                builder: (context, value, _) {
                  Widget valueInput = Container();
                  if (selectedActivity != null) {
                    switch (selectedActivity.type.kind) {
                      case TypeKind.numeric:
                        final numericType = selectedActivity.type.numericType;

                        valueInput = Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: TextField(
                            controller: numericValueController,
                            keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                            decoration: InputDecoration(
                              suffixText: numericType.unit,
                              hintText: 'Value',
                            ),
                          ),
                        );
                        break;
                      case TypeKind.enumeration:
                        final enumType = selectedActivity.type.enumType;

                        valueInput = Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: AppDropdownButton<EnumTypeValue>(
                            onChanged: (value) {
                              setState(() {
                                _selectedEnum = value;
                              });
                            },
                            hint: Text('Select value'),
                            value: _selectedEnum,
                            items: enumType.values,
                            itemFormat: (value) => value.name,
                          ),
                        );
                        break;
                      case TypeKind.range:
                        final rangeType = selectedActivity.type.rangeType;

                        valueInput = Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Slider(
                            min: rangeType.min,
                            max: rangeType.max,
                            value: sliderPosition ?? rangeType.min.toDouble(),
                            divisions: rangeType.max.toInt() - rangeType.min.toInt(),
                            label: sliderPosition?.toString() ?? '',
                            onChanged: (value) {
                              setState(() {
                                sliderPosition = value;
                              });
                            },
                          ),
                        );
                        break;
                    }
                  }

                  return Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                        child: AppDropdownButton<Activity>(
                          value: selectedActivity,
                          items: value.values.toList(),
                          hint: Text('Select activity'),
                          onChanged: (activity) {
                            if (activity != selectedActivity) {
                              setState(() {
                                selectedActivity = activity;
                                _selectedEnum = null;
                                numericValueController.text = '';
                              });
                            }
                          },
                          itemFormat: (activity) => activity.name,
                        ),
                      ),
                      valueInput,
                    ],
                  );
                },
              ),
              Container(),
            ],
          ),
        ),
      ),
    );
  }
}
