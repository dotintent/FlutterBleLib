#import "ConnectionStateStreamHandler.h"

@implementation ConnectionStateStreamHandler
{
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

- (void)onNewConnectionState:(id)connectionState {
    if (eventSink != nil) {
        eventSink(connectionState);
    }
}

@end
