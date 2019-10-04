part of internal;

class DartToPlatformBridge {
  MethodChannel _downstreamChannel;

  DartToPlatformBridge() {
    _downstreamChannel = new MethodChannel(ChannelName.downstream);
  }

  Future<void> simulate() =>
      _downstreamChannel.invokeMethod(PlatformMethodName.simulate);

  Future<void> publishScanResult(ScanResult scanResult) =>
      _downstreamChannel.invokeMethod(
          SimulationPlatformMethodName.publishScanResult, <String, dynamic>{
        ArgumentName.name: scanResult.name,
        ArgumentName.id: scanResult.id,
        ArgumentName.mtu: scanResult.mtu,
        ArgumentName.rssi: scanResult.rssi,
        ArgumentName.isConnectable: scanResult.isConnectable,
        ArgumentName.txPowerLevel: scanResult.txPowerLevel,
        ArgumentName.manufacturerData: scanResult.manufacturerData,
        ArgumentName.serviceData: scanResult.serviceData,
        ArgumentName.serviceUuids: scanResult.serviceUuids,
        ArgumentName.localName: scanResult.localName,
        ArgumentName.solicitedServiceUuids: scanResult.solicitedServiceUuids,
        ArgumentName.overflowUuids: scanResult.overflowUuids,
      });
}
