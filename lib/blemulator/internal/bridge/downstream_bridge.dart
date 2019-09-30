part of internal;

class DownstreamBridge {
  MethodChannel _downstreamChannel;

  DownstreamBridge() {
    _downstreamChannel = new MethodChannel(ChannelName.downstream);
  }

  Future<void> simulate() =>
      _downstreamChannel.invokeMethod(DownstreamMethodName.simulate);

  Future<void> addScanResult(ScanResult scanResult) =>
      _downstreamChannel.invokeMethod(
          SimulationDownstreamMethodName.addScanResult, <String, dynamic>{
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
