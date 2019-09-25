#import "ScanningStreamHandler.h"

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

- (void)onScanResult:(id)scanResult {
    if (scanResultsSink != nil) {
        // Temporary implementation just to showcase the results
        if ([scanResult isKindOfClass:NSArray.class]) {
            NSArray* testArray = (NSArray*)scanResult;
            if (testArray != nil) {
                NSError* error = nil;
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:testArray[1] options:NSJSONWritingPrettyPrinted error:&error];
                NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                scanResultsSink(jsonString);
            }
        } else {
            NSLog(@"Nope");
        }
    }
}

- (void)onComplete {
    if (scanResultsSink != nil) {
        scanResultsSink(FlutterEndOfEventStream);
    }
}

@end
