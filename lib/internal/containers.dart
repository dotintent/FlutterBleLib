abstract class _ConnectionStateContainerMetadata {
  static const String peripheralIdentifier = "peripheralIdentifier";
  static const String connectionState = "connectionState";
}

class ConnectionStateContainer {
  String peripheralIdentifier;
  String connectionState;

  ConnectionStateContainer.fromJson(Map<String, dynamic> json)
      : peripheralIdentifier =
            json[_ConnectionStateContainerMetadata.peripheralIdentifier],
        connectionState =
            json[_ConnectionStateContainerMetadata.connectionState];
}
