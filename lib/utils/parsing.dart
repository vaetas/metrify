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

/// Parses double from string while respecting single dot/comma as decimal points. Will remove all spaces
/// before parsing.
double parseDouble(String text) {
  if (text == null || text.trim().isEmpty) {
    return null;
  }

  // Trim surrounding spaces and remove inner spaces.
  text = text.trim().replaceAll(RegExp(r' '), '');

  // Meaning of dot and comma might vary in different regions. If parsed string
  // contains only single dot or comma, then interpret is as a decimal point.
  final dotFormat = RegExp(r'^-?[0-9]+(\.[0-9]*)?$');
  final commaFormat = RegExp(r'^-?[0-9]+(,[0-9]*)?$');

  if (dotFormat.hasMatch(text)) {
    return double.parse(text);
  }

  if (commaFormat.hasMatch(text)) {
    return double.parse(text.replaceAll(RegExp(','), '.'));
  }

  return null;
}
