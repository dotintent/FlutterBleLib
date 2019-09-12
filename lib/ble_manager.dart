part of flutter_ble_lib;

typedef RestoreStateAction = Function(List<Device> restoreStateIdentifier);

class BleManager {
  FlutterBleLib _bleLib;

  BleManager() {
    _bleLib = FlutterBleLib();
  }

  Future<void> createClient(
      {String restoreStateIdentifier, RestoreStateAction restoreStateAction}) {
    if (restoreStateAction != null) {
      _bleLib.restoredState().then((devices) {
        restoreStateAction(devices);
      });
    }
    return _bleLib.createClient(restoreStateIdentifier);
  }

  Future<void> destroyClient() async {
    return _bleLib.destroyClient();
  }
}
