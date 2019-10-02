part of internal_bridge_lib;

abstract class FlutterBLE {
  InternalBleManager _manager;

  final MethodChannel _methodChannel =
      const MethodChannel(ChannelName.flutterBleLib);
}

class FlutterBleLib extends FlutterBLE
    with
        DeviceConnectionMixin,
        DiscoveryMixin,
        ScanningMixin,
        LogLevelMixin,
        RssiMixin,
        MtuMixin,
        BluetoothStateMixin,
        DevicesMixin,
        CharacteristicsMixin {
  final EventChannel _restoreStateEventChannel =
      const EventChannel(ChannelName.stateRestoreEvents);

  void registerManager(InternalBleManager manager) {
    _manager = manager;
  }

  Future<List<Peripheral>> restoredState() => _restoreStateEventChannel
      .receiveBroadcastStream()
      .map(
        (jsonString) {
          if (jsonString == null)
            return null;
          else {
            List<Map<String, dynamic>> restoredPeripheralsJson =
                jsonDecode(jsonString);
            return restoredPeripheralsJson
                .map((peripheralJson) =>
                    Peripheral.fromJson(peripheralJson, _manager))
                .toList();
          }
        },
      )
      .take(1)
      .single;

  Future<void> createClient(String restoreStateIdentifier) async {
    await _methodChannel.invokeMethod(MethodName.createClient, <String, String>{
      ArgumentName.restoreStateIdentifier: restoreStateIdentifier
    });
    return;
  }

  Future<void> destroyClient() async {
    await _methodChannel.invokeMethod(MethodName.destroyClient);
    return;
  }

  Future<void> cancelTransaction(String transactionId) async {
    await _methodChannel.invokeMethod(MethodName.cancelTransaction,
        <String, String>{ArgumentName.transactionId: transactionId});
    return;
  }
}
