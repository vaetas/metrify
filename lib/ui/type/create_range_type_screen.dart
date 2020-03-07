import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:metrify/models/type.dart';
import 'package:metrify/ui/widgets/appbar_submit_button.dart';

class CreateRangeTypeScreen extends StatefulWidget {
  @override
  _CreateRangeTypeScreenState createState() => _CreateRangeTypeScreenState();
}

class _CreateRangeTypeScreenState extends State<CreateRangeTypeScreen> {
  Box<ActivityType> _box;

  String _name = '';
  String _start = '';
  String _end = '';

  final _nameController = TextEditingController();
  final _startController = TextEditingController();
  final _endController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _box = Hive.box<ActivityType>(typeBox);

    _nameController
      ..addListener(() {
        setState(() {
          _name = _nameController.text;
        });
      });

    _startController
      ..addListener(() {
        setState(() {
          _start = _startController.text;
        });
      });

    _endController
      ..addListener(() {
        setState(() {
          _end = _endController.text;
        });
      });
  }

  bool _canSubmit() {
    return _name.trim().isNotEmpty && _start.trim().isNotEmpty && _end.trim().isNotEmpty;
  }

  void _submit(BuildContext context) {
    final name = _name.trim();
    int start;
    int end;

    try {
      start = int.parse(_start);
    } catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Minimum value is invalid.'),
      ));
      return;
    }

    try {
      end = int.parse(_end);
    } catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Maximum value is invalid.'),
      ));
      return;
    }

    if ((start - end).abs() < 1) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Min and max value cannot be equal.'),
      ));
      return;
    }

    final type = ActivityType(
      name,
      TypeKind.range,
      rangeType: RangeType(
        start.toDouble(),
        end.toDouble(),
      ),
    );

    _box.add(type);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Range Type'),
        actions: <Widget>[
          Builder(
            builder: (context) {
              return AppBarSubmitButton(
                onPressed: _canSubmit() ? () => _submit(context) : null,
              );
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text('Only integers can be used for min and max values.'),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                autocorrect: true,
                textCapitalization: TextCapitalization.words,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                controller: _startController,
                decoration: InputDecoration(
                  labelText: 'Minimum',
                ),
                keyboardType: TextInputType.numberWithOptions(),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                controller: _endController,
                decoration: InputDecoration(labelText: 'Maximum'),
                keyboardType: TextInputType.numberWithOptions(),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }
}
