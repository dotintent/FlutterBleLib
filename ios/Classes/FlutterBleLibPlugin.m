#import "FlutterBleLibPlugin.h"
#import <flutter_ble_lib-Swift.h>
#import "Constants/ArgumentKey.h"
#import "Constants/ChannelName.h"
#import "Constants/MethodName.h"
#import "Event/AdapterStateStreamHandler.h"
#import "Event/RestoreStateStreamHandler.h"
#import "Event/ScanningStreamHandler.h"
#import "Event/ConnectionStateStreamHandler.h"
#import "Util/ArgumentValidator.h"
#import "Util/FlutterErrorFactory.h"
#import "Util/JSONStringifier.h"

typedef void (^Resolve)(id result);
typedef void (^Reject)(NSString *code, NSString *message, NSError *error);

@interface FlutterBleLibPlugin () <BleClientManagerDelegate>

@property (nonatomic) BleClientManager *manager;
@property (nonatomic) AdapterStateStreamHandler *adapterStateStreamHandler;
@property (nonatomic) RestoreStateStreamHandler *restoreStateStreamHandler;
@property (nonatomic) ScanningStreamHandler *scanningStreamHandler;
@property (nonatomic) ConnectionStateStreamHandler *connectionStateStreamHandler;

@end

@implementation FlutterBleLibPlugin

// MARK: - Initializers

- (instancetype)init {
    self = [super init];
    if (self) {
        self.adapterStateStreamHandler = [AdapterStateStreamHandler new];
        self.restoreStateStreamHandler = [RestoreStateStreamHandler new];
        self.scanningStreamHandler = [ScanningStreamHandler new];
        self.connectionStateStreamHandler = [ConnectionStateStreamHandler new];
    }
    return self;
}

