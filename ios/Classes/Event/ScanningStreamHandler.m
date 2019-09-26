#import "ScanningStreamHandler.h"
#import "ArgumentValidator.h"
#import "ScanResultFactory.h"
#import "FlutterErrorFactory.h"

@implementation ScanningStreamHandler
{
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
        assert(scanResult.count == 2 &&
               (scanResult[0] == [NSNull null] || (scanResult[1] == [NSNull null] && [scanResult[0] isKindOfClass:NSString.class])));
        if (scanResult[0] == [NSNull null]) {
            scanResultsSink([ScanResultFactory scanResultFromJSONObject:scanResult[1]]);
        } else {
            scanResultsSink([FlutterErrorFactory flutterErrorFromJSONString:scanResult[0]]);
            [self onComplete];
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
