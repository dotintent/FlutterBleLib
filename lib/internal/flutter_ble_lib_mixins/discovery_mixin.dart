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

    List<String> decodedJson = (jsonDecode(jsonString) as List<dynamic>).cast();

    return decodedJson
        .map((serviceJsonString) =>
            Service.fromJson(jsonDecode(serviceJsonString), peripheral))
        .toList();
  }

  Future<List<Characteristic>> characteristics(
      Peripheral peripheral, String serviceUuid) async {
    String jsonString = await _methodChannel
        .invokeMethod(MethodName.characteristics, <String, dynamic>{
      ArgumentName.deviceIdentifier: peripheral.identifier,
      ArgumentName.serviceUuid: serviceUuid
    });

    Map<String, dynamic> jsonObject = jsonDecode(jsonString);
    List<String> jsonCharacteristics =
        (jsonObject["characteristics"] as List<dynamic>).cast();
    Service service = Service.fromJson(jsonObject, peripheral);

    return jsonCharacteristics.map((characteristicJsonString) {
      return Characteristic.fromJson(jsonDecode(characteristicJsonString), service);
    }).toList();
  }
}
