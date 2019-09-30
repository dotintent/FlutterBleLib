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
          else
            return [
              Peripheral.fromJson(jsonDecode(jsonString), _manager)
            ]; //TODO Add proper mapping from json here (11.09.2019)
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
}