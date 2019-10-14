#import "DartMethodCaller.h"
#import "DartMethodName.h"

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

- (void)connectToDevice {
    
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

@end
