import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:metrify/models/category.dart';
import 'package:metrify/ui/widgets/appbar_submit_button.dart';

class CreateCategoryScreen extends StatefulWidget {
  @override
  _CreateCategoryScreenState createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {
  Box<Category> _box;
  String _name;

  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _box = Hive.box<Category>(categoryBox);

    _nameController.addListener(() {
      setState(() {
        _name = _nameController.text;
      });
    });
  }

  bool _canSubmit() => _name != null && _name.trim().isNotEmpty;

  void _submit() {
    final category = Category(_name.trim());
    _box.add(category);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category'),
        actions: <Widget>[
          AppBarSubmitButton(
            onPressed: _canSubmit() ? _submit : null,
          )
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _nameController,
                autocorrect: true,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(labelText: 'Name'),
              ),
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
