#import "SimulatorPlugin.h"
#import "DartMethodCaller.h"
#import "DartValueHandler.h"

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

@end
