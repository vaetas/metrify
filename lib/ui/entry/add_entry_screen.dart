import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:metrify/models/activity.dart';
import 'package:metrify/models/entry.dart';
import 'package:metrify/models/type.dart';
import 'package:metrify/ui/widgets/appbar_submit_button.dart';
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
                            decoration: InputDecoration(suffixText: numericType.unit),
                          ),
                        );
                        break;
                      case TypeKind.enumeration:
                        final enumType = selectedActivity.type.enumType;

                        valueInput = Container(
                          child: DropdownButton<EnumTypeValue>(
                            onChanged: (value) {
                              setState(() {
                                _selectedEnum = value;
                              });
                            },
                            hint: Text('Select value'),
                            value: _selectedEnum,
                            items: enumType.values
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.name),
                                  ),
                                )
                                .toList(),
                          ),
                        );
                        break;
                      case TypeKind.range:
                        final rangeType = selectedActivity.type.rangeType;

                        print(selectedActivity.type.rangeType.min);
                        print(selectedActivity.type.rangeType.max);
                        valueInput = Container(
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
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        margin: EdgeInsets.all(15),
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: DropdownButton<Activity>(
                          underline: Container(),
                          hint: Text('Select activity'),
                          isExpanded: true,
                          onChanged: (activity) {
                            if (activity != selectedActivity) {
                              setState(() {
                                selectedActivity = activity;
                                _selectedEnum = null;
                                numericValueController.text = '';
                              });
                            }
                          },
                          value: selectedActivity,
                          items: value.values.map((e) {
                            return DropdownMenuItem(
                              value: e,
                              child: Text(e.name),
                            );
                          }).toList(),
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