// MARK: - FlutterPlugin implementation

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:CHANNEL_NAME_FLUTTER_BLE_LIB binaryMessenger:[registrar messenger]];

    FlutterEventChannel *adapterStateChannel = [FlutterEventChannel eventChannelWithName:CHANNEL_NAME_ADAPTER_STATE_CHANGES binaryMessenger:[registrar messenger]];
    FlutterEventChannel *restoreStateChannel = [FlutterEventChannel eventChannelWithName:CHANNEL_NAME_STATE_RESTORE_EVENTS binaryMessenger:[registrar messenger]];
    FlutterEventChannel *scanningChannel = [FlutterEventChannel eventChannelWithName:CHANNEL_NAME_SCANNING_EVENTS binaryMessenger:[registrar messenger]];
    FlutterEventChannel *connectionStateChannel = [FlutterEventChannel eventChannelWithName:CHANNEL_NAME_CONNECTION_STATE_CHANGE_EVENTS binaryMessenger:[registrar messenger]];

    FlutterBleLibPlugin *instance = [[FlutterBleLibPlugin alloc] init];
    
    [registrar addMethodCallDelegate:instance channel:channel];

    [adapterStateChannel setStreamHandler:instance.adapterStateStreamHandler];
    [restoreStateChannel setStreamHandler:instance.restoreStateStreamHandler];
    [scanningChannel setStreamHandler:instance.scanningStreamHandler];
    [connectionStateChannel setStreamHandler:instance.connectionStateStreamHandler];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([METHOD_NAME_CREATE_CLIENT isEqualToString:call.method]) {
        [self createClient:call result:result];
    } else if ([METHOD_NAME_START_DEVICE_SCAN isEqualToString:call.method]) {
        [self startDeviceScan:call result:result];
    } else if ([METHOD_NAME_STOP_DEVICE_SCAN isEqualToString:call.method]) {
        [self stopDeviceScan:result];
    } else if ([METHOD_NAME_CONNECT_TO_DEVICE isEqualToString:call.method]) {
        [self connectToDevice:call result:result];
    } else if ([METHOD_NAME_CANCEL_CONNECTION isEqualToString:call.method]) {
        [self cancelDeviceConnection:call result:result];
    } else if ([METHOD_NAME_IS_DEVICE_CONNECTED isEqualToString:call.method]) {
        [self isDeviceConnected:call result:result];
    } else if ([METHOD_NAME_SET_LOG_LEVEL isEqualToString:call.method]) {
        [self setLogLevel:call result:result];
    } else if ([METHOD_NAME_LOG_LEVEL isEqualToString:call.method]) {
        [self logLevel:call result:result];
    } else if ([METHOD_NAME_GET_SERVICES isEqualToString:call.method]) {
        [self servicesForDevice:call result:result];
    } else if ([METHOD_NAME_DISCOVER_ALL_SERVICES_AND_CHARACTERISTICS isEqualToString:call.method]) {
        [self discoverAllServicesAndCharacteristicsForDevice:call result:result];
    } else if ([METHOD_NAME_GET_CHARACTERISTICS_FOR_SERVICE isEqualToString:call.method]) {
        [self characteristicsForService:call result:result];
    } else if ([METHOD_NAME_GET_CHARACTERISTICS isEqualToString:call.method]) {
        [self characteristics:call result:result];
    } else if ([METHOD_NAME_READ_CHARACTERISTIC_FOR_DEVICE isEqualToString:call.method]) {
        [self readCharacteristicForDevice:call result:result];
    } else if ([METHOD_NAME_READ_CHARACTERISTIC_FOR_SERVICE isEqualToString:call.method]) {
        [self readCharacteristicForService:call result:result];
    } else if ([METHOD_NAME_READ_CHARACTERISTIC_FOR_IDENTIFIER isEqualToString:call.method]) {
        [self readCharacteristic:call result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

// MARK: - MBA Methods - BleClient lifecycle

- (void)createClient:(FlutterMethodCall *)call result:(FlutterResult)result {
    _manager = [[BleClientManager alloc] initWithQueue:dispatch_get_main_queue()
                                  restoreIdentifierKey:[ArgumentValidator validStringOrNil:call.arguments[ARGUMENT_KEY_RESTORE_STATE_IDENTIFIER]]];
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

// MARK: - MBA Methods - Scanning

- (void)startDeviceScan:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSArray* expectedArguments = [NSArray arrayWithObjects:ARGUMENT_KEY_SCAN_MODE, nil];
    [_manager startDeviceScan:[ArgumentValidator validStringArrayOrNil:call.arguments[ARGUMENT_KEY_UUIDS]]
                      options:[ArgumentValidator validDictionaryOrNil:expectedArguments in:call.arguments]];
    result(nil);
}

- (void)stopDeviceScan:(FlutterResult)result {
    [_manager stopDeviceScan];
    [self.scanningStreamHandler onComplete];
    result(nil);
}

// MARK: - MBA Methods - Connection

- (void)connectToDevice:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSArray* expectedArguments = [NSArray arrayWithObjects:ARGUMENT_KEY_TIMEOUT_MILLIS, nil];
    [_manager connectToDevice:call.arguments[ARGUMENT_KEY_DEVICE_IDENTIFIER]
                      options:[ArgumentValidator validDictionaryOrNil:expectedArguments in:call.arguments]
                      resolve:result
                       reject:[self rejectForFlutterResult:result]];
}

- (void)cancelDeviceConnection:(FlutterMethodCall *)call result:(FlutterResult)result {
    [_manager cancelDeviceConnection:call.arguments[ARGUMENT_KEY_DEVICE_IDENTIFIER]
                             resolve:result
                              reject:[self rejectForFlutterResult:result]];
}

- (void)isDeviceConnected:(FlutterMethodCall *)call result:(FlutterResult)result {
    [_manager isDeviceConnected:call.arguments[ARGUMENT_KEY_DEVICE_IDENTIFIER]
                        resolve:result
                         reject:[self rejectForFlutterResult:result]];

}

// MARK: - MBA Methods - Log Level

- (void)setLogLevel:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *logLevel = call.arguments[ARGUMENT_KEY_LOG_LEVEL];
    [_manager setLogLevel:[logLevel capitalizedString]];
    result(nil);
}

