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
@property(nonatomic) DeviceConnectionChangeHandler* deviceConnectionChangeHandler;
@property(nonatomic) MonitorCharacteristicHandler* monitorCharacteristicHandler;
@end

@interface ScanDevicesHandler ()
@property(nonatomic) FlutterEventSink scanDevicesSink;
@end

@interface BluetoothStateHandler ()
@property(nonatomic) FlutterEventSink bluetoothStateSink;
@end

@interface DeviceConnectionChangeHandler ()
@property(nonatomic) FlutterEventSink deviceConnectionChangeStateSink;
@end

@interface MonitorCharacteristicHandler ()
@property(nonatomic) FlutterEventSink monitorCharacteristicHandlerSink;
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
    FlutterEventChannel* deviceConnectionChangeChannel = [FlutterEventChannel
                                                 eventChannelWithName: FBLFlutterBleLibDeviceConnectionChange
                                                 binaryMessenger: [registrar messenger]];
    FlutterEventChannel* monitorCharacteristicChannel = [FlutterEventChannel
                                                          eventChannelWithName: FBLFlutterBleLibMonitorCharacteristicChange
                                                          binaryMessenger: [registrar messenger]];
    FlutterBleLibPlugin* instance = [[FlutterBleLibPlugin alloc] init];
    
    instance.scanDevicesHandler = [[ScanDevicesHandler alloc] init];
    instance.bluetoothStateHandler = [[BluetoothStateHandler alloc] init];
    instance.deviceConnectionChangeHandler = [[DeviceConnectionChangeHandler alloc] init];
    instance.monitorCharacteristicHandler = [[MonitorCharacteristicHandler alloc] init];
    
    [registrar addMethodCallDelegate:instance channel:channel];
    
    [scanDevicesChannel setStreamHandler:instance.scanDevicesHandler];
    [bluetoothStateChanel setStreamHandler:instance.bluetoothStateHandler];
    [deviceConnectionChangeChannel setStreamHandler:instance.deviceConnectionChangeHandler];
    [monitorCharacteristicChannel setStreamHandler:instance.monitorCharacteristicHandler];
}



- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
  if([FBLCreateClient isEqualToString:call.method]) {
      //TODO flutter should pass something here.
      [self createClient:nil result:result];
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
      [self startDeviceScan:call result:result];
  } else if([FBLStopDeviceScan isEqualToString:call.method]) {
      [self stopDeviceScan:result];
  } else if([FBLRequestMTUForDevice isEqualToString:call.method]) {
      [self requestMTUForDevice:call result:result];
  } else if([FBLReadRSSIForDevice isEqualToString:call.method]) {
      [self readRSSIForDevice:call result:result];
  } else if([FBLConnectToDevice isEqualToString:call.method]) {
      [self connectToDevice:call.arguments result:result];
  } else if([FBLCancelDeviceConnection isEqualToString:call.method]) {
      [self cancelDeviceConnection:call.arguments result:result];
  } else if([FBLIsDeviceConnected isEqualToString:call.method]) {
      [self isDeviceConnected:call.arguments result:result];
  } else if([FBLDiscoverAllServicesAndCharacteristicsForDevice isEqualToString:call.method]) {
      [self discoverAllServicesAndCharacteristicsForDevice:call.arguments result:result];
  } else if([FBLServicesForDevice isEqualToString:call.method]) {
      [self servicesForDevice:call.arguments result:result];
  } else if([FBLCharacteristicsForDevice isEqualToString:call.method]) {
      [self characteristicsForDevice:call result:result];
  } else if([FBLCharacteristicsForService isEqualToString:call.method]) {
      [self characteristicsForService:call result:result];
  } else if([FBLWriteCharacteristicForDevice isEqualToString:call.method]) {
      [self writeCharacteristicForDevice:call result:result];
  } else if([FBLWriteCharacteristicForService isEqualToString:call.method]) {
      [self writeCharacteristicForService:call result:result];
  } else if([FBLWriteCharacteristic isEqualToString:call.method]) {
      [self writeCharacteristic:call result:result];
  } else if([FBLReadCharacteristicForDevice isEqualToString:call.method]) {
      [self readCharacteristicForDevice:call result:result];
  } else if([FBLReadCharacteristicForService isEqualToString:call.method]) {
      [self readCharacteristicForService:call result:result];
  } else if([FBLReadCharacteristic isEqualToString:call.method]) {
      [self readCharacteristic:call result:result];
  } else if([FBLMonitorCharacteristicForDevice isEqualToString:call.method]) {
      [self monitorCharacteristicForDevice:call result:result];
  } else if([FBLMonitorCharacteristicForService isEqualToString:call.method]) {
      [self monitorCharacteristicForService:call result:result];
  } else if([FBLMonitorCharacteristic isEqualToString:call.method]) {
      [self monitorCharacteristic:call result:result];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)dispatchEvent:(NSString * _Nonnull)name value:(id _Nonnull)value {
    if([BleEvent.scanEvent isEqualToString: name]) {
        [_scanDevicesHandler handleScanDevice : [Converter convertToScanResultMessage:value]];
    } else if([BleEvent.stateChangeEvent isEqualToString: name]) {
        [_bluetoothStateHandler handleBluetoothState:[Converter convertToBleDataBluetoothStateMessageFromString:value]];
    } else if([BleEvent.disconnectionEvent isEqualToString: name]) {
         [_deviceConnectionChangeHandler handleDeviceConnectionState:[Converter convertToBleDeviceMessage:value[1]]];
    } else if([BleEvent.readEvent isEqualToString: name]) {
        [_monitorCharacteristicHandler handleMonitorCharacteristic:[Converter conevrtToMonitorCharacteristicMessage:value]];
    }
}

