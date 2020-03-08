import 'package:flutter/material.dart';

typedef String ItemFormatFn(dynamic item);

/// Customized [DropdownButton] to better fit app theme.
class AppDropdownButton<T> extends StatelessWidget {
  /// Selected value.
  final T value;

  /// Items to select from.
  final List<T> items;

  /// Function to get String from single [item].
  final ItemFormatFn itemFormat;

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
