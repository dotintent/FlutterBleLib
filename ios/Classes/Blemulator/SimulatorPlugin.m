#import "SimulatorPlugin.h"
#import <flutter_ble_lib-Swift.h>
#import "SimulatedAdapter.h"
#import "DartMethodCaller.h"
#import "DartValueHandler.h"
#import "PlatformMethodName.h"
#import "SimulationChannelName.h"

@import MultiplatformBleAdapter;

typedef id<BleAdapter> _Nonnull (^BleAdapterCreator)(dispatch_queue_t _Nonnull queue, NSString * _Nullable restoreIdentifierKey);

@interface SimulatorPlugin ()

@property (nonatomic) DartMethodCaller *dartMethodCaller;
@property (nonatomic) DartValueHandler *dartValueHandler;

@end

@implementation SimulatorPlugin

// MARK: - Public methods

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *dartToPlatformChannel = [FlutterMethodChannel methodChannelWithName:SIMULATION_CHANNEL_NAME_TO_PLATFORM
                                                                              binaryMessenger:[registrar messenger]];
    FlutterMethodChannel *platformToDartChannel = [FlutterMethodChannel methodChannelWithName:SIMULATION_CHANNEL_NAME_TO_DART
                                                                              binaryMessenger:[registrar messenger]];

    SimulatorPlugin *instance = [[SimulatorPlugin alloc] initWithPlatformToDartChannel:platformToDartChannel];

    [registrar addMethodCallDelegate:instance channel:dartToPlatformChannel];

}

// MARK: - Initializers

- (instancetype)initWithPlatformToDartChannel:(FlutterMethodChannel *)platformToDartChannel {
    self = [super init];
    if (self) {
        self.dartMethodCaller = [[DartMethodCaller alloc] initWithDartMethodChannel:platformToDartChannel];
        self.dartValueHandler = [DartValueHandler new];
    }
    return self;
}

// MARK: - FlutterMethodCallHandler implementation

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([PLATFORM_METHOD_NAME_SIMULATE isEqualToString:call.method]) {
        [self switchToEmulation:result];
        return;
    } else {
        [self.dartValueHandler handleMethodCall:call result:result];
        return;
    }
}

// MARK: - Private methods

- (void)switchToEmulation:(FlutterResult)result {
    BleAdapterCreator bleAdapterCreator = ^(dispatch_queue_t _Nonnull queue, NSString * _Nullable restoreIdentifierKey) {
        return [[SimulatedAdapter alloc] initWithDartMethodCaller:self.dartMethodCaller
                                                 dartValueHandler:self.dartValueHandler];
    };
    [BleAdapterFactory setBleAdapterCreator:bleAdapterCreator];
    result(nil);
}

@end
