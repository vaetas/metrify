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
import 'package:metrify/models/category.dart';
import 'package:metrify/ui/widgets/appbar_submit_button.dart';

class CreateCategoryScreen extends StatefulWidget {
  static const routeName = '/category/create';

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
