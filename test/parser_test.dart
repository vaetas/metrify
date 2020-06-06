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

import 'package:metrify/utils/parsing.dart';
import 'package:test/test.dart';

void main() {
  group('Parsing', () {
    test('positive number', () {
      expect(parseDouble('10'), 10.0);
    });

    test('negative number', () {
      expect(parseDouble('-10'), -10.0);
    });

    test('negative decimal number', () {
      expect(parseDouble('-10.3'), -10.3);
    });

    test('decimal dot', () {
      expect(parseDouble('10.1'), 10.1);
    });

    test('decimal comma', () {
      expect(parseDouble('10,1'), 10.1);
    });

    test('trailing dot', () {
      expect(parseDouble('10.'), 10.0);
    });

    test('too many decimal points', () {
      expect(parseDouble(('10..')), null);
    });

    test('number with spaces', () {
      expect(parseDouble(('1 000 000')), 1000000.0);
    });

    test('number with spaces', () {
      expect(parseDouble(('1,000,000.12')), 1000000.12);
    });

    test('number with spaces and decimal points', () {
      expect(parseDouble(('1 000 000.123')), 1000000.123);
    });
  });
}
