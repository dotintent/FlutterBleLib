part of internal;

class SimulatorCallHandler {

  Future<dynamic> handleCall(MethodCall call) {
    switch (call.method) {
      default:
        throw UnimplementedError("${call.method} is not implemented");
    }
  }
}