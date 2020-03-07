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
