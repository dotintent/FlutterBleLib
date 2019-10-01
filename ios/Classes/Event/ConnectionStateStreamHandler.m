#import "ConnectionStateStreamHandler.h"

@implementation ConnectionStateStreamHandler {
    FlutterEventSink eventSink;
}

- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    eventSink = nil;
    return nil;
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)events {
    eventSink = events;
    return nil;
}

- (void)onConnectingEvent:(NSString *)deviceId {
    if (eventSink != nil) {
        eventSink([self jsonStringForDeviceId:deviceId connectionState:@"connecting"]);
    }
}

- (void)onConnectedEvent:(NSString *)deviceId {
    if (eventSink != nil) {
        eventSink([self jsonStringForDeviceId:deviceId connectionState:@"connected"]);
    }
}

- (NSString *)jsonStringForDeviceId:(NSString *)deviceId connectionState:(NSString *)connectionState {
    NSMutableDictionary<NSString *, id> *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:deviceId forKey:@"peripheralIdentifier"];
    [dictionary setValue:connectionState forKey:@"connectionState"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