- (void)logLevel:(FlutterMethodCall *)call result:(FlutterResult)result {
    [_manager logLevel:result
                reject:[self rejectForFlutterResult:result]];
}

// MARK: - MBA Methods - Discovery

- (void)servicesForDevice:(FlutterMethodCall *)call result:(FlutterResult)result {
    [_manager servicesForDevice:call.arguments[ARGUMENT_KEY_DEVICE_IDENTIFIER]
                        resolve:[self resolveForServicesForDevice:result]
                         reject:[self rejectForFlutterResult:result]];
}

- (void)discoverAllServicesAndCharacteristicsForDevice:(FlutterMethodCall *)call result:(FlutterResult)result {
    [_manager discoverAllServicesAndCharacteristicsForDevice:call.arguments[ARGUMENT_KEY_DEVICE_IDENTIFIER]
                                               transactionId:[ArgumentValidator validStringOrNil:call.arguments[ARGUMENT_KEY_TRANSACTION_ID]]
                                                     resolve:result
                                                      reject:[self rejectForFlutterResult:result]];
}

- (void)characteristicsForService:(FlutterMethodCall *)call result:(FlutterResult)result {
    [_manager characteristicsForService:[call.arguments[ARGUMENT_KEY_SERVICE_ID] doubleValue]
                                resolve:[self resolveForCharacteristicsForService:result]
                                 reject:[self rejectForFlutterResult:result]];
}

- (void)characteristics:(FlutterMethodCall *)call result:(FlutterResult)result {
    [_manager servicesForDevice:call.arguments[ARGUMENT_KEY_DEVICE_IDENTIFIER]
                        resolve:[self resolveForCharacteristics:result
                                                    serviceUuid:call.arguments[ARGUMENT_KEY_SERVICE_UUID]]
                         reject:[self rejectForFlutterResult:result]];
}

// MARK: - MBA Methods - Characteristics observation

- (void)readCharacteristicForDevice:(FlutterMethodCall *)call result:(FlutterResult)result {
    [_manager readCharacteristicForDevice:call.arguments[ARGUMENT_KEY_DEVICE_IDENTIFIER]
                              serviceUUID:call.arguments[ARGUMENT_KEY_SERVICE_UUID]
                       characteristicUUID:call.arguments[ARGUMENT_KEY_CHARACTERISTIC_UUID]
                            transactionId:[ArgumentValidator validStringOrNil:call.arguments[ARGUMENT_KEY_TRANSACTION_ID]]
                                  resolve:result
                                   reject:[self rejectForFlutterResult:result]];
}

- (void)readCharacteristicForService:(FlutterMethodCall *)call result:(FlutterResult)result {
    [_manager readCharacteristicForService:[call.arguments[ARGUMENT_KEY_SERVICE_ID] doubleValue]
                        characteristicUUID:call.arguments[ARGUMENT_KEY_CHARACTERISTIC_UUID]
                             transactionId:[ArgumentValidator validStringOrNil:call.arguments[ARGUMENT_KEY_TRANSACTION_ID]]
                                   resolve:result
                                    reject:[self rejectForFlutterResult:result]];
}

- (void)readCharacteristic:(FlutterMethodCall *)call result:(FlutterResult)result {
    [_manager readCharacteristic:[call.arguments[ARGUMENT_KEY_CHARACTERISTIC_IDENTIFIER] doubleValue]
                   transactionId:[ArgumentValidator validStringOrNil:call.arguments[ARGUMENT_KEY_TRANSACTION_ID]]
                         resolve:result
                          reject:[self rejectForFlutterResult:result]];
}

// MARK: - MBA Methods - BleClientManagerDelegate implementation

