part of flutter_ble_lib;

class FlutterBleLib {
  static const MethodChannel _methodChannel =
  const MethodChannel(ChannelName.flutterBleLib);

  static const EventChannel _restoreStateEventChannel =
  const EventChannel(ChannelName.stateRestoreEvents);

  static const EventChannel _scanEventChannel =
  const EventChannel(ChannelName.scanningEvents);

  Future<List<Peripheral>> restoredState() => _restoreStateEventChannel
      .receiveBroadcastStream()
      .map(
        (jsonString) {
          if (jsonString == null)
            return null;
          else
            return [
              Peripheral.fromJson(jsonString)
            ]; //TODO Add proper mapping from json here (11.09.2019)
        },
      )
          .take(1)
          .single;

  Future<void> createClient(String restoreStateIdentifier) async {
    await _methodChannel.invokeMethod(
        MethodName.createClient, <String, String>{
      ArgumentName.restoreStateIdentifier: restoreStateIdentifier
    });
    return;
  }

  Future<void> destroyClient() async {
    await _methodChannel.invokeMethod(MethodName.destroyClient);
    return;
  }

  Stream<ScanResult> startDeviceScan(int scanMode,
      int callbackType,
      List<String> uuids,) async* {
    _methodChannel.invokeMethod(
      MethodName.startDeviceScan,
      <String, dynamic>{
        ArgumentName.scanMode: scanMode,
        ArgumentName.callbackType: callbackType,
        ArgumentName.uuids: uuids
      },
    );
    yield* _scanEventChannel
        .receiveBroadcastStream()
        .map((scanResultJson) {
      return ScanResult.fromJson(
        jsonDecode(scanResultJson),
      );
    });
  }
  Future<void> stopDeviceScan() async {
    await _methodChannel.invokeMethod(MethodName.stopDeviceScan);
    return;
  }
}
