#import "ScanningStreamHandler.h"
#import "ArgumentHandler.h"
#import "JSONStringifier.h"
#import "FlutterErrorFactory.h"
#import "ArgumentKey.h"

@implementation ScanningStreamHandler {
    FlutterEventSink scanResultsSink;
    id <BleAdapter> bleAdapter;
}

- (void) attachAdatper:(id<BleAdapter>)adapter {
    bleAdapter = adapter;
}

- (void) detachAdapter{
    [self cancelPreviousScanning:@"detach adapter"];
    bleAdapter = nil;
}

- (void) cancelPreviousScanning:(NSString *)message{
    if (scanResultsSink != nil){
        NSString *errorCode = @"2"; // OperationCancelled
        NSDictionary *json = @{@"errorCode": errorCode, @"reason": message};
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        scanResultsSink([FlutterError errorWithCode:@"2" message:message details: jsonString]);
        scanResultsSink(FlutterEndOfEventStream);
        scanResultsSink = nil;
    }
    [bleAdapter stopDeviceScan];
}

- (void)stopDeviceScan:(FlutterResult)result {
    @synchronized (self) {
        [self cancelPreviousScanning:@"stop device scan"];
        result(nil);
    }
}

- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    @synchronized (self) {
        [bleAdapter stopDeviceScan];
        scanResultsSink = nil;
        return nil;
    }
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)events {
    @synchronized (self) {
        [self cancelPreviousScanning:@"Restart the scan"];
        scanResultsSink = events;
        
        NSArray* expectedArguments = [NSArray arrayWithObjects:ARGUMENT_KEY_ALLOW_DUPLICATES, nil];
        [bleAdapter startDeviceScan:[ArgumentHandler stringArrayOrNil:arguments[ARGUMENT_KEY_UUIDS]] options:[ArgumentHandler dictionaryOrNil:expectedArguments in:arguments]];
        return nil;
    }
}

- (void)onScanResult:(NSArray *)scanResult {
    @synchronized (self) {
        if (scanResultsSink != nil) {
            if (!(scanResult.count == 2 &&
                (scanResult[0] == [NSNull null] || (scanResult[1] == [NSNull null] && [scanResult[0] isKindOfClass:NSString.class])))) {
                scanResultsSink([FlutterError errorWithCode:@"-1" message:@"Invalid scanResult format." details:nil]);
                scanResultsSink(FlutterEndOfEventStream);
            } else {
                if (scanResult[0] == [NSNull null]) {
                    scanResultsSink([JSONStringifier jsonStringFromJSONObject:scanResult[1]]);
                } else {
                    scanResultsSink([FlutterErrorFactory flutterErrorFromJSONString:scanResult[0]]);
                    scanResultsSink(FlutterEndOfEventStream);
                }
            }
        }
    }
}

- (nullable NSString *)validStringOrNil:(id)argument {
    if (argument != nil && (NSNull *)argument != [NSNull null] && [argument isKindOfClass:[NSString class]]) {
        return (NSString *)argument;
    } else {
        return nil;
    }
}

@end
