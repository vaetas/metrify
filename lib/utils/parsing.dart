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
