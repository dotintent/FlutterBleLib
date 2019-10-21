#import "DartMethodCaller.h"
#import "DartMethodName.h"
#import "DartCallArgumentKeys.h"
#import "Peripheral.h"
#import "DartResultConverter.h"
#import "BleError.h"
#import "Base64Coder.h"

typedef void (^InvokeMethodResultHandler)(id _Nullable result);
typedef void (^SuccessHandler)(id _Nullable result);

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
    NSDictionary<NSString *,id> *arguments = [[NSDictionary alloc] init];
    [self.dartMethodChannel invokeMethod:DART_METHOD_NAME_START_DEVICE_SCAN
                               arguments:arguments
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
                                               deviceIdentifier, DART_CALL_ARGUMENT_DEVICE_ID,
                                               nil];
    SuccessHandler successHandler = ^(id _Nullable result) {
        resolve([[[Peripheral alloc] initWithIdentifier:deviceIdentifier
                                                   name:name] jsonObjectRepresentation]);
    };
    [self.dartMethodChannel invokeMethod:DART_METHOD_NAME_CONNECT_TO_DEVICE
                               arguments:arguments
                                  result:[self invokeMethodResultHandlerForMethod:DART_METHOD_NAME_CONNECT_TO_DEVICE
                                                                        onSuccess:successHandler
                                                                          onError:reject]];
}

- (void)cancelDeviceConnection:(NSString *)deviceIdentifier
                          name:(NSString *)name
                       resolve:(Resolve)resolve
                        reject:(Reject)reject {
    NSDictionary<NSString *,id> *arguments = [NSDictionary dictionaryWithObjectsAndKeys:
                                              deviceIdentifier, DART_CALL_ARGUMENT_DEVICE_ID,
                                              nil];
    [self.dartMethodChannel invokeMethod:DART_METHOD_NAME_DISCONNECT_OR_CANCEL_CONNECTION
                               arguments:arguments
                                  result:[self invokeMethodResultHandlerForMethod:DART_METHOD_NAME_DISCONNECT_OR_CANCEL_CONNECTION
                                                                        onSuccess:resolve
                                                                          onError:reject]];
}

- (void)isDeviceConnected:(NSString *)deviceIdentifier
                  resolve:(Resolve)resolve
                   reject:(Reject)reject {
    NSDictionary<NSString *,id> *arguments = [NSDictionary dictionaryWithObjectsAndKeys:
                                              deviceIdentifier, DART_CALL_ARGUMENT_DEVICE_ID,
                                              nil];
    [self.dartMethodChannel invokeMethod:DART_METHOD_NAME_IS_DEVICE_CONNECTED
                               arguments:arguments
                                  result:[self invokeMethodResultHandlerForMethod:DART_METHOD_NAME_IS_DEVICE_CONNECTED
                                                                        onSuccess:resolve
                                                                          onError:reject]];
}

// MARK: - Discovery

- (void)discoverAllServicesAndCharacteristics:(NSString *)deviceIdentifier
                                         name:(NSString *)name
                                transactionId:(NSString *)transactionId
                                      resolve:(Resolve)resolve
                                       reject:(Reject)reject {
    NSDictionary<NSString *,id> *arguments = [NSDictionary dictionaryWithObjectsAndKeys:
                                              deviceIdentifier, DART_CALL_ARGUMENT_DEVICE_ID,
                                              nil];
    SuccessHandler successHandler = ^(id result) {
        resolve([DartResultConverter deviceContainerFromDartResult:result
                                                        peripheral:[[Peripheral alloc] initWithIdentifier:deviceIdentifier
                                                                                                     name:name]]);
    };
    [self.dartMethodChannel invokeMethod:DART_METHOD_NAME_DISCOVER_ALL_SERVICES_AND_CHARACTERISTICS
                               arguments:arguments
                                  result:[self invokeMethodResultHandlerForMethod:DART_METHOD_NAME_DISCOVER_ALL_SERVICES_AND_CHARACTERISTICS
                                                                        onSuccess:successHandler
                                                                          onError:reject]];
}

// MARK: - Characteristics observation

