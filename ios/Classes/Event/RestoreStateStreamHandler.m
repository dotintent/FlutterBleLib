#import "RestoreStateStreamHandler.h"

@implementation RestoreStateStreamHandler
{
    FlutterEventSink restoreStateSink;
}

- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    restoreStateSink = nil;
    return nil;
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)events {
    restoreStateSink = events;
    return nil;
}

- (void)onRestoreEvent:(id)restoreStateIdentifier {
    if (restoreStateSink != nil) {
        restoreStateSink(restoreStateIdentifier);
    }
}

@end
