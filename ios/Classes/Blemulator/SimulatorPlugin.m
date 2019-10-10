#import "SimulatorPlugin.h"
#import <flutter_ble_lib-Swift.h>
#import "SimulatedAdapter.h"
#import "DartMethodCaller.h"
#import "DartValueHandler.h"

typedef id<BleAdapter> _Nonnull (^BleAdapterCreator)(dispatch_queue_t _Nonnull queue, NSString * _Nullable restoreIdentifierKey);

@interface SimulatorPlugin ()

@property (nonatomic) DartMethodCaller *dartMethodCaller;
@property (nonatomic) DartValueHandler *dartValueHandler;

@end

@implementation SimulatorPlugin

// MARK: - Public methods

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {

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
    
}

// MARK: - Private methods

- (void)switchToEmulation:(FlutterResult)result {
    BleAdapterCreator bleAdapterCreator = ^(dispatch_queue_t _Nonnull queue, NSString * _Nullable restoreIdentifierKey) {
        return [[SimulatedAdapter alloc] initWithDartMethodCaller:self.dartMethodCaller
                                                 dartValueHandler:self.dartValueHandler];
    };
    [BleAdapterFactory setBleAdapterCreator:bleAdapterCreator];
}

@end