- (void)readCharacteristicForDevice:(NSString *)deviceIdentifier
                        serviceUUID:(NSString *)serviceUUID
                 characteristicUUID:(NSString *)characteristicUUID
                      transactionId:(NSString *)transactionId
                            resolve:(Resolve)resolve
                             reject:(Reject)reject {
    NSDictionary<NSString *,id> *arguments = [NSDictionary dictionaryWithObjectsAndKeys:
                                              deviceIdentifier, DART_CALL_ARGUMENT_DEVICE_IDENTIFIER,
                                              serviceUUID, DART_CALL_ARGUMENT_SERVICE_UUID,
                                              characteristicUUID, DART_CALL_ARGUMENT_CHARACTERISTIC_UUID,
                                              transactionId, DART_CALL_ARGUMENT_TRANSACTION_ID,
                                              nil];
    [self.dartMethodChannel invokeMethod:DART_METHOD_NAME_READ_CHARACTERISTIC_FOR_DEVICE
                               arguments:arguments
                                  result:[self invokeMethodResultHandlerForMethod:DART_METHOD_NAME_READ_CHARACTERISTIC_FOR_DEVICE
                                                                        onSuccess:[self characteristicResultSuccessHandler:resolve]
                                                                          onError:reject]];
}

- (void)readCharacteristicForService:(int)serviceIdentifier
                  characteristicUUID:(NSString *)characteristicUUID
                       transactionId:(NSString *)transactionId
                             resolve:(Resolve)resolve
                              reject:(Reject)reject {
    NSDictionary<NSString *,id> *arguments = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [NSNumber numberWithInt:serviceIdentifier], DART_CALL_ARGUMENT_SERVICE_ID,
                                              characteristicUUID, DART_CALL_ARGUMENT_CHARACTERISTIC_UUID,
                                              transactionId, DART_CALL_ARGUMENT_TRANSACTION_ID,
                                              nil];
    [self.dartMethodChannel invokeMethod:DART_METHOD_NAME_READ_CHARACTERISTIC_FOR_SERVICE
                               arguments:arguments
                                  result:[self invokeMethodResultHandlerForMethod:DART_METHOD_NAME_READ_CHARACTERISTIC_FOR_SERVICE
                                                                        onSuccess:[self characteristicResultSuccessHandler:resolve]
                                                                          onError:reject]];
}

- (void)readCharacteristic:(int)characteristicIdentifier
             transactionId:(NSString *)transactionId
                   resolve:(Resolve)resolve
                    reject:(Reject)reject {
    NSDictionary<NSString *,id> *arguments = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [NSNumber numberWithInt:characteristicIdentifier], DART_CALL_ARGUMENT_CHARACTERISTIC_IDENTIFIER,
                                              transactionId, DART_CALL_ARGUMENT_TRANSACTION_ID,
                                              nil];
    [self.dartMethodChannel invokeMethod:DART_METHOD_NAME_READ_CHARACTERISTIC_FOR_IDENTIFIER
                               arguments:arguments
                                  result:[self invokeMethodResultHandlerForMethod:DART_METHOD_NAME_READ_CHARACTERISTIC_FOR_IDENTIFIER
                                                                        onSuccess:[self characteristicResultSuccessHandler:resolve]
                                                                          onError:reject]];
}

-(void)writeCharacteristicForDevice:(NSString *)deviceIdentifier
                        serviceUUID:(NSString *)serviceUUID
                 characteristicUUID:(NSString *)characteristicUUID
                              value:(NSString *)value
                      transactionId:(NSString *)transactionId
                            resolve:(Resolve)resolve
                             reject:(Reject)reject {
    NSDictionary<NSString *,id> *arguments = [NSDictionary dictionaryWithObjectsAndKeys:
                                              deviceIdentifier, DART_CALL_ARGUMENT_DEVICE_IDENTIFIER,
                                              serviceUUID, DART_CALL_ARGUMENT_SERVICE_UUID,
                                              characteristicUUID, DART_CALL_ARGUMENT_CHARACTERISTIC_UUID,
                                              [FlutterStandardTypedData
                                               typedDataWithBytes:[Base64Coder dataFromBase64String:value]], DART_CALL_ARGUMENT_VALUE,
                                              transactionId, DART_CALL_ARGUMENT_TRANSACTION_ID,
                                              nil];
    [self.dartMethodChannel invokeMethod:DART_METHOD_NAME_WRITE_CHARACTERISTIC_FOR_DEVICE
                               arguments:arguments
                                  result:[self invokeMethodResultHandlerForMethod:DART_METHOD_NAME_WRITE_CHARACTERISTIC_FOR_DEVICE
                                                                        onSuccess:[self characteristicResultSuccessHandler:resolve]
                                                                          onError:reject]];
}