- (void)dispatchEvent:(NSString * _Nonnull)name value:(id _Nonnull)value {
    if ([BleEvent.restoreStateEvent isEqualToString:name]) {
        [self.restoreStateStreamHandler onRestoreEvent:value];
    } else if ([BleEvent.stateChangeEvent isEqualToString:name]) {
        [self.adapterStateStreamHandler onNewAdapterState:value];
    } else if ([BleEvent.scanEvent isEqualToString:name]) {
        [self.scanningStreamHandler onScanResult:(NSArray*)value];
    } else if ([BleEvent.connectingEvent isEqualToString:name]) {
        [self.connectionStateStreamHandler onConnectingEvent:(NSString *)value];
    } else if ([BleEvent.connectedEvent isEqualToString:name]) {
        [self.connectionStateStreamHandler onConnectedEvent:(NSString *)value];
    }
}

// MARK: - Utility methods

- (Resolve)resolveForServicesForDevice:(FlutterResult)result {
    return ^(NSArray *servicesArray) {
        result([JSONStringifier jsonStringFromJSONObject:[self arrayReplacingKeys:@[@[@"id", @"serviceId"],
                                                                                    @[@"uuid", @"serviceUuid"]]
                                                                          inArray:servicesArray]]);
    };
}

- (Resolve)resolveForCharacteristicsForService:(FlutterResult)result {
    return ^(NSArray *characteristicsArray) {
        result([JSONStringifier jsonStringFromJSONObject:[self arrayReplacingKeys:@[@[@"uuid", @"characteristicUuid"]]
                                                                          inArray:characteristicsArray]]);
    };
}

- (Resolve)resolveForCharacteristics:(FlutterResult)result serviceUuid:(NSString *)serviceUuid {
    return ^(NSArray *servicesArray) {

        NSDictionary *matchingService = nil;
        for (NSDictionary *service in [self arrayReplacingKeys:@[@[@"id", @"serviceId"], @[@"uuid", @"serviceUuid"]]
                                                       inArray:servicesArray]) {
            if ([[service valueForKey:@"serviceUuid"] isEqualToString:serviceUuid]) {
                matchingService = service;
                break;
            }
        }

        if (matchingService == nil) {
            result([FlutterError errorWithCode:@"-1" message:@"Service not found" details:nil]);
            return;
        }

        Resolve resolve = ^(NSArray* characteristicsArray) {
            NSMutableDictionary *resultDictionary = [[NSMutableDictionary alloc] init];
            [resultDictionary addEntriesFromDictionary:matchingService];
            [resultDictionary setObject:[self arrayReplacingKeys:@[@[@"uuid", @"characteristicUuid"]]
                                                         inArray:characteristicsArray]
                                 forKey:@"characteristics"];
            result([JSONStringifier jsonStringFromJSONObject:resultDictionary]);
        };

        [_manager characteristicsForService:[[matchingService valueForKey:@"id"] doubleValue]
                            resolve:resolve
                             reject:[self rejectForFlutterResult:result]];
    };
}

- (Reject)rejectForFlutterResult:(FlutterResult)result {
    return ^(NSString *code, NSString *message, NSError *error) {
        result([FlutterErrorFactory flutterErrorFromJSONString:message]);
    };
}

- (NSArray *)arrayReplacingKeys:(NSArray<NSArray<NSString *> *> *)keys inArray:(NSArray *)servicesArray {
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in servicesArray) {
        NSMutableDictionary *newDictionary = [[NSMutableDictionary alloc] init];
        for (NSArray *keyPair in keys) {
            [newDictionary addEntriesFromDictionary:dictionary];
            [newDictionary setObject:[dictionary objectForKey:keyPair[0]] forKey:keyPair[1]];
            [newDictionary removeObjectForKey:keyPair[0]];
        }
        [newArray addObject:newDictionary];
    }
    return newArray;
}

@end
