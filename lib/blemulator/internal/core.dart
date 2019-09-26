part of internal;

class BlemulatorBridge {
  MethodChannel _upstreamChannel;
  MethodChannel _downstreamChannel;

  BlemulatorBridge() {
    _upstreamChannel = new MethodChannel(ChannelName.upstream);
    _upstreamChannel.setMethodCallHandler(SimulatorCallHandler().handleCall);
    _downstreamChannel = new MethodChannel(ChannelName.downstream);
  }

  Future<void> simulate() =>
      _downstreamChannel.invokeMethod(MethodName.simulate);
}