- (void)writeCharacteristicForService:(int)serviceIdentifier
                   characteristicUUID:(NSString *)characteristicUUID
                                value:(NSString *)value
                        transactionId:(NSString *)transactionId
                              resolve:(Resolve)resolve
                               reject:(Reject)reject {
    NSDictionary<NSString *,id> *arguments = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [NSNumber numberWithInt:serviceIdentifier], DART_CALL_ARGUMENT_SERVICE_ID,
                                              characteristicUUID, DART_CALL_ARGUMENT_CHARACTERISTIC_UUID,
                                              [FlutterStandardTypedData
                                               typedDataWithBytes:[Base64Coder dataFromBase64String:value]], DART_CALL_ARGUMENT_VALUE,
                                              transactionId, DART_CALL_ARGUMENT_TRANSACTION_ID,
                                              nil];
    [self.dartMethodChannel invokeMethod:DART_METHOD_NAME_WRITE_CHARACTERISTIC_FOR_SERVICE
                               arguments:arguments
                                  result:[self invokeMethodResultHandlerForMethod:DART_METHOD_NAME_WRITE_CHARACTERISTIC_FOR_SERVICE
                                                                        onSuccess:[self characteristicResultSuccessHandler:resolve]
                                                                          onError:reject]];
}

- (void)writeCharacteristic:(int)characteristicIdentifier
                      value:(NSString *)value
              transactionId:(NSString *)transactionId
                    resolve:(Resolve)resolve
                     reject:(Reject)reject {
    NSDictionary<NSString *,id> *arguments = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [NSNumber numberWithInt:characteristicIdentifier], DART_CALL_ARGUMENT_CHARACTERISTIC_IDENTIFIER,
                                              [FlutterStandardTypedData
                                               typedDataWithBytes:[Base64Coder dataFromBase64String:value]], DART_CALL_ARGUMENT_VALUE,
                                              transactionId, DART_CALL_ARGUMENT_TRANSACTION_ID,
                                              nil];
    [self.dartMethodChannel invokeMethod:DART_METHOD_NAME_WRITE_CHARACTERISTIC_FOR_IDENTIFIER
                               arguments:arguments
                                  result:[self invokeMethodResultHandlerForMethod:DART_METHOD_NAME_WRITE_CHARACTERISTIC_FOR_IDENTIFIER
                                                                        onSuccess:[self characteristicResultSuccessHandler:resolve]
                                                                          onError:reject]];
}

- (void)monitorCharacteristicForDevice:(NSString *)deviceIdentifier
                           serviceUUID:(NSString *)serviceUUID
                    characteristicUUID:(NSString *)characteristicUUID
                         transactionId:(NSString *)transactionId
                               resolve:(Resolve)resolve
                                reject:(Reject)reject {
    NSDictionary<NSString *,id> *arguments = [NSDictionary dictionaryWithObjectsAndKeys:
                                              deviceIdentifier, DART_CALL_ARGUMENT_DEVICE_IDENTIFIER,
                                              serviceUUID, DART_CALL_ARGUMENT_SERVICE_UUID,
                                              characteristicUUID, DART_CALL_ARGUMENT_CHARACTERISTIC_UUID,
                                              transactionId, DART_CALL_ARGUMENT_TRANSACTION_ID,
                                              nil];
    [self.dartMethodChannel invokeMethod:DART_METHOD_NAME_MONITOR_CHARACTERISTIC_FOR_DEVICE
                               arguments:arguments
                                  result:[self simpleInvokeMethodResultHandlerForMethod:DART_METHOD_NAME_MONITOR_CHARACTERISTIC_FOR_DEVICE]];
}

- (void)monitorCharacteristicForService:(int)serviceIdentifier
                     characteristicUUID:(NSString *)characteristicUUID
                          transactionId:(NSString *)transactionId
                                resolve:(Resolve)resolve
                                 reject:(Reject)reject {
    NSDictionary<NSString *,id> *arguments = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [NSNumber numberWithInt:serviceIdentifier], DART_CALL_ARGUMENT_SERVICE_ID,
                                              characteristicUUID, DART_CALL_ARGUMENT_CHARACTERISTIC_UUID,
                                              transactionId, DART_CALL_ARGUMENT_TRANSACTION_ID,
                                              nil];
    [self.dartMethodChannel invokeMethod:DART_METHOD_NAME_MONITOR_CHARACTERISTIC_FOR_SERVICE
                               arguments:arguments
                                  result:[self simpleInvokeMethodResultHandlerForMethod:DART_METHOD_NAME_MONITOR_CHARACTERISTIC_FOR_SERVICE]];
                                     
}

