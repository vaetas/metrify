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

typedef ItemFormatFn<T> = String Function(T object);

/// Customized [DropdownButton] to better fit app theme.
class AppDropdownButton<T> extends StatelessWidget {
  /// Selected value.
  final T value;

  /// Items to select from.
  final List<T> items;

  /// Function to get String from single [item].
  final ItemFormatFn<T> itemFormat;

  final Widget hint;
  final ValueChanged onChanged;

  AppDropdownButton({
    Key key,
    this.value,
    this.items,
    this.hint,
    @required this.onChanged,
    this.itemFormat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      alignedDropdown: true,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border(
              bottom: BorderSide(
                // color: Colors.white.withOpacity(0.45),
                color: Theme.of(context).inputDecorationTheme.enabledBorder.borderSide.color,
                width: 1,
              ),
            ),
          ),
          child: DropdownButton<T>(
            isExpanded: true,
            onChanged: onChanged,
            value: value,
            underline: Container(),
            hint: hint,
            items: items.map((i) {
              return DropdownMenuItem(
                value: i,
                child: Text(itemFormat != null ? itemFormat(i) : i.toString()),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
