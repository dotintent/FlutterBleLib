#import "DartMethodCaller.h"
#import "DartMethodName.h"
#import "SimulationArgumentName.h"
#import "Peripheral.h"
#import "JSONStringifier.h"

typedef void (^InvokeMethodResultHandler)(id _Nullable result);

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
                options:(NSDictionary<NSString *,id> *)options
                resolve:(Resolve)resolve
                 reject:(Reject)reject {
    NSDictionary<NSString *,id> *arguments = [NSDictionary dictionaryWithObjectsAndKeys:
                                               deviceIdentifier, SIMULATION_ARGUMENT_NAME_DEVICE_ID,
                                               nil];
    [self.dartMethodChannel invokeMethod:DART_METHOD_NAME_CONNECT_TO_DEVICE
                               arguments:[JSONStringifier jsonStringFromJSONObject:arguments]
                                  result:[self invokeMethodResultHandlerForMethod:DART_METHOD_NAME_CONNECT_TO_DEVICE
                                                                          resolve:resolve
                                                                           reject:reject]];
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
                                                        resolve:(Resolve)resolve
                                                         reject:(Reject)reject {
    return ^(id _Nullable result) {
        if ([result class] == [FlutterError class]) {
            NSLog(@"%@%@%@%@", @"DartMethodCaller.", methodName, @": FlutterError: ", [(FlutterError *)result message]);
            reject;
        } else if ([result class] == [NSError class]) {
            NSLog(@"%@%@%@%@", @"DartMethodCaller.", methodName, @": error: ", (NSError *)result);
            reject;
        } else {
            NSLog(@"%@%@%@%@", @"DartMethodCaller.", methodName, @": success: ", result);
            resolve([[Peripheral alloc] initWithIdentifier:[[NSUUID alloc] initWithUUIDString:@"F000AA00-0451-4000-B000-000000000000"]
                                                      name:@"SensorTag"
                                                       mtu:23]);
        }
    };
}

@end
