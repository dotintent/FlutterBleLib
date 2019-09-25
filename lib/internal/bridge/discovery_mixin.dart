part of internal_bridge_lib;

mixin DiscoveryMixin on FlutterBLE {
  Future<void> discoverAllServicesAndCharacteristics(
      Peripheral peripheral, String transactionId) async {
    await _methodChannel.invokeMethod(
      MethodName.discoverAllServicesAndCharacteristics,
      <String, dynamic>{
        ArgumentName.deviceIdentifier: peripheral.identifier,
        ArgumentName.transactionId: transactionId,
      },
    );
  }

  Future<List<Service>> services(Peripheral peripheral) async {
    String jsonString = await _methodChannel.invokeMethod(
      MethodName.services,
      <String, dynamic>{
        ArgumentName.deviceIdentifier: peripheral.identifier,
      },
    );

    List<Map<String, dynamic>> decodedJson =
        (jsonDecode(jsonString) as List<dynamic>).cast();

    return decodedJson
        .map((serviceJson) =>
            Service.fromJson(serviceJson, peripheral, _manager))
        .toList();
  }

  Future<List<Characteristic>> characteristics(
      Peripheral peripheral, String serviceUuid) async {
    String jsonString = await _methodChannel.invokeMethod(
      MethodName.characteristics,
      <String, dynamic>{
        ArgumentName.deviceIdentifier: peripheral.identifier,
        ArgumentName.serviceUuid: serviceUuid,
      },
    );

    Map<String, dynamic> jsonObject = jsonDecode(jsonString);
    List<Map<String, dynamic>> jsonCharacteristics =
        (jsonObject["characteristics"] as List<dynamic>).cast();
    Service service = Service.fromJson(jsonObject, peripheral, _manager);

    return jsonCharacteristics.map((characteristicJson) {
      return Characteristic.fromJson(characteristicJson, service, _manager);
    }).toList();
  }

  Future<List<Characteristic>> characteristicsForService(
      Service service) async {
    String jsonString = await _methodChannel.invokeMethod(
      MethodName.characteristicsForService,
      <String, dynamic>{
        ArgumentName.serviceId: service._id,
      },
    );

    List<Map<String, dynamic>> jsonList =
        (jsonDecode(jsonString) as List<dynamic>).cast();

    return jsonList.map((characteristicJson) {
      return Characteristic.fromJson(characteristicJson, service, _manager);
    }).toList();
  }
}
