part of flutter_ble_lib;


mixin LogLevelMixin on FlutterBLE {

  Future<void> setLogLevel(LogLevel logLevel) async {
    print("set log level to ${describeEnum(logLevel)}");
    return await _methodChannel.invokeMethod(MethodName.setLogLevel, <String, dynamic>{
      ArgumentName.logLevel: describeEnum(logLevel),
    });
  }

  Future<LogLevel> logLevel() async {
    String logLevelName = await _methodChannel.invokeMethod(MethodName.logLevel);
    return logLevelFromString(logLevelName);
  }
}