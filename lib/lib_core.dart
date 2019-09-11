part of flutter_ble_lib;

class FlutterBleLib {
  static const MethodChannel _methodChannel =
      const MethodChannel(ChannelName.FLUTTER_BLE_LIB);

  static const EventChannel _restoreStateEventChannel =
      const EventChannel(ChannelName.STATE_RESTORE_EVENTS);

  Future<List<Device>> restoredState() =>
      _restoreStateEventChannel.receiveBroadcastStream().map(
    (jsonString) {
      if (jsonString == null)
        return null;
      else
        return [
          Device.fromJson(jsonString)
        ]; //TODO Add proper mapping from json here (11.09.2019)
    },
  ).single;

  Future<void> createClient(String restoreStateIdentifier) async {
    await _methodChannel.invokeMethod(
        MethodName.CREATE_CLIENT, <String, String>{
      ArgumentName.RESTORE_STATE_IDENTIFIER: restoreStateIdentifier
    });
    return;
  }

  Future<void> destroyClient() async {
    await _methodChannel.invokeMethod(MethodName.DESTROY_CLIENT);
    return;
  }
}
