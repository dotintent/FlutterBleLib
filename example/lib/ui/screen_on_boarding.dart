import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:flutter_ble_lib_example/ui/screen_names.dart' as ScreenNames;


class OnBoardingPager extends StatefulWidget {
  @override
  _OnBoardingPagerState createState() => new _OnBoardingPagerState();
}

class _OnBoardingPagerState extends State<OnBoardingPager>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  List<Widget> _pages = <Widget>[
    new WelcomeScreen(),
    new InfoScreen(),
    new CreateScreen()
  ];

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: _pages.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(

      body: new TabBarView(
        controller: _tabController,
        children: _pages,
      ),
      bottomNavigationBar: new PreferredSize(
        preferredSize: const Size.fromHeight(48.0),
        child: new Theme(
          data: Theme.of(context).copyWith(accentColor: Colors.white),
          child: new Container(
            height: 48.0,
            alignment: Alignment.center,
            child: new TabPageSelector(controller: _tabController),
          ),
        ),
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  static const String _welcomeMessage = "Welcome in flutter ble example. This app shows you all functionality of our library. Swipe right to get more information";

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme
        .of(context)
        .textTheme
        .title;
    final Widget flutterIcon = new Container(
        margin: const EdgeInsets.only(bottom: 20.0),
        child: new Image.asset(
          'images/flutter-ble-lib-logo-small.png', width: 250.0, height: 145.0,)
    );
    final Text message = new Text(
      _welcomeMessage, style: textStyle, textAlign: TextAlign.center,);
    return
      new Padding(padding: new EdgeInsets.all(24.0),
        child: new Center(
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[flutterIcon, message,],
          ),
        ),
      );
  }
}

class InfoScreen extends StatelessWidget {
  static const String _infoMessage = "Our library allows:";
  static const String _actionMessage = "Swipe Right for more...";
  static const List<String> _infoPoints = const <String>[
    "set log level",
    "listen bluetooth state",
    "scan devices",
    "establish connection",
    "listen connection state changes",
    "discover services",
    "read characteristics",
    "write characteristics",
    "listen characteristic notifications",
  ];

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme
        .of(context)
        .textTheme
        .headline;
    final TextStyle textStyleMessage = Theme
        .of(context)
        .textTheme
        .body1;
    final Text message = new Text(_infoMessage, style: textStyle,);
    final List<Widget> list = _infoPoints.map((text) =>
        _checkboxWithLabel(context, text)).toList();
    return new Container(
      padding: const EdgeInsets.all(16.0),
      child: new Center(
        child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[message]
              ..addAll(list)
              ..add(new Text(_actionMessage, textAlign: TextAlign.end,
                style: textStyleMessage,))
        ),
      ),
    );
  }

  Widget _checkboxWithLabel(BuildContext context, String text) {
    final TextStyle textStyle = Theme
        .of(context)
        .textTheme
        .subhead;
    return new Row(
      children: <Widget>[
        new Checkbox(value: true, onChanged: null),
        new Text(text, style: textStyle,)
      ],
    );
  }
}

class CreateScreen extends StatelessWidget {

  static const String _createMessage = "Just click on button and check our libs";

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme
        .of(context)
        .textTheme
        .display1;
    return new Container(
      padding: const EdgeInsets.only(
          left: 16.0, right: 16.0, top: 48.0, bottom: 48.0),
      child: new Center(
        child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Text(
                _createMessage, textAlign: TextAlign.center, style: textStyle,),
              new Container (
                margin: const EdgeInsets.only(top: 48.0),
                child: new FloatingActionButton(
                    child: new Icon(Icons.bluetooth),
                    onPressed: () => _onCreateButtonClick(context)
                ),
              ),
            ]
        ),
      ),
    );
  }

  _onCreateButtonClick(BuildContext context) {
    FlutterBleLib.instance.createClient(null).then(
            (data) =>
            Navigator.of(context).pushNamed(
                ScreenNames.bleDevicesScreen)
    );
  }
}
