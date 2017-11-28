import 'dart:async';

import 'package:flutter/services.dart';

class FlutterBleLib {
  static const MethodChannel _channel =
      const MethodChannel('flutter_ble_lib');

  static Future<String> get platformVersion =>
      _channel.invokeMethod('getPlatformVersion');
}
