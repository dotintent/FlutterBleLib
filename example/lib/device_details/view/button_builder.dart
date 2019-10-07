
import 'package:flutter/material.dart';

class ButtonBuilder {
  Widget build(String text, { Function action }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: RaisedButton(
          color: Colors.blue,
          textColor: Colors.white,
          child: Text(text),
          onPressed: action,
        ),
      ),
    );
  }
}