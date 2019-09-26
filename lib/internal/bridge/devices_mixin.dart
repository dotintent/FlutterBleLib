part of internal_bridge_lib;

mixin DevicesMixin on FlutterBLE {


  Future<List<Peripheral>> knownDevices(List<String> peripheralIdentifiers) async {
    String peripheralsJson = await _methodChannel.invokeMethod(MethodName.knownDevices, <String, dynamic>{
      ArgumentName.deviceIdentifiers: peripheralIdentifiers,
    });
    print("knownw devices json: $peripheralsJson");
//    var myThing = peripheralsJson.map((e) => Peripheral.fromJson(e, _manager)).toList();
    print("known devices json: $peripheralsJson");
    return <Peripheral>[];
  }

  Future<List<Peripheral>> connectedDevices(List<String> serviceUUIDs) async {
    String peripheralsJson = await _methodChannel.invokeMethod(MethodName.connectedDevices, <String, dynamic>{
      ArgumentName.serviceUuids: serviceUUIDs,
    });
    print("connected devices json: $peripheralsJson");
    print("knownw devices json: $peripheralsJson");
//    var myThing = peripheralsJson.map((e) => Peripheral.fromJson(e, _manager)).toList();
    print("connected devices json: $peripheralsJson");
    return <Peripheral>[];
  }
}