- (void)monitorCharacteristic:(int)characteristicIdentifier
                transactionId:(NSString *)transactionId
                      resolve:(Resolve)resolve
                       reject:(Reject)reject {
    NSDictionary<NSString *,id> *arguments = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [NSNumber numberWithInt:characteristicIdentifier], DART_CALL_ARGUMENT_CHARACTERISTIC_IDENTIFIER,
                                              transactionId, DART_CALL_ARGUMENT_TRANSACTION_ID,
                                              nil];
    [self.dartMethodChannel invokeMethod:DART_METHOD_NAME_MONITOR_CHARACTERISTIC_FOR_IDENTIFIER
                               arguments:arguments
                                  result:[self simpleInvokeMethodResultHandlerForMethod:DART_METHOD_NAME_MONITOR_CHARACTERISTIC_FOR_IDENTIFIER]];
}

// MARK: - RSSI

- (void)readRSSIForDevice:(NSString *)deviceIdentifier
                     name:(NSString *)name
                  resolve:(Resolve)resolve
                   reject:(Reject)reject {
    NSDictionary<NSString *,id> *arguments = [NSDictionary dictionaryWithObjectsAndKeys:
                                              deviceIdentifier, DART_CALL_ARGUMENT_DEVICE_ID,
                                              nil];
    SuccessHandler successHandler = ^(id result) {
        resolve([[[Peripheral alloc] initWithIdentifier:deviceIdentifier
                                                   name:name] jsonObjectRepresentationWithRssi:(NSNumber *)result]);
    };
    [self.dartMethodChannel invokeMethod:DART_METHOD_NAME_RSSI
                               arguments:arguments
                                  result:[self invokeMethodResultHandlerForMethod:DART_METHOD_NAME_RSSI
                                                                        onSuccess:successHandler
                                                                          onError:reject]];
// MARK: - Cancel transaction

- (void)cancelTransaction:(NSString *)transactionId {
    NSDictionary<NSString *,id> *arguments = [NSDictionary dictionaryWithObjectsAndKeys:
                                              transactionId, DART_CALL_ARGUMENT_TRANSACTION_ID,
                                              nil];
    [self.dartMethodChannel invokeMethod:DART_METHOD_NAME_CANCEL_TRANSACTION
                               arguments:arguments];
}

// MARK: - Utility methods

- (SuccessHandler)characteristicResultSuccessHandler:(Resolve)resolve {
    return ^(id result) {
        resolve([[DartResultConverter characteristicFromDartResult:result] jsonObjectRepresentation]);
    };
}

- (InvokeMethodResultHandler)simpleInvokeMethodResultHandlerForMethod:(NSString *)methodName {
    return ^(id _Nullable result) {
        if (result == FlutterMethodNotImplemented) {
            NSLog(@"%@%@%@", @"DartMethodCaller.", methodName, @": FlutterMethodNotImplemented");
        } else if ([result class] == [FlutterError class]) {
            NSLog(@"%@%@%@%@", @"DartMethodCaller.", methodName, @": FlutterError: ", [(FlutterError *)result message]);
        } else {
            NSLog(@"%@%@%@%@", @"DartMethodCaller.", methodName, @": success: ", result);
        }
    };
}

- (InvokeMethodResultHandler)invokeMethodResultHandlerForMethod:(NSString *)methodName
                                                        onSuccess:(SuccessHandler)successHandler
                                                         onError:(Reject)reject {
    return ^(id _Nullable result) {
        if (result == FlutterMethodNotImplemented) {
            NSLog(@"%@%@%@", @"DartMethodCaller.", methodName, @": FlutterMethodNotImplemented");
        } else if ([result class] == [FlutterError class]) {
            FlutterError *flutterError = (FlutterError *)result;
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[flutterError.message dataUsingEncoding:NSUTF8StringEncoding]
                                                                       options:NSJSONReadingMutableContainers
                                                                         error:nil];
            BleError *bleError = [[BleError alloc] initWithErrorCode:[[dictionary objectForKey:@"errorCode"] intValue]
                                                              reason:[dictionary objectForKey:@"reason"]];
            [bleError callReject:reject];
            NSLog(@"%@%@%@%@", @"DartMethodCaller.", methodName, @": FlutterError: ", flutterError.message);
        } else {
            successHandler(result);
            NSLog(@"%@%@%@%@", @"DartMethodCaller.", methodName, @": success: ", result);
        }
    };
}

@end
