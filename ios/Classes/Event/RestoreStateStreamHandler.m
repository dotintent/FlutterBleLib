#import "RestoreStateStreamHandler.h"

@implementation RestoreStateStreamHandler {
    FlutterEventSink restoreStateSink;
}

- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    @synchronized (self) {
        restoreStateSink = nil;
        return nil;
    }
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)events {
    @synchronized (self) {
        restoreStateSink = events;
        return nil;
    }
}

- (void)onRestoreEvent:(id)restoreStateIdentifier {
    @synchronized (self) {
        if (restoreStateSink != nil) {
            restoreStateSink(restoreStateIdentifier);
        }
    }
}

@end
