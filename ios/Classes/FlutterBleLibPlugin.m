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

typedef void (^Resolve)(id result);
typedef void (^Reject)(NSString *code, NSString *message, NSError *error);

@interface FlutterBleLibPlugin () <BleClientManagerDelegate>

@property (nonatomic) BleClientManager* manager;
@property (nonatomic) AdapterStateStreamHandler* adapterStateStreamHandler;
@property (nonatomic) RestoreStateStreamHandler* restoreStateStreamHandler;
@property (nonatomic) ScanningStreamHandler* scanningStreamHandler;
@property (nonatomic) ConnectionStateStreamHandler* connectionStateStreamHandler;

@end

@implementation FlutterBleLibPlugin

// MARK: - Initializers

- (instancetype)init
{
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

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:CHANNEL_NAME_FLUTTER_BLE_LIB binaryMessenger:[registrar messenger]];

    FlutterEventChannel* adapterStateChannel = [FlutterEventChannel eventChannelWithName:CHANNEL_NAME_ADAPTER_STATE_CHANGES binaryMessenger:[registrar messenger]];
    FlutterEventChannel* restoreStateChannel = [FlutterEventChannel eventChannelWithName:CHANNEL_NAME_STATE_RESTORE_EVENTS binaryMessenger:[registrar messenger]];
    FlutterEventChannel* scanningChannel = [FlutterEventChannel eventChannelWithName:CHANNEL_NAME_SCANNING_EVENTS binaryMessenger:[registrar messenger]];
    FlutterEventChannel* connectionStateChannel = [FlutterEventChannel eventChannelWithName:CHANNEL_NAME_CONNECTION_STATE_CHANGE_EVENTS binaryMessenger:[registrar messenger]];

    FlutterBleLibPlugin* instance = [[FlutterBleLibPlugin alloc] init];
    
    [registrar addMethodCallDelegate:instance channel:channel];

    [adapterStateChannel setStreamHandler:instance.adapterStateStreamHandler];
    [restoreStateChannel setStreamHandler:instance.restoreStateStreamHandler];
    [scanningChannel setStreamHandler:instance.scanningStreamHandler];
    [connectionStateChannel setStreamHandler:instance.connectionStateStreamHandler];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
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
    } else {
        result(FlutterMethodNotImplemented);
    }
}

// MARK: - MBA Methods - BleClient lifecycle

- (void)createClient:(FlutterMethodCall*)call result:(FlutterResult)result {
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

- (void)startDeviceScan:(FlutterMethodCall*)call result:(FlutterResult)result {
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

- (void)connectToDevice:(FlutterMethodCall*)call result:(FlutterResult)result {
    [_manager connectToDevice:[ArgumentValidator validStringOrNil:call.arguments[ARGUMENT_KEY_DEVICE_IDENTIFIER]]
                      options:nil
                      resolve:result
                       reject:[self rejectForFlutterResult:result]];
}

- (void)cancelDeviceConnection:(FlutterMethodCall*)call result:(FlutterResult)result {
    [_manager cancelDeviceConnection:[ArgumentValidator validStringOrNil:call.arguments[ARGUMENT_KEY_DEVICE_IDENTIFIER]]
                             resolve:result
                              reject:[self rejectForFlutterResult:result]];
}

- (void)isDeviceConnected:(FlutterMethodCall*)call result:(FlutterResult)result {
    [_manager isDeviceConnected:[ArgumentValidator validStringOrNil:call.arguments[ARGUMENT_KEY_DEVICE_IDENTIFIER]]
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
    }
}

// MARK: - Utility methods

- (Reject)rejectForFlutterResult:(FlutterResult)result {
    return ^(NSString *code, NSString *message, NSError *error) {
        result([FlutterErrorFactory flutterErrorFromJSONString:message]);
    };
}

@end
