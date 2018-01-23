#import "FlutterBleLibPlugin.h"
#import "Methods.h"
#import "Namespace.h"
#import "BleData/Bledata.pbobjc.h"
#import "Converter.h"
#import <flutter_ble_lib/flutter_ble_lib-Swift.h>

@interface FlutterBleLibPlugin () <BleClientManagerDelegate>
@property(nonatomic) BleClientManager* manager;
@property(nonatomic) ScanDevicesHandler* scanDevicesHandler;
@property(nonatomic) BluetoothStateHandler* bluetoothStateHandler;
@property(nonatomic) DeviceConnectionChangedHandler* deviceConnectionChangedHandler;
@end

@interface ScanDevicesHandler ()
@property(nonatomic) FlutterEventSink scanDevicesSink;
@end

@interface BluetoothStateHandler ()
@property(nonatomic) FlutterEventSink bluetoothStateSink;
@end

@interface DeviceConnectionChangedHandler ()
@property(nonatomic) FlutterEventSink deviceConnectionChangedStateSink;
@end

@implementation FlutterBleLibPlugin


+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {

    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName: FBLFlutterBleLib
                                     binaryMessenger:[registrar messenger]];
    
    FlutterEventChannel* scanDevicesChannel = [FlutterEventChannel
                                               eventChannelWithName: FBLFlutterBleLibScanDevices
                                               binaryMessenger: [registrar messenger]];
    FlutterEventChannel* bluetoothStateChanel = [FlutterEventChannel
                                                 eventChannelWithName: FBLFlutterBleLibStateChange
                                                 binaryMessenger: [registrar messenger]];
    FlutterEventChannel* deviceConnectionChangedChannel = [FlutterEventChannel
                                                 eventChannelWithName: FBLFlutterBleLibDeviceConnectionChanged
                                                 binaryMessenger: [registrar messenger]];
    
    FlutterBleLibPlugin* instance = [[FlutterBleLibPlugin alloc] init];
    
    instance.scanDevicesHandler = [[ScanDevicesHandler alloc] init];
    instance.bluetoothStateHandler = [[BluetoothStateHandler alloc] init];
    instance.deviceConnectionChangedHandler = [[DeviceConnectionChangedHandler alloc] init];
    
    [registrar addMethodCallDelegate:instance channel:channel];
    
    [scanDevicesChannel setStreamHandler:instance.scanDevicesHandler];
    [bluetoothStateChanel setStreamHandler:instance.bluetoothStateHandler];
    [deviceConnectionChangedChannel setStreamHandler:instance.deviceConnectionChangedHandler];
}



- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
  if([FBLCreateClient isEqualToString:call.method]) {
      //TODO flutter should pass something here.
      [self createClient:nil];
  } else if([FBLDestroyClient isEqualToString:call.method]) {
      [self destroyClient];
  } else if([FBLSetLogLevel isEqualToString:call.method]) {
      [self setLogLevel:call.arguments];
  } else if([FBLCancelTransaction isEqualToString:call.method]) {
      [self cancelTransaction:call.arguments];
  } else if([FBLLogLevel isEqualToString:call.method]) {
      [self logLevel:result];
  } else if([FBLState isEqualToString:call.method]) {
      [self state:result];
  } else if([FBLStartDeviceScan isEqualToString:call.method]) {
      [self startDeviceScan:result];
  } else if([FBLStopDeviceScan isEqualToString:call.method]) {
      [self stopDeviceScan:result];
  } else if([FBLRequestMTUForDevice isEqualToString:call.method]) {
      //[self TBD];
  } else if([FBLReadRSSIForDevice isEqualToString:call.method]) {
      //[self TBD];
  } else if([FBLConnectToDevice isEqualToString:call.method]) {
      //[self TBD];
  } else if([FBLCancelDeviceConnection isEqualToString:call.method]) {
      //[self TBD];
  } else if([FBLIsDeviceConnected isEqualToString:call.method]) {
      //[self TBD];
  } else if([FBLDiscoverAllServicesAndCharacteristicsForDevice isEqualToString:call.method]) {
      //[self TBD];
  } else if([FBLServicesForDevice isEqualToString:call.method]) {
      //[self TBD];
  } else if([FBLCharacteristicsForDevice isEqualToString:call.method]) {
      //[self TBD];
  } else if([FBLCharacteristicsForService isEqualToString:call.method]) {
      //[self TBD];
  } else if([FBLWriteCharacteristicForDevice isEqualToString:call.method]) {
      //[self TBD];
  } else if([FBLWriteCharacteristic isEqualToString:call.method]) {
      //[self TBD];
  } else if([FBLReadCharacteristicForDevice isEqualToString:call.method]) {
      //[self TBD];
  } else if([FBLReadCharacteristicForService isEqualToString:call.method]) {
      //[self TBD];
  } else if([FBLReadCharacteristic isEqualToString:call.method]) {
      //[self TBD];
  } else if([FBLMonitorCharacteristicForDevice isEqualToString:call.method]) {
      //[self TBD];
  } else if([FBLMonitorCharacteristicForService isEqualToString:call.method]) {
      //[self TBD];
  } else if([FBLMonitorCharacteristic isEqualToString:call.method]) {
      //[self TBD];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)dispatchEvent:(NSString * _Nonnull)name value:(id _Nonnull)value {
    if([BleEvent.scanEvent isEqualToString: name]) {
        [_scanDevicesHandler handleScanDevice : [Converter convertToScanResultMessage:value]];
    }else  if([BleEvent.stateChangeEvent isEqualToString: name]) {
        [_bluetoothStateHandler handleBluetoothState:[Converter convertToBleDataBluetoothStateMessageFromString:value]];
    }
}

