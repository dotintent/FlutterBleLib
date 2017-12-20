///
//  Generated code. Do not modify.
///
// ignore_for_file: non_constant_identifier_names,library_prefixes
library bledata_pbjson;

const LogLevelMessage$json = const {
  '1': 'LogLevelMessage',
  '2': const [
    const {'1': 'VERBOSE', '2': 0},
    const {'1': 'DEBUG', '2': 1},
    const {'1': 'INFO', '2': 2},
    const {'1': 'WARNING', '2': 3},
    const {'1': 'ERROR', '2': 4},
    const {'1': 'NONE', '2': 5},
  ],
};

const BluetoothStateMessage$json = const {
  '1': 'BluetoothStateMessage',
  '2': const [
    const {'1': 'UNKNOWN', '2': 0},
    const {'1': 'RESETTING', '2': 1},
    const {'1': 'UNSUPPORTED', '2': 2},
    const {'1': 'UNAUTHORIZED', '2': 3},
    const {'1': 'POWERED_OFF', '2': 4},
    const {'1': 'POWERED_ON', '2': 5},
  ],
};

const ScanSettingsMessage$json = const {
  '1': 'ScanSettingsMessage',
  '2': const [
    const {'1': 'scanMode', '3': 1, '4': 1, '5': 5, '10': 'scanMode'},
    const {'1': 'callbackType', '3': 2, '4': 1, '5': 5, '10': 'callbackType'},
  ],
};

const ScanFilterMessage$json = const {
  '1': 'ScanFilterMessage',
  '2': const [
    const {'1': 'deviceName', '3': 1, '4': 1, '5': 9, '10': 'deviceName'},
    const {'1': 'deviceAddress', '3': 2, '4': 1, '5': 9, '10': 'deviceAddress'},
    const {'1': 'serviceUuid', '3': 3, '4': 1, '5': 9, '10': 'serviceUuid'},
    const {'1': 'serviceUuidMask', '3': 4, '4': 1, '5': 9, '10': 'serviceUuidMask'},
    const {'1': 'serviceDataUuid', '3': 5, '4': 1, '5': 9, '10': 'serviceDataUuid'},
    const {'1': 'serviceData', '3': 6, '4': 1, '5': 12, '10': 'serviceData'},
    const {'1': 'serviceDataMask', '3': 7, '4': 1, '5': 12, '10': 'serviceDataMask'},
    const {'1': 'manufacturerId', '3': 8, '4': 1, '5': 5, '10': 'manufacturerId'},
    const {'1': 'manufacturerData', '3': 9, '4': 1, '5': 12, '10': 'manufacturerData'},
    const {'1': 'manufacturerDataMask', '3': 10, '4': 1, '5': 12, '10': 'manufacturerDataMask'},
  ],
};

const BleDeviceMessage$json = const {
  '1': 'BleDeviceMessage',
  '2': const [
    const {'1': 'macAddress', '3': 1, '4': 1, '5': 9, '10': 'macAddress'},
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
  ],
};

const ScanResultMessage$json = const {
  '1': 'ScanResultMessage',
  '2': const [
    const {'1': 'bleDeviceMessage', '3': 1, '4': 1, '5': 11, '6': '.BleDeviceMessage', '10': 'bleDeviceMessage'},
    const {'1': 'rssi', '3': 2, '4': 1, '5': 5, '10': 'rssi'},
    const {'1': 'timestampNanos', '3': 3, '4': 1, '5': 4, '10': 'timestampNanos'},
    const {'1': 'scanCallbackTypeMessage', '3': 4, '4': 1, '5': 5, '10': 'scanCallbackTypeMessage'},
  ],
};

const ConnectToDeviceDataMessage$json = const {
  '1': 'ConnectToDeviceDataMessage',
  '2': const [
    const {'1': 'macAddress', '3': 1, '4': 1, '5': 9, '10': 'macAddress'},
    const {'1': 'isAutoConnect', '3': 2, '4': 1, '5': 8, '10': 'isAutoConnect'},
    const {'1': 'requestMtu', '3': 3, '4': 1, '5': 5, '10': 'requestMtu'},
  ],
};

const ConnectedDeviceMessage$json = const {
  '1': 'ConnectedDeviceMessage',
  '2': const [
    const {'1': 'deviceMessage', '3': 1, '4': 1, '5': 11, '6': '.BleDeviceMessage', '10': 'deviceMessage'},
    const {'1': 'rssi', '3': 2, '4': 1, '5': 5, '10': 'rssi'},
    const {'1': 'mtu', '3': 3, '4': 1, '5': 5, '10': 'mtu'},
  ],
};