- (void)createClient:(NSString*)restoreIdentifierKey  result: (FlutterResult) result  {
    _manager = [[BleClientManager alloc] initWithQueue:dispatch_get_main_queue()
                                  restoreIdentifierKey:restoreIdentifierKey];
     _manager.delegate = self;
    result(nil);
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

- (void)startDeviceScan: (FlutterMethodCall *) methodData result:(FlutterResult) result {
    NSData *data = [((FlutterStandardTypedData *) methodData.arguments) data];
    BleDataScanDataMessage* scanData = [BleDataScanDataMessage parseFromData:data error: nil];
    [_manager startDeviceScan:[scanData.uuidsArray copy] options: nil];
    result(nil);
}

- (void)stopDeviceScan: (FlutterResult) result {
    [_manager stopDeviceScan];
    result(nil);
}

- (void) connectToDevice:(FlutterStandardTypedData*) device result: (FlutterResult) result {
    
    NSError *error = nil;
    [_manager
     connectToDevice:[[[BleDataBleDeviceMessage alloc] initWithData:[device data] error: &error] id_p]
     options:nil
     resolve:^(id _Nullable device) {
         BleDataBleDeviceMessage* bleDeviceMessage = [Converter convertToBleDeviceMessage: device];
         result([FlutterStandardTypedData typedDataWithBytes:[bleDeviceMessage data]]);
     }
     reject:^(NSString * _Nullable code, NSString * _Nullable message, NSError * _Nullable error) {
         result([FlutterError errorWithCode:code message:message details:@"connectToDevice method"]);
     }
    ];
    if(error != nil) {
        NSString *errorCodeAsString = [NSString stringWithFormat: @"%ld", (long)error.code ];
        result([FlutterError errorWithCode : errorCodeAsString message :@"Could not parse data" details:error.localizedDescription]);
    }
   
}

-(void) isDeviceConnected: (NSString *) deviceId result:(FlutterResult) result {
    [_manager isDeviceConnected:deviceId resolve:^(id _Nullable isConnected) {
        result(isConnected);
    } reject:^(NSString * _Nullable code, NSString * _Nullable message, NSError * _Nullable error) {
        result([FlutterError errorWithCode:code message:message details:@"connectToDevice method"]);
    }];
}

-(void) requestMTUForDevice: (FlutterMethodCall *) methodData result:(FlutterResult) result {
    NSString* deviceId = methodData.arguments[@"deviceId"];
    NSNumber* mtu = methodData.arguments[@"mtu"];
    NSString* transactionId = methodData.arguments[@"transactionId"];
    [_manager requestMTUForDevice:deviceId mtu:mtu transactionId:transactionId resolve:^(id _Nullable device) {
        BleDataBleDeviceMessage* bleDeviceMessage = [Converter convertToBleDeviceMessage: device];
        result([FlutterStandardTypedData typedDataWithBytes:[bleDeviceMessage data]]);
    } reject:^(NSString * _Nullable code, NSString * _Nullable message, NSError * _Nullable error) {
        result([FlutterError errorWithCode:code message:message details:@"requestMTUForDevice method"]);
    }];
}

-(void) readRSSIForDevice: (FlutterMethodCall *) methodData result:(FlutterResult) result {
    NSString* deviceId = methodData.arguments[@"deviceId"];
    NSString* transactionId = methodData.arguments[@"transactionId"];
    [_manager readRSSIForDevice:deviceId transactionId:transactionId resolve:^(id _Nullable device) {
        BleDataBleDeviceMessage* bleDeviceMessage = [Converter convertToBleDeviceMessage: device];
        result([FlutterStandardTypedData typedDataWithBytes:[bleDeviceMessage data]]);
    } reject:^(NSString * _Nullable code, NSString * _Nullable message, NSError * _Nullable error) {
        result([FlutterError errorWithCode:code message:message details:@"readRSSIForDevice method"]);
    }];
}

-(void) cancelDeviceConnection: (NSString *) deviceId result:(FlutterResult) result {
    [_manager cancelDeviceConnection :deviceId resolve:^(id _Nullable device) {
        BleDataBleDeviceMessage* bleDeviceMessage = [Converter convertToBleDeviceMessage: device];
        result([FlutterStandardTypedData typedDataWithBytes:[bleDeviceMessage data]]);
    } reject:^(NSString * _Nullable code, NSString * _Nullable message, NSError * _Nullable error) {
        result([FlutterError errorWithCode:code message:message details:@"cancelDeviceConnection method"]);
    }];
}

-(void) discoverAllServicesAndCharacteristicsForDevice: (NSString *) deviceId result:(FlutterResult) result {
    [_manager discoverAllServicesAndCharacteristicsForDevice :deviceId resolve:^(id _Nullable device) {
        BleDataBleDeviceMessage* bleDeviceMessage = [Converter convertToBleDeviceMessage: device];
        result([FlutterStandardTypedData typedDataWithBytes:[bleDeviceMessage data]]);
    } reject:^(NSString * _Nullable code, NSString * _Nullable message, NSError * _Nullable error) {
        result([FlutterError errorWithCode:code message:message details:@"discoverAllServicesAndCharacteristicsForDevice method"]);
    }];
}

-(void) servicesForDevice: (NSString *) deviceId result:(FlutterResult) result {
    [_manager servicesForDevice :deviceId resolve:^(id _Nullable services) {
        BleDataServiceMessages * bleDataServiceMessages = [Converter convertToBleDataServiceMessages: services];
        result([FlutterStandardTypedData typedDataWithBytes:[bleDataServiceMessages data]]);
    } reject:^(NSString * _Nullable code, NSString * _Nullable message, NSError * _Nullable error) {
        result([FlutterError errorWithCode:code message:message details:@"servicesForDevice method"]);
    }];
}

-(void) characteristicsForDevice: (FlutterMethodCall *) methodData result:(FlutterResult) result {
    NSString* deviceId = methodData.arguments[@"deviceId"];
    NSString* serviceUUID = methodData.arguments[@"serviceUUID"];
    [_manager characteristicsForDevice:deviceId serviceUUID:serviceUUID resolve:^(id _Nullable characteristics) {
        BleDataCharacteristicMessages* bleDataCharacteristicMessages = [Converter convertToBleDataCharacteristicMessages: characteristics];
        result([FlutterStandardTypedData typedDataWithBytes:[bleDataCharacteristicMessages data]]);
    } reject:^(NSString * _Nullable code, NSString * _Nullable message, NSError * _Nullable error) {
        result([FlutterError errorWithCode:code message:message details:@"characteristicsForDevice method"]);
    }];
}

-(void) characteristicsForService: (FlutterMethodCall *) methodData result:(FlutterResult) result {
    NSNumber* serviceIdentifier = methodData.arguments[@"serviceIdentifier"];
    [_manager characteristicsForService:serviceIdentifier.doubleValue resolve:^(id _Nullable characteristics) {
        BleDataCharacteristicMessages* bleDataCharacteristicMessages = [Converter convertToBleDataCharacteristicMessages: characteristics];
        result([FlutterStandardTypedData typedDataWithBytes:[bleDataCharacteristicMessages data]]);
    } reject:^(NSString * _Nullable code, NSString * _Nullable message, NSError * _Nullable error) {
        result([FlutterError errorWithCode:code message:message details:@"characteristicsForService method"]);
    }];
}

-(void) writeCharacteristicForDevice: (FlutterMethodCall *) methodData result:(FlutterResult) result {
    NSString* deviceId = methodData.arguments[@"deviceId"];
    NSString* serviceUUID = methodData.arguments[@"serviceUUID"];
    NSString* characteristicUUID = methodData.arguments[@"characteristicUUID"];
    NSString* valueBase64 = methodData.arguments[@"valueBase64"];
    BOOL response = methodData.arguments[@"response"];
    NSString* transactionId = methodData.arguments[@"transactionId"];
    [_manager writeCharacteristicForDevice:deviceId serviceUUID:serviceUUID characteristicUUID:characteristicUUID valueBase64:valueBase64
                                  response:response transactionId:transactionId
                                   resolve:^(id _Nullable characteristic) {
                                       BleDataCharacteristicMessage* bleDataCharacteristicMessage = [Converter convertToBleDataCharacteristicMessage: characteristic];
                                       result([FlutterStandardTypedData typedDataWithBytes:[bleDataCharacteristicMessage data]]);
                                   } reject:^(NSString * _Nullable code, NSString * _Nullable message, NSError * _Nullable error) {
                                       result([FlutterError errorWithCode:code message:message details:@"writeCharacteristicForDevice method"]);
                                   }];
}
-(void) writeCharacteristicForService: (FlutterMethodCall *) methodData result:(FlutterResult) result {
    NSNumber* serviceIdentifier = methodData.arguments[@"serviceIdentifier"];
    NSString* characteristicUUID = methodData.arguments[@"characteristicUUID"];
    NSString* valueBase64 = methodData.arguments[@"valueBase64"];
    BOOL response = methodData.arguments[@"response"];
    NSString* transactionId = methodData.arguments[@"transactionId"];
    [_manager writeCharacteristicForService:serviceIdentifier.doubleValue characteristicUUID:characteristicUUID valueBase64:valueBase64
                                  response:response transactionId:transactionId
                                   resolve:^(id _Nullable characteristic) {
                                       BleDataCharacteristicMessage* bleDataCharacteristicMessage = [Converter convertToBleDataCharacteristicMessage: characteristic];
                                       result([FlutterStandardTypedData typedDataWithBytes:[bleDataCharacteristicMessage data]]);
                                   } reject:^(NSString * _Nullable code, NSString * _Nullable message, NSError * _Nullable error) {
                                       result([FlutterError errorWithCode:code message:message details:@"writeCharacteristicForService method"]);
                                   }];
}

-(void) writeCharacteristic: (FlutterMethodCall *) methodData result:(FlutterResult) result {
    NSNumber* characteristicIdentifier = methodData.arguments[@"characteristicIdentifier"];
    NSString* valueBase64 = methodData.arguments[@"valueBase64"];
    BOOL response = methodData.arguments[@"response"];
    NSString* transactionId = methodData.arguments[@"transactionId"];
    [_manager writeCharacteristic:characteristicIdentifier.doubleValue valueBase64:valueBase64 response:response transactionId:transactionId
                                    resolve:^(id _Nullable characteristic) {
                                        BleDataCharacteristicMessage* bleDataCharacteristicMessage = [Converter convertToBleDataCharacteristicMessage: characteristic];
                                        result([FlutterStandardTypedData typedDataWithBytes:[bleDataCharacteristicMessage data]]);
                                    } reject:^(NSString * _Nullable code, NSString * _Nullable message, NSError * _Nullable error) {
                                        result([FlutterError errorWithCode:code message:message details:@"writeCharacteristic method"]);
                                    }];
}

-(void) readCharacteristicForDevice: (FlutterMethodCall *) methodData result:(FlutterResult) result {
    NSString* deviceId = methodData.arguments[@"deviceId"];
    NSString* serviceUUID = methodData.arguments[@"serviceUUID"];
    NSString* characteristicUUID = methodData.arguments[@"characteristicUUID"];
    NSString* transactionId = methodData.arguments[@"transactionId"];
    [_manager readCharacteristicForDevice:deviceId serviceUUID:serviceUUID characteristicUUID:characteristicUUID transactionId:transactionId
                                   resolve:^(id _Nullable characteristic) {
                                       BleDataCharacteristicMessage* bleDataCharacteristicMessage = [Converter convertToBleDataCharacteristicMessage: characteristic];
                                       result([FlutterStandardTypedData typedDataWithBytes:[bleDataCharacteristicMessage data]]);
                                   } reject:^(NSString * _Nullable code, NSString * _Nullable message, NSError * _Nullable error) {
                                       result([FlutterError errorWithCode:code message:message details:@"writeCharacteristicForDevice method"]);
                                   }];
}

-(void) readCharacteristicForService: (FlutterMethodCall *) methodData result:(FlutterResult) result {
    NSNumber* serviceIdentifier = methodData.arguments[@"serviceIdentifier"];
    NSString* characteristicUUID = methodData.arguments[@"characteristicUUID"];
    NSString* transactionId = methodData.arguments[@"transactionId"];
    [_manager readCharacteristicForService:serviceIdentifier.doubleValue characteristicUUID:characteristicUUID transactionId:transactionId
                                  resolve:^(id _Nullable characteristic) {
                                      BleDataCharacteristicMessage* bleDataCharacteristicMessage = [Converter convertToBleDataCharacteristicMessage: characteristic];
                                      result([FlutterStandardTypedData typedDataWithBytes:[bleDataCharacteristicMessage data]]);
                                  } reject:^(NSString * _Nullable code, NSString * _Nullable message, NSError * _Nullable error) {
                                      result([FlutterError errorWithCode:code message:message details:@"writeCharacteristicForDevice method"]);
                                  }];
}

-(void) readCharacteristic: (FlutterMethodCall *) methodData result:(FlutterResult) result {
    NSNumber* characteristicIdentifier = methodData.arguments[@"characteristicIdentifier"];
    NSString* transactionId = methodData.arguments[@"transactionId"];
    [_manager readCharacteristic:characteristicIdentifier.doubleValue transactionId:transactionId
                                   resolve:^(id _Nullable characteristic) {
                                       BleDataCharacteristicMessage* bleDataCharacteristicMessage = [Converter convertToBleDataCharacteristicMessage: characteristic];
                                       result([FlutterStandardTypedData typedDataWithBytes:[bleDataCharacteristicMessage data]]);
                                   } reject:^(NSString * _Nullable code, NSString * _Nullable message, NSError * _Nullable error) {
                                       result([FlutterError errorWithCode:code message:message details:@"writeCharacteristicForDevice method"]);
                                   }];
}

-(void) monitorCharacteristicForDevice: (FlutterMethodCall *) methodData result:(FlutterResult) result {
    NSString* deviceId = methodData.arguments[@"deviceId"];
    NSString* serviceUUID = methodData.arguments[@"serviceUUID"];
    NSString* characteristicUUID = methodData.arguments[@"characteristicUUID"];
    NSString* transactionId = methodData.arguments[@"transactionId"];
    [_manager monitorCharacteristicForDevice:deviceId serviceUUID:serviceUUID characteristicUUID:characteristicUUID transactionId:transactionId
                         resolve:^(id _Nullable characteristic) {
                             result(nil);
                         } reject:^(NSString * _Nullable code, NSString * _Nullable message, NSError * _Nullable error) {
                             result([FlutterError errorWithCode:code message:message details:@"writeCharacteristicForDevice method"]);
                         }];
}

-(void) monitorCharacteristicForService: (FlutterMethodCall *) methodData result:(FlutterResult) result {
    NSString* deviceId = methodData.arguments[@"deviceId"];
    NSString* serviceUUID = methodData.arguments[@"serviceUUID"];
    NSString* characteristicUUID = methodData.arguments[@"characteristicUUID"];
    NSString* transactionId = methodData.arguments[@"transactionId"];
    [_manager monitorCharacteristicForDevice:deviceId serviceUUID:serviceUUID characteristicUUID:characteristicUUID transactionId:transactionId
                                     resolve:^(id _Nullable characteristic) {
                                         result(nil);
                                     } reject:^(NSString * _Nullable code, NSString * _Nullable message, NSError * _Nullable error) {
                                         result([FlutterError errorWithCode:code message:message details:@"writeCharacteristicForDevice method"]);
                                     }];
}

-(void) monitorCharacteristic: (FlutterMethodCall *) methodData result:(FlutterResult) result {
    NSString* deviceId = methodData.arguments[@"deviceId"];
    NSString* serviceUUID = methodData.arguments[@"serviceUUID"];
    NSString* characteristicUUID = methodData.arguments[@"characteristicUUID"];
    NSString* transactionId = methodData.arguments[@"transactionId"];
    [_manager monitorCharacteristicForDevice:deviceId serviceUUID:serviceUUID characteristicUUID:characteristicUUID transactionId:transactionId
                                     resolve:^(id _Nullable characteristic) {
                                         result(nil);
                                     } reject:^(NSString * _Nullable code, NSString * _Nullable message, NSError * _Nullable error) {
                                         result([FlutterError errorWithCode:code message:message details:@"writeCharacteristicForDevice method"]);
                                     }];
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

@implementation DeviceConnectionChangeHandler
- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
    self.deviceConnectionChangeStateSink = eventSink;
    return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
    self.deviceConnectionChangeStateSink = nil;
    return nil;
}

- (void) handleDeviceConnectionState : (BleDataBleDeviceMessage*) bleDataBleDeviceMessage {
    if (self.deviceConnectionChangeStateSink != nil) {
        self.deviceConnectionChangeStateSink([FlutterStandardTypedData typedDataWithBytes:[bleDataBleDeviceMessage data]]);
    }
}
@end

@implementation MonitorCharacteristicHandler
- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
    self.monitorCharacteristicHandlerSink = eventSink;
    return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
    self.monitorCharacteristicHandlerSink = nil;
    return nil;
}

- (void) handleMonitorCharacteristic : (BleDataMonitorCharacteristicMessage*) bleDataMonitorCharacteristicMessage {
    if (self.monitorCharacteristicHandlerSink != nil) {
        self.monitorCharacteristicHandlerSink([FlutterStandardTypedData typedDataWithBytes:[bleDataMonitorCharacteristicMessage data]]);
    }
}
@end
