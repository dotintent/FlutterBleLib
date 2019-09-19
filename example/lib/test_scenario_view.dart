import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'sensor_tag_test_scenario.dart';

class DebugLog {
  String time;
  String content;

  DebugLog(this.time, this.content);
}

class TestScenarioWidget extends StatefulWidget {
  _TestScenarioWidgetState createState() => _TestScenarioWidgetState();
}

class _TestScenarioWidgetState extends State<TestScenarioWidget> {
  List<DebugLog> _log = [];

  bool _isTestInProgress = false;

  Logger _logger;
  Logger _errorLogger;
  TestScenario _testScenario;

  void _startTest() async {
    if (_isTestInProgress) return;

    _isTestInProgress = true;

    _logger = (newLog) {
      setState(() {
        _log.insert(0, DebugLog(DateTime.now().toString(), newLog));
      });
    };
    _errorLogger = (newLog) {
      setState(() {
        _log.insert(0, DebugLog(DateTime.now().toString(), newLog));
      });
    };
    _testScenario = new TestScenario();

    setState(() {
      _log.clear();
    });

    await _testScenario.runTestScenario(_logger, _errorLogger);
    _isTestInProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          child: Flexible(
            child: ListView.builder(
              controller: ScrollController(),
              itemCount: _log.length,
              itemBuilder: (buildContext, index) =>
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.grey,
                          width: 0.5,
                        ),
                        bottom: BorderSide(
                          color: Colors.grey,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              _log[index].time,
                              style: TextStyle(fontSize: 9),
                            ),
                          ),
                          Text(_log[index].content,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              style: TextStyle(fontSize: 9)),
                        ],
                      ),
                    ),
                  ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text("Run Sensor Tag test scenario"),
              onPressed: _startTest,
            )
          ],
        ),
      ],
    );
  }
}
