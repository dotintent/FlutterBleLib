import 'package:flutter/material.dart';

class CustomMaterialButton extends StatelessWidget {

  const CustomMaterialButton({
    Key key,
    this.onPressed,
    this.color,
    this.disabledColor,
    this.child,
    this.minWidth,
  }) : super(key: key);

  final VoidCallback onPressed;

  final Color color;
  final Color disabledColor;
  final Widget child;
  final double minWidth;

  bool get enabled => onPressed != null;

  Color _getColor(BuildContext context) {
    if (enabled) {
      return color ?? Theme.of(context).buttonColor;
    } else {
      if (disabledColor != null)
        return disabledColor;
      final Brightness brightness = Theme.of(context).brightness;
      assert(brightness != null);
      switch (brightness) {
        case Brightness.light:
          return Colors.black12;
        case Brightness.dark:
          return Colors.white12;
      }
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    return new MaterialButton(
      onPressed: onPressed,
      minWidth: minWidth,
      color: _getColor(context),
      child: child,
    );
  }
}