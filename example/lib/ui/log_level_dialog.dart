import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';

class LogLevelDialog extends StatefulWidget {
  @override
  LogLevelDialogState createState() => new LogLevelDialogState();
}

class LogLevelDialogState extends State<LogLevelDialog> {

  LogLevel _currentLogLevel = LogLevel.NONE;

  @override
  initState() {
    super.initState();
    FlutterBleLib.instance.logLevel().then((logLevel) =>
        setState(() => _currentLogLevel = logLevel));
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle = Theme
        .of(context)
        .textTheme
        .title;
    final TextStyle contextTextStyle = Theme
        .of(context)
        .textTheme
        .body1;
    return new AlertDialog(
        title: new Text("Log level", style: titleStyle,),
        content: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text(_dialogText(), style: contextTextStyle,),
            new Container(
              padding: const EdgeInsets.all(12.0),
              child: new PopupMenuButton<LogLevel>(
                padding:const EdgeInsets.all(8.0),
                child: new Text(
                  _currentLogLevel.toString(),
                  style: contextTextStyle,
                ),
                onSelected: (logLevel) => _onSelect(logLevel),
                itemBuilder: (BuildContext context) {
                  return LogLevel.values.map((LogLevel choice) {
                    return new PopupMenuItem<LogLevel>(
                      value: choice,
                      child: new Text(choice.toString().substring(
                          choice.toString().lastIndexOf(".") + 1)),
                    );
                  }).toList();
                },
              ),
            ),
          ],)
    );
  }

  _onSelect(LogLevel logLevel) {
    FlutterBleLib.instance.setLogLevel(logLevel);
    setState(() {
      _currentLogLevel = logLevel;
    });
  }


  _dialogText() => "Current log level:${_currentLogLevel.toString().substring(
      _currentLogLevel.toString().lastIndexOf(".") + 1)} \nChoose log level:";
}