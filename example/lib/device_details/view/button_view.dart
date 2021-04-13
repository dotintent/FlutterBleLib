import 'package:flutter/material.dart';

class ButtonView extends StatelessWidget {
  final String _text;
  final void Function()? action;

  ButtonView(this._text, {this.action});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ElevatedButton(
          child: Text(_text),
          onPressed: action,
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.white),
            backgroundColor: MaterialStateProperty.all(Colors.blue),
          ),
        ),
      ),
    );
  }
}
