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
import 'package:metrify/ui/widgets/utils.dart';

typedef FilterTapCallback<T> = Function(T item, bool value);

class FilterChipInput<T> extends StatelessWidget {
  final Set<T> items;
  final Set<T> selected;
  final FilterTapCallback<T> onTap;
  final TransformFn<T, String> itemFormatFn;
  final TransformFn<T, Color> colorFormatFn;

  FilterChipInput({
    Key key,
    this.items,
    this.selected,
    this.onTap,
    this.itemFormatFn,
    this.colorFormatFn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5,
      children: items.map((i) {
        return FilterChip(
          onSelected: (value) => onTap(i, value),
          selected: selected.contains(i),
          label: Text(itemFormatFn(i)),
          selectedColor: colorFormatFn(i),
        );
      }).toList(),
    );
  }
}
