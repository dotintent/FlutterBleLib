#import "DartMethodCaller.h"
#import "DartMethodName.h"
#import "SimulationArgumentName.h"
#import "Peripheral.h"
#import "DartResultConverter.h"

typedef void (^InvokeMethodResultHandler)(id _Nullable result);
typedef void (^SuccessHandler)(id _Nullable result);
typedef void (^ErrorHandler)(id error);

@interface DartMethodCaller ()

@property (nonatomic) FlutterMethodChannel *dartMethodChannel;

@end

@implementation DartMethodCaller

// MARK: - Initializers

- (instancetype)initWithDartMethodChannel:(FlutterMethodChannel *)dartMethodChannel {
    self = [super init];
    if (self) {
        self.dartMethodChannel = dartMethodChannel;
    }
    return self;
}

// MARK: - Methods - Lifecycle

- (void)createClient {
    [self.dartMethodChannel invokeMethod:DART_METHOD_NAME_CREATE_CLIENT
                               arguments:nil
                                  result:[self simpleInvokeMethodResultHandlerForMethod:DART_METHOD_NAME_CREATE_CLIENT]];
}

// MARK: - Methods - Scanning

- (void)startDeviceScan {
    [self.dartMethodChannel invokeMethod:DART_METHOD_NAME_START_DEVICE_SCAN
                               arguments:nil
                                  result:[self simpleInvokeMethodResultHandlerForMethod:DART_METHOD_NAME_START_DEVICE_SCAN]];
}

- (void)stopDeviceScan {
    [self.dartMethodChannel invokeMethod:DART_METHOD_NAME_STOP_DEVICE_SCAN
                               arguments:nil
                                  result:[self simpleInvokeMethodResultHandlerForMethod:DART_METHOD_NAME_STOP_DEVICE_SCAN]];
}

// MARK: - Methods - Connection

- (void)connectToDevice:(NSString *)deviceIdentifier
                   name:(NSString *)name
                options:(NSDictionary<NSString *,id> *)options
                resolve:(Resolve)resolve
                 reject:(Reject)reject {
    NSDictionary<NSString *,id> *arguments = [NSDictionary dictionaryWithObjectsAndKeys:
                                               deviceIdentifier, SIMULATION_ARGUMENT_NAME_DEVICE_ID,
                                               nil];
    SuccessHandler successHandler = ^(id _Nullable result) {
        resolve([[[Peripheral alloc] initWithIdentifier:deviceIdentifier
                                                   name:name
                                                    mtu:23] jsonObjectRepresentation]);
    };
    ErrorHandler errorHandler = ^(id error) {
        // TODO: - Send error here
        // reject();
    };
    [self.dartMethodChannel invokeMethod:DART_METHOD_NAME_CONNECT_TO_DEVICE
                               arguments:arguments
                                  result:[self invokeMethodResultHandlerForMethod:DART_METHOD_NAME_CONNECT_TO_DEVICE
                                                                          onSuccess:successHandler
                                                                           onError:errorHandler]];
}

- (void)cancelDeviceConnection:(NSString *)deviceIdentifier
                          name:(NSString *)name
                       resolve:(Resolve)resolve
                        reject:(Reject)reject {
    NSDictionary<NSString *,id> *arguments = [NSDictionary dictionaryWithObjectsAndKeys:
                                              deviceIdentifier, SIMULATION_ARGUMENT_NAME_DEVICE_ID,
                                              nil];
    ErrorHandler errorHandler = ^(id error) {
        // TODO: - Send error here
        // reject();
    };
    [self.dartMethodChannel invokeMethod:DART_METHOD_NAME_DISCONNECT_OR_CANCEL_CONNECTION
                               arguments:arguments
                                  result:[self invokeMethodResultHandlerForMethod:DART_METHOD_NAME_DISCONNECT_OR_CANCEL_CONNECTION
                                                                        onSuccess:resolve
                                                                          onError:errorHandler]];
}

- (void)isDeviceConnected:(NSString *)deviceIdentifier
                  resolve:(Resolve)resolve
                   reject:(Reject)reject {
    NSDictionary<NSString *,id> *arguments = [NSDictionary dictionaryWithObjectsAndKeys:
                                              deviceIdentifier, SIMULATION_ARGUMENT_NAME_DEVICE_ID,
                                              nil];
    ErrorHandler errorHandler = ^(id error) {
        // TODO: - Send error here
        // reject();
    };
    [self.dartMethodChannel invokeMethod:DART_METHOD_NAME_IS_DEVICE_CONNECTED
                               arguments:arguments
                                  result:[self invokeMethodResultHandlerForMethod:DART_METHOD_NAME_IS_DEVICE_CONNECTED
                                                                        onSuccess:resolve
                                                                          onError:errorHandler]];
}

// MARK: - Discovery

- (void)discoverAllServicesAndCharacteristics:(NSString *)deviceIdentifier
                                         name:(NSString *)name
                                transactionId:(NSString *)transactionId
                                      resolve:(Resolve)resolve
                                       reject:(Reject)reject {
    NSDictionary<NSString *,id> *arguments = [NSDictionary dictionaryWithObjectsAndKeys:
                                              deviceIdentifier, SIMULATION_ARGUMENT_NAME_DEVICE_ID,
                                              nil];
    SuccessHandler successHandler = ^(id result) {
        resolve([DartResultConverter deviceContainerFromDartResult:result
                                                        peripheral:[[Peripheral alloc] initWithIdentifier:deviceIdentifier
                                                                                                     name:name
                                                                                                      mtu:23]]);
    };
    ErrorHandler errorHandler = ^(id error) {
        // TODO: - Send error here
        // reject();
    };
    [self.dartMethodChannel invokeMethod:DART_METHOD_NAME_DISCOVER_ALL_SERVICES_AND_CHARACTERISTICS
                               arguments:arguments
                                  result:[self invokeMethodResultHandlerForMethod:DART_METHOD_NAME_DISCOVER_ALL_SERVICES_AND_CHARACTERISTICS
                                                                        onSuccess:successHandler
                                                                          onError:errorHandler]];
}

// MARK: - Utility methods

- (InvokeMethodResultHandler)simpleInvokeMethodResultHandlerForMethod:(NSString *)methodName {
    return ^(id _Nullable result) {
        if ([result class] == [FlutterError class]) {
            NSLog(@"%@%@%@%@", @"DartMethodCaller.", methodName, @": FlutterError: ", [(FlutterError *)result message]);
        } else if ([result class] == [NSError class]) {
            NSLog(@"%@%@%@%@", @"DartMethodCaller.", methodName, @": error: ", (NSError *)result);
        } else {
            NSLog(@"%@%@%@%@", @"DartMethodCaller.", methodName, @": success: ", result);
        }
    };
}

- (InvokeMethodResultHandler)invokeMethodResultHandlerForMethod:(NSString *)methodName
                                                        onSuccess:(SuccessHandler)successHandler
                                                         onError:(ErrorHandler)errorHandler {
    return ^(id _Nullable result) {
        if ([result class] == [FlutterError class]) {
            NSLog(@"%@%@%@%@", @"DartMethodCaller.", methodName, @": FlutterError: ", [(FlutterError *)result message]);
            errorHandler((FlutterError *)result);
        } else if ([result class] == [NSError class]) {
            NSLog(@"%@%@%@%@", @"DartMethodCaller.", methodName, @": error: ", (NSError *)result);
            errorHandler((NSError *)result);
        } else {
            NSLog(@"%@%@%@%@", @"DartMethodCaller.", methodName, @": success: ", result);
            successHandler(result);
        }
    };
}

@end
