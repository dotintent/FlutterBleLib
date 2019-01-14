import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:flutter_ble_lib_example/ui/button_widget.dart';

class InsertValueDialog extends StatefulWidget {

  final Characteristic _characteristic;
  final dynamic _sendAction;

  InsertValueDialog(this._characteristic, {dynamic sendAction}) :
        _sendAction = sendAction;

  @override
  InsertValueDialogState createState() =>
      new InsertValueDialogState(_characteristic, sendAction: _sendAction);
}

enum DataType {
  HEX,
  OCTAL,
  BINARY,
  STRING,
}

class InsertValueDialogState extends State<InsertValueDialog> {

  final Characteristic _characteristic;
  final dynamic _sendAction;

  DataType _currentDataType = DataType.HEX;

  String _textValue = "";

  TextEditingController _controller;
  FocusNode _focusNode;

  InsertValueDialogState(this._characteristic, {dynamic sendAction}) :
        _sendAction = sendAction;

  @override
  Widget build(BuildContext context) {
    _focusNode = new FocusNode();
    _controller = new TextEditingController(text: _textValue);
    final TextStyle titleStyle = Theme
        .of(context)
        .textTheme
        .title;
    final TextStyle contextTextStyle = Theme
        .of(context)
        .textTheme
        .body1;
    return new AlertDialog(
      title: new Text("Type value", style: titleStyle,),
      content:
      new SingleChildScrollView(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Text(_dialogText(), style: contextTextStyle,),
              new Container(
                padding: const EdgeInsets.all(12.0),
                child: new Column(
                  children: <Widget>[]
                    ..addAll(_radioGroupCollection())
                    ..add(
                      new TextFormField(
                        keyboardType: _keyboardType(),
                        decoration: new InputDecoration(
                          labelText: 'Value',
                          prefixText: _prefixText(),
                          prefixStyle: new TextStyle(color: Colors.white),
                        ),
                        controller: _controller,
                        maxLines: 1,
                        focusNode: _focusNode,
                      ),
                    ),
                ),
              ),
            ],
          ))
      ,
      actions: <Widget>[
        new CustomMaterialButton(
            child: new Text("Send", style: new TextStyle(color: Colors.white),),
            onPressed: () {
              _sendAction(_dataAsBytes());
              Navigator.pop(context);
            }
        )
      ],
    );
  }

  _dataAsBytes() {
    if (_currentDataType == DataType.STRING) {
      return utf8.encode(_controller.text);
    }
    return new List<int>()
      ..add(int.parse(
          _controller.text, radix: _calculateRadix(), onError: (error) {
        print("Error occours : $error");
        return 1;
      }));
  }

  _calculateRadix() {
    switch (_currentDataType) {
      case DataType.HEX :
        return 16;
      case DataType.OCTAL :
        return 8;
      case DataType.BINARY :
        return 2;
      case DataType.STRING:
        throw new Exception("Please check that data type is not sting");
    }
  }

  _keyboardType() {
    switch (_currentDataType) {
      case DataType.HEX :
      case DataType.OCTAL :
      case DataType.BINARY :
        return TextInputType.number;
      case DataType.STRING :
        return TextInputType.text;
    }
  }

  _prefixText() {
    switch (_currentDataType) {
      case DataType.HEX :
        return "0x";
      case DataType.OCTAL :
        return "0";
      case DataType.BINARY :
        return "0b";
      case DataType.STRING :
        return "";
    }
  }

  _radioGroupCollection() =>
      DataType.values
          .map((dataType) =>
      new RadioListTile<DataType>(
          title: new Text(_label(dataType)),
          value: dataType,
          groupValue: _currentDataType,
          selected: dataType == _currentDataType,
          onChanged: (value) {
            setState(() {
              _focusNode.unfocus();
              _controller.text = "";
              _currentDataType = value;
            });
          }
      ),
      ).toList();

  _label(DataType dataType) {
    switch (dataType) {
      case DataType.HEX :
        return "Hex";
      case DataType.OCTAL :
        return "Octal";
      case DataType.BINARY :
        return "Binary";
      case DataType.STRING :
        return "UTF-8 String";
    }
  }

  _dialogText() => "Choose data type:";
}