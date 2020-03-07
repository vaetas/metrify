import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:metrify/models/type.dart';
import 'package:metrify/ui/widgets/appbar_submit_button.dart';

class CreateNumericTypeScreen extends StatefulWidget {
  @override
  _CreateNumericTypeScreenState createState() => _CreateNumericTypeScreenState();
}

class _CreateNumericTypeScreenState extends State<CreateNumericTypeScreen> {
  String _name;
  String _unit;

  Box<ActivityType> _box;
  final nameController = TextEditingController();
  final unitController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _box = Hive.box<ActivityType>(typeBox);

    nameController.addListener(() {
      setState(() {
        _name = nameController.text;
      });
    });

    unitController.addListener(() {
      setState(() {
        _unit = unitController.text;
      });
    });
  }

  Future _submit() async {
    final type = ActivityType(
      _name.trim(),
      TypeKind.numeric,
      numericType: NumericType(_unit.trim()),
    );

    _box.add(type);
    Navigator.pop(context);
  }

  bool _canSubmit() => _name != null && _name.trim().isNotEmpty && _unit != null && _unit.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Numeric type'),
        actions: <Widget>[
          Builder(
            builder: (context) {
              return AppBarSubmitButton(onPressed: _canSubmit() ? _submit : null);
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: TextField(
                controller: nameController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(labelText: 'Name'),
                autocorrect: true,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                controller: unitController,
                decoration: InputDecoration(labelText: 'Unit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    unitController.dispose();
    super.dispose();
  }
}
