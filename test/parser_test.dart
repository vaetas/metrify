import 'package:flutter_test/flutter_test.dart';
import 'package:metrify/utils/parsing.dart';

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
