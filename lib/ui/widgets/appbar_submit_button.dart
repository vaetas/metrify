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

class AppBarSubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  AppBarSubmitButton({Key key, this.onPressed, this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(11),
      width: 90,
      child: FlatButton(
        padding: const EdgeInsets.all(0),
        color: Theme.of(context).accentColor,
        // visualDensity: VisualDensity.compact,
        disabledColor: Theme.of(context).accentColor.withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
        child: Text(
          label ?? 'Save',
          style: TextStyle(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
