#import <Flutter/Flutter.h>
#import "Bledata.pbobjc.h"

@interface FlutterBleLibPlugin : NSObject<FlutterPlugin>
@end

@interface ScanDevicesHandler : NSObject<FlutterStreamHandler>

- (void) handleScanDevice : (BleDataScanResultMessage*) scanResultMessage;

@end

@interface BluetoothStateHandler : NSObject<FlutterStreamHandler>

- (void) handleBluetoothState : (BleDataBluetoothStateMessage) bleDataBluetoothStateMessage;

@end

@interface DeviceConnectionChangeHandler : NSObject<FlutterStreamHandler>

- (void) handleDeviceConnectionState : (BleDataBleDeviceMessage*) bleDataBleDeviceMessage;

@end
