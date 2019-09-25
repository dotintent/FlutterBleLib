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

- (void)onScanResult:(NSArray*)scanResult {
    if (scanResultsSink != nil) {
        assert(scanResult.count == 2 &&
               (scanResult[0] == [NSNull null] || (scanResult[1] == [NSNull null] && [scanResult[0] isKindOfClass:NSString.class])));
        if (scanResult[0] == [NSNull null]) {
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:scanResult[1]
                                                               options:NSJSONWritingPrettyPrinted
                                                                 error:nil];
            scanResultsSink([[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
        } else {
            NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:[scanResult[0] dataUsingEncoding:NSUTF8StringEncoding]
                                                                       options:NSJSONReadingMutableContainers
                                                                         error:nil];
            scanResultsSink([FlutterError errorWithCode:[dictionary objectForKey:@"errorCode"]
                                                message:[dictionary objectForKey:@"reason"]
                                                details:scanResult[0]]);
            [self onComplete];
        }
    }
}

- (void)onComplete {
    if (scanResultsSink != nil) {
        scanResultsSink(FlutterEndOfEventStream);
    }
}

- (nullable NSString*)validStringOrNil:(id)argument {
    if (argument != nil && (NSNull *)argument != [NSNull null] && [argument isKindOfClass:[NSString class]]) {
        return (NSString*)argument;
    } else {
        return nil;
    }
}

@end
