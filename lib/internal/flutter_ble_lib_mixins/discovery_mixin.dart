part of flutter_ble_lib;

mixin DiscoveryMixin on FlutterBLE {
  Future<void> discoverAllServicesAndCharacteristics(
      Peripheral peripheral, String transactionId) async {
    await _methodChannel.invokeMethod(
        MethodName.discoverAllServicesAndCharacteristics, <String, dynamic>{
      ArgumentName.deviceIdentifier: peripheral.identifier,
      ArgumentName.transactionId: transactionId
    });
  }

  Future<List<Service>> services(Peripheral peripheral) async {
    String jsonString = await _methodChannel.invokeMethod(
        MethodName.services, <String, dynamic>{
      ArgumentName.deviceIdentifier: peripheral.identifier
    });

    List<Map<String, dynamic>> services = jsonDecode(jsonString);

    return services.map((value) => Service.fromJson(value, peripheral));
  }

  Future<List<Characteristic>> characteristics(
      Peripheral peripheral, String serviceUuid) async {
    String jsonString = await _methodChannel
        .invokeMethod(MethodName.characteristics, <String, dynamic>{
      ArgumentName.deviceIdentifier: peripheral.identifier,
      ArgumentName.serviceUuid: serviceUuid
    });

    Map<String, dynamic> jsonObject = jsonDecode(jsonString);
    List<Map<String, dynamic>> jsonCharacteristics = jsonObject["characteristics"];
    Service service = Service.fromJson(jsonObject, peripheral);

    return jsonCharacteristics.map((characteristic) {
      Characteristic.fromJson(characteristic, service);
    }).cast();
  }
}
