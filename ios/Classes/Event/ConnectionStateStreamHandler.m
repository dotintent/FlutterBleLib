#import "ConnectionStateStreamHandler.h"
#import "FlutterErrorFactory.h"

@implementation ConnectionStateStreamHandler {
    FlutterEventSink eventSink;
}

- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    @synchronized (self) {
        eventSink = nil;
        return nil;
    }
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)events {
    @synchronized (self) {
        eventSink = events;
        return nil;
    }
}

- (void)onConnectingEvent:(NSString *)deviceId {
    @synchronized (self) {
        if (eventSink != nil) {
            eventSink([self jsonStringForDeviceId:deviceId connectionState:@"connecting"]);
        }
    }
}

- (void)onConnectedEvent:(NSString *)deviceId {
    @synchronized (self) {
        if (eventSink != nil) {
            eventSink([self jsonStringForDeviceId:deviceId connectionState:@"connected"]);
        }
    }
}

- (void)onDisconnectedEvent:(NSArray *)peripheralResponse {
    @synchronized (self) {
        if (eventSink != nil) {
            if (peripheralResponse[0] == [NSNull null]) {
                NSDictionary *peripheral = peripheralResponse[1];
                eventSink([self jsonStringForDeviceId:[peripheral objectForKey:@"id"] connectionState:@"disconnected"]);
            } else {
                eventSink([FlutterErrorFactory flutterErrorFromJSONString:peripheralResponse[0]]);
            }
        }
    }
}

- (void)emitDisconnectedEvent:(NSString *)deviceId {
    @synchronized (self) {
        if (eventSink != nil) {
            eventSink([self jsonStringForDeviceId:deviceId connectionState:@"disconnected"]);
        }
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
