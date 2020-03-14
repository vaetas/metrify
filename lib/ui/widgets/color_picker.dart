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

typedef void ColorPickerCallback(Color color);

const _colors = <Color>[
  Colors.red,
  Colors.orange,
  Colors.green,
  Colors.blue,
  Colors.indigo,
  Colors.lime,
  Colors.purple,
  Colors.teal,
  Colors.amber,
  Colors.greenAccent,
  Colors.pink,
  Colors.purpleAccent,
];

class ColorPicker extends StatelessWidget {
  final Color selected;
  final ColorPickerCallback onSelect;

  ColorPicker({Key key, this.selected, this.onSelect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: GridView.count(
        crossAxisCount: 6,
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: _colors.map((c) {
          return Material(
            borderRadius: BorderRadius.circular(6),
            elevation: selected == c ? 15 : 0,
            color: c,
            child: InkWell(
              onTap: () => onSelect(c),
              child: Container(
                height: 40,
                width: 40,
                child: selected == c ? Icon(Icons.check) : null,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