- (void)createClient:(NSString*)restoreIdentifierKey {
    _manager = [[BleClientManager alloc] initWithQueue:dispatch_get_main_queue()
                                  restoreIdentifierKey:restoreIdentifierKey];
     _manager.delegate = self;
}

- (void)destroyClient {
    [_manager invalidate];
    _manager = nil;
}

- (void)invalidate {
    [self destroyClient];
}

- (void)setLogLevel:(NSString*)logLevel {
    [_manager setLogLevel:[logLevel capitalizedString]];
}

- (void)cancelTransaction:(NSString*)transactionId {
    [_manager cancelTransaction:transactionId];
}

- (void)logLevel:(FlutterResult) result {
    [_manager logLevel:^(id _Nullable logLevel) {
        result(@([Converter convertToBleDataLogLevelMessage: (NSNumber*) logLevel]));
    }];
}

- (void)state: (FlutterResult) result {
    [_manager state:^(id _Nullable state) {
        result(@([Converter convertToBleDataBluetoothStateMessage: (NSNumber*) state]));
    } ];
}

- (void)startDeviceScan: (FlutterResult) result {
    [_manager startDeviceScan:nil options: nil];
    result(nil);
}

- (void)stopDeviceScan: (FlutterResult) result {
    [_manager stopDeviceScan];
    result(nil);
}
@end

@implementation ScanDevicesHandler
- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
    self.scanDevicesSink = eventSink;
    return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
    self.scanDevicesSink = nil;
    return nil;
}

- (void) handleScanDevice : (BleDataScanResultMessage*) scanResultMessage {
    if (self.scanDevicesSink != nil) {
        self.scanDevicesSink([FlutterStandardTypedData typedDataWithBytes:[scanResultMessage data]]);
    }
}
@end

@implementation BluetoothStateHandler
- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
    self.bluetoothStateSink = eventSink;
    return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
    self.bluetoothStateSink = nil;
    return nil;
}

- (void) handleBluetoothState : (BleDataBluetoothStateMessage) bleDataBluetoothStateMessage {
    if (self.bluetoothStateSink != nil) {
        self.bluetoothStateSink(@(bleDataBluetoothStateMessage));
    }
}
@end

@implementation DeviceConnectionChangedHandler
- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
    self.deviceConnectionChangedStateSink = eventSink;
    return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
    self.deviceConnectionChangedStateSink = nil;
    return nil;
}

- (void) handleDeviceConnectionState : (BleDataBleDeviceMessage*) bleDataBleDeviceMessage {
    if (self.deviceConnectionChangedStateSink != nil) {
        self.deviceConnectionChangedStateSink(bleDataBleDeviceMessage);
    }
}
@end
