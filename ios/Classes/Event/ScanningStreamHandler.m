#import "ScanningStreamHandler.h"
#import "ArgumentValidator.h"
#import "JSONStringifier.h"
#import "FlutterErrorFactory.h"

@implementation ScanningStreamHandler {
    FlutterEventSink scanResultsSink;
}

- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    scanResultsSink = nil;
    return nil;
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)events {
    scanResultsSink = events;
    return nil;
}

- (void)onScanResult:(NSArray *)scanResult {
    if (scanResultsSink != nil) {
        if (!(scanResult.count == 2 &&
            (scanResult[0] == [NSNull null] || (scanResult[1] == [NSNull null] && [scanResult[0] isKindOfClass:NSString.class])))) {
            scanResultsSink([FlutterError errorWithCode:@"-1" message:@"Invalid scanResult format." details:nil]);
            [self onComplete];
        } else {
            if (scanResult[0] == [NSNull null]) {
                scanResultsSink([JSONStringifier jsonStringFromJSONObject:scanResult[1]]);
            } else {
                scanResultsSink([FlutterErrorFactory flutterErrorFromJSONString:scanResult[0]]);
                [self onComplete];
            }
        }
    }
}

- (void)onComplete {
    if (scanResultsSink != nil) {
        scanResultsSink(FlutterEndOfEventStream);
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
