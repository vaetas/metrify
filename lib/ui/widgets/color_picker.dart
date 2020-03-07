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